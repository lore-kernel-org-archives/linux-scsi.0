From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 17:39:07 +0000
Message-ID: <1511977145.2671.13.camel@wdc.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11264 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934224AbdK2RjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 12:39:10 -0500
In-Reply-To: <20171129162050.GA32071@lst.de>
Content-Language: en-US
Content-ID: <4B7115E51170774EB5DDACC4839C75A9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

T24gV2VkLCAyMDE3LTExLTI5IGF0IDE3OjIwICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBXZWQsIE5vdiAyOSwgMjAxNyBhdCAwNDoxODozMFBNICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUg
d3JvdGU6DQo+ID4gQXMgdGhlIGFib3ZlIHBhdGNoIGRlc2NyaXB0aW9uIHNob3dzIGl0IGNhbiBo
YXBwZW4gdGhhdCB0aGUgU0NTSSBjb3JlIGNhbGxzDQo+ID4gZ2V0X2RldmljZSgpIGFmdGVyIHRo
ZSBkZXZpY2UgcmVmZXJlbmNlIGNvdW50IGhhcyByZWFjaGVkIHplcm8gYW5kIGJlZm9yZQ0KPiA+
IHRoZSBtZW1vcnkgZm9yIHN0cnVjdCBkZXZpY2UgaXMgZnJlZWQuIEFsdGhvdWdoIHRoZSBhYm92
ZSBwYXRjaCBsb29rcyBmaW5lDQo+ID4gdG8gbWUsIHdvdWxkIHlvdSBjb25zaWRlciBpdCBhY2Nl
cHRhYmxlIHRvIG1vZGlmeSBnZXRfZGV2aWNlKCkgc3VjaCB0aGF0IGl0DQo+ID4gdXNlcyBrb2Jq
ZWN0X2dldF91bmxlc3NfemVybygpIGluc3RlYWQgb2Yga29iamVjdF9nZXQoKT8gSSdtIGFza2lu
ZyB0aGlzDQo+ID4gYmVjYXVzZSB0aGF0IGNoYW5nZSB3b3VsZCBoZWxwIHRvIHJlZHVjZSB0aGUg
Y29tcGxleGl0eSBvZiB0aGUgYWxyZWFkeSB0b28NCj4gPiBjb21wbGljYXRlZCBTQ1NJIGNvcmUu
DQo+IA0KPiBJIGRvbid0IHRoaW5rIHdlIGNhbiBqdXN0IG1vZGlmeSBnZXRfZGV2aWNlLCBidXQg
d2UgY2FuIGFkZCBhIG5ldw0KPiBnZXRfZGV2aWNlX3VubGVzc196ZXJvLiAgSW4gZmFjdCBJIGhh
dmUgYW4gb3BlbiBjb2RlZCB2YXJpYW50IG9mIHRoYXQNCj4gaW4gbnZtZSwgYW5kIHdhcyBwbGFu
bmluZyB0byBzdWJtaXQgb25lIGZvciB0aGUgY3VycmVudCBtZXJnZSB3aW5kb3cuLg0KDQpTb3Jy
eSBidXQgSSBkb24ndCBzZWUgd2h5IHdlIGNhbid0IG1vZGlmeSBnZXRfZGV2aWNlKCk/IENhbiB5
b3UgZXhwbGFpbiB3aHkNCnlvdSB0aGluayB0aGF0IHNvbWV0aGluZyBsaWtlIHRoZSBwYXRjaCBi
ZWxvdyBpcyB3cm9uZz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCltQQVRDSF0gTWFrZSBpdCBz
YWZlIHRvIHVzZSBnZXRfZGV2aWNlKCkgaWYgdGhlIHJlZmVyZW5jZSBjb3VudCBpcyB6ZXJvDQoN
Ci0tLQ0KIGRyaXZlcnMvYmFzZS9jb3JlLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jhc2UvY29y
ZS5jIGIvZHJpdmVycy9iYXNlL2NvcmUuYw0KaW5kZXggMTEwMjMwZDg2NTI3Li4wNDlhNWQ5ZGJh
OGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jhc2UvY29yZS5jDQorKysgYi9kcml2ZXJzL2Jhc2Uv
Y29yZS5jDQpAQCAtMTkxNiw3ICsxOTE2LDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwoZGV2aWNlX3Jl
Z2lzdGVyKTsNCiAgKi8NCiBzdHJ1Y3QgZGV2aWNlICpnZXRfZGV2aWNlKHN0cnVjdCBkZXZpY2Ug
KmRldikNCiB7DQotCXJldHVybiBkZXYgPyBrb2JqX3RvX2Rldihrb2JqZWN0X2dldCgmZGV2LT5r
b2JqKSkgOiBOVUxMOw0KKwlyZXR1cm4gZGV2ICYmIGtvYmplY3RfZ2V0X3VubGVzc196ZXJvKCZk
ZXYtPmtvYmopID8gZGV2IDogTlVMTDsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoZ2V0X2Rldmlj
ZSk7DQo=
