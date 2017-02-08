From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 04/14] qla2xxx: Use IOCB interface to submit
 non-critical MBX.
Date: Wed, 8 Feb 2017 19:15:25 +0000
Message-ID: <C2BFB9E1-B258-4A11-AC83-B2AFB9BF8223@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
 <1486161655-2307-5-git-send-email-himanshu.madhani@cavium.com>
 <1486579669.16026.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0058.outbound.protection.outlook.com ([104.47.37.58]:54739
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752253AbdBHTRt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Feb 2017 14:17:49 -0500
In-Reply-To: <1486579669.16026.14.camel@sandisk.com>
Content-Language: en-US
Content-ID: <EEFBF7CBBB7D2544B1EE35F375476CCE@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>

DQpPbiAyLzgvMTcsIDEwOjQ4IEFNLCAiQmFydCBWYW4gQXNzY2hlIiA8QmFydC5WYW5Bc3NjaGVA
c2FuZGlzay5jb20+IHdyb3RlOg0KDQo+T24gRnJpLCAyMDE3LTAyLTAzIGF0IDE0OjQwIC0wODAw
LCBIaW1hbnNodSBNYWRoYW5pIHdyb3RlOg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9tYnguYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9tYnguYw0KPj4gaW5k
ZXggZGI2YmQ5Mi4uNDIyNTI1NiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9tYnguYw0KPj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21ieC5jDQo+PiBA
QCAtMTAsNiArMTAsMjkgQEANCj4+ICAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCj4+ICAjaW5j
bHVkZSA8bGludXgvZ2ZwLmg+DQo+PiAgDQo+PiArc3RhdGljIHN0cnVjdCBtYl9jbWRfbmFtZSB7
DQo+PiArCXVpbnQxNl90IGNtZDsNCj4+ICsJY2hhciAqc3RyOw0KPj4gK30gbWJfc3RyW10gPSB7
DQo+PiArCXsweGZmZmYsCQkidW5rbm93biJ9LA0KPj4gKwl7TUJDX0dFVF9QT1JUX0RBVEFCQVNF
LAkiR1BEQiJ9LA0KPj4gKwl7TUJDX0dFVF9JRF9MSVNULAkiR0lETGlzdCJ9LA0KPj4gKwl7TUJD
X0dFVF9MSU5LX1BSSVZfU1RBVFMsICJTdGF0cyJ9LA0KPj4gK307DQo+PiArDQo+PiArc3RhdGlj
IGNoYXIgKm1iX3RvX3N0cih1aW50MTZfdCBjbWQpDQo+PiArew0KPj4gKwlpbnQgaTsNCj4+ICsJ
c3RydWN0IG1iX2NtZF9uYW1lICplOw0KPj4gKw0KPj4gKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlf
U0laRShtYl9zdHIpOyBpKyspIHsNCj4+ICsJCWUgPSBtYl9zdHIgKyBpOw0KPj4gKwkJaWYgKGNt
ZCA9PSBlLT5jbWQpDQo+PiArCQkJcmV0dXJuIGUtPnN0cjsNCj4+ICsJfQ0KPj4gKwlyZXR1cm4g
bWJfc3RyWzBdLnN0cjsgLyogdW5rbm93biAqLw0KPj4gK30NCj4NCj5QbGVhc2UgdXNlIGNvbnN0
IGNoYXIgKiBpbnN0ZWFkIG9mIGNoYXIgKiBpbiB0aGUgc3RydWN0IGRlZmluaXRpb24gYW5kIGZv
cg0KPnRoZSBtYl90b19zdHIoKSBmdW5jdGlvbiByZXR1cm4gdHlwZS4gUGxlYXNlIGFsc28gbGVh
dmUgb3V0IHRoZSBlbGVtZW50IHdpdGgNCj5pbmRleCAweGZmZmYgZnJvbSB0aGUgbWJfc3RyW10g
YXJyYXkgYW5kIG1ha2UgbWJfdG9fc3RyKCkgcmV0dXJuICJ1bmtub3duIg0KPmluc3RlYWQgb2Yg
bWJfc3RyWzBdLnN0ciBpZiBsb29rdXAgZmFpbHMuDQoNCldpbGwgdXBkYXRlIHBhdGNoIGFuZCBy
ZXNlbmQuIA0KDQo+DQo+QmFydC4NCj5XZXN0ZXJuIERpZ2l0YWwgQ29ycG9yYXRpb24gKGFuZCBp
dHMgc3Vic2lkaWFyaWVzKSBFLW1haWwgQ29uZmlkZW50aWFsaXR5IE5vdGljZSAmIERpc2NsYWlt
ZXI6DQo+DQo+VGhpcyBlLW1haWwgYW5kIGFueSBmaWxlcyB0cmFuc21pdHRlZCB3aXRoIGl0IG1h
eSBjb250YWluIGNvbmZpZGVudGlhbCBvciBsZWdhbGx5IHByaXZpbGVnZWQgaW5mb3JtYXRpb24g
b2YgV0RDIGFuZC9vciBpdHMgYWZmaWxpYXRlcywgYW5kIGFyZSBpbnRlbmRlZCBzb2xlbHkgZm9y
IHRoZSB1c2Ugb2YgdGhlIGluZGl2aWR1YWwgb3IgZW50aXR5IHRvIHdoaWNoIHRoZXkgYXJlIGFk
ZHJlc3NlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgYW55IGRpc2Ns
b3N1cmUsIGNvcHlpbmcsIGRpc3RyaWJ1dGlvbiBvciBhbnkgYWN0aW9uIHRha2VuIG9yIG9taXR0
ZWQgdG8gYmUgdGFrZW4gaW4gcmVsaWFuY2Ugb24gaXQsIGlzIHByb2hpYml0ZWQuIElmIHlvdSBo
YXZlIHJlY2VpdmVkIHRoaXMgZS1tYWlsIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5k
ZXIgaW1tZWRpYXRlbHkgYW5kIGRlbGV0ZSB0aGUgZS1tYWlsIGluIGl0cyBlbnRpcmV0eSBmcm9t
IHlvdXIgc3lzdGVtLg0KPg0K
