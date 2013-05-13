From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 7/8] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Mon, 13 May 2013 13:02:17 +0300
Message-ID: <1368439340-26346-8-git-send-email-draviv@codeaurora.org>
References: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

As part of device initialization sequence, sending NOP OUT UPIU and
waiting for NOP IN UPIU response is mandatory. This confirms that the
device UFS Transport (UTP) layer is functional and the host can configure
the device with further commands. Add support for sending NOP OUT UPIU to
check the device connection path and test whether the UTP layer on the
device side is functional during initialization.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Acked-by: Santosh Y <santoshsy@gmail.com>

---
v5:
  - rebase on top of Seungwon Jeon's UFS V4 patchset
v4:
   - Removed readl_poll_timeout and replaced with wait logic
   - additional checks for completion
v3:
   - minor bug fix in error path
v2:
   - fixed INTERNAL_CMD_TAG check in readl_poll_timeout
   - minor cleanup from v1
   - rebased on Seungwon Jeon's UFS V3 patchset

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 333812f..2db550b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,6 +43,13 @@
 /* UIC command timeout, unit: ms */
 #define UIC_CMD_TIMEOUT	500
 
+/* NOP OUT retries waiting for NOP IN response */
+#define NOP_OUT_RETRIES    10
+/* Timeout after 30 msecs if NOP OUT hangs without response */
+#define NOP_OUT_TIMEOUT    30 /* msecs */
+/* Reserved tag for internal commands */
+#define INTERNAL_CMD_TAG   0
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -71,6 +78,39 @@ enum {
 	INT_AGGR_CONFIG,
 };
 
+/*
+ * ufshcd_wait_for_register - wait for register value to change
+ * @hba - per-adapter interface
+ * @reg - mmio register offset
+ * @mask - mask to apply to read register value
+ * @val - wait condition
+ * @interval_us - polling interval in microsecs
+ * @timeout_ms - timeout in millisecs
+ *
+ * Returns final register value after iteration
+ */
+static u32 ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
+		u32 val, unsigned long interval_us, unsigned long timeout_ms)
+{
+	u32 tmp;
+	ktime_t start;
+	unsigned long diff;
+
+	tmp = ufshcd_readl(hba, reg);
+
+	start = ktime_get();
+	while ((tmp & mask) == val) {
+		/* wakeup within 50us of expiry */
+		usleep_range(interval_us, interval_us + 50);
+		tmp = ufshcd_readl(hba, reg);
+		diff = ktime_to_ms(ktime_sub(ktime_get(), start));
+		if (diff > timeout_ms)
+			break;
+	}
+
+	return tmp;
+}
+
 /**
  * ufshcd_get_intr_mask - Get the interrupt bit mask
  * @hba - Pointer to adapter instance
@@ -612,7 +652,7 @@ static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags)
 {
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	enum dma_data_direction cmd_dir =
-		lrbp->cmd->sc_data_direction;
+		lrbp->cmd ? lrbp->cmd->sc_data_direction : DMA_NONE;
 	u32 data_direction;
 	u32 dword_0;
 
@@ -629,6 +669,8 @@ static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags)
 
 	dword_0 = data_direction | (lrbp->command_type
 				<< UPIU_COMMAND_TYPE_OFFSET);
+	if (lrbp->intr_cmd)
+		dword_0 |= UTP_REQ_DESC_INT_CMD;
 
 	/* Transfer request descriptor header fields */
 	req_desc->header.dword_0 = cpu_to_le32(dword_0);
@@ -717,6 +759,18 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 
 }
 
+static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+
+	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
+
+	/* command descriptor fields */
+	ucd_req_ptr->header.dword_0 =
+		UPIU_HEADER_DWORD(
+			UPIU_TRANSACTION_NOP_OUT, 0, 0, lrbp->task_tag);
+}
+
 /**
  * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
  * @hba - UFS hba
@@ -731,11 +785,13 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UTP_CMD_TYPE_SCSI:
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc(lrbp, &upiu_flags);
-		if (lrbp->command_type == UTP_CMD_TYPE_SCSI)
+		if (lrbp->cmd && lrbp->command_type == UTP_CMD_TYPE_SCSI)
 			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
-		else
+		else if (lrbp->cmd && ufshcd_is_query_req(lrbp))
 			ufshcd_prepare_utp_query_req_upiu(hba, lrbp,
 								upiu_flags);
+		else if (!lrbp->cmd)
+			ufshcd_prepare_utp_nop_upiu(lrbp);
 		break;
 	case UTP_CMD_TYPE_UFS:
 		/* For UFS native command implementation */
@@ -784,6 +840,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = cmd->device->lun;
+	lrbp->intr_cmd = false;
 
 	if (ufshcd_is_query_req(lrbp))
 		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
@@ -972,6 +1029,104 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	return ret;
 }
 
