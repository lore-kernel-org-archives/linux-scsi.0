Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B94C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64DB5204EC
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgHYCIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 22:08:11 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:20064 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYCIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 22:08:10 -0400
IronPort-SDR: 5LABzHLQMfV+BsS33d0CHDj/T+7FpnXg4lPKGs/kSoCBt9lii0egL+bQq2mLHFIlOrHNC0ahZP
 nm3Z6JNhYSnvK43OCgS0dVmd02q5nfLICFhWO/pClZ8Lo2a6sB5HG32Wv3RrPwG2np/VpEvNQK
 cEI3DVyjCQg1LSsLxGVbct8dewpynkoilm5ueWZAt+/XAZHv5jLKE93IM4i0ud7yVXNlvmVhI+
 RCj+QvvNurmLtCBYWLXt+1RH864Yo3DWh4kPFW+6Ay2Jc+qMFXb7KO8rMsAuFB36B3guvqsj2N
 zzA=
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="47272760"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 24 Aug 2020 19:07:15 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 24 Aug 2020 19:07:14 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id EB9CC21626; Mon, 24 Aug 2020 19:07:14 -0700 (PDT)
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
Subject: [PATCH v1 1/2] scsi: ufs: Abort tasks before clear them from doorbell
Date:   Mon, 24 Aug 2020 19:07:05 -0700
Message-Id: <1598321228-21093-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
References: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To recovery non-fatal errors, no full reset is required, err_handler only
clears those pending TRs/TMRs so that scsi layer can re-issue them. In
current err_handler, TRs are directly cleared from UFS host's doorbell but
not aborted from device side. However, according to the UFSHCI JEDEC spec,
the host software shall use UTP Transfer Request List CLear Register to
clear a task from UFS host's doorbell only when a UTP Transfer Request is
expected to not be completed, e.g. when the host software receives a
“FUNCTION COMPLETE” Task Management response which means a Transfer Request
was aborted. To follow the UFSHCI JEDEC spec, in err_handler, aborts one TR
before clearing it from doorbell.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 143 ++++++++++++++++++++++++++--------------------
 1 file changed, 81 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8441ad..000895f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -235,6 +235,7 @@ static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg);
+static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
 static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
@@ -5657,8 +5658,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
 	unsigned long flags;
-	u32 err_xfer = 0;
-	u32 err_tm = 0;
+	bool err_xfer = false;
+	bool err_tm = false;
 	int err = 0;
 	int tag;
 	bool needs_reset = false;
@@ -5734,7 +5735,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Clear pending transfer requests */
 	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
-		if (ufshcd_clear_cmd(hba, tag)) {
+		if (ufshcd_try_to_abort_task(hba, tag)) {
 			err_xfer = true;
 			goto lock_skip_pending_xfer_clear;
 		}
@@ -6486,7 +6487,7 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 }
 
 /**
- * ufshcd_abort - abort a specific command
+ * ufshcd_try_to_abort_task - abort a specific task
  * @cmd: SCSI command pointer
  *
  * Abort the pending command in device by sending UFS_ABORT_TASK task management
@@ -6495,6 +6496,80 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
  * issued. To avoid that, first issue UFS_QUERY_TASK to check if the command is
  * really issued and then try to abort it.
  *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
+{
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	int err = 0;
+	int poll_cnt;
+	u8 resp = 0xF;
+	u32 reg;
+
+	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
+		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
+				UFS_QUERY_TASK, &resp);
+		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
+			/* cmd pending in the device */
+			dev_err(hba->dev, "%s: cmd pending in the device. tag = %d\n",
+				__func__, tag);
+			break;
+		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+			/*
+			 * cmd not pending in the device, check if it is
+			 * in transition.
+			 */
+			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
+				__func__, tag);
+			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+			if (reg & (1 << tag)) {
+				/* sleep for max. 200us to stabilize */
+				usleep_range(100, 200);
+				continue;
+			}
+			/* command completed already */
+			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
+				__func__, tag);
+			goto out;
+		} else {
+			dev_err(hba->dev,
+				"%s: no response from device. tag = %d, err %d\n",
+				__func__, tag, err);
+			if (!err)
+				err = resp; /* service response error */
+			goto out;
+		}
+	}
+
+	if (!poll_cnt) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
+			UFS_ABORT_TASK, &resp);
+	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+		if (!err) {
+			err = resp; /* service response error */
+			dev_err(hba->dev, "%s: issued. tag = %d, err %d\n",
+				__func__, tag, err);
+		}
+		goto out;
+	}
+
+	err = ufshcd_clear_cmd(hba, tag);
+	if (err)
+		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
+			__func__, tag, err);
+
+out:
+	return err;
+}
+
+/**
+ * ufshcd_abort - scsi host template eh_abort_handler callback
+ * @cmd: SCSI command pointer
+ *
  * Returns SUCCESS/FAILED
  */
 static int ufshcd_abort(struct scsi_cmnd *cmd)
@@ -6504,8 +6579,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	unsigned int tag;
 	int err = 0;
-	int poll_cnt;
-	u8 resp = 0xF;
 	struct ufshcd_lrb *lrbp;
 	u32 reg;
 
@@ -6574,63 +6647,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
-		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
-				UFS_QUERY_TASK, &resp);
-		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
-			/* cmd pending in the device */
-			dev_err(hba->dev, "%s: cmd pending in the device. tag = %d\n",
-				__func__, tag);
-			break;
-		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-			/*
-			 * cmd not pending in the device, check if it is
-			 * in transition.
-			 */
-			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
-				__func__, tag);
-			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-			if (reg & (1 << tag)) {
-				/* sleep for max. 200us to stabilize */
-				usleep_range(100, 200);
-				continue;
-			}
-			/* command completed already */
-			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
-				__func__, tag);
-			goto out;
-		} else {
-			dev_err(hba->dev,
-				"%s: no response from device. tag = %d, err %d\n",
-				__func__, tag, err);
-			if (!err)
-				err = resp; /* service response error */
-			goto out;
-		}
-	}
-
-	if (!poll_cnt) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
-			UFS_ABORT_TASK, &resp);
-	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		if (!err) {
-			err = resp; /* service response error */
-			dev_err(hba->dev, "%s: issued. tag = %d, err %d\n",
-				__func__, tag, err);
-		}
-		goto out;
-	}
-
-	err = ufshcd_clear_cmd(hba, tag);
-	if (err) {
-		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
-			__func__, tag, err);
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err)
 		goto out;
-	}
 
 	spin_lock_irqsave(host->host_lock, flags);
 	__ufshcd_transfer_req_compl(hba, (1UL << tag));
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

