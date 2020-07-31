Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7546FC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9DA206DA
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbgGaOI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:08:27 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:12145 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387526AbgGaOI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 10:08:27 -0400
IronPort-SDR: yNlKDWRRZ0qJ3kT/3Nnk4Y5plJSVwMrzrKlMnqfhCK2jWz++3Xjcu/56kJp5gFl0WxPaHPKAMZ
 f1JUy+AH7xGRs+gqSBpeaIdDxIugTzZddcN+54BS2uRF4qtfQSq2K2au/CwMv9FUdBBGp0rBJB
 fNjEXkQPsyqOFsucYwWWP7mYUp29Pfhghw9oP4O0VHMemYNqmzNfith526/bZOuINYoj7C7qq+
 E4OeV7Vp6vuhJvB0rA4TcRnWVMjB0geTQ1UR8QsYN0ZVabPlrCtEq9QlldwYjB9rzqXNpX1HZb
 l40=
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="47235774"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 31 Jul 2020 07:08:27 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 31 Jul 2020 07:08:26 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 2E10B22E5A; Fri, 31 Jul 2020 07:08:26 -0700 (PDT)
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
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 7/8] scsi: ufs: Move dumps in IRQ handler to error handler
Date:   Fri, 31 Jul 2020 07:07:55 -0700
Message-Id: <1596204478-5420-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596204478-5420-1-git-send-email-cang@codeaurora.org>
References: <1596204478-5420-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometime dumps in IRQ handler are heavy enough to cause system stability
issues, move them to error handler and only print basic host regs here.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6bdf2bf..523b771 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5696,6 +5696,19 @@ static void ufshcd_err_handler(struct work_struct *work)
 				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
 		needs_reset = true;
 
+	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
+			      UFSHCD_UIC_HIBERN8_MASK)) {
+		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ufshcd_print_host_state(hba);
+		ufshcd_print_pwr_info(hba);
+		ufshcd_print_host_regs(hba);
+		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+		ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	}
+
 	/*
 	 * if host reset is required then skip clearing the pending
 	 * transfers forcefully because they will get cleared during
@@ -5915,18 +5928,12 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 
 		/* dump controller state before resetting */
 		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
-			bool pr_prdt = !!(hba->saved_err &
-					SYSTEM_BUS_FATAL_ERROR);
-
 			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
 					__func__, hba->saved_err,
 					hba->saved_uic_err);
-
-			ufshcd_print_host_regs(hba);
+			ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE,
+					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
-			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-			ufshcd_print_trs(hba, hba->outstanding_reqs,
-					pr_prdt);
 		}
 		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

