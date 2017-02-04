From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 1/8] scsi: ufs: skip request abort task when previous aborts failed
Date: Fri,  3 Feb 2017 16:56:40 -0800
Message-ID: <1486169800-22696-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

On certain error conditions request abort task itself might fail
when aborting a request. In such case, subsequent request aborts
should skip issuing the abort task as it is expected to fail as well,
and device reset handler will be called next.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a70bf06..61fea17 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1877,6 +1877,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
+	lrbp->req_abort_skip = false;
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
@@ -4979,6 +4980,17 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	return err;
 }
 
+static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
+{
+	struct ufshcd_lrb *lrbp;
+	int tag;
+
+	for_each_set_bit(tag, &bitmap, hba->nutrs) {
+		lrbp = &hba->lrb[tag];
+		lrbp->req_abort_skip = true;
+	}
+}
+
 /**
  * ufshcd_abort - abort a specific command
  * @cmd: SCSI command pointer
@@ -5047,6 +5059,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	ufshcd_print_pwr_info(hba);
 	ufshcd_print_trs(hba, 1 << tag, true);
 
+
+	/* Skip task abort in case previous aborts failed and report failure */
+	if (lrbp->req_abort_skip) {
+		err = -EIO;
+		goto out;
+	}
+
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 				UFS_QUERY_TASK, &resp);
@@ -5120,6 +5139,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
+		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
 		err = FAILED;
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7ffcde2..292fc14 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -165,6 +165,7 @@ struct ufs_pm_lvl_states {
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
  * @issue_time_stamp: time stamp for debug purposes
+ * @req_abort_skip: skip request abort task flag
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -187,6 +188,8 @@ struct ufshcd_lrb {
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 	ktime_t issue_time_stamp;
+
+	bool req_abort_skip;
 };
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
