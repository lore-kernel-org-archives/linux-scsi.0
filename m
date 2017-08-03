From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Thu, 3 Aug 2017 01:33:49 +0000
Message-ID: <1501724027.30887.1.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-7-ming.lei@redhat.com>
         <1501544540.2466.31.camel@wdc.com> <20170801104433.GC31452@ming.t460p>
         <1501604045.2475.8.camel@wdc.com> <20170802030128.GA7267@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15329 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751727AbdHCBeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 21:34:37 -0400
In-Reply-To: <20170802030128.GA7267@ming.t460p>
Content-Language: en-US
Content-ID: <7E5D9D321CDD9B42A88469D402BE0A55@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTA4LTAyIGF0IDExOjAxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBBdWcgMDEsIDIwMTcgYXQgMDQ6MTQ6MDdQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0wOC0wMSBhdCAxODo0NCArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBPbiBNb24sIEp1bCAzMSwgMjAxNyBhdCAxMTo0MjoyMVBNICswMDAwLCBCYXJ0
IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gPiA+IFNpbmNlIHNldHRpbmcsIGNsZWFyaW5nIGFuZCB0
ZXN0aW5nIG9mIEJMS19NUV9TX0JVU1kgY2FuIGhhcHBlbiBjb25jdXJyZW50bHkNCj4gPiA+ID4g
YW5kIHNpbmNlIGNsZWFyaW5nIGFuZCB0ZXN0aW5nIGhhcHBlbnMgd2l0aG91dCBhbnkgbG9ja3Mg
aGVsZCBJJ20gYWZyYWlkIHRoaXMNCj4gPiA+ID4gcGF0Y2ggaW50cm9kdWNlcyB0aGUgZm9sbG93
aW5nIHJhY2UgY29uZGl0aW9uczoNCj4gPiA+ID4gWyAuLi4gXQ0KPiA+ID4gPiAqIENoZWNraW5n
IEJMS19NUV9TX0JVU1kgYWZ0ZXIgcmVxdWVzdHMgaGF2ZSBiZWVuIHJlbW92ZWQgZnJvbSB0aGUg
ZGlzcGF0Y2ggbGlzdA0KPiA+ID4gPiAgIGJ1dCBiZWZvcmUgdGhhdCBiaXQgaXMgY2xlYXJlZCwg
cmVzdWx0aW5nIGluIHRlc3RfYml0KEJMS19NUV9TX0JVU1ksICZoY3R4LT5zdGF0ZSkNCj4gPiA+
ID4gICByZXBvcnRpbmcgdGhhdCB0aGUgQkxLX01RX1NfQlVTWQ0KPiA+ID4gPiBoYXMgYmVlbiBz
ZXQgYWx0aG91Z2ggdGhlcmUgYXJlIG5vIHJlcXVlc3RzDQo+ID4gPiA+ICAgb24gdGhlIGRpc3Bh
dGNoIGxpc3QuDQo+ID4gPiANCj4gPiA+IFRoYXQgd29uJ3QgYmUgYSBwcm9ibGVtLCBiZWNhdXNl
IGRpc3BhdGNoIHdpbGwgYmUgc3RhcnRlZCBpbiB0aGUNCj4gPiA+IGNvbnRleHQgaW4gd2hpY2gg
ZGlzcGF0Y2ggbGlzdCBpcyBmbHVzaGVkLCBzaW5jZSB0aGUgQlVTWSBiaXQNCj4gPiA+IGlzIGNs
ZWFyZWQgYWZ0ZXIgYmxrX21xX2Rpc3BhdGNoX3JxX2xpc3QoKSByZXR1cm5zLiBTbyBubyBJL08N
Cj4gPiA+IGhhbmcuDQo+ID4gDQo+ID4gSGVsbG8gTWluZywNCj4gPiANCj4gPiBQbGVhc2UgY29u
c2lkZXIgY2hhbmdpbmcgdGhlIG5hbWUgb2YgdGhlIEJMS19NUV9TX0JVU1kgY29uc3RhbnQuIFRo
YXQgYml0DQo+ID4gaXMgdXNlZCB0byBzZXJpYWxpemUgZGlzcGF0Y2hpbmcgcmVxdWVzdHMgZnJv
bSB0aGUgaGN0eCBkaXNwYXRjaCBsaXN0IGJ1dA0KPiA+IHRoYXQncyBub3QgY2xlYXIgZnJvbSB0
aGUgbmFtZSBvZiB0aGF0IGNvbnN0YW50Lg0KPiANCj4gQWN0dWFsbHkgd2hhdCB3ZSB3YW50IHRv
IGRvIGlzIHRvIHN0b3AgdGFraW5nIHJlcXVlc3QgZnJvbSBzdy9zY2hlZHVsZXINCj4gcXVldWUg
d2hlbiAtPmRpc3BhdGNoIGFyZW4ndCBmbHVzaGVkIGNvbXBsZXRlbHksIEkgdGhpbmsgQlVTWSBp
c24ndA0KPiBhIGJhZCBuYW1lIGZvciB0aGlzIGNhc2UsIG9yIGhvdyBhYm91dCBESVNQQVRDSF9C
VVNZPyBvcg0KPiBGTFVTSElOR19ESVNQQVRDSD8NCg0KSGVsbG8gTWluZywNCg0KRkxVU0hJTkdf
RElTUEFUQ0ggc291bmRzIGZpbmUgdG8gbWUuIEluIGNhc2UgeW91IHdvdWxkIHByZWZlciBhIHNo
b3J0ZXIgbmFtZSwNCmhvdyBhYm91dCBCTEtfTVFfU19ESVNQQVRDSElORyAocmVmZXJzIHRvIGRp
c3BhdGNoaW5nIHJlcXVlc3RzIHRvIHRoZSBkcml2ZXIpPw0KDQpCYXJ0Lg==
