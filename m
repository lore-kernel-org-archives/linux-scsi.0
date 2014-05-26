From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 1/6] scsi: ufs: fix endianness sparse warnings
Date: Mon, 26 May 2014 10:59:10 +0530
Message-ID: <1401082155-23184-2-git-send-email-sthumma@codeaurora.org>
References: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix many warnings with incorrect endian assumptions
which makes the code unportable to new architectures.

The UFS specification defines the byte order as big-endian
for UPIU structure and little-endian for the host controller
transfer/task management descriptors.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufs.h    | 36 ++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++----------------------------------
 drivers/scsi/ufs/ufshci.h | 32 ++++++++++++++++----------------
 3 files changed, 42 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 7210500..f42d1ce 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -196,9 +196,9 @@ enum {
  * @dword_2: UPIU header DW-2
  */
 struct utp_upiu_header {
-	u32 dword_0;
-	u32 dword_1;
-	u32 dword_2;
+	__be32 dword_0;
+	__be32 dword_1;
+	__be32 dword_2;
 };
 
 /**
@@ -207,7 +207,7 @@ struct utp_upiu_header {
  * @cdb: Command Descriptor Block CDB DW-4 to DW-7
  */
 struct utp_upiu_cmd {
-	u32 exp_data_transfer_len;
+	__be32 exp_data_transfer_len;
 	u8 cdb[MAX_CDB_SIZE];
 };
 
@@ -228,10 +228,10 @@ struct utp_upiu_query {
 	u8 idn;
 	u8 index;
 	u8 selector;
-	u16 reserved_osf;
-	u16 length;
-	u32 value;
-	u32 reserved[2];
+	__be16 reserved_osf;
+	__be16 length;
+	__be32 value;
+	__be32 reserved[2];
 };
 
 /**
@@ -256,9 +256,9 @@ struct utp_upiu_req {
  * @sense_data: Sense data field DW-8 to DW-12
  */
 struct utp_cmd_rsp {
-	u32 residual_transfer_count;
-	u32 reserved[4];
-	u16 sense_data_len;
+	__be32 residual_transfer_count;
+	__be32 reserved[4];
+	__be16 sense_data_len;
 	u8 sense_data[18];
 };
 
@@ -286,10 +286,10 @@ struct utp_upiu_rsp {
  */
 struct utp_upiu_task_req {
 	struct utp_upiu_header header;
-	u32 input_param1;
-	u32 input_param2;
-	u32 input_param3;
-	u32 reserved[2];
+	__be32 input_param1;
+	__be32 input_param2;
+	__be32 input_param3;
+	__be32 reserved[2];
 };
 
 /**
@@ -301,9 +301,9 @@ struct utp_upiu_task_req {
  */
 struct utp_upiu_task_rsp {
 	struct utp_upiu_header header;
-	u32 output_param1;
-	u32 output_param2;
-	u32 reserved[3];
+	__be32 output_param1;
+	__be32 output_param2;
+	__be32 reserved[3];
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 04884d6..064c9d9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -163,7 +163,7 @@ static inline int ufshcd_is_device_present(u32 reg_hcs)
  */
 static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 {
-	return lrbp->utr_descriptor_ptr->header.dword_2 & MASK_OCS;
+	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
 
 /**
@@ -176,7 +176,7 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 static inline int
 ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
 {
-	return task_req_descp->header.dword_2 & MASK_OCS;
+	return le32_to_cpu(task_req_descp->header.dword_2) & MASK_OCS;
 }
 
 /**
@@ -390,26 +390,6 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_query_to_cpu() - formats the buffer to native cpu endian
- * @response: upiu query response to convert
- */
-static inline void ufshcd_query_to_cpu(struct utp_upiu_query *response)
-{
-	response->length = be16_to_cpu(response->length);
-	response->value = be32_to_cpu(response->value);
-}
-
-/**
- * ufshcd_query_to_be() - formats the buffer to big endian
- * @request: upiu query request to convert
- */
-static inline void ufshcd_query_to_be(struct utp_upiu_query *request)
-{
-	request->length = cpu_to_be16(request->length);
-	request->value = cpu_to_be32(request->value);
-}
-
-/**
  * ufshcd_copy_query_response() - Copy the Query Response and the data
  * descriptor
  * @hba: per adapter instance
@@ -425,7 +405,6 @@ void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			UPIU_RSP_CODE_OFFSET;
 
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
-	ufshcd_query_to_cpu(&query_res->upiu_res);
 
 
 	/* Get the descriptor */
@@ -749,7 +728,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	struct ufs_query *query = &hba->dev_cmd.query;
-	u16 len = query->request.upiu_req.length;
+	u16 len = be16_to_cpu(query->request.upiu_req.length);
 	u8 *descp = (u8 *)lrbp->ucd_req_ptr + GENERAL_UPIU_REQUEST_SIZE;
 
 	/* Query request header */
@@ -766,7 +745,6 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	/* Copy the Query Request buffer as is */
 	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
 			QUERY_OSF_SIZE);
-	ufshcd_query_to_be(&ucd_req_ptr->qr);
 
 	/* Copy the Descriptor */
 	if ((len > 0) && (query->request.upiu_req.opcode ==
@@ -1151,7 +1129,7 @@ static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	}
 
 	if (flag_res)
-		*flag_res = (response->upiu_res.value &
+		*flag_res = (be32_to_cpu(response->upiu_res.value) &
 				MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
 
 out_unlock:
@@ -1195,7 +1173,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	switch (opcode) {
 	case UPIU_QUERY_OPCODE_WRITE_ATTR:
 		request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
-		request->upiu_req.value = *attr_val;
+		request->upiu_req.value = cpu_to_be32(*attr_val);
 		break;
 	case UPIU_QUERY_OPCODE_READ_ATTR:
 		request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
@@ -1222,7 +1200,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		goto out_unlock;
 	}
 
-	*attr_val = response->upiu_res.value;
+	*attr_val = be32_to_cpu(response->upiu_res.value);
 
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
@@ -2568,12 +2546,8 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	task_req_upiup->header.dword_1 =
 		UPIU_HEADER_DWORD(0, tm_function, 0, 0);
 
-	task_req_upiup->input_param1 = lrbp->lun;
-	task_req_upiup->input_param1 =
-		cpu_to_be32(task_req_upiup->input_param1);
-	task_req_upiup->input_param2 = lrbp->task_tag;
-	task_req_upiup->input_param2 =
-		cpu_to_be32(task_req_upiup->input_param2);
+	task_req_upiup->input_param1 = cpu_to_be32(lrbp->lun);
+	task_req_upiup->input_param2 = cpu_to_be32(lrbp->task_tag);
 
 	/* send command to the controller */
 	__set_bit(free_slot, &hba->outstanding_tasks);
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0475c66..9abc7e3 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -304,10 +304,10 @@ enum {
  * @size: size of physical segment DW-3
  */
 struct ufshcd_sg_entry {
-	u32    base_addr;
-	u32    upper_addr;
-	u32    reserved;
-	u32    size;
+	__le32    base_addr;
+	__le32    upper_addr;
+	__le32    reserved;
+	__le32    size;
 };
 
 /**
@@ -330,10 +330,10 @@ struct utp_transfer_cmd_desc {
  * @dword3: Descriptor Header DW3
  */
 struct request_desc_header {
-	u32 dword_0;
-	u32 dword_1;
-	u32 dword_2;
-	u32 dword_3;
+	__le32 dword_0;
+	__le32 dword_1;
+	__le32 dword_2;
+	__le32 dword_3;
 };
 
 /**
@@ -352,16 +352,16 @@ struct utp_transfer_req_desc {
 	struct request_desc_header header;
 
 	/* DW 4-5*/
-	u32  command_desc_base_addr_lo;
-	u32  command_desc_base_addr_hi;
+	__le32  command_desc_base_addr_lo;
+	__le32  command_desc_base_addr_hi;
 
 	/* DW 6 */
-	u16  response_upiu_length;
-	u16  response_upiu_offset;
+	__le16  response_upiu_length;
+	__le16  response_upiu_offset;
 
 	/* DW 7 */
-	u16  prd_table_length;
-	u16  prd_table_offset;
+	__le16  prd_table_length;
+	__le16  prd_table_offset;
 };
 
 /**
@@ -376,10 +376,10 @@ struct utp_task_req_desc {
 	struct request_desc_header header;
 
 	/* DW 4-11 */
-	u32 task_req_upiu[TASK_REQ_UPIU_SIZE_DWORDS];
+	__le32 task_req_upiu[TASK_REQ_UPIU_SIZE_DWORDS];
 
 	/* DW 12-19 */
-	u32 task_rsp_upiu[TASK_RSP_UPIU_SIZE_DWORDS];
+	__le32 task_rsp_upiu[TASK_RSP_UPIU_SIZE_DWORDS];
 };
 
 #endif /* End of Header */
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
