Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CCDC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 10:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF71464EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 10:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhBXKvK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 05:51:10 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2908 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhBXKvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 05:51:01 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Dlt1V33SFz5VG2;
        Wed, 24 Feb 2021 18:48:14 +0800 (CST)
Received: from dggemi710-chm.china.huawei.com (10.3.20.109) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 24 Feb 2021 18:50:14 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi710-chm.china.huawei.com (10.3.20.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 24 Feb 2021 18:50:14 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Wed, 24 Feb 2021 18:50:14 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Topic: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Index: AQHXCmzcm1+9CefWtUG8kvjjNsr6mqpnFSvg
Date:   Wed, 24 Feb 2021 10:50:14 +0000
Message-ID: <79b5bdb1b5d94b248671bf99a930d971@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com>
 <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au>
 <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com>
 <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au>
 <4d2f90d2157045a7b0800a4004f539ba@hisilicon.com>
 <7293ba4c-c5ab-528f-1feb-dc59bfb0df2d@telegraphics.com.au>
In-Reply-To: <7293ba4c-c5ab-528f-1feb-dc59bfb0df2d@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.203.110]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmlubiBUaGFpbiBbbWFp
bHRvOmZ0aGFpbkB0ZWxlZ3JhcGhpY3MuY29tLmF1XQ0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1
YXJ5IDI0LCAyMDIxIDY6MjEgUE0NCj4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgPHNv
bmcuYmFvLmh1YUBoaXNpbGljb24uY29tPg0KPiBDYzogdGFueGlhb2ZlaSA8dGFueGlhb2ZlaUBo
dWF3ZWkuY29tPjsgamVqYkBsaW51eC5pYm0uY29tOw0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4YXJtQG9wZW5ldWxlci5vcmc7DQo+IGxpbnV4LW02OGtAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtMaW51eGFybV0gUmU6IFtQQVRDSCBmb3ItbmV4dCAwMC8zMl0g
c3BpbiBsb2NrIHVzYWdlIG9wdGltaXphdGlvbg0KPiBmb3IgU0NTSSBkcml2ZXJzDQo+IA0KPiBP
biBUdWUsIDIzIEZlYiAyMDIxLCBTb25nIEJhbyBIdWEgKEJhcnJ5IFNvbmcpIHdyb3RlOg0KPiAN
Cj4gPiA+DQo+ID4gPiBSZWdhcmRpbmcgbTY4aywgeW91ciBhbmFseXNpcyBvdmVybG9va3MgdGhl
IHRpbWluZyBpc3N1ZS4gRS5nLiBwYXRjaA0KPiA+ID4gMTEvMzIgY291bGQgYmUgYSBwcm9ibGVt
IGJlY2F1c2UgcmVtb3ZpbmcgdGhlIGlycXNhdmUgd291bGQgYWxsb3cgUERNQQ0KPiA+ID4gdHJh
bnNmZXJzIHRvIGJlIGludGVycnVwdGVkLiBBc2lkZSBmcm9tIHRoZSB0aW1pbmcgaXNzdWVzLCBJ
IGFncmVlDQo+ID4gPiB3aXRoIHlvdXIgYW5hbHlzaXMgYWJvdmUgcmVnYXJkaW5nIG02OGsuDQo+
ID4NCj4gPiBZb3UgbWVudGlvbmVkIHlvdSBuZWVkIHJlYWx0aW1lIHNvIHlvdSB3YW50IGFuIGlu
dGVycnVwdCB0byBiZSBhYmxlIHRvDQo+ID4gcHJlZW1wdCBhbm90aGVyIG9uZS4NCj4gDQo+IFRo
YXQncyBub3Qgd2hhdCBJIHNhaWQuIEJ1dCBmb3IgdGhlIHNha2Ugb2YgZGlzY3Vzc2lvbiwgeWVz
LCBJIGRvIGtub3cNCj4gcGVvcGxlIHdobyBydW4gTGludXggb24gQVJNIGhhcmR3YXJlIChpZiBB
bmRyb2lkIHZlbmRvciBrZXJuZWxzIGNhbiBiZQ0KPiBjYWxsZWQgIkxpbnV4IikgYW5kIHdobyB3
b3VsZCBiZW5lZml0IGZyb20gcmVhbHRpbWUgc3VwcG9ydCBvbiB0aG9zZQ0KPiBkZXZpY2VzLg0K
DQpSZWFsdGltZSByZXF1aXJlbWVudCBpcyBkZWZpbml0ZWx5IGEgdHJ1ZSByZXF1aXJlbWVudCBv
biBBUk0gTGludXguDQoNCkkgb25jZSB0YWxrZWQvd29ya2VkICB3aXRoIHNvbWUgZ3V5cyB3aG8g
d2VyZSB1c2luZyBBUk0gZm9yIHJlYWx0aW1lDQpzeXN0ZW0uDQpUaGUgZmVhc2libGUgYXBwcm9h
Y2hlcyBpbmNsdWRlOg0KMS4gRHVhbCBPUyhSVE9TICsgTGludXgpOiBlLmcuICBRTlgrTGludXgg
WEVOT01BSStMaW51eCBMNCtMaW51eA0KMi4gcHJlZW1wdC1ydA0KV2hpY2ggaXMgY29udGludW91
c2x5IG1haW50YWluZWQgbGlrZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMTAy
MTgyMDEwNDEuNjVma25yN2JkcGx3cWJlekBsaW51dHJvbml4LmRlLw0KMy4gYm9vdGFyZ3MgaXNv
bGNwdXM9DQp0byBpc29sYXRlIGEgY3B1IGZvciBhIHNwZWNpZmljIHJlYWx0aW1lIHRhc2sgb3Ig
aW50ZXJydXB0DQpodHRwczovL2FjY2Vzcy5yZWRoYXQuY29tL2RvY3VtZW50YXRpb24vZW4tdXMv
cmVkX2hhdF9lbnRlcnByaXNlX2xpbnV4X2Zvcl9yZWFsX3RpbWUvNy9odG1sL3R1bmluZ19ndWlk
ZS9pc29sYXRpbmdfY3B1c191c2luZ190dW5lZC1wcm9maWxlcy1yZWFsdGltZQ0KNC4gQVJNIEZJ
USB3aGljaCBoYXMgc2VwYXJhdGUgZmlxIEFQSSwgYW4gZXhhbXBsZSBpbiBmc2wgc291bmQ6DQpo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9s
aW51eC5naXQvdHJlZS9zb3VuZC9zb2MvZnNsL2lteC1wY20tZmlxLmMNCjUuIExldCBvbmUgY29y
ZSBpbnZpc2libGUgdG8gTGludXgNClJ1bm5pbmcgbm9uLW9zIHN5c3RlbSBhbmQgcnRvcyBvbiB0
aGUgY29yZQ0KDQpIb25lc3RseSwgSSd2ZSBuZXZlciBzZWVuIGFueW9uZSB3aG8gZGVwZW5kcyBv
biBpcnEgcHJpb3JpdHkgdG8gc3VwcG9ydA0KcmVhbHRpbWUgaW4gQVJNIExpbnV4IHRob3VnaCBB
Uk0ncyBSVE9TLWVzIHVzZSBpdCBxdWl0ZSBjb21tb25seS4NCg0KPiANCj4gPiBOb3cgeW91IHNh
aWQgeW91IHdhbnQgYW4gaW50ZXJydXB0IG5vdCB0byBiZSBwcmVlbXB0ZWQgYXMgaXQgd2lsbCBt
YWtlIGENCj4gPiB0aW1pbmcgaXNzdWUuDQo+IA0KPiBtYWNfZXNwIGRlbGliZXJhdGVseSBjb25z
dHJhaW5zIHNlZ21lbnQgc2l6ZXMgc28gdGhhdCBpdCBjYW4gaGFybWxlc3NseQ0KPiBkaXNhYmxl
IGludGVycnVwdHMgZm9yIHRoZSBkdXJhdGlvbiBvZiB0aGUgdHJhbnNmZXIuDQo+IA0KPiBNYXli
ZSB0aGUgaXJxc2F2ZSBpbiB0aGlzIGRyaXZlciBpcyBvdmVyLWNhdXRpb3VzLiBXaG8ga25vd3M/
IFRoZSBQRE1BDQo+IHRpbWluZyBwcm9ibGVtIHJlbGF0ZXMgdG8gU0NTSSBidXMgc2lnbmFsbGlu
ZyBhbmQgdGhlIHRvbGVyYW5jZSBvZiByZWFsLQ0KPiB3b3JsZCBTQ1NJIGRldmljZXMgdG8gc2Ft
ZS4gVGhlIG90aGVyIHByb2JsZW0gaXMgdGhhdCB0aGUgUERNQSBsb2dpYw0KPiBjaXJjdWl0IGlz
IHVuZG9jdW1lbnRlZCBoYXJkd2FyZS4gU28gdGhlcmUgbWF5IGJlIGZ1cnRoZXIgdGltaW5nDQo+
IHJlcXVpcmVtZW50cyBsdXJraW5nIHRoZXJlLiBUaGVyZWZvcmUsIHBhdGNoIDExLzMyIGlzIHRv
byByaXNreS4NCj4gDQo+ID4gSWYgdGhpcyBQRE1BIHRyYW5zZmVyIHdpbGwgaGF2ZSBzb21lIHBy
b2JsZW0gd2hlbiBpdCBpcyBwcmVlbXB0ZWQsIEkNCj4gPiBiZWxpZXZlIHdlIG5lZWQgc29tZSBl
bmhhbmNlZCB3YXlzIHRvIGhhbmRsZSB0aGlzLCBvdGhlcndpc2UsIG9uY2Ugd2UNCj4gPiBlbmFi
bGUgcHJlZW1wdF9ydCBvciB0aHJlYWRlZF9pcnEsIGl0IHdpbGwgZ2V0IHRoZSB0aW1pbmcgaXNz
dWUuIHNvIGhlcmUNCj4gPiBpdCBuZWVkcyBhIGNsZWFyIGNvbW1lbnQgYW5kIElSUUZfTk9fVEhS
RUFEIGlmIHRoaXMgaXMgdGhlIGNhc2UuDQo+ID4NCj4gDQo+IFBlb3BsZSB3aG8gcmVxdWlyZSBm
YXN0IHJlc3BvbnNlIHRpbWVzIGNhbm5vdCBleHBlY3QgcmFuZG9tIGRyaXZlcnMgb3INCj4gcGxh
dGZvcm1zIHRvIG1lZXQgc3VjaCByZXF1aXJlbWVudHMuIEkgZmVhciB5b3UgbWF5IGJlIGFza2lu
ZyB0b28gbXVjaA0KPiBmcm9tIE1hYyBRdWFkcmEgbWFjaGluZXMuDQoNCk9uY2UgcHJlZW1wdF9y
dCBpcyBlbmFibGVkLCB0aG9zZSB3aG8gd2FudCBhIGZhc3QgaXJxIGVudmlyb25tZW50IG5lZWQN
CmEgbm9fdGhyZWFkIGZsYWcsIG9yIG5lZWQgdG8gc2V0IGl0cyBpcnEgdGhyZWFkIHRvIGhpZ2hl
ciBzY2hlZF9maWZvL3JyDQpwcmlvcml0eS4NCg0KPiANCj4gPiA+DQo+ID4gPiBXaXRoIHJlZ2Fy
ZCB0byBvdGhlciBhcmNoaXRlY3R1cmVzIGFuZCBwbGF0Zm9ybXMsIGluIHNwZWNpZmljIGNhc2Vz
LA0KPiA+ID4gZS5nLiB3aGVyZSB0aGVyZSdzIG5ldmVyIG1vcmUgdGhhbiBvbmUgSVJRIGludm9s
dmVkLCB0aGVuIEkgY291bGQNCj4gPiA+IGFncmVlIHRoYXQgeW91ciBhc3N1bXB0aW9ucyBwcm9i
YWJseSBob2xkIGFuZCBhbiBpcnFzYXZlIHdvdWxkIGJlDQo+ID4gPiBwcm9iYWJseSByZWR1bmRh
bnQuDQo+ID4gPg0KPiA+ID4gV2hlbiB5b3UgZmluZCBhIHJlZHVuZGFudCBpcnFzYXZlLCB0byBh
Y3R1YWxseSBwYXRjaCBpdCB3b3VsZCBicmluZyBhDQo+ID4gPiByaXNrIG9mIHJlZ3Jlc3Npb24g
d2l0aCBsaXR0bGUgb3Igbm8gcmV3YXJkLiBJdCdzIG5vdCBteSBwbGFjZSB0byB2ZXRvDQo+ID4g
PiB0aGlzIGVudGlyZSBwYXRjaCBzZXJpZXMgb24gdGhhdCBiYXNpcyBidXQgSU1PIHRoaXMga2lu
ZCBvZiBjaHVybiBpcw0KPiA+ID4gbWlzZ3VpZGVkLg0KPiA+DQo+ID4gTm9wZS4NCj4gPg0KPiA+
IEkgd291bGQgc2F5IHRoZSByZWFsIG1pc2d1aWRhbmNlIGlzIHRoYXQgdGhlIGNvZGUgYWRkcyBv
bmUgbG9jayB3aGlsZSBpdA0KPiA+IGRvZXNuJ3QgbmVlZCB0aGUgbG9jay4gRWFzaWx5IHdlIGNh
biBhZGQgcmVkdW5kYW50IGxvY2tzIG9yIGV4YWdnZXJhdGUNCj4gPiB0aGUgY292ZXJhZ2UgcmFu
Z2Ugb2YgbG9ja3MsIGJ1dCB0aGUgc21hcnRlciB3YXkgaXMgdGhhdCBwZW9wbGUgYWRkDQo+ID4g
bG9ja3Mgb25seSB3aGVuIHRoZXkgcmVhbGx5IG5lZWQgdGhlIGxvY2sgYnkgY29uc2lkZXJpbmcg
Y29uY3VycmVuY3kgYW5kDQo+ID4gcmVhbHRpbWUgcGVyZm9ybWFuY2UuDQo+ID4NCj4gDQo+IFlv
dSBhcHBlYXIgdG8gYmUgZGViYXRpbmcgYSBzdHJhd21hbi4gTm8tb25lIGlzIGFkdm9jYXRpbmcg
ZXhjZXNzaXZlDQo+IGxvY2tpbmcgaW4gbmV3IGNvZGUuDQo+IA0KDQpJIGFjdHVhbGx5IG1lYW50
IG1vc3QgaXJxc2F2ZShzKSBpbiBoYXJkaXJxIHdlcmUgYWRkZWQgY2FyZWxlc3NseS4NCldoZW4g
aXJxIGFuZCB0aHJlYWRzIGNvdWxkIGFjY2VzcyBzYW1lIGRhdGEsIHBlb3BsZSBhZGRlZCBpcnFz
YXZlDQppbiB0aHJlYWRzLCB0aGF0IGlzIHBlcmZlY3RseSBnb29kIGFzIGl0IGNvdWxkIGJsb2Nr
IGlycS4gQnV0DQpwZW9wbGUgd2VyZSBsaWtlbHkgdG8gcHV0IGFuIGlycXNhdmUgaW4gaXJxIHdp
dGhvdXQgYW55IHRoaW5raW5nLg0KDQpXZSBkbyBoYXZlIHNvbWUgZHJpdmVycyB3aGljaCBhcmUg
ZG9pbmcgdGhhdCB3aXRoIGEgY2xlYXIgaW50ZW50aW9uDQphcyB5b3VyIHNvbmljX2ludGVycnVw
dCgpLCBidXQgSSBiZXQgbW9zdCB3ZXJlIGRvbmUgYWltbGVzc2x5Lg0KDQpBbnl3YXksIHRoZSBk
ZWJhdGUgaXMgbG9uZyBlbm91Z2gsIGxldCdzIG1vdmUgdG8gc29tZSBtb3JlIGltcG9ydGFudA0K
dGhpbmdzLiBJIGFwcHJlY2lhdGUgdGhhdCB5b3Ugc2hhcmVkIGEgbG90IG9mIGtub3dsZWRnZSBv
ZiBtNjhrLg0KDQpUaGFua3MNCkJhcnJ5DQo=
