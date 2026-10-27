import 'package:flutter/material.dart';

/// A fully local mock conversation for previewing chat UI without contacting anyone.
class DeveloperChatPreviewScreen extends StatefulWidget {
  const DeveloperChatPreviewScreen({super.key});

  @override
  State<DeveloperChatPreviewScreen> createState() => _DeveloperChatPreviewScreenState();
}

class _DeveloperChatPreviewScreenState extends State<DeveloperChatPreviewScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_PreviewMessage> _messages = [
    _PreviewMessage('السلام عليكم 👋', false, '10:24 ص'),
    _PreviewMessage('وعليكم السلام، أهلًا بك في بلوساب 🌿', true, '10:24 ص'),
    _PreviewMessage('هذه محادثة تجريبية لمعاينة شكل الرسائل.', false, '10:25 ص'),
    _PreviewMessage('يمكنك تجربة إرسال رسالة من الأسفل، ولن تُرسل لأي شخص.', true, '10:25 ص'),
    _PreviewMessage('كيف تبدو الصور والملفات في الواجهة؟ 📎', false, '10:26 ص'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_PreviewMessage(text, true, TimeOfDay.now().format(context)));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF128C7E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Row(children: [
          const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: green)),
          const SizedBox(width: 10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('محادثة تجريبية', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('معاينة للمطور فقط', style: TextStyle(fontSize: 12)),
          ])),
          IconButton(onPressed: () => _showInfo(context), icon: const Icon(Icons.info_outline)),
        ]),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFEAF2EE)),
        child: Column(children: [
          Container(width: double.infinity, margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(10)),
            child: const Text('وضع تجريبي: الرسائل هنا محلية ولا تصل إلى أي مستخدم.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF765B13)))),
          Expanded(child: ListView.builder(controller: _scroll, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), itemCount: _messages.length,
            itemBuilder: (context, index) {
              final m = _messages[index];
              return Align(alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78),
                margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.fromLTRB(12, 9, 9, 5),
                decoration: BoxDecoration(color: m.mine ? const Color(0xFFD7F8C6) : Colors.white, borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(13), topRight: const Radius.circular(13),
                  bottomLeft: Radius.circular(m.mine ? 13 : 3), bottomRight: Radius.circular(m.mine ? 3 : 13)), boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 2)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Align(alignment: Alignment.centerRight, child: Text(m.text, style: const TextStyle(fontSize: 16, color: Color(0xFF202124)))),
                  const SizedBox(height: 3), Row(mainAxisSize: MainAxisSize.min, children: [Text(m.time, style: const TextStyle(fontSize: 10, color: Colors.black54)), if (m.mine) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.done_all, size: 14, color: Colors.blue))]),
                ]),
              ));
            })),
          SafeArea(top: false, child: Container(color: const Color(0xFFF7F7F7), padding: const EdgeInsets.fromLTRB(8, 7, 8, 7), child: Row(children: [
            IconButton(onPressed: () => _showAttachmentInfo(context), icon: const Icon(Icons.attach_file, color: green)),
            Expanded(child: TextField(controller: _controller, minLines: 1, maxLines: 4, onSubmitted: (_) => _send(), decoration: InputDecoration(hintText: 'اكتب رسالة تجريبية', filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none)))),
            const SizedBox(width: 6), CircleAvatar(backgroundColor: green, child: IconButton(onPressed: _send, icon: const Icon(Icons.send, color: Colors.white, size: 19))),
          ]))),
        ]),
      ),
    );
  }

  void _showInfo(BuildContext context) => showDialog<void>(context: context, builder: (c) => AlertDialog(title: const Text('محادثة تجريبية'), content: const Text('هذه واجهة وهمية لمعاينة تصميم المحادثة. لا يوجد اتصال شبكي ولا يتم إرسال الرسائل خارج هذه الشاشة.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('حسنًا'))]));
  void _showAttachmentInfo(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('المرفقات غير مفعّلة في وضع المعاينة التجريبي.')));
}

class _PreviewMessage {
  final String text;
  final bool mine;
  final String time;
  const _PreviewMessage(this.text, this.mine, this.time);
}
