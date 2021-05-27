Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D86C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 15:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7FA4613BF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 15:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhE0QBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 12:01:05 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:38166 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234147AbhE0QBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 12:01:04 -0400
X-UUID: 05a690dadd484569a137615899435cc3-20210527
X-UUID: 05a690dadd484569a137615899435cc3-20210527
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <alice.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1039475866; Thu, 27 May 2021 23:59:27 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 May 2021 23:59:26 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 23:59:26 +0800
From:   Alice <alice.chao@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: [PATCH 1/1] scsi: ufs: Export ufshcd_hba_stop
Date:   Thu, 27 May 2021 23:58:16 +0800
Message-ID: <20210527155817.15006-1-alice.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
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

