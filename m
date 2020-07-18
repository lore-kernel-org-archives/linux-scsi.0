Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986B4C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 04:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C60F2083E
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 04:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgGRENU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:13:20 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:38944 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgGRENU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 00:13:20 -0400
IronPort-SDR: Q1lRdZgW4Gu7pv+dBZUFmr7jVIFHAExgHTtQ4rfdoJ6aVa8KvbEYnkLHg4Xd3HIOb0/BHO1Bur
 ODCflAt4ZRc1fyYeUK2S+tJmn/QSDHscnnzK6athuHmekX4U2hoj2z6zbHf1rJFWvSgzfJR/0j
 J+ClTF3U3x6oiPu2/ujbxmrnyk1nZXMeRmisju9ApVg2CkIwiwd0xwiB6eNr9+HzBKymcDHbJF
 iFDdjRKZI18ccb5tyjOEqiycYGfqtwVSXm/3VEnps/mx7rtAmfZx/CpGmTkQaXC7LuobW8ib1B
 aDc=
X-IronPort-AV: E=Sophos;i="5.75,365,1589266800"; 
   d="scan'208";a="47222742"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 17 Jul 2020 21:13:20 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg04-sd.qualcomm.com with ESMTP; 17 Jul 2020 21:13:19 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 402F822D61; Fri, 17 Jul 2020 21:13:19 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/4] scsi: ufs: Add checks before setting clk-gating states
Date:   Fri, 17 Jul 2020 21:13:01 -0700
Message-Id: <1595045585-16402-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595045585-16402-1-git-send-email-cang@codeaurora.org>
References: <1595045585-16402-1-git-send-email-cang@codeaurora.org>
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
index efc0a6c..9ddfd13 100644
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
+	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
+		(hba->clk_gating.state != CLKS_ON));
 
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

