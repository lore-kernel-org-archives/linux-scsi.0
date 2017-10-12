From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v8 09/10] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Thu, 12 Oct 2017 17:18:53 +0000
Message-ID: <1507828732.2448.42.camel@wdc.com>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
         <20171010210346.14574-10-bart.vanassche@wdc.com>
         <20171012160238.GC9275@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64062 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756464AbdJLRTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 13:19:11 -0400
In-Reply-To: <20171012160238.GC9275@ming.t460p>
Content-Language: en-US
Content-ID: <CA2F6C562325A0479C7EF9E2921ADAC3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>

T24gRnJpLCAyMDE3LTEwLTEzIGF0IDAwOjAyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBPY3QgMTAsIDIwMTcgYXQgMDI6MDM6NDVQTSAtMDcwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IFsgLi4uIF0NCj4gPiArCS8qIElmIHRoZSBTQ1NJIGRldmljZSBoYXMgYWxyZWFk
eSBiZWVuIHF1aWVzY2VkLCBkbyBub3RoaW5nLiAqLw0KPiA+ICsJaWYgKGJsa19zZXRfcHJlZW1w
dF9vbmx5KHEpKQ0KPiA+ICsJCXJldHVybiAwOw0KPiANCj4gTGFzdCB0aW1lLCBJIGhhdmUgbWVu
dGlvbmVkIHRoYXQgdGhpcyB3YXkgaXNuJ3Qgc2FmZSwgZXNwZWNpYWxseQ0KPiB0aGUgU0NTSSBk
b21haW4gY29tbWFuZCBjYW4gYmUgc2VudCBjb25jdXJyZW50bHksIGFsc28gdGhlcmUgbWlnaHQN
Cj4gYmUgaXNzdWUgd3J0LiBydW50aW1lIFBNIHZzLiBzeXN0ZW0gc3VzcGVuZC4NCj4gDQo+IFRo
ZSBpc3N1ZSBzaG91bGQgaGF2ZSBiZWVuIGF2b2lkZWQgc2ltcGx5IGJ5IHNldHRpbmcgdGhlIGZs
YWcNCj4gYW5kIGNvbnRpbnVlIHRvIGZyZWV6ZSBxdWV1ZS4NCg0KSSB0aGluayB0aGUgcG1fYXV0
b3NsZWVwX2xvY2soKSAvIHBtX2F1dG9zbGVlcF91bmxvY2soKSBjYWxscyBpbiB0aGUgcG93ZXIN
Cm1hbmFnZW1lbnQgY29kZSBwcmV2ZW50IHRoYXQgdGhlIHBvd2VyIG1hbmFnZW1lbnQgY29kZSBj
YW4gdHJpZ2dlcg0KY29uY3VycmVudCBzY3NpX2RldmljZV9xdWllc2NlKCkgY2FsbHMuDQoNCj4g
PiArDQo+ID4gKwlibGtfbXFfZnJlZXplX3F1ZXVlKHEpOw0KPiA+ICsJLyoNCj4gPiArCSAqIEVu
c3VyZSB0aGF0IHRoZSBlZmZlY3Qgb2YgYmxrX3NldF9wcmVlbXB0X29ubHkoKSB3aWxsIGJlIHZp
c2libGUNCj4gPiArCSAqIGZvciBwZXJjcHVfcmVmX3RyeWdldCgpIGNhbGxlcnMgdGhhdCBvY2N1
ciBhZnRlciB0aGUgcXVldWUNCj4gPiArCSAqIHVuZnJlZXplIGV2ZW4gaWYgdGhlIHF1ZXVlIHdh
cyBhbHJlYWR5IGZyb3plbiBiZWZvcmUgdGhpcyBmdW5jdGlvbg0KPiA+ICsJICogd2FzIGNhbGxl
ZC4gU2VlIGFsc28gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzU3MzQ5Ny8uDQo+ID4gKwkgKi8N
Cj4gPiArCXN5bmNocm9uaXplX3JjdSgpOw0KPiANCj4gTm8sIGl0IGlzIGEgYmFkIGlkZWEgdG8g
ZG8gdHdvIHN5bmNocm9uaXplX3JjdSgpIHdoaWNoIGNhbg0KPiBiZSB2ZXJ5IHNsb3csIGVzcGVj
aWFsbHkgaW4gYmlnIG1hY2hpbmUsIHRoaXMgd2F5IG1heSBzbG93IGRvd24NCj4gc3VzcGVuZCBt
dWNoLg0KDQpzY3NpX2RldmljZV9xdWllc2NlKCkgaXMgb25seSB1c2VkIGJ5IHRoZSBTQ1NJIHBv
d2VyIG1hbmFnZW1lbnQgY29kZSBhbmQgYnkNCnRoZSBTUEkgRFYgY29kZS4gVGhlIG51bWJlciBv
ZiB1c2VycyBvZiB0aGUgU0NTSSBwYXJhbGxlbCBjb2RlIGlzIHNtYWxsLiBBbmQNCnRoZSBTQ1NJ
IHBvd2VyIG1hbmFnZW1lbnQgY29kZSBpcyB1c2VkIG9uIGxhcHRvcHMgYnV0IG5vdCBvbiBiaWcg
bWFjaGluZXMuDQpBbnl3YXksIGlmIHlvdSByZWFsbHkgY2FyZSBhYm91dCB0aGlzIG9wdGltaXph
dGlvbiwgdGhhdCdzIHNvbWV0aGluZyB0aGF0IGNhbg0KYmUgZG9uZSBlYXNpbHkgYXMgYSBmb2xs
b3ctdXAgcGF0Y2guDQoNCkJhcnQu
