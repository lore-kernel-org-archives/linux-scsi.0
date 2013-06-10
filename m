From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Mon, 10 Jun 2013 17:12:09 +0300
Message-ID: <1370873530-19461-2-git-send-email-draviv@codeaurora.org>
References: <1370873530-19461-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1370873530-19461-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

As part of device initialization sequence, sending NOP OUT UPIU and
waiting for NOP IN UPIU response is mandatory. This confirms that the
device UFS Transport (UTP) layer is functional and the host can configure
the device with further commands. Add support for sending NOP OUT UPIU to
check the device connection path and test whether the UTP layer on the
device side is functional during initialization.

In order to send a UPIU request a UPIU request tag is required. Since
internal request is not scheduled via the block layer, a special tag is
reserved. The reserved tag is the last queuing tag (usually 31). To
avoid collisions with SCSI commands receiving a dynamic allocated tags,
the SCSI command queue depth is shorten by one. In such way the last tag
will never be used by other SCSI commands and will remain available for
internal commands. This design allows us sending maintenance commands
before the queue was initialized or when its blocked. For example
initiating urgent background operations which requires to block all
incoming SCSI requests.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 139bc06..69c0328 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -36,10 +36,16 @@
 #ifndef _UFS_H
 #define _UFS_H
 
+#include <linux/mutex.h>
+#include <linux/types.h>
+
 #define MAX_CDB_SIZE	16
+#define GENERAL_UPIU_REQUEST_SIZE 32
+#define UPIU_HEADER_DATA_SEGMENT_MAX_SIZE	((ALIGNED_UPIU_SIZE) - \
+					(GENERAL_UPIU_REQUEST_SIZE))
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
-			((byte3 << 24) | (byte2 << 16) |\
+			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
 			 (byte1 << 8) | (byte0))
 
 /*
@@ -73,6 +79,7 @@ enum {
 	UPIU_TRANSACTION_TASK_RSP	= 0x24,
 	UPIU_TRANSACTION_READY_XFER	= 0x31,
 	UPIU_TRANSACTION_QUERY_RSP	= 0x36,
+	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
 };
 
 /* UPIU Read/Write flags */
@@ -110,6 +117,12 @@ enum {
 	UPIU_COMMAND_SET_TYPE_QUERY	= 0x2,
 };
 
