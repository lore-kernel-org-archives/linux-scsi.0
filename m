From: Pawel Wodkowski <pawelx.wodkowski@intel.com>
Subject: [PATCH] scsi: ufs: add support for BLKSECDISCARD
Date: Tue, 26 Jul 2016 13:56:50 +0200
Message-ID: <1469534210-4366-1-git-send-email-pawelx.wodkowski@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:8000 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbcGZMNH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2016 08:13:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hunter@vger.kernel.org, Adrian <adrian.hunter@intel.com>
Cc: Pielaszkiewicz@vger.kernel.org, Tomasz <tomasz.pielaszkiewicz@intel.com>, Janca@vger.kernel.org, Grzegorz <grzegorz.janca@intel.com>

Add BLKSECDISCAD feature support if LU is provisioned for TPRZ
(bProvisioningType = 3).

To perform BLKSECDISCAD driver issue purge operation after each discard
SCSI command with REQ_SECURE flag set, and delay calling scsi_done()
till purge finish. This operation might long so block requests from SCSI
layer in ufshcd_queueucommand() and then unblock it after purge finish.

Signed-off-by: Pawel Wodkowski <pawelx.wodkowski@intel.com>
---
 drivers/scsi/ufs/ufs.h    |  19 +++++
 drivers/scsi/ufs/ufshcd.c | 187 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |   6 ++
 3 files changed, 208 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b291fa6ed2ad..2f769974fda1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -132,12 +132,14 @@ enum flag_idn {
 	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
 	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
 	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
+	QUERY_FLAG_IDN_PURGE_EN         = 0x06,
 };
 
 /* Attribute idn for Query requests */
 enum attr_idn {
 	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
 	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
+	QUERY_ATTR_IDN_PURGE_STATUS	= 0x06,
 	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
 	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
 };
@@ -247,6 +249,13 @@ enum {
 	UFSHCD_AMP		= 3,
 };
 
+/* Provisioning type */
+enum unit_desc_param_provisioning_type {
+	THIN_PROVISIONING_DISABLED		= 0x00,
+	THIN_PROVISIONING_ENABLED_TPRZ_0	= 0x02,
+	THIN_PROVISIONING_ENABLED_TPRZ_1	= 0x03,
+};
+
 #define POWER_DESC_MAX_SIZE			0x62
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
 
@@ -279,6 +288,16 @@ enum bkops_status {
 	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
 };
 
+/* Purge operation status */
+enum purge_status {
+	PURGE_STATUS_IDLE             = 0x0,
+	PURGE_STATUS_IN_PROGRESS      = 0x1,
+	PURGE_STATUS_STOP_BY_HOST     = 0x2,
+	PURGE_STATUS_SUCCESS          = 0x3,
+	PURGE_STATUS_QUEUE_NOT_EMPTY  = 0x4,
+	PURGE_STATUS_GENERAL_FAIL     = 0x5
+};
+
 /* UTP QUERY Transaction Specific Fields OpCode */
 enum query_opcode {
 	UPIU_QUERY_OPCODE_NOP		= 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f8fa72c31a9d..4ca15a6f294c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -70,6 +70,9 @@
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
+/* Purge operation timeout */
+#define PURGE_TIMEOUT 9000 /* msecs */
+
 /* maximum number of retries for a general UIC command  */
 #define UFS_UIC_COMMAND_RETRIES 3
 
@@ -1382,11 +1385,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
 	unsigned long flags;
+	bool secure;
 	int tag;
 	int err = 0;
 
 	hba = shost_priv(host);
 
+	secure = !!(cmd->request->cmd_flags & REQ_SECURE);
 	tag = cmd->request->tag;
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
@@ -1420,6 +1425,17 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		cmd->scsi_done(cmd);
 		goto out_unlock;
 	}
+
+	if (secure) {
+		if (hba->is_purge_in_progress) {
+			secure = false;
+			err = SCSI_MLQUEUE_HOST_BUSY;
+			goto out_unlock;
+		}
+
+		hba->is_purge_in_progress = true;
+	}
+
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* acquire the tag to make sure device cmds don't use it */
@@ -1465,9 +1481,19 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
+
+	if (secure) {
+		hba->purge_timeout = jiffies + msecs_to_jiffies(PURGE_TIMEOUT);
+
+		scsi_block_requests(hba->host);
+	}
+
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
+	if (err && secure && hba->is_purge_in_progress)
+		hba->is_purge_in_progress = false;
+
 	return err;
 }
 
@@ -1641,7 +1667,7 @@ static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba - UFS hba
  * @cmd_type - specifies the type (NOP, Query...)
