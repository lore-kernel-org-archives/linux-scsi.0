From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Mon, 28 Aug 2017 02:02:29 +0000
Message-ID: <AT5PR84MB0308DD95D77323F7FF9D9F55FD9E0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
         <20170823214009.15015-8-bart.vanassche@wdc.com>
         <20170824090718.GG19886@lst.de> <1503593651.2702.16.camel@wdc.com>
         <AT5PR84MB0308689A9E2AA2461DEB35A0FD9B0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
 <1503691451.2680.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:42084 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdH1CCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2017 22:02:32 -0400
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 5B7D6613CD
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2017 02:02:32 +0000 (UTC)
In-Reply-To: <1503691451.2680.16.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

PiBIZWxsbyBTaGFuZSwNCj4gDQo+IFlvdSBoYXZlIGVpdGhlciBtaXNpbnRlcnByZXQgbXkgc3Rh
dGVtZW50IG9yIHRoZSBTQ1NJIFZQRCBoYW5kbGluZyBjb2RlLiBJZg0KPiB5b3UgaGF2ZSBhIGxv
b2sgYXQgdGhlIFNDU0kgVlBEIGhhbmRsaW5nIGNvZGUgeW91IHdpbGwgc2VlIHRoYXQgYW4NCj4g
cmN1X3JlYWRfbG9jaygpIC8NCj4gcmN1X3JlYWRfdW5sb2NrKCkgcGFpciBpcyBzdWZmaWNpZW50
IHRvIHByZXZlbnQgdGhhdCB0aGUgVlBEIGJ1ZmZlcg0KPiByY3VfZGVyZWZlcmVuY2UoKSBwb2lu
dHMgYXQgaXMgYmVpbmcgbW9kaWZpZWQgYXMgbG9uZyBhcyB0aGUgUkNVIHJlYWQgbG9jayBpcw0K
PiBoZWxkLCBhdCBsZWFzdCBpZg0KPiByY3VfZGVyZWZlcmVuY2UoKSBpcyBvbmx5IGNhbGxlZCBv
bmNlLiBUaGUgdXBkYXRlIHNpZGUgbmFtZWx5IGRvZXMgbm90DQo+IG1vZGlmeSB0aGUgVlBEIGJ1
ZmZlciBhZnRlciB0aGUgcG9pbnRlciB0byB0aGF0IGJ1ZmZlciBoYXMgYmVlbiBwdWJsaXNoZWQu
DQoNCkhpIEJhcnQsDQoNCkknbSBwcmV0dHkgc3VyZSBJIHVuZGVyc3Rvb2QgdGhlIGNvZGUuIE15
IG1haW4gcG9pbnQgd2FzIHRoYXQgdGhlIG9ubHkgdGhpbmcgdGhhdCBSQ1UgZ3VhcmFudGVlcyB3
aXRoIGNvZGUgaW4gYmV0d2VlbiByY3VfcmVhZF9sb2NrKCkvcmN1X3JlYWRfdW5sb2NrKCkgaWYg
eW91IGRlcmVmZXJlbmNlIGFuIFJDVSBwb2ludGVyIHVzaW5nIHJjdV9kZXJlZmVyZW5jZSgpIGlz
IHRoYXQgdGhlIG1lbW9yeSB0aGF0IHRoZSBwb2ludGVyIHJldHVybmVkIHBvaW50cyB0byB3b24n
dCBiZSBmcmVlZCBhbmQgd2lsbCBiZSB2YWxpZCByZWdhcmRsZXNzIG9mIGlmIHlvdSBnZXQgdGhl
IG5ldyBvciBvbGQgcG9pbnRlci4gQW55dGhpbmcgcmVsYXRlZCB0byB0aGUgYWN0dWFsIGNvbnRl
bnRzIG9mIHdoYXQgdGhlIHBvaW50ZXIgcG9pbnRzIHRvIGlzIGNvZGUgc3BlY2lmaWMgaW4gcmVn
YXJkIHRvIHdoYXQgaGFwcGVucyB0byBpdC4NCg0KQXMgQ2hyaXN0b3BoIHBvaW50ZWQgb3V0ICh3
aGljaCBJIGZhaWxlZCB0byBjb25zaWRlciBmdWxseSkgYnkgZG9pbmcgYSBkaXJlY3Qga2ZyZWUg
aW4gc2NzaV9kZXZpY2VfZGV2X3JlbGVhc2VfdXNlcmNvbnRleHQoKSB3aXRob3V0IGEgY2FsbCB0
byBzeW5jaHJvbml6ZV9yY3UoKSBpZiB5b3UgaGFkIHNvbWUgY29kZSB0aGF0IHRoYXQgZ290IG9u
ZSBvZiB0aGUgUkNVIHBvaW50ZXJzIGluIGEgcmVhZC1zaWRlIGNyaXRpY2FsIHNlY3Rpb24gYW5k
IGZvciBzb21lIHJlYXNvbiBzY3NpX2RldmljZV9kZXZfcmVsZWFzZV91c2VyY29udGV4dCgpIGdv
dCBjYWxsZWQgeW91IGNvdWxkIG5vdyBoYXZlIGFuIGludmFsaWQgcG9pbnRlciB3aGVuIFJDVSBt
YWtlcyBhIGd1YXJhbnRlZSB0aGF0IGl0IG11c3QgYmUgdmFsaWQuIFRoYXQncyB3aGF0IEkgYmVs
aWV2ZSBDaHJpc3RvcGggd2FzIGRpc2N1c3NpbmcgaW4gaGlzIHJlcGx5IHRvIG15IGVtYWlsLg0K
DQo+IFN3aXRjaGluZyB0byBrZnJlZV9yY3UoKSByZXF1aXJlcyBtb3JlIGNoYW5nZXMgYmVjYXVz
ZSBhbGwgdW5zaWduZWQgY2hhcg0KPiBwb2ludGVycyB0byBWUEQgZGF0YSBoYXZlIHRvIGJlIGNv
bnZlcnRlZCBpbnRvIHBvaW50ZXJzIHRvIGEgc3RydWN0dXJlIHRoYXQNCj4gY29udGFpbnMgdGhl
IFZQRCBkYXRhIGFuZCB0aGUgUkNVIGhlYWQuIEFueXdheSwgSSB3aWxsIGNvbnZlcnQgdGhlIGtm
cmVlKCkNCj4gY2FsbHMgdG8gUkNVIHBvaW50ZXJzIGludG8ga2ZyZWVfcmN1KCkgcG9pbnRlcnMu
DQo+IA0KDQpUaGFua3MsIEkgYXBwcmVjaWF0ZSB5b3UgdGFraW5nIHRoZSBjb21tZW50cyBvbmJv
YXJkLiBJJ3ZlIGJlZW4gbG9va2luZyBhdCB0aGUgbmV3IHBhdGNoZXMgdG9kYXkgYW5kIHNob3Vs
ZCBwb3N0IHNvbWV0aGluZyBiYWNrIGJ5IHRoZSBlbmQgb2YgbXkgZGF5IHRvZGF5Lg0KDQpTaGFu
ZQ0K
