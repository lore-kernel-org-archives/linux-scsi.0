From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 13/14] block: mq-deadline: Limit write request dispatch
 for zoned block devices
Date: Mon, 25 Sep 2017 22:06:59 +0000
Message-ID: <1506377218.2641.37.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-14-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34803 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934366AbdIYWHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 18:07:02 -0400
In-Reply-To: <20170925061454.5533-14-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <CA9BFA7B3510D0438484A3B6F8C2AAEB@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDE1OjE0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gLQlyZXR1cm4gcnFfZW50cnlfZmlmbyhkZC0+Zmlmb19saXN0W2RhdGFfZGlyXS5uZXh0KTsN
Cj4gKwlpZiAoIWRkLT56b25lc193bG9jayB8fCBkYXRhX2RpciA9PSBSRUFEKQ0KPiArCQlyZXR1
cm4gcnFfZW50cnlfZmlmbyhkZC0+Zmlmb19saXN0W2RhdGFfZGlyXS5uZXh0KTsNCj4gKw0KPiAr
CXNwaW5fbG9ja19pcnFzYXZlKCZkZC0+em9uZV9sb2NrLCBmbGFncyk7DQo+ICsNCj4gKwlsaXN0
X2Zvcl9lYWNoX2VudHJ5KHJxLCAmZGQtPmZpZm9fbGlzdFtXUklURV0sIHF1ZXVlbGlzdCkgew0K
PiArCQlpZiAoZGVhZGxpbmVfY2FuX2Rpc3BhdGNoX3JlcXVlc3QoZGQsIHJxKSkNCj4gKwkJCWdv
dG8gb3V0Ow0KPiArCX0NCj4gKwlycSA9IE5VTEw7DQo+ICsNCj4gK291dDoNCj4gKwlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZkZC0+em9uZV9sb2NrLCBmbGFncyk7DQoNCklzIGl0IGRvY3VtZW50
ZWQgc29tZXdoZXJlIHdoYXQgZGQtPnpvbmVfbG9jayBwcm90ZWN0cyBhbmQgd2hlbiB0aGF0IGxv
Y2sgc2hvdWxkIGJlDQphY3F1aXJlZD8NCg0KPiAJLyoNCj4gIAkgKiBUaGlzIG1heSBiZSBhIHJl
cXVldWUgb2YgYSByZXF1ZXN0IHRoYXQgaGFzIGxvY2tlZCBpdHMNCj4gLQkgKiB0YXJnZXQgem9u
ZS4gSWYgdGhpcyBpcyB0aGUgY2FzZSwgcmVsZWFzZSB0aGUgcmVxdWVzdCB6b25lIGxvY2suDQo+
ICsJICogdGFyZ2V0IHpvbmUuIElmIHRoaXMgaXMgdGhlIGNhc2UsIHJlbGVhc2UgdGhlIHpvbmUg
bG9jay4NCj4gIAkgKi8NCj4gIAlpZiAoZGVhZGxpbmVfcmVxdWVzdF9oYXNfem9uZV93bG9jayhy
cSkpDQo+ICAJCWRlYWRsaW5lX3d1bmxvY2tfem9uZShkZCwgcnEpOw0KDQpDYW4gdGhpcyBjaGFu
Z2UgYmUgZm9sZGVkIGludG8gdGhlIHBhdGNoIHRoYXQgaW50cm9kdWNlZCB0aGF0IGNvbW1lbnQ/
DQoNCj4gQEAgLTU3MCw2ICs2MjEsOSBAQCBzdGF0aWMgdm9pZCBkZF9pbnNlcnRfcmVxdWVzdChz
dHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwgc3RydWN0IHJlcXVlc3QgKnJxLA0KPiAgDQo+ICAJ
YmxrX21xX3NjaGVkX3JlcXVlc3RfaW5zZXJ0ZWQocnEpOw0KPiAgDQo+ICsJaWYgKGF0X2hlYWQg
JiYgZGVhZGxpbmVfcmVxdWVzdF9uZWVkc196b25lX3dsb2NrKGRkLCBycSkpDQo+ICsJCXByX2lu
Zm8oIiMjIyMjIyMjIFdyaXRlIGF0IGhlYWQgIVxuIik7DQo+ICsNCj4gIAlpZiAoYXRfaGVhZCB8
fCBibGtfcnFfaXNfcGFzc3Rocm91Z2gocnEpKSB7DQo+ICAJCWlmIChhdF9oZWFkKQ0KPiAgCQkJ
bGlzdF9hZGQoJnJxLT5xdWV1ZWxpc3QsICZkZC0+ZGlzcGF0Y2gpOw0KDQpXaWxsIGl0IGJlIGVh
c3kgdG8gdXNlcnMgd2hvIGFuYWx5emUgYSBrZXJuZWwgbG9nIHRvIGZpZ3VyZSBvdXQgd2h5IHRo
YXQNCm1lc3NhZ2UgaGFzIGJlZW4gZ2VuZXJhdGVkPyBTaG91bGQgdGhhdCBtZXNzYWdlIHBlcmhh
cHMgaW5jbHVkZSB0aGUgYmxvY2sNCmRldmljZSBuYW1lLCB6b25lIG51bWJlciBhbmQgcmVxdWVz
dCBzZWN0b3IgbnVtYmVyPw0KDQpUaGFua3MsDQoNCkJhcnQu