- * @timeout - time in seconds
+ * @timeout - time in miliseconds
  *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -3306,6 +3332,18 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 static int ufshcd_slave_configure(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue;
+	struct ufs_hba *hba = shost_priv(sdev->host);
+	u8 provisioning_type;
+	int err;
+
+	/* Check Provisioning type for this LUN.For TPRZ_1 set secure flag. */
+	err = ufshcd_read_unit_desc_param(hba,
+			ufshcd_scsi_to_upiu_lun(sdev->lun),
+			UNIT_DESC_PARAM_PROVISIONING_TYPE,
+			&provisioning_type, 1);
+
+	if (!err && provisioning_type == THIN_PROVISIONING_ENABLED_TPRZ_1)
+		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
@@ -3536,9 +3574,16 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			clear_bit_unlock(index, &hba->lrb_in_use);
-			/* Do not touch lrbp after scsi done */
-			cmd->scsi_done(cmd);
-			__ufshcd_release(hba);
+
+			if (!(cmd->request->cmd_flags & REQ_SECURE)) {
+				/* Do not touch lrbp after scsi done */
+				cmd->scsi_done(cmd);
+				__ufshcd_release(hba);
+			} else {
+				/* Schedule purge */
+				hba->purge_cmd = cmd;
+				schedule_delayed_work(&hba->purge_work, 1);
+			}
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
 			if (hba->dev_cmd.complete)
 				complete(hba->dev_cmd.complete);
@@ -4162,6 +4207,139 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 }
 
 /**
+* ufshcd_purge_handler - Issue purge operation after discard.
+* @work: pointer to work structure
+*
+* Phisically remove all unmapped address space by seting fPurgeEnable and
+* waiting operation to complete. SCSI command that issued purge will be blocked
+* till this work finish. In case of error command result is overwritten by
+* proper host byte error code. In all scenarios, when work is done scsi_done()
+* is called to finish SCSI command.
+*/
+static void ufshcd_purge_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+			purge_work.work);
+	u32 next_purge_status = hba->purge_status;
+	unsigned long delay_time = msecs_to_jiffies(20);
+	int err = 0;
+	int host_byte = 0;
+	bool done = false;
+
+	WARN(!hba->is_purge_in_progress,
+			"PURGE: Invalid state - purge not in progress\n");
+
+	if (hba->purge_status == PURGE_STATUS_IN_PROGRESS) {
+		err = ufshcd_query_attr_retry(hba,
+				UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_PURGE_STATUS, 0, 0,
+				&next_purge_status);
+		/*
+		 * In case of err assume operation is still in progress.
+		 * If error keep showing timout will eventualy kill purge.
+		 */
+		if (err) {
+			dev_dbg(hba->dev, "%s: failed to get purge status - assuming still in progress\n",
+				__func__);
+			delay_time = msecs_to_jiffies(100);
+		}
+
+		WARN(hba->purge_status == PURGE_STATUS_IN_PROGRESS &&
+			next_purge_status == PURGE_STATUS_IDLE,
+			"Invalid purge state: IDLE\n");
+
+		/*
+		 * This is not required but if something bad happen
+		 * (ex card reset) we want to inform upper layer that
+		 * purge might not be completed.
+		 */
+		if (next_purge_status == PURGE_STATUS_IDLE) {
+			host_byte = DID_ERROR;
+			done = true;
+		}
+	} else if (hba->purge_cmd->result & 0xffff0000) {
+		/*
+		 *  Don't issue purge if discard failed. Also don't touch cmd's
+		 * error code.
+		 */
+		next_purge_status = PURGE_STATUS_GENERAL_FAIL;
+		host_byte = 0;
+		done = true;
+
+	} else {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+				QUERY_FLAG_IDN_PURGE_EN, NULL);
+
+		if (err) {
+			dev_err(hba->dev, "%s: flag set error (err=%d).\n",
+				__func__, err);
+			next_purge_status = PURGE_STATUS_GENERAL_FAIL;
+			host_byte = DID_ERROR;
+			done = true;
+		} else {
+			/* Some devices are timing out while checking purge
+			 * status just after setting fPurgeEnable flag. For them
+			 * assume purge is in progress. This will be validated
+			 * in next turn. Also give a little more time for
+			 * houskeeping.
+			 */
+			dev_dbg(hba->dev, "%s: Purge started.\n", __func__);
+			next_purge_status = PURGE_STATUS_IN_PROGRESS;
+			delay_time = msecs_to_jiffies(100);
+		}
+	}
+
+	if (!done) {
+		switch (next_purge_status) {
+		case PURGE_STATUS_QUEUE_NOT_EMPTY:
+			/* This is retry condition */
+			delay_time = 1;
+			break;
+
+		case PURGE_STATUS_IN_PROGRESS:
+			break;
+		case PURGE_STATUS_SUCCESS:
+			done = true;
+			break;
+		default:
+			/* Every other condition is a failure */
+			host_byte = DID_ERROR;
+			done = true;
+		}
+	}
+
+	/*
+	 * If purge timeous out then finish SCSI command with error. If device
+	 * is still really doing purge, it will finish in background and all
+	 * further SCSI commands will fail till that moment.
+	 */
+	if (!done && time_after(jiffies, hba->purge_timeout)) {
+		host_byte = DID_TIME_OUT;
+		next_purge_status = PURGE_STATUS_GENERAL_FAIL;
+		done = true;
+	}
+
+	if (done) {
+		if (host_byte)
+			hba->purge_cmd->result = host_byte;
+
+		hba->purge_cmd->scsi_done(hba->purge_cmd);
+		hba->purge_cmd = NULL;
+		hba->is_purge_in_progress = false;
+		ufshcd_release(hba);
+		scsi_unblock_requests(hba->host);
+
+		dev_dbg(hba->dev, "%s: purge %s\n", __func__,
+			next_purge_status == PURGE_STATUS_SUCCESS ?
+					"done" : "failed");
+	} else
+		schedule_delayed_work(&hba->purge_work, delay_time);
+
+	hba->purge_status = next_purge_status;
+}
+
+
+/**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
  */
@@ -6440,6 +6618,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize work queues */
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
+	INIT_DELAYED_WORK(&hba->purge_work, ufshcd_purge_handler);
 
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4bb65669f052..c8462fac54eb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -545,6 +545,12 @@ struct ufs_hba {
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
+
+	unsigned long purge_timeout;
+	bool is_purge_in_progress;
+	enum purge_status purge_status;
+	struct delayed_work purge_work;
+	struct scsi_cmnd *purge_cmd;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
1.9.1