+/* UTP Transfer Request Command Offset */
+#define UPIU_COMMAND_TYPE_OFFSET	28
+
+/* Offset of the response code in the UPIU header */
+#define UPIU_RSP_CODE_OFFSET		8
+
 enum {
 	MASK_SCSI_STATUS	= 0xFF,
 	MASK_TASK_RESPONSE	= 0xFF00,
@@ -138,26 +151,32 @@ struct utp_upiu_header {
 
 /**
  * struct utp_upiu_cmd - Command UPIU structure
- * @header: UPIU header structure DW-0 to DW-2
  * @data_transfer_len: Data Transfer Length DW-3
  * @cdb: Command Descriptor Block CDB DW-4 to DW-7
  */
 struct utp_upiu_cmd {
-	struct utp_upiu_header header;
 	u32 exp_data_transfer_len;
 	u8 cdb[MAX_CDB_SIZE];
 };
 
 /**
- * struct utp_upiu_rsp - Response UPIU structure
- * @header: UPIU header DW-0 to DW-2
+ * struct utp_upiu_req - general upiu request structure
+ * @header:UPIU header structure DW-0 to DW-2
+ * @sc: fields structure for scsi command
+ */
+struct utp_upiu_req {
+	struct utp_upiu_header header;
+	struct utp_upiu_cmd sc;
+};
+
+/**
+ * struct utp_cmd_rsp - Response UPIU structure
  * @residual_transfer_count: Residual transfer count DW-3
  * @reserved: Reserved double words DW-4 to DW-7
  * @sense_data_len: Sense data length DW-8 U16
  * @sense_data: Sense data field DW-8 to DW-12
  */
-struct utp_upiu_rsp {
-	struct utp_upiu_header header;
+struct utp_cmd_rsp {
 	u32 residual_transfer_count;
 	u32 reserved[4];
 	u16 sense_data_len;
@@ -165,6 +184,16 @@ struct utp_upiu_rsp {
 };
 
 /**
+ * struct utp_upiu_rsp - general upiu response structure
+ * @header: UPIU header structure DW-0 to DW-2
+ * @sc: fields structure for scsi command
+ */
+struct utp_upiu_rsp {
+	struct utp_upiu_header header;
+	struct utp_cmd_rsp sc;
+};
+
+/**
  * struct utp_upiu_task_req - Task request UPIU structure
  * @header - UPIU header structure DW0 to DW-2
  * @input_param1: Input parameter 1 DW-3
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 48a7645..d534c50 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,6 +43,15 @@
 /* UIC command timeout, unit: ms */
 #define UIC_CMD_TIMEOUT	500
 
+/* NOP OUT retries waiting for NOP IN response */
+#define NOP_OUT_RETRIES    10
+/* Timeout after 30 msecs if NOP OUT hangs without response */
+#define NOP_OUT_TIMEOUT    30 /* msecs */
+
+#define SCSI_CMD_QUEUE_SIZE (hba->nutrs - 1)
+/* Reserved tag for internal commands */
+#define INTERNAL_CMD_TAG   (hba->nutrs - 1)
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -71,6 +80,41 @@ enum {
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
+		if (diff > timeout_ms) {
+			tmp = ufshcd_readl(hba, reg);
+			break;
+		}
+	}
+
+	return tmp;
+}
+
 /**
  * ufshcd_get_intr_mask - Get the interrupt bit mask
  * @hba - Pointer to adapter instance
@@ -223,18 +267,13 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
+ * ufshcd_get_req_rsp - returns the TR response
  * @ucd_rsp_ptr: pointer to response UPIU
- *
- * This function checks the response UPIU for valid transaction type in
- * response field
- * Returns 0 on success, non-zero on failure
  */
 static inline int
-ufshcd_is_valid_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
+ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
 {
-	return ((be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24) ==
-		 UPIU_TRANSACTION_RESPONSE) ? 0 : DID_ERROR << 16;
+	return be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24;
 }
 
 /**
@@ -331,9 +370,9 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
 	int len;
 	if (lrbp->sense_buffer) {
-		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
+		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sc.sense_data_len);
 		memcpy(lrbp->sense_buffer,
-			lrbp->ucd_rsp_ptr->sense_data,
+			lrbp->ucd_rsp_ptr->sc.sense_data,
 			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
 	}
 }
@@ -551,76 +590,128 @@ static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
 }
 
 /**
+ * ufshcd_prepare_req_desc() - Fills the requests header
+ * descriptor according to request
+ * @lrbp: pointer to local reference block
+ * @upiu_flags: flags required in the header
+ * @cmd_dir: requests data direction
+ */
+static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags,
+		enum dma_data_direction cmd_dir)
+{
+	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
+	u32 data_direction;
+	u32 dword_0;
+
+	if (cmd_dir == DMA_FROM_DEVICE) {
+		data_direction = UTP_DEVICE_TO_HOST;
+		*upiu_flags = UPIU_CMD_FLAGS_READ;
+	} else if (cmd_dir == DMA_TO_DEVICE) {
+		data_direction = UTP_HOST_TO_DEVICE;
+		*upiu_flags = UPIU_CMD_FLAGS_WRITE;
+	} else {
+		data_direction = UTP_NO_DATA_TRANSFER;
+		*upiu_flags = UPIU_CMD_FLAGS_NONE;
+	}
+
+	dword_0 = data_direction | (lrbp->command_type
+				<< UPIU_COMMAND_TYPE_OFFSET);
+	if (lrbp->intr_cmd)
+		dword_0 |= UTP_REQ_DESC_INT_CMD;
+
+	/* Transfer request descriptor header fields */
+	req_desc->header.dword_0 = cpu_to_le32(dword_0);
+
+	/*
+	 * assigning invalid value for command status. Controller
+	 * updates OCS on command completion, with the command
+	 * status
+	 */
+	req_desc->header.dword_2 =
+		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+}
+
+/**
+ * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
+ * for scsi commands
+ * @lrbp - local reference block pointer
+ * @upiu_flags - flags
+ */
+static
+void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+
+	/* command descriptor fields */
+	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+				UPIU_TRANSACTION_COMMAND, upiu_flags,
+				lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+				UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
+
+	/* Total EHS length and Data segment length will be zero */
+	ucd_req_ptr->header.dword_2 = 0;
+
+	ucd_req_ptr->sc.exp_data_transfer_len =
+		cpu_to_be32(lrbp->cmd->sdb.length);
+
+	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd,
+		(min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE)));
+}
+
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
+/**
  * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * @hba - per adapter instance
  * @lrb - pointer to local reference block
  */
-static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
+static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct utp_transfer_req_desc *req_desc;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
-	u32 data_direction;
 	u32 upiu_flags;
