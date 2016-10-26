From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Wed, 26 Oct 2016 16:15:22 +0000
Message-ID: <1477498520.2550.1.camel@sandisk.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
         <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
         <1477434237.3079.84.camel@linux.vnet.ibm.com>
         <1477437481.2385.7.camel@sandisk.com>
         <1477439413.3079.101.camel@linux.vnet.ibm.com>
         <e3531f72-596e-359c-93bd-3855291d7ba0@sandisk.com>
         <1477497160.2724.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0076.outbound.protection.outlook.com ([104.47.33.76]:11920
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754302AbcJZQPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 12:15:35 -0400
In-Reply-To: <1477497160.2724.11.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <3F1DBF8EB38A1044A0712D58447E27A8@namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "gabriel@krisman.be" <gabriel@krisman.be>

T24gV2VkLCAyMDE2LTEwLTI2IGF0IDA4OjUyIC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIFdlZCwgMjAxNi0xMC0yNiBhdCAwODo0MiAtMDcwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IENhbiB5b3UgZWxhYm9yYXRlIG9uIHRoaXM/IFNpbmNlIHRoZSBzZW5zZSBidWZm
ZXIgaXMgYXZhaWxhYmxlIGluwqANCj4gPiBzY3NpX2lvX2NvbXBsZXRpb24oKSBhbmQgc2luY2Ug
dGhhdCBmdW5jdGlvbiBhbHJlYWR5IGNhbGxzwqANCj4gPiBzY3NpX2NvbW1hbmRfbm9ybWFsaXpl
X3NlbnNlKCkgdGhpcyBmdW5jdGlvbiBzZWVtcyBsaWtlIGEgZ29vZMKgDQo+ID4gY2FuZGlkYXRl
IHRvIG1lIHRvIGFkZCByZXRyeSBsb2dpYyBmb3IgUkVRX1RZUEVfQkxPQ0tfUEMgcmVxdWVzdHMu
DQo+IA0KPiBVQXMgYXJlIHVzZWQgdG8gc2lnbmFsIEFFTnMgdG8gdXNlcnNwYWNlIGNvbnRyb2wg
cHJvY2Vzc2VzIHRoYXQgdXNlDQo+IEJMT0NLX1BDLCBsaWtlIENEIGNoYW5nZXJzLCBidXJuZXJz
IGFuZCBzY2FubmVycy7CoMKgSWYgd2UgZWF0IFVBcw0KPiBpbnNpZGUgc2NzaV9pb19jb21wbGV0
aW9uKCksIHdlIGNvdWxkIHBvdGVudGlhbGx5IGJyZWFrIGFueSB1c2Vyc3BhY2UNCj4gY29udHJv
bCBzeXN0ZW0gdGhhdCByZWxpZXMgb24gQUVOcy4NCg0KSWdub3JpbmcgdGhlIFNDU0kgZXJyb3Ig
aGFuZGxlciwgdGhlIGNhbGwgc2VxdWVuY2UgZm9yIHJlcG9ydGluZyBVQXMgdG8NCnVzZXIgc3Bh
Y2UgaXMgYXMgZm9sbG93czogc2NzaV9zb2Z0aXJxX2RvbmUoKSAtPg0Kc2NzaV9kZWNpZGVfZGlz
cG9zaXRpb24oKSAtPiBzY3NpX2NoZWNrX3NlbnNlKCkgLT4gc2NzaV9yZXBvcnRfc2Vuc2UoKS4N
ClRoaXMgbWVhbnMgdGhhdCBzY3NpX3JlcG9ydF9zZW5zZSgpIGlzIGNhbGxlZCBiZWZvcmUNCnNj
c2lfaW9fY29tcGxldGlvbigpIGlzIGNhbGxlZC4gSSB0aGluayB0aGlzIG1lYW5zIHRoYXQgd2hh
dA0Kc2NzaV9pb19jb21wbGV0aW9uKCkgZGVjaWRlcyBjYW5ub3QgYWZmZWN0IFVBIHJlcG9ydGlu
ZyB0byB1c2VyIHNwYWNlPw0KDQpCYXJ0Lg==
