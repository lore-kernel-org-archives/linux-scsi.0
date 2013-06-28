From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V2 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization
Date: Fri, 28 Jun 2013 23:26:19 +0530
Message-ID: <1372442179-20099-3-git-send-email-sthumma@codeaurora.org>
References: <1372442179-20099-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1372442179-20099-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, linux-arm-msm@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Dolev Raviv <draviv@codeaurora.org>

Allow UFS device to complete its initialization and accept
SCSI commands by setting fDeviceInit flag. The device may take
time for this operation and hence the host should poll until
fDeviceInit flag is toggled to zero. This step is mandated by
UFS device specification for device initialization completion.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h    |   88 +++++++++++++-
 drivers/scsi/ufs/ufshcd.c |  292 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |   14 ++
 drivers/scsi/ufs/ufshci.h |    2 +-
 4 files changed, 390 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 4737fad..5484c59 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -43,6 +43,8 @@
 #define GENERAL_UPIU_REQUEST_SIZE 32
 #define UPIU_HEADER_DATA_SEGMENT_MAX_SIZE	((ALIGNED_UPIU_SIZE) - \
 					(GENERAL_UPIU_REQUEST_SIZE))
+#define QUERY_OSF_SIZE			((GENERAL_UPIU_REQUEST_SIZE) - \
+					(sizeof(struct utp_upiu_header)))
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
 			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
@@ -68,7 +70,7 @@ enum {
 	UPIU_TRANSACTION_COMMAND	= 0x01,
 	UPIU_TRANSACTION_DATA_OUT	= 0x02,
 	UPIU_TRANSACTION_TASK_REQ	= 0x04,
-	UPIU_TRANSACTION_QUERY_REQ	= 0x26,
+	UPIU_TRANSACTION_QUERY_REQ	= 0x16,
 };
 
 /* UTP UPIU Transaction Codes Target to Initiator */
@@ -97,8 +99,19 @@ enum {
 	UPIU_TASK_ATTR_ACA	= 0x03,
 };
 
-/* UTP QUERY Transaction Specific Fields OpCode */
+/* UPIU Query request function */
 enum {
+	UPIU_QUERY_FUNC_STANDARD_READ_REQUEST = 0x01,
+	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST = 0x81,
+};
+
+/* Flag idn for Query Requests*/
+enum flag_idn {
+	QUERY_FLAG_IDN_FDEVICEINIT = 0x01,
+};
+
+/* UTP QUERY Transaction Specific Fields OpCode */
+enum query_opcode {
 	UPIU_QUERY_OPCODE_NOP		= 0x0,
 	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
 	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
@@ -110,6 +123,21 @@ enum {
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
@@ -127,6 +155,7 @@ enum {
 	MASK_SCSI_STATUS	= 0xFF,
 	MASK_TASK_RESPONSE	= 0xFF00,
 	MASK_RSP_UPIU_RESULT	= 0xFFFF,
+	MASK_QUERY_DATA_SEG_LEN	= 0xFFFF,
 };
 
 /* Task management service response */
@@ -160,13 +189,40 @@ struct utp_upiu_cmd {
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
  * struct utp_upiu_req - general upiu request structure
  * @header:UPIU header structure DW-0 to DW-2
  * @sc: fields structure for scsi command
+ * @qr: fields structure for query request
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
@@ -187,10 +243,14 @@ struct utp_cmd_rsp {
  * struct utp_upiu_rsp - general upiu response structure
  * @header: UPIU header structure DW-0 to DW-2
  * @sr: fields structure for scsi command
+ * @qr: fields structure for query request
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
@@ -223,4 +283,24 @@ struct utp_upiu_task_rsp {
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
index d613ae4..f8278be 100644
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
@@ -380,6 +388,63 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
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
+	struct ufs_query_res *query_res = hba->dev_cmd.query.response;
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
+	if (hba->dev_cmd.query.descriptor && lrbp->ucd_rsp_ptr->qr.opcode ==
+			UPIU_QUERY_OPCODE_READ_DESC) {
+		u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr +
+				GENERAL_UPIU_REQUEST_SIZE;
+		u16 len;
+
+		/* data segment length */
+		len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
+						MASK_QUERY_DATA_SEG_LEN;
+
+		memcpy(hba->dev_cmd.query.descriptor, descp,
+			min_t(u16, len, UPIU_HEADER_DATA_SEGMENT_MAX_SIZE));
+	}
+}
+
+/**
  * ufshcd_hba_capabilities - Read controller capabilities
  * @hba: per adapter instance
  */
@@ -661,6 +726,46 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
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
+					struct ufshcd_lrb *lrbp,
+					u32 upiu_flags)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+	u16 len = hba->dev_cmd.query.request->upiu_req.length;
+	u8 *descp = (u8 *)lrbp->ucd_req_ptr + GENERAL_UPIU_REQUEST_SIZE;
+
+	/* Query request header */
+	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+			UPIU_TRANSACTION_QUERY_REQ, upiu_flags,
+			lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+			0, hba->dev_cmd.query.request->query_func, 0, 0);
+
+	/* Data segment length */
+	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
+			0, 0, len >> 8, (u8)len);
+
+	/* Copy the Query Request buffer as is */
+	memcpy(&lrbp->ucd_req_ptr->qr, &hba->dev_cmd.query.request->upiu_req,
+			QUERY_OSF_SIZE);
+	ufshcd_query_to_be(&lrbp->ucd_req_ptr->qr);
+
+	/* Copy the Descriptor */
+	if ((hba->dev_cmd.query.descriptor != NULL) && (len > 0) &&
+		(hba->dev_cmd.query.request->upiu_req.opcode ==
+					UPIU_QUERY_OPCODE_WRITE_DESC)) {
+		memcpy(descp, hba->dev_cmd.query.descriptor,
+			min_t(u16, len, UPIU_HEADER_DATA_SEGMENT_MAX_SIZE));
+	}
+}
+
 static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
