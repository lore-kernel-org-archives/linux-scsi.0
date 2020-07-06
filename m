Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3D5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4642075B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="u7wVUTpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgGFGHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:07:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:35226 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728747AbgGFGHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:07:13 -0400
X-UUID: 28bcc605ca014749835e2b07ab78cbe5-20200706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TEVJ+Nr51pohIXBKHppotISQ5SGWi6nMpNvyxh0dqh4=;
        b=u7wVUTpXFHtcf3DF+PloFy7FAEuFtIm37rJC/+n3PjG/OrXb3g35FOVe/ndJTZ9nM38v1bW6U4sgeAJ6yn8z/ZO/cH/lIDjJR8sjKtF/ASlWENP0SfTXKYfLBYWBmiI9epAS3VDHl6SSRYTFu4MI9yMvUSsUrrQwq8ppuVfPfRg=;
X-UUID: 28bcc605ca014749835e2b07ab78cbe5-20200706
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2011109653; Mon, 06 Jul 2020 14:07:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Jul 2020 14:07:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 14:07:05 +0800
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
Subject: [PATCH v1 1/2] scsi: ufs: Simplify completion timestamp for SCSI and query commands
Date:   Mon, 6 Jul 2020 14:07:06 +0800
Message-ID: <20200706060707.32608-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200706060707.32608-1-stanley.chu@mediatek.com>
References: <20200706060707.32608-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U2ltcGxpZnkgcmVjb3JkaW5nIGNvbW1hbmQgY29tcGxldGlvbiB0aW1lIGluDQpfX3Vmc2hjZF90
cmFuc2Zlcl9yZXFfY29tcGwoKSBieSBhc3NpZ25pbmcgbHJicC0+Y29tcGxfdGltZV9zdGFtcA0K
aW4gYW4gdW5pZmllZCBsb2NhdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0
YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCAzICstLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQppbmRleCAxOGRhMmQ2NGY5ZmEuLjcxZThkN2M3ODJiZCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCkBAIC00ODgxLDYgKzQ4ODEsNyBAQCBzdGF0aWMgdm9pZCBfX3Vmc2hjZF90cmFuc2Zl
cl9yZXFfY29tcGwoc3RydWN0IHVmc19oYmEgKmhiYSwNCiANCiAJZm9yX2VhY2hfc2V0X2JpdChp
bmRleCwgJmNvbXBsZXRlZF9yZXFzLCBoYmEtPm51dHJzKSB7DQogCQlscmJwID0gJmhiYS0+bHJi
W2luZGV4XTsNCisJCWxyYnAtPmNvbXBsX3RpbWVfc3RhbXAgPSBrdGltZV9nZXQoKTsNCiAJCWNt
ZCA9IGxyYnAtPmNtZDsNCiAJCWlmIChjbWQpIHsNCiAJCQl1ZnNoY2RfYWRkX2NvbW1hbmRfdHJh
Y2UoaGJhLCBpbmRleCwgImNvbXBsZXRlIik7DQpAQCAtNDg4OSwxMyArNDg5MCwxMSBAQCBzdGF0
aWMgdm9pZCBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoc3RydWN0IHVmc19oYmEgKmhiYSwN
CiAJCQljbWQtPnJlc3VsdCA9IHJlc3VsdDsNCiAJCQkvKiBNYXJrIGNvbXBsZXRlZCBjb21tYW5k
IGFzIE5VTEwgaW4gTFJCICovDQogCQkJbHJicC0+Y21kID0gTlVMTDsNCi0JCQlscmJwLT5jb21w
bF90aW1lX3N0YW1wID0ga3RpbWVfZ2V0KCk7DQogCQkJLyogRG8gbm90IHRvdWNoIGxyYnAgYWZ0
ZXIgc2NzaSBkb25lICovDQogCQkJY21kLT5zY3NpX2RvbmUoY21kKTsNCiAJCQlfX3Vmc2hjZF9y
ZWxlYXNlKGhiYSk7DQogCQl9IGVsc2UgaWYgKGxyYnAtPmNvbW1hbmRfdHlwZSA9PSBVVFBfQ01E
X1RZUEVfREVWX01BTkFHRSB8fA0KIAkJCWxyYnAtPmNvbW1hbmRfdHlwZSA9PSBVVFBfQ01EX1RZ
UEVfVUZTX1NUT1JBR0UpIHsNCi0JCQlscmJwLT5jb21wbF90aW1lX3N0YW1wID0ga3RpbWVfZ2V0
KCk7DQogCQkJaWYgKGhiYS0+ZGV2X2NtZC5jb21wbGV0ZSkgew0KIAkJCQl1ZnNoY2RfYWRkX2Nv
bW1hbmRfdHJhY2UoaGJhLCBpbmRleCwNCiAJCQkJCQkiZGV2X2NvbXBsZXRlIik7DQotLSANCjIu
MTguMA0K

