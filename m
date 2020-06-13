Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296C4C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 14:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07F3207BC
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 14:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g0wX4/9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFMOSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Jun 2020 10:18:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60263 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbgFMOSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2020 10:18:40 -0400
X-UUID: c184aa17f8104b1a9208789351e2921b-20200613
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=wHRgb/U6EDepiWXV4OCkOGKqYbDMEPUS8ORL4G6vBio=;
        b=g0wX4/9zL38TPFHqu9k31wM43At4ZGQ1sAE29H2OQq+SkpZtpvONOTHitoafQpBvRb+qjtkqsck3SYOfRDisSI5IaC5VCulTGWjJ1Kt+DLhEiuSAvmJnKFPQvxo3G6uEsbAy0OB+IVhK5hpEeObXCP9GR9Kx+lm3JjVjPH9bRHY=;
X-UUID: c184aa17f8104b1a9208789351e2921b-20200613
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1479505449; Sat, 13 Jun 2020 22:18:32 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 13 Jun 2020 22:18:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 13 Jun 2020 22:18:28 +0800
Message-ID: <1592057910.25636.81.camel@mtkswgap22>
Subject: RE: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Sat, 13 Jun 2020 22:18:30 +0800
In-Reply-To: <SN6PR04MB4640968DCD865651AFA8925DFC9E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
         <20200612151000.27639-3-stanley.chu@mediatek.com>
         <SN6PR04MB4640968DCD865651AFA8925DFC9E0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: C5756CE2E349CF9053AF970775DB6925B7A04576EC619A0BCFF76E5D910C78282000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU2F0LCAyMDIwLTA2LTEzIGF0IDEwOjQ4ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiArc3RhdGljIHZvaWQgdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFjZShz
dHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IHVpY19jb21tYW5kICp1Y21kLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqc3RyKQ0KPiA+ICt7DQo+ID4gKyAg
ICAgICB1MzIgY21kOw0KPiA+ICsNCj4gPiArICAgICAgIGlmICghdHJhY2VfdWZzaGNkX3VpY19j
b21tYW5kX2VuYWJsZWQoKSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsNCj4g
PiArICAgICAgIGlmICghc3RyY21wKHN0ciwgInVpY19zZW5kIikpDQo+ID4gKyAgICAgICAgICAg
ICAgIGNtZCA9IHVjbWQtPmNvbW1hbmQ7DQo+ID4gKyAgICAgICBlbHNlDQo+ID4gKyAgICAgICAg
ICAgICAgIGNtZCA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VSUNfQ09NTUFORCk7DQo+IFdoeSBv
biBjb21wbGV0ZSB5b3UgY2FuJ3QganVzdCB1c2UgdWNtZC0+Y29tbWFuZCBhcyB3ZWxsPw0KDQpS
ZWFkaW5nIHJlZ2lzdGVycyBpcyByZWFsbHkgaGVscGZ1bCBmb3IgZGVidWdnaW5nIHRvIGNoZWNr
IGlmIGhvc3QgVUlDDQpjb21tYW5kIHJlZ2lzdGVyIHJlYWxseSByZWNlaXZlZCB0aGUgY29tbWFu
ZCBiZWZvcmUuDQoNCkJ1dCB0aGUgb3JpZ2luYWwgcmVxdWVzdGluZyBVSUMgY29tbWFuZCBzaGFs
bCBiZSBsb2dnZWQgaW4gdHJhY2Ugc28NCnVjbWQtPmNvbW1hbmQgaXMgbG9nZ2VkIGR1cmluZyAi
c2VuZCIsIGFuZCB0aGUgY29tbWFuZCBpbiByZWdpc3RlciBpcw0KcmVhZCBhbmQgbG9nZ2VkIGR1
cmluZyAiY29tcGxldGVkIi4gVGhlbiB3ZSBjb3VsZCBzaW1wbHkgY2hlY2sgdGhlbSB0bw0Ka25v
dyBpZiBzb21ldGhpbmcgd3Jvbmcgd2hpbGUgc2VuZGluZyB0aGUgY29tbWFuZC4NCg0KVGhpcyBj
b25jZXB0IGlzIHNpbWlsYXIgYXMgY3VycmVudCBVVFAgY29tbWFuZCB0cmFjZSBldmVudHMgdGhh
dA0KZG9vcmJlbGwgcmVnaXN0ZXIgaXMgcmVhZCBhbmQgZHVtcGVkIGluIHRoZSB0cmFjZS4NCg0K
PiANCj4gPiArDQo+ID4gKyAgICAgICB0cmFjZV91ZnNoY2RfdWljX2NvbW1hbmQoZGV2X25hbWUo
aGJhLT5kZXYpLCBzdHIsIGNtZCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB1Y21kLT5yZXN1bHQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdWZz
aGNkX3JlYWRsKGhiYSwgUkVHX1VJQ19DT01NQU5EX0FSR18xKSwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUlDX0NPTU1BTkRfQVJH
XzIpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVmc2hjZF9yZWFkbCho
YmEsIFJFR19VSUNfQ09NTUFORF9BUkdfMykpOw0KPiBXaHkgY2FuJ3QgeW91IGp1c3QgdXNlIHRo
ZSB1Y21kIG1lbWJlcnM/DQo+IFdoeSBuZWVkIHRvIHJlYWQgdGhvc2U/DQoNCkFzIGFib3ZlIHNh
bWUgcmVhc29uLCByZWFkaW5nIHJlZ2lzdGVycyBjYW4ga25vdyB3aGljaCBhcmd1bWVudHMgYXJl
DQpleGFjdGx5IHNlbnQgdG8gdGhlIGRldmljZS4NCg0KVGhpcyBpcyB2ZXJ5IGhlbHBmdWwgZm9y
IGZhc3QgaXNzdWUgYnJlYWtkb3duIGlmIFVJQyBjb21tYW5kIGlzIG5vdA0KcmVzcG9uZGVkIHVu
ZGVyIGV4cGVjdGF0aW9uLg0KDQpIZXJlLCB3ZSBhbHNvIHJlYWxseSB3YW50IHRvIGtlZXAgdGhl
IG9yaWdpbmFsIHJlcXVlc3RpbmcgYXJndW1lbnRzIGZyb20NCiJ1Y21kIiwganVzdCBsaWtlIFVJ
QyBjb21tYW5kLiBIb3dldmVyLCBhcmd1bWVudHMgaW4gcmVnaXN0ZXIgd2lsbCBiZQ0KY2hhbmdl
ZCBhZnRlciBVSUMgY29tbWFuZCBpcyBkb25lIHNvIHdlIGNhbiBub3QgZG8gdGhlIHNhbWUgd2F5
IGFzIFVJQw0KY29tbWFuZC4gU28gYSBjb21wcm9taXNlIGlzIGhlcmUgdGhhdCB3ZSBsb2dnZWQg
dGhlIGFyZ3VtZW50cyB3aGljaCBob3N0DQpyZWdpc3RlciBleGFjdGx5IHJlY2VpdmVkIGluIHRy
YWNlLg0KDQo+IA0KPiA+ICt9DQo+IA0KPiANCj4gPiArDQo+ID4gIHN0YXRpYyB2b2lkIHVmc2hj
ZF9hZGRfY29tbWFuZF90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+ICAgICAgICAgICAg
ICAgICB1bnNpZ25lZCBpbnQgdGFnLCBjb25zdCBjaGFyICpzdHIpDQo+ID4gIHsNCj4gPiBAQCAt
MjA1NCw2ICsyMDc1LDggQEAgdWZzaGNkX2Rpc3BhdGNoX3VpY19jbWQoc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gPiBzdHJ1Y3QgdWljX2NvbW1hbmQgKnVpY19jbWQpDQo+ID4gICAgICAgICAvKiBX
cml0ZSBVSUMgQ21kICovDQo+ID4gICAgICAgICB1ZnNoY2Rfd3JpdGVsKGhiYSwgdWljX2NtZC0+
Y29tbWFuZCAmIENPTU1BTkRfT1BDT0RFX01BU0ssDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
IFJFR19VSUNfQ09NTUFORCk7DQo+ID4gKw0KPiA+ICsgICAgICAgdWZzaGNkX2FkZF91aWNfY29t
bWFuZF90cmFjZShoYmEsIHVpY19jbWQsICJ1aWNfc2VuZCIpOw0KPiA+ICB9DQo+ID4gDQo+ID4g
IC8qKg0KPiA+IEBAIC0yMDgwLDYgKzIxMDMsOSBAQCB1ZnNoY2Rfd2FpdF9mb3JfdWljX2NtZChz
dHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+IHN0cnVjdCB1aWNfY29tbWFuZCAqdWljX2NtZCkNCj4g
PiAgICAgICAgIGhiYS0+YWN0aXZlX3VpY19jbWQgPSBOVUxMOw0KPiA+ICAgICAgICAgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+IA0KPiA+
ICsgICAgICAgdWljX2NtZC0+cmVzdWx0ID0gcmV0Ow0KPiA+ICsgICAgICAgdWZzaGNkX2FkZF91
aWNfY29tbWFuZF90cmFjZShoYmEsIHVpY19jbWQsICJ1aWNfY29tcGxldGUiKTsNCj4gPiArDQo+
ID4gICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICB9DQo+IENhbid0IHlvdSBqdXN0IGNhbGwgdGhl
ICJzZW5kIiBhbmQgImNvbXBsZXRlIiBmcm9tIHVmc2hjZF9zZW5kX3VpY19jbWQ/DQoNCkZvciAi
c2VuZCIsIHdlIHdvdWxkIGxpa2UgdG8gbG9nIHRoZSB0aW1lIGFzIHByZWNpc2UgYXMgcG9zc2li
bGUgc28NCiJzZW5kIiBldmVudCBpcyBsb2dnZWQgd2hpbGUgVUlDIGNvbW1hbmQgaXMgc2VudC4N
Cg0KVGhhbmtzIHNvIG11Y2ghIFlvdXIgcXVlc3Rpb24gcmVtaW5kcyBtZSB0aGF0ICJzZW5kIiB0
cmFjZSBzaGFsbCBiZQ0KbW92ZWQgYmVmb3JlIFVJQyBjb21tYW5kIGlzIHNlbnQgb3RoZXJ3aXNl
IHJlZ2lzdGVyIHZhbHVlIG1heSBiZSBjaGFuZ2VkDQpiZWZvcmUgbG9nZ2luZyAic2VuZCIgdHJh
Y2UuIEkgd2lsbCBmaXggdGhpcyBpbiBuZXh0IHZlcnNpb24uDQoNCkZvciAiY29tcGxldGVkIiwg
dG8gbWFrZSBsb2dnaW5nIHRpbWUgYXMgY2xvc2VkIHRvIFVJQyBjb21tYW5kDQpjb21wbGV0aW9u
IGFzIHBvc3NpYmxlLCBtYXliZSBJIG5lZWQgdG8gY2hhbmdlIHRoZSBsb2dnaW5nIHRpbWluZyB0
bw0KdWZzaGNkX3VpY19jbWRfY29tcGwoKSwganVzdCBsaWtlIFVUUCBjb21tYW5kIGNvbXBsZXRp
b24gdHJhY2Ugd2hpY2ggaXMNCmxvZ2dlZCBpbiBfX3Vmc2hjZF90cmFuc2Zlcl9yZWdfY29tcGwo
KS4NCg0KSWYgeW91IGhhdmUgbm8gb2JqZWN0aW9uLCBJIHdpbGwgdHJ5IHRvIGZpeCB0aGlzIGlu
IG5leHQgdmVyc2lvbi4NCg0KPiANCj4gDQo+ID4gDQo+ID4gQEAgLTM3NjAsNiArMzc4Niw5IEBA
IHN0YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+
IHN0cnVjdCB1aWNfY29tbWFuZCAqY21kKQ0KPiA+ICAgICAgICAgICAgICAgICByZXQgPSAoc3Rh
dHVzICE9IFBXUl9PSykgPyBzdGF0dXMgOiAtMTsNCj4gPiAgICAgICAgIH0NCj4gPiAgb3V0Og0K
PiA+ICsgICAgICAgY21kLT5yZXN1bHQgPSByZXQ7DQo+ID4gKyAgICAgICB1ZnNoY2RfYWRkX3Vp
Y19jb21tYW5kX3RyYWNlKGhiYSwgY21kLCAidWljX2NvbXBsZXRlIik7DQo+ID4gKw0KPiA+ICAg
ICAgICAgaWYgKHJldCkgew0KPiA+ICAgICAgICAgICAgICAgICB1ZnNoY2RfcHJpbnRfaG9zdF9z
dGF0ZShoYmEpOw0KPiA+ICAgICAgICAgICAgICAgICB1ZnNoY2RfcHJpbnRfcHdyX2luZm8oaGJh
KTsNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmggYi9pbmNsdWRl
L3RyYWNlL2V2ZW50cy91ZnMuaA0KPiA+IGluZGV4IDVmMzAwNzM5MjQwZC4uY2Y4ZDU2OGQ1YTEz
IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oDQo+ID4gKysrIGIv
aW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmgNCj4gPiBAQCAtMjQ5LDYgKzI0OSwzOSBAQCBUUkFD
RV9FVkVOVCh1ZnNoY2RfY29tbWFuZCwNCj4gPiAgICAgICAgICkNCj4gPiAgKTsNCj4gPiANCj4g
PiArVFJBQ0VfRVZFTlQodWZzaGNkX3VpY19jb21tYW5kLA0KPiA+ICsgICAgICAgVFBfUFJPVE8o
Y29uc3QgY2hhciAqZGV2X25hbWUsIGNvbnN0IGNoYXIgKnN0ciwgdTMyIGNtZCwgaW50IHJlc3Vs
dCwNCj4gPiArICAgICAgICAgICAgICAgIHUzMiBhcmcxLCB1MzIgYXJnMiwgdTMyIGFyZzMpLA0K
PiA+ICsNCj4gPiArICAgICAgIFRQX0FSR1MoZGV2X25hbWUsIHN0ciwgY21kLCByZXN1bHQsIGFy
ZzEsIGFyZzIsIGFyZzMpLA0KPiA+ICsNCj4gPiArICAgICAgIFRQX1NUUlVDVF9fZW50cnkoDQo+
ID4gKyAgICAgICAgICAgICAgIF9fc3RyaW5nKGRldl9uYW1lLCBkZXZfbmFtZSkNCj4gPiArICAg
ICAgICAgICAgICAgX19zdHJpbmcoc3RyLCBzdHIpDQo+ID4gKyAgICAgICAgICAgICAgIF9fZmll
bGQodTMyLCBjbWQpDQo+ID4gKyAgICAgICAgICAgICAgIF9fZmllbGQoaW50LCByZXN1bHQpDQo+
ID4gKyAgICAgICAgICAgICAgIF9fZmllbGQodTMyLCBhcmcxKQ0KPiA+ICsgICAgICAgICAgICAg
ICBfX2ZpZWxkKHUzMiwgYXJnMikNCj4gPiArICAgICAgICAgICAgICAgX19maWVsZCh1MzIsIGFy
ZzMpDQo+ID4gKyAgICAgICApLA0KPiA+ICsNCj4gPiArICAgICAgIFRQX2Zhc3RfYXNzaWduKA0K
PiA+ICsgICAgICAgICAgICAgICBfX2Fzc2lnbl9zdHIoZGV2X25hbWUsIGRldl9uYW1lKTsNCj4g
PiArICAgICAgICAgICAgICAgX19hc3NpZ25fc3RyKHN0ciwgc3RyKTsNCj4gPiArICAgICAgICAg
ICAgICAgX19lbnRyeS0+Y21kID0gY21kOw0KPiA+ICsgICAgICAgICAgICAgICBfX2VudHJ5LT5y
ZXN1bHQgPSByZXN1bHQ7DQo+ID4gKyAgICAgICAgICAgICAgIF9fZW50cnktPmFyZzEgPSBhcmcx
Ow0KPiA+ICsgICAgICAgICAgICAgICBfX2VudHJ5LT5hcmcyID0gYXJnMjsNCj4gPiArICAgICAg
ICAgICAgICAgX19lbnRyeS0+YXJnMyA9IGFyZzM7DQo+ID4gKyAgICAgICApLA0KPiA+ICsNCj4g
PiArICAgICAgIFRQX3ByaW50aygNCj4gPiArICAgICAgICAgICAgICAgIiVzOiAlczogY21kOiAw
eCV4LCBhcmcxOiAweCV4LCBhcmcyOiAweCV4LCBhcmczOiAweCV4LCByZXN1bHQ6ICVkIiwNCj4g
PiArICAgICAgICAgICAgICAgX19nZXRfc3RyKHN0ciksIF9fZ2V0X3N0cihkZXZfbmFtZSksIF9f
ZW50cnktPmNtZCwNCj4gPiArICAgICAgICAgICAgICAgX19lbnRyeS0+YXJnMSwgX19lbnRyeS0+
YXJnMiwgX19lbnRyeS0+YXJnMywgX19lbnRyeS0+cmVzdWx0DQo+ID4gKyAgICAgICApDQo+IFBl
cnNvbmFsbHksIGFzIHRob3NlIHRyYWNlIGV2ZW50cyBhcmVuJ3QgdmVyeSBodW1hbiByZWFkYWJs
ZSBhbnl3YXksIEkgd291bGQganVzdCBkdW1wIHRoZSB1aWMgY29tbWFuZCwNCj4gQW5kIGxldCB0
aGUgcGFyc2VycyBkbyB0aGVpciBqb2IuDQo+IEFuZCBpZiB0aGlzIGlzIHRoZSBjYXNlLCByZXN1
bHQgaXMgcmVkdW5kYW50IGFzIGl0IGlzIHBhcnQgb2YgYXJnMg0KDQpNeSBvcmlnaW5hbCB0aG91
Z2h0IGlzIHRvIGxvZyBzb21lIGV4Y2VwdGlvbnMsIGxpa2UgIi1FVElNRURPVVQiIGluDQoicmVz
dWx0Ii4gQnV0IGlmIEkgY2hhbmdlZCAiY29tcGxldGlvbiIgdHJhY2UgaGFuZGxpbmcgdG8gaW50
ZXJydXB0DQpoYW5kbGVyLCB0aGVyZSB3aWxsIGJlIG5vIGNoYW5jZSB0byBsb2cgdGhvc2UgZXhj
ZXB0aW9ucy4gVGhpcyBpcyBPSw0KYmVjYXVzZSBVVFAgdHJhY2UgaXMgZXhhY3RseSBiZWhhdmUg
dGhpcyB3YXk6IE5vIGNvbXBsZXRpb24gZXZlbnQgaW4NCnRyYWNlIGlmIHJlcXVlc3QgaXMgbm90
IGJhY2suIEFuZCBpZiB0aGlzIHdheSBpcyBpbXBsZW1lbnRlZCwgInJlc3VsdCINCmlzIGRlZmlu
aXRlbHkgcmVkdW5kYW50IGFuZCBzaGFsbCBiZSByZW1vdmVkLg0KDQpUaGFua3MsDQpTdGFubGV5
IENodQ0KDQo=

