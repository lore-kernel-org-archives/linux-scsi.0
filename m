From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 1/7] smartpqi: add pqi reset quiesce support
Date: Thu, 17 Aug 2017 15:15:01 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8D0FE6@avsrvexchmbx2.microsemi.net>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
         <150239079917.23771.5169713749423377610.stgit@brunhilda>
 <1502941453.3589.22.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0056.outbound.protection.outlook.com ([104.47.34.56]:3680
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdHQPP0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Aug 2017 11:15:26 -0400
In-Reply-To: <1502941453.3589.22.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Gerry Morong <gerry.morong@microsemi.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21h
aWx0bzpqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3Qg
MTYsIDIwMTcgMTA6NDQgUE0NCj4gVG86IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1pY3Jvc2VtaS5j
b20+OyBqb3NlcGguc3pjenlwZWtAaHBlLmNvbTsNCj4gR2VycnkgTW9yb25nIDxnZXJyeS5tb3Jv
bmdAbWljcm9zZW1pLmNvbT47IEpvaG4gSGFsbA0KPiA8Sm9obi5IYWxsQG1pY3Jvc2VtaS5jb20+
OyBLZXZpbiBCYXJuZXR0DQo+IDxrZXZpbi5iYXJuZXR0QG1pY3Jvc2VtaS5jb20+OyBNYWhlc2gg
UmFqYXNoZWtoYXJhDQo+IDxtYWhlc2gucmFqYXNoZWtoYXJhQG1pY3Jvc2VtaS5jb20+OyBCYWRl
ciBBbGkgLSBTYWxlaA0KPiA8YmFkZXIuYWxpc2FsZWhAbWljcm9zZW1pLmNvbT47IGhjaEBpbmZy
YWRlYWQub3JnOyBTY290dCBUZWVsDQo+IDxzY290dC50ZWVsQG1pY3Jvc2VtaS5jb20+OyBWaXN3
YXMgRyA8dmlzd2FzLmdAbWljcm9zZW1pLmNvbT47IEp1c3Rpbg0KPiBMaW5kbGV5IDxqdXN0aW4u
bGluZGxleUBtaWNyb3NlbWkuY29tPjsgU2NvdHQgQmVuZXNoDQo+IDxzY290dC5iZW5lc2hAbWlj
cm9zZW1pLmNvbT47IFBPU1dBTERAc3VzZS5jb20NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS83XSBzbWFydHBxaTogYWRkIHBxaSByZXNl
dCBxdWllc2NlIHN1cHBvcnQNCj4gDQo+IEVYVEVSTkFMIEVNQUlMDQo+IA0KPiANCj4gT24gVGh1
LCAyMDE3LTA4LTEwIGF0IDEzOjQ2IC0wNTAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+ID4gRnJvbTog
S2V2aW4gQmFybmV0dCA8a2V2aW4uYmFybmV0dEBtaWNyb3NlaW0uY29tPg0KPiANCj4gVG8gbWlz
c3BlbGwgc29tZW9uZSBlbHNlJ3MgY29tcGFueSBuYW1lIGNvdWxkIGJlIGNvbnNpZGVyZWQgdW5m
b3J0dW5hdGUNCj4gLi4uIHRvIG1pc3NwZWxsIHlvdXIgb3duIGxvb2tzIGxpa2UgY2FyZWxlc3Nu
ZXNzLg0KPiANCj4gWW91J3ZlIGRvbmUgdGhpcyB0d2ljZSwgYnkgdGhlIHdheS4NCj4gDQo+IEph
bWVzDQo+IA0KPiA+IFJldmlld2VkLWJ5OiBTY290dCBCZW5lc2ggPHNjb3R0LmJlbmVzaEBtaWNy
b3NlbWkuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEtldmluIEJhcm5ldHQgPGtldmluLmJhcm5l
dHRAbWljcm9zZW1pLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBEb24gQnJhY2UgPGRvbi5icmFj
ZUBtaWNyb3NlbWkuY29tPg0KDQpUaGF0J3MgbXkgYmFkLiBJJ2xsIGJlIG1vcmUgY2FyZWZ1bCBp
biB0aGUgZnV0dXJlLg0KDQpUaGFua3MsDQpEb24gQnJhY2UNCg0KRVNDIC0gU21hcnQgU3RvcmFn
ZQ0KTWljcm9zZW1pIENvcnBvcmF0aW9uDQoNCg0K
