From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 03:28:53 +0000
Message-ID: <1487215718.2664.1.camel@sandisk.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
         <1487176942.2666.1.camel@sandisk.com>
         <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
         <1487207394.2666.14.camel@sandisk.com>
         <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:59383 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbdBPD3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 22:29:00 -0500
In-Reply-To: <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
Content-Language: en-US
Content-ID: <2AD48902FCBFB0429AD8109904082376@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

T24gVGh1LCAyMDE3LTAyLTE2IGF0IDExOjUyICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gVGhhbmtzIGZvciB0aGUgcG9pbnRlcnMuIEkgY2hlY2tlZCBsaWJpc2NzaSB0ZXN0cy4gQW5k
IGZyb20gd2hhdCBpcyBkb25lDQo+IHRoZXJlLCBpdCBzZWVtcyB0byBtZSB0aGF0IGl0IGlzIGJh
c2ljYWxseSBpbXBvc3NpYmxlIHRvIGRpc3Rpbmd1aXNoZWQNCj4gYmV0d2VlbiBhIGJ1Z2d5IGhh
cmR3YXJlIHJlc3BvbnNlIGFuZCBhbiBpbi1wdXJwb3NlIChvciBidWdneSkgbm90DQo+IGFsaWdu
ZWQgZGF0YS1vdXQgYnVmZmVyIHNpemUuDQo+IEUuZy4gdGhlIHRlc3QgaW4gdGVzdF93cml0ZTEw
X3Jlc2lkdWFscy5jIHdoaWNoIGlzc3VlcyBhIDEgYmxvY2sgd3JpdGUNCj4gd2l0aCBhIGJ1ZiBz
aXplIG9mIDEwMDAwIGFuZCBjaGVja3MgdGhhdCByZXNpZHVhbCBpcyAxMDAwMCAtIGJsb2NrIHNp
emUuDQo+IEZvciB0aGF0IGNhc2UsIHdpdGggYm90aCB0aGlzIHBhdGNoIGFuZCB0aGUgb3JpZ2lu
YWwgbXB0M3NhcyBwYXRjaCwgdGhlDQo+IHJvdW5kaW5nIHVwIG9mIHJlc2lkIHRvIHRoZSBibG9j
ayBzaXplIHdpbGwgYnJlYWsgdGhlIHRlc3QuDQo+IA0KPiBZZXQsIGl0IGlzIHZlcnkgc3VycHJp
c2luZyB0aGF0IExJTyBhbmQgU0NTVF9TQ1NJIGlzc3VlIHRoZSAiYnVnZ3kiDQo+IHJlcXVlc3Qg
YXMgaXMgd2l0aG91dCBjaGVja2luZyBhbmQgZXZlbnR1YWxseSBjb3JyZWN0aW5nIHRoaW5ncyBm
aXJzdC4NCj4gU28gdW5sZXNzIExJTyBhbmQgU0NTVF9TQ1NJIGFyZSBmaXhlZCB0byBkbyB0aGF0
IG9uIHRoZSByZXF1ZXN0IHRoZXkNCj4gc2VuZCB0byB0aGUgZGV2aWNlLCBib3RoIHBhdGNoZXMg
c2hvdWxkIGJlIGRyb3BwZWQuDQo+IFVzZXJzIHdpdGggYnVnZ3kgbXB0MyBIQkFzIHdpbGwgbmVl
ZCB0byB1cGRhdGUgdGhlIEhCQSBGVy4uLg0KPiANCj4gU28gdGhlIGNvbmNsdXNpb24gbWF5IGJl
IHRoYXQgd2UgbmVlZCB0byBkcm9wIGV2ZXJ5dGhpbmcgPyBUaGUgbXB0M3Nhcw0KPiBwYXRjaCBi
cmVha3MgWkJDIG5vdywgc28gdGhhdCBtdXN0IGJlIHJlbW92ZWQgdG9vLg0KDQpIZWxsbyBEYW1p
ZW4sDQoNCkZvciB0aGUgZXhhbXBsZSB5b3UgY2l0ZWQgKGJ1ZmZsZW4gLSByZXNpZHVhbCkgPSBi
bG9jayBzaXplLiBUaGlzIGlzDQp3aHkgSSBwcm9wb3NlZCB0byByb3VuZCAoYnVmZmxlbiAtIHJl
c2lkdWFsKSBpbnN0ZWFkIG9mIHJlc2lkdWFsLiBXaGV0aGVyDQpidWZmbGVuIG9yIChidWZmbGVu
IC0gcmVzaWR1YWwpIGlzIHJvdW5kZWQgZG9lc24ndCBtYXR0ZXIgaWYgYnVmZmxlbiBpcyBhDQpt
dWx0aXBsZSBvZiB0aGUgbG9naWNhbCBibG9jayBzaXplLiBCdXQgaXQgbWF0dGVycyBpZiBidWZm
bGVuIGlzIG5vdCBhDQptdWx0aXBsZSBvZiB0aGUgbG9naWNhbCBibG9jayBzaXplLg0KDQpCYXJ0
Lg==
