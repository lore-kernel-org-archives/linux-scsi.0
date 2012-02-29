From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v3 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Wed, 29 Feb 2012 12:11:51 +0530
Message-ID: <1330497714-26504-3-git-send-email-santoshsy@gmail.com>
References: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36830 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443Ab2B2GoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 01:44:16 -0500
In-Reply-To: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu, Santosh Yaraganavi <santoshsy@gmail.com>

From: Santosh Yaraganavi <santoshsy@gmail.com>

This patch adds support for Transfer request handling.

ufshcd includes following implementations:
 - SCSI queuecommand
 - Compose UPIU(UFS Protocol information unit)
 - Issue commands to UFS host controller
 - Handle completed commands

Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@linaro.org>
Reviewed-by: Vishak G <vishak.g@samsung.com>
Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
---
v2 -> v3:
	- use shost_priv() instead of accessing hostdata directly.
	- update SCSI command result with appropriate byte codes.
v1 -> v2:
	- Use bitops.h defined functions to perform bit operations.
	  Ex: set_bit(), __set_bit, clear_bit...
	- ufshcd_map_sg(): remove BUG_ON on scsi_dma_map() failure
	  and return error value.
	- ufshcd_compose_upiu(): add missing break in switch case,
	  remove unused parameter "hba".
	- ufshcd_slave_alloc(): set sdev->use_10_for_ms = 1, since UFS
	  does not support MODE_SENSE_6.
	- ufshcd_scsi_cmd_status(): add missing break in switch case.
	  Add ufshcd_adjust_lun_qdepth to adjust LUN queue depth
	  if SAM_STAT_TASK_SET_FULL is received from the device.
	- ufshcd_transfer_rsp_status(): combine cases with same error code.

 drivers/scsi/ufs/ufshcd.c |  494 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 494 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 26b16c1..43b9c62 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -63,6 +63,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
 
 #include "ufs.h"
@@ -75,6 +76,8 @@ enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
 	UFSHCD_MAX_LUNS		= 8,
+	UFSHCD_CMD_PER_LUN	= 32,
+	UFSHCD_CAN_QUEUE	= 32,
 };
 
 /* UFSHCD states */
