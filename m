Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DDAC433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 05:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1019B206C0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 05:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bd896+5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHIFI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 01:08:28 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56590 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbgHIFI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 01:08:27 -0400
X-UUID: 3886343308c846c5b743285c9b51a7e6-20200809
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=n5rpOkS/9YzOZBQ2IqBRfdrcZmfEvjOti8eNGJiZ+ys=;
        b=bd896+5yIlzMczsrDT+5GvUq7hAwlVB10L1XylVZcrM8XFC9aX1rly6CpnZ+cpzfsIQgLj9B3QD4/9ig+FQSeDwPqObsx0OzY7GUpN+8unEpJ10g2O39JWJh2GvAs0lRveuXrZIRD035V5gaIwKtGmQWooUt3zDydHPM1ITg7Zo=;
X-UUID: 3886343308c846c5b743285c9b51a7e6-20200809
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 328196676; Sun, 09 Aug 2020 13:08:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 9 Aug 2020 13:07:33 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 Aug 2020 13:07:33 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3] scsi: ufs: Fix possible infinite loop in ufshcd_hold
Date:   Sun, 9 Aug 2020 13:07:34 +0800
Message-ID: <20200809050734.18740-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: BE00B5FA824ED99B1C6B9E2F0B73FA1E619CF8E4178918B797D1658D07BEBB112000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SW4gdWZzaGNkX3N1c3BlbmQoKSwgYWZ0ZXIgY2xrLWdhdGluZyBpcyBzdXNwZW5kZWQgYW5kIGxp
bmsgaXMgc2V0DQphcyBIaWJlcm44IHN0YXRlLCB1ZnNoY2RfaG9sZCgpIGlzIHN0aWxsIHBvc3Np
Ymx5IGludm9rZWQgYmVmb3JlDQp1ZnNoY2Rfc3VzcGVuZCgpIHJldHVybnMuIEZvciBleGFtcGxl
LCBNZWRpYVRlaydzIHN1c3BlbmQgdm9wcyBtYXkNCmlzc3VlIFVJQyBjb21tYW5kcyB3aGljaCB3
b3VsZCBjYWxsIHVmc2hjZF9ob2xkKCkgZHVyaW5nIHRoZSBjb21tYW5kDQppc3N1aW5nIGZsb3cu
DQoNCk5vdyBpZiBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HIGNhcGFiaWxpdHkg
aXMgZW5hYmxlZCwNCnRoZW4gdWZzaGNkX2hvbGQoKSBtYXkgZW50ZXIgaW5maW5pdGUgbG9vcHMg
YmVjYXVzZSB0aGVyZSBpcyBubw0KY2xrLXVuZ2F0aW5nIHdvcmsgc2NoZWR1bGVkIG9yIHBlbmRp
bmcuIEluIHRoaXMgY2FzZSwgdWZzaGNkX2hvbGQoKQ0Kc2hhbGwganVzdCBieXBhc3MsIGFuZCBr
ZWVwIHRoZSBsaW5rIGFzIEhpYmVybjggc3RhdGUuDQoNCkNvLURldmVsb3BlZC1ieTogQW5keSBU
ZW5nIDxhbmR5LnRlbmdAbWVkaWF0ZWsuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxh
dnJpLmFsdG1hbkB3ZGMuY29tPg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KQ2hhbmdlcyBzaW5jZSB2MjoNCiAgICAtIFJlYmFzZSB0
byB0aGUgbGF0ZXN0IE1hcnRpbidzIHF1ZXVlIGJyYW5jaA0KICAgIC0gQWRkIG1pc3NpbmcgUmV2
aWV3ZWQgdGFnIHNpbmNlIEF2cmkncyBsZXR0ZXIgaXMgbm90IHNob3dpbmcgdXAgaW4gTEtNTCBh
bmQgUGF0Y2h3b3JrDQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgNSArKysrLQ0K
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jDQppbmRleCAzMDc2MjIyODQyMzkuLmI0Zjk0ODAyN2IzZSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCkBA
IC0xNTYxLDYgKzE1NjEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNoY2RfdW5nYXRlX3dvcmsoc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQ0KIGludCB1ZnNoY2RfaG9sZChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCBib29sIGFzeW5jKQ0KIHsNCiAJaW50IHJjID0gMDsNCisJYm9vbCBmbHVzaF9yZXN1bHQ7DQog
CXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQogCWlmICghdWZzaGNkX2lzX2Nsa2dhdGluZ19hbGxv
d2VkKGhiYSkpDQpAQCAtMTU5Miw3ICsxNTkzLDkgQEAgaW50IHVmc2hjZF9ob2xkKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIGJvb2wgYXN5bmMpDQogCQkJCWJyZWFrOw0KIAkJCX0NCiAJCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQotCQkJZmx1c2hf
d29yaygmaGJhLT5jbGtfZ2F0aW5nLnVuZ2F0ZV93b3JrKTsNCisJCQlmbHVzaF9yZXN1bHQgPSBm
bHVzaF93b3JrKCZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmspOw0KKwkJCWlmIChoYmEtPmNs
a19nYXRpbmcuaXNfc3VzcGVuZGVkICYmICFmbHVzaF9yZXN1bHQpDQorCQkJCWdvdG8gb3V0Ow0K
IAkJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQogCQkJ
Z290byBzdGFydDsNCiAJCX0NCi0tIA0KMi4xOC4wDQo=

