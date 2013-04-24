From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Wed, 24 Apr 2013 19:44:32 +0530
Message-ID: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As part of device initialization sequence, sending NOP OUT UPIU and
waiting for NOP IN UPIU response is mandatory. This confirms that the
device UFS Transport (UTP) layer is functional and the host can configure
the device with further commands. Add support for sending NOP OUT UPIU to
check the device connection path and test whether the UTP layer on the
device side is functional during initialization.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  167 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h |    4 +
 2 files changed, 162 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ced421a..1a8cba3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -34,12 +34,21 @@
  */
 
 #include "ufshcd.h"
+#include <linux/iopoll.h>
+#include <linux/async.h>
 
 /* Timeout after 10 secs if UIC command hangs */
 #define UIC_COMMAND_TIMEOUT	(10 * HZ)
 /* Retry for 3 times in case of UIC failures */
 #define UIC_COMMAND_RETRIES	3
 
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
@@ -607,7 +616,7 @@ static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags)
 {
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	enum dma_data_direction cmd_dir =
-		lrbp->cmd->sc_data_direction;
+		lrbp->cmd ? lrbp->cmd->sc_data_direction : DMA_NONE;
 	u32 data_direction;
 	u32 dword_0;
 
@@ -624,6 +633,8 @@ static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags)
 
 	dword_0 = data_direction | (lrbp->command_type
 				<< UPIU_COMMAND_TYPE_OFFSET);
+	if (lrbp->intr_cmd)
+		dword_0 |= UTP_REQ_DESC_INT_CMD;
 
 	/* Transfer request descriptor header fields */
 	req_desc->header.dword_0 = cpu_to_le32(dword_0);
@@ -712,6 +723,18 @@ static inline void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 
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
@@ -741,12 +764,14 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UTP_CMD_TYPE_SCSI:
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc(lrbp, &upiu_flags);
-		if (lrbp->cmd && lrbp->command_type == UTP_CMD_TYPE_SCSI)
+		if (lrbp->cmd && lrbp->command_type == UTP_CMD_TYPE_SCSI) {
 			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
-		else if (lrbp->cmd)
+		} else if (lrbp->cmd && ufshcd_is_query_req(lrbp)) {
 			ufshcd_prepare_utp_query_req_upiu(hba, lrbp,
 								upiu_flags);
-		else {
+		} else if (!lrbp->cmd) {
+			ufshcd_prepare_utp_nop_upiu(lrbp);
+		} else {
 			dev_err(hba->dev, "%s: Invalid UPIU request\n",
 				__func__);
 			ret = -EINVAL;
@@ -799,6 +824,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = cmd->device->lun;
+	lrbp->intr_cmd = false;
 
 	if (ufshcd_is_query_req(lrbp))
 		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
@@ -1112,6 +1138,113 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	return err;
 }
 
+static inline int
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
+	unsigned long timeout;
+	unsigned long flags;
+	struct completion wait;
+	int retries = NOP_OUT_RETRIES;
+
+retry:
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	lrbp = &hba->lrb[INTERNAL_CMD_TAG];
+	init_completion(&wait);
+
+	err = ufshcd_compose_nop_out_upiu(hba, lrbp);
+	if (err)
+		goto may_retry;
+
+	lrbp->completion = &wait;
+	ufshcd_send_command(hba, INTERNAL_CMD_TAG);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	timeout = wait_for_completion_timeout(
+			&wait, msecs_to_jiffies(NOP_OUT_TIMEOUT));
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (timeout > 0) {
+		int ocs;
+
+		ocs = ufshcd_get_tr_ocs(lrbp);
+		switch (ocs) {
+		case OCS_SUCCESS:
+			goto out;
+		default:
+			dev_dbg(hba->dev, "%s: OCS error %d\n", __func__, ocs);
+			err = -EIO;
+			goto may_retry;
+		}
+	} else {
+		u32 reg;
+
+		err = -ETIMEDOUT;
+
+		/* clear outstanding transaction before retry */
+		ufshcd_utrl_clear(hba, INTERNAL_CMD_TAG);
+		__clear_bit(INTERNAL_CMD_TAG, &hba->outstanding_reqs);
+
+		/* poll for max. 1 sec to clear door bell register by h/w */
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (readl_poll_timeout(
+				hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL,
+				reg, !(reg & INTERNAL_CMD_TAG), 1000, 1000))
+			retries = 0;
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		goto may_retry;
+	}
+
+may_retry:
+	if (retries--) {
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto retry;
+	}
+
+out:
+	if (err)
+		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return err;
+}
+
+static void ufshcd_async_device_probe(void *data, async_cookie_t cookie)
+{
+	int err;
+	struct ufs_hba *hba = data;
+
+	err = ufshcd_validate_dev_connection(hba);
+	if (err)
+		dev_err(hba->dev, "%s failed with error %d\n", __func__, err);
+	else
+		scsi_scan_host(hba->host);
+}
+
 /**
  * ufshcd_make_hba_operational - Make UFS controller operational
  * @hba: per adapter instance
@@ -1166,7 +1299,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 		scsi_unblock_requests(hba->host);
 
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-	scsi_scan_host(hba->host);
 out:
 	return err;
 }
@@ -1568,6 +1700,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 /**
+ * ufshcd_is_nop_out_upiu() - check if the command is NOP OUT UPIU
+ * @lrbp: pointer to logical reference block
+ */
+static inline bool ufshcd_is_nop_out_upiu(struct ufshcd_lrb *lrbp)
+{
+	return (be32_to_cpu(lrbp->ucd_req_ptr->header.dword_0) >> 24) ==
+				UPIU_TRANSACTION_NOP_OUT;
+}
+
+/**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
  */
@@ -1578,6 +1720,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	u32 tr_doorbell;
 	int result;
 	int index;
+	bool int_aggr_reset = true;
 
 	lrb = hba->lrb;
 	tr_doorbell =
@@ -1586,17 +1729,20 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 
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
+				complete(lrb[index].completion);
 			}
+			/* Don't reset counters for interrupt cmd */
+			int_aggr_reset = lrb[index].intr_cmd ? false : true;
 		} /* end of if */
 	} /* end of for */
 
@@ -1604,7 +1750,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	hba->outstanding_reqs ^= completed_reqs;
 
 	/* Reset interrupt aggregation counters */
-	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+	if (int_aggr_reset)
+		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
 }
 
 /**
@@ -2098,6 +2245,8 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 		dev_err(hba->dev, "Initialization failed\n");
 		goto out_remove_scsi_host;
 	}
+
+	async_schedule(ufshcd_async_device_probe, hba);
 	*hba_handle = hba;
 
 	return 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 13378f3..e273bf7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -101,6 +101,8 @@ struct uic_command {
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
+ * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
+ * @completion: holds the state of completion (used for internal commands)
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -116,6 +118,8 @@ struct ufshcd_lrb {
 	int command_type;
 	int task_tag;
 	unsigned int lun;
+	bool intr_cmd;
+	struct completion *completion;
 };
 
 /**
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
