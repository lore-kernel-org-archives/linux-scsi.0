Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8882EC47257
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6495F21655
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 06:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QUWQr+4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgECGEF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 02:04:05 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:29426 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726931AbgECGEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 02:04:05 -0400
X-UUID: 2577f8c191a143a6a363cdd4a87b16cd-20200503
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=axYdivepqlgkjKZMDc+q6wcYI5dYnIuDFbudgz9mHU4=;
        b=QUWQr+4ZUEdFHI0yt4kIZbvR6XHYwLTMEcrscEqFnk4Ig1dEtzaA+ZKeDWK8e3UNjaPkMD2DnkjBr/h+PvzUMqisp/Hg33MkuxPMHRO1WpBMcMJoQtU4k630Vs6E98wn3ALmzURQDbsqAU4DQOzXfwBsxe3hhBHUmyaFt3mpLtk=;
X-UUID: 2577f8c191a143a6a363cdd4a87b16cd-20200503
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 821661675; Sun, 03 May 2020 14:03:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 3 May 2020 14:03:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 14:03:54 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Date:   Sun, 3 May 2020 14:03:45 +0800
Message-ID: <20200503060351.10572-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200503060351.10572-1-stanley.chu@mediatek.com>
References: <20200503060351.10572-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBVRlMgZGVpdmNlcyBtYXkgaGF2ZSByZXF1aXJlZCBkZXZpY2UgcXVpcmtzIG9yIGhhdmUg
bm9uLXN0YW5kYXJkDQpmZWF0dXJlcyB3aGljaCBhcmUgZW5hYmxlZCBvbmx5IG9uIHNwZWNpZmll
ZCBVRlMgaG9zdHMgb3IgZm9yIHNwZWNpYWwNCmN1c3RvbWVycy4NCg0KVG8gbm90ICJwb2xsdXRl
IiBjb21tb24gZGV2aWNlIHF1aXJrIGxpc3QsIGkuZS4sIHVmc19maXh1cHMgdGFibGUgZm9yDQp0
aG9zZSBkZXZpY2VzIG1lbnRpb25lZCBhYm92ZSwgaW50cm9kdWNlICJmaXh1cF9kZXZfcXVpcmtz
IiB2b3BzIHRvDQphbGxvdyB2ZW5kb3JzIHRvIGZpeCBvciBtb2RpZnkgZGV2aWNlIHF1aXJrcyBh
Y2NvcmRpbmdseS4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAxICsNCiBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgNyArKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCA4IGlu
c2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQppbmRleCAwNGRkZmIxNWU4NTguLmRhN2IzNzU3MDli
NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCkBAIC02ODk5LDYgKzY4OTksNyBAQCBzdGF0aWMgaW50IHVmc19n
ZXRfZGV2aWNlX2Rlc2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCiAJfQ0KIA0KIAl1ZnNfZml4dXBf
ZGV2aWNlX3NldHVwKGhiYSk7DQorCXVmc2hjZF92b3BzX2ZpeHVwX2Rldl9xdWlya3MoaGJhKTsN
CiANCiAJLyoNCiAJICogUHJvYmUgV0Igb25seSBmb3IgVUZTLTMuMSBkZXZpY2VzIG9yIFVGUyBk
ZXZpY2VzIHdpdGggcXVpcmsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggMDU2NTM3ZTUyYzE5Li41ZmEwM2Uw
ZjNiZDEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtMzM2LDYgKzMzNiw3IEBAIHN0cnVjdCB1ZnNfaGJh
X3ZhcmlhbnRfb3BzIHsNCiAJdm9pZCAgICAoKmhpYmVybjhfbm90aWZ5KShzdHJ1Y3QgdWZzX2hi
YSAqLCBlbnVtIHVpY19jbWRfZG1lLA0KIAkJCQkJZW51bSB1ZnNfbm90aWZ5X2NoYW5nZV9zdGF0
dXMpOw0KIAlpbnQJKCphcHBseV9kZXZfcXVpcmtzKShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCisJ
dm9pZAkoKmZpeHVwX2Rldl9xdWlya3MpKHN0cnVjdCB1ZnNfaGJhICpoYmEpOw0KIAlpbnQgICAg
ICgqc3VzcGVuZCkoc3RydWN0IHVmc19oYmEgKiwgZW51bSB1ZnNfcG1fb3ApOw0KIAlpbnQgICAg
ICgqcmVzdW1lKShzdHJ1Y3QgdWZzX2hiYSAqLCBlbnVtIHVmc19wbV9vcCk7DQogCXZvaWQJKCpk
YmdfcmVnaXN0ZXJfZHVtcCkoc3RydWN0IHVmc19oYmEgKmhiYSk7DQpAQCAtMTA4NSw2ICsxMDg2
LDEyIEBAIHN0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF92b3BzX2FwcGx5X2Rldl9xdWlya3Moc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUgdm9p
ZCB1ZnNoY2Rfdm9wc19maXh1cF9kZXZfcXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQorew0K
KwlpZiAoaGJhLT52b3BzICYmIGhiYS0+dm9wcy0+Zml4dXBfZGV2X3F1aXJrcykNCisJCWhiYS0+
dm9wcy0+Zml4dXBfZGV2X3F1aXJrcyhoYmEpOw0KK30NCisNCiBzdGF0aWMgaW5saW5lIGludCB1
ZnNoY2Rfdm9wc19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIG9w
KQ0KIHsNCiAJaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPnN1c3BlbmQpDQotLSANCjIuMTgu
MA0K

