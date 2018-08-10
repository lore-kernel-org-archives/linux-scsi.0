From: Evan Green <evgreen@chromium.org>
Subject: [PATCH] scsi: ufs: Enable bInitPowerMode of sleep
Date: Fri, 10 Aug 2018 16:50:10 -0700
Message-ID: <20180810235010.6004-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: gwendal@chromium.org, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

UFS devices can be provisioned to have an initial power mode of either
active or sleep. If the initial power mode is sleep, then the host
controller driver must send a START STOP UNIT to the device in order
to wake it up. Unfortunately, the device will refuse to complete other
common low level operations, such as reading descriptors and attributes.
The Linux driver currently fails to enumerate devices that start in
sleep mode, because it fails to read the device descriptor from the
unconscious device.

The way the UFS controller driver is structured, this presents a bit of
a Catch-22. In order to perform low-level enumeration of the device, the
driver needs to send a SCSI command. But SCSI needs low-level enumeration
of the device to be complete before full enumeration can occur.

This change adds a method for sending low-level SCSI commands, modeled
after (and reusing much of) the mechanism for sending device management
commands. With this primitive, ufshcd_probe_hba can execute REQUEST SENSE
to clear the Unit Attention, and then a START STOP UNIT in order to bring
the device out of sleep mode. Only after this is done can the rest of
enumeration, such as reading the device descriptor and geometry descriptor,
be done.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 drivers/scsi/ufs/ufshcd.c | 208 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h |  11 +++
 2 files changed, 206 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d320b1..a17fb3cf5656 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -213,12 +213,18 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+static inline int
+ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status);
+
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+				   enum ufs_dev_pwr_mode pwr_mode);
+
 static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
@@ -2523,6 +2529,8 @@ static int
 ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int resp;
+	int result;
+	int scsi_status;
 	int err = 0;
 
 	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
@@ -2547,6 +2555,31 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -2690,6 +2723,84 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
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
@@ -4099,6 +4210,35 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 	return err;
 }
 
+/**
+ * ufshcd_power_on() - checks device power state, and sends START STOP UNIT
+ * if needed to bring the device out of sleep mode.
+ * @hba: per-adapter instance
+ *
+ */
+static int ufshcd_power_on(struct ufs_hba *hba)
+{
+	uint32_t current_pwr_mode;
+	int rc;
+
+	rc = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_POWER_MODE, 0, 0,
+		&current_pwr_mode);
+
+	if (rc) {
+		dev_err(hba->dev, "Failed to get bCurrentPowerMode: %d\n", rc);
+		return rc;
+	}
+
+	if (current_pwr_mode != UFS_PWR_SLEEP)
+		return 0;
+
+	rc = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+	if (rc)
+		dev_err(hba->dev, "Failed to set power mode: %d\n", rc);
+
+	return rc;
+}
 /**
  * ufshcd_make_hba_operational - Make UFS controller operational
  * @hba: per adapter instance
@@ -6565,6 +6705,17 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/*
+	 * Unit Attention will need to be cleared after a reset and before
+	 * the device can be told to come out of sleep mode.
+	 */
+	hba->wlun_dev_clr_ua = true;
+	ret = ufshcd_power_on(hba);
+	if (ret) {
+		printk("ufshcd_power_on failed %d\n", ret);
+		goto out;
+	}
+
 	/* Init check for device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
@@ -6586,7 +6737,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
-	hba->wlun_dev_clr_ua = true;
 
 	if (ufshcd_get_max_pwr_mode(hba)) {
 		dev_err(hba->dev,
@@ -7202,6 +7352,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 static int
 ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 {
+	struct scsi_cmnd scmd;
 	unsigned char cmd[6] = {REQUEST_SENSE,
 				0,
 				0,
@@ -7217,9 +7368,24 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
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
 
@@ -7238,30 +7404,27 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
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
@@ -7277,7 +7440,24 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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
@@ -7297,7 +7477,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f51758f1e5cc..90a6936b07a5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -128,6 +128,17 @@ enum uic_link_state {
 #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_HIBERN8_STATE)
 
+/* Values for the bCurrentPowerMode attribute */
+enum ufs_pwr_mode {
+	UFS_PWR_IDLE = 0x0,
+	UFS_PWR_PRE_ACTIVE = 0x1,
+	UFS_PWR_ACTIVE = 0x11,
+	UFS_PWR_PRE_SLEEP = 0x20,
+	UFS_PWR_SLEEP = 0x22,
+	UFS_PWR_PRE_PWR_DOWN = 0x30,
+	UFS_PWR_DOWN = 0x33,
+};
+
 /*
  * UFS Power management levels.
  * Each level is in increasing order of power savings.
-- 
2.16.4
