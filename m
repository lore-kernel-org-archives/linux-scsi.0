From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V5 13/14] block: mq-deadline: Limit write request dispatch
 for zoned block devices
Date: Mon, 2 Oct 2017 04:38:01 +0000
Message-ID: <1506919078.24488.9.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-14-damien.lemoal@wdc.com>
         <1506377218.2641.37.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31923 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdJBEiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 00:38:04 -0400
In-Reply-To: <1506377218.2641.37.camel@wdc.com>
Content-Language: en-US
Content-ID: <E6CDCD7269F7474F9632A934D055602B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDIyOjA2ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIE1vbiwgMjAxNy0wOS0yNSBhdCAxNToxNCArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3Jv
dGU6DQo+ID4gLQlyZXR1cm4gcnFfZW50cnlfZmlmbyhkZC0+Zmlmb19saXN0W2RhdGFfZGlyXS5u
ZXh0KTsNCj4gPiArCWlmICghZGQtPnpvbmVzX3dsb2NrIHx8IGRhdGFfZGlyID09IFJFQUQpDQo+
ID4gKwkJcmV0dXJuIHJxX2VudHJ5X2ZpZm8oZGQtPmZpZm9fbGlzdFtkYXRhX2Rpcl0ubmV4dCk7
DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2NrX2lycXNhdmUoJmRkLT56b25lX2xvY2ssIGZsYWdzKTsN
Cj4gPiArDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHJxLCAmZGQtPmZpZm9fbGlzdFtXUklU
RV0sIHF1ZXVlbGlzdCkgew0KPiA+ICsJCWlmIChkZWFkbGluZV9jYW5fZGlzcGF0Y2hfcmVxdWVz
dChkZCwgcnEpKQ0KPiA+ICsJCQlnb3RvIG91dDsNCj4gPiArCX0NCj4gPiArCXJxID0gTlVMTDsN
Cj4gPiArDQo+ID4gK291dDoNCj4gPiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRkLT56b25l
X2xvY2ssIGZsYWdzKTsNCj4gDQo+IElzIGl0IGRvY3VtZW50ZWQgc29tZXdoZXJlIHdoYXQgZGQt
PnpvbmVfbG9jayBwcm90ZWN0cyBhbmQgd2hlbiB0aGF0IGxvY2sNCj4gc2hvdWxkIGJlDQo+IGFj
cXVpcmVkPw0KDQpJdCB3YXMgbm90IHdlbGwgZXhwbGFpbmVkLiBJIGFkZGVkIGNvbW1lbnRzIGlu
IFY2Lg0KDQo+IA0KPiA+IAkvKg0KPiA+ICAJICogVGhpcyBtYXkgYmUgYSByZXF1ZXVlIG9mIGEg
cmVxdWVzdCB0aGF0IGhhcyBsb2NrZWQgaXRzDQo+ID4gLQkgKiB0YXJnZXQgem9uZS4gSWYgdGhp
cyBpcyB0aGUgY2FzZSwgcmVsZWFzZSB0aGUgcmVxdWVzdCB6b25lDQo+ID4gbG9jay4NCj4gPiAr
CSAqIHRhcmdldCB6b25lLiBJZiB0aGlzIGlzIHRoZSBjYXNlLCByZWxlYXNlIHRoZSB6b25lIGxv
Y2suDQo+ID4gIAkgKi8NCj4gPiAgCWlmIChkZWFkbGluZV9yZXF1ZXN0X2hhc196b25lX3dsb2Nr
KHJxKSkNCj4gPiAgCQlkZWFkbGluZV93dW5sb2NrX3pvbmUoZGQsIHJxKTsNCj4gDQo+IENhbiB0
aGlzIGNoYW5nZSBiZSBmb2xkZWQgaW50byB0aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VkIHRoYXQg
Y29tbWVudD8NCg0KT2YgY291cnNlLiBGaXhlZCBpbiBWNi4NCg0KPiA+IEBAIC01NzAsNiArNjIx
LDkgQEAgc3RhdGljIHZvaWQgZGRfaW5zZXJ0X3JlcXVlc3Qoc3RydWN0IGJsa19tcV9od19jdHgN
Cj4gPiAqaGN0eCwgc3RydWN0IHJlcXVlc3QgKnJxLA0KPiA+ICANCj4gPiAgCWJsa19tcV9zY2hl
ZF9yZXF1ZXN0X2luc2VydGVkKHJxKTsNCj4gPiAgDQo+ID4gKwlpZiAoYXRfaGVhZCAmJiBkZWFk
bGluZV9yZXF1ZXN0X25lZWRzX3pvbmVfd2xvY2soZGQsIHJxKSkNCj4gPiArCQlwcl9pbmZvKCIj
IyMjIyMjIyBXcml0ZSBhdCBoZWFkICFcbiIpOw0KPiA+ICsNCj4gPiAgCWlmIChhdF9oZWFkIHx8
IGJsa19ycV9pc19wYXNzdGhyb3VnaChycSkpIHsNCj4gPiAgCQlpZiAoYXRfaGVhZCkNCj4gPiAg
CQkJbGlzdF9hZGQoJnJxLT5xdWV1ZWxpc3QsICZkZC0+ZGlzcGF0Y2gpOw0KPiANCj4gV2lsbCBp
dCBiZSBlYXN5IHRvIHVzZXJzIHdobyBhbmFseXplIGEga2VybmVsIGxvZyB0byBmaWd1cmUgb3V0
IHdoeSB0aGF0DQo+IG1lc3NhZ2UgaGFzIGJlZW4gZ2VuZXJhdGVkPyBTaG91bGQgdGhhdCBtZXNz
YWdlIHBlcmhhcHMgaW5jbHVkZSB0aGUgYmxvY2sNCj4gZGV2aWNlIG5hbWUsIHpvbmUgbnVtYmVy
IGFuZCByZXF1ZXN0IHNlY3RvciBudW1iZXI/DQoNClRoaXMgd2FzIGp1c3QgYSBkZWJ1ZyBtZXNz
YWdlIGZvciBtZSB0aGF0IEkgZm9yZ290IHRvIHJlbW92ZS4gSSBkaWQgaW4gVjYuDQpUaGFua3Mg
Zm9yIGNhdGNoaW5nIHRoaXMuDQoNCkJlc3QgcmVnYXJkcy4NCg0KLS0gDQpEYW1pZW4gTGUgTW9h
bA0KV2VzdGVybiBEaWdpdGFs
