From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 08/29] scsi: aacraid: Move code to wait for IO completion
 to shutdown func
Date: Fri, 22 Dec 2017 16:26:46 +0000
Message-ID: <1513960005.2579.10.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-9-RaghavaAditya.Renukunta@microsemi.com>
         <1513879148.2931.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31544 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbdLVQ0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 11:26:49 -0500
In-Reply-To: <1513879148.2931.19.camel@wdc.com>
Content-Language: en-US
Content-ID: <EF4D430923EE884BB4DB7B8DAEDCCAF9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDE3OjU5ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIFRodSwgMjAxNy0xMi0yMSBhdCAwOTozMyAtMDgwMCwgUmFnaGF2YSBBZGl0eWEgUmVu
dWt1bnRhIHdyb3RlOg0KPiA+ICtzdGF0aWMgdm9pZCBhYWNfd2FpdF9mb3JfaW9fY29tcGxldGlv
bihzdHJ1Y3QgYWFjX2RldiAqYWFjKQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWd2
ID0gMDsNCj4gPiArCWludCBpID0gMDsNCj4gPiArDQo+ID4gKwlmb3IgKGkgPSA2MDsgaTsgLS1p
KSB7DQo+ID4gKwkJc3RydWN0IHNjc2lfZGV2aWNlICpkZXY7DQo+ID4gKwkJc3RydWN0IHNjc2lf
Y21uZCAqY29tbWFuZDsNCj4gPiArCQlpbnQgYWN0aXZlID0gMDsNCj4gPiArDQo+ID4gKwkJX19z
aG9zdF9mb3JfZWFjaF9kZXZpY2UoZGV2LCBhYWMtPnNjc2lfaG9zdF9wdHIpIHsNCj4gPiArCQkJ
c3Bpbl9sb2NrX2lycXNhdmUoJmRldi0+bGlzdF9sb2NrLCBmbGFndik7DQo+ID4gKwkJCWxpc3Rf
Zm9yX2VhY2hfZW50cnkoY29tbWFuZCwgJmRldi0+Y21kX2xpc3QsIGxpc3QpIHsNCj4gPiArCQkJ
CWlmIChjb21tYW5kLT5TQ3AucGhhc2UgPT0gQUFDX09XTkVSX0ZJUk1XQVJFKSB7DQo+ID4gKwkJ
CQkJYWN0aXZlKys7DQo+ID4gKwkJCQkJYnJlYWs7DQo+ID4gKwkJCQl9DQo+ID4gKwkJCX0NCj4g
PiArCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2LT5saXN0X2xvY2ssIGZsYWd2KTsNCj4g
PiArCQkJaWYgKGFjdGl2ZSkNCj4gPiArCQkJCWJyZWFrOw0KPiA+ICsNCj4gPiArCQl9DQo+ID4g
KwkJLyoNCj4gPiArCQkgKiBXZSBjYW4gZXhpdCBJZiBhbGwgdGhlIGNvbW1hbmRzIGFyZSBjb21w
bGV0ZQ0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmIChhY3RpdmUgPT0gMCkNCj4gPiArCQkJYnJlYWs7
DQo+ID4gKwkJc3NsZWVwKDEpOw0KPiA+ICsJfQ0KPiA+ICt9DQo+IA0KPiBIYXZlIHlvdSBjb25z
aWRlcmVkIHRvIGNhbGwgc2NzaV90YXJnZXRfYmxvY2soKSBhbmQgc2NzaV90YXJnZXRfdW5ibG9j
aygpIGluc3RlYWQNCj4gb2YgaW1wbGVtZW50aW5nIGZ1bmN0aW9uYWxpdHkgbGlrZSB0aGUgYWJv
dmUgaW4gYSBTQ1NJIExMRD8NCg0KKHJlcGx5aW5nIHRvIG15IG93biBlLW1haWwpDQoNCkl0IHNl
ZW1zIGxpa2UgSSBtaXNyZWFkIHlvdXIgY29kZSAtIGNhbGxpbmcgc2NzaV90YXJnZXRfYmxvY2so
KSBhbmQNCnNjc2lfdGFyZ2V0X3VuYmxvY2soKSB3b3VsZCBub3QgYmUgc3VmZmljaWVudC4gQnV0
IGNhbGxpbmcgYmxrX21xX2ZyZWV6ZV9xdWV1ZSgpDQphbmQgYmxrX21xX3VuZnJlZXplX3F1ZXVl
KCkgc2hvdWxkIGJlIHN1ZmZpY2llbnQuIFRoZSBmb2xsb3dpbmcgY29tbWl0IG1hZGUgdGhlc2UN
CmZ1bmN0aW9ucyB3b3JrIG5vdCBvbmx5IGZvciBzY3NpLW1xIGJ1dCBhbHNvIGZvciBsZWdhY3kg
c2NzaSBxdWV1ZXM6IGNvbW1pdA0KMDU1ZjZlMThlMDhmICgiYmxvY2s6IE1ha2UgcV91c2FnZV9j
b3VudGVyIGFsc28gdHJhY2sgbGVnYWN5IHJlcXVlc3RzIikuDQoNCkJhcnQu
