Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF190C2BBCD
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2BA233F8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgLPNRo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:17:44 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60959 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbgLPNRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 08:17:44 -0500
X-UUID: b6cf2ffd7d924269b1648e85e37f2489-20201216
X-UUID: b6cf2ffd7d924269b1648e85e37f2489-20201216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1050888559; Wed, 16 Dec 2020 21:16:42 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 21:16:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 21:16:39 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/4] scsi: ufs: Refactor cancelling clkscaling works
Date:   Wed, 16 Dec 2020 21:16:36 +0800
Message-ID: <20201216131639.4128-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201216131639.4128-1-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cancelling suspend_work and resume_work is only required while
suspending clk-scaling. Thus moving these two invokes into
ufshcd_suspend_clkscaling() function.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 052479a56a6f..a91b73a1fc48 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1451,6 +1451,9 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	cancel_work_sync(&hba->clk_scaling.suspend_work);
+	cancel_work_sync(&hba->clk_scaling.resume_work);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (!hba->clk_scaling.is_suspended) {
 		suspend = true;
@@ -1514,9 +1517,6 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
 
-	cancel_work_sync(&hba->clk_scaling.suspend_work);
-	cancel_work_sync(&hba->clk_scaling.resume_work);
-
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
 	} else {
@@ -5663,11 +5663,8 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
 	} else {
 		ufshcd_hold(hba, false);
-		if (hba->clk_scaling.is_enabled) {
-			cancel_work_sync(&hba->clk_scaling.suspend_work);
-			cancel_work_sync(&hba->clk_scaling.resume_work);
+		if (hba->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
-		}
 	}
 	down_write(&hba->clk_scaling_lock);
 	hba->clk_scaling.is_allowed = false;
@@ -8512,11 +8509,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
-	if (hba->clk_scaling.is_enabled) {
-		cancel_work_sync(&hba->clk_scaling.suspend_work);
-		cancel_work_sync(&hba->clk_scaling.resume_work);
+	if (hba->clk_scaling.is_enabled)
 		ufshcd_suspend_clkscaling(hba);
-	}
+
 	down_write(&hba->clk_scaling_lock);
 	hba->clk_scaling.is_allowed = false;
 	up_write(&hba->clk_scaling_lock);
-- 
2.18.0

