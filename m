From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 5/9] block: introduce blk_drain_queue()
Date: Thu, 31 Aug 2017 22:34:49 +0000
Message-ID: <1504218887.31872.66.camel@wdc.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
         <20170831172728.15817-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6172 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdHaWfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 18:35:38 -0400
In-Reply-To: <20170831172728.15817-6-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <6774D82921BB4141B25B5F903F257A24@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "oleksandr@natalenko.name" <oleksandr@natalenko.name>

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDAxOjI3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gU28g
dGhhdCB3ZSBjYW4gc3VwcG9ydCBsZWdhY3kgdmVyc2lvbiBvZiBmcmVlemluZyBxdWV1ZSwNCj4g
d2hpY2ggaXMgcmVxdWlyZWQgYnkgc2FmZSBTQ1NJIHF1aWVzY2luZy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIGJsb2NrL2Js
ay1jb3JlLmMgICAgICAgfCAxNiArKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L2Js
a2Rldi5oIHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWNvcmUuYyBiL2Jsb2NrL2Jsay1jb3JlLmMNCj4gaW5k
ZXggZDU3OTUwMWYyNGJhLi42MzY0NTJmMTUxZWEgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Jsay1j
b3JlLmMNCj4gKysrIGIvYmxvY2svYmxrLWNvcmUuYw0KPiBAQCAtNTMwLDYgKzUzMCwyMiBAQCBz
dGF0aWMgdm9pZCBfX2Jsa19kcmFpbl9xdWV1ZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgYm9v
bCBkcmFpbl9hbGwpDQo+ICB9DQo+ICANCj4gIC8qKg0KPiArICogYmxrX2RyYWluX3F1ZXVlIC0g
ZHJhaW4gcmVxdWVzdHMgZnJvbSByZXF1ZXN0X3F1ZXVlDQo+ICsgKiBAcTogcXVldWUgdG8gZHJh
aW4NCj4gKyAqDQo+ICsgKiBEcmFpbiByZXF1ZXN0cyBmcm9tIEBxLiAgQWxsIHBlbmRpbmcgcmVx
dWVzdHMgYXJlIGRyYWluZWQuDQo+ICsgKiBUaGUgY2FsbGVyIGlzIHJlc3BvbnNpYmxlIGZvciBl
bnN1cmluZyB0aGF0IG5vIG5ldyByZXF1ZXN0cw0KPiArICogd2hpY2ggbmVlZCB0byBiZSBkcmFp
bmVkIGFyZSBxdWV1ZWQuDQo+ICsgKi8NCj4gK3ZvaWQgYmxrX2RyYWluX3F1ZXVlKHN0cnVjdCBy
ZXF1ZXN0X3F1ZXVlICpxKQ0KPiArew0KPiArCXNwaW5fbG9ja19pcnEocS0+cXVldWVfbG9jayk7
DQo+ICsJX19ibGtfZHJhaW5fcXVldWUocSwgdHJ1ZSk7DQo+ICsJc3Bpbl91bmxvY2tfaXJxKHEt
PnF1ZXVlX2xvY2spOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTChibGtfZHJhaW5fcXVldWUpOw0K
DQpIZWxsbyBNaW5nLA0KDQpQbGVhc2UgZHJvcCB0aGlzIHBhdGNoLiBBcyBmYXIgYXMgSSBjYW4g
c2VlIHRoaXMgcGF0Y2ggc2VyaWVzIGludHJvZHVjZXMgb25seQ0Kb25lIGNhbGwgdG8gYmxrX2Ry
YWluX3F1ZXVlKCksIG5hbWVseSBpbiBibGtfZnJlZXplX3F1ZXVlX3dhaXQoKSBpbiBwYXRjaCA2
Lg0KTXkgcHJvcG9zYWwgaXMgdG8gaW5saW5lIHRoZSBib2R5IG9mIGJsa19kcmFpbl9xdWV1ZSgp
IGluIGJsa19mcmVlemVfcXVldWVfd2FpdCgpDQppbnN0ZWFkIG9mIHJlaW50cm9kdWNpbmcgYmxr
X2RyYWluX3F1ZXVlKCkgKHNlZSBhbHNvIGNvbW1pdCA4MDc1OTJhNGZhZmI7DQoiYmxvY2s6IExl
dCBibGtfZHJhaW5fcXVldWUoKSBjYWxsZXIgb2J0YWluIHRoZSBxdWV1ZSBsb2NrIikuDQoNCkJh
cnQu
