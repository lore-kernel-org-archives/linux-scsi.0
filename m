From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Wed, 6 Dec 2017 16:07:17 +0000
Message-ID: <1512576435.3297.3.camel@wdc.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
         <1512490099.2660.6.camel@sandisk.com> <20171205162825.GA23788@ming.t460p>
         <20171206015212.GB26512@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171206015212.GB26512@ming.t460p>
Content-Language: en-US
Content-ID: <C6311B4186A0184C9F9B881FE4CEA678@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTEyLTA2IGF0IDA5OjUyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
V2VkLCBEZWMgMDYsIDIwMTcgYXQgMTI6Mjg6MjVBTSArMDgwMCwgTWluZyBMZWkgd3JvdGU6DQo+
ID4gT24gVHVlLCBEZWMgMDUsIDIwMTcgYXQgMDQ6MDg6MjBQTSArMDAwMCwgQmFydCBWYW4gQXNz
Y2hlIHdyb3RlOg0KPiA+ID4gVGhlIHBhdGNoIGJlbG93IGlzIG5vdCBhIGZ1bGwgc29sdXRpb24g
YnV0IHJlc3VsdGVkIGluIGEgc2lnbmlmaWNhbnQNCj4gPiA+IGltcHJvdmVtZW50IGluIG15IHRl
c3RzOg0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1xLXNjaGVkLmMgYi9i
bG9jay9ibGstbXEtc2NoZWQuYw0KPiA+ID4gaW5kZXggNjllMzIyNmU2NmNhLi45ZDg2ODc2ZWM1
MDMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9ibG9jay9ibGstbXEtc2NoZWQuYw0KPiA+ID4gKysrIGIv
YmxvY2svYmxrLW1xLXNjaGVkLmMNCj4gPiA+IEBAIC0yMjYsNiArMjI2LDcgQEAgdm9pZCBibGtf
bXFfc2NoZWRfZGlzcGF0Y2hfcmVxdWVzdHMoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgpDQo+
ID4gPiAgCQkgKiBUT0RPOiBnZXQgbW9yZSBidWRnZXRzLCBhbmQgZGVxdWV1ZSBtb3JlIHJlcXVl
c3RzIGluDQo+ID4gPiAgCQkgKiBvbmUgdGltZS4NCj4gPiA+ICAJCSAqLw0KPiA+ID4gKwkJYmxr
X21xX3NjaGVkX21hcmtfcmVzdGFydF9oY3R4KGhjdHgpOw0KPiA+ID4gIAkJYmxrX21xX2RvX2Rp
c3BhdGNoX2N0eChoY3R4KTsNCj4gPiA+ICAJfSBlbHNlIHsNCj4gPiA+ICAJCWJsa19tcV9mbHVz
aF9idXN5X2N0eHMoaGN0eCwgJnJxX2xpc3QpOw0KPiANCj4gQlRXLCB0aGlzIGtpbmQgb2YgY2hh
bmdlIGNhbid0IGNvdmVyIHNjc2lfc2V0X2Jsb2NrZWQoKSB3aGljaCBpcw0KPiB0cmlnZ2VyZWQg
YnkgdGltZW91dCwgc2NzaSBkaXNwYXRjaCBmYWlsdXJlLiBZb3Ugd2lsbCBzZWUgdGhhdA0KPiBl
YXNpbHkgaWYgeW91IHJ1biB0aGUgU0NTSSB0ZXN0IHNjcmlwdCBJIHByb3ZpZGVkIGluIHRoZSBj
b21taXQgbG9nLg0KDQpIZWxsbyBNaW5nLA0KDQpJIGFtIGF3YXJlIHRoYXQgdGhlIGFib3ZlIGNo
YW5nZSBkb2VzIG5vdCBjb3ZlciBhbGwgY2FzZXMuIFRoYXQncyB3aHkgSSB3cm90ZQ0KaW4gbXkg
cHJldmlvdXMgZS1tYWlsIHRoYXQgdGhhdCBwYXRjaCBpcyBub3QgYSBmdWxsIHNvbHV0aW9uLiBU
aGUgcmVhc29uIEkNCnBvc3RlZCB0aGF0IGNoYW5nZSBhbnl3YXkgaXMgYmVjYXVzZSBJIHByZWZl
ciBhIHNvbHV0aW9uIHRoYXQgaXMgbm90IGJhc2VkIG9uDQpkZWxheWVkIHF1ZXVlIHJ1bnMgb3Zl
ciBhIHNvbHV0aW9uIHRoYXQgaXMgYmFzZWQgb24gZGVsYXllZCBxdWV1ZSBydW5zDQooYmxrX21x
X2RlbGF5X3J1bl9od19xdWV1ZSgpKS4gTXkgY29uY2VybiBpcyB0aGF0IHBlcmZvcm1hbmNlIG9m
IGEgc29sdXRpb24NCmJhc2VkIG9uIGRlbGF5ZWQgcXVldWUgcnVucyB3aWxsIGJlIHN1Ym9wdGlt
YWwuDQoNCkJhcnQu
