From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RFC] scsi: ufs: Rework UFS host driver implementation
Date: Fri,  3 May 2013 19:34:41 +0530
Message-ID: <1367589881-10860-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

UFS protocol comprises of two specifications, UFS device and
UFS host controller specification. The current UFSHCD driver
combines implementation of both the specs into one file. As
new features evolve in both specifications one single file
looks cumbersome and hard to maintain. Split the UFS driver file
into two -

ufs.c:
- Behave as a LLD to SCSI mid layer.
- Implements UFS device specification
	o Driver interfaces to UFS device in terms of UPIUs.
	o Prepares UPIUs for SCSI commands and internal commands
	  and send it to host driver through host ops.
	o Handles full device initialization.
	o Handles device power management
	o Handles device specific features like bkops etc.
	o Handles task management commands.

ufshcd.c:
- Driver interfaces with host controller and UIC layer on host side.
- Implements UFS HCI specification
	o Configure memory and transfer descriptors
	o Build UTRD and UTMRD based on request from ufs.c and allow
	  controller to execute the commands
	o Handle hardware interrupts from controller including errors.
	o Handle UIC commands
	o Handle host controller/UIC specific power management

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>

---
The patch is not complete and does not handle some of the points
mentioned above. This is just for review on design part.
---
 drivers/scsi/ufs/Makefile |    2 +-
 drivers/scsi/ufs/ufs.c    |  341 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h    |   37 +++++
 drivers/scsi/ufs/ufshcd.c |  352 +++++++++++++--------------------------------
 drivers/scsi/ufs/ufshcd.h |   10 ++
 5 files changed, 487 insertions(+), 255 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs.c

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 1e5bd48..386b17a 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,4 @@
 # UFSHCD makefile
-obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o ufs.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs.c b/drivers/scsi/ufs/ufs.c
new file mode 100644
index 0000000..50dac2d
--- /dev/null
+++ b/drivers/scsi/ufs/ufs.c
@@ -0,0 +1,341 @@
+/*
+ * Universal Flash Storage driver Core
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd.c
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
+ *
+ * The Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
+ */
+
+#include "ufshcd.h"
+
+static bool ufs_is_valid_tr_rsp(struct ufs_tr_queue_cmd *trcmd)
+{
+	struct utp_upiu_rsp *resp_upiu = trcmd->resp_upiu;
+	struct utp_upiu_cmd *req_upiu = trcmd->req_upiu;
+	u8 cmd;
+	u8 resp;
+
+	cmd = be32_to_cpu(req_upiu->header.dword_0) >> 24;
+	resp = be32_to_cpu(resp_upiu->header.dword_0) >> 24;
+
+	switch (cmd) {
+	case UPIU_TRANSACTION_COMMAND:
+		if (resp == UPIU_TRANSACTION_RESPONSE)
+			return true;
+	default:
+		return false;
+	}
+}
+
+static inline u16 ufs_get_rsp_upiu_result(struct utp_upiu_rsp *upiu)
+{
+	return be32_to_cpu(upiu->header.dword_1) & MASK_RSP_UPIU_RESULT;
+}
+
+static inline void ufs_copy_sense_data(struct ufs_tr_queue_cmd *trcmd)
+{
+	int len;
+	struct utp_upiu_rsp *upiu = trcmd->resp_upiu;
+	unsigned char *buf = trcmd->scmd->sense_buffer;
+
+	if (buf) {
+		len = be16_to_cpu(upiu->sense_data_len);
+		memcpy(buf, upiu->sense_data,
+				min_t(int, len, SCSI_SENSE_BUFFERSIZE));
+	}
+}
+
+/**
+ * ufs_scsi_cmd_status - Update SCSI command result based on SCSI status
+ * @lrb: pointer to local reference block of completed command
+ * @scsi_status: SCSI command status
+ *
+ * Returns value base on SCSI command status
+ */
+static int ufs_scsi_cmd_status(struct ufs_tr_queue_cmd *trcmd, int scsi_status)
+{
+	int result = 0;
+	int lun_qdepth;
+	struct ufs_hba *hba = trcmd->hba;
+	struct scsi_cmnd *scmd = trcmd->scmd;
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
+		ufs_copy_sense_data(trcmd);
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
+		lun_qdepth = hba->ops->get_lun_qdepth(trcmd->hba, trcmd->lun);
+
+		/*
+		 * LUN queue depth will be total outstanding commands,
+		 * except the command for which the LUN reported
+		 * SAM_STAT_TASK_SET_FULL.
+		 */
+		scsi_adjust_queue_depth(scmd->device,
+				MSG_SIMPLE_TAG, lun_qdepth - 1);
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
+static int ufs_tr_queue_cmd_done(struct ufs_tr_queue_cmd *trcmd)
+{
+	struct utp_upiu_rsp *upiu = trcmd->resp_upiu;
+	int result = trcmd->result;
+	int scsi_status;
+	struct scsi_cmnd *scmd = trcmd->scmd;
+	struct ufs_hba *hba = trcmd->hba;
+
+	switch (result) {
+	case UFS_CMD_SUCCESS:
+		break;
+	case UFS_CMD_ABORTED:
+		set_host_byte(scmd, DID_ABORT);
+		goto out;
+	case UFS_CMD_ERROR:
+	default:
+		set_host_byte(scmd, DID_ERROR);
+		goto out;
+	}
+
+	if (!upiu) {
+		set_host_byte(scmd, DID_ERROR);
+		goto out;
+	}
+
+	/* check if the returned transfer response is valid */
+	if (!ufs_is_valid_tr_rsp(trcmd)) {
+		dev_err(hba->dev, "%s: Invalid response = 0x%x\n",
+				__func__, be32_to_cpu(
+				trcmd->resp_upiu->header.dword_0) >> 24);
+		set_host_byte(scmd, DID_ERROR);
+		goto out;
+	}
+
+	/*
+	 * get the response UPIU result to extract
+	 * the overall response status and SCSI command status.
+	 */
+	result = ufs_get_rsp_upiu_result(trcmd->resp_upiu);
+
+	if (result & MASK_TRANSFER_RESPONSE) {
+		set_host_byte(scmd, DID_ERROR);
+		goto out;
+	}
+
+	/*
+	 * get the result based on SCSI status response
+	 * to notify the SCSI midlayer of the command status
+	 */
+	scsi_status = result & MASK_SCSI_STATUS;
+	result = ufs_scsi_cmd_status(trcmd, scsi_status);
+	scmd->result = result;
+out:
+	scsi_dma_unmap(scmd);
+	trcmd->scmd->scsi_done(trcmd->scmd);
+	return 0;
+}
+
+static inline bool ufs_is_tag_valid(u32 tag)
+{
+	return (tag < UFS_MAX_QUEUE) ? true : false;
+}
+
+static int
+ufs_fill_tr_cmd(struct scsi_cmnd *scmd, struct ufs_tr_queue_cmd *trcmd)
+{
+	int nsegs;
+	int err = 0;
+
+	memset(trcmd, 0, sizeof(*trcmd));
+	trcmd->scmd = scmd;
+	trcmd->tag = scmd->request->tag;
+	trcmd->lun = scmd->device->lun;
+	trcmd->command_type = UTP_CMD_TYPE_SCSI;
+	trcmd->done = ufs_tr_queue_cmd_done;
+	trcmd->sgl = scsi_sglist(scmd);
+
+	if (trcmd->sgl) {
+		trcmd->dir = scmd->sc_data_direction;
+		nsegs = scsi_dma_map(scmd);
+		if (nsegs < 0)
+			err = nsegs;
+		else
+			trcmd->sg_segments = nsegs;
+	}
+
+	return err;
+}
+
+static int ufs_compose_upiu(struct ufs_tr_queue_cmd *trcmd)
+{
+	struct utp_upiu_cmd *upiu;
+	struct ufs_hba *hba = trcmd->hba;
+	int err = 0;
+	u8 flags = UPIU_CMD_FLAGS_NONE;
+
+	upiu = hba->ops->get_tr_upiu(trcmd);
+
+	if (!upiu) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	switch (trcmd->command_type) {
+	case UTP_CMD_TYPE_SCSI:
+		if (trcmd->dir == DMA_FROM_DEVICE)
+			flags = UPIU_CMD_FLAGS_READ;
+		else if (trcmd->dir == DMA_TO_DEVICE)
+			flags = UPIU_CMD_FLAGS_WRITE;
+
+		upiu->header.dword_0 = cpu_to_be32(UPIU_HEADER_DWORD(
+					UPIU_TRANSACTION_COMMAND,
+					flags,
+					trcmd->lun,
+					trcmd->tag));
+
+		upiu->header.dword_1 = cpu_to_be32(UPIU_HEADER_DWORD(
+					UPIU_COMMAND_SET_TYPE_SCSI,
+					0,
+					0,
+					0));
+
+		/* Total EHS length and Data segment length will be zero */
+		upiu->header.dword_2 = 0;
+
+		upiu->exp_data_transfer_len =
+			cpu_to_be32(trcmd->scmd->sdb.length);
+
+		memcpy(upiu->cdb, trcmd->scmd->cmnd, min_t(unsigned short,
+					trcmd->scmd->cmd_len, MAX_CDB_SIZE));
+		trcmd->req_upiu = upiu;
+		break;
+	case UTP_CMD_TYPE_DEV_MANAGE:
+		/* For query function implementation */
+		break;
+	case UTP_CMD_TYPE_UFS:
+		/* For UFS native command implementation */
+		break;
+	}
+out:
+	return err;
+}
+
+/**
+ * ufs_scsi_queuecmd - Issue SCSI cdb to UFS device
+ * @shost: SCSI host of command to be sent
+ * @cmd: SCSI command to be sent
+ *
+ * Returns 0 for success, non-zero in case of failure
+ */
+int ufs_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
+{
+	struct ufs_tr_queue_cmd *trcmd;
+	struct ufs_hba *hba;
+	int err = 0;
+	int tag;
+
+	hba = shost ? shost_priv(shost) : NULL;
+	if (!hba || !scmd) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	tag  = scmd->request->tag;
+	if (!ufs_is_tag_valid(tag)) {
+		dev_err(hba->dev, "%s: Invalid tag\n", __func__);
+		err = -EINVAL;
+		goto out;
+	}
+
+	trcmd = hba->ops->get_tr_cmd(hba, tag);
+	if (IS_ERR_OR_NULL(trcmd)) {
+		err = trcmd ? PTR_ERR(trcmd) : -EBUSY;
+		dev_err(hba->dev, "%s: Unable to get cmd %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	err = ufs_fill_tr_cmd(scmd, trcmd);
+	if (err) {
+		dev_err(hba->dev, "%s: Unable to fill cmd %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	trcmd->hba = hba;
+
+	err = ufs_compose_upiu(trcmd);
+	if (err) {
+		dev_err(hba->dev, "%s: Unable to compose upiu %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	err = hba->ops->issue_tr_cmd(trcmd);
+	if (err) {
+		dev_err(hba->dev, "%s: Unable to issue cmd %d\n",
+				__func__, err);
+		scsi_dma_unmap(scmd);
+		goto out;
+	}
+
+out:
+	return err;
+}
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 139bc06..fa513e0 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -36,6 +36,7 @@
 #ifndef _UFS_H
 #define _UFS_H
 
+#define UFS_MAX_QUEUE	32
 #define MAX_CDB_SIZE	16
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
@@ -112,6 +113,7 @@ enum {
 
 enum {
 	MASK_SCSI_STATUS	= 0xFF,
+	MASK_TRANSFER_RESPONSE	= 0xFF00,
 	MASK_TASK_RESPONSE	= 0xFF00,
 	MASK_RSP_UPIU_RESULT	= 0xFFFF,
 };
@@ -124,6 +126,14 @@ enum {
 	UPIU_TASK_MANAGEMENT_FUNC_FAILED	= 0x05,
 	UPIU_INCORRECT_LOGICAL_UNIT_NO		= 0x09,
 };
+
+/* UFS command status in host layer */
+enum {
+	UFS_CMD_SUCCESS	= 0x0,
+	UFS_CMD_ABORTED	= 0x1,
+	UFS_CMD_ERROR	= 0x2,
+};
+
 /**
  * struct utp_upiu_header - UPIU header structure
  * @dword_0: UPIU header DW-0
@@ -194,4 +204,31 @@ struct utp_upiu_task_rsp {
 	u32 reserved[3];
 };
 
+/**
+ * struct ufs_tr_queue_cmd - UFS Transfer request command structure
+ * @hba: pointer to host adapter
+ * @scmd: pointer to scsi command
+ * @req_upiu: request UPIU structure
+ * @resp_upiu: response UPIU structure
+ * @command_type: SCSI, UFS, Query.
+ * @tag: Task tag of the command
+ * @lun: LUN of the command
+ * @done: transfer request completion function
+ */
+struct ufs_tr_queue_cmd {
+	struct utp_upiu_cmd *req_upiu;
+	struct utp_upiu_rsp *resp_upiu;
+	struct ufs_hba *hba;
+	struct scsi_cmnd *scmd;
+	int command_type;
+	int tag;
+	int dir;
+	int result;
+	unsigned int lun;
+	struct scatterlist *sgl;
+	int sg_segments;
+	int (*done)(struct ufs_tr_queue_cmd *);
+};
+
+extern int ufs_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd);
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c32a478..52a82fa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -202,34 +202,6 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
- * @ucd_rsp_ptr: pointer to response UPIU
- *
- * This function checks the response UPIU for valid transaction type in
- * response field
- * Returns 0 on success, non-zero on failure
- */
-static inline int
-ufshcd_is_valid_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
-{
-	return ((be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24) ==
-		 UPIU_TRANSACTION_RESPONSE) ? 0 : DID_ERROR << 16;
-}
-
-/**
- * ufshcd_get_rsp_upiu_result - Get the result from response UPIU
- * @ucd_rsp_ptr: pointer to response UPIU
- *
- * This function gets the response status and scsi_status from response UPIU
- * Returns the response result code.
- */
-static inline int
-ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
-{
-	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
-}
-
-/**
  * ufshcd_config_int_aggr - Configure interrupt aggregation values.
  *		Currently there is no use case where we want to configure
  *		interrupt aggregation dynamically. So to configure interrupt
@@ -309,18 +281,14 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 }
 
 /**
- * ufshcd_copy_sense_data - Copy sense data in case of check condition
+ * ufshcd_copy_resp_upiu - Copy response UPIU
  * @lrb - pointer to local reference block
  */
-static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
+static inline void ufshcd_copy_resp_upiu(struct ufshcd_lrb *lrbp)
 {
-	int len;
-	if (lrbp->sense_buffer) {
-		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
-		memcpy(lrbp->sense_buffer,
-			lrbp->ucd_rsp_ptr->sense_data,
-			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
-	}
+	struct ufs_tr_queue_cmd *trcmd = &lrbp->trcmd;
+
+	trcmd->resp_upiu = lrbp->ucd_rsp_ptr;
 }
 
 /**
@@ -363,30 +331,27 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
  * ufshcd_map_sg - Map scatter-gather list to prdt
  * @lrbp - pointer to local reference block
  *
- * Returns 0 in case of success, non-zero value in case of failure
  */
-static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
+static void ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 {
 	struct ufshcd_sg_entry *prd_table;
 	struct scatterlist *sg;
-	struct scsi_cmnd *cmd;
-	int sg_segments;
+	struct scatterlist *sgl;
+	int nsegs;
 	int i;
 
-	cmd = lrbp->cmd;
-	sg_segments = scsi_dma_map(cmd);
-	if (sg_segments < 0)
-		return sg_segments;
+	sgl = lrbp->trcmd.sgl;
+	nsegs = lrbp->trcmd.sg_segments;
 
-	if (sg_segments) {
+	if (nsegs) {
 		lrbp->utr_descriptor_ptr->prd_table_length =
-					cpu_to_le16((u16) (sg_segments));
+					cpu_to_le16((u16) (nsegs));
 
 		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
 
-		scsi_for_each_sg(cmd, sg, sg_segments, i) {
+		for_each_sg(sgl, sg, nsegs, i) {
 			prd_table[i].size  =
-				cpu_to_le32(((u32) sg_dma_len(sg))-1);
+				cpu_to_le32(((u32) sg_dma_len(sg)) - 1);
 			prd_table[i].base_addr =
 				cpu_to_le32(lower_32_bits(sg->dma_address));
 			prd_table[i].upper_addr =
@@ -395,8 +360,6 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 	} else {
 		lrbp->utr_descriptor_ptr->prd_table_length = 0;
 	}
-
-	return 0;
 }
 
 /**
@@ -423,118 +386,100 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
- * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * ufshcd_compose_utrd - form UFS transfer request descriptor
  * @lrb - pointer to local reference block
  */
-static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
+static int ufshcd_compose_utrd(struct ufshcd_lrb *lrbp)
 {
 	struct utp_transfer_req_desc *req_desc;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
-	u32 data_direction;
-	u32 upiu_flags;
+	struct ufs_tr_queue_cmd *trcmd = &lrbp->trcmd;
+	u32 dir = UTP_NO_DATA_TRANSFER;
+	u32 cmd_type = 0;
+	int err = 0;
 
-	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
 	req_desc = lrbp->utr_descriptor_ptr;
 
-	switch (lrbp->command_type) {
-	case UTP_CMD_TYPE_SCSI:
-		if (lrbp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
-			data_direction = UTP_DEVICE_TO_HOST;
-			upiu_flags = UPIU_CMD_FLAGS_READ;
-		} else if (lrbp->cmd->sc_data_direction == DMA_TO_DEVICE) {
-			data_direction = UTP_HOST_TO_DEVICE;
-			upiu_flags = UPIU_CMD_FLAGS_WRITE;
-		} else {
-			data_direction = UTP_NO_DATA_TRANSFER;
-			upiu_flags = UPIU_CMD_FLAGS_NONE;
-		}
+	if (trcmd->command_type == UTP_CMD_TYPE_SCSI) {
+		cmd_type = UTP_SCSI_COMMAND;
+	} else {
+		err = -EINVAL;
+		goto out;
+	}
 
-		/* Transfer request descriptor header fields */
-		req_desc->header.dword_0 =
-			cpu_to_le32(data_direction | UTP_SCSI_COMMAND);
+	if (trcmd->dir == DMA_FROM_DEVICE)
+		dir = UTP_DEVICE_TO_HOST;
+	else if (trcmd->dir == DMA_TO_DEVICE)
+		dir = UTP_HOST_TO_DEVICE;
 
-		/*
-		 * assigning invalid value for command status. Controller
-		 * updates OCS on command completion, with the command
-		 * status
-		 */
-		req_desc->header.dword_2 =
-			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+	/* Transfer request descriptor header fields */
+	req_desc->header.dword_0 = cpu_to_le32(dir | cmd_type);
 
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
-		break;
-	case UTP_CMD_TYPE_DEV_MANAGE:
-		/* For query function implementation */
-		break;
-	case UTP_CMD_TYPE_UFS:
-		/* For UFS native command implementation */
-		break;
-	} /* end of switch */
+	/*
+	 * assigning invalid value for command status. Controller
+	 * updates OCS on command completion, with the command
+	 * status
+	 */
+	req_desc->header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+out:
+	return err;
 }
 
 /**
- * ufshcd_queuecommand - main entry point for SCSI requests
- * @cmd: command from SCSI Midlayer
- * @done: call back function
- *
- * Returns 0 for success, non-zero in case of failure
+ * ufshcd_get_lun_qdepth - Get number of outstanding requests for a given LUN
+ * @trcmd: the transfer request queue command
+ * @lun: the lun in question
  */
-static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static int ufshcd_get_lun_qdepth(struct ufs_hba *hba, int lun)
 {
-	struct ufshcd_lrb *lrbp;
-	struct ufs_hba *hba;
-	unsigned long flags;
-	int tag;
-	int err = 0;
+	int i;
+	int lun_qdepth = 0;
 
-	hba = shost_priv(host);
+	/*
+	 * LUN queue depth can be obtained by counting outstanding commands
+	 * on the LUN.
+	 */
+	for (i = 0; i < hba->nutrs; i++) {
+		if (test_bit(i, &hba->outstanding_reqs)) {
+			if (hba->lrb[i].trcmd.lun == lun)
+				lun_qdepth++;
+		}
+	}
 
-	tag = cmd->request->tag;
+	return lun_qdepth;
+}
 
-	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
+static inline
+struct ufs_tr_queue_cmd *ufshcd_get_tr_cmd(struct ufs_hba *hba, int tag)
+{
+	struct ufshcd_lrb *lrbp;
 
 	lrbp = &hba->lrb[tag];
 
-	lrbp->cmd = cmd;
-	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
-	lrbp->sense_buffer = cmd->sense_buffer;
-	lrbp->task_tag = tag;
-	lrbp->lun = cmd->device->lun;
+	return lrbp ? &lrbp->trcmd : NULL;
+}
+
+static inline
+struct utp_upiu_cmd *ufshcd_get_tr_upiu(struct ufs_tr_queue_cmd *trcmd)
+{
+	struct ufshcd_lrb *lrbp = container_of(trcmd, struct ufshcd_lrb, trcmd);
 
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+	return lrbp->ucd_cmd_ptr;
+}
 
-	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(lrbp);
-	err = ufshcd_map_sg(lrbp);
+static int ufshcd_issue_tr_cmd(struct ufs_tr_queue_cmd *trcmd)
+{
+	struct ufshcd_lrb *lrbp = container_of(trcmd, struct ufshcd_lrb, trcmd);
+	struct ufs_hba *hba = trcmd->hba;
+	int tag = lrbp->trcmd.tag;
+	int err;
+	unsigned long flags;
+
+	err = ufshcd_compose_utrd(lrbp);
 	if (err)
 		goto out;
 
+	ufshcd_map_sg(lrbp);
+
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
@@ -1013,90 +958,6 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
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
- * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
- * @lrb: pointer to local reference block of completed command
- * @scsi_status: SCSI command status
- *
- * Returns value base on SCSI command status
- */
-static inline int
-ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
-{
-	int result = 0;
-
-	switch (scsi_status) {
-	case SAM_STAT_GOOD:
-		result |= DID_OK << 16 |
-			  COMMAND_COMPLETE << 8 |
-			  SAM_STAT_GOOD;
-		break;
-	case SAM_STAT_CHECK_CONDITION:
-		result |= DID_OK << 16 |
-			  COMMAND_COMPLETE << 8 |
-			  SAM_STAT_CHECK_CONDITION;
-		ufshcd_copy_sense_data(lrbp);
-		break;
-	case SAM_STAT_BUSY:
-		result |= SAM_STAT_BUSY;
-		break;
-	case SAM_STAT_TASK_SET_FULL:
-
-		/*
-		 * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
-		 * depth needs to be adjusted to the exact number of
-		 * outstanding commands the LUN can handle at any given time.
-		 */
-		ufshcd_adjust_lun_qdepth(lrbp->cmd);
-		result |= SAM_STAT_TASK_SET_FULL;
-		break;
-	case SAM_STAT_TASK_ABORTED:
-		result |= SAM_STAT_TASK_ABORTED;
-		break;
-	default:
-		result |= DID_ERROR << 16;
-		break;
-	} /* end of switch */
-
-	return result;
-}
-
-/**
  * ufshcd_transfer_rsp_status - Get overall status of the response
  * @hba: per adapter instance
  * @lrb: pointer to local reference block of completed command
@@ -1107,7 +968,6 @@ static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int result = 0;
-	int scsi_status;
 	int ocs;
 
 	/* overall command status of utrd */
@@ -1115,30 +975,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	switch (ocs) {
 	case OCS_SUCCESS:
-
-		/* check if the returned transfer response is valid */
-		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
-		if (result) {
-			dev_err(hba->dev,
-				"Invalid response = %x\n", result);
-			break;
-		}
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
+		result = UFS_CMD_SUCCESS;
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
+		result = UFS_CMD_ABORTED;
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -1147,7 +987,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_PEER_COMM_FAILURE:
 	case OCS_FATAL_ERROR:
 	default:
-		result |= DID_ERROR << 16;
+		result = UFS_CMD_ERROR;
 		dev_err(hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
@@ -1178,14 +1018,10 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 
 			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
 
-			if (lrb[index].cmd) {
-				scsi_dma_unmap(lrb[index].cmd);
-				lrb[index].cmd->result = result;
-				lrb[index].cmd->scsi_done(lrb[index].cmd);
-
-				/* Mark completed command as NULL in LRB */
-				lrb[index].cmd = NULL;
-			}
+			lrb[index].trcmd.result = result;
+			ufshcd_copy_resp_upiu(&lrb[index]);
+			if (lrb[index].trcmd.done)
+				lrb[index].trcmd.done(&lrb[index].trcmd);
 		} /* end of if */
 	} /* end of for */
 
@@ -1513,7 +1349,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
-	.queuecommand		= ufshcd_queuecommand,
+	.queuecommand		= ufs_scsi_queuecmd,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.eh_abort_handler	= ufshcd_abort,
@@ -1597,6 +1433,13 @@ void ufshcd_remove(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
+static const struct ufshcd_hba_ops hba_ops = {
+	.get_tr_cmd = ufshcd_get_tr_cmd,
+	.get_tr_upiu = ufshcd_get_tr_upiu,
+	.issue_tr_cmd = ufshcd_issue_tr_cmd,
+	.get_lun_qdepth = ufshcd_get_lun_qdepth,
+};
+
 /**
  * ufshcd_init - Driver initialization routine
  * @dev: pointer to device handle
@@ -1638,6 +1481,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	hba->dev = dev;
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
+	hba->ops = &hba_ops;
 
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6b99a42..712e1ad 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -113,8 +113,15 @@ struct ufshcd_lrb {
 	int command_type;
 	int task_tag;
 	unsigned int lun;
+	struct ufs_tr_queue_cmd trcmd;
 };
 
+struct ufshcd_hba_ops {
+	struct ufs_tr_queue_cmd *(*get_tr_cmd)(struct ufs_hba *, int);
+	struct utp_upiu_cmd *(*get_tr_upiu)(struct ufs_tr_queue_cmd *);
+	int (*issue_tr_cmd)(struct ufs_tr_queue_cmd *);
+	int (*get_lun_qdepth)(struct ufs_hba *, int);
+};
 
 /**
  * struct ufs_hba - per adapter private structure
@@ -184,6 +191,9 @@ struct ufs_hba {
 
 	/* HBA Errors */
 	u32 errors;
+
+	/* HBA operations */
+	const struct ufshcd_hba_ops *ops;
 };
 
 int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
