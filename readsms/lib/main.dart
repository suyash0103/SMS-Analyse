import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Read SMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Read SMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  int income = 0;
  int expend = 0;

  int credOrDet(String message) {
    String cred = "credited";
    String deb = "debited";

    for (int i = 0; i < message.length; i++) {
      int end = i + 8;
      if (i + 8 > message.length) end = message.length;
      String sub = message.substring(i, end);
      if (sub == cred) return 0;
      end = i + 7;
      if (i + 7 > message.length) end = message.length;
      sub = message.substring(i, end);
      if (sub == deb) return 1;
    }

    return -1;
  }

  int findCost(String message) {
    int value = 0;
    for (int i = 0; i < message.length; i++) {
      if (message[i] == 'R' &&
          i + 1 < message.length &&
          message[i + 1] == 's') {
        if (i + 2 < message.length && message[i + 2] == '.') {
          i += 3;
          int pos1 = i;
          while (i < message.length &&
              (message[i] == '0' ||
                  message[i] == '1' ||
                  message[i] == '2' ||
                  message[i] == '3' ||
                  message[i] == '4' ||
                  message[i] == '5' ||
                  message[i] == '6' ||
                  message[i] == '7' ||
                  message[i] == '8' ||
                  message[i] == '9')) {
            i++;
          }
          int pos2 = i;
          String sub = message.substring(pos1, pos2);
          // print("VVVVVVV" + sub);
          try {
            value = int.parse(sub);
          } on Exception {
            print("Exception");
          }

          break;
        } else if (i + 2 < message.length && message[i + 2] != '.') {
          // print("HERE");
          i = i + 2;
          int pos1 = i;
          while (i < message.length &&
              (message[i] == '0' ||
                  message[i] == '1' ||
                  message[i] == '2' ||
                  message[i] == '3' ||
                  message[i] == '4' ||
                  message[i] == '5' ||
                  message[i] == '6' ||
                  message[i] == '7' ||
                  message[i] == '8' ||
                  message[i] == '9')) {
            i++;
          }
          // print("HERE2" + pos1.toString() + " " + i.toString());
          int pos2 = i;
          String sub = message.substring(pos1, pos2);
          // print("VVVVVVV" + sub);
          try {
            value = int.parse(sub);
          } on Exception {
            print("Exception");
          }
          // value = int.parse(sub);
          break;
        }
      }
    }
    return value;
  }

  void fetchSMS() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;
    setState(() {
      for (var i = 0; i < messages.length; i++) {
        // income++;
        String message = messages[i].body;
        // print(message);
        int value = findCost(message);
        // print("AAAAAAAAA " + i.toString() + " " + value.toString());
        int cred = -1;
        if (value != 0) {
          cred = credOrDet(message);
        }
        // print("CCCCCCCCC " + cred.toString());
        if (cred == 0) {
          income += value;
        } else if (cred == 1) {
          expend += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Income: ',
                ),
                Text(
                  '$income',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Expenditure: ',
                ),
                Text(
                  '$expend',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            FlatButton(
              onPressed: fetchSMS,
              child: Text("Show Income and Expenditure"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