-
-	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
-	req_desc = lrbp->utr_descriptor_ptr;
+	int ret = 0;
 
 	switch (lrbp->command_type) {
 	case UTP_CMD_TYPE_SCSI:
-		if (lrbp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
-			data_direction = UTP_DEVICE_TO_HOST;
-			upiu_flags = UPIU_CMD_FLAGS_READ;
-		} else if (lrbp->cmd->sc_data_direction == DMA_TO_DEVICE) {
-			data_direction = UTP_HOST_TO_DEVICE;
-			upiu_flags = UPIU_CMD_FLAGS_WRITE;
+		if (likely(lrbp->cmd)) {
+			ufshcd_prepare_req_desc(lrbp, &upiu_flags,
+					lrbp->cmd->sc_data_direction);
+			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 		} else {
-			data_direction = UTP_NO_DATA_TRANSFER;
-			upiu_flags = UPIU_CMD_FLAGS_NONE;
+			ret = -EINVAL;
 		}
-
-		/* Transfer request descriptor header fields */
-		req_desc->header.dword_0 =
-			cpu_to_le32(data_direction | UTP_SCSI_COMMAND);
-
-		/*
-		 * assigning invalid value for command status. Controller
-		 * updates OCS on command completion, with the command
-		 * status
-		 */
-		req_desc->header.dword_2 =
-			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
-
-		/* command descriptor fields */
-		ucd_cmd_ptr->header.dword_0 =
-			cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_COMMAND,
-						      upiu_flags,
-						      lrbp->lun,
-						      lrbp->task_tag));
-		ucd_cmd_ptr->header.dword_1 =
-			cpu_to_be32(
-				UPIU_HEADER_DWORD(UPIU_COMMAND_SET_TYPE_SCSI,
-						  0,
-						  0,
-						  0));
-
-		/* Total EHS length and Data segment length will be zero */
-		ucd_cmd_ptr->header.dword_2 = 0;
-
-		ucd_cmd_ptr->exp_data_transfer_len =
-			cpu_to_be32(lrbp->cmd->sdb.length);
-
-		memcpy(ucd_cmd_ptr->cdb,
-		       lrbp->cmd->cmnd,
-		       (min_t(unsigned short,
-			      lrbp->cmd->cmd_len,
-			      MAX_CDB_SIZE)));
 		break;
 	case UTP_CMD_TYPE_DEV_MANAGE:
-		/* For query function implementation */
+		ufshcd_prepare_req_desc(lrbp, &upiu_flags, DMA_NONE);
+		if (hba->i_cmd.dev_cmd_type == DEV_CMD_TYPE_NOP)
+			ufshcd_prepare_utp_nop_upiu(lrbp);
+		else
+			ret = -EINVAL;
 		break;
 	case UTP_CMD_TYPE_UFS:
 		/* For UFS native command implementation */
+		dev_err(hba->dev, "%s: UFS native command are not supported\n",
+			__func__);
+		ret = -ENOTSUPP;
+		break;
+	default:
+		ret = -ENOTSUPP;
+		dev_err(hba->dev, "%s: unknown command type: 0x%x\n",
+				__func__, lrbp->command_type);
 		break;
 	} /* end of switch */
