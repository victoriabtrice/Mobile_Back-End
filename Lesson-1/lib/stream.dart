import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}


class _StreamWidgetState extends State<StreamWidget> {

  int percent = 100;
  int getSteam = 0;
  double circular = 1;

  late StreamSubscription _sub;

  final Stream _myStream = Stream.periodic(const Duration(seconds: 1), (int count){
    return count;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream')),
      body: Center(child: LayoutBuilder(builder: (context, constraints){
        final double avaWidth = constraints.maxWidth;
        final double avaHeight = constraints.maxHeight;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CircularPercentIndicator(
                radius: avaHeight / 5,
                lineWidth: 10,
                percent: circular,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$percent %'),
                    if(percent == 100) const Text('Full')
                    else if (percent == 0) const Text('Empty') 
                    else Container()
                  ],
                ),
              ),
            )
          ],
        );
      },)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sub = _myStream.listen((event) {
            getSteam = int.parse(event.toString());
            setState(() {
              if(percent - getSteam <= 0){
                _sub.cancel();
                percent = 0;
                circular = 0;
              } else {
                percent = percent - getSteam;
                circular = percent / 100;
              }
            });
          });
        },
        child: Text('Play'),
      ),
    );
  }
}
