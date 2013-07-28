From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/9] scsi: ufs: Set fDeviceInit flag to initiate device initialization
Date: Sun, 28 Jul 2013 22:40:30 +0530
Message-ID: <1375031437-10206-3-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39178 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RLw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:11:52 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so3798590pbb.0
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:11:52 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Dolev Raviv <draviv@codeaurora.org>

Allow UFS device to complete its initialization and accept
SCSI commands by setting fDeviceInit flag. The device may take
time for this operation and hence the host should poll until
fDeviceInit flag is toggled to zero. This step is mandated by
UFS device specification for device initialization completion.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 51b5e3f..50d32f1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -40,6 +40,10 @@
 #include <linux/types.h>
 
 #define MAX_CDB_SIZE	16
+#define GENERAL_UPIU_REQUEST_SIZE 32
+#define QUERY_DESC_MAX_SIZE       256
+#define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
+					(sizeof(struct utp_upiu_header)))
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
 			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
@@ -65,7 +69,7 @@ enum {
 	UPIU_TRANSACTION_COMMAND	= 0x01,
 	UPIU_TRANSACTION_DATA_OUT	= 0x02,
 	UPIU_TRANSACTION_TASK_REQ	= 0x04,
-	UPIU_TRANSACTION_QUERY_REQ	= 0x26,
+	UPIU_TRANSACTION_QUERY_REQ	= 0x16,
 };
 
 /* UTP UPIU Transaction Codes Target to Initiator */
@@ -94,8 +98,19 @@ enum {
 	UPIU_TASK_ATTR_ACA	= 0x03,
 };
 
-/* UTP QUERY Transaction Specific Fields OpCode */
+/* UPIU Query request function */
 enum {
+	UPIU_QUERY_FUNC_STANDARD_READ_REQUEST           = 0x01,
+	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST          = 0x81,
+};
+
+/* Flag idn for Query Requests*/
+enum flag_idn {
+	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
+};
+
+/* UTP QUERY Transaction Specific Fields OpCode */
+enum query_opcode {
 	UPIU_QUERY_OPCODE_NOP		= 0x0,
 	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
 	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
@@ -107,6 +122,21 @@ enum {
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
 };
 
+/* Query response result code */
+enum {
+	QUERY_RESULT_SUCCESS                    = 0x00,
+	QUERY_RESULT_NOT_READABLE               = 0xF6,
+	QUERY_RESULT_NOT_WRITEABLE              = 0xF7,
+	QUERY_RESULT_ALREADY_WRITTEN            = 0xF8,
+	QUERY_RESULT_INVALID_LENGTH             = 0xF9,
+	QUERY_RESULT_INVALID_VALUE              = 0xFA,
+	QUERY_RESULT_INVALID_SELECTOR           = 0xFB,
+	QUERY_RESULT_INVALID_INDEX              = 0xFC,
+	QUERY_RESULT_INVALID_IDN                = 0xFD,
+	QUERY_RESULT_INVALID_OPCODE             = 0xFE,
+	QUERY_RESULT_GENERAL_FAILURE            = 0xFF,
+};
+
 /* UTP Transfer Request Command Type (CT) */
 enum {
 	UPIU_COMMAND_SET_TYPE_SCSI	= 0x0,
@@ -121,9 +151,10 @@ enum {
 #define UPIU_RSP_CODE_OFFSET		8
 
 enum {
-	MASK_SCSI_STATUS	= 0xFF,
-	MASK_TASK_RESPONSE	= 0xFF00,
-	MASK_RSP_UPIU_RESULT	= 0xFFFF,
+	MASK_SCSI_STATUS		= 0xFF,
+	MASK_TASK_RESPONSE              = 0xFF00,
+	MASK_RSP_UPIU_RESULT            = 0xFFFF,
+	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
 };
 
 /* Task management service response */
@@ -157,13 +188,40 @@ struct utp_upiu_cmd {
 };
 
 /**
+ * struct utp_upiu_query - upiu request buffer structure for
+ * query request.
+ * @opcode: command to perform B-0
+ * @idn: a value that indicates the particular type of data B-1
+ * @index: Index to further identify data B-2
+ * @selector: Index to further identify data B-3
+ * @reserved_osf: spec reserved field B-4,5
+ * @length: number of descriptor bytes to read/write B-6,7
+ * @value: Attribute value to be written DW-5
+ * @reserved: spec reserved DW-6,7
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
  * struct utp_upiu_req - general upiu request structure
  * @header:UPIU header structure DW-0 to DW-2
  * @sc: fields structure for scsi command DW-3 to DW-7
+ * @qr: fields structure for query request DW-3 to DW-7
  */
 struct utp_upiu_req {
 	struct utp_upiu_header header;
-	struct utp_upiu_cmd sc;
+	union {
+		struct utp_upiu_cmd sc;
+		struct utp_upiu_query qr;
+	};
 };
 
 /**
@@ -184,10 +242,14 @@ struct utp_cmd_rsp {
  * struct utp_upiu_rsp - general upiu response structure
  * @header: UPIU header structure DW-0 to DW-2
  * @sr: fields structure for scsi command DW-3 to DW-12
+ * @qr: fields structure for query request DW-3 to DW-7
  */
 struct utp_upiu_rsp {
 	struct utp_upiu_header header;
-	struct utp_cmd_rsp sr;
+	union {
+		struct utp_cmd_rsp sr;
+		struct utp_upiu_query qr;
+	};
 };
 
 /**
@@ -220,4 +282,24 @@ struct utp_upiu_task_rsp {
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
index ed20156..7b581f7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -48,6 +48,14 @@
 /* Timeout after 30 msecs if NOP OUT hangs without response */
 #define NOP_OUT_TIMEOUT    30 /* msecs */
 
+/* Query request retries */
+#define QUERY_REQ_RETRIES 10
+/* Query request timeout */
+#define QUERY_REQ_TIMEOUT 30 /* msec */
+
+/* Expose the flag value from utp_upiu_query.value */
+#define MASK_QUERY_UPIU_FLAG_LOC 0xFF
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -341,6 +349,60 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 }
 
 /**
+ * ufshcd_query_to_cpu() - formats the buffer to native cpu endian
+ * @response: upiu query response to convert
+ */
+static inline void ufshcd_query_to_cpu(struct utp_upiu_query *response)
+{
+	response->length = be16_to_cpu(response->length);
+	response->value = be32_to_cpu(response->value);
+}
+
+/**
+ * ufshcd_query_to_be() - formats the buffer to big endian
+ * @request: upiu query request to convert
+ */
+static inline void ufshcd_query_to_be(struct utp_upiu_query *request)
+{
+	request->length = cpu_to_be16(request->length);
+	request->value = cpu_to_be32(request->value);
+}
+
+/**
+ * ufshcd_copy_query_response() - Copy the Query Response and the data
+ * descriptor
+ * @hba: per adapter instance
+ * @lrb - pointer to local reference block
+ */
+static
+void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
+
+	/* Get the UPIU response */
+	query_res->response = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
+			UPIU_RSP_CODE_OFFSET;
+
+	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
+	ufshcd_query_to_cpu(&query_res->upiu_res);
+
+
+	/* Get the descriptor */
+	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
+		u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr +
+				GENERAL_UPIU_REQUEST_SIZE;
+		u16 len;
+
+		/* data segment length */
+		len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
+						MASK_QUERY_DATA_SEG_LEN;
+
+		memcpy(hba->dev_cmd.query.descriptor, descp,
+				min_t(u16, len, QUERY_DESC_MAX_SIZE));
+	}
+}
+
+/**
  * ufshcd_hba_capabilities - Read controller capabilities
  * @hba: per adapter instance
  */