@@ -127,6 +130,7 @@ struct uic_command {
  * @host: Scsi_Host instance of the driver
  * @pdev: PCI device handle
  * @lrb: local reference block
+ * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
@@ -153,6 +157,8 @@ struct ufs_hba {
 
 	struct ufshcd_lrb *lrb;
 
+	unsigned long outstanding_reqs;
+
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
@@ -173,12 +179,28 @@ struct ufs_hba {
  * @ucd_cmd_ptr: UCD address of the command
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
+ * @cmd: pointer to SCSI command
+ * @sense_buffer: pointer to sense buffer address of the SCSI command
+ * @sense_bufflen: Length of the sense buffer
+ * @scsi_status: SCSI status of the command
+ * @command_type: SCSI, UFS, Query.
+ * @task_tag: Task tag of the command
+ * @lun: LUN of the command
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
 	struct utp_upiu_cmd *ucd_cmd_ptr;
 	struct utp_upiu_rsp *ucd_rsp_ptr;
 	struct ufshcd_sg_entry *ucd_prdt_ptr;
+
+	struct scsi_cmnd *cmd;
+	u8 *sense_buffer;
+	unsigned int sense_bufflen;
+	int scsi_status;
+
+	int command_type;
+	int task_tag;
+	unsigned int lun;
 };
 
 /**
@@ -205,6 +227,18 @@ static inline int ufshcd_is_device_present(u32 reg_hcs)
 }
 
 /**
+ * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
+ * @lrb: pointer to local command reference block
+ *
+ * This function is used to get the OCS field from UTRD
+ * Returns the OCS field in the UTRD
+ */
+static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
+{
+	return lrbp->utr_descriptor_ptr->header.dword_2 & MASK_OCS;
+}
+
+/**
  * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
  * @reg: Register value of host controller status
  *
@@ -272,6 +306,34 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
+ * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * This function checks the response UPIU for valid transaction type in
+ * response field
+ * Returns 0 on success, non-zero on failure
+ */
+static inline int
+ufshcd_is_valid_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
+{
+	return ((be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24) ==
+		 UPIU_TRANSACTION_RESPONSE) ? 0 : DID_ERROR << 16;
+}
+
+/**
+ * ufshcd_get_rsp_upiu_result - Get the result from response UPIU
+ * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * This function gets the response status and scsi_status from response UPIU
+ * Returns the response result code.
+ */
+static inline int
+ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
+{
+	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
+}
+
+/**
  * ufshcd_config_int_aggr - Configure interrupt aggregation values.
  *		Currently there is no use case where we want to configure
  *		interrupt aggregation dynamically. So to configure interrupt
@@ -347,6 +409,34 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_send_command - Send SCSI or device management commands
+ * @hba: per adapter instance
+ * @task_tag: Task tag of the command
+ */
+static inline
+void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
+{
+	__set_bit(task_tag, &hba->outstanding_reqs);
+	writel((1 << task_tag),
+	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL));
+}
+
+/**
+ * ufshcd_copy_sense_data - Copy sense data in case of check condition
+ * @lrb - pointer to local reference block
+ */
+static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
+{
+	int len;
+	if (lrbp->sense_buffer) {
+		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
+		memcpy(lrbp->sense_buffer,
+			lrbp->ucd_rsp_ptr->sense_data,
+			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
+	}
+}
+
+/**
  * ufshcd_hba_capabilities - Read controller capabilities
  * @hba: per adapter instance
  */
@@ -383,6 +473,46 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
 }
 
 /**
+ * ufshcd_map_sg - Map scatter-gather list to prdt
+ * @lrbp - pointer to local reference block
+ *
+ * Returns 0 in case of success, non-zero value in case of failure
+ */
+static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
+{
+	struct ufshcd_sg_entry *prd_table;
+	struct scatterlist *sg;
+	struct scsi_cmnd *cmd;
+	int sg_segments;
+	int i;
+
+	cmd = lrbp->cmd;
+	sg_segments = scsi_dma_map(cmd);
+	if (sg_segments < 0)
+		return sg_segments;
+
+	if (sg_segments) {
+		lrbp->utr_descriptor_ptr->prd_table_length =
+					cpu_to_le16((u16) (sg_segments));
+
+		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
+
+		scsi_for_each_sg(cmd, sg, sg_segments, i) {
+			prd_table[i].size  =
+				cpu_to_le32(((u32) sg_dma_len(sg))-1);
+			prd_table[i].base_addr =
+				cpu_to_le32(sg->dma_address);
+			prd_table[i].upper_addr =
+				cpu_to_le32((sg->dma_address >> 32));
+		}
+	} else {
+		lrbp->utr_descriptor_ptr->prd_table_length = 0;
+	}
+
+	return 0;
+}
+
+/**
  * ufshcd_int_config - enable/disable interrupts
  * @hba: per adapter instance
  * @option: interrupt option
@@ -406,6 +536,127 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
+ * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * @lrb - pointer to local reference block
+ */
+static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
+{
+	struct utp_transfer_req_desc *req_desc;
+	struct utp_upiu_cmd *ucd_cmd_ptr;
+	u32 data_direction;
+	u32 upiu_flags;
+
+	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
+	req_desc = lrbp->utr_descriptor_ptr;
+
+	switch (lrbp->command_type) {
+	case UTP_CMD_TYPE_SCSI:
+		if (lrbp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
+			data_direction = UTP_DEVICE_TO_HOST;
+			upiu_flags = UPIU_CMD_FLAGS_READ;
+		} else if (lrbp->cmd->sc_data_direction == DMA_TO_DEVICE) {
+			data_direction = UTP_HOST_TO_DEVICE;
+			upiu_flags = UPIU_CMD_FLAGS_WRITE;
+		} else {
+			data_direction = UTP_NO_DATA_TRANSFER;
+			upiu_flags = UPIU_CMD_FLAGS_NONE;
+		}
+
+		/* Transfer request descriptor header fields */
+		req_desc->header.dword_0 =
+			cpu_to_le32(data_direction | UTP_SCSI_COMMAND);
+
+		/*
+		 * assigning invalid value for command status. Controller
+		 * updates OCS on command completion, with the command
+		 * status
+		 */
+		req_desc->header.dword_2 =
+			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+
+		/* command descriptor fields */
+		ucd_cmd_ptr->header.dword_0 =
+			cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_COMMAND,
+						      upiu_flags,
+						      lrbp->lun,
+						      lrbp->task_tag));
+		ucd_cmd_ptr->header.dword_1 =
+			cpu_to_be32(
+				UPIU_HEADER_DWORD(UPIU_COMMAND_SET_TYPE_SCSI,
+						  0,
+						  0,
+						  0));
+
+		/* Total EHS length and Data segment length will be zero */
+		ucd_cmd_ptr->header.dword_2 = 0;
+
+		ucd_cmd_ptr->exp_data_transfer_len =
+			cpu_to_be32(lrbp->cmd->transfersize);
+
+		memcpy(ucd_cmd_ptr->cdb,
+		       lrbp->cmd->cmnd,
+		       (min_t(unsigned short,
+			      lrbp->cmd->cmd_len,
+			      MAX_CDB_SIZE)));
+		break;
+	case UTP_CMD_TYPE_DEV_MANAGE:
+		/* For query function implementation */
+		break;
+	case UTP_CMD_TYPE_UFS:
+		/* For UFS native command implementation */
+		break;
+	} /* end of switch */
+}
+
+/**
+ * ufshcd_queuecommand - main entry point for SCSI requests
+ * @cmd: command from SCSI Midlayer
+ * @done: call back function
+ *
+ * Returns 0 for success, non-zero in case of failure
+ */
+static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+{
+	struct ufshcd_lrb *lrbp;
+	struct ufs_hba *hba;
+	unsigned long flags;
+	int tag;
+	int err = 0;
+
+	hba = shost_priv(host);
+
+	tag = cmd->request->tag;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	lrbp = &hba->lrb[tag];
+
+	lrbp->cmd = cmd;
+	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
+	lrbp->sense_buffer = cmd->sense_buffer;
+	lrbp->task_tag = tag;
+	lrbp->lun = cmd->device->lun;
+
+	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+
+	/* form UPIU before issuing the command */
+	ufshcd_compose_upiu(lrbp);
+	err = ufshcd_map_sg(lrbp);
+	if (err)
+		goto out;
+
+	/* issue command to the controller */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_send_command(hba, tag);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return err;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -643,6 +894,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
 
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	scsi_scan_host(hba->host);
 out:
 	return err;
 }
