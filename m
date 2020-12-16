Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FC5C2BBCF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F401223407
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgLPNRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:17:46 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60973 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbgLPNRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 08:17:46 -0500
X-UUID: d177ab417976450bafb135f63a96bf8f-20201216
X-UUID: d177ab417976450bafb135f63a96bf8f-20201216
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1839463626; Wed, 16 Dec 2020 21:16:43 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 21:16:38 +0800
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
Subject: [PATCH v2 3/4] scsi: ufs: Cleanup and refactor clk-scaling feature
Date:   Wed, 16 Dec 2020 21:16:38 +0800
Message-ID: <20201216131639.4128-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201216131639.4128-1-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0E421CE0C17336D5D05C23F0CF20E7FE5670D862594CD5AF3E17BD277F234B072000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Manipulate clock scaling related stuff only if the host capability
supports clock scaling feature to avoid redundant code execution.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 64 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cc16598136d..ce0528f2e2ed 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1448,9 +1448,6 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 	unsigned long flags;
 	bool suspend = false;
 
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return;
-
 	cancel_work_sync(&hba->clk_scaling.suspend_work);
 	cancel_work_sync(&hba->clk_scaling.resume_work);
 
@@ -1470,9 +1467,6 @@ static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 	unsigned long flags;
 	bool resume = false;
 
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return;
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->clk_scaling.is_suspended) {
 		resume = true;
@@ -5642,6 +5636,26 @@ static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
+{
+	down_write(&hba->clk_scaling_lock);
+	hba->clk_scaling.is_allowed = allow;
+	up_write(&hba->clk_scaling_lock);
+}
+
+static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
+{
+	if (suspend) {
+		if (hba->clk_scaling.is_enabled)
+			ufshcd_suspend_clkscaling(hba);
+		ufshcd_clk_scaling_allow(hba, false);
+	} else {
+		ufshcd_clk_scaling_allow(hba, true);
+		if (hba->clk_scaling.is_enabled)
+			ufshcd_resume_clkscaling(hba);
+	}
+}
+
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
 	pm_runtime_get_sync(hba->dev);
@@ -5663,23 +5677,20 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
 	} else {
 		ufshcd_hold(hba, false);
-		if (hba->clk_scaling.is_enabled)
+		if (ufshcd_is_clkscaling_supported(hba) &&
+		    hba->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
 	}
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = false;
-	up_write(&hba->clk_scaling_lock);
+	ufshcd_clk_scaling_allow(hba, false);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
 	ufshcd_release(hba);
 
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = true;
-	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_resume_clkscaling(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_suspend(hba, false);
+
 	pm_runtime_put(hba->dev);
 }
 
@@ -8507,12 +8518,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_suspend_clkscaling(hba);
-
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = false;
-	up_write(&hba->clk_scaling_lock);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_suspend(hba, true);
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
@@ -8618,11 +8625,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = true;
-	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_resume_clkscaling(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_suspend(hba, false);
+
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
@@ -8719,11 +8724,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	hba->clk_gating.is_suspended = false;
 
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = true;
-	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_resume_clkscaling(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_suspend(hba, false);
 
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
-- 
2.18.0

