From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Mon, 23 Aug 2004 10:41:33 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408230141.AA03503@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE6A9E@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;	boundary="--------------------5778921486282513"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37299 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S265805AbUHWBlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 21:41:31 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i7N1fTJB030656 for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 10:41:29 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s7.gw.fujitsu.co.jp by m3.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i7N1fT0B021997 for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 10:41:29 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s7.gw.fujitsu.co.jp (8.12.11)
	id i7N1fTtr031855 for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 10:41:29 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan502-0.fjmail.jp.fujitsu.com [10.59.80.122])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I2V00K3LM14RM@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Aug 2004 10:41:28 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E5704DE6A9E@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

This is multipart message.

----------------------5778921486282513
Content-Type: text/plain; charset=us-ascii

Hi Eric,

I took a message according to your request.
Please look at the message and comment me.

Masao Fukuchi

Moore, Eric Dean wrote:
>Would it be possible for you to set up remote system 
>to send kernel messages over serial cable?
>Is so, pls recompile the driver with MPT_DEBUG_TM defined in
>the mpt device driver Makefile; then send me log file.
>
>Thanks,
>Eric
>
>On Thursday, August 19, 2004 9:05 PM, Masao Fukuchi wrote:
>> 
>> 
>> Eric,
>> 
>> I applyed your patch and tested it, but the patch didn't work well.
>> I didn't met Oops. 
>> But after read command finishing with fail, keyboard and mouse click 
>> didn't work.
>> And also I couldn't login from other server.
>> 
>> The message was almost same as Fusion MPT driver 3.01.15.
>> 
>> Masao Fukuchi
>> 
>> Moore, Eric Dean wrote:
>> >Here is a patch to apply against 3.01.15. It will have a small
>> >fix in mptscsih_abort which should work with Christoph's suggestion
>> >of removing the "is the device is offline" check in 
>> >mptscsih_flush_running_cmds.  Pls test and let me know if you still 
>> >hit the oops.
>> >
>> >Eric
>> >
>> >
>> >On Thursday, August 19, 2004 7:15 AM, Masao Fukuchi wrote:
>> >> 
>> >> I tried fusion MPT driver 3.01.15 and I didn't met Oops.
>> >> (Eric fixed Oops problem by Fusion MPT driver 3.01.04)
>> >> 
>> >> Masao Fukuchi
>> >> 
>> >> Message:
>> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> >> (sc=e00000007c205080)
>> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting target reset! 
>> >> (sc=e00000007c205080)
>> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting bus reset! 
>> >> (sc=e00000007c205080)
>> >>  18:19:03 kernel: mptbase: Initiating ioc3 recovery
>> >>  18:19:28 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> >> (sc=e00000007c205080)
>> >>  18:19:28 kernel: mptscsih: ioc3: >> Attempting host reset! 
>> >> (sc=e00000007c205080)
>> >>  18:19:28 kernel: mptbase: Initiating ioc3 recovery
>> >>  18:19:52 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> >> (sc=e00000007c205080)
>> >>  18:19:52 kernel: scsi: Device offlined - not ready after 
>> >> error recovery: host 3 channel 0 id 1 lun 0
>> >>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 2
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 3
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 4
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 5
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 6
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 7
>> >>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>> >>  18:19:54 kernel: mptbase: Initiating ioc3 recovery
>> >> 
>> >> 
>> >> Christoph Hellwig wrote:
>> >> >On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
>> >> >> Hi Christoph,
>> >> >> 
>> >> >> I applyed attached patch into latest fusion MPT 
>> driver(3.01.15) and
>> >> >> tested it, but I still met Oops.
>> >> >> Then I also applyed your latest patch(it gets rid of the 
>> >> fusion pendingQ
>> >> >> in favour of using the scsi midlayer queuing), but I met 
>> >> Oops again.
>> >> >
>> >> >Can you try the patch Eric posted instead?
>> >> >
>> >> >-
>> >> >To unsubscribe from this list: send the line "unsubscribe 
>> >> linux-scsi" in
>> >> >the body of a message to majordomo@vger.kernel.org
>> >> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> 
>> >
>> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