@@ -742,6 +994,230 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_slave_alloc - handle initial SCSI device configurations
+ * @sdev: pointer to SCSI device
+ *
+ * Returns success
+ */
+static int ufshcd_slave_alloc(struct scsi_device *sdev)
+{
+	struct ufs_hba *hba;
+
+	hba = shost_priv(sdev->host);
+	sdev->tagged_supported = 1;
+
+	/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
+	sdev->use_10_for_ms = 1;
+	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
+
+	/*
+	 * Inform SCSI Midlayer that the LUN queue depth is same as the
+	 * controller queue depth. If a LUN queue depth is less than the
+	 * controller queue depth and if the LUN reports
+	 * SAM_STAT_TASK_SET_FULL, the LUN queue depth will be adjusted
+	 * with scsi_adjust_queue_depth.
+	 */
+	scsi_activate_tcq(sdev, hba->nutrs);
+	return 0;
+}
+
+/**
+ * ufshcd_slave_destroy - remove SCSI device configurations
+ * @sdev: pointer to SCSI device
+ */
+static void ufshcd_slave_destroy(struct scsi_device *sdev)
+{
+	struct ufs_hba *hba;
+
+	hba = shost_priv(sdev->host);
+	scsi_deactivate_tcq(sdev, hba->nutrs);
+}
+
+/**
+ * ufshcd_adjust_lun_qdepth - Update LUN queue depth if device responds with
+ *			      SAM_STAT_TASK_SET_FULL SCSI command status.
+ * @cmd: pointer to SCSI command
+ */
+static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
+{
+	struct ufs_hba *hba;
+	int i;
+	int lun_qdepth = 0;
+
+	hba = shost_priv(cmd->device->host);
+
+	/*
+	 * LUN queue depth can be obtained by counting outstanding commands
+	 * on the LUN.
+	 */
+	for (i = 0; i < hba->nutrs; i++) {
+		if (test_bit(i, &hba->outstanding_reqs)) {
+
+			/*
+			 * Check if the outstanding command belongs
+			 * to the LUN which reported SAM_STAT_TASK_SET_FULL.
+			 */
+			if (cmd->device->lun == hba->lrb[i].lun)
+				lun_qdepth++;
+		}
+	}
+
+	/*
+	 * LUN queue depth will be total outstanding commands, except the
+	 * command for which the LUN reported SAM_STAT_TASK_SET_FULL.
+	 */
+	scsi_adjust_queue_depth(cmd->device, MSG_SIMPLE_TAG, lun_qdepth - 1);
+}
+
+/**
+ * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
+ * @lrb: pointer to local reference block of completed command
+ * @scsi_status: SCSI command status
+ *
+ * Returns value base on SCSI command status
+ */
+static inline int
+ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
+{
+	int result = 0;
+
+	switch (scsi_status) {
+	case SAM_STAT_GOOD:
+		result |= DID_OK << 16 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_GOOD;
+		break;
+	case SAM_STAT_CHECK_CONDITION:
+		result |= DID_OK << 16 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_CHECK_CONDITION;
+		ufshcd_copy_sense_data(lrbp);
+		break;
+	case SAM_STAT_BUSY:
+		result |= SAM_STAT_BUSY;
+		break;
+	case SAM_STAT_TASK_SET_FULL:
+
+		/*
+		 * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
+		 * depth needs to be adjusted to the exact number of
+		 * outstanding commands the LUN can handle at any given time.
+		 */
+		ufshcd_adjust_lun_qdepth(lrbp->cmd);
+		result |= SAM_STAT_TASK_SET_FULL;
+		break;
+	case SAM_STAT_TASK_ABORTED:
+		result |= SAM_STAT_TASK_ABORTED;
+		break;
+	default:
+		result |= DID_ERROR << 16;
+		break;
+	} /* end of switch */
+
+	return result;
+}
+
+/**
+ * ufshcd_transfer_rsp_status - Get overall status of the response
+ * @hba: per adapter instance
+ * @lrb: pointer to local reference block of completed command
+ *
+ * Returns result of the command to notify SCSI midlayer
+ */
+static inline int
+ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int result = 0;
+	int scsi_status;
+	int ocs;
+
+	/* overall command status of utrd */
+	ocs = ufshcd_get_tr_ocs(lrbp);
+
+	switch (ocs) {
+	case OCS_SUCCESS:
+
+		/* check if the returned transfer response is valid */
+		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
+		if (result) {
+			dev_err(&hba->pdev->dev,
+				"Invalid response = %x\n", result);
+			break;
+		}
+
+		/*
+		 * get the response UPIU result to extract
+		 * the SCSI command status
+		 */
+		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
+
+		/*
+		 * get the result based on SCSI status response
+		 * to notify the SCSI midlayer of the command status
+		 */
+		scsi_status = result & MASK_SCSI_STATUS;
+		result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
+		break;
+	case OCS_ABORTED:
+		result |= DID_ABORT << 16;
+		break;
+	case OCS_INVALID_CMD_TABLE_ATTR:
+	case OCS_INVALID_PRDT_ATTR:
+	case OCS_MISMATCH_DATA_BUF_SIZE:
+	case OCS_MISMATCH_RESP_UPIU_SIZE:
+	case OCS_PEER_COMM_FAILURE:
+	case OCS_FATAL_ERROR:
+	default:
+		result |= DID_ERROR << 16;
+		dev_err(&hba->pdev->dev,
+		"OCS error from controller = %x\n", ocs);
+		break;
+	} /* end of switch */
+
+	return result;
+}
+
+/**
+ * ufshcd_transfer_req_compl - handle SCSI and query command completion
+ * @hba: per adapter instance
+ */
+static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
+{
+	struct ufshcd_lrb *lrb;
+	unsigned long completed_reqs;
+	u32 tr_doorbell;
+	int result;
+	int index;
+
+	lrb = hba->lrb;
+	tr_doorbell =
+		readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+
+	for (index = 0; index < hba->nutrs; index++) {
+		if (test_bit(index, &completed_reqs)) {
+
+			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
+
+			if (lrb[index].cmd) {
+				scsi_dma_unmap(lrb[index].cmd);
+				lrb[index].cmd->result = result;
+				lrb[index].cmd->scsi_done(lrb[index].cmd);
+
+				/* Mark completed command as NULL in LRB */
+				lrb[index].cmd = NULL;
+			}
+		} /* end of if */
+	} /* end of for */
+
+	/* clear corresponding bits of completed commands */
+	hba->outstanding_reqs ^= completed_reqs;
+
+	/* Reset interrupt aggregation counters */
+	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+}
+
+/**
  * ufshcd_uic_cc_handler - handle UIC command completion
  * @work: pointer to a work queue structure
  *
@@ -772,6 +1248,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	if (intr_status & UIC_COMMAND_COMPL)
 		schedule_work(&hba->uic_workq);
+
+	if (intr_status & UTP_TRANSFER_REQ_COMPL)
+		ufshcd_transfer_req_compl(hba);
 }
 
 /**
@@ -808,7 +1287,13 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.queuecommand		= ufshcd_queuecommand,
+	.slave_alloc		= ufshcd_slave_alloc,
+	.slave_destroy		= ufshcd_slave_destroy,
 	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
+	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
 /**
@@ -998,10 +1483,12 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ufshcd_host_memory_configure(hba);
 
 	host->can_queue = hba->nutrs;
+	host->cmd_per_lun = hba->nutrs;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFSHCD_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
+	host->max_cmd_len = MAX_CDB_SIZE;
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
@@ -1013,6 +1500,13 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_lrb_free;
 	}
 
+	/* Enable SCSI tag mapping */
+	err = scsi_init_shared_tag_map(host, host->can_queue);
+	if (err) {
+		dev_err(&pdev->dev, "init shared queue failed\n");
+		goto out_free_irq;
+	}
+
 	pci_set_drvdata(pdev, hba);
 
 	err = scsi_add_host(host, &pdev->dev);
-- 
1.7.5.4

