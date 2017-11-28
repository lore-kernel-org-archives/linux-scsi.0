From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 22:09:07 +0000
Message-ID: <1511906943.28512.28.camel@wdc.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
         <20171128193503.13695-15-himanshu.madhani@cavium.com>
         <1511898300.28512.20.camel@wdc.com>
         <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3745 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdK1WJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 17:09:09 -0500
In-Reply-To: <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
Content-Language: en-US
Content-ID: <5601F444FD70E049A71F8142406B0C1E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Himanshu.Madhani@cavium.com" <Himanshu.Madhani@cavium.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gVHVlLCAyMDE3LTExLTI4IGF0IDIxOjM4ICswMDAwLCBNYWRoYW5pLCBIaW1hbnNodSB3cm90
ZToNCj4gSGkgQmFydCwgDQo+IA0KPiA+IE9uIE5vdiAyOCwgMjAxNywgYXQgMTE6NDUgQU0sIEJh
cnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4g
T24gVHVlLCAyMDE3LTExLTI4IGF0IDExOjM0IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiA+ID4gRnJvbTogUXVpbm4gVHJhbiA8cXVpbm4udHJhbkBjYXZpdW0uY29tPg0KPiA+IA0K
PiA+IE5lc3Rpbmcgc3BpbmxvY2tzIGlzIGFsbG93ZWQgc28gSSB0aGluayBhIG1vcmUgZGV0YWls
ZWQgZGVzY3JpcHRpb24NCj4gPiBpcyByZXF1aXJlZCBmb3IgdGhpcyBwYXRjaC4gSXQgd291bGQg
aGVscCBlLmcuIHRvIGV4cGxhaW4gd2h5IHRoaXMNCj4gPiBwYXRjaCBpcyBhIGJ1ZyBmaXggYW5k
IGFsc28gd2hhdCBpdCBmaXhlcy4NCj4gPiANCj4gQXBvbG9neSBmb3IgdXNpbmcgd3Jvbmcgc3Vi
amVjdCBmb3IgdGhpcyBwYXRjaC4gDQo+IA0KPiB3ZSByYW4gaW50byB0aGlzIGRlYWRsb2NrIGlz
c3VlIHdoaWxlIHVubG9hZGluZyBkcml2ZXIgYW5kIHN0YWNrIHRyYWNlIHNob3dzIGZvbGxvd2lu
Zw0KPiANCj4gIzE0IFtmZmZmOWYyZTIxZTAzZGI4XSBuYXRpdmVfcXVldWVkX3NwaW5fbG9ja19z
bG93cGF0aCBhdCBmZmZmZmZmZmFkMGQ4ODAyDQo+ICMxNSBbZmZmZjlmMmUyMWUwM2RjMF0gZG9f
cmF3X3NwaW5fbG9jayBhdCBmZmZmZmZmZmFkMGQ5OWU0DQo+ICMxNiBbZmZmZjlmMmUyMWUwM2Rk
OF0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSBhdCBmZmZmZmZmZmFkNjUyNDcxDQo+ICMxNyBbZmZm
ZjlmMmUyMWUwM2UwMF0gcWxhMngwMF9lbHNfZGNtZF9pb2NiX3RpbWVvdXQgYXQgZmZmZmZmZmZj
MDcwY2Q2MyBbcWxhMnh4eF0NCj4gIzE4IFtmZmZmOWYyZTIxZTAzZTQwXSBxbGEyeDAwX3NwX3Rp
bWVvdXQgYXQgZmZmZmZmZmZjMDZmMDZkMyBbcWxhMnh4eF0NCj4gIzE5IFtmZmZmOWYyZTIxZTAz
ZTY4XSBjYWxsX3RpbWVyX2ZuIGF0IGZmZmZmZmZmYWQwZjk3ZDgNCj4gIzIwIFtmZmZmOWYyZTIx
ZTAzZWQ4XSBydW5fdGltZXJfc29mdGlycSBhdCBmZmZmZmZmZmFkMGZhZjQ3DQo+ICMyMSBbZmZm
ZjlmMmUyMWUwM2Y2OF0gX19zb2Z0aXJxZW50cnlfdGV4dF9zdGFydCBhdCBmZmZmZmZmZmFkNjU1
ZjMyDQo+IA0KPiBUaGVyZSBpcyBwYXRjaCAjMTkgKGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5v
cmcvcGF0Y2gvMTAwODA5NjcvKSBsYXRlciBpbiB0aGlzIHNlcmllcyB3aGljaCB1bHRpbWF0ZWx5
IHJlbW92ZXMNCj4gdGhpcyBibG9jayBvZiBjb2RlIHByb3RlY3RlZCBieSB0aGVzZSBzcGluIGxv
Y2tzLiBpZiB5b3UgcHJlZmVyIGkgY2FuIG1lcmdlIHRoaXMgcGF0Y2ggd2l0aCB0aGUgb3RoZXIg
cGF0Y2ggYW5kIA0KPiBhZGQgbW9yZSBkZXNjcmlwdGlvbg0KDQpIZWxsbyBIaW1hbnNodSwNCg0K
RG8geW91IGVuYWJsZSBDT05GSUdfUFJPVkVfTE9DS0lORyBpbiBhbnkgb2YgeW91ciB0ZXN0cz8g
SWYgdGhpcyBidWcgY291bGQNCmJlIHJlcHJvZHVjZWQgd2l0aCBDT05GSUdfUFJPVkVfTE9DS0lO
RyB0aGVuIHRoYXQgd291bGQgcHJvdmlkZSB2ZXJ5IHZhbHVhYmxlDQppbmZvcm1hdGlvbiBhYm91
dCB0aGUgcm9vdCBjYXVzZSBvZiB0aGUgZGVhZGxvY2suDQoNClRoYW5rcywNCg0KQmFydC4=
