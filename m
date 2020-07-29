Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40080C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE9720663
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kMAixCiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgG2FSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:18:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:41150 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbgG2FSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 01:18:52 -0400
X-UUID: fb8c768a8ce64b0f88330079f964f83e-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=AiW8oR0hft7D4lqwhgoiimjhk6Sk5LoavMLolAc9+uE=;
        b=kMAixCiS+/p1KXt1K1WXEZdN5icS/7d/+Q05fBuS4NUMeqRsR667H0V32ff3mcABeWMM44IJYhCIpCpedZndvE8Q/FCL8fMp/iUDsaoieu1OI9VnTTjHQ9k4JVyIiUEIJ6bR4ymf6j8tQN/Uo0Bd2lsh2CEfjwUEiuaLwC4YD7Q=;
X-UUID: fb8c768a8ce64b0f88330079f964f83e-20200729
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 154831121; Wed, 29 Jul 2020 13:18:48 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 13:18:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 13:18:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>
CC:     <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs: Introduce device quirk "DELAY_AFTER_LPM"
Date:   Wed, 29 Jul 2020 13:18:39 +0800
Message-ID: <20200729051840.31318-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200729051840.31318-1-stanley.chu@mediatek.com>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0D04A94861386952C8B68E824B73A7255AEB99E12A9CBFEE23563D1A21504EC12000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBVRlMgZGV2aWNlcyByZXF1aXJlIGRlbGF5IGFmdGVyIFZDQyBwb3dlciByYWlsIGlzIHR1
cm5lZC1vZmYuDQpJbnRyb2R1Y2UgYSBkZXZpY2UgcXVpcmsgIkRFTEFZX0FGVEVSX0xQTSIgdG8g
YWRkIDVtcyBkZWxheXMgYWZ0ZXINClZDQyBwb3dlci1vZmYgZHVyaW5nIHN1c3BlbmQgZmxvdy4N
Cg0KU2lnbmVkLW9mZi1ieTogQW5keSBUZW5nIDxhbmR5LnRlbmdAbWVkaWF0ZWsuY29tPg0KU2ln
bmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogZHJp
dmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAgNyArKysrKysrDQogZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyAgICAgfCAxMSArKysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5z
ZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmgg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaA0KaW5kZXggMmEwMDQxNDkzZTMwLi4wN2Y1
NTlhYzU4ODMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaA0KKysr
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmgNCkBAIC0xMDksNCArMTA5LDExIEBAIHN0
cnVjdCB1ZnNfZGV2X2ZpeCB7DQogICovDQogI2RlZmluZSBVRlNfREVWSUNFX1FVSVJLX1NVUFBP
UlRfRVhURU5ERURfRkVBVFVSRVMgKDEgPDwgMTApDQogDQorLyoNCisgKiBTb21lIFVGUyBkZXZp
Y2VzIHJlcXVpcmUgZGVsYXkgYWZ0ZXIgVkNDIHBvd2VyIHJhaWwgaXMgdHVybmVkLW9mZi4NCisg
KiBFbmFibGUgdGhpcyBxdWlyayB0byBpbnRyb2R1Y2UgNW1zIGRlbGF5cyBhZnRlciBWQ0MgcG93
ZXItb2ZmIGR1cmluZw0KKyAqIHN1c3BlbmQgZmxvdy4NCisgKi8NCisjZGVmaW5lIFVGU19ERVZJ
Q0VfUVVJUktfREVMQVlfQUZURVJfTFBNICAgICAgICAoMSA8PCAxMSkNCisNCiAjZW5kaWYgLyog
VUZTX1FVSVJLU19IXyAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCBhY2JhMjI3MWM1ZDMuLjYzZjRlMmY3
NWFhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBAIC04MTExLDYgKzgxMTEsOCBAQCBzdGF0aWMgaW50IHVm
c2hjZF9saW5rX3N0YXRlX3RyYW5zaXRpb24oc3RydWN0IHVmc19oYmEgKmhiYSwNCiANCiBzdGF0
aWMgdm9pZCB1ZnNoY2RfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KKwli
b29sIHZjY19vZmYgPSBmYWxzZTsNCisNCiAJLyoNCiAJICogSXQgc2VlbXMgc29tZSBVRlMgZGV2
aWNlcyBtYXkga2VlcCBkcmF3aW5nIG1vcmUgdGhhbiBzbGVlcCBjdXJyZW50DQogCSAqIChhdGxl
YXN0IGZvciA1MDB1cykgZnJvbSBVRlMgcmFpbHMgKGVzcGVjaWFsbHkgZnJvbSBWQ0NRIHJhaWwp
Lg0KQEAgLTgxMzksMTMgKzgxNDEsMjIgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3ZyZWdfc2V0X2xw
bShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KIAlpZiAodWZzaGNkX2lzX3Vmc19kZXZfcG93ZXJvZmYo
aGJhKSAmJiB1ZnNoY2RfaXNfbGlua19vZmYoaGJhKSAmJg0KIAkgICAgIWhiYS0+ZGV2X2luZm8u
aXNfbHVfcG93ZXJfb25fd3ApIHsNCiAJCXVmc2hjZF9zZXR1cF92cmVnKGhiYSwgZmFsc2UpOw0K
KwkJdmNjX29mZiA9IHRydWU7DQogCX0gZWxzZSBpZiAoIXVmc2hjZF9pc191ZnNfZGV2X2FjdGl2
ZShoYmEpKSB7DQogCQl1ZnNoY2RfdG9nZ2xlX3ZyZWcoaGJhLT5kZXYsIGhiYS0+dnJlZ19pbmZv
LnZjYywgZmFsc2UpOw0KKwkJdmNjX29mZiA9IHRydWU7DQogCQlpZiAoIXVmc2hjZF9pc19saW5r
X2FjdGl2ZShoYmEpKSB7DQogCQkJdWZzaGNkX2NvbmZpZ192cmVnX2xwbShoYmEsIGhiYS0+dnJl
Z19pbmZvLnZjY3EpOw0KIAkJCXVmc2hjZF9jb25maWdfdnJlZ19scG0oaGJhLCBoYmEtPnZyZWdf
aW5mby52Y2NxMik7DQogCQl9DQogCX0NCisNCisJLyoNCisJICogU29tZSBVRlMgZGV2aWNlcyBy
ZXF1aXJlIGRlbGF5IGFmdGVyIFZDQyBwb3dlciByYWlsIGlzIHR1cm5lZC1vZmYuDQorCSAqLw0K
KwlpZiAodmNjX29mZiAmJiBoYmEtPnZyZWdfaW5mby52Y2MgJiYNCisJCWhiYS0+ZGV2X3F1aXJr
cyAmIFVGU19ERVZJQ0VfUVVJUktfREVMQVlfQUZURVJfTFBNKQ0KKwkJdXNsZWVwX3JhbmdlKDUw
MDAsIDUxMDApOw0KIH0NCiANCiBzdGF0aWMgaW50IHVmc2hjZF92cmVnX3NldF9ocG0oc3RydWN0
IHVmc19oYmEgKmhiYSkNCi0tIA0KMi4xOC4wDQo=