@@ -622,6 +684,45 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 		(min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE)));
 }
 
+/**
+ * ufshcd_prepare_utp_query_req_upiu() - fills the utp_transfer_req_desc,
+ * for query requsts
+ * @hba: UFS hba
+ * @lrbp: local reference block pointer
+ * @upiu_flags: flags
+ */
+static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
+				struct ufshcd_lrb *lrbp, u32 upiu_flags)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+	struct ufs_query *query = &hba->dev_cmd.query;
+	u16 len = query->request.upiu_req.length;
+	u8 *descp = (u8 *)lrbp->ucd_req_ptr + GENERAL_UPIU_REQUEST_SIZE;
+
+	/* Query request header */
+	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+			UPIU_TRANSACTION_QUERY_REQ, upiu_flags,
+			lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+			0, query->request.query_func, 0, 0);
+
+	/* Data segment length */
+	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
+			0, 0, len >> 8, (u8)len);
+
+	/* Copy the Query Request buffer as is */
+	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
+			QUERY_OSF_SIZE);
+	ufshcd_query_to_be(&ucd_req_ptr->qr);
+
+	/* Copy the Descriptor */
+	if ((len > 0) && (query->request.upiu_req.opcode ==
+					UPIU_QUERY_OPCODE_WRITE_DESC)) {
+		memcpy(descp, query->descriptor,
+				min_t(u16, len, QUERY_DESC_MAX_SIZE));
+	}
+}
+
 static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
@@ -656,7 +757,10 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
-		if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
+			ufshcd_prepare_utp_query_req_upiu(
+					hba, lrbp, upiu_flags);
+		else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
 			ufshcd_prepare_utp_nop_upiu(lrbp);
 		else
 			ret = -EINVAL;
@@ -800,6 +904,9 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 					__func__, resp);
 		}
 		break;
+	case UPIU_TRANSACTION_QUERY_RSP:
+		ufshcd_copy_query_response(hba, lrbp);
+		break;
 	case UPIU_TRANSACTION_REJECT_UPIU:
 		/* TODO: handle Reject UPIU Response */
 		err = -EPERM;
@@ -889,8 +996,8 @@ static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
  * @cmd_type - specifies the type (NOP, Query...)
  * @timeout - time in seconds
  *
