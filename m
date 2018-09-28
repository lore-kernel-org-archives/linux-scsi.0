From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 1/2] scsi: ufs: Allow SCSI commands early during init
Date: Fri, 28 Sep 2018 16:02:02 -0700
Message-ID: <20180928230203.905-2-evgreen@chromium.org>
References: <20180928230203.905-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928230203.905-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adrian Hunter <adrian.hunter@intel.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

The UFS driver is currently organized in such a way that sending SCSI
commands is not possible before SCSI targets have been created. This
presents a problem in that sending SCSI commands is necessary as
part of low-level initialization. The obvious solution would be to just
create the SCSI devices a little earlier during initialization, however
that kicks off the SCSI state machine to start poking at those targets,
which requires low-level initialzation to have already been completed.

This change adds a couple functions that enable sending SCSI requests
without actually having a SCSI target. The functions follow the same form
as the send_dev_cmd functions. It then wires that capability into a few
UFS functions that will be called during low-level initialization.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v1:
	* Refactored into two patches.

 drivers/scsi/ufs/ufshcd.c | 164 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 152 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c55f38ec391c..d5c9ca581905 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -234,6 +234,9 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+static inline int
+ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status);
+
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -2537,6 +2540,8 @@ static int
 ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int resp;
+	int result;
+	int scsi_status;
 	int err = 0;
 
 	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
@@ -2561,6 +2566,31 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		dev_err(hba->dev, "%s: Reject UPIU not fully implemented\n",
 				__func__);
 		break;
+
+	case UPIU_TRANSACTION_RESPONSE:
+		/*
+		 * Get the response UPIU result to extract the SCSI command
+		 * status.
+		 */
+		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
+		scsi_status = result & MASK_SCSI_STATUS;
+		result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
+		if ((result & MASK_SCSI_STATUS) != SAM_STAT_GOOD) {
+			dev_err(hba->dev,
+				"%s: Failed SCSI device management command: %x\n",
+				__func__, result);
+
+			print_hex_dump(KERN_ERR, "UFS Sense Data ",
+				       DUMP_PREFIX_OFFSET, 16, 1,
+				       lrbp->sense_buffer, lrbp->sense_bufflen,
+				       false);
+
+			ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
+			err = -EIO;
+		}
+
+		break;
+
 	default:
 		err = -EINVAL;
 		dev_err(hba->dev, "%s: Invalid device management cmd response: %x\n",
@@ -2704,6 +2734,84 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	return err;
 }
 
