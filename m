Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1408C43445
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BF720825
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgGWLrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:47:03 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:37421 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbgGWLrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 07:47:01 -0400
IronPort-SDR: FqecuWXJo4kGCPSL8SeMEWIIWBDadrZ/Wi2JXjfgp/Rf6LufEZflKnuCaTUEK0kfVGWVYa77sS
 XlcPqUtI3pn9mrzEC2eoTHMqpW34qvfs6lMSArYavSEWxbHiYXbVuInXGR+sbKjLBasSlYM0sY
 dgfNsATKPPBObEQutgylKxXBK6oOSGBvgvgP+awGAHkGwhiW9V2pqJwTMquzvWO719Yvdn9DaR
 TxB3QAmE7zM6zfGvnGPqDgnCaAi4GIbZKADxNukSrkEUwUgIGHCHSxh0Mr2xowEHHgGbGPC/w0
 1Pc=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="47229402"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 23 Jul 2020 04:47:00 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 23 Jul 2020 04:46:59 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id A0DA522E23; Thu, 23 Jul 2020 04:46:59 -0700 (PDT)
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
Subject: [PATCH v6 7/8] scsi: ufs: Move dumps in IRQ handler to error handler
Date:   Thu, 23 Jul 2020 04:46:25 -0700
Message-Id: <1595504787-19429-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
References: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometime dumps in IRQ handler are heavy enough to cause system stability
issues, move them to error handler.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c480823..b2bafa3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5682,6 +5682,21 @@ static void ufshcd_err_handler(struct work_struct *work)
 				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
 		needs_reset = true;
 
+	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
+			      UFSHCD_UIC_HIBERN8_MASK)) {
+		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
+
+		dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
+				__func__, hba->saved_err, hba->saved_uic_err);
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
@@ -5900,22 +5915,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 
 		/* block commands from scsi mid-layer */
 		ufshcd_scsi_block_requests(hba);
-
-		/* dump controller state before resetting */
-		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
-			bool pr_prdt = !!(hba->saved_err &
-					SYSTEM_BUS_FATAL_ERROR);
-
-			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
-					__func__, hba->saved_err,
-					hba->saved_uic_err);
-
-			ufshcd_print_host_regs(hba);
-			ufshcd_print_pwr_info(hba);
-			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-			ufshcd_print_trs(hba, hba->outstanding_reqs,
-					pr_prdt);
-		}
 		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

