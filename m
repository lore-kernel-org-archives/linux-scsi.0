From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sun, 1 Jan 2017 14:22:11 +0000
Message-ID: <1483280506.5512.1.camel@sandisk.com>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
         <20161229080250.GA11605@infradead.org>
         <1483226343.2518.32.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0089.outbound.protection.outlook.com ([104.47.33.89]:8914
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754991AbdAAOWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Jan 2017 09:22:21 -0500
In-Reply-To: <1483226343.2518.32.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <4FB5EA17D8535C4DA4CE240D192FBA4B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>, "jbaron@akamai.com" <jbaron@akamai.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "davem@davemloft.net" <davem@davemloft.net>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "dledford@redhat.com" <dledford@redhat.com>

T24gU2F0LCAyMDE2LTEyLTMxIGF0IDE1OjE5IC0wODAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIFRodSwgMjAxNi0xMi0yOSBhdCAwMDowMiAtMDgwMCwgQ2hyaXN0b3BoIEhlbGx3aWcg
d3JvdGU6DQo+ID4gT24gV2VkLCBEZWMgMjgsIDIwMTYgYXQgMTE6MzA6MjRQTSAtMDUwMCwgSmFz
b24gQmFyb24gd3JvdGU6DQo+ID4gPiBBZGQgYSBuZXcgcGFyYW1ldGVyIHRvIHNjc2lfaW50ZXJu
YWxfZGV2aWNlX2Jsb2NrKCkgdG8gZGVjaWRlIA0KPiA+ID4gd2hldGhlciBvciBub3QgdG8gaW52
b2tlIHNjc2lfd2FpdF9mb3JfcXVldWVjb21tYW5kKCkuDQo+ID4gDQo+ID4gV2UnbGwgYWxzbyBu
ZWVkIHRvIGRlYWwgd2l0aCB0aGUgYmxrLW1xIHdhaXQgcGF0aCB0aGF0IEJhcnQgaGFzIGJlZW4N
Cj4gPiB3b3JraW5nIG9uIChJIHRoaW5rIGl0J3MgYWxyZWFkeSBpbiB0aGUgc2NzaSB0cmVlLCBi
dXQgSSdkIGhhdmUgdG8NCj4gPiBjaGVjaykuDQo+ID4gDQo+ID4gQWxzbyBhZGRpbmcgYSBib29s
IGZsYWcgZm9yIHRoZSBsYXN0IGNhbGwgaW4gYSBmdW5jdGlvbiBpcyBzdHlsZSANCj4gPiB0aGF0
J3MgYSBsaXR0bGUgYW5ub3lpbmcuDQo+ID4gDQo+ID4gSSdkIHByZWZlciB0byBhZGQgYSBzY3Np
X2ludGVybmFsX2RldmljZV9ibG9ja19ub3dhaXQgdGhhdCBjb250YWlucw0KPiA+IGFsbCB0aGUg
Y29kZSBleGNlcHQgZm9yIHRoZSB3YWl0aW5nLCBhbmQgdGhlbiBtYWtlDQo+ID4gc2NzaV9pbnRl
cm5hbF9kZXZpY2VfYmxvY2tfbm93YWl0IGEgd3JhcHBlciBhcm91bmQgaXQuICBPciBkcm9wIHRo
ZQ0KPiA+IGFubm95aW5nIGludGVybmFsIGZvciBib3RoIHdoaWxlIHdlJ3JlIGF0IGl0IDopDQo+
IA0KPiBPSywgSSBrbm93IGl0J3MgbmV3IHllYXIsIGJ1dCB0aGlzIGlzIGFuIHVucGF0Y2hlZCBy
ZWdyZXNzaW9uIGluIC1yYzENCj4gdGhhdCdzIGNhdXNpbmcgc2VyaW91cyBpc3N1ZXMuICBJIHdv
dWxkIGxpa2UgdGhpcyBmaXhlZCBieSAtcmMzIHNvIHdlDQo+IGhhdmUgMyBvcHRpb25zDQo+IA0K
PiAgICAxLiByZXZlcnQgYWxsIHRoZSBxdWV1ZWNvbW1hbmQgd2FpdCBzdHVmZiB1bnRpbCBpdCBw
cm92ZXMgaXQncyBhY3R1YWxseQ0KPiAgICAgICB3b3JraW5nIHdpdGhvdXQgcmVncmVzc2lvbnMN
Cj4gICAgMi4gYXBwbHkgdGhpcyBwYXRjaCBhbmQgZml4IHRoZSBzdHlsZSBpc3N1ZXMgbGF0ZXIN
Cj4gICAgMy4gc29tZW9uZSBlbHNlIHN1cHBsaWVzIHRoZSBjb3JyZWN0bHkgc3R5bGVkIGZpeCBw
YXRjaA0KPiANCj4gVGhlIGNvbnNlcnZhdGl2ZSBpbiBtZSBzYXlzIHRoYXQgMS4gaXMgcHJvYmFi
bHkgdGhlIG1vc3QgY29ycmVjdCB0aGluZw0KPiB0byBkbyBiZWNhdXNlIGl0IGdpdmVzIHVzIHRp
bWUgdG8gZ2V0IHRoZSBxdWV1ZWNvbW1hbmQgd2FpdCBzdHVmZg0KPiByaWdodDsgdGhhdCdzIHdo
YXQgSSdsbCBwcm9iYWJseSBkbyBpZiB0aGVyZSdzIG5vIG1vdmVtZW50IG5leHQgd2Vlay4gDQo+
ICBIb3dldmVyLCBzaW5jZSB3ZSdyZSByZWFzb25hYmx5IGVhcmx5IGluIHRoZSAtcmMgY3ljbGUs
IHNvIGVpdGhlciAyIG9yDQo+IDMgYXJlIHZpYWJsZSBwcm92aWRlZCBubyBmdXJ0aGVyIHJlZ3Jl
c3Npb25zIGNhdXNlZCBieSB0aGUgcXVldWVjb21tYW5kDQo+IHdhaXQgc3R1ZmYgcG9wIHVwLg0K
DQpIZWxsbyBKYW1lcywNCg0KTXkgcmVjb21tZW5kYXRpb24gaXMgdG8gcmV2ZXJ0IGNvbW1pdCAx
OGY2MDg0YTk4OWIgKCJzY3NpOiBtcHQzc2FzOiBGaXgNCnNlY3VyZSBlcmFzZSBwcmVtYXR1cmUg
dGVybWluYXRpb24iKS4gU2luY2UgdGhlIG1wdDNzYXMgZHJpdmVyIHVzZXMgdGhlDQpzaW5nbGUt
cXVldWUgYXBwcm9hY2ggYW5kIHNpbmNlIHRoZSBTQ1NJIGNvcmUgdW5sb2NrcyB0aGUgYmxvY2sg
bGF5ZXINCnJlcXVlc3QgcXVldWUgbG9jayBiZWZvcmUgdGhlIC5xdWV1ZWNvbW1hbmQgY2FsbGJh
Y2sgZnVuY3Rpb24gaXMgY2FsbGVkLA0KbXVsdGlwbGUgdGhyZWFkcyBjYW4gZXhlY3V0ZSB0aGF0
IGNhbGxiYWNrIGZ1bmN0aW9uIChzY3NpaF9xY21kKCkgaW4gdGhpcw0KY2FzZSkgc2ltdWx0YW5l
b3VzbHkuIFRoaXMgbWVhbnMgdGhhdCB1c2luZyBzY3NpX2ludGVybmFsX2RldmljZV9ibG9jaygp
DQpmcm9tIGluc2lkZSAucXVldWVjb21tYW5kIHRvIHNlcmlhbGl6ZSBTQ1NJIGNvbW1hbmQgZXhl
Y3V0aW9uIGlzIHdyb25nLg0KDQpCYXJ0Lg==