+static int
+ufshcd_compose_nop_out_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	lrbp->cmd = NULL;
+	lrbp->sense_bufflen = 0;
+	lrbp->sense_buffer = NULL;
+	lrbp->task_tag = INTERNAL_CMD_TAG;
+	lrbp->lun = 0; /* NOP OUT is not specific to any LUN */
+	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+	lrbp->intr_cmd = true; /* No interrupt aggregation */
+
+	return ufshcd_compose_upiu(hba, lrbp);
+}
+
+static int ufshcd_wait_for_nop_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int err = 0;
+	unsigned long timeout;
+	unsigned long flags;
+
+	timeout = wait_for_completion_timeout(
+			lrbp->completion, msecs_to_jiffies(NOP_OUT_TIMEOUT));
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	lrbp->completion = NULL;
+	if (timeout)
+		err = ufshcd_get_tr_ocs(lrbp);
+	else
+		err = -ETIMEDOUT;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return err;
+}
+
+/**
+ * ufshcd_validate_dev_connection() - Check device connection status
+ * @hba: per-adapter instance
+ *
+ * Send NOP OUT UPIU and wait for NOP IN response to check whether the
+ * device Transport Protocol (UTP) layer is ready after a reset.
+ * If the UTP layer at the device side is not initialized, it may
+ * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
+ * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
+ */
+static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
+{
+	int err;
+	struct ufshcd_lrb *lrbp;
+	unsigned long flags;
+	struct completion wait;
+	int retries = NOP_OUT_RETRIES;
+
+retry:
+	init_completion(&wait);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	lrbp = &hba->lrb[INTERNAL_CMD_TAG];
+	err = ufshcd_compose_nop_out_upiu(hba, lrbp);
+	if (unlikely(err)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	lrbp->completion = &wait;
+	ufshcd_send_command(hba, INTERNAL_CMD_TAG);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_wait_for_nop_cmd(hba, lrbp);
+
+	if (err == -ETIMEDOUT) {
+		u32 reg;
+		u32 mask = 1 << INTERNAL_CMD_TAG;
+
+		/* clear outstanding transaction before retry */
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		ufshcd_utrl_clear(hba, INTERNAL_CMD_TAG);
+		__clear_bit(INTERNAL_CMD_TAG, &hba->outstanding_reqs);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+		/* poll for max. 1 sec to clear door bell register by h/w */
+		reg = ufshcd_wait_for_register(hba,
+				REG_UTP_TRANSFER_REQ_DOOR_BELL,
+				mask, mask, 1000, 1000);
+		if ((reg & mask) == mask)
+			retries = 0;
+	}
+
+	if (err && retries--) {
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+		goto retry;
+	}
+
+out:
+	if (err)
+		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
+	return err;
+}
+
 /**
  * ufshcd_make_hba_operational - Make UFS controller operational
  * @hba: per adapter instance
@@ -1438,6 +1593,16 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
 	}
 }
 
+/*
+ * ufshcd_is_nop_out_upiu() - check if the command is NOP OUT UPIU
+ * @lrbp: pointer to logical reference block
+ */
+static inline bool ufshcd_is_nop_out_upiu(struct ufshcd_lrb *lrbp)
+{
+	return (be32_to_cpu(lrbp->ucd_req_ptr->header.dword_0) >> 24) ==
+				UPIU_TRANSACTION_NOP_OUT;
+}
+
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
@@ -1449,6 +1614,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	u32 tr_doorbell;
 	int result;
 	int index;
+	bool int_aggr_reset = true;
 
 	lrb = hba->lrb;
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -1456,17 +1622,21 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 
 	for (index = 0; index < hba->nutrs; index++) {
 		if (test_bit(index, &completed_reqs)) {
-
-			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
-
 			if (lrb[index].cmd) {
+				result = ufshcd_transfer_rsp_status(
+						hba, &lrb[index]);
 				scsi_dma_unmap(lrb[index].cmd);
 				lrb[index].cmd->result = result;
 				lrb[index].cmd->scsi_done(lrb[index].cmd);
 
 				/* Mark completed command as NULL in LRB */
 				lrb[index].cmd = NULL;
+			} else if (ufshcd_is_nop_out_upiu(&lrb[index])) {
+				if (lrb[index].completion)
+					complete(lrb[index].completion);
 			}
+			/* Don't reset counters for interrupt cmd */
+			int_aggr_reset = lrb[index].intr_cmd ? false : true;
 		} /* end of if */
 	} /* end of for */
 
@@ -1474,7 +1644,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	hba->outstanding_reqs ^= completed_reqs;
 
 	/* Reset interrupt aggregation counters */
-	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+	if (int_aggr_reset)
+		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
 }
 
 /**
@@ -1772,8 +1943,16 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	int ret;
 
 	ret = ufshcd_link_startup(hba);
-	if (!ret)
-		scsi_scan_host(hba->host);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_validate_dev_connection(hba);
+	if (ret)
+		goto out;
+
+	scsi_scan_host(hba->host);
+out:
+	return;
 }
 
 static struct scsi_host_template ufshcd_driver_template = {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 974bd07..558d2f4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -102,6 +102,8 @@ struct uic_command {
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
+ * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
+ * @completion: holds the state of completion (used for internal commands)
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -117,6 +119,8 @@ struct ufshcd_lrb {
 	int command_type;
 	int task_tag;
 	unsigned int lun;
+	bool intr_cmd;
+	struct completion *completion;
 };
 
 /**
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