+
+	return ret;
 }
 
 /**
@@ -654,11 +745,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = cmd->device->lun;
-
+	lrbp->intr_cmd = false;
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(lrbp);
+	ufshcd_compose_upiu(hba, lrbp);
 	err = ufshcd_map_sg(lrbp);
 	if (err)
 		goto out;
@@ -671,6 +762,139 @@ out:
 	return err;
 }
 
+static int ufshcd_compose_internal_cmd(struct ufs_hba *hba,
+		struct ufshcd_lrb *lrbp, enum internal_cmd_type cmd_type)
+{
+	lrbp->cmd = NULL;
+	lrbp->sense_bufflen = 0;
+	lrbp->sense_buffer = NULL;
+	lrbp->task_tag = INTERNAL_CMD_TAG;
+	lrbp->lun = 0; /* internal cmd is not specific to any LUN */
+	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+	lrbp->intr_cmd = true; /* No interrupt aggregation */
+	hba->i_cmd.dev_cmd_type = cmd_type;
+
+	return ufshcd_compose_upiu(hba, lrbp);
+}
+
+static int ufshcd_wait_for_internal_cmd(struct ufs_hba *hba,
+		struct ufshcd_lrb *lrbp, int max_timeout)
+{
+	int err = 0;
+	unsigned long timeout;
+	unsigned long flags;
+
+	timeout = wait_for_completion_timeout(hba->i_cmd.dev_cmd_complete,
+			msecs_to_jiffies(max_timeout));
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->i_cmd.dev_cmd_complete = NULL;
+	if (timeout)
+		err = ufshcd_get_tr_ocs(lrbp);
+	else
+		err = -ETIMEDOUT;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return err;
+}
+
+static int
+ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
+{
+	int err = 0;
+	unsigned long flags;
+	u32 reg;
+	u32 mask = 1 << tag;
+
+	/* clear outstanding transaction before retry */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_utrl_clear(hba, INTERNAL_CMD_TAG);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* poll for max. 1 sec to clear door bell register by h/w */
+	reg = ufshcd_wait_for_register(hba,
+			REG_UTP_TRANSFER_REQ_DOOR_BELL,
+			mask, mask, 1000, 1000);
+	if ((reg & mask) == mask)
+		err = -ETIMEDOUT;
+
+	return err;
+}
+
+/**
+ * ufshcd_internal_cmd_completion() - handles internal command responses
+ * @hba: per adapter instance
+ * @lrbp: pointer to local reference block
+ */
+static int
+ufshcd_internal_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int resp;
+	int err = 0;
+
+	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
+
+	switch (resp) {
+	case UPIU_TRANSACTION_NOP_IN:
+		break;
+	case UPIU_TRANSACTION_REJECT_UPIU:
+		/* TODO: handle Reject UPIU Response */
+		dev_err(hba->dev, "Reject UPIU not fully implemented\n");
+		err = -EPERM;
+		break;
+	default:
+		dev_err(hba->dev, "Invalid internal cmd response: %x\n", resp);
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+/**
+ * ufshcd_exec_internal_cmd() - API for sending internal
+ * requests
+ * @hba - UFS hba
+ * @cmd_type - specifies the type (NOP, Query...)
+ * @timeout - time in seconds
+ *
+ * NOTE: There is only one available tag for internal commands. Thus
+ * synchronisation is the responsibilty of the user.
+ */
+static int ufshcd_exec_internal_cmd(struct ufs_hba *hba,
+		enum internal_cmd_type cmd_type, int timeout)
+{
+	struct ufshcd_lrb *lrbp;
+	int err;
+	struct completion wait;
+	unsigned long flags;
+
+	init_completion(&wait);
+	lrbp = &hba->lrb[INTERNAL_CMD_TAG];
+
+	err = ufshcd_compose_internal_cmd(hba, lrbp, cmd_type);
+	if (unlikely(err))
+		goto out;
+
+	hba->i_cmd.dev_cmd_complete = &wait;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_send_command(hba, INTERNAL_CMD_TAG);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_wait_for_internal_cmd(hba, lrbp, timeout);
+
+	if (err == -ETIMEDOUT) {
+		if (!ufshcd_clear_cmd(hba, INTERNAL_CMD_TAG))
+			err = -EAGAIN;
+	} else if (!err) {
+		err = ufshcd_internal_cmd_completion(hba, lrbp);
+	}
+
+out:
+	return err;
+}
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
@@ -805,8 +1029,8 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le16(ALIGNED_UPIU_SIZE);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
-		hba->lrb[i].ucd_cmd_ptr =
-			(struct utp_upiu_cmd *)(cmd_descp + i);
+		hba->lrb[i].ucd_req_ptr =
+			(struct utp_upiu_req *)(cmd_descp + i);
 		hba->lrb[i].ucd_rsp_ptr =
 			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
 		hba->lrb[i].ucd_prdt_ptr =
@@ -992,6 +1216,38 @@ out:
 }
 
 /**
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
+	int err = 0;
+	int retries;
+
+	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
+		mutex_lock(&hba->i_cmd.dev_cmd_lock);
+		err = ufshcd_exec_internal_cmd(hba, DEV_CMD_TYPE_NOP,
+					       NOP_OUT_TIMEOUT);
+		mutex_unlock(&hba->i_cmd.dev_cmd_lock);
+
+		if (!err || err == -ETIMEDOUT)
+			break;
+
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+	}
+
+	if (err)
+		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
+	return err;
+}
+
+/**
  * ufshcd_do_reset - reset the host controller
  * @hba: per adapter instance
  *
@@ -1014,16 +1270,22 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* abort outstanding commands */
-	for (tag = 0; tag < hba->nutrs; tag++) {
+	for (tag = 0; tag < SCSI_CMD_QUEUE_SIZE; tag++) {
 		if (test_bit(tag, &hba->outstanding_reqs)) {
 			lrbp = &hba->lrb[tag];
-			scsi_dma_unmap(lrbp->cmd);
-			lrbp->cmd->result = DID_RESET << 16;
-			lrbp->cmd->scsi_done(lrbp->cmd);
-			lrbp->cmd = NULL;
+			if (lrbp->cmd) {
+				scsi_dma_unmap(lrbp->cmd);
+				lrbp->cmd->result = DID_RESET << 16;
+				lrbp->cmd->scsi_done(lrbp->cmd);
+				lrbp->cmd = NULL;
+			}
 		}
 	}
 
+	/* complete internal command */
+	if (hba->i_cmd.dev_cmd_complete)
+		complete(hba->i_cmd.dev_cmd_complete);
+
 	/* clear outstanding request/task bit maps */
 	hba->outstanding_reqs = 0;
 	hba->outstanding_tasks = 0;
@@ -1068,7 +1330,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	 * SAM_STAT_TASK_SET_FULL, the LUN queue depth will be adjusted
 	 * with scsi_adjust_queue_depth.
 	 */
-	scsi_activate_tcq(sdev, hba->nutrs);
+	scsi_activate_tcq(sdev, SCSI_CMD_QUEUE_SIZE);
 	return 0;
 }
 
