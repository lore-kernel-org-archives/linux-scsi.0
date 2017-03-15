From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V3 2/3] hpsa: limit outstanding rescans
Date: Wed, 15 Mar 2017 17:32:30 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F33FB5A@avsrvexchmbx1.microsemi.net>
References: <148917802486.17050.17178463722401202189.stgit@brunhilda>
         <148917811749.17050.10796225321668028334.stgit@brunhilda>
 <1489598619.2387.22.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0086.outbound.protection.outlook.com ([104.47.36.86]:53783
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750988AbdCOTHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 15:07:10 -0400
In-Reply-To: <1489598619.2387.22.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Gerry Morong <gerry.morong@microsemi.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21h
aWx0bzpqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAx
NSwgMjAxNyAxMjoyNCBQTQ0KPiBUbzogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9zZW1pLmNv
bT47IGpvc2VwaC5zemN6eXBla0BocGUuY29tOw0KPiBHZXJyeSBNb3JvbmcgPGdlcnJ5Lm1vcm9u
Z0BtaWNyb3NlbWkuY29tPjsgSm9obiBIYWxsDQo+IDxKb2huLkhhbGxAbWljcm9zZW1pLmNvbT47
IEtldmluIEJhcm5ldHQNCj4gPGtldmluLmJhcm5ldHRAbWljcm9zZW1pLmNvbT47IE1haGVzaCBS
YWphc2hla2hhcmENCj4gPG1haGVzaC5yYWphc2hla2hhcmFAbWljcm9zZW1pLmNvbT47IEJhZGVy
IEFsaSAtIFNhbGVoDQo+IDxiYWRlci5hbGlzYWxlaEBtaWNyb3NlbWkuY29tPjsgaGNoQGluZnJh
ZGVhZC5vcmc7IFNjb3R0IFRlZWwNCj4gPHNjb3R0LnRlZWxAbWljcm9zZW1pLmNvbT47IFZpc3dh
cyBHIDx2aXN3YXMuZ0BtaWNyb3NlbWkuY29tPjsgSnVzdGluDQo+IExpbmRsZXkgPGp1c3Rpbi5s
aW5kbGV5QG1pY3Jvc2VtaS5jb20+OyBTY290dCBCZW5lc2gNCj4gPHNjb3R0LmJlbmVzaEBtaWNy
b3NlbWkuY29tPjsgUE9TV0FMREBzdXNlLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMyAyLzNdIGhwc2E6IGxpbWl0IG91dHN0YW5k
aW5nIHJlc2NhbnMNCj4gDQo+IEVYVEVSTkFMIEVNQUlMDQo+IA0KPiANCj4gT24gRnJpLCAyMDE3
LTAzLTEwIGF0IDE0OjM1IC0wNjAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+ID4gYXZvaWQgcmVzY2Fu
IHN0b3Jtcy4gTm8gbmVlZCB0byBxdWV1ZSBhbm90aGVyDQo+ID4gaWYgb25lIGlzIHBlbmRpbmcu
DQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogU2NvdHQgQmVuZXNoIDxzY290dC5iZW5lc2hAbWljcm9z
ZW1pLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogU2NvdHQgVGVlbCA8c2NvdHQudGVlbEBtaWNyb3Nl
bWkuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBUb21hcyBIZW56bCA8dGhlbnpsQHJlZGhhdC5jb20+
IHJldmlldw0KPiANCj4gR3V5cywgd2hhdCBpcyB0aGlzIGFkZGl0aW9uYWwgInJldmlldyIgZm9y
PyAgSSBqdXN0IG5vdGljZWQgYmVjYXVzZSBteQ0KPiByZXBseSBzY3JpcHRzIGJhcmZlZCBvbiBp
dC4gIFBsZWFzZSBkb24ndCBhZGQgZXh0cmEganVuayBhZnRlciBhbiBlbWFpbA0KPiBhZGRyZXNz
IGluIGEgdGFnIGxpbmUuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBKYW1lcw0KDQpNeSBiYWQuIEkn
bGwgc2VuZCB1cCBhIFY0Lg0KU29ycnkgYWJvdXQgdGhhdC4NCg0KVGhhbmtzLA0KRG9uIEJyYWNl
DQpFU0MgLSBTbWFydCBTdG9yYWdlDQpNaWNyb3NlbWkgQ29ycG9yYXRpb24NCg0KDQo=
