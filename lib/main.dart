import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allUser = [];

  Future getAllUser() async {
    try {
      var response = await http.get(Uri.parse("https://reqres.in/api/users"));
      List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
      data.forEach((element) {
        allUser.add(element);
      });
    } catch (e) {
      print("something wrong");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Future Builder"),
      ),
      body: Center(
        child: FutureBuilder(
            future: getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("LOADING 🟢🟡🔴"),
                );
              }
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    backgroundImage: NetworkImage(allUser[index]["avatar"]),
                  ),
                  title: Text(
                      "${allUser[index]["first_name"]} ${allUser[index]["last_name"]}"),
                  subtitle: Text("${allUser[index]["email"]}"),
                ),
              );
            }),
      ),
    );
  }
}
