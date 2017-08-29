From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: Fix command send race condition
Date: Tue, 29 Aug 2017 21:21:41 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B4055A7@avsrvexchmbx1.microsemi.net>
References: <a765104e-3574-08f4-2667-78b59c8da27c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0084.outbound.protection.outlook.com ([104.47.37.84]:29660
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751275AbdH2VVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 17:21:45 -0400
In-Reply-To: <a765104e-3574-08f4-2667-78b59c8da27c@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Miller <dougmill@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "stable@kernel.org" <stable@kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmlhbiBLaW5nIFttYWlsdG86
YnJraW5nQGxpbnV4LnZuZXQuaWJtLmNvbV0NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDI5LCAy
MDE3IDk6MDAgQU0NCj4gDQo+IFRoaXMgZml4ZXMgYSBwb3RlbnRpYWwgcmFjZSBjb25kaXRpb24g
b2JzZXJ2ZWQgb24gUG93ZXIgc3lzdGVtcy4NCj4gU2V2ZXJhbCBwbGFjZXMgdGhyb3VnaG91dCB0
aGUgYWFjcmFpZCBkcml2ZXIgY2FsbCBhYWNfZmliX3NlbmQgb3Igc2ltaWxhciB0byBzZW5kDQo+
IGEgY29tbWFuZCB0byB0aGUgYWFjcmFpZCBhZGFwdGVyLCB0aGVuIGNoZWNrIHRoZSByZXR1cm4g
Y29kZSB0byBkZXRlcm1pbmUgaWYNCj4gdGhlIGNvbW1hbmQgd2FzIGFjdHVhbGx5IHNlbnQgdG8g
dGhlIGFkYXB0ZXIsIHRoZW4gdXBkYXRlIHRoZSBwaGFzZSBmaWVsZCBpbg0KPiB0aGUgc2NzaSBj
b21tYW5kIHNjcmF0Y2ggcGFkIGFyZWEgdG8gdHJhY2sgdGhhdCB0aGUgZmlybXdhcmUgbm93IG93
bnMgdGhpcw0KPiBjb21tYW5kLg0KPiBIb3dldmVyLCB0aGVyZSBpcyBub3RoaW5nIHRoYXQgZW5z
dXJlcyB0aGF0IGJ5IHRoZSB0aW1lIHRoZSBhYWNfZmliX3NlbmQNCj4gZnVuY3Rpb24gcmV0dXJu
cyBhbmQgd2UgZ28gdG8gd3JpdGUgdG8gdGhlIHNjc2kgY29tbWFuZCwgdGhhdCB0aGUgY29tbWFu
ZA0KPiBoYXNuJ3QgYWxyZWFkeSBjb21wbGV0ZWQgYW5kIHRoZSBzY3NpIGNvbW1hbmQgaGFzIGJl
ZW4gZnJlZWQuDQo+IFRoaXMgd2FzIGNhdXNpbmcgcmFuZG9tIGNyYXNoZXMgaW4gdGhlIFRDUCBz
dGFjayB3aGljaCB3YXMgdHJhY2tlZCBkb3duIHRvIGJlDQo+IGNhdXNlZCBieSBtZW1vcnkgdGhh
dCBoYWQgYmVlbiBhIHN0cnVjdCByZXF1ZXN0ICsgc2NzaV9jbW5kIGJlaW5nIG5vdyB1c2VkDQo+
IGZvciBhbiBza2J1ZmYuIE1lbW9yeSBwb2lzb25pbmcgd2FzIGVuYWJsZWQgaW4gdGhlIGtlcm5l
bCB0byBkZWJ1ZyB0aGlzIHdoaWNoDQo+IHNob3dlZCB0aGF0IHRoZSBsYXN0IG93bmVyIG9mIHRo
ZSBtZW1vcnkgdGhhdCBoYWQgYmVlbiBmcmVlZCB3YXMgYWFjcmFpZCBhbmQNCj4gdGhhdCBpdCB3
YXMgYSBzdHJ1Y3QgcmVxdWVzdC4NCj4gVGhlIG1lbW9yeSB0aGF0IHdhcyBjb3JydXB0ZWQgd2Fz
IHRoZSBleGFjdCBkYXRhIHBhdHRlcm4gb2YNCj4gQUFDX09XTkVSX0ZJUk1XQVJFIGFuZCBpdCB3
YXMgYXQgdGhlIHNhbWUgb2Zmc2V0IHRoYXQgYWFjcmFpZCB3cml0ZXMsDQo+IHdoaWNoIGlzIHNj
c2ljbWQtPlNDcC5waGFzZS4gVGhlIHBhdGNoIGJlbG93IHJlc29sdmVzIHRoaXMgaXNzdWUuDQo+
IA0KPiBDYzogc3RhYmxlPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6
IEJyaWFuIEtpbmcgPGJya2luZ0BsaW51eC52bmV0LmlibS5jb20+DQo+IC0tLQ0KPiANClJldmll
d2VkLWJ5OiBEYXZlIENhcnJvbGwgPGRhdmlkLmNhcnJvbGxAbWljcm9zZW1pLmNvbT4NCg0K
