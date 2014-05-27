From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 4/4] scsi: ufs: Fix queue depth handling for best effort cases
Date: Tue, 27 May 2014 10:21:52 +0300
Message-ID: <1401175312-17753-5-git-send-email-draviv@codeaurora.org>
References: <1401175312-17753-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401175312-17753-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Some UFS devices may expose bLUQueueDepth field as zero indicating
that the queue depth depends on the number of resources available
for LUN at a particular instant to handle the outstanding transfer
requests. Currently, when response for SCSI command is TASK_FULL
the LLD decrements the queue depth but fails to increment when the
resources are available. The scsi mid-layer handles the change in
queue depth heuristically and offers simple interface with
->change_queue_depth.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 97 ++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b301ed8..b103e95 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1991,27 +1991,55 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 
 	/* allow SCSI layer to restart the device in case of errors */
 	sdev->allow_restart = 1;
+
 	lun_qdepth = ufshcd_read_sdev_qdepth(hba, sdev);
-	if (lun_qdepth == 0 || lun_qdepth > hba->nutrs) {
-		dev_info(hba->dev, "%s, lun %d queue depth is %d\n", __func__,
-				sdev->lun, lun_qdepth);
+	if (lun_qdepth <= 0)
+		/* eventually, we can figure out the real queue depth */
 		lun_qdepth = hba->nutrs;
-	} else if (lun_qdepth < 0) {
-		lun_qdepth = 1;
-	}
+	else
+		lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
 
-	/*
-	 * Inform SCSI Midlayer that the LUN queue depth is same as the
-	 * controller queue depth. If a LUN queue depth is less than the
-	 * controller queue depth and if the LUN reports
-	 * SAM_STAT_TASK_SET_FULL, the LUN queue depth will be adjusted
-	 * with scsi_adjust_queue_depth.
-	 */
+	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
+			__func__, lun_qdepth);
 	scsi_activate_tcq(sdev, lun_qdepth);
+
 	return 0;
 }
 
 /**
+ * ufshcd_change_queue_depth - change queue depth
+ * @sdev: pointer to SCSI device
+ * @depth: required depth to set
+ * @reason: reason for changing the depth
+ *
+ * Change queue depth according to the reason and make sure
+ * the max. limits are not crossed.
+ */
+int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
+{
+	struct ufs_hba *hba = shost_priv(sdev->host);
+
+	if (depth > hba->nutrs)
+		depth = hba->nutrs;
+
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+	case SCSI_QDEPTH_RAMP_UP:
+		if (!sdev->tagged_supported)
+			depth = 1;
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return depth;
+}
+
+/**
  * ufshcd_slave_destroy - remove SCSI device configurations
  * @sdev: pointer to SCSI device
  */
@@ -2064,42 +2092,6 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
 }
 
 /**
- * ufshcd_adjust_lun_qdepth - Update LUN queue depth if device responds with
- *			      SAM_STAT_TASK_SET_FULL SCSI command status.
- * @cmd: pointer to SCSI command
- */
-static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
-{
-	struct ufs_hba *hba;
-	int i;
-	int lun_qdepth = 0;
-
-	hba = shost_priv(cmd->device->host);
-
-	/*
-	 * LUN queue depth can be obtained by counting outstanding commands
-	 * on the LUN.
-	 */
-	for (i = 0; i < hba->nutrs; i++) {
-		if (test_bit(i, &hba->outstanding_reqs)) {
-
-			/*
-			 * Check if the outstanding command belongs
-			 * to the LUN which reported SAM_STAT_TASK_SET_FULL.
-			 */
-			if (cmd->device->lun == hba->lrb[i].lun)
-				lun_qdepth++;
-		}
-	}
-
-	/*
-	 * LUN queue depth will be total outstanding commands, except the
-	 * command for which the LUN reported SAM_STAT_TASK_SET_FULL.
-	 */
-	scsi_adjust_queue_depth(cmd->device, MSG_SIMPLE_TAG, lun_qdepth - 1);
-}
-
-/**
  * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
  * @lrb: pointer to local reference block of completed command
  * @scsi_status: SCSI command status
@@ -2120,12 +2112,6 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 			  scsi_status;
 		break;
 	case SAM_STAT_TASK_SET_FULL:
-		/*
-		 * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
-		 * depth needs to be adjusted to the exact number of
-		 * outstanding commands the LUN can handle at any given time.
-		 */
-		ufshcd_adjust_lun_qdepth(lrbp->cmd);
 	case SAM_STAT_BUSY:
 	case SAM_STAT_TASK_ABORTED:
 		ufshcd_copy_sense_data(lrbp);
@@ -3156,6 +3142,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_destroy		= ufshcd_slave_destroy,
+	.change_queue_depth	= ufshcd_change_queue_depth,
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
