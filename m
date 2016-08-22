From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/7] aacraid: Use memdup_user() rather than duplicating
 its implementation
Date: Mon, 22 Aug 2016 18:00:28 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FA8E64@avsrvexchmbx1.microsemi.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
 <23c56a66-74a6-6033-f209-ac3e4ba83e61@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0062.outbound.protection.outlook.com ([104.47.33.62]:14109
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750892AbcHVSfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 14:35:12 -0400
In-Reply-To: <23c56a66-74a6-6033-f209-ac3e4ba83e61@users.sourceforge.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>

PiBGcm9tOiBNYXJrdXMgRWxmcmluZyA8ZWxmcmluZ0B1c2Vycy5zb3VyY2Vmb3JnZS5uZXQ+DQo+
IERhdGU6IFNhdCwgMjAgQXVnIDIwMTYgMjA6MDU6MjQgKzAyMDANCj4gDQo+IFJldXNlIGV4aXN0
aW5nIGZ1bmN0aW9uYWxpdHkgZnJvbSBtZW1kdXBfdXNlcigpIGluc3RlYWQgb2Yga2VlcGluZyBk
dXBsaWNhdGUNCj4gc291cmNlIGNvZGUuDQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBkZXRlY3RlZCBi
eSB1c2luZyB0aGUgQ29jY2luZWxsZSBzb2Z0d2FyZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1h
cmt1cyBFbGZyaW5nIDxlbGZyaW5nQHVzZXJzLnNvdXJjZWZvcmdlLm5ldD4NCj4gLS0tDQo+ICBk
cml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jIHwgMTIgKysrLS0tLS0tLS0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1jdHJsLmMgYi9kcml2ZXJzL3Njc2kvYWFj
cmFpZC9jb21tY3RybC5jDQo+IGluZGV4IDU2NDhiNzEuLjFhZjMwODQgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1jdHJsLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvY29tbWN0cmwuYw0KPiBAQCAtNTI2LDE1ICs1MjYsOSBAQCBzdGF0aWMgaW50IGFhY19z
ZW5kX3Jhd19zcmIoc3RydWN0IGFhY19kZXYqIGRldiwgdm9pZA0KPiBfX3VzZXIgKiBhcmcpDQo+
ICAgICAgICAgICAgICAgICBnb3RvIGNsZWFudXA7DQo+ICAgICAgICAgfQ0KPiANCj4gLSAgICAg
ICB1c2VyX3NyYmNtZCA9IGttYWxsb2MoZmlic2l6ZSwgR0ZQX0tFUk5FTCk7DQo+IC0gICAgICAg
aWYgKCF1c2VyX3NyYmNtZCkgew0KPiAtICAgICAgICAgICAgICAgZHByaW50aygoS0VSTl9ERUJV
RyJhYWNyYWlkOiBDb3VsZCBub3QgbWFrZSBhIGNvcHkgb2YgdGhlIHNyYlxuIikpOw0KPiAtICAg
ICAgICAgICAgICAgcmNvZGUgPSAtRU5PTUVNOw0KPiAtICAgICAgICAgICAgICAgZ290byBjbGVh
bnVwOw0KPiAtICAgICAgIH0NCj4gLSAgICAgICBpZihjb3B5X2Zyb21fdXNlcih1c2VyX3NyYmNt
ZCwgdXNlcl9zcmIsZmlic2l6ZSkpew0KPiAtICAgICAgICAgICAgICAgZHByaW50aygoS0VSTl9E
RUJVRyJhYWNyYWlkOiBDb3VsZCBub3QgY29weSBzcmIgZnJvbSB1c2VyXG4iKSk7DQo+IC0gICAg
ICAgICAgICAgICByY29kZSA9IC1FRkFVTFQ7DQo+ICsgICAgICAgdXNlcl9zcmJjbWQgPSBtZW1k
dXBfdXNlcih1c2VyX3NyYiwgZmlic2l6ZSk7DQo+ICsgICAgICAgaWYgKElTX0VSUih1c2VyX3Ny
YmNtZCkpIHsNCj4gKyAgICAgICAgICAgICAgIHJjb2RlID0gUFRSX0VSUih1c2VyX3NyYmNtZCk7
DQo+ICAgICAgICAgICAgICAgICBnb3RvIGNsZWFudXA7DQo+ICAgICAgICAgfQ0KPiANCj4gLS0N
Cg0KSGkgTWFya3VzLA0KDQpQYXRjaCAyLzcgc2hvdWxkIHByZWNlZGUgUGF0Y2ggMS83LCBhcyBm
YWxsaW5nIGludG8ga2ZyZWUoKSB3b3VsZCBub3QgbG9vayBwcmV0dHkuDQoNClRoYW5rcywgLURh
dmUNCg==
