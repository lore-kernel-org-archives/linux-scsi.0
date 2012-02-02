From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 2/4] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Thu,  2 Feb 2012 10:27:27 +0530
Message-ID: <1328158649-4137-3-git-send-email-vinholikatti@gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Yaraganavi <santoshsy@gmail.com>

This patch adds support for Transfer request handling.

ufshcd includes following implementations:
 - SCSI queuecommand
 - Compose UPIU(UFS Protocol information unit)
 - Issue commands to UFS host controller
 - Handle completed commands

Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Saugata Das <saugata.das@linaro.org>
Reviewed-by: Vishak G <vishak.g@samsung.com>
Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c |  447 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 447 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c82eeea..23d758b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -62,6 +62,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
 
 #include "ufs.h"
@@ -81,6 +82,7 @@ enum {
 	UFSHCD_MAX_CHANNEL	= 1,
 	UFSHCD_MAX_ID		= 1,
 	UFSHCD_MAX_LUNS		= 8,
+	UFSHCD_CMD_PER_LUN	= 16,
 	UFSHCD_CAN_QUEUE	= 32,
 	BYTES_128		= 128,
 	BYTES_1024		= 1024
@@ -146,6 +148,7 @@ struct uic_command {
  * @host: Scsi_Host instance of the driver
  * @pdev: PCI device handle
  * @lrb: local reference block
+ * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
@@ -184,6 +187,8 @@ struct ufs_hba {
 
 	struct ufshcd_lrb *lrb;
 
+	u32 outstanding_reqs;
+
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
@@ -204,12 +209,28 @@ struct ufs_hba {
  * @ucd_cmd_ptr: UCD address of the command
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
+ * @cmd: pointer to scsi command
+ * @sense_buffer: pointer sense buffer address of the scsi command
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
+	int lun;
 };
 
 /**
@@ -236,6 +257,18 @@ static inline int ufshcd_is_device_present(u32 reg_hcs)
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
@@ -303,6 +336,36 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
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
+		 UPIU_TRANSACTION_RESPONSE) ? 0 :
+					      (DID_ERROR << 16 |
+					       COMMAND_COMPLETE << 8);
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
  * ufshcd_config_int_aggr - Configure interrupt aggregation values
  *		currently there is no use case where we want to configure
  *		interrupt aggregation dynamically. So to configure interrupt
@@ -342,6 +405,34 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_send_command - Send SCSI or device management commands
+ * @hba: per adapter instance
+ * @task_tag: Task tag of the command
+ */
+static inline
+void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
+{
+	hba->outstanding_reqs |= (1 << task_tag);
+	writel((1 << task_tag),
+	       (UFSHCD_MMIO_BASE + REG_UTP_TRANSFER_REQ_DOOR_BELL));
+}
+
+/**
+ * ufshcd_copy_sense_data - Copy sense data in case of check condition
+ * @lrb - pointer to local reference block
+ */
+static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
+{
+	int len;
+	if (lrbp->sense_buffer != NULL) {
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
@@ -385,6 +476,42 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
 }
 
 /**
+ * ufshcd_map_sg - Map scatter-gather list to prdt
+ * @lrbp - pointer to local reference block
+ */
+static void ufshcd_map_sg(struct ufshcd_lrb *lrbp)
+{
+	struct ufshcd_sg_entry *prd_table;
+	struct scatterlist *sg;
+	struct scsi_cmnd *cmd;
+	int sg_segments;
+	int i;
+
+	cmd = lrbp->cmd;
+	sg_segments = scsi_dma_map(cmd);
+
+	BUG_ON(sg_segments < 0);
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
+}
+
+/**
  * ufshcd_int_config - enable/disable interrupts
  * @hba: per adapter instance
  * @option: interrupt option
@@ -410,6 +537,124 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
+ * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * @hba: per adapter instance
+ * @lrb - pointer to local reference block
+ */
+static void ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct utp_transfer_req_desc *req_desc;
+	struct utp_upiu_cmd *ucd_cmd_ptr;
+	u32 data_direction;
+	u32 upiu_flags;
+
+	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
+	req_desc = lrbp->utr_descriptor_ptr;
+
+	memset(ucd_cmd_ptr, 0, sizeof(struct utp_upiu_cmd));
+
+	switch (lrbp->command_type) {
+	case UTP_CMD_TYPE_SCSI:
+		if (DMA_FROM_DEVICE == lrbp->cmd->sc_data_direction) {
+			data_direction = UTP_DEVICE_TO_HOST;
+			upiu_flags = UPIU_CMD_FLAGS_READ;
+		} else if (DMA_TO_DEVICE == lrbp->cmd->sc_data_direction) {
+			data_direction = UTP_HOST_TO_DEVICE;
+			upiu_flags = UPIU_CMD_FLAGS_WRITE;
+		} else {
+			data_direction = UTP_NO_DATA_TRANSFER;
+			upiu_flags = 0;
+		}
+
+		/*
+		 * Transfer request desc header fields
+		 * set interrupt bit if interrupt aggregation is disabled
+		 */
+		req_desc->header.dword_0 = cpu_to_le32(data_direction |
+						       UTP_SCSI_COMMAND);
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
+		ucd_cmd_ptr->exp_data_transfer_len =
+			cpu_to_be32(lrbp->cmd->transfersize);
+		memcpy(ucd_cmd_ptr->cdb, lrbp->cmd->cmnd,
+		      (min_t(unsigned short,
+			     lrbp->cmd->cmd_len,
+			     (unsigned short)MAX_CDB_SIZE)));
+
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
+		/* set command response to zero */
+		memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+	case UTP_CMD_TYPE_DEV_MANAGE:
+		/* For query function implementation */
+		break;
+	case UTP_CMD_TYPE_UFS:
+		/* For UFS native command implementation */
+		break;
+	} /* end of switch, command_type */
+}
+
+/**
+ * ufshcd_queuecommand - main entry point for SCSI requests
+ * @cmd: command from SCSI Midlayer
+ * @done: call back function
+ *
+ * Retruns 0 for success, SCSI Midlayer specific error in case of failure
+ */
+static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+{
+	struct ufshcd_lrb *lrbp;
+	struct ufs_hba *hba;
+	unsigned long flags;
+	int tag;
+
+	hba = (struct ufs_hba *) &host->hostdata[0];
+
+	tag = cmd->request->tag;
+
+	if (UFSHCD_STATE_OPERATIONAL != hba->ufshcd_state)
+		return SCSI_MLQUEUE_HOST_BUSY;
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
+	ufshcd_compose_upiu(hba, lrbp);
+	ufshcd_map_sg(lrbp);
+
+	/* issue command to the controller */
+	spin_lock_irqsave(host->host_lock, flags);
+	ufshcd_send_command(hba, tag);
+	spin_unlock_irqrestore(host->host_lock, flags);
+	return 0;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -680,6 +925,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
 
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	scsi_scan_host(hba->host);
 
 	return 0;
 }
@@ -763,6 +1009,190 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_slave_alloc - handle initial scsi devie configurations
+ * @sdev: pointer to scsi device
+ *
+ * Returns success
+ */
+static int ufshcd_slave_alloc(struct scsi_device *sdev)
+{
+	struct ufs_hba *hba;
+
+	hba = (struct ufs_hba *)sdev->host->hostdata;
+	sdev->tagged_supported = 1;
+	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
+	scsi_activate_tcq(sdev, hba->nutrs);
+
+	return 0;
+}
+
+/**
+ * ufshcd_slave_destroy - remove scsi device configurations
+ * @sdev: pointer to scsi device
+ */
+static void ufshcd_slave_destroy(struct scsi_device *sdev)
+{
+	struct ufs_hba *hba;
+
+	hba = (struct ufs_hba *)sdev->host->hostdata;
+	scsi_deactivate_tcq(sdev, hba->nutrs);
+}
+
+/**
+ * ufshcd_scsi_cmd_status - Update SCSI command result based on scsi status
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
+		result |= DRIVER_SENSE << 24 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_CHECK_CONDITION;
+		ufshcd_copy_sense_data(lrbp);
+		break;
+	case SAM_STAT_BUSY:
+		result |= DID_BUS_BUSY << 16 |
+			  SAM_STAT_BUSY;
+		break;
+	case SAM_STAT_TASK_SET_FULL:
+		result |= DID_OK << 16 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_TASK_SET_FULL;
+		break;
+	case SAM_STAT_TASK_ABORTED:
+		result |=  DID_ABORT << 16 |
+			   ABORT_TASK << 8 |
+			   SAM_STAT_TASK_ABORTED;
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
+ * @lrb: pointer to local reference block of completed command
+ *
+ * Returns result of the command to notify SCSI midlayer
+ */
+static inline int ufshcd_transfer_rsp_status(struct ufshcd_lrb *lrbp)
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
+			pr_err(UFSHCD ":Invalid Response\n");
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
+	case OCS_INVALID_CMD_TABLE_ATTR:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case OCS_INVALID_PRDT_ATTR:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case OCS_MISMATCH_DATA_BUF_SIZE:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case OCS_MISMATCH_RESP_UPIU_SIZE:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case OCS_PEER_COMM_FAILURE:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case OCS_ABORTED:
+		result |= DID_ABORT << 16 | ABORT_TASK << 8;
+		break;
+	case OCS_FATAL_ERROR:
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		break;
+	default:
+		/* should not come here */
+		result |= DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		pr_err(UFSHCD ":Invalid OCS from controller\n");
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
+	u32 completed_reqs;
+	u32 tr_doorbell;
+	int result;
+	int index;
+
+	lrb = hba->lrb;
+	tr_doorbell =
+		readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+
+	/* clear completed commands from outstanding_reqs */
+	hba->outstanding_reqs ^= completed_reqs;
+
+	for (index = 0; index < hba->nutrs; index++) {
+		if (completed_reqs & (1 << index)) {
+
+			result = ufshcd_transfer_rsp_status(&lrb[index]);
+
+			if (NULL != lrb[index].cmd) {
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
+	/* Reset interrupt aggregation counters */
+	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+}
+
+/**
  * ufshcd_uic_cc_handler - handle UIC command completion
  * @work: pointer to a work queue structure
  *
@@ -793,6 +1223,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	if (intr_status & UIC_COMMAND_COMPL)
 		schedule_work(&hba->uic_workq);
+
+	if (intr_status & UTP_TRANSFER_REQ_COMPL)
+		ufshcd_transfer_req_compl(hba);
 }
 
 /**
@@ -830,7 +1263,13 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.queuecommand		= ufshcd_queuecommand,
+	.slave_alloc		= ufshcd_slave_alloc,
+	.slave_destroy		= ufshcd_slave_destroy,
 	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
+	.can_queue		= UFSHCD_CAN_QUEUE
 };
 
 /**
@@ -1003,6 +1442,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->max_lun = UFSHCD_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
+	host->max_cmd_len = MAX_CDB_SIZE;
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
@@ -1014,6 +1454,13 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_lrb_free;
 	}
 
+	/* Enable scsi tag mapping */
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
