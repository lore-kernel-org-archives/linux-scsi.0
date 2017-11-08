From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 8 Nov 2017 01:06:44 +0000
Message-ID: <1510103203.2656.59.camel@wdc.com>
References: <20171107152155.19949-1-ming.lei@redhat.com>
         <1510071227.2656.12.camel@wdc.com> <20171108005906.GE20599@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33180 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbdKHBGs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 20:06:48 -0500
In-Reply-To: <20171108005906.GE20599@ming.t460p>
Content-Language: en-US
Content-ID: <E34405FE14863648BC8017DA3EB006E2@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>

T24gV2VkLCAyMDE3LTExLTA4IGF0IDA4OjU5ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMDcsIDIwMTcgYXQgMDQ6MTM6NDhQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0xMS0wNyBhdCAyMzoyMSArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfZGVidWdmcy5jIGIvZHJp
dmVycy9zY3NpL3Njc2lfZGVidWdmcy5jDQo+ID4gPiBpbmRleCA1ZTk3NTUwMDhhZWQuLjdhNTA4
Nzg0NDZiNCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2RlYnVnZnMuYw0K
PiA+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfZGVidWdmcy5jDQo+ID4gPiBAQCAtOSw3ICs5
LDEwIEBAIHZvaWQgc2NzaV9zaG93X3JxKHN0cnVjdCBzZXFfZmlsZSAqbSwgc3RydWN0IHJlcXVl
c3QgKnJxKQ0KPiA+ID4gIAlpbnQgbXNlY3MgPSBqaWZmaWVzX3RvX21zZWNzKGppZmZpZXMgLSBj
bWQtPmppZmZpZXNfYXRfYWxsb2MpOw0KPiA+ID4gIAljaGFyIGJ1Zls4MF07DQo+ID4gPiAgDQo+
ID4gPiAtCV9fc2NzaV9mb3JtYXRfY29tbWFuZChidWYsIHNpemVvZihidWYpLCBjbWQtPmNtbmQs
IGNtZC0+Y21kX2xlbik7DQo+ID4gPiArCWlmIChjbWQtPmNtbmQgPT0gc2NzaV9yZXEocnEpLT5j
bWQpDQo+ID4gPiArCQlfX3Njc2lfZm9ybWF0X2NvbW1hbmQoYnVmLCBzaXplb2YoYnVmKSwgY21k
LT5jbW5kLCBjbWQtPmNtZF9sZW4pOw0KPiA+ID4gKwllbHNlDQo+ID4gPiArCQlzdHJjcHkoYnVm
LCAidW5rbm93biIpOw0KPiA+ID4gIAlzZXFfcHJpbnRmKG0sICIsIC5jbWQ9JXMsIC5yZXRyaWVz
PSVkLCBhbGxvY2F0ZWQgJWQuJTAzZCBzIGFnbyIsIGJ1ZiwNCj4gPiA+ICAJCSAgIGNtZC0+cmV0
cmllcywgbXNlY3MgLyAxMDAwLCBtc2VjcyAlIDEwMDApOw0KPiA+ID4gIH0NCj4gPiANCj4gPiBU
aGlzIGNoYW5nZSBpbnRyb2R1Y2VzIGEgbmV3IGJ1ZywgbmFtZWx5IHRoYXQgInVua25vd24iIHdp
bGwgYXBwZWFyIGluIHRoZQ0KPiA+IGRlYnVnZnMgb3V0cHV0IGlmIChjbWQtPmNtbmQgIT0gc2Nz
aV9yZXEocnEpLT5jbWQpLiBIYXZlIHlvdSBjb25zaWRlcmVkIHRvIHVzZQ0KPiANCj4gQmVjYXVz
ZSB0aGVyZSBpc24ndCByZWxpYWJsZSB3YXkgdG8gZ2V0IHRoZSBjb21tYW5kIHNhZmVseSwgYW5k
IEkgZG9uJ3QNCj4gdGhpbmsgaXQgaXMgYSBuZXcgYnVnLg0KPiANCj4gPiB0aGUgdGVzdCAoY21k
LT5jbW5kICE9IE5VTEwpIGluc3RlYWQ/DQo+IA0KPiBObywgdGhhdCBpcyB3b3JzZSwgYmVjYXVz
ZSB5b3UgbWF5IGNhdXNlIHVzZS1hZnRlci1mcmVlIGlmIHlvdSByZWFkIGENCj4gZnJlZWQgYnVm
ZmVyLg0KDQpJdCBzZWVtcyBsaWtlIHlvdXIgb3BlcmF0aW5nIG1vZGUgaXMgc3RpbGwgdG8gY29u
dHJhZGljdCBhbGwgZmVlZGJhY2sgeW91IGdldA0KaW5zdGVhZCBvZiB0cnlpbmcgdG8gYWRkcmVz
cyB0aGUgZmVlZGJhY2sgeW91IGdldD8NCg0KQW55d2F5LCB0aGlzIGlzIGEgZGVidWdnaW5nIGZh
Y2lsaXR5IHNvIEknbSBub3QgY29udmluY2VkIHRoYXQgYXZvaWRpbmcgYQ0KKHZlcnkgc3BvcmFk
aWMpIHVzZS1hZnRlci1mcmVlIGluIHRoaXMgY29kZSBpcyBiZXR0ZXIgdGhhbiBvbWl0dGluZyB2
ZXJ5DQp1c2VmdWwgb3V0cHV0Lg0KDQpCYXJ0Lg==
