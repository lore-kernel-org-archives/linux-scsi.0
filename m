Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A372C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 23:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E7164E0D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 23:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhBJXt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 18:49:56 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2835 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhBJXtz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 18:49:55 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DbbyP70h8z13r52;
        Thu, 11 Feb 2021 07:46:53 +0800 (CST)
Received: from dggemi711-chm.china.huawei.com (10.3.20.110) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 11 Feb 2021 07:49:10 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi711-chm.china.huawei.com (10.3.20.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 11 Feb 2021 07:49:10 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Thu, 11 Feb 2021 07:49:10 +0800
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
Thread-Index: AQHW//Cyu0PLR2OKVEm5NkJUbKWYbqpR4DFw//+TtYCAAJWd4A==
Date:   Wed, 10 Feb 2021 23:49:10 +0000
Message-ID: <3ec7cb32aa754a59b894d048873132cf@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com>
 <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au>
 <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com>
 <9611728-3e7-3954-cfee-f3d3cf45df6@telegraphics.com.au>
 <13c414b9bd7940caa5e1df810356dcfd@hisilicon.com>
 <221cb29-53a8-fd1-4232-360655f28f3@telegraphics.com.au>
In-Reply-To: <221cb29-53a8-fd1-4232-360655f28f3@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.246]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmlubiBUaGFpbiBbbWFp
bHRvOmZ0aGFpbkB0ZWxlZ3JhcGhpY3MuY29tLmF1XQ0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVh
cnkgMTEsIDIwMjEgMTE6MzUgQU0NCj4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgPHNv
bmcuYmFvLmh1YUBoaXNpbGljb24uY29tPg0KPiBDYzogdGFueGlhb2ZlaSA8dGFueGlhb2ZlaUBo
dWF3ZWkuY29tPjsgamVqYkBsaW51eC5pYm0uY29tOw0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4YXJtQG9wZW5ldWxlci5vcmc7DQo+IGxpbnV4LW02OGtAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbTGludXhhcm1dIFJlOiBbUEFUQ0ggZm9yLW5leHQgMDAv
MzJdIHNwaW4gbG9jayB1c2FnZSBvcHRpbWl6YXRpb24NCj4gZm9yIFNDU0kgZHJpdmVycw0KPiAN
Cj4gT24gV2VkLCAxMCBGZWIgMjAyMSwgU29uZyBCYW8gSHVhIChCYXJyeSBTb25nKSB3cm90ZToN
Cj4gDQo+ID4gPiBPbiBXZWQsIDEwIEZlYiAyMDIxLCBTb25nIEJhbyBIdWEgKEJhcnJ5IFNvbmcp
IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoZXJlIGlzIG5vIHdhcm5pbmcg
ZnJvbSBtNjhrIGJ1aWxkcy4gVGhhdCdzIGJlY2F1c2UNCj4gPiA+ID4gPiBhcmNoX2lycXNfZGlz
YWJsZWQoKSByZXR1cm5zIHRydWUgd2hlbiB0aGUgSVBMIGlzIG5vbi16ZXJvLg0KPiA+ID4gPg0K
PiA+ID4gPiBTbyBmb3IgbTY4aywgdGhlIGNhc2UgaXMNCj4gPiA+ID4gYXJjaF9pcnFzX2Rpc2Fi
bGVkKCkgaXMgdHJ1ZSwgYnV0IGludGVycnVwdHMgY2FuIHN0aWxsIGNvbWU/DQo+ID4gPiA+DQo+
ID4gPiA+IFRoZW4gaXQgc2VlbXMgaXQgaXMgdmVyeSBjb25mdXNpbmcuIElmIHByaW9yaXRpemVk
IGludGVycnVwdHMgY2FuDQo+ID4gPiA+IHN0aWxsIGNvbWUgd2hpbGUgYXJjaF9pcnFzX2Rpc2Fi
bGVkKCkgaXMgdHJ1ZSwNCj4gPiA+DQo+ID4gPiBZZXMsIG9uIG02OGsgQ1BVcywgYW4gSVJRIGhh
dmluZyBhIHByaW9yaXR5IGxldmVsIGhpZ2hlciB0aGFuIHRoZQ0KPiA+ID4gcHJlc2VudCBwcmlv
cml0eSBtYXNrIHdpbGwgZ2V0IHNlcnZpY2VkLg0KPiA+ID4NCj4gPiA+IE5vbi1NYXNrYWJsZSBJ
bnRlcnJ1cHQgKE5NSSkgaXMgbm90IHN1YmplY3QgdG8gdGhpcyBydWxlIGFuZCBnZXRzDQo+ID4g
PiBzZXJ2aWNlZCByZWdhcmRsZXNzLg0KPiA+ID4NCj4gPiA+ID4gaG93IGNvdWxkIHNwaW5fbG9j
a19pcnFzYXZlKCkgYmxvY2sgdGhlIHByaW9yaXRpemVkIGludGVycnVwdHM/DQo+ID4gPg0KPiA+
ID4gSXQgcmFpc2VzIHRoZSB0aGUgbWFzayBsZXZlbCB0byA3LiBBZ2FpbiwgcGxlYXNlIHNlZQ0K
PiA+ID4gYXJjaC9tNjhrL2luY2x1ZGUvYXNtL2lycWZsYWdzLmgNCj4gPg0KPiA+IEhpIEZpbm4s
DQo+ID4gVGhhbmtzIGZvciB5b3VyIGV4cGxhbmF0aW9uIGFnYWluLg0KPiA+DQo+ID4gVEJILCB0
aGF0IGlzIHdoeSBtNjhrIGlzIHNvIGNvbmZ1c2luZy4gaXJxc19kaXNhYmxlZCgpIG9uIG02OGsg
c2hvdWxkDQo+ID4ganVzdCByZWZsZWN0IHRoZSBzdGF0dXMgb2YgYWxsIGludGVycnVwdHMgaGF2
ZSBiZWVuIGRpc2FibGVkIGV4Y2VwdCBOTUkuDQo+ID4NCj4gPiBpcnFzX2Rpc2FibGVkKCkgc2hv
dWxkIGJlIGNvbnNpc3RlbnQgd2l0aCB0aGUgY2FsbGluZyBvZiBBUElzIHN1Y2ggYXMNCj4gPiBs
b2NhbF9pcnFfZGlzYWJsZSwgbG9jYWxfaXJxX3NhdmUsIHNwaW5fbG9ja19pcnFzYXZlIGV0Yy4N
Cj4gPg0KPiANCj4gV2hlbiBpcnFzX2Rpc2FibGVkKCkgcmV0dXJucyB0cnVlLCB3ZSBjYW5ub3Qg
aW5mZXIgdGhhdA0KPiBhcmNoX2xvY2FsX2lycV9kaXNhYmxlKCkgd2FzIGNhbGxlZC4gQnV0IEkg
aGF2ZSBub3QgeWV0IGZvdW5kIGRyaXZlciBjb2RlDQo+IG9yIGNvcmUga2VybmVsIGNvZGUgYXR0
ZW1wdGluZyB0aGF0IGluZmVyZW5jZS4NCj4gDQo+ID4gPg0KPiA+ID4gPiBJc24ndCBhcmNoX2ly
cXNfZGlzYWJsZWQoKSBhIHN0YXR1cyByZWZsZWN0aW9uIG9mIGlycSBkaXNhYmxlIEFQST8NCj4g
PiA+ID4NCj4gPiA+DQo+ID4gPiBXaHkgbm90Pw0KPiA+DQo+ID4gSWYgc28sIGFyY2hfaXJxc19k
aXNhYmxlZCgpIHNob3VsZCBtZWFuIGFsbCBpbnRlcnJ1cHRzIGhhdmUgYmVlbiBtYXNrZWQNCj4g
PiBleGNlcHQgTk1JIGFzIE5NSSBpcyB1bm1hc2thYmxlLg0KPiA+DQo+IA0KPiBDYW4geW91IHN1
cHBvcnQgdGhhdCBjbGFpbSB3aXRoIGEgcmVmZXJlbmNlIHRvIGNvcmUga2VybmVsIGNvZGUgb3IN
Cj4gZG9jdW1lbnRhdGlvbj8gKElmIHNvbWUgYXJjaCBjb2RlIGFncmVlcyB3aXRoIHlvdSwgdGhh
dCdzIG5laXRoZXIgaGVyZSBub3INCj4gdGhlcmUuKQ0KDQpJIHRoaW5rIHRob3NlIGxpbmtzIEkg
c2hhcmUgeW91IGhhdmUgc3VwcG9ydGVkIHRoaXMuIEp1c3QgeW91IGRvbid0DQpiZWxpZXZlIDot
KQ0KDQo+IA0KPiA+ID4NCj4gPiA+IEFyZSBhbGwgaW50ZXJydXB0cyAoaW5jbHVkaW5nIE5NSSkg
bWFza2VkIHdoZW5ldmVyDQo+ID4gPiBhcmNoX2lycXNfZGlzYWJsZWQoKSByZXR1cm5zIHRydWUg
b24geW91ciBwbGF0Zm9ybXM/DQo+ID4NCj4gPiBPbiBteSBwbGF0Zm9ybSwgb25jZSBpcnFzX2Rp
c2FibGVkKCkgaXMgdHJ1ZSwgYWxsIGludGVycnVwdHMgYXJlIG1hc2tlZA0KPiA+IGV4Y2VwdCBO
TUkuIE5NSSBqdXN0IGlnbm9yZSBzcGluX2xvY2tfaXJxc2F2ZSBvciBsb2NhbF9pcnFfZGlzYWJs
ZS4NCj4gPg0KPiA+IE9uIEFSTTY0LCB3ZSBhbHNvIGhhdmUgaGlnaC1wcmlvcml0eSBpbnRlcnJ1
cHRzLCBidXQgdGhleSBhcmUgcnVubmluZyBhcw0KPiA+IFBFU1VET19OTUk6DQo+ID4gaHR0cHM6
Ly9sd24ubmV0L0FydGljbGVzLzc1NTkwNi8NCj4gPg0KPiANCj4gQSBnbGFuY2UgYXQgdGhlIEFS
TSBHSUMgc3BlY2lmaWNhdGlvbiBzdWdnZXN0cyB0aGF0IHlvdXIgaGFyZHdhcmUgd29ya3MNCj4g
bXVjaCBsaWtlIDY4MDAwIGhhcmR3YXJlLg0KPiANCj4gICAgV2hlbiBlbmFibGVkLCBhIENQVSBp
bnRlcmZhY2UgdGFrZXMgdGhlIGhpZ2hlc3QgcHJpb3JpdHkgcGVuZGluZw0KPiAgICBpbnRlcnJ1
cHQgZm9yIGl0cyBjb25uZWN0ZWQgcHJvY2Vzc29yIGFuZCBkZXRlcm1pbmVzIHdoZXRoZXIgdGhl
DQo+ICAgIGludGVycnVwdCBoYXMgc3VmZmljaWVudCBwcmlvcml0eSBmb3IgaXQgdG8gc2lnbmFs
IHRoZSBpbnRlcnJ1cHQNCj4gICAgcmVxdWVzdCB0byB0aGUgcHJvY2Vzc29yLiBbLi4uXQ0KPiAN
Cj4gICAgV2hlbiB0aGUgcHJvY2Vzc29yIGFja25vd2xlZGdlcyB0aGUgaW50ZXJydXB0IGF0IHRo
ZSBDUFUgaW50ZXJmYWNlLCB0aGUNCj4gICAgRGlzdHJpYnV0b3IgY2hhbmdlcyB0aGUgc3RhdHVz
IG9mIHRoZSBpbnRlcnJ1cHQgZnJvbSBwZW5kaW5nIHRvIGVpdGhlcg0KPiAgICBhY3RpdmUsIG9y
IGFjdGl2ZSBhbmQgcGVuZGluZy4gQXQgdGhpcyBwb2ludCB0aGUgQ1BVIGludGVyZmFjZSBjYW4N
Cj4gICAgc2lnbmFsIGFub3RoZXIgaW50ZXJydXB0IHRvIHRoZSBwcm9jZXNzb3IsIHRvIHByZWVt
cHQgaW50ZXJydXB0cyB0aGF0DQo+ICAgIGFyZSBhY3RpdmUgb24gdGhlIHByb2Nlc3Nvci4gSWYg
dGhlcmUgaXMgbm8gcGVuZGluZyBpbnRlcnJ1cHQgd2l0aA0KPiAgICBzdWZmaWNpZW50IHByaW9y
aXR5IGZvciBzaWduYWxpbmcgdG8gdGhlIHByb2Nlc3NvciwgdGhlIGludGVyZmFjZQ0KPiAgICBk
ZWFzc2VydHMgdGhlIGludGVycnVwdCByZXF1ZXN0IHNpZ25hbCB0byB0aGUgcHJvY2Vzc29yLg0K
PiANCj4gaHR0cHM6Ly9kZXZlbG9wZXIuYXJtLmNvbS9kb2N1bWVudGF0aW9uL2loaTAwNDgvYi8N
Cj4gDQo+IEhhdmUgeW91IGNvbnNpZGVyZWQgdGhhdCBMaW51eC9hcm0gbWlnaHQgYmVuZWZpdCBp
ZiBpdCBjb3VsZCBmdWxseSBleHBsb2l0DQo+IGhhcmR3YXJlIGZlYXR1cmVzIGFscmVhZHkgYXZh
aWxhYmxlLCBzdWNoIGFzIHRoZSBpbnRlcnJ1cHQgcHJpb3JpdHkNCj4gbWFza2luZyBmZWF0dXJl
IGluIHRoZSBHSUMgaW4gZXhpc3RpbmcgYXJtIHN5c3RlbXM/DQoNCkkgZ3Vlc3Mgbm86LSkgdGhl
cmUgYXJlIG9ubHkgdHdvIGxldmVsczogSVJRIGFuZCBOTUkuIEluamVjdGluZyBhIGhpZ2gtcHJp
bw0KSVJRIGxldmVsIGJldHdlZW4gdGhlbSBtYWtlcyBubyBzZW5zZS4NCg0KVG8gbWUsIGFybTY0
J3MgZGVzaWduIGlzIHF1aXRlIGNsZWFyIGFuZCBoYXMgbm8gYW55IGNvbmZ1c2lvbi4NCg0KPiAN
Cj4gPiBPbiBtNjhrLCBpdCBzZWVtcyB5b3UgbWVhbu+8mg0KPiA+IGlycV9kaXNhYmxlZCgpIGlz
IHRydWUsIGJ1dCBoaWdoLXByaW9yaXR5IGludGVycnVwdHMgY2FuIHN0aWxsIGNvbWU7DQo+ID4g
bG9jYWxfaXJxX2Rpc2FibGUoKSBjYW4gZGlzYWJsZSBoaWdoLXByaW9yaXR5IGludGVycnVwdHMs
IGFuZCBhdCB0aGF0DQo+ID4gdGltZSwgaXJxX2Rpc2FibGVkKCkgaXMgYWxzbyB0cnVlLg0KPiA+
DQo+ID4gVEJILCB0aGlzIGlzIHdyb25nIGFuZCBjb25mdXNpbmcgb24gbTY4ay4NCj4gPg0KPiAN
Cj4gTGlrZSB5b3UsIEkgd2FzIHN1cnByaXNlZCB3aGVuIEkgbGVhcm5lZCBhYm91dCBpdC4gQnV0
IHRoYXQgZG9lc24ndCBtZWFuDQo+IGl0J3Mgd3JvbmcuIFRoZSBmYWN0IHRoYXQgaXQgd29ya3Mg
c2hvdWxkIHRlbGwgeW91IHNvbWV0aGluZy4NCj4gDQoNClRoZSBmYWN0IGlzIHRoYXQgbTY4ayBs
ZXRzIGFyY2hfaXJxX2Rpc2FibGVkKCkgcmV0dXJuIHRydWUgdG8gcHJldGVuZA0KYWxsIElSUXMg
YXJlIGRpc2FibGVkIHdoaWxlIGhpZ2gtcHJpb3JpdHkgSVJRIGlzIHN0aWxsIG9wZW4sIHRodXMg
InBhc3MiDQphbGwgc2FuaXRpemluZyBjaGVjayBpbiBnZW5pcnEgYW5kIGtlcm5lbCBjb3JlLg0K
DQo+IFRoaW5ncyBjb3VsZCBhbHdheXMgYmUgbWFkZSBzaW1wbGVyLiBCdXQgZGlzY2FyZGluZyBm
ZWF0dXJlcyBpc24ndA0KPiBuZWNlc3NhcmlseSBhbiBpbXByb3ZlbWVudC4NCg0KVGhpcyBmZWF0
dXJlIGNvdWxkIGJlIHVzZWQgYnkgY2FsbGluZyBsb2NhbF9pcnFfZW5hYmxlX2luX2hhcmRpcnEo
KQ0KaW4gdGhvc2UgSVJRIGhhbmRsZXJzIHdobyBob3BlIGhpZ2gtcHJpb3JpdHkgaW50ZXJydXB0
cyB0byBwcmVlbXB0IGl0DQpmb3IgYSB3aGlsZS4NCg0KSXQgc2hvdWxkbid0IGhpZGUgc29tZXdo
ZXJlIGFuZCBtYWtlIGNvbmZ1c2lvbi4NCg0KT24gdGhlIG90aGVyIGhhbmQsIHRob3NlIHdobyBj
YXJlIGFib3V0IHJlYWx0aW1lIHNob3VsZCB1c2UgdGhyZWFkZWQNCklSUSBhbmQgbGV0IElSUSB0
aHJlYWRzIHByZWVtcHQgZWFjaCBvdGhlci4NCg0KVGhhbmtzDQpCYXJyeQ0KDQo=