+static void ufshcd_scsi_dev_cmd_done(struct scsi_cmnd *cmd)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)cmd->host_scribble;
+
+	if (hba->dev_cmd.complete) {
+		ufshcd_add_command_trace(hba, cmd->tag,
+				"dev_complete");
+		complete(hba->dev_cmd.complete);
+	}
+}
+
+/**
+ * ufshcd_exec_dev_scsi_cmd - API for sending device management SCSI requests
+ * @hba: UFS hba
+ * @cmd: specifies the SCSI command to send
+ * @timeout: time in seconds
+ *
+ * NOTE: Since there is only one available tag for device management commands,
+ * it is expected you hold the hba->dev_cmd.lock mutex.
+ */
+static int ufshcd_exec_dev_scsi_cmd(struct ufs_hba *hba,
+		struct scsi_cmnd *cmd, int timeout)
+{
+	struct ufshcd_lrb *lrbp;
+	int err;
+	int tag;
+	struct completion wait;
+	unsigned long flags;
+	u8 sense_data[18];
+
+	down_read(&hba->clk_scaling_lock);
+
+	/*
+	 * Get free slot, sleep if slots are unavailable.
+	 * Even though we use wait_event() which sleeps indefinitely,
+	 * the maximum wait time is bounded by SCSI request timeout.
+	 */
+	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
+
+	/* Borrow the host_scribble to store a pointer back to the host */
+	cmd->scsi_done = ufshcd_scsi_dev_cmd_done;
+	cmd->host_scribble = (unsigned char *)hba;
+	cmd->tag = tag;
+	memset(&sense_data, 0, sizeof(sense_data));
+	init_completion(&wait);
+	lrbp = &hba->lrb[tag];
+	lrbp->cmd = cmd;
+	lrbp->task_tag = tag;
+	lrbp->lun = UFS_UPIU_UFS_DEVICE_WLUN;
+	lrbp->sense_buffer = sense_data;
+	lrbp->sense_bufflen = sizeof(sense_data);
+	err = ufshcd_comp_scsi_upiu(hba, lrbp);
+	if (unlikely(err))
+		goto out_put_tag;
+
+	hba->dev_cmd.complete = &wait;
+
+	ufshcd_add_query_upiu_trace(hba, tag, "query_send");
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
+	ufshcd_send_command(hba, tag);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
+	ufshcd_add_query_upiu_trace(hba, tag,
+			err ? "query_complete_err" : "query_complete");
+
+out_put_tag:
+	lrbp->sense_buffer = NULL;
+	lrbp->sense_bufflen = 0;
+	ufshcd_put_dev_cmd_tag(hba, tag);
+	wake_up(&hba->dev_cmd.tag_wq);
+	up_read(&hba->clk_scaling_lock);
+	return err;
+}
+
 /**
  * ufshcd_init_query() - init the query response and request parameters
  * @hba: per-adapter instance
@@ -7216,6 +7324,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 static int
 ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 {
+	struct scsi_cmnd scmd;
 	unsigned char cmd[6] = {REQUEST_SENSE,
 				0,
 				0,
@@ -7231,9 +7340,24 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 		goto out;
 	}
 
-	ret = scsi_execute(sdp, cmd, DMA_FROM_DEVICE, buffer,
-			UFSHCD_REQ_SENSE_SIZE, NULL, NULL,
-			msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL);
+	if (sdp) {
+		ret = scsi_execute(sdp, cmd, DMA_FROM_DEVICE, buffer,
+				UFSHCD_REQ_SENSE_SIZE, NULL, NULL,
+				msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL);
+	} else {
+		memset(&scmd, 0, sizeof(scmd));
+		scmd.sc_data_direction = DMA_NONE;
+		scmd.cmnd = cmd;
+		scmd.cmd_len = sizeof(cmd);
+		/* No data transfer is performed during early transfers. */
+		cmd[4] = 0;
+		mutex_lock(&hba->dev_cmd.lock);
+		ret = ufshcd_exec_dev_scsi_cmd(hba,
+			&scmd, msecs_to_jiffies(1000));
+
+		mutex_unlock(&hba->dev_cmd.lock);
+	}
+
 	if (ret)
 		pr_err("%s: failed with err %d\n", __func__, ret);
 
@@ -7252,30 +7376,27 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
  * Returns non-zero if failed to set the requested power mode
  */
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
-				     enum ufs_dev_pwr_mode pwr_mode)
+				   enum ufs_dev_pwr_mode pwr_mode)
 {
+	struct scsi_cmnd scmd;
 	unsigned char cmd[6] = { START_STOP };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret;
 
+	cmd[4] = pwr_mode << 4;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
 	if (sdp) {
 		ret = scsi_device_get(sdp);
 		if (!ret && !scsi_device_online(sdp)) {
-			ret = -ENODEV;
 			scsi_device_put(sdp);
+			sdp = NULL;
 		}
-	} else {
-		ret = -ENODEV;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	if (ret)
-		return ret;
-
 	/*
 	 * If scsi commands fail, the scsi mid-layer schedules scsi error-
 	 * handling, which would wait for host to be resumed. Since we know
@@ -7291,7 +7412,24 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		hba->wlun_dev_clr_ua = false;
 	}
 
-	cmd[4] = pwr_mode << 4;
+	/*
+	 * If SCSI is not yet alive, try sending this command manually.
+	 * This is needed to avoid a circular dependency where SCSI
+	 * needs low level initialization to happen, but sending a
+	 * SCSI command (like START STOP UNIT) is part of low level
+	 * initialization.
+	 */
+	if (!sdp) {
+		memset(&scmd, 0, sizeof(scmd));
+		scmd.sc_data_direction = DMA_TO_DEVICE;
+		scmd.cmnd = cmd;
+		scmd.cmd_len = sizeof(cmd);
+		mutex_lock(&hba->dev_cmd.lock);
+		ret = ufshcd_exec_dev_scsi_cmd(hba, &scmd, START_STOP_TIMEOUT);
+		mutex_unlock(&hba->dev_cmd.lock);
+		hba->host->eh_noresume = 0;
+		return ret;
+	}
 
 	/*
 	 * Current function would be generally called from the power management
@@ -7311,7 +7449,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
 out:
-	scsi_device_put(sdp);
+	if (sdp)
+		scsi_device_put(sdp);
+
 	hba->host->eh_noresume = 0;
 	return ret;
 }
-- 
2.16.4
