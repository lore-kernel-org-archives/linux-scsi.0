Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BCCC2BB48
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A934222B6
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLOJki (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:40:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:59060 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728200AbgLOJkc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:40:32 -0500
X-UUID: f7ab351191f14c849d8e2407f373e878-20201215
X-UUID: f7ab351191f14c849d8e2407f373e878-20201215
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 60192814; Tue, 15 Dec 2020 17:39:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:39:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:39:35 +0800
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
Subject: [PATCH v1 1/4] scsi: ufs: Cleanup ufshcd_suspend_clkscaling function
Date:   Tue, 15 Dec 2020 17:39:31 +0800
Message-ID: <20201215093934.21223-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201215093934.21223-1-stanley.chu@mediatek.com>
References: <20201215093934.21223-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A697137FF3D77AF70E1B83643F3DF2E5C7F94A04A846938C5771F16B97E9A4B32000:8
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

