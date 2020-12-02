Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8F4C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1BB206A4
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgLBDs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 22:48:26 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:35360 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgLBDs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 22:48:26 -0500
IronPort-SDR: +2iklZMFj41B9sTG3ei4cnAn+W0DtC/kjVfHQ8cYhx5c5xhaf8qFx/DZc2Cj5N+LibOvQ3OvXm
 Oc94MCsQ51cyQZ1JPsnrGF8M5S1T7izuk3iWeKdoimDlvhMlhCm3Tz3Tm1fp/0BC9IJV0xiyfB
 A6czLUD+fPK0VS38eDediOsqynmmLATR2JvtrNkfSqcroF/XHuqoMDTdMZPKAm0Tzv5ddjbWr9
 hGbVb0OKFbikMm8AYtK+HLd6zxvH6N+o1msxwc2fTy6UwAOr4Qo49Toc+YvlANgi7P5uaa7BHp
 d9Q=
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="47538811"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 01 Dec 2020 19:47:25 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 01 Dec 2020 19:47:23 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E1DA12106B; Tue,  1 Dec 2020 19:47:23 -0800 (PST)
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
Subject: [PATCH v4 2/3] scsi: ufs: Fix a race condition between ufshcd_abort and eh_work
Date:   Tue,  1 Dec 2020 19:47:07 -0800
Message-Id: <1606880829-27500-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606880829-27500-1-git-send-email-cang@codeaurora.org>
References: <1606880829-27500-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In current task abort routine, if task abort happens to the device W-LU,
the code directly jumps to ufshcd_eh_host_reset_handler() to perform a
full reset and restore then returns FAIL or SUCCESS. Commands sent to the
device W-LU are most likely the SSU cmds sent during UFS PM operations. If
such SSU cmd enters task abort routine, when ufshcd_eh_host_reset_handler()
flushes eh_work, it will get stuck there since err_handler is serialized
with PM operations.

In order to unblock above call path, we merely clean up the lrb taken by
this cmd, queue the eh_work and return SUCCESS. Once the cmd is aborted,
the PM operation which sends out the cmd just errors out, then err_handler
shall be able to proceed with the full reset and restore.

In this scenario, the cmd is aborted even before it is actually cleared by
HW, set the lrb->in_use flag to prevent subsequent cmds, including SCSI
cmds and dev cmds, from taking the lrb released from abort. The flag shall
evetually be cleared in __ufshcd_transfer_req_compl() invoked by the full
reset and restore from err_handler.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 55 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7e764e8..cd7394e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2539,6 +2539,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		(hba->clk_gating.state != CLKS_ON));
 
 	lrbp = &hba->lrb[tag];
+	if (unlikely(lrbp->in_use)) {
+		if (hba->pm_op_in_progress)
+			set_host_byte(cmd, DID_BAD_TARGET);
+		else
+			err = SCSI_MLQUEUE_HOST_BUSY;
+		ufshcd_release(hba);
+		goto out;
+	}
 
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
@@ -2781,6 +2789,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
+	if (unlikely(lrbp->in_use)) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
@@ -2797,6 +2810,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
 
+out:
 	ufshcd_add_query_upiu_trace(hba, tag,
 			err ? "query_complete_err" : "query_complete");
 
@@ -4932,6 +4946,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
+		lrbp->in_use = false;
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
 		if (cmd) {
@@ -6374,8 +6389,12 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
+	if (unlikely(lrbp->in_use)) {
+		err = -EBUSY;
+		goto out;
+	}
 
+	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
@@ -6447,6 +6466,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		}
 	}
 
+out:
 	blk_put_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
@@ -6696,16 +6716,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		BUG();
 	}
 
-	/*
-	 * Task abort to the device W-LUN is illegal. When this command
-	 * will fail, due to spec violation, scsi err handling next step
-	 * will be to send LU reset which, again, is a spec violation.
-	 * To avoid these unnecessary/illegal step we skip to the last error
-	 * handling stage: reset and restore.
-	 */
-	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
-		return ufshcd_eh_host_reset_handler(cmd);
-
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
@@ -6726,7 +6736,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * to reduce repeated printouts. For other aborted requests only print
 	 * basic details.
 	 */
-	scsi_print_command(hba->lrb[tag].cmd);
+	scsi_print_command(cmd);
 	if (!hba->req_abort_count) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
 		ufshcd_print_host_regs(hba);
@@ -6745,6 +6755,27 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto cleanup;
 	}
 
+	/*
+	 * Task abort to the device W-LUN is illegal. When this command
+	 * will fail, due to spec violation, scsi err handling next step
+	 * will be to send LU reset which, again, is a spec violation.
+	 * To avoid these unnecessary/illegal steps, first we clean up
+	 * the lrb taken by this cmd and mark the lrb as in_use, then
+	 * queue the eh_work and bail.
+	 */
+	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
+		spin_lock_irqsave(host->host_lock, flags);
+		if (lrbp->cmd) {
+			__ufshcd_transfer_req_compl(hba, (1UL << tag));
+			__set_bit(tag, &hba->outstanding_reqs);
+			lrbp->in_use = true;
+			hba->force_reset = true;
+			ufshcd_schedule_eh_work(hba);
+		}
+		spin_unlock_irqrestore(host->host_lock, flags);
+		goto out;
+	}
+
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip)
 		err = -EIO;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1e680bf..66e5338 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -163,6 +163,7 @@ struct ufs_pm_lvl_states {
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
+ * @in_use: indicates that this lrb is still in use
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -192,6 +193,7 @@ struct ufshcd_lrb {
 #endif
 
 	bool req_abort_skip;
+	bool in_use;
 };
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

