Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD5BC4707F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BF5613AF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhE1Djl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 23:39:41 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57835 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229883AbhE1Djk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 23:39:40 -0400
X-UUID: d4bf6b5d5f4d48458fd69ab47ebaf0e8-20210528
X-UUID: d4bf6b5d5f4d48458fd69ab47ebaf0e8-20210528
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <alice.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 989834174; Fri, 28 May 2021 11:38:03 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 May 2021 11:38:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 May 2021 11:38:01 +0800
From:   Alice <alice.chao@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: [PATCH v2 1/2] scsi: ufs: Export ufshcd_hba_stop
Date:   Fri, 28 May 2021 11:36:21 +0800
Message-ID: <20210528033624.12170-2-alice.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210528033624.12170-1-alice.chao@mediatek.com>
References: <20210528033624.12170-1-alice.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Alice.Chao" <alice.chao@mediatek.com>

Export ufshcd_hba_stop to allow vendors to disable HCI in variant ops.

Signed-off-by: Alice.Chao <alice.chao@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3eb54937f1d8..986fab41bc42 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4417,7 +4417,7 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
  * ufshcd_hba_stop - Send controller to reset state
  * @hba: per adapter instance
  */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba)
+void ufshcd_hba_stop(struct ufs_hba *hba)
 {
 	unsigned long flags;
 	int err;
@@ -4436,6 +4436,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
 	if (err)
 		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
 }
+EXPORT_SYMBOL_GPL(ufshcd_hba_stop);
 
 /**
  * ufshcd_hba_execute_hce - initialize the controller
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5eb66a8debc7..708a0a9acff5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -947,6 +947,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				unsigned long timeout_ms);
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
+void ufshcd_hba_stop(struct ufs_hba *hba);
 
 static inline void check_upiu_size(void)
 {
-- 
2.18.0