@@ -1081,7 +1343,7 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
-	scsi_deactivate_tcq(sdev, hba->nutrs);
+	scsi_deactivate_tcq(sdev, SCSI_CMD_QUEUE_SIZE);
 }
 
 /**
@@ -1144,7 +1406,7 @@ static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
 	 * LUN queue depth can be obtained by counting outstanding commands
 	 * on the LUN.
 	 */
-	for (i = 0; i < hba->nutrs; i++) {
+	for (i = 0; i < SCSI_CMD_QUEUE_SIZE; i++) {
 		if (test_bit(i, &hba->outstanding_reqs)) {
 
 			/*
@@ -1230,27 +1492,36 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	switch (ocs) {
 	case OCS_SUCCESS:
-
 		/* check if the returned transfer response is valid */
-		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
-		if (result) {
+		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
+
+		switch (result) {
+		case UPIU_TRANSACTION_RESPONSE:
+			/*
+			 * get the response UPIU result to extract
+			 * the SCSI command status
+			 */
+			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
+
+			/*
+			 * get the result based on SCSI status response
+			 * to notify the SCSI midlayer of the command status
+			 */
+			scsi_status = result & MASK_SCSI_STATUS;
+			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
+			break;
+		case UPIU_TRANSACTION_REJECT_UPIU:
+			/* TODO: handle Reject UPIU Response */
+			result = DID_ERROR << 16;
 			dev_err(hba->dev,
-				"Invalid response = %x\n", result);
+				"Reject UPIU not fully implemented\n");
 			break;
+		default:
+			result = DID_ERROR << 16;
+			dev_err(hba->dev,
+				"Unexpected request response code = %x\n",
+				result);
 		}
-
-		/*
-		 * get the response UPIU result to extract
-		 * the SCSI command status
-		 */
-		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
-
-		/*
-		 * get the result based on SCSI status response
-		 * to notify the SCSI midlayer of the command status
-		 */
-		scsi_status = result & MASK_SCSI_STATUS;
-		result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
 		break;
 	case OCS_ABORTED:
 		result |= DID_ABORT << 16;
@@ -1290,29 +1561,37 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
  */
 static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	struct ufshcd_lrb *lrb;
+	struct ufshcd_lrb *lrbp;
+	struct scsi_cmnd *cmd;
 	unsigned long completed_reqs;
 	u32 tr_doorbell;
 	int result;
 	int index;
+	bool int_aggr_reset = false;
 
-	lrb = hba->lrb;
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
 
 	for (index = 0; index < hba->nutrs; index++) {
 		if (test_bit(index, &completed_reqs)) {
+			lrbp = &hba->lrb[index];
+			cmd = lrbp->cmd;
 
-			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
-
-			if (lrb[index].cmd) {
-				scsi_dma_unmap(lrb[index].cmd);
-				lrb[index].cmd->result = result;
-				lrb[index].cmd->scsi_done(lrb[index].cmd);
+			if (cmd) {
+				result = ufshcd_transfer_rsp_status(hba, lrbp);
+				scsi_dma_unmap(cmd);
+				cmd->result = result;
+				cmd->scsi_done(cmd);
 
 				/* Mark completed command as NULL in LRB */
-				lrb[index].cmd = NULL;
+				lrbp->cmd = NULL;
+			} else if (lrbp->command_type ==
+					UTP_CMD_TYPE_DEV_MANAGE) {
+				if (hba->i_cmd.dev_cmd_complete)
+					complete(hba->i_cmd.dev_cmd_complete);
 			}
+			/* Don't reset counters for interrupt cmd */
+			int_aggr_reset |= !lrbp->intr_cmd;
 		} /* end of if */
 	} /* end of for */
 
@@ -1320,7 +1599,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	hba->outstanding_reqs ^= completed_reqs;
 
 	/* Reset interrupt aggregation counters */
-	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+	if (int_aggr_reset)
+		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
 }
 
 /**
@@ -1463,10 +1743,10 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	task_req_upiup =
 		(struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
 	task_req_upiup->header.dword_0 =
-		cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
-					      lrbp->lun, lrbp->task_tag));
+		UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
+					      lrbp->lun, lrbp->task_tag);
 	task_req_upiup->header.dword_1 =
-	cpu_to_be32(UPIU_HEADER_DWORD(0, tm_function, 0, 0));
+		UPIU_HEADER_DWORD(0, tm_function, 0, 0);
 
 	task_req_upiup->input_param1 = lrbp->lun;
 	task_req_upiup->input_param1 =
@@ -1521,7 +1801,7 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
 	if (err == FAILED)
 		goto out;
 
-	for (pos = 0; pos < hba->nutrs; pos++) {
+	for (pos = 0; pos < SCSI_CMD_QUEUE_SIZE; pos++) {
 		if (test_bit(pos, &hba->outstanding_reqs) &&
 		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
 
@@ -1539,6 +1819,11 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
 			}
 		}
 	} /* end of for */
+
+	/* complete internal command */
+	if (hba->i_cmd.dev_cmd_complete)
+		complete(hba->i_cmd.dev_cmd_complete);
+
 out:
 	return err;
 }
@@ -1618,8 +1903,16 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
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
@@ -1771,8 +2064,8 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = SCSI_CMD_QUEUE_SIZE;
+	host->cmd_per_lun = SCSI_CMD_QUEUE_SIZE;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFSHCD_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
@@ -1788,6 +2081,9 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
 
+	/* Initialize mutex for internal commands */
+	mutex_init(&hba->i_cmd.dev_cmd_lock);
+
 	/* IRQ registration */
 	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 49590ee..e41fa5e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -68,6 +68,10 @@
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
 
+enum internal_cmd_type {
+	DEV_CMD_TYPE_NOP		= 0x0,
+};
+
 /**
  * struct uic_command - UIC command structure
  * @command: UIC command
@@ -91,7 +95,7 @@ struct uic_command {
 /**
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
- * @ucd_cmd_ptr: UCD address of the command
+ * @ucd_req_ptr: UCD address of the command
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
  * @cmd: pointer to SCSI command
@@ -101,10 +105,11 @@ struct uic_command {
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
+ * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
+	struct utp_upiu_req *ucd_req_ptr;
 	struct utp_upiu_rsp *ucd_rsp_ptr;
 	struct ufshcd_sg_entry *ucd_prdt_ptr;
 
@@ -116,8 +121,20 @@ struct ufshcd_lrb {
 	int command_type;
 	int task_tag;
 	unsigned int lun;
+	bool intr_cmd;
 };
 
+/**
+ * struct ufs_internal_cmd - all assosiated fields with internal commands
+ * @dev_cmd_type: device management command type - Query, NOP OUT
+ * @dev_cmd_lock: lock to allow one internal command at a time
+ * @dev_cmd_complete: internal commands completion
+ */
+struct ufs_internal_cmd {
+	enum internal_cmd_type dev_cmd_type;
+	struct mutex dev_cmd_lock;
+	struct completion *dev_cmd_complete;
+};
 
 /**
  * struct ufs_hba - per adapter private structure
@@ -146,6 +163,7 @@ struct ufshcd_lrb {
  * @intr_mask: Interrupt Mask Bits
  * @feh_workq: Work queue for fatal controller error handling
  * @errors: HBA errors
+ * @i_cmd: ufs internal command information
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -188,6 +206,9 @@ struct ufs_hba {
 
 	/* HBA Errors */
 	u32 errors;
+
+	/* Internal Request data */
+	struct ufs_internal_cmd i_cmd;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
