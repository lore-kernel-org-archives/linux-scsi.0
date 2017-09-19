From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 23:25:47 +0000
Message-ID: <1505863546.2671.55.camel@wdc.com>
References: <1505498249.3420.15.camel@wdc.com>
         <20170917124000.GB6289@ming.t460p> <1505747894.2685.6.camel@wdc.com>
         <20170919054308.GA2517@ming.t460p> <1505835394.2671.18.camel@wdc.com>
         <20170919155603.GB22809@redhat.com> <20170919160401.GC19830@ming.t460p>
         <1505839754.2671.42.camel@wdc.com>
         <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
         <1505846549.2671.52.camel@wdc.com> <20170919224410.GA21829@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:50420 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdISXZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 19:25:51 -0400
In-Reply-To: <20170919224410.GA21829@ming.t460p>
Content-Language: en-US
Content-ID: <13C2EA50845865459AF92EAA58C57B5A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gV2VkLCAyMDE3LTA5LTIwIGF0IDA2OjQ0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gRm9y
IHRoaXMgaXNzdWUsIGl0IGlzbid0IHNhbWUgYmV0d2VlbiBTQ1NJIGFuZCBkbS1ycS4NCj4gDQo+
IFdlIGRvbid0IG5lZWQgdG8gcnVuIHF1ZXVlIGluIC5lbmRfaW8gb2YgZG0sIGFuZCB0aGUgdGhl
b3J5IGlzDQo+IHNpbXBsZSwgb3RoZXJ3aXNlIGl0IGlzbid0IHBlcmZvcm1hbmNlIGlzc3VlLCBh
bmQgc2hvdWxkIGJlIEkvTyBoYW5nLg0KPiANCj4gMSkgZXZlcnkgZG0tcnEncyByZXF1ZXN0IGlz
IDE6MSBtYXBwZWQgdG8gU0NTSSdzIHJlcXVlc3QNCj4gDQo+IDIpIGlmIHRoZXJlIGlzIGFueSBt
YXBwZWQgU0NTSSByZXF1ZXN0IG5vdCBmaW5pc2hlZCwgZWl0aGVyDQo+IGluLWZsaWdodCBvciBp
biByZXF1ZXVlIGxpc3Qgb3Igd2hhdGV2ZXIsIHRoZXJlIHdpbGwgYmUgb25lDQo+IGNvcnJlc3Bv
bmRpbmcgZG0tcnEncyByZXF1ZXN0IGluLWZsaWdodA0KPiANCj4gMykgb25jZSB0aGUgbWFwcGVk
IFNDU0kgcmVxdWVzdCBpcyBjb21wbGV0ZWQsIGRtLXJxJ3MgY29tcGxldGlvbg0KPiBwYXRoIHdp
bGwgYmUgdHJpZ2dlcmVkIGFuZCBkbS1ycSdzIHF1ZXVlIHdpbGwgYmUgcmVydW4gYmVjYXVzZSBv
Zg0KPiBTQ0hFRF9SRVNUQVJUIGluIGRtLXJxDQo+IA0KPiBTbyB0aGUgaHcgcXVldWUgb2YgZG0t
cnEgaGFzIGJlZW4gcnVuIGluIGRtLXJxJ3MgY29tcGxldGlvbiBwYXRoDQo+IGFscmVhZHksIHJp
Z2h0PyBXaHkgZG8gd2UgbmVlZCB0byBkbyBpdCBhZ2FpbiBpbiB0aGUgaG90IHBhdGg/DQoNClRo
ZSBtZWFzdXJlbWVudCBkYXRhIGluIHRoZSBkZXNjcmlwdGlvbiBvZiBwYXRjaCA1LzUgc2hvd3Mg
YSBzaWduaWZpY2FudA0KcGVyZm9ybWFuY2UgcmVncmVzc2lvbiBmb3IgYW4gaW1wb3J0YW50IHdv
cmtsb2FkLCBuYW1lbHkgcmFuZG9tIEkvTy4NCkFkZGl0aW9uYWxseSwgdGhlIHBlcmZvcm1hbmNl
IGltcHJvdmVtZW50IGZvciBzZXF1ZW50aWFsIEkvTyB3YXMgYWNoaWV2ZWQNCmZvciBhbiB1bnJl
YWxpc3RpY2FsbHkgbG93IHF1ZXVlIGRlcHRoLiBTb3JyeSBidXQgZ2l2ZW4gdGhlc2UgbWVhc3Vy
ZW1lbnQNCnJlc3VsdHMgSSBkb24ndCBzZWUgd2h5IEkgc2hvdWxkIHNwZW5kIG1vcmUgdGltZSBv
biB0aGlzIHBhdGNoIHNlcmllcy4NCg0KQmFydC4=
