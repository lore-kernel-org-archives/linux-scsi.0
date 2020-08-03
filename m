Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BEEC433E3
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A1320786
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHCJFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 05:05:12 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:41081 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgHCJFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 05:05:11 -0400
IronPort-SDR: zRexsfCqaEhZdY034AtWx3HE7j7QVGJHTWsaAsIVsF2odNnR6UXa803ufhNEeY31gt3Hyxp7lL
 hJbIJpQAPlY1pojS9Yg3kMONPDp43HIM2On8mTT/yxU9OHoIrh+10W8Z4B9HvxXBF8hs0ayi3l
 nVJcx4DX5AEnoT5BE34vYKEIuqhndQPyTgmrSUixqYBeNNqFnQd/g+XtYl80Z18e+kj1cv+jka
 Vtdj1Ad0LXe0YgRRLyyY/ptWIciTDpWw17GiEBnEegPz5LCnJ1DP6XjRdj9gVM914CyeC+OBsW
 EB4=
X-IronPort-AV: E=Sophos;i="5.75,429,1589266800"; 
   d="scan'208";a="29063953"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 03 Aug 2020 02:05:11 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 03 Aug 2020 02:05:10 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 8D12E214E4; Mon,  3 Aug 2020 02:05:10 -0700 (PDT)
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
Subject: [PATCH v9 7/9] scsi: ufs: Move dumps in IRQ handler to error handler
Date:   Mon,  3 Aug 2020 02:04:42 -0700
Message-Id: <1596445485-19834-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometime dumps in IRQ handler are heavy enough to cause system stability
issues, move them to error handler and only print basic host regs here.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a10003..a79fbbd 100644
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

