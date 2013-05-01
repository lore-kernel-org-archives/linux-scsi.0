From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V4] scsi: ufs: add support for query requests
Date: Wed,  1 May 2013 18:26:55 +0300
Message-ID: <1367422015-23651-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add support for sending UFS query requests through tagged command
queuing. This design allows queuing query requests in any open slot
along with other SCSI commands. In this way there is no need to
save a slot in the requests queue and decrease its size.

A query request is posing to a SCSI command to use native flow. But
unlike normal SCSI command flow, the data and response fields are
filled in UFS host data structure instead of passing as arguments
while queuing into SCSI mlqueue (mid-layer SCSI queue, the requests
from this queue are submitted to the device queue). As per specification
only one query request is allowed to be processed by device. Hence a
mutex lock for protecting data and response fields (hba->query.request and
hba->query.response) needs to be held while query request is in
progress.

The API for submitting a query request is ufs_query_request() in
ufshcd.c. This function is responsible for:
1. Obtaining the SCSI device from the host
2. Keeping the query mutex to prevent multiple queries
3. Storing the required data for sending a query request in ufs_hba
4. Queuing a SCSI vendor specific command to trigger a query request
   in the UFS driver.

The callers of ufs_query_request() are expected to fill the query
command data fields and are to provide an allocated response field
for the driver to fill response fields after request completion.

The request and response upiu is extended in a union to enable using the
same data structure, both for command upiu and query request upiu.

The query request flow is separated from the scsi command flow in:
1. Preparing the request
2. Validating response (error) codes
3. Copying data (only used for descriptor read/write query requests)
4. Copying response/sense

Data error can't be handled in the scsi command native flow. Hence,
we pass the code as without a change back to the submitting layer.

UPIU (UFS Protocol Information Unit) size is increased to 512 bytes
from 128. The UPIU header and the transaction specific fields (SCSI
command or Query Request OSF - Op-code Specific Fields) are 32 bytes
together, the rest is used to transfer extra request data (such as
descriptor in query requests). In order to accommodate the largest
descriptor in the UFS spec (256 bytes) we need to increase the UPIU
size.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
changes for v4:
- Removed un-necessary inline modifiers
- Fixed return values to SCSI layer on completion
changes for v3:
- Reworked validating response UPIU
- Removed redundant NULL pointer checks
changes for v2:
- Moved ufs_query_request to ufshcd.c and removed ufs_core.c
- Addressed Santosh's comments



diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 35faf24..82417d6 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -35,6 +35,7 @@
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller Driver Core"
 	depends on SCSI
+	default y
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 139bc06..086ff03 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -36,10 +36,20 @@
 #ifndef _UFS_H
 #define _UFS_H
 
+#include <linux/mutex.h>
+#include <linux/types.h>
+
 #define MAX_CDB_SIZE	16
+#define GENERAL_UPIU_REQUEST_SIZE 32
+#define UPIU_HEADER_DATA_SEGMENT_MAX_SIZE	((ALIGNED_UPIU_SIZE) - \
+					(GENERAL_UPIU_REQUEST_SIZE))
+#define QUERY_OSF_SIZE			((GENERAL_UPIU_REQUEST_SIZE) - \
+					(sizeof(struct utp_upiu_header)))
+#define UFS_QUERY_RESERVED_SCSI_CMD 0xCC
+#define UFS_QUERY_CMD_SIZE 10
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
-			((byte3 << 24) | (byte2 << 16) |\
+			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
 			 (byte1 << 8) | (byte0))
 
 /*
@@ -62,7 +72,7 @@ enum {
 	UPIU_TRANSACTION_COMMAND	= 0x01,
 	UPIU_TRANSACTION_DATA_OUT	= 0x02,
 	UPIU_TRANSACTION_TASK_REQ	= 0x04,
-	UPIU_TRANSACTION_QUERY_REQ	= 0x26,
+	UPIU_TRANSACTION_QUERY_REQ	= 0x16,
 };
 
 /* UTP UPIU Transaction Codes Target to Initiator */
@@ -73,6 +83,7 @@ enum {
 	UPIU_TRANSACTION_TASK_RSP	= 0x24,
 	UPIU_TRANSACTION_READY_XFER	= 0x31,
 	UPIU_TRANSACTION_QUERY_RSP	= 0x36,
+	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
 };
 
 /* UPIU Read/Write flags */
@@ -90,6 +101,12 @@ enum {
 	UPIU_TASK_ATTR_ACA	= 0x03,
 };
 
