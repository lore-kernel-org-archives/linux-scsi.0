From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Sun, 29 Jan 2017 17:14:37 +0000
Message-ID: <1485710063.16362.1.camel@sandisk.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
         <20170123163446.9227-2-bart.vanassche@sandisk.com>
         <1485359225.3093.3.camel@sandisk.com> <20170126143614.GA19849@lst.de>
         <1485667034.15853.1.camel@sandisk.com> <20170129090736.GA10369@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0071.outbound.protection.outlook.com ([104.47.32.71]:61177
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751848AbdA2ROr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Jan 2017 12:14:47 -0500
In-Reply-To: <20170129090736.GA10369@lst.de>
Content-Language: en-US
Content-ID: <540A33901703404FB0E67457FFC362E1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gU3VuLCAyMDE3LTAxLTI5IGF0IDEwOjA3ICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBI
aSBCYXJ0LA0KPiANCj4gdGhhbmtzIGZvciB0aGUgYW5hbHlzaXMuICBJIHRoaW5rIHRoZSBtYWlu
IGlzc3VlIGhlcmUgaXMgdGhhdCB3ZSBzaG91bGRuJ3QNCj4gdHJ5IHRvIGFzc2lnbiBhZmZpbml0
eSBtYXNrcyBpZiB0aGVyZSBhcmUgbm90IGFmZmluaXR5IHZlY3RvcnMgbGVmdCB0bw0KPiBhc3Np
Z24uDQo+IA0KPiBEb2VzIHRoZSBwYXRjaCBiZWxvdyBmaXggdGhlIGlzc3VlIGZvciB5b3U/DQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvbXNpLmMgYi9kcml2ZXJzL3BjaS9tc2kuYw0K
PiBpbmRleCA1MGM1MDAzLi45NmMwNzEzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3BjaS9tc2ku
Yw0KPiArKysgYi9kcml2ZXJzL3BjaS9tc2kuYw0KPiBAQCAtMTIwNiw2ICsxMjA2LDExIEBAIGlu
dCBwY2lfYWxsb2NfaXJxX3ZlY3RvcnNfYWZmaW5pdHkoc3RydWN0IHBjaV9kZXYgKmRldiwgdW5z
aWduZWQgaW50IG1pbl92ZWNzLA0KPiAgCWlmIChmbGFncyAmIFBDSV9JUlFfQUZGSU5JVFkpIHsN
Cj4gIAkJaWYgKCFhZmZkKQ0KPiAgCQkJYWZmZCA9ICZtc2lfZGVmYXVsdF9hZmZkOw0KPiArDQo+
ICsJCWlmIChhZmZkLT5wcmVfdmVjdG9ycyArIGFmZmQtPnBvc3RfdmVjdG9ycyA+IG1pbl92ZWNz
KQ0KPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJCWlmIChhZmZkLT5wcmVfdmVjdG9ycyArIGFm
ZmQtPnBvc3RfdmVjdG9ycyA9PSBtaW5fdmVjcykNCj4gKwkJCWZsYWdzICY9fiBQQ0lfSVJRX0FG
RklOSVRZOw0KPiAgCX0gZWxzZSB7DQo+ICAJCWlmIChXQVJOX09OKGFmZmQpKQ0KPiAgCQkJYWZm
ZCA9IE5VTEw7DQoNCkhlbGxvIENocmlzdG9waCwNCg0KVGhhbmtzIGZvciB0aGUgcXVpY2sgcmVw
bHkuIFNvcnJ5IGJ1dCB0aGUgYWJvdmUgcGF0Y2ggZGlkbid0IGhlbHAgLSB0aGUNClBDSV9JUlFf
QUZGSU5JVFkgaXNuJ3QgdGVzdGVkIGFmdGVyIHRoZSBhYm92ZSBjb2RlIGNsZWFycyBpdC4gQnV0
IGFmdGVyIEkNCmNoYW5nZWQgImZsYWdzICY9fiBQQ0lfSVJRX0FGRklOSVRZIiBpbnRvICJhZmZk
ID0gTlVMTCIgdGhlIG1lbW9yeQ0KY29ycnVwdGlvbiBjb21wbGFpbnQgd2FzIGdvbmUgYW5kIEkv
TyB0aHJvdWdoIHRoZSBxbGEyeHh4IGFkYXB0ZXINCndhcyBzdGlsbCB3b3JraW5nIGZpbmUuIElm
IHlvdSB3YW50IHlvdSBjYW4gYWRkIHRoZSBmb2xsb3dpbmcgdG8gdGhlIGFib3ZlDQpwYXRjaCB3
aXRoIHRoZSBhZm9yZW1lbnRpb25lZCBjaGFuZ2U6DQoNClRlc3RlZC1ieTogQmFydCBWYW4gQXNz
Y2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCg0KQmFydC4=
