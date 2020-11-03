Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAD7C388F9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E15822277
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgKCGY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 01:24:58 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:4484 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbgKCGY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 01:24:57 -0500
IronPort-SDR: GDc74n/LjJBtVr6QTJhtHMCHBJFutl2B5aqzYGeprI40wzRHtGbL3VWxlZAQSm0Citcme+tSIr
 J+FrAH64d4KutD6BYNFqpXWlCO3aEy8cLyoH4NjqeKYgyVU7/xxaxoyMwA4JE6fDHlq5D+zIST
 pJTPubfDIpym66Qo9/qdCH8mHWAgO4KVcJUGZFSTeT/CrhNbadKGugxwQDf1uq0Je+xcykl61N
 D8hxvzZr1C0WtCzRNkBRkPwwzTgZToYEmHYK5Z+7qVjg95puS3oetMp7n8Ol5ivwk3BMDseGAz
 mZg=
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="47412256"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 02 Nov 2020 22:24:56 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 02 Nov 2020 22:24:55 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 68C4E217C9; Mon,  2 Nov 2020 22:24:55 -0800 (PST)
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
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs: Try to save power mode change and UIC cmd completion timeout
Date:   Mon,  2 Nov 2020 22:24:40 -0800
Message-Id: <1604384682-15837-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the uic_cmd->cmd_active as a flag to track the lifecycle of an UIC cmd.
The flag is set before send the UIC cmd and cleared in IRQ handler. When a
PMC or UIC cmd completion timeout happens, if the flag is not set, instead
of returning timeout error, we still treat it as a successful operation.
This is to deal with the scenario in which completion has been raised but
the one waiting for the completion cannot be awaken in time due to kernel
scheduling problem.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index efa7d86..7f33310 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2122,10 +2122,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
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
@@ -2157,6 +2167,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 	if (completion)
 		init_completion(&uic_cmd->done);
 
+	uic_cmd->cmd_active = 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
 
 	return 0;
@@ -3828,10 +3839,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
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
@@ -4923,11 +4942,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 			ufshcd_get_uic_cmd_result(hba);
 		hba->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
+		if (!hba->uic_async_done)
+			hba->active_uic_cmd->cmd_active = 0;
 		complete(&hba->active_uic_cmd->done);
 		retval = IRQ_HANDLED;
 	}
 
 	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
+		hba->active_uic_cmd->cmd_active = 0;
 		complete(hba->uic_async_done);
 		retval = IRQ_HANDLED;
 	}
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 66e5338..be982ed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -64,6 +64,7 @@ enum dev_cmd_type {
  * @argument1: UIC command argument 1
  * @argument2: UIC command argument 2
  * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding
  * @done: UIC command completion
  */
 struct uic_command {
@@ -71,6 +72,7 @@ struct uic_command {
 	u32 argument1;
 	u32 argument2;
 	u32 argument3;
+	int cmd_active;
 	struct completion done;
 };
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

