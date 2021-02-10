Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAB7C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 05:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCCF464E4B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 05:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhBJFPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 00:15:02 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3016 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhBJFOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 00:14:55 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Db7F36pP8zRCtH;
        Wed, 10 Feb 2021 13:12:55 +0800 (CST)
Received: from dggemi709-chm.china.huawei.com (10.3.20.108) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 10 Feb 2021 13:14:11 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi709-chm.china.huawei.com (10.3.20.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 10 Feb 2021 13:14:11 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Wed, 10 Feb 2021 13:14:11 +0800
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
Thread-Index: AQHW/fAMrBMz1ua2YUiLJwcWnjqnW6pPDROA//+zewCAAIlDYIAABJ6AgAD2eICAAJMNYA==
Date:   Wed, 10 Feb 2021 05:14:11 +0000
Message-ID: <00c06b19e87a425fa3a4b6aaecc66d49@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <88d26bd86c314e5483ec596952054be7@hisilicon.com>
 <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au>
In-Reply-To: <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.202.77]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmlubiBUaGFpbiBbbWFp
bHRvOmZ0aGFpbkB0ZWxlZ3JhcGhpY3MuY29tLmF1XQ0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1
YXJ5IDEwLCAyMDIxIDU6MTYgUE0NCj4gVG86IFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgPHNv
bmcuYmFvLmh1YUBoaXNpbGljb24uY29tPg0KPiBDYzogdGFueGlhb2ZlaSA8dGFueGlhb2ZlaUBo
dWF3ZWkuY29tPjsgamVqYkBsaW51eC5pYm0uY29tOw0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4YXJtQG9wZW5ldWxlci5vcmc7DQo+IGxpbnV4LW02OGtAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtMaW51eGFybV0gUmU6IFtQQVRDSCBmb3ItbmV4dCAwMC8zMl0g
c3BpbiBsb2NrIHVzYWdlIG9wdGltaXphdGlvbg0KPiBmb3IgU0NTSSBkcml2ZXJzDQo+IA0KPiBP
biBUdWUsIDkgRmViIDIwMjEsIFNvbmcgQmFvIEh1YSAoQmFycnkgU29uZykgd3JvdGU6DQo+IA0K
PiA+ID4gPiBzb25pY19pbnRlcnJ1cHQoKSB1c2VzIGFuIGlycSBsb2NrIHdpdGhpbiBhbiBpbnRl
cnJ1cHQgaGFuZGxlciB0bw0KPiA+ID4gPiBhdm9pZCBpc3N1ZXMgcmVsYXRpbmcgdG8gdGhpcy4g
VGhpcyBraW5kIG9mIGxvY2tpbmcgbWF5IGJlIG5lZWRlZCBpbg0KPiA+ID4gPiB0aGUgZHJpdmVy
cyB5b3UgYXJlIHRyeWluZyB0byBwYXRjaC4gT3IgaXQgbWlnaHQgbm90LiBBcHBhcmVudGx5LA0K
PiA+ID4gPiBuby1vbmUgaGFzIGxvb2tlZC4NCj4gPg0KPiA+IElzIHRoZSBjb21tZW50IGluIHNv
bmljX2ludGVycnVwdCgpIG91dGRhdGVkIGFjY29yZGluZyB0byB0aGlzOg0KPiA+IG02OGs6IGly
cTogUmVtb3ZlIElSUUZfRElTQUJMRUQNCj4gPg0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lw0KPiA/aWQ9
NzdhNDI3OQ0KPiA+IGh0dHA6Ly9sa21sLml1LmVkdS9oeXBlcm1haWwvbGludXgva2VybmVsLzEx
MDkuMi8wMTY4Ny5odG1sDQo+ID4NCj4gDQo+IFRoZSByZW1vdmFsIG9mIElSUUZfRElTQUJMRUQg
aXNuJ3QgcmVsZXZhbnQgdG8gdGhpcyBkcml2ZXIuIENvbW1pdA0KPiA3N2E0Mjc5Njc4NmMgKCJt
NjhrOiBSZW1vdmUgZGVwcmVjYXRlZCBJUlFGX0RJU0FCTEVEIikgZGlkIG5vdCBkaXNhYmxlDQo+
IGludGVycnVwdHMsIGl0IGp1c3QgcmVtb3ZlZCBzb21lIGNvZGUgdG8gZW5hYmxlIHRoZW0uDQo+
IA0KPiBUaGUgY29kZSBhbmQgY29tbWVudHMgaW4gc29uaWNfaW50ZXJydXB0KCkgYXJlIGNvcnJl
Y3QuIFlvdSBjYW4gY29uZmlybQ0KPiB0aGlzIGZvciB5b3Vyc2VsZiBxdWl0ZSBlYXNpbHkgdXNp
bmcgUUVNVSBhbmQgYSBjcm9zcy1jb21waWxlci4NCj4gDQo+ID4gYW5kIHRoaXM6DQo+ID4gZ2Vu
aXJxOiBXYXJuIHdoZW4gaGFuZGxlciBlbmFibGVzIGludGVycnVwdHMNCj4gPg0KPiBodHRwczov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5n
aXQvY29tbWl0Lw0KPiA/aWQ9YjczOGE1MGENCj4gPg0KPiA+IHdvdWxkbid0IGdlbmlycSByZXBv
cnQgYSB3YXJuaW5nIG9uIG02OGs/DQo+ID4NCj4gDQo+IFRoZXJlIGlzIG5vIHdhcm5pbmcgZnJv
bSBtNjhrIGJ1aWxkcy4gVGhhdCdzIGJlY2F1c2UgYXJjaF9pcnFzX2Rpc2FibGVkKCkNCj4gcmV0
dXJucyB0cnVlIHdoZW4gdGhlIElQTCBpcyBub24temVyby4NCg0KDQpTbyBmb3IgbTY4aywgdGhl
IGNhc2UgaXMNCmFyY2hfaXJxc19kaXNhYmxlZCgpIGlzIHRydWUsIGJ1dCBpbnRlcnJ1cHRzIGNh
biBzdGlsbCBjb21lPw0KDQpUaGVuIGl0IHNlZW1zIGl0IGlzIHZlcnkgY29uZnVzaW5nLiBJZiBw
cmlvcml0aXplZCBpbnRlcnJ1cHRzIGNhbiBzdGlsbCBjb21lDQp3aGlsZSBhcmNoX2lycXNfZGlz
YWJsZWQoKSBpcyB0cnVlLCBob3cgY291bGQgc3Bpbl9sb2NrX2lycXNhdmUoKSBibG9jayB0aGUN
CnByaW9yaXRpemVkIGludGVycnVwdHM/IElzbid0IGFyY2hfaXJxc19kaXNhYmxlZCgpIGEgc3Rh
dHVzIHJlZmxlY3Rpb24gb2YNCmlycSBkaXNhYmxlIEFQST8NCg0KVGhhbmtzDQpCYXJyeQ0KDQo=
