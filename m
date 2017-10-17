From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: Micro-optimize READ / WRITE CDB encoding
Date: Tue, 17 Oct 2017 22:41:20 +0000
Message-ID: <1508280078.3457.20.camel@wdc.com>
References: <20171017210352.19580-1-bart.vanassche@wdc.com>
         <cb08e66f-c5a4-6eab-2306-8bcb3aeffb3b@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:52336 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752788AbdJQWlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 18:41:23 -0400
In-Reply-To: <cb08e66f-c5a4-6eab-2306-8bcb3aeffb3b@interlog.com>
Content-Language: en-US
Content-ID: <06EB8C10AF735F459AD949EA52F9D800@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gVHVlLCAyMDE3LTEwLTE3IGF0IDE4OjE3IC0wNDAwLCBEb3VnbGFzIEdpbGJlcnQgd3JvdGU6
DQo+IE9uIDIwMTctMTAtMTcgMDU6MDMgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBA
QCAtMTAyNSw3ICsxMDI1LDYgQEAgc3RhdGljIGludCBzZF9zZXR1cF9yZWFkX3dyaXRlX2NtbmQo
c3RydWN0IHNjc2lfY21uZCAqU0NwbnQpDQo+ID4gICAJc3RydWN0IGdlbmRpc2sgKmRpc2sgPSBy
cS0+cnFfZGlzazsNCj4gPiAgIAlzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwID0gc2NzaV9kaXNrKGRp
c2spOw0KPiA+ICAgCXNlY3Rvcl90IGJsb2NrID0gYmxrX3JxX3BvcyhycSk7DQo+IA0KPiBzL2Js
b2NrL2xiYS8JCSMgdXNlIHRoZSB3ZWxsIHVuZGVyc3Rvb2QgU0NTSSBhYmJyZXZpYXRpb24NCg0K
U2luY2UgYmxrX3JxX3BvcygpIHJldHVybnMgdGhlIG9mZnNldCBpbiB1bml0cyBvZiA1MTIgYnl0
ZXMsIGhvdyBhYm91dCByZW5hbWluZw0KJ2Jsb2NrJyBpbnRvICdzZWN0b3InIGFuZCB1c2luZyB0
aGUgbmFtZSAnbGJhJyBmb3IgdGhlIG51bWJlciBvYnRhaW5lZCBhZnRlciB0aGUNCnNoaWZ0IG9w
ZXJhdGlvbj8NCg0KPiANCj4gPiAtCXNlY3Rvcl90IHRocmVzaG9sZDsNCj4gPiAgIAl1bnNpZ25l
ZCBpbnQgdGhpc19jb3VudCA9IGJsa19ycV9zZWN0b3JzKHJxKTsNCj4gPiAgIAl1bnNpZ25lZCBp
bnQgZGlmLCBkaXg7DQo+ID4gICAJYm9vbCB6b25lZF93cml0ZSA9IHNkX2lzX3pvbmVkKHNka3Ap
ICYmIHJxX2RhdGFfZGlyKHJxKSA9PSBXUklURTsNCj4gPiBAQCAtMTA3MSwyMCArMTA3MCwyMiBA
QCBzdGF0aWMgaW50IHNkX3NldHVwX3JlYWRfd3JpdGVfY21uZChzdHJ1Y3Qgc2NzaV9jbW5kICpT
Q3BudCkNCj4gPiAgIAkJZ290byBvdXQ7DQo+ID4gICAJfQ0KPiA+ICAgDQo+ID4gLQkvKg0KPiA+
IC0JICogU29tZSBTRCBjYXJkIHJlYWRlcnMgY2FuJ3QgaGFuZGxlIG11bHRpLXNlY3RvciBhY2Nl
c3NlcyB3aGljaCB0b3VjaA0KPiA+IC0JICogdGhlIGxhc3Qgb25lIG9yIHR3byBoYXJkd2FyZSBz
ZWN0b3JzLiAgU3BsaXQgYWNjZXNzZXMgYXMgbmVlZGVkLg0KPiA+IC0JICovDQo+ID4gLQl0aHJl
c2hvbGQgPSBnZXRfY2FwYWNpdHkoZGlzaykgLSBTRF9MQVNUX0JVR0dZX1NFQ1RPUlMgKg0KPiA+
IC0JCShzZHAtPnNlY3Rvcl9zaXplIC8gNTEyKTsNCj4gPiArCWlmICh1bmxpa2VseShzZHAtPmxh
c3Rfc2VjdG9yX2J1ZykpIHsNCj4gPiArCQlzZWN0b3JfdCB0aHJlc2hvbGQ7DQo+IA0KPiBzL3Ro
cmVzaG9sZC90aHJlc2hvbGRfbGJhLwkjIGEgYml0IGxvbmcgYnV0IG1vcmUgcHJlY2lzZQ0KDQpB
IHNpbWlsYXIgY29tbWVudCBhcHBsaWVzIGhlcmUgLSBzaG91bGRuJ3QgdGhpcyBiZSBjYWxsZWQg
J3RocmVzaG9sZF9zZWN0b3InPw0KDQo+ID4gICAJCX0NCj4gPiAgIAl9DQo+ID4gICAJaWYgKHJx
X2RhdGFfZGlyKHJxKSA9PSBXUklURSkgew0KPiA+IEBAIC0xMTczLDU2ICsxMTU3LDI2IEBAIHN0
YXRpYyBpbnQgc2Rfc2V0dXBfcmVhZF93cml0ZV9jbW5kKHN0cnVjdCBzY3NpX2NtbmQgKlNDcG50
KQ0KPiA+ICAgCQlTQ3BudC0+Y21uZFs3XSA9IDB4MTg7DQo+ID4gICAJCVNDcG50LT5jbW5kWzld
ID0gKHJxX2RhdGFfZGlyKHJxKSA9PSBSRUFEKSA/IFJFQURfMzIgOiBXUklURV8zMjsNCj4gDQo+
IFBlcmhhcHMgcnFfZGF0YV9kaXIocnEpIGNvdWxkIGJlIHBsYWNlZCBpbiBhIGxvY2FsIHZhcmlh
YmxlDQoNCkkgd2lsbCBrZWVwIHRoYXQgZm9yIGEgc2VwYXJhdGUgcGF0Y2guDQoNCkJhcnQu