----------------------5778921486282513
Content-Type: application/octet-stream;
	name="tmo_oops"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="tmo_oops"

bXB0c2NzaWg6IGlvYzM6ID4+IEF0dGVtcHRpbmcgdGFzayBhYm9ydCEgKHNjPWUwMDAwMDAw
N2MxYTY4ODApClRNX1JFUVVFU1Q6CjAxMDAwMDAxIDAwMDAwMTAwIDAwMGQwMDYyIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIAowMDAwMDAwMCAwMDAw
MDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAKbXB0c2NzaWg6IGlvYzM6IG1wdHNjc2loX3Rhc2tt
Z210X3RpbWVvdXQ6IFRNIHJlcXVlc3QgdGltZWQgb3V0IQptcHRzY3NpaDogSU9DIHNldHVw
X3Jlc2V0IHJvdXRlZCB0byBTQ1NJIGhvc3QgZHJpdmVyIQptcHRzY3NpaDogaW9jMzogV0FS
TklORyAtIFNldHVwLURpYWcgUmVzZXQKbXB0c2NzaWg6IElPQyBzZXR1cF9yZXNldCByb3V0
ZWQgdG8gU0NTSSBob3N0IGRyaXZlciEKbXB0c2NzaWg6IGlvYzI6IFdBUk5JTkcgLSBTZXR1
cC1EaWFnIFJlc2V0Cm1wdHNjc2loOiBJT0MgcHJlX3Jlc2V0IHJvdXRlZCB0byBTQ1NJIGhv
c3QgZHJpdmVyIQptcHRzY3NpaDogaW9jMzogV0FSTklORyAtIFByZS1EaWFnIFJlc2V0Cm1w
dHNjc2loOiBpb2MzOiBXQVJOSU5HIC0gUHJlLVJlc2V0IGNvbXBsZXRlLgptcHRzY3NpaDog
SU9DIHByZV9yZXNldCByb3V0ZWQgdG8gU0NTSSBob3N0IGRyaXZlciEKbXB0c2NzaWg6IGlv
YzI6IFdBUk5JTkcgLSBQcmUtRGlhZyBSZXNldAptcHRzY3NpaDogaW9jMjogV0FSTklORyAt
IFByZS1SZXNldCBjb21wbGV0ZS4KbXB0c2NzaWg6IGlvYzM6ID4+IEF0dGVtcHRpbmcgYnVz
IHJlc2V0ISAoc2M9ZTAwMDAwMDA3YzFhNjg4MCkKbXB0c2NzaWg6IElPQyBwb3N0X3Jlc2V0
IHJvdXRlZCB0byBTQ1NJIGhvc3QgZHJpdmVyIQptcHRzY3NpaDogaW9jMzogV0FSTklORyAt
IFBvc3QtRGlhZyBSZXNldAptcHRzY3NpaDogaW9jMzogV0FSTklORyAtIFBvc3QtUmVzZXQg
Y29tcGxldGUuCm1wdHNjc2loOiBJT0MgcG9zdF9yZXNldCByb3V0ZWQgdG8gU0NTSSBob3N0
IGRyaXZlciEKbXB0c2NzaWg6IGlvYzI6IFdBUk5JTkcgLSBQb3N0LURpYWcgUmVzZXQKbXB0
c2NzaWg6IGlvYzI6IFdBUk5JTkcgLSBQb3N0LVJlc2V0IGNvbXBsZXRlLgptcHRzY3NpaDog
aW9jMzogbXB0c2NzaWhfdGFza21nbXRfdGltZW91dAptcHRzY3NpaDogaW9jMzogPj4gQXR0
ZW1wdGluZyB0YXNrIGFib3J0ISAoc2M9ZTAwMDAwMDA3YzFhNjg4MCkKVE1fUkVRVUVTVDoK
MDEwMDAwMDEgMDAwMDAxMDAgMDAwZDAwNzcgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAgCjAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IAptcHRzY3NpaDogaW9jMzogPj4gQXR0ZW1wdGluZyBob3N0IHJlc2V0ISAoc2M9ZTAwMDAw
MDA3YzFhNjg4MCkKbXB0c2NzaWg6IElPQyBzZXR1cF9yZXNldCByb3V0ZWQgdG8gU0NTSSBo
b3N0IGRyaXZlciEKbXB0c2NzaWg6IGlvYzM6IFdBUk5JTkcgLSBTZXR1cC1EaWFnIFJlc2V0
Cm1wdHNjc2loOiBJT0Mgc2V0dXBfcmVzZXQgcm91dGVkIHRvIFNDU0kgaG9zdCBkcml2ZXIh
Cm1wdHNjc2loOiBpb2MyOiBXQVJOSU5HIC0gU2V0dXAtRGlhZyBSZXNldAptcHRzY3NpaDog
SU9DIHByZV9yZXNldCByb3V0ZWQgdG8gU0NTSSBob3N0IGRyaXZlciEKbXB0c2NzaWg6IGlv
YzM6IFdBUk5JTkcgLSBQcmUtRGlhZyBSZXNldAptcHRzY3NpaDogaW9jMzogV0FSTklORyAt
IFByZS1SZXNldCBjb21wbGV0ZS4KbXB0c2NzaWg6IElPQyBwcmVfcmVzZXQgcm91dGVkIHRv
IFNDU0kgaG9zdCBkcml2ZXIhCm1wdHNjc2loOiBpb2MyOiBXQVJOSU5HIC0gUHJlLURpYWcg
UmVzZXQKbXB0c2NzaWg6IGlvYzI6IFdBUk5JTkcgLSBQcmUtUmVzZXQgY29tcGxldGUuCm1w
dHNjc2loOiBJT0MgcG9zdF9yZXNldCByb3V0ZWQgdG8gU0NTSSBob3N0IGRyaXZlciEKbXB0
c2NzaWg6IGlvYzM6IFdBUk5JTkcgLSBQb3N0LURpYWcgUmVzZXQKbXB0c2NzaWg6IGlvYzM6
IFdBUk5JTkcgLSBQb3N0LVJlc2V0IGNvbXBsZXRlLgptcHRzY3NpaDogSU9DIHBvc3RfcmVz
ZXQgcm91dGVkIHRvIFNDU0kgaG9zdCBkcml2ZXIhCm1wdHNjc2loOiBpb2MyOiBXQVJOSU5H
IC0gUG9zdC1EaWFnIFJlc2V0Cm1wdHNjc2loOiBpb2MyOiBXQVJOSU5HIC0gUG9zdC1SZXNl
dCBjb21wbGV0ZS4KbXB0c2NzaWg6IG1wdHNjc2loX2hvc3RfcmVzZXQ6IFN0YXR1cyA9IFNV
Q0NFU1MKbXB0c2NzaWg6IGlvYzM6ID4+IEF0dGVtcHRpbmcgdGFzayBhYm9ydCEgKHNjPWUw
MDAwMDAwN2MxYTY4ODApClRNX1JFUVVFU1Q6CjAxMDAwMDAxIDAwMDAwMTAwIDAwMGQwMDhi
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIAowMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAKc2NzaTMgKDE6MCk6IHJlamVjdGluZyBJ
L08gdG8gb2ZmbGluZSBkZXZpY2UKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBs
b2dpY2FsIGJsb2NrIDAKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2Fs
IGJsb2NrIDEKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2Nr
IDIKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2NrIDMKQnVm
ZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2NrIDQKQnVmZmVyIEkv
TyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2NrIDUKQnVmZmVyIEkvTyBlcnJv
ciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2NrIDYKQnVmZmVyIEkvTyBlcnJvciBvbiBk
ZXZpY2Ugc2RiLCBsb2dpY2FsIGJsb2NrIDcKc2NzaTMgKDE6MCk6IHJlamVjdGluZyBJL08g
dG8gb2ZmbGluZSBkZXZpY2UKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dp
Y2FsIGJsb2NrIDAKQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2Ugc2RiLCBsb2dpY2FsIGJs
b2NrIDEKbXB0c2NzaWg6IGlvYzM6IG1wdHNjc2loX3Rhc2ttZ210X3RpbWVvdXQ6IFRNIHJl
cXVlc3QgdGltZWQgb3V0IQptcHRzY3NpaDogSU9DIHNldHVwX3Jlc2V0IHJvdXRlZCB0byBT
Q1NJIGhvc3QgZHJpdmVyIQptcHRzY3NpaDogaW9jMzogV0FSTklORyAtIFNldHVwLURpYWcg
UmVzZXQKbXB0c2NzaWg6IElPQyBzZXR1cF9yZXNldCByb3V0ZWQgdG8gU0NTSSBob3N0IGRy
aXZlciEKbXB0c2NzaWg6IGlvYzI6IFdBUk5JTkcgLSBTZXR1cC1EaWFnIFJlc2V0Cm1wdHNj
c2loOiBJT0MgcHJlX3Jlc2V0IHJvdXRlZCB0byBTQ1NJIGhvc3QgZHJpdmVyIQptcHRzY3Np
aDogaW9jMzogV0FSTklORyAtIFByZS1EaWFnIFJlc2V0ClVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSAoYWRkcmVzcyAwMDAwMDAwMDAwMDAwMDAw
KQpldmVudHMvMFs0XTogT29wcyA4ODEzMjcyODkxMzkyIFsxXQpNb2R1bGVzIGxpbmtlZCBp
bjogaWRlX2NkIGNkcm9tIG1kNSBpcHY2IGJ1dHRvbiBhdXRvZnMgb2hjaTEzOTQgaWVlZTEz
OTQgZTEwMDAgbg0KbHNfaXNvODg1OV8xIG5sc19jcDQzNyB2ZmF0IGZhdCBtcHRzY3NpaCBt
cHRiYXNlIHNkX21vZCBzY3NpX21vZAoNClBpZDogNCwgQ1BVIDAsIGNvbW06ICAgICAgICAg
ICAgIGV2ZW50cy8wCnBzciA6IDAwMDAxMDEwMDgwMjYwMTggaWZzIDogODAwMDAwMDAwMDAw
MDUwZSBpcCAgOiBbPGEwMDAwMDAxMDAyM2FjYTA+XSAgICBUYWluDQp0ZWQ6IEdGIAppcCBp
cyBhdCBzd2lvdGxiX3VubWFwX3NnKzB4YTAvMHgyMjAKdW5hdDogMDAwMDAwMDAwMDAwMDAw
MCBwZnMgOiAwMDAwMDAwMDAwMDAwODE0IHJzYyA6IDAwMDAwMDAwMDAwMDAwMDMKcm5hdDog
ZTAwMDAwMDA3Zjk0N2Q2MCBic3BzOiBlMDAwMDAwMDdmOTQwMDAwIHByICA6IDAwMDAwMDAw
MDU2YWFhNTUKbGRyczogMDAwMDAwMDAwMDAwMDAwMCBjY3YgOiAwMDAwMDAwMDAwMDAwMDAw
IGZwc3I6IDAwMDk4MDRjOGE3MDQzM2YKY3NkIDogMDAwMDAwMDAwMDAwMDAwMCBzc2QgOiAw
MDAwMDAwMDAwMDAwMDAwCmIwICA6IGEwMDAwMDAyMDAwYmQ3OTAgYjYgIDogYTAwMDAwMDEw
MDIzOGQwMCBiNyAgOiBhMDAwMDAwMTAwMjNhYzAwCmY2ICA6IDEwMDNlMDAwMDAwMDAwMDAw
MDA4OCBmNyAgOiAwZmZlOGJiNGVlOWU0MDAwMDAwMDAKZjggIDogMTAwM2UwMDAwMDAwMDAw
MDAzMzAwIGY5ICA6IDEwMDNlMDAwMDAwMDAwMDAwMDA2MApmMTAgOiAxMDAzZTAwMDAwMDAw
MGVhMDAwMDAgZjExIDogMTAwM2UwMDAwMDAwMDM2N2I3YWQwCnIxICA6IGEwMDAwMDAxMDA5
ZDdlMjAgcjIgIDogZTAwMDAwMDA3Zjk0N2RhMCByMyAgOiBhMDAwMDAwMjAwMGQwOTAwCnI4
ICA6IDAwMDAwMDAwMDAwMDAwODggcjkgIDogYTAwMDAwMDEwMDgwMzhjMCByMTAgOiA2ZGI2
ZGI2ZGI2ZGI2ZGI3CnIxMSA6IGUwMDAwMDAwN2MxNDIwMDAgcjEyIDogZTAwMDAwMDA3Zjk0
N2Q5MCByMTMgOiBlMDAwMDAwMDdmOTQwMDAwCnIxNCA6IGEwMDA3ZmZmZmY5MDAwMDAgcjE1
IDogMDAwMDAwMDAwMDAwMzMwMCByMTYgOiBhMDAwMDAwMTAwN2VmZjA4CnIxNyA6IDAwMDAw
MDAwMDAwMDAwMTAgcjE4IDogZTAwMDAwMDA3YzFhNjk1OCByMTkgOiBhMDAwMDAwMTAwMjNh
YzAwCnIyMCA6IGEwMDAwMDAxMDA2NTkyZDggcjIxIDogMDAwMDAwMDAwMDAwMDAwMCByMjIg
OiBlMDAwMDAwMDdmNzY4ZTk0CnIyMyA6IDAwMDAwMDAwMDAwMDAwMDAgcjI0IDogYTAwMDAw
MDEwMDdmMjVlOCByMjUgOiAwMDAwMDAxMDA4MDIyMDE4CnIyNiA6IDAwMDAwMDAwMDAwMDAw
MDEgcjI3IDogMDAwMDAwMDAwMDAwMDAwMCByMjggOiBhMDAwMDAwMTAwMDg2YzMwCnIyOSA6
IGEwMDAwMDAxMDAyNDE3NjAgcjMwIDogMDAwMDAwMDAwMDAwMDAwMCByMzEgOiBlMDAwMDAw
MDAxMDA0NWI4Cg0KQ2FsbCBUcmFjZToKIFs8YTAwMDAwMDEwMDAxOWJhMD5dIHNob3dfc3Rh
Y2srMHg4MC8weGEwCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAwMDAw
MDA3Zjk0Nzk2MCBic3A9ZTAwMDAwMDA3Zjk0MTQxMAogWzxhMDAwMDAwMTAwMDNmZWQwPl0g
ZGllKzB4MWQwLzB4MjgwCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAw
MDAwMDA3Zjk0N2IzMCBic3A9ZTAwMDAwMDA3Zjk0MTNlMAogWzxhMDAwMDAwMTAwMDVmMjYw
Pl0gaWE2NF9kb19wYWdlX2ZhdWx0KzB4MzgwLzB4OTgwCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc3A9ZTAwMDAwMDA3Zjk0N2IzMCBic3A9ZTAwMDAwMDA3Zjk0MTM4MAog
WzxhMDAwMDAwMTAwMDEyMzQwPl0gaWE2NF9sZWF2ZV9rZXJuZWwrMHgwLzB4MjYwCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAwMDAwMDA3Zjk0N2JjMCBic3A9ZTAw
MDAwMDA3Zjk0MTM4MAogWzxhMDAwMDAwMTAwMjNhY2EwPl0gc3dpb3RsYl91bm1hcF9zZysw
eGEwLzB4MjIwCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAwMDAwMDA3
Zjk0N2Q5MCBic3A9ZTAwMDAwMDA3Zjk0MTMxMAogWzxhMDAwMDAwMjAwMGJkNzkwPl0gbXB0
c2NzaWhfZmx1c2hfcnVubmluZ19jbWRzKzB4MTcwLzB4MzIwIFttcHRzY3NpaF0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBzcD1lMDAwMDAwMDdmOTQ3ZGEwIGJzcD1lMDAw
MDAwMDdmOTQxMjkwCiBbPGEwMDAwMDAyMDAwYzJhYzA+XSBtcHRzY3NpaF9pb2NfcmVzZXQr
MHgxMjAvMHg1NjAgW21wdHNjc2loXQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHNwPWUwMDAwMDAwN2Y5NDdkYTAgYnNwPWUwMDAwMDAwN2Y5NDEyNTAKIFs8YTAwMDAwMDIw
MDBhNDJlMD5dIG1wdF9kaWFnX3Jlc2V0KzB4ZDIwLzB4ZTAwIFttcHRiYXNlXQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHNwPWUwMDAwMDAwN2Y5NDdkYTAgYnNwPWUwMDAw
MDAwN2Y5NDExYjAKIFs8YTAwMDAwMDIwMDBhMzIyMD5dIEtpY2tTdGFydCsweDYwLzB4NDAw
IFttcHRiYXNlXQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwPWUwMDAwMDAw
N2Y5NDdkYTAgYnNwPWUwMDAwMDAwN2Y5NDExNDgKIFs8YTAwMDAwMDIwMDBhMTAyMD5dIE1h
a2VJb2NSZWFkeSsweDFhMC8weDY2MCBbbXB0YmFzZV0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzcD1lMDAwMDAwMDdmOTQ3ZGEwIGJzcD1lMDAwMDAwMDdmOTQxMGM4CiBb
PGEwMDAwMDAyMDAwOWY4NjA+XSBtcHRfZG9faW9jX3JlY292ZXJ5KzB4MTQwLzB4YmMwIFtt
cHRiYXNlXQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwPWUwMDAwMDAwN2Y5
NDdkYjAgYnNwPWUwMDAwMDAwN2Y5NDEwNTAKIFs8YTAwMDAwMDIwMDBhYTlhMD5dIG1wdF9I
YXJkUmVzZXRIYW5kbGVyKzB4MjYwLzB4NGEwIFttcHRiYXNlXQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHNwPWUwMDAwMDAwN2Y5NDdkYjAgYnNwPWUwMDAwMDAwN2Y5NDBm
ZTAKIFs8YTAwMDAwMDIwMDBjNGM5MD5dIG1wdHNjc2loX3NjaGVkdWxlX3Jlc2V0KzB4MzAv
MHhlMCBbbXB0c2NzaWhdCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAw
MDAwMDA3Zjk0N2RiMCBic3A9ZTAwMDAwMDA3Zjk0MGZjMAogWzxhMDAwMDAwMTAwMGJlNjUw
Pl0gd29ya2VyX3RocmVhZCsweDQxMC8weDVlMAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNwPWUwMDAwMDAwN2Y5NDdkYjAgYnNwPWUwMDAwMDAwN2Y5NDBmMjgKIFs8YTAw
MDAwMDEwMDBjN2IwMD5dIGt0aHJlYWQrMHgxODAvMHgxYTAKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzcD1lMDAwMDAwMDdmOTQ3ZTIwIGJzcD1lMDAwMDAwMDdmOTQwZWY4
CiBbPGEwMDAwMDAxMDAwMWJiMDA+XSBrZXJuZWxfdGhyZWFkX2hlbHBlcisweGUwLzB4MTAw
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3A9ZTAwMDAwMDA3Zjk0N2UzMCBi
c3A9ZTAwMDAwMDA3Zjk0MGVkMAogWzxhMDAwMDAwMTAwMDA5MDgwPl0gc3RhcnRfa2VybmVs
X3RocmVhZCsweDIwLzB4NDAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzcD1l
MDAwMDAwMDdmOTQ3ZTMwIGJzcD1lMDAwMDAwMDdmOTQwZWQwCiA=

----------------------5778921486282513--