- * NOTE: There is only one available tag for device management commands. Thus
- * synchronisation is the responsibilty of the user.
+ * NOTE: Since there is only one available tag for device management commands,
+ * it is expected you hold the hba->dev_cmd.lock mutex.
  */
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
@@ -930,6 +1037,76 @@ out_put_tag:
 }
 
 /**
+ * ufshcd_query_flag() - API function for sending flag query requests
+ * hba: per-adapter instance
+ * query_opcode: flag query to perform
+ * idn: flag idn to access
+ * flag_res: the flag value after the query request completes
+ *
+ * Returns 0 for success, non-zero in case of failure
+ */
+static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
+			enum flag_idn idn, bool *flag_res)
+{
+	struct ufs_query_req *request;
+	struct ufs_query_res *response;
+	int err;
+
+	BUG_ON(!hba);
+
+	mutex_lock(&hba->dev_cmd.lock);
+	request = &hba->dev_cmd.query.request;
+	response = &hba->dev_cmd.query.response;
+	memset(request, 0, sizeof(struct ufs_query_req));
+	memset(response, 0, sizeof(struct ufs_query_res));
+
+	switch (opcode) {
+	case UPIU_QUERY_OPCODE_SET_FLAG:
+	case UPIU_QUERY_OPCODE_CLEAR_FLAG:
+	case UPIU_QUERY_OPCODE_TOGGLE_FLAG:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
+		break;
+	case UPIU_QUERY_OPCODE_READ_FLAG:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+		if (!flag_res) {
+			/* No dummy reads */
+			dev_err(hba->dev, "%s: Invalid argument for read request\n",
+					__func__);
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		break;
+	default:
+		dev_err(hba->dev,
+			"%s: Expected query flag opcode but got = %d\n",
+			__func__, opcode);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+	request->upiu_req.opcode = opcode;
+	request->upiu_req.idn = idn;
+
+	/* Send query request */
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
+			QUERY_REQ_TIMEOUT);
+
+	if (err) {
+		dev_err(hba->dev,
+			"%s: Sending flag query for idn %d failed, err = %d\n",
+			__func__, idn, err);
+		goto out_unlock;
+	}
+
+	if (flag_res)
+		*flag_res = (response->upiu_res.value &
+				MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
+
+out_unlock:
+	mutex_unlock(&hba->dev_cmd.lock);
+	return err;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -1099,6 +1276,57 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_complete_dev_init() - checks device readiness
+ * hba: per-adapter instance
+ *
+ * Set fDeviceInit flag and poll until device toggles it.
+ */
+static int ufshcd_complete_dev_init(struct ufs_hba *hba)
+{
+	int i, retries, err = 0;
+	bool flag_res = 1;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* Set the fDeviceInit flag */
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, NULL);
+		if (!err || err == -ETIMEDOUT)
+			break;
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+	}
+	if (err) {
+		dev_err(hba->dev,
+			"%s setting fDeviceInit flag failed with error %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	/* poll for max. 100 iterations for fDeviceInit flag to clear */
+	for (i = 0; i < 100 && !err && flag_res; i++) {
+		for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+			err = ufshcd_query_flag(hba,
+					UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
+			if (!err || err == -ETIMEDOUT)
+				break;
+			dev_dbg(hba->dev, "%s: error %d retrying\n", __func__,
+					err);
+		}
+	}
+	if (err)
+		dev_err(hba->dev,
+			"%s reading fDeviceInit flag failed with error %d\n",
+			__func__, err);
+	else if (flag_res)
+		dev_err(hba->dev,
+			"%s fDeviceInit was not cleared by the device\n",
+			__func__);
+
+out:
+	return err;
+}
+
+/**
  * ufshcd_make_hba_operational - Make UFS controller operational
  * @hba: per adapter instance
  *
@@ -1953,6 +2181,10 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
+	ret = ufshcd_complete_dev_init(hba);
+	if (ret)
+		goto out;
+
 	scsi_scan_host(hba->host);
 out:
 	return;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c750a90..6d6fdeb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -70,6 +70,7 @@
 
 enum dev_cmd_type {
 	DEV_CMD_TYPE_NOP		= 0x0,
+	DEV_CMD_TYPE_QUERY		= 0x1,
 };
 
 /**
@@ -125,6 +126,18 @@ struct ufshcd_lrb {
 };
 
 /**
+ * struct ufs_query - holds relevent data structures for query request
+ * @request: request upiu and function
+ * @descriptor: buffer for sending/receiving descriptor
+ * @response: response upiu and response
+ */
+struct ufs_query {
+	struct ufs_query_req request;
+	u8 *descriptor;
+	struct ufs_query_res response;
+};
+
+/**
  * struct ufs_dev_cmd - all assosiated fields with device management commands
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
@@ -136,6 +149,7 @@ struct ufs_dev_cmd {
 	struct mutex lock;
 	struct completion *complete;
 	wait_queue_head_t tag_wq;
+	struct ufs_query query;
 };
 
 /**
@@ -233,4 +247,10 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
 	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
 }
 
+static inline void check_upiu_size(void)
+{
+	BUILD_BUG_ON(ALIGNED_UPIU_SIZE <
+		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
+}
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d5c5f14..f1e1b74 100644
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
1.8.3.1

