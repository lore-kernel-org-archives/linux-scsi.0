Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D79EC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09265611AC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhFWHjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:49 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:46767 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhFWHj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:28 -0400
IronPort-SDR: 25XuRK9IuinLb2dsg5AberW6mEs7JsWq12WmHo8WbPHrPsfIqaKD1csCoNQXS/6rGGWELoxUwI
 XT9K7hFfQ7mrv6fJu9fjhGlFEwxsuAPBjM5MefxfKDZ0xEJyLuSo7t7E0rWTZ1wcmpMKnHab8O
 zLI6tc9mfmSf1hoXIAP8AKpsOS4xd06RTb8Puf1oPbuJFYvwu44TR7CRG5C2xWAU5GakerhxQO
 WbB8prvB5zjowXhoJ0r7SYxQZD6fJyfNw/Q95bGApc+1joMrEd3rgZltTEI864q5YPq+r8nzn8
 UV8=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="29780821"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:11 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:37:10 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id D312D21BC1; Wed, 23 Jun 2021 00:37:10 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in suspend/resume
Date:   Wed, 23 Jun 2021 00:35:06 -0700
Message-Id: <1624433711-9339-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To protect system suspend/resume from being disturbed by error handling,
instead of using host_sem, let error handler call lock_system_sleep() and
unlock_system_sleep() which achieve the same purpose. Remove the host_sem
used in suspend/resume paths to make the code more readable.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3695dd2..a09e4a2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5907,6 +5907,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	/*
+	 * It is not safe to perform error handling while suspend or resume is
+	 * in progress. Hence the lock_system_sleep() call.
+	 */
+	lock_system_sleep();
 	ufshcd_rpm_get_sync(hba);
 	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
 	    hba->is_wlu_sys_suspended) {
@@ -5951,6 +5956,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_clear_ua_wluns(hba);
 	ufshcd_rpm_put(hba);
+	unlock_system_sleep();
 }
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -9053,16 +9059,13 @@ static int ufshcd_wl_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
-	down(&hba->host_sem);
 
 	if (pm_runtime_suspended(dev))
 		goto out;
 
 	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
-	if (ret) {
+	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
-		up(&hba->host_sem);
-	}
 
 out:
 	if (!ret)
@@ -9095,7 +9098,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_wlu_sys_suspended = false;
-	up(&hba->host_sem);
 	return ret;
 }
 #endif
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

