From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 18:42:30 +0000
Message-ID: <1505846549.2671.52.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-2-ming.lei@redhat.com>
         <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
         <1505747894.2685.6.camel@wdc.com> <20170919054308.GA2517@ming.t460p>
         <1505835394.2671.18.camel@wdc.com> <20170919155603.GB22809@redhat.com>
         <20170919160401.GC19830@ming.t460p> <1505839754.2671.42.camel@wdc.com>
         <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25711 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751227AbdISSme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 14:42:34 -0400
In-Reply-To: <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
Content-Language: en-US
Content-ID: <DD54F743DF8E2C4FB60BB499026AF9CC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gV2VkLCAyMDE3LTA5LTIwIGF0IDAwOjU1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
V2VkLCBTZXAgMjAsIDIwMTcgYXQgMTI6NDkgQU0sIEJhcnQgVmFuIEFzc2NoZQ0KPiA8QmFydC5W
YW5Bc3NjaGVAd2RjLmNvbT4gd3JvdGU6DQo+ID4gT24gV2VkLCAyMDE3LTA5LTIwIGF0IDAwOjA0
ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gPiA+IFJ1biBxdWV1ZSBhdCBlbmRfaW8gaXMgZGVm
aW5pdGVseSB3cm9uZywgYmVjYXVzZSBibGstbXEgaGFzIFNDSEVEX1JFU1RBUlQNCj4gPiA+IHRv
IGRvIHRoYXQgYWxyZWFkeS4NCj4gPiANCj4gPiBTb3JyeSBidXQgSSBkaXNhZ3JlZS4gSWYgU0NI
RURfUkVTVEFSVCBpcyBzZXQgdGhhdCBjYXVzZXMgdGhlIGJsay1tcSBjb3JlIHRvDQo+ID4gcmVl
eGFtaW5lIHRoZSBzb2Z0d2FyZSBxdWV1ZXMgYW5kIHRoZSBoY3R4IGRpc3BhdGNoIGxpc3QgYnV0
IG5vdCB0aGUgcmVxdWV1ZQ0KPiA+IGxpc3QuIElmIGEgYmxvY2sgZHJpdmVyIHJldHVybnMgQkxL
X1NUU19SRVNPVVJDRSB0aGVuIHJlcXVlc3RzIGVuZCB1cCBvbiB0aGUNCj4gPiByZXF1ZXVlIGxp
c3QuIEhlbmNlIHRoZSBmb2xsb3dpbmcgY29kZSBpbiBzY3NpX2VuZF9yZXF1ZXN0KCk6DQo+IA0K
PiBUaGF0IGRvZXNuJ3QgbmVlZCBTQ0hFRF9SRVNUQVJULCBiZWNhdXNlIGl0IGlzIHJlcXVldWUn
cw0KPiByZXNwb25zaWJpbGl0eSB0byBkbyB0aGF0LA0KPiBzZWUgYmxrX21xX3JlcXVldWVfd29y
aygpLCB3aGljaCB3aWxsIHJ1biBodyBxdWV1ZSBhdCB0aGUgZW5kIG9mIHRoaXMgZnVuYy4NCg0K
VGhhdCdzIG5vdCB3aGF0IEkgd2FzIHRyeWluZyB0byBleHBsYWluLiBXaGF0IEkgd2FzIHRyeWlu
ZyB0byBleHBsYWluIGlzIHRoYXQNCmV2ZXJ5IGJsb2NrIGRyaXZlciB0aGF0IGNhbiBjYXVzZSBh
IHJlcXVlc3QgdG8gZW5kIHVwIG9uIHRoZSByZXF1ZXVlIGxpc3QgaXMNCnJlc3BvbnNpYmxlIGZv
ciBraWNraW5nIHRoZSByZXF1ZXVlIGxpc3QgYXQgYSBsYXRlciB0aW1lLiBIZW5jZSB0aGUNCmti
bG9ja2Rfc2NoZWR1bGVfd29yaygmc2Rldi0+cmVxdWV1ZV93b3JrKSBjYWxsIGluIHRoZSBTQ1NJ
IGNvcmUgYW5kIHRoZQ0KYmxrX21xX2tpY2tfcmVxdWV1ZV9saXN0KCkgYW5kIGJsa19tcV9kZWxh
eV9raWNrX3JlcXVldWVfbGlzdCgpIGNhbGxzIGluIHRoZQ0KZG0gY29kZS4gV2hhdCBJIHdvdWxk
IGxpa2UgdG8gc2VlIGlzIG1lYXN1cmVtZW50IHJlc3VsdHMgZm9yIGRtLW1wYXRoIHdpdGhvdXQN
CnRoaXMgcGF0Y2ggc2VyaWVzIGFuZCBhIGNhbGwgdG8ga2ljayB0aGUgcmVxdWV1ZSBsaXN0IGFk
ZGVkIHRvIHRoZSBkbS1tcGF0aA0KZW5kX2lvIGNvZGUuDQoNCkJhcnQu
