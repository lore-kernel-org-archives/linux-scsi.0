Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1746CC2BBCA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D568C22509
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgLOJky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:40:54 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:59050 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728300AbgLOJkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:40:47 -0500
X-UUID: 15492db03985405d860f43f9e3a91c6f-20201215
X-UUID: 15492db03985405d860f43f9e3a91c6f-20201215
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1953850868; Tue, 15 Dec 2020 17:39:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:39:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:39:36 +0800
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
Subject: [PATCH v1 3/4] scsi: ufs: Cleanup and refactor clk-scaling feature
Date:   Tue, 15 Dec 2020 17:39:33 +0800
Message-ID: <20201215093934.21223-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201215093934.21223-1-stanley.chu@mediatek.com>
References: <20201215093934.21223-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3CAFF49127AEEC67EFC7D1E363E3F12449FA4DAFF1E67EE4408B68ABB45E843A2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Manipulate clock scaling related stuff only if the host capability
supports clock scaling feature to avoid redundant code execution.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 54 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cc16598136d..15e5877411b3 100644
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
@@ -5663,7 +5657,8 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
 	} else {
 		ufshcd_hold(hba, false);
-		if (hba->clk_scaling.is_enabled)
+		if (ufshcd_is_clkscaling_supported(hba) &&
+		    hba->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
 	}
 	down_write(&hba->clk_scaling_lock);
@@ -5678,7 +5673,8 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	down_write(&hba->clk_scaling_lock);
 	hba->clk_scaling.is_allowed = true;
 	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
+	if (ufshcd_is_clkscaling_supported(hba) &&
+	    hba->clk_scaling.is_enabled)
 		ufshcd_resume_clkscaling(hba);
 	pm_runtime_put(hba->dev);
 }
@@ -8466,6 +8462,25 @@ static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
 		ufshcd_setup_hba_vreg(hba, true);
 }
 
+static void ufshcd_clk_scaling_pm(struct ufs_hba *hba, bool suspend)
+{
+	if (suspend) {
+		if (hba->clk_scaling.is_enabled)
+			ufshcd_suspend_clkscaling(hba);
+
+		down_write(&hba->clk_scaling_lock);
+		hba->clk_scaling.is_allowed = false;
+		up_write(&hba->clk_scaling_lock);
+	} else {
+		down_write(&hba->clk_scaling_lock);
+		hba->clk_scaling.is_allowed = true;
+		up_write(&hba->clk_scaling_lock);
+
+		if (hba->clk_scaling.is_enabled)
+			ufshcd_resume_clkscaling(hba);
+	}
+}
+
 /**
  * ufshcd_suspend - helper function for suspend operations
  * @hba: per adapter instance
@@ -8507,12 +8522,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_suspend_clkscaling(hba);
-
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = false;
-	up_write(&hba->clk_scaling_lock);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_pm(hba, true);
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
@@ -8618,11 +8629,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = true;
-	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_resume_clkscaling(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_pm(hba, false);
+
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
@@ -8719,11 +8728,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	hba->clk_gating.is_suspended = false;
 
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = true;
-	up_write(&hba->clk_scaling_lock);
-	if (hba->clk_scaling.is_enabled)
-		ufshcd_resume_clkscaling(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_clk_scaling_pm(hba, false);
 
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
-- 
2.18.0

