Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F48C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 21:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948DA64E66
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 21:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhBJVaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 16:30:23 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2834 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbhBJV3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 16:29:40 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DbXrY1D1mz13kph;
        Thu, 11 Feb 2021 05:26:37 +0800 (CST)
Received: from dggemi710-chm.china.huawei.com (10.3.20.109) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 11 Feb 2021 05:28:53 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi710-chm.china.huawei.com (10.3.20.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 11 Feb 2021 05:28:53 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Thu, 11 Feb 2021 05:28:53 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Topic: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Index: AQHW//Cyu0PLR2OKVEm5NkJUbKWYbqpR4DFw
Date:   Wed, 10 Feb 2021 21:28:53 +0000
Message-ID: <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com>
 <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au>
 <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com>
 <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au>
In-Reply-To: <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.223]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmlubiBUaGFpbiBbbWFp
bHRvOmZ0aGFpbkB0ZWxlZ3JhcGhpY3MuY29tLmF1XQ0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVh
cnkgMTEsIDIwMjEgMTA6MDcgQU0NCj4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgPHNv
bmcuYmFvLmh1YUBoaXNpbGljb24uY29tPg0KPiBDYzogdGFueGlhb2ZlaSA8dGFueGlhb2ZlaUBo
dWF3ZWkuY29tPjsgamVqYkBsaW51eC5pYm0uY29tOw0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4YXJtQG9wZW5ldWxlci5vcmc7DQo+IGxpbnV4LW02OGtAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbTGludXhhcm1dIFJlOiBbUEFUQ0ggZm9yLW5leHQgMDAv
MzJdIHNwaW4gbG9jayB1c2FnZSBvcHRpbWl6YXRpb24NCj4gZm9yIFNDU0kgZHJpdmVycw0KPiAN
Cj4gDQo+IE9uIFdlZCwgMTAgRmViIDIwMjEsIFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgd3Jv
dGU6DQo+IA0KPiA+ID4gT24gVHVlLCA5IEZlYiAyMDIxLCBTb25nIEJhbyBIdWEgKEJhcnJ5IFNv
bmcpIHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gPiA+IHNvbmljX2ludGVycnVwdCgpIHVzZXMgYW4g
aXJxIGxvY2sgd2l0aGluIGFuIGludGVycnVwdCBoYW5kbGVyDQo+ID4gPiA+ID4gPiB0byBhdm9p
ZCBpc3N1ZXMgcmVsYXRpbmcgdG8gdGhpcy4gVGhpcyBraW5kIG9mIGxvY2tpbmcgbWF5IGJlDQo+
ID4gPiA+ID4gPiBuZWVkZWQgaW4gdGhlIGRyaXZlcnMgeW91IGFyZSB0cnlpbmcgdG8gcGF0Y2gu
IE9yIGl0IG1pZ2h0IG5vdC4NCj4gPiA+ID4gPiA+IEFwcGFyZW50bHksIG5vLW9uZSBoYXMgbG9v
a2VkLg0KPiA+ID4gPg0KPiA+ID4gPiBJcyB0aGUgY29tbWVudCBpbiBzb25pY19pbnRlcnJ1cHQo
KSBvdXRkYXRlZCBhY2NvcmRpbmcgdG8gdGhpczoNCj4gPiA+ID4gbTY4azogaXJxOiBSZW1vdmUg
SVJRRl9ESVNBQkxFRA0KPiA+ID4gPg0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lw0KPiA/aWQ9NzdhNDI3
OQ0KPiA+ID4gPiBodHRwOi8vbGttbC5pdS5lZHUvaHlwZXJtYWlsL2xpbnV4L2tlcm5lbC8xMTA5
LjIvMDE2ODcuaHRtbA0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZSByZW1vdmFsIG9mIElSUUZf
RElTQUJMRUQgaXNuJ3QgcmVsZXZhbnQgdG8gdGhpcyBkcml2ZXIuIENvbW1pdA0KPiA+ID4gNzdh
NDI3OTY3ODZjICgibTY4azogUmVtb3ZlIGRlcHJlY2F0ZWQgSVJRRl9ESVNBQkxFRCIpIGRpZCBu
b3QgZGlzYWJsZQ0KPiA+ID4gaW50ZXJydXB0cywgaXQganVzdCByZW1vdmVkIHNvbWUgY29kZSB0
byBlbmFibGUgdGhlbS4NCj4gPiA+DQo+ID4gPiBUaGUgY29kZSBhbmQgY29tbWVudHMgaW4gc29u
aWNfaW50ZXJydXB0KCkgYXJlIGNvcnJlY3QuIFlvdSBjYW4NCj4gPiA+IGNvbmZpcm0gdGhpcyBm
b3IgeW91cnNlbGYgcXVpdGUgZWFzaWx5IHVzaW5nIFFFTVUgYW5kIGENCj4gPiA+IGNyb3NzLWNv
bXBpbGVyLg0KPiA+ID4NCj4gPiA+ID4gYW5kIHRoaXM6IGdlbmlycTogV2FybiB3aGVuIGhhbmRs
ZXIgZW5hYmxlcyBpbnRlcnJ1cHRzDQo+ID4gPiA+DQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvDQo+ID9p
ZD1iNzM4YTUwYQ0KPiA+ID4gPg0KPiA+ID4gPiB3b3VsZG4ndCBnZW5pcnEgcmVwb3J0IGEgd2Fy
bmluZyBvbiBtNjhrPw0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZXJlIGlzIG5vIHdhcm5pbmcg
ZnJvbSBtNjhrIGJ1aWxkcy4gVGhhdCdzIGJlY2F1c2UNCj4gPiA+IGFyY2hfaXJxc19kaXNhYmxl
ZCgpIHJldHVybnMgdHJ1ZSB3aGVuIHRoZSBJUEwgaXMgbm9uLXplcm8uDQo+ID4NCj4gPg0KPiA+
IFNvIGZvciBtNjhrLCB0aGUgY2FzZSBpcw0KPiA+IGFyY2hfaXJxc19kaXNhYmxlZCgpIGlzIHRy
dWUsIGJ1dCBpbnRlcnJ1cHRzIGNhbiBzdGlsbCBjb21lPw0KPiA+DQo+ID4gVGhlbiBpdCBzZWVt
cyBpdCBpcyB2ZXJ5IGNvbmZ1c2luZy4gSWYgcHJpb3JpdGl6ZWQgaW50ZXJydXB0cyBjYW4gc3Rp
bGwNCj4gPiBjb21lIHdoaWxlIGFyY2hfaXJxc19kaXNhYmxlZCgpIGlzIHRydWUsDQo+IA0KPiBZ
ZXMsIG9uIG02OGsgQ1BVcywgYW4gSVJRIGhhdmluZyBhIHByaW9yaXR5IGxldmVsIGhpZ2hlciB0
aGFuIHRoZSBwcmVzZW50DQo+IHByaW9yaXR5IG1hc2sgd2lsbCBnZXQgc2VydmljZWQuDQo+IA0K
PiBOb24tTWFza2FibGUgSW50ZXJydXB0IChOTUkpIGlzIG5vdCBzdWJqZWN0IHRvIHRoaXMgcnVs
ZSBhbmQgZ2V0cyBzZXJ2aWNlZA0KPiByZWdhcmRsZXNzLg0KPiANCj4gPiBob3cgY291bGQgc3Bp
bl9sb2NrX2lycXNhdmUoKSBibG9jayB0aGUgcHJpb3JpdGl6ZWQgaW50ZXJydXB0cz8NCj4gDQo+
IEl0IHJhaXNlcyB0aGUgdGhlIG1hc2sgbGV2ZWwgdG8gNy4gQWdhaW4sIHBsZWFzZSBzZWUNCj4g
YXJjaC9tNjhrL2luY2x1ZGUvYXNtL2lycWZsYWdzLmgNCg0KSGkgRmlubiwNClRoYW5rcyBmb3Ig
eW91ciBleHBsYW5hdGlvbiBhZ2Fpbi4NCg0KVEJILCB0aGF0IGlzIHdoeSBtNjhrIGlzIHNvIGNv
bmZ1c2luZy4gaXJxc19kaXNhYmxlZCgpIG9uIG02OGsgc2hvdWxkIGp1c3QNCnJlZmxlY3QgdGhl
IHN0YXR1cyBvZiBhbGwgaW50ZXJydXB0cyBoYXZlIGJlZW4gZGlzYWJsZWQgZXhjZXB0IE5NSS4N
Cg0KaXJxc19kaXNhYmxlZCgpIHNob3VsZCBiZSBjb25zaXN0ZW50IHdpdGggdGhlIGNhbGxpbmcg
b2YgQVBJcyBzdWNoDQphcyBsb2NhbF9pcnFfZGlzYWJsZSwgbG9jYWxfaXJxX3NhdmUsIHNwaW5f
bG9ja19pcnFzYXZlIGV0Yy4NCg0KPiANCj4gPiBJc24ndCBhcmNoX2lycXNfZGlzYWJsZWQoKSBh
IHN0YXR1cyByZWZsZWN0aW9uIG9mIGlycSBkaXNhYmxlIEFQST8NCj4gPg0KPiANCj4gV2h5IG5v
dD8NCg0KSWYgc28sIGFyY2hfaXJxc19kaXNhYmxlZCgpIHNob3VsZCBtZWFuIGFsbCBpbnRlcnJ1
cHRzIGhhdmUgYmVlbiBtYXNrZWQNCmV4Y2VwdCBOTUkgYXMgTk1JIGlzIHVubWFza2FibGUuDQoN
Cj4gDQo+IEFyZSBhbGwgaW50ZXJydXB0cyAoaW5jbHVkaW5nIE5NSSkgbWFza2VkIHdoZW5ldmVy
IGFyY2hfaXJxc19kaXNhYmxlZCgpDQo+IHJldHVybnMgdHJ1ZSBvbiB5b3VyIHBsYXRmb3Jtcz8N
Cg0KT24gbXkgcGxhdGZvcm0sIG9uY2UgaXJxc19kaXNhYmxlZCgpIGlzIHRydWUsIGFsbCBpbnRl
cnJ1cHRzIGFyZSBtYXNrZWQNCmV4Y2VwdCBOTUkuIE5NSSBqdXN0IGlnbm9yZSBzcGluX2xvY2tf
aXJxc2F2ZSBvciBsb2NhbF9pcnFfZGlzYWJsZS4NCg0KT24gQVJNNjQsIHdlIGFsc28gaGF2ZSBo
aWdoLXByaW9yaXR5IGludGVycnVwdHMsIGJ1dCB0aGV5IGFyZSBydW5uaW5nIGFzDQpQRVNVRE9f
Tk1JOg0KaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzc1NTkwNi8NCg0KT24gbTY4aywgaXQgc2Vl
bXMgeW91IG1lYW6jug0KaXJxX2Rpc2FibGVkKCkgaXMgdHJ1ZSwgYnV0IGhpZ2gtcHJpb3JpdHkg
aW50ZXJydXB0cyBjYW4gc3RpbGwgY29tZTsNCmxvY2FsX2lycV9kaXNhYmxlKCkgY2FuIGRpc2Fi
bGUgaGlnaC1wcmlvcml0eSBpbnRlcnJ1cHRzLCBhbmQgYXQgdGhhdA0KdGltZSwgaXJxX2Rpc2Fi
bGVkKCkgaXMgYWxzbyB0cnVlLg0KDQpUQkgsIHRoaXMgaXMgd3JvbmcgYW5kIGNvbmZ1c2luZyBv
biBtNjhrLg0KDQo+IA0KPiA+IFRoYW5rcw0KPiA+IEJhcnJ5DQo+ID4NCg0KVGhhbmtzDQpCYXJy
eQ0K
