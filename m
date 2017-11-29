From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 17:47:54 +0000
Message-ID: <1511977672.2671.19.camel@wdc.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129173904.GB20581@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53438 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934051AbdK2Rr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 12:47:58 -0500
In-Reply-To: <20171129173904.GB20581@kroah.com>
Content-Language: en-US
Content-ID: <AA3F6A8504055B45A1925C952DABBC70@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

T24gV2VkLCAyMDE3LTExLTI5IGF0IDE3OjM5ICswMDAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gV2VkLCBOb3YgMjksIDIwMTcgYXQgMDQ6MTg6MzBQTSArMDAwMCwg
QmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IEFzIHRoZSBhYm92ZSBwYXRjaCBkZXNjcmlwdGlv
biBzaG93cyBpdCBjYW4gaGFwcGVuIHRoYXQgdGhlIFNDU0kgY29yZSBjYWxscw0KPiA+IGdldF9k
ZXZpY2UoKSBhZnRlciB0aGUgZGV2aWNlIHJlZmVyZW5jZSBjb3VudCBoYXMgcmVhY2hlZCB6ZXJv
IGFuZCBiZWZvcmUNCj4gPiB0aGUgbWVtb3J5IGZvciBzdHJ1Y3QgZGV2aWNlIGlzIGZyZWVkLiBB
bHRob3VnaCB0aGUgYWJvdmUgcGF0Y2ggbG9va3MgZmluZQ0KPiA+IHRvIG1lLCB3b3VsZCB5b3Ug
Y29uc2lkZXIgaXQgYWNjZXB0YWJsZSB0byBtb2RpZnkgZ2V0X2RldmljZSgpIHN1Y2ggdGhhdCBp
dA0KPiA+IHVzZXMga29iamVjdF9nZXRfdW5sZXNzX3plcm8oKSBpbnN0ZWFkIG9mIGtvYmplY3Rf
Z2V0KCk/IEknbSBhc2tpbmcgdGhpcw0KPiA+IGJlY2F1c2UgdGhhdCBjaGFuZ2Ugd291bGQgaGVs
cCB0byByZWR1Y2UgdGhlIGNvbXBsZXhpdHkgb2YgdGhlIGFscmVhZHkgdG9vDQo+ID4gY29tcGxp
Y2F0ZWQgU0NTSSBjb3JlLg0KPiANCj4gU2hvdWxkbid0IHRoZXJlIGJlIGEgYnVzIGxvY2sgc29t
ZXdoZXJlIHByZXZlbnRpbmcgdGhpcyByYWNlPyAgSGF2aW5nIGFuDQo+IG9wZW4tY29kZWQgcHV0
IGNhbGwgaXNuJ3QgZ29vZCwgYXMgeW91IHNlZSBoZXJlLg0KDQpIZWxsbyBHcmVnLA0KDQpUaGUg
Z2V0X2RldmljZSgpIGNhbGwgb2NjdXJzIHdpdGggdGhlIFNDU0kgaG9zdCBsb2NrIGhlbGQuIFRo
ZSBTQ1NJIGhvc3QgbG9jaw0Kc2VyaWFsaXplcyBpdGVyYXRpb24gb3ZlciB0aGUgc2libGluZyBs
aXN0IGJ5IHRoZSBnZXRfZGV2aWNlKCkgY2FsbGVyIGFuZA0KcmVtb3ZhbCBvZiB0aGUgU0NTSSBo
b3N0IGZyb20gdGhlIFNDU0kgZGV2aWNlIHNpYmxpbmcgbGlzdCBieQ0Kc2NzaV9kZXZpY2VfZGV2
X3JlbGVhc2VfdXNlcmNvbnRleHQoKS4gSWYgeW91IGhhdmUgYSBsb29rIGF0IF9fc2NzaV9yZW1v
dmVfdGFyZ2V0KCkNCnRoZW4geW91IHdpbGwgc2VlIHRoYXQgdGhlIGhvc3QgbG9jayBoYXMgdG8g
YmUgcmVsZWFzZWQgYWZ0ZXIgYSBtYXRjaGluZyBTQ1NJDQp0YXJnZXQgaGFzIGJlZW4gZm91bmQg
YW5kIGJlZm9yZSBzY3NpX3JlbW92ZV9kZXZpY2UoKSBpcyBjYWxsZWQuIFRoZSBsYXR0ZXINCmZ1
bmN0aW9uIG5hbWVseSBtYXkgc2xlZXAuDQoNCkJhcnQu
