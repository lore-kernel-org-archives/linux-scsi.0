Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276ADC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 01:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E63AE23A9D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 01:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbhAOBhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 20:37:13 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:13949 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAOBhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 20:37:12 -0500
IronPort-SDR: lRgqXgWEIvhFu/KcUySbJRnLYYPldxkEii9NaZ9a6uNF+arWDIa3McN3Hq9QZUE6pGJCtw7Jlh
 pDq94ktMD9rsO3EMhYoRwyKQIvZUiS+Q3fHrPWVrzHA5+Uq+TvAqZEmRtQbiwdmFkahVwLAArp
 4eFkDV31AtVV/J8AKZ9hVTnCD1FOT81o7We9Wf1GHYyu2tBHuPOFKt+JMvumgmE4K04F7J1ZEV
 I0Pzf0KZqsJX8q117LBqv+3Krm15uwjjTR2HFKw5s3hKlPOTdQ33eVgWaRkCCy4/TwrNLIRoPl
 5ds=
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="29542002"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 14 Jan 2021 17:36:32 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 14 Jan 2021 17:36:31 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 5A430218C5; Thu, 14 Jan 2021 17:36:31 -0800 (PST)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: Minor adjustments to error handling
Date:   Thu, 14 Jan 2021 17:36:18 -0800
Message-Id: <1610674580-20811-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1610674580-20811-1-git-send-email-cang@codeaurora.org>
References: <1610674580-20811-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In error handling prepare stage, after SCSI requests are blocked, do a
down/up_write(clk_scaling_lock) to clean up the queuecommand() path.
Meanwhile, stop eeh_work in case it disturbs error recovery. Moreover,
reset ufshcd_state at the entrance of ufshcd_probe_hba(), since it may be
called multiple times during error recovery.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 53fd59c..bb0ef70 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4964,6 +4964,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * UFS device needs urgent BKOPs.
 			 */
 			if (!hba->pm_op_in_progress &&
+			    !ufshcd_eh_in_progress(hba) &&
 			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) &&
 			    schedule_work(&hba->eeh_work)) {
 				/*
@@ -5765,10 +5766,16 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 			ufshcd_suspend_clkscaling(hba);
 		}
 	}
+	ufshcd_scsi_block_requests(hba);
+	/* Clean up ufshcd_queuecommand path */
+	down_write(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+	cancel_work_sync(&hba->eeh_work);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_resume_clkscaling(hba);
@@ -5862,8 +5869,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_scsi_block_requests(hba);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -6022,7 +6029,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->eh_sem);
 }
@@ -7836,6 +7842,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	unsigned long flags;
 	ktime_t start = ktime_get();
 
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+
 	ret = ufshcd_link_startup(hba);
 	if (ret)
 		goto out;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

