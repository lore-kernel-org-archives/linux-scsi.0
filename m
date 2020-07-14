Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A09C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5E820773
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGNC2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 22:28:20 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:26314 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNC2U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 22:28:20 -0400
IronPort-SDR: A87NJChYtSQopguNtv4r8EhhJOIUm9vFIMxCy/hVqWZHHGnf+xdnl0gGAMCQlZW4ZPPBJKcoQ5
 N2sHEtChEfOUZhxF7PC2jZkdrb7HuktG5jRQxth/fwR2Izs5A1n/KEdvJUOQZbqgG2/Eb3r79I
 a6eO2yHvjNJqV5MTuF7cLNhIFuoxMU54a3mEhL5dSGLg4Ev/zZ0FBq1b/sBZnLNjbMO19vrFtT
 ijKIrcQqCXQn/eX5DMLB8ea0c0HAMs1Zj2tS87so/707Xpj9bFYnNSbK9vGuce3f3fAYlTGgE6
 2SU=
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="47216744"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 13 Jul 2020 19:28:19 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 13 Jul 2020 19:28:18 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id DEE8D22DC2; Mon, 13 Jul 2020 19:28:18 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] scsi: ufs: Add checks before setting clk-gating states
Date:   Mon, 13 Jul 2020 19:28:09 -0700
Message-Id: <1594693693-22466-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clock gating features can be turned on/off selectively which means its
state information is only important if it is enabled. This change makes
sure that we only look at state of clk-gating if it is enabled.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index efc0a6c..ebf7a95 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1839,6 +1839,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
+	hba->clk_gating.state = CLKS_ON;
+
 	hba->clk_gating.delay_ms = 150;
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
@@ -2538,7 +2540,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		err = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
-	WARN_ON(hba->clk_gating.state != CLKS_ON);
+	if (ufshcd_is_clkgating_allowed(hba))
+		WARN_ON(hba->clk_gating.state != CLKS_ON);
 
 	lrbp = &hba->lrb[tag];
 
@@ -8315,8 +8318,11 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		/* If link is active, device ref_clk can't be switched off */
 		__ufshcd_setup_clocks(hba, false, true);
 
-	hba->clk_gating.state = CLKS_OFF;
-	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		hba->clk_gating.state = CLKS_OFF;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
+	}
 
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
@@ -8456,6 +8462,11 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_suspend_clkscaling(hba);
 	ufshcd_setup_clocks(hba, false);
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		hba->clk_gating.state = CLKS_OFF;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
+	}
 out:
 	hba->pm_op_in_progress = 0;
 	if (ret)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

