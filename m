Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97723C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5635964EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhBXFhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:37:42 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:3383 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhBXFhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 00:37:42 -0500
IronPort-SDR: VFUJjWc2DPJGzoAUvU0BCP2avjDIqsx4Ox2hduoRvJTZJq9AnZI8BKT4zzvr5tlFczBuB+VjQf
 vXahwRMUy6ADeVbFQ9m548+nzVl4Ap2PLsOJ1GYp9w0rkmw0w8mBkb2i741eoDpCFWJRRaYyOM
 DhWreb/mut+z5DTwhtJTawPDgDsyLra5L6KbIq2aHxj0wIMdKHoRoYUXcd/ySYuR6ofLQnl+RR
 vqsQtY+smGab91iFVhFjdV7y8Uu3lxr5KikdenQSZFz4aOTTR0F55MxnSXTMKXnYmn36Fu+8kc
 8yo=
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="47788277"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 23 Feb 2021 21:37:01 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 23 Feb 2021 21:37:00 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 0D1F921A10; Tue, 23 Feb 2021 21:37:00 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
Date:   Tue, 23 Feb 2021 21:36:47 -0800
Message-Id: <1614145010-36079-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In error handling prepare stage, after SCSI requests are blocked, do a
down/up_write(clk_scaling_lock) to clean up the queuecommand() path.
Meanwhile, stop eeh_work in case it disturbs error recovery. Moreover,
reset ufshcd_state at the entrance of ufshcd_probe_hba(), since it may be
called multiple times during error recovery.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80620c8..013eb73 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4987,6 +4987,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * UFS device needs urgent BKOPs.
 			 */
 			if (!hba->pm_op_in_progress &&
+			    !ufshcd_eh_in_progress(hba) &&
 			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) &&
 			    schedule_work(&hba->eeh_work)) {
 				/*
@@ -5784,13 +5785,20 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	}
+	ufshcd_scsi_block_requests(hba);
+	/* Drain ufshcd_queuecommand() */
+	down_write(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+	cancel_work_sync(&hba->eeh_work);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
+	ufshcd_clear_ua_wluns(hba);
 	pm_runtime_put(hba->dev);
 }
 
@@ -5882,8 +5890,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_scsi_block_requests(hba);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -6042,12 +6050,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
-
-	if (!err && needs_reset)
-		ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -7858,6 +7862,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	unsigned long flags;
 	ktime_t start = ktime_get();
 
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+
 	ret = ufshcd_link_startup(hba);
 	if (ret)
 		goto out;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