@@ -695,7 +800,10 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc(lrbp, &upiu_flags, DMA_NONE);
-		if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
+			ufshcd_prepare_utp_query_req_upiu(
+					hba, lrbp, upiu_flags);
+		else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
 			ufshcd_prepare_utp_nop_upiu(lrbp);
 		else
 			ret = -EINVAL;
@@ -863,6 +971,9 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 					__func__, resp);
 		}
 		break;
+	case UPIU_TRANSACTION_QUERY_RSP:
+		ufshcd_copy_query_response(hba, lrbp);
+		break;
 	case UPIU_TRANSACTION_REJECT_UPIU:
 		/* TODO: handle Reject UPIU Response */
 		err = -EPERM;
@@ -973,6 +1084,128 @@ out_put_tag:
 }
 
 /**
+ * ufshcd_query_request() - API for issuing query request to the device.
+ * @hba: ufs driver context
+ * @query: params for query request
+ * @descriptor: buffer for sending/receiving descriptor
+ * @retries: number of times to try executing the command
+ *
+ * All necessary fields for issuing a query and receiving its response
+ * are stored in the UFS hba struct. We can use this method since we know
+ * there is only one active query request or any device management command
+ * at all times.
+ */
+static int ufshcd_send_query_request(struct ufs_hba *hba,
+					struct ufs_query_req *query,
+					u8 *descriptor,
+					struct ufs_query_res *response)
+{
+	int ret;
+
+	BUG_ON(!hba);
+	if (!query || !response) {
+		dev_err(hba->dev,
+			"%s: NULL pointer query = %p, response = %p\n",
+			__func__, query, response);
+		return -EINVAL;
+	}
+
+	mutex_lock(&hba->dev_cmd.lock);
+	hba->dev_cmd.query.request = query;
+	hba->dev_cmd.query.response = response;
+	hba->dev_cmd.query.descriptor = descriptor;
+
+	ret = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
+					QUERY_REQ_TIMEOUT);
+
+	hba->dev_cmd.query.request = NULL;
+	hba->dev_cmd.query.response = NULL;
+	hba->dev_cmd.query.descriptor = NULL;
+	mutex_unlock(&hba->dev_cmd.lock);
+
+	return ret;
+}
+
+/**
+ * ufshcd_query_flag() - Helper function for composing flag query requests
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
+	struct ufs_query_req *query;
+	struct ufs_query_res *response;
+	int err = -ENOMEM;
+
+	query = kzalloc(sizeof(struct ufs_query_req), GFP_KERNEL);
+	if (!query) {
+		dev_err(hba->dev,
+			"%s: Failed allocating ufs_query_req instance\n",
+			__func__);
+		goto out_no_mem;
+	}
+	response = kzalloc(sizeof(struct ufs_query_res), GFP_KERNEL);
+	if (!response) {
+		dev_err(hba->dev,
+			"%s: Failed allocating ufs_query_res instance\n",
+			__func__);
+		goto out_free_query;
+	}
+
+	switch (opcode) {
+	case UPIU_QUERY_OPCODE_SET_FLAG:
+	case UPIU_QUERY_OPCODE_CLEAR_FLAG:
+	case UPIU_QUERY_OPCODE_TOGGLE_FLAG:
+		query->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
+		break;
+	case UPIU_QUERY_OPCODE_READ_FLAG:
+		query->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+		if (!flag_res) {
+			/* No dummy reads */
+			dev_err(hba->dev, "%s: Invalid argument for read request\n",
+					__func__);
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	default:
+		dev_err(hba->dev,
+			"%s: Expected query flag opcode but got = %d\n",
+			__func__, opcode);
+		err = -EINVAL;
+		goto out;
+	}
+	query->upiu_req.opcode = opcode;
+	query->upiu_req.idn = idn;
+
+	/* Send query request */
+	err = ufshcd_send_query_request(hba, query, NULL, response);
+
+	if (err) {
+		dev_err(hba->dev,
+			"%s: Sending flag query for idn %d failed, err = %d\n",
+			__func__, idn, err);
+		goto out;
+	}
+
+	if (flag_res)
+		*flag_res = (response->upiu_res.value &
+				MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
+
+out:
+	kfree(response);
+out_free_query:
+	kfree(query);
+out_no_mem:
+	return err;
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -1141,6 +1374,59 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_validate_device_init() - checks device readiness
+ * hba: per-adapter instance
+ *
+ * Set fDeviceInit flag, than, query the flag until the device clears the
+ * flag.
+ */
+static int ufshcd_validate_device_init(struct ufs_hba *hba)
+{
+	int i, retries, err = 0;
+	bool flag_res = 0;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* Set the fDeviceIntit flag */
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
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
+		retries = QUERY_REQ_RETRIES;
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
@@ -1993,6 +2279,10 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
+	ret = ufshcd_validate_device_init(hba);
+	if (ret)
+		goto out;
+
 	scsi_scan_host(hba->host);
 out:
 	return;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c750a90..c6aeb6d 100644
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
+	struct ufs_query_req *request;
+	u8 *descriptor;
+	struct ufs_query_res *response;
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
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