+/* UPIU Query request function */
+enum {
+	UPIU_QUERY_FUNC_STANDARD_READ_REQUEST = 0x01,
+	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST = 0x81,
+};
+
 /* UTP QUERY Transaction Specific Fields OpCode */
 enum {
 	UPIU_QUERY_OPCODE_NOP		= 0x0,
@@ -103,6 +120,21 @@ enum {
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
 };
 
+/* Query response result code */
+enum {
+	QUERY_RESULT_SUCCESS			= 0x00,
+	QUERY_RESULT_NOT_READABLE		= 0xF6,
+	QUERY_RESULT_NOT_WRITEABLE		= 0xF7,
+	QUERY_RESULT_ALREADY_WRITTEN		= 0xF8,
+	QUERY_RESULT_INVALID_LENGTH		= 0xF9,
+	QUERY_RESULT_INVALID_VALUE		= 0xFA,
+	QUERY_RESULT_INVALID_SELECTOR		= 0xFB,
+	QUERY_RESULT_INVALID_INDEX		= 0xFC,
+	QUERY_RESULT_INVALID_IDN		= 0xFD,
+	QUERY_RESULT_INVALID_OPCODE		= 0xFE,
+	QUERY_RESULT_GENERAL_FAILURE		= 0xFF,
+};
+
 /* UTP Transfer Request Command Type (CT) */
 enum {
 	UPIU_COMMAND_SET_TYPE_SCSI	= 0x0,
@@ -110,10 +142,17 @@ enum {
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
 	MASK_RSP_UPIU_RESULT	= 0xFFFF,
+	MASK_QUERY_DATA_SEG_LEN	= 0xFFFF,
 };
 
 /* Task management service response */
@@ -138,26 +177,59 @@ struct utp_upiu_header {
 
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
+ * struct utp_upiu_query - upiu request buffer structure for
+ * query request.
+ * @opcode: command to perform B-0
+ * @idn: a value that indicates the particular type of data B-1
+ * @index: Index to further identify data B-2
+ * @selector: Index to further identify data B-3
+ * @reserved_osf: spec reserved field B-4,5
+ * @length: number of descriptor bytes to read/write B-6,7
+ * @value: Attribute value to be written DW-6
+ * @reserved: spec reserved DW-7,8
+ */
+struct utp_upiu_query {
+	u8 opcode;
+	u8 idn;
+	u8 index;
+	u8 selector;
+	u16 reserved_osf;
+	u16 length;
+	u32 value;
+	u32 reserved[2];
+};
+
+/**
+ * struct utp_upiu_req - general upiu request structure
+ * @header:UPIU header structure DW-0 to DW-2
+ * @sc: fields structure for scsi command
+ * @qr: fields structure for query request
+ */
+struct utp_upiu_req {
+	struct utp_upiu_header header;
+	union {
+		struct utp_upiu_cmd sc;
+		struct utp_upiu_query qr;
+	};
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
@@ -165,6 +237,20 @@ struct utp_upiu_rsp {
 };
 
 /**
+ * struct utp_upiu_rsp - general upiu response structure
+ * @header: UPIU header structure DW-0 to DW-2
+ * @sc: fields structure for scsi command
+ * @qr: fields structure for query request
+ */
+struct utp_upiu_rsp {
+	struct utp_upiu_header header;
+	union {
+		struct utp_cmd_rsp sc;
+		struct utp_upiu_query qr;
+	};
+};
+
+/**
  * struct utp_upiu_task_req - Task request UPIU structure
  * @header - UPIU header structure DW0 to DW-2
  * @input_param1: Input parameter 1 DW-3
@@ -194,4 +280,24 @@ struct utp_upiu_task_rsp {
 	u32 reserved[3];
 };
 
+/**
+ * struct ufs_query_req - parameters for building a query request
+ * @query_func: UPIU header query function
+ * @upiu_req: the query request data
+ */
+struct ufs_query_req {
+	u8 query_func;
+	struct utp_upiu_query upiu_req;
+};
+
+/**
+ * struct ufs_query_resp - UPIU QUERY
+ * @response: device response code
+ * @upiu_res: query response data
+ */
+struct ufs_query_res {
+	u8 response;
+	struct utp_upiu_query upiu_res;
+};
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c32a478..c8fdc6b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -202,18 +202,13 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
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
@@ -316,14 +311,71 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
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
 
 /**
+ * ufshcd_query_to_cpu() - formats the received buffer in to the native cpu
+ * endian
+ * @response: upiu query response to convert
+ */
+static inline void ufshcd_query_to_cpu(struct utp_upiu_query *response)
+{
+	response->length = be16_to_cpu(response->length);
+	response->value = be32_to_cpu(response->value);
+}
+
+/**
+ * ufshcd_query_to_be() - formats the buffer before sending in to big endian
+ * @response: upiu query request to convert
+ */
+static inline void ufshcd_query_to_be(struct utp_upiu_query *request)
+{
+	request->length = cpu_to_be16(request->length);
+	request->value = cpu_to_be32(request->value);
+}
+
+/**
+ * ufshcd_copy_query_response() - Copy Query Response and descriptor
+ * @lrb - pointer to local reference block
+ * @query_res - pointer to the query result
+ */
+static
+void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufs_query_res *query_res = hba->query.response;
+
+	/* Get the UPIU response */
+	if (query_res) {
+		query_res->response = ufshcd_get_rsp_upiu_result(
+			lrbp->ucd_rsp_ptr) >> UPIU_RSP_CODE_OFFSET;
+
+		memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr,
+			QUERY_OSF_SIZE);
+		ufshcd_query_to_cpu(&query_res->upiu_res);
+	}
+
+	/* Get the descriptor */
+	if (hba->query.descriptor && lrbp->ucd_rsp_ptr->qr.opcode ==
+			UPIU_QUERY_OPCODE_READ_DESC) {
+		u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr +
+				GENERAL_UPIU_REQUEST_SIZE;
+		u16 len;
+
+		/* data segment length */
+		len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
+						MASK_QUERY_DATA_SEG_LEN;
+
+		memcpy(hba->query.descriptor, descp,
+			min_t(u16, len, UPIU_HEADER_DATA_SEGMENT_MAX_SIZE));
+	}
+}
+
+/**
  * ufshcd_hba_capabilities - Read controller capabilities
  * @hba: per adapter instance
  */
@@ -423,76 +475,159 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
- * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
- * @lrb - pointer to local reference block
+ * ufshcd_prepare_req_desc - Fills the requests header
+ * descriptor according to request
+ * lrbp: pointer to local reference block
+ * upiu_flags: flags required in the header
  */
-static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
+static void ufshcd_prepare_req_desc(struct ufshcd_lrb *lrbp, u32 *upiu_flags)
 {
-	struct utp_transfer_req_desc *req_desc;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
+	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
+	enum dma_data_direction cmd_dir =
+		lrbp->cmd->sc_data_direction;
 	u32 data_direction;
-	u32 upiu_flags;
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
 
-	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
-	req_desc = lrbp->utr_descriptor_ptr;
+	dword_0 = data_direction | (lrbp->command_type
+				<< UPIU_COMMAND_TYPE_OFFSET);
 
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
+	/* Transfer request descriptor header fields */
+	req_desc->header.dword_0 = cpu_to_le32(dword_0);
 
-		/* Transfer request descriptor header fields */
-		req_desc->header.dword_0 =
-			cpu_to_le32(data_direction | UTP_SCSI_COMMAND);
+	/*
+	 * assigning invalid value for command status. Controller
+	 * updates OCS on command completion, with the command
+	 * status
+	 */
+	req_desc->header.dword_2 =
+		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+}
 
-		/*
-		 * assigning invalid value for command status. Controller
-		 * updates OCS on command completion, with the command
-		 * status
-		 */
-		req_desc->header.dword_2 =
-			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+static inline bool ufshcd_is_query_req(struct ufshcd_lrb *lrbp)
+{
+	return lrbp->cmd ? lrbp->cmd->cmnd[0] == UFS_QUERY_RESERVED_SCSI_CMD :
+		false;
+}
 
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
+/**
+ * ufshcd_prepare_utp_query_req_upiu() - fills the utp_transfer_req_desc,
+ * for query requsts
+ * @hba: UFS hba
+ * @lrbp: local reference block pointer
+ * @upiu_flags: flags
+ */
+static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
+					struct ufshcd_lrb *lrbp,
+					u32 upiu_flags)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+	u16 len = hba->query.request->upiu_req.length;
+	u8 *descp = (u8 *)lrbp->ucd_req_ptr + GENERAL_UPIU_REQUEST_SIZE;
+
+	/* Query request header */
+	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+			UPIU_TRANSACTION_QUERY_REQ, upiu_flags,
+			lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+			0, hba->query.request->query_func, 0, 0);
+
+	/* Data segment length */
+	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
+			0, 0, len >> 8, (u8)len);
+
+	/* Copy the Query Request buffer as is */
+	memcpy(&lrbp->ucd_req_ptr->qr, &hba->query.request->upiu_req,
+			QUERY_OSF_SIZE);
+	ufshcd_query_to_be(&lrbp->ucd_req_ptr->qr);
+
+	/* Copy the Descriptor */
+	if (hba->query.descriptor != NULL && len > 0 &&
+		(hba->query.request->upiu_req.opcode ==
+					UPIU_QUERY_OPCODE_WRITE_DESC)) {
+		memcpy(descp, hba->query.descriptor,
+			min_t(u16, len, UPIU_HEADER_DATA_SEGMENT_MAX_SIZE));
+	}
+
+}
+
+/**
+ * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * @hba - UFS hba
+ * @lrb - pointer to local reference block
+ */
+static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	u32 upiu_flags;
+	int ret = 0;
+
+	switch (lrbp->command_type) {
+	case UTP_CMD_TYPE_SCSI:
 	case UTP_CMD_TYPE_DEV_MANAGE:
-		/* For query function implementation */
+		ufshcd_prepare_req_desc(lrbp, &upiu_flags);
+		if (lrbp->cmd && lrbp->command_type == UTP_CMD_TYPE_SCSI)
+			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+		else if (lrbp->cmd)
+			ufshcd_prepare_utp_query_req_upiu(hba, lrbp,
+								upiu_flags);
+		else {
+			dev_err(hba->dev, "%s: Invalid UPIU request\n",
+				__func__);
+			ret = -EINVAL;
+		}
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
@@ -527,10 +662,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = cmd->device->lun;
 
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+	if (ufshcd_is_query_req(lrbp))
+		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(lrbp);
+	ufshcd_compose_upiu(hba, lrbp);
 	err = ufshcd_map_sg(lrbp);
 	if (err)
 		goto out;
@@ -544,6 +682,110 @@ out:
 }
 
 /**
+ *  ufshcd_query_request() - Entry point for issuing query request to a
+ *  ufs device.
+ *  @hba: ufs driver context
+ *  @query: params for query request
+ *  @descriptor: buffer for sending/receiving descriptor
+ *  @response: pointer to a buffer that will contain the response code and
+ *           response upiu
+ *  @timeout: time limit for the command in seconds
+ *  @retries: number of times to try executing the command
+ *
+ *  The query request is submitted to the same request queue as the rest of
+ *  the scsi commands passed to the UFS controller. In order to use this
+ *  queue, we need to receive a tag, same as all other commands. The tags
+ *  are issued from the block layer. To simulate a request from the block
+ *  layer, we use the same interface as the SCSI layer does when it issues
+ *  commands not generated by users. To distinguish a query request from
+ *  the SCSI commands, we use a vendor specific unused SCSI command
+ *  op-code. This op-code is not part of the SCSI command subset used in
+ *  UFS. In such way it is easy to check the command in the driver and
+ *  handle it appropriately.
+ *
+ *  All necessary fields for issuing a query and receiving its response are
+ *  stored in the UFS hba struct. We can use this method since we know
+ *  there is only one active query request at all times.
+ *
+ *  The request that will pass to the device is stored in "query" argument
+ *  passed to this function, while the "response" argument (which is output
+ *  field) will hold the query response from the device along with the
+ *  response code.
+ */
+int ufshcd_query_request(struct ufs_hba *hba,
+			struct ufs_query_req *query,
+			u8 *descriptor,
+			struct ufs_query_res *response,
+			int timeout,
+			int retries)
+{
+	struct scsi_device *sdev;
+	u8 cmd[UFS_QUERY_CMD_SIZE] = {0};
+	int result;
+	bool sdev_lookup = true;
+
+	if (!hba || !query || !response) {
+		dev_err(hba->dev,
+			"%s: NULL pointer hba = %p, query = %p response = %p\n",
+			__func__, hba, query, response);
+		return -EINVAL;
+	}
+
+	/*
+	 * A SCSI command structure is composed from opcode at the
+	 * begining and 0 at the end.
+	 */
+	cmd[0] = UFS_QUERY_RESERVED_SCSI_CMD;
+
+	/* extracting the SCSI Device */
+	sdev = scsi_device_lookup(hba->host, 0, 0, 0);
+	if (!sdev) {
+		/**
+		 * There are some Query Requests that are sent during device
+		 * initialization, this happens before the scsi device was
+		 * initialized. If there is no scsi device, we generate a
+		 * temporary device to allow the Query Request flow.
+		 */
+		sdev_lookup = false;
+		sdev = scsi_get_host_dev(hba->host);
+	}
+
+	if (!sdev) {
+		dev_err(hba->dev, "%s: Could not fetch scsi device\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	mutex_lock(&hba->query.lock_ufs_query);
+	hba->query.request = query;
+	hba->query.descriptor = descriptor;
+	hba->query.response = response;
+
+	/* wait until request is completed */
+	result = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL,
+				timeout, retries, 0, NULL);
+	if (result) {
+		dev_err(hba->dev,
+			"%s: Query with opcode 0x%x, failed with result %d\n",
+			__func__, query->upiu_req.opcode, result);
+		result = -EIO;
+	}
+
+	hba->query.request = NULL;
+	hba->query.descriptor = NULL;
+	hba->query.response = NULL;
+	mutex_unlock(&hba->query.lock_ufs_query);
+
+	/* Releasing scsi device resource */
+	if (sdev_lookup)
+		scsi_device_put(sdev);
+	else
+		scsi_free_host_dev(sdev);
+
+	return result;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -677,8 +919,8 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le16(ALIGNED_UPIU_SIZE);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
-		hba->lrb[i].ucd_cmd_ptr =
-			(struct utp_upiu_cmd *)(cmd_descp + i);
+		hba->lrb[i].ucd_req_ptr =
+			(struct utp_upiu_req *)(cmd_descp + i);
 		hba->lrb[i].ucd_rsp_ptr =
 			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
 		hba->lrb[i].ucd_prdt_ptr =
@@ -1101,7 +1343,9 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
  * @hba: per adapter instance
  * @lrb: pointer to local reference block of completed command
  *
- * Returns result of the command to notify SCSI midlayer
+ * Returns result of the command to notify SCSI midlayer. In
+ * case of query request specific result, returns DID_OK, and
+ * the error will be handled by the dispatcher.
  */
 static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
@@ -1115,27 +1359,46 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
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
+		case UPIU_TRANSACTION_QUERY_RSP:
+			/*
+			 *  Return result = ok, since SCSI layer wouldn't
+			 *  know how to handle errors from query requests.
+			 *  The result is saved with the response so that
+			 *  the ufs_core layer will handle it.
+			 */
+			result = DID_OK << 16;
+			ufshcd_copy_query_response(hba, lrbp);
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
@@ -1364,10 +1627,10 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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
@@ -1670,6 +1933,9 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
+	/* Initialize mutex for query requests */
+	mutex_init(&hba->query.lock_ufs_query);
+
 	/* IRQ registration */
 	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6b99a42..336980b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -60,6 +60,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_device.h>
 
 #include "ufs.h"
 #include "ufshci.h"
@@ -88,7 +89,7 @@ struct uic_command {
 /**
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
- * @ucd_cmd_ptr: UCD address of the command
+ * @ucd_req_ptr: UCD address of the command
  * @ucd_rsp_ptr: Response UPIU address for this command
  * @ucd_prdt_ptr: PRDT address of the command
  * @cmd: pointer to SCSI command
@@ -101,7 +102,7 @@ struct uic_command {
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
-	struct utp_upiu_cmd *ucd_cmd_ptr;
+	struct utp_upiu_req *ucd_req_ptr;
 	struct utp_upiu_rsp *ucd_rsp_ptr;
 	struct ufshcd_sg_entry *ucd_prdt_ptr;
 
@@ -115,6 +116,19 @@ struct ufshcd_lrb {
 	unsigned int lun;
 };
 
+/**
+ * struct ufs_query - keeps the query request information
+ * @request: request upiu and function
+ * @descriptor: buffer for sending/receiving descriptor
+ * @response: response upiu and response
+ * @mutex: lock to allow one query at a time
+ */
+struct ufs_query {
+	struct ufs_query_req *request;
+	u8 *descriptor;
+	struct ufs_query_res *response;
+	struct mutex lock_ufs_query;
+};
 
 /**
  * struct ufs_hba - per adapter private structure
@@ -143,6 +157,7 @@ struct ufshcd_lrb {
  * @uic_workq: Work queue for UIC completion handling
  * @feh_workq: Work queue for fatal controller error handling
  * @errors: HBA errors
+ * @query: query request information
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -184,6 +199,9 @@ struct ufs_hba {
 
 	/* HBA Errors */
 	u32 errors;
+
+	/* Query Request */
+	struct ufs_query query;
 };
 
 int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0c16484..4a86247 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -39,7 +39,7 @@
 enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,
 	TASK_RSP_UPIU_SIZE_DWORDS	= 8,
-	ALIGNED_UPIU_SIZE		= 128,
+	ALIGNED_UPIU_SIZE		= 512,
 };
 
 /* UFSHCI Registers */
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
