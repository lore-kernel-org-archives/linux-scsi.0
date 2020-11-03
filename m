Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759FEC388F7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21AB2223BF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jpEKNxLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKCHju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 02:39:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54905 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgKCHjt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 02:39:49 -0500
X-UUID: 51b34c5255d245b689b6dde48e5d9086-20201103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZZrwHSS1iEJcnFxsaFwOkWSIeqBrHNXbvsvad1w31c0=;
        b=jpEKNxLMJF3m1Z2UJy/TLKydQxeNHaEsfpxxLSTBf/189X6IgF1caOFcvf27tZduzmCI/3kn4RaTzyE3nu2JoYTuVNoYsK87bkvtjpCf0Y8EVzvwV3BltVdt3UqdsohYaySfcBFan1SZ2JYC6bFUWlXUO9WwookACIf9u9FmsCk=;
X-UUID: 51b34c5255d245b689b6dde48e5d9086-20201103
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 325287640; Tue, 03 Nov 2020 15:39:46 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Nov 2020 15:39:44 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Nov 2020 15:39:44 +0800
Message-ID: <1604389184.13152.9.camel@mtkswgap22>
Subject: RE: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with
 correct type
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Date:   Tue, 3 Nov 2020 15:39:44 +0800
In-Reply-To: <DM6PR04MB6575F51915ED4E904ED82EC1FC110@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
         <20201029115750.24391-2-stanley.chu@mediatek.com>
         <DM6PR04MB6575F51915ED4E904ED82EC1FC110@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 0E859257A7E797E8F756E436308F7A8CC066855BC4D0EBA211CF9AA173D4A0132000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVHVlLCAyMDIwLTExLTAzIGF0IDA3OjEyICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiBJbiB1ZnNfbXRrX3VuaXByb19zZXRfbHBtKCksIHVzZSBzcGVj
