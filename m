Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50A9C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 03:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F3A23A57
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 03:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgLRDcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 22:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgLRDcO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 22:32:14 -0500
From:   Jaegeuk Kim <jaegeuk@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Date:   Thu, 17 Dec 2020 19:31:31 -0800
Message-Id: <20201218033131.2624065-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When gate_work/ungate_work gets an error during hibern8_enter or exit,
 ufshcd_err_handler()
   ufshcd_scsi_block_requests()
   ufshcd_reset_and_restore()
     ufshcd_clear_ua_wluns() -> stuck
   ufshcd_scsi_unblock_requests()

In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery flows
such as suspend/resume, link_recovery, and error_handler.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add25a7e..e711def829cd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3963,6 +3963,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
+	else
+		ufshcd_clear_ua_wluns(hba);
 
 	return ret;
 }
@@ -5968,6 +5970,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->eh_sem);
+
+	ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -6908,14 +6912,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshcd_set_clk_freq(hba, true);
 
 	err = ufshcd_hba_enable(hba);
-	if (err)
-		goto out;
 
 	/* Establish the link again and restore the device */
-	err = ufshcd_probe_hba(hba, false);
 	if (!err)
-		ufshcd_clear_ua_wluns(hba);
-out:
+		err = ufshcd_probe_hba(hba, false);
+
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
 	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
@@ -8745,6 +8746,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
+	ufshcd_clear_ua_wluns(hba);
 	ufshcd_release(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
@@ -8855,6 +8857,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
 
-- 
2.29.2.729.g45daf8777d-goog

