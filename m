Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2601C388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8285A2227F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgKCGZR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 01:25:17 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:30196 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCGZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 01:25:16 -0500
IronPort-SDR: JXv9Q1UC6ry6FSYnDYrn5ErYovILaWn2Flo2uexVjBxoNm++K9c664ft/tbDLylpVurzn9J0GV
 N2nREYpNgxbSo/1hPNDPgVmc6Z4NBbsu9OUyGdoW6H+tROIafPc318T9C3ImrE2Ybuz61Z5Jkk
 msUv4IChlk4ENwmPLyr3dbdAemDShzBknqOM1jRNbp5zb4ETwu3Bi3KyOeXu02Yi407AXtGu/5
 6VwIOkOwSjTHNSNXwIxf+f63TSqCDJr92yT/FMGAHzoWo7VebzLodY+IL7vAcLIyEvvQhwutX1
 iTI=
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="29256947"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 02 Nov 2020 22:25:14 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 02 Nov 2020 22:25:03 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 07731217C9; Mon,  2 Nov 2020 22:25:02 -0800 (PST)
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
Subject: [PATCH] scsi: ufs: Try to save power mode change and UIC cmd completion timeout
Date:   Mon,  2 Nov 2020 22:24:41 -0800
Message-Id: <1604384682-15837-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the uic_cmd->cmd_active as a flag to track the lifecycle of an UIC cmd.
The flag is set before send the UIC cmd and cleared after the completion is
raised in IRQ handler. For a power mode change operation, including hibern8
enter/exit, the flag is cleared only after hba->uic_async_done completion
is raised. When completion timeout happens, if the flag is cleared, instead
of returning timeout error, simply ignore it.

Change-Id: Ie3cd6ae6221a44619925fb2cf78136a5617fdd5d
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 252e022..8b291c3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2131,10 +2131,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	unsigned long flags;
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
+					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
-	else
+	} else {
 		ret = -ETIMEDOUT;
+		dev_err(hba->dev,
+			"uic cmd 0x%x with arg3 0x%x completion timeout\n",
+			uic_cmd->command, uic_cmd->argument3);
+
+		if (!uic_cmd->cmd_active) {
+			dev_err(hba->dev, "%s: UIC cmd has been completed, return the result\n",
+				__func__);
+			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
+		}
+	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
@@ -2166,6 +2176,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 	if (completion)
 		init_completion(&uic_cmd->done);
 
+	uic_cmd->cmd_active = 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
 
 	return 0;
@@ -3944,10 +3955,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
+
+		if (!cmd->cmd_active) {
+			dev_err(hba->dev, "%s: Power Mode Change operation has been completed, go check UPMCRS\n",
+				__func__);
+			goto check_upmcrs;
+		}
+
 		ret = -ETIMEDOUT;
 		goto out;
 	}
 
+check_upmcrs:
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
@@ -5060,11 +5079,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 		hba->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
 		complete(&hba->active_uic_cmd->done);
+		if (!hba->uic_async_done)
+			hba->active_uic_cmd->cmd_active = 0;
 		retval = IRQ_HANDLED;
 	}
 
 	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
 		complete(hba->uic_async_done);
+		hba->active_uic_cmd->cmd_active = 0;
 		retval = IRQ_HANDLED;
 	}
 	return retval;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