aWZpYyB1bnNpZ25lZCB2YWx1ZXMNCj4gPiBhcyB0aGUgYXJndW1lbnQgdG8gaW52b2tlIHVmc2hj
ZF9kbWVfc2V0KCkuDQo+ID4gDQo+ID4gSW4gdGhlIHNhbWUgdGltZSwgY2hhbmdlIHRoZSBuYW1l
IG9mIHVmc19tdGtfdW5pcHJvX3NldF9wbSgpDQo+ID4gdG8gdWZzX210a191bmlwcm9fc2V0X2xw
bSgpIHRvIGFsaWduIHRoZSBuYW1pbmcgY29udmVudGlvbg0KPiA+IGluIE1lZGlhVGVrIFVGUyBk
cml2ZXIuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1
QG1lZGlhdGVrLmNvbT4NCj4gTG9va3MgbGlrZSB0aGlzIHBhdGNoIGlzIGdpbGRpbmcgdGhlIGxp
bHk/DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KUGxlYXNlIHNlZSBleHBsYW5hdGlvbiBi
ZWxvdy4NCg0KPiANCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsu
YyB8IDEyICsrKysrKy0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCA2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiA+IGlu
ZGV4IDhkZjczYmMyZjhjYi4uMDE5NmE4OTA1NWI1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5jDQo+ID4gQEAgLTYzOSwxNCArNjM5LDE0IEBAIHN0YXRpYyBpbnQgdWZzX210a19w
d3JfY2hhbmdlX25vdGlmeShzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEsDQo+ID4gICAgICAgICBy
ZXR1cm4gcmV0Ow0KPiA+ICB9DQo+ID4gDQo+ID4gLXN0YXRpYyBpbnQgdWZzX210a191bmlwcm9f
c2V0X3BtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgbHBtKQ0KPiA+ICtzdGF0aWMgaW50IHVm
c19tdGtfdW5pcHJvX3NldF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBscG0pDQo+ID4g
IHsNCj4gPiAgICAgICAgIGludCByZXQ7DQo+ID4gICAgICAgICBzdHJ1Y3QgdWZzX210a19ob3N0
ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+ID4gDQo+ID4gICAgICAgICByZXQg
PSB1ZnNoY2RfZG1lX3NldChoYmEsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBV
SUNfQVJHX01JQl9TRUwoVlNfVU5JUFJPUE9XRVJET1dOQ09OVFJPTCwgMCksDQo+ID4gLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBscG0pOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgbHBtID8gMSA6IDApOw0KPiBib29sIGlzIGltcGxpY2l0bHkgY29udmVydGVkIHRvIGlu
dCBhbnl3YXk/DQoNClRoaXMgY2hhbmdlIGlzIHRoZSBlY2hvIG9mIHlvdXIgc3VnZ2VzdGlvbiBp
bg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXNjc2kvcGF0Y2gv
MjAyMDA5MDgwNjQ1MDcuMzA3NzQtNC1zdGFubGV5LmNodUBtZWRpYXRlay5jb20vDQoNCkFjdHVh
bGx5IEkgdGhpbmsgeW91ciBzdWdnZXN0aW9uIGlzIGNvbnN0cnVjdGl2ZSB0aGF0IHRoZSBhY2Nl
cHRlZA0KdmFsdWVzIG9mIFZTX1VOSVBST1BPV0VSRE9XTkNPTlRST0wgYXJlIGJldHRlciBjbGVh
cmx5IGRlZmluZWQgc28gSSB1c2UNCnRoZSBjYXN0aW5nIGhlcmUgaW4gdGhpcyBwYXRjaC4NCg0K
PiANCj4gPiAgICAgICAgIGlmICghcmV0IHx8ICFscG0pIHsNCj4gPiAgICAgICAgICAgICAgICAg
LyoNCj4gPiAgICAgICAgICAgICAgICAgICogRm9yY2libHkgc2V0IGFzIG5vbi1MUE0gbW9kZSBp
ZiBVSUMgY29tbWFuZHMgaXMgZmFpbGVkDQo+ID4gQEAgLTY2NCw3ICs2NjQsNyBAQCBzdGF0aWMg
aW50IHVmc19tdGtfcHJlX2xpbmsoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgICAgICAgIGlu
dCByZXQ7DQo+ID4gICAgICAgICB1MzIgdG1wOw0KPiA+IA0KPiA+IC0gICAgICAgcmV0ID0gdWZz
X210a191bmlwcm9fc2V0X3BtKGhiYSwgZmFsc2UpOw0KPiA+ICsgICAgICAgcmV0ID0gdWZzX210
a191bmlwcm9fc2V0X2xwbShoYmEsIGZhbHNlKTsNCj4gPiAgICAgICAgIGlmIChyZXQpDQo+ID4g
ICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gDQo+ID4gQEAgLTc3NCw3ICs3NzQsNyBA
QCBzdGF0aWMgaW50IHVmc19tdGtfbGlua19zZXRfaHBtKHN0cnVjdCB1ZnNfaGJhDQo+ID4gKmhi
YSkNCj4gPiAgICAgICAgIGlmIChlcnIpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiBlcnI7
DQo+ID4gDQo+ID4gLSAgICAgICBlcnIgPSB1ZnNfbXRrX3VuaXByb19zZXRfcG0oaGJhLCBmYWxz
ZSk7DQo+ID4gKyAgICAgICBlcnIgPSB1ZnNfbXRrX3VuaXByb19zZXRfbHBtKGhiYSwgZmFsc2Up
Ow0KPiA+ICAgICAgICAgaWYgKGVycikNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIGVycjsN
Cj4gPiANCj4gPiBAQCAtNzk1LDEwICs3OTUsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtf
c2V0X2xwbShzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEpDQo+ID4gIHsNCj4gPiAgICAgICAgIGlu
dCBlcnI7DQo+ID4gDQo+ID4gLSAgICAgICBlcnIgPSB1ZnNfbXRrX3VuaXByb19zZXRfcG0oaGJh
LCB0cnVlKTsNCj4gPiArICAgICAgIGVyciA9IHVmc19tdGtfdW5pcHJvX3NldF9scG0oaGJhLCB0
cnVlKTsNCj4gPiAgICAgICAgIGlmIChlcnIpIHsNCj4gPiAgICAgICAgICAgICAgICAgLyogUmVz
dW1lIFVuaVBybyBzdGF0ZSBmb3IgZm9sbG93aW5nIGVycm9yIHJlY292ZXJ5ICovDQo+ID4gLSAg
ICAgICAgICAgICAgIHVmc19tdGtfdW5pcHJvX3NldF9wbShoYmEsIGZhbHNlKTsNCj4gPiArICAg
ICAgICAgICAgICAgdWZzX210a191bmlwcm9fc2V0X2xwbShoYmEsIGZhbHNlKTsNCj4gPiAgICAg
ICAgICAgICAgICAgcmV0dXJuIGVycjsNCj4gPiAgICAgICAgIH0NCj4gPiANCj4gPiAtLQ0KPiA+
IDIuMTguMA0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQo=

