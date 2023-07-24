Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF53EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjGXU3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjGXU3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:29:46 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADE812C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:29:45 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6687466137bso2707777b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230585; x=1690835385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2kFUH5XnNnogeYX7NxCBvzFUm1UTmh7uv6JtjAPYLI=;
        b=cIHQCSa88MxQ5hECp4fRG9xMeLFo9vAqS4JVTahggH5eaOSWHrhjA6HvO3E1FRqgLt
         aZYu/EzzeyACoitLRzhpLTvCQXAtVPk+6Z5kBDEUdlvAKIPAq7o5/jHUNR+08NshCUsU
         gIlZiV//tYl8Jmq8J95d9bxwqBifFNvaHW4Seaeq1t/shdgRP2tvpcd0QRTN/am2NVAg
         BVjAojOu6wO/cugQqUf/KMgjN0+jfeC0k8otEO7HcQJKgQ9Z0f1gKtI0cgP8app97Fln
         hy+8Fx/BFc6sUrz/0puC+ktqGZprXlmyKHe1T7+aphoc2O4bKO7skV2GhwvQM8+IXCoG
         9XLw==
X-Gm-Message-State: ABy/qLb+WTJftJXVAh0xoN0zuDcIoyYmrIPHFU6UDJj8RxyMLNvtB5nu
        2l2+OzNCi93uYnE7P2rOFbQ=
X-Google-Smtp-Source: APBJJlFQl3uDeAjGQhiYr+8G90f+1UwS0qzTASueQYW9i6jKlel2oYb9JphE7ejh79mpZk/0Jyj20w==
X-Received: by 2002:a05:6a20:841a:b0:135:4858:681 with SMTP id c26-20020a056a20841a00b0013548580681mr10425725pzd.9.1690230584618;
        Mon, 24 Jul 2023 13:29:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:29:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 12/12] scsi: ufs: Simplify response header parsing
Date:   Mon, 24 Jul 2023 13:16:47 -0700
Message-ID: <20230724202024.3379114-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the code that parses UTP transfer request headers easier to read by
using u8 instead of __be32 where appropriate.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 89 +++++++++++----------------------------
 include/ufs/ufs.h         | 51 +++++++++++++++++++---
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  5 ++-
 4 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 84a6ad4c5550..f9fab40af83a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -332,13 +332,13 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
-	struct utp_upiu_header *header;
+	struct utp_upiu_hdr *header;
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
 	if (str_t == UFS_CMD_SEND)
-		header = &rq->header;
+		header = (struct utp_upiu_hdr *)&rq->header;
 	else
 		header = &hba->lrb[tag].ucd_rsp_ptr->header;
 
@@ -882,35 +882,7 @@ static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
 static inline enum upiu_response_transaction
 ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
 {
-	return be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24;
-}
-
-/**
- * ufshcd_get_rsp_upiu_result - Get the result from response UPIU
- * @ucd_rsp_ptr: pointer to response UPIU
- *
- * This function gets the response status and scsi_status from response UPIU
- *
- * Return: the response result code.
- */
-static inline int
-ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
-{
-	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
-}
-
-/*
- * ufshcd_get_rsp_upiu_data_seg_len - Get the data segment length
- *				from response UPIU
- * @ucd_rsp_ptr: pointer to response UPIU
- *
- * Return: the data segment length.
- */
-static inline unsigned int
-ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
-{
-	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
-		MASK_RSP_UPIU_DATA_SEG_LEN;
+	return ucd_rsp_ptr->header.transaction_code;
 }
 
 /**
@@ -924,8 +896,7 @@ ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
  */
 static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
 {
-	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
-			MASK_RSP_EXCEPTION_EVENT;
+	return ucd_rsp_ptr->header.device_information & 1;
 }
 
 /**
@@ -2227,7 +2198,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 	int len;
 
 	if (sense_buffer &&
-	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
+	    be16_to_cpu(lrbp->ucd_rsp_ptr->header.data_segment_length)) {
 		int len_to_copy;
 
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
@@ -2262,8 +2233,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		u16 buf_len;
 
 		/* data segment length */
-		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
-						MASK_QUERY_DATA_SEG_LEN;
+		resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
+				       .data_segment_length);
 		buf_len = be16_to_cpu(
 				hba->dev_cmd.query.request.upiu_req.length);
 		if (likely(buf_len >= resp_len)) {
@@ -3008,13 +2979,6 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 					mask, ~mask, 1000, 1000);
 }
 
-static int
-ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
-{
-	return ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
-				UPIU_RSP_CODE_OFFSET;
-}
-
 /**
  * ufshcd_dev_cmd_completion() - handles device management command responses
  * @hba: per adapter instance
@@ -3039,11 +3003,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 					__func__, resp);
 		}
 		break;
-	case UPIU_TRANSACTION_QUERY_RSP:
-		err = ufshcd_check_query_response(hba, lrbp);
-		if (!err)
+	case UPIU_TRANSACTION_QUERY_RSP: {
+		u8 response = lrbp->ucd_rsp_ptr->header.response;
+
+		if (response == 0)
 			err = ufshcd_copy_query_response(hba, lrbp);
 		break;
+	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
 		/* TODO: handle Reject UPIU Response */
 		err = -EPERM;
@@ -5244,7 +5210,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	u8 upiu_flags;
 	u32 resid;
 
-	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
+	upiu_flags = lrbp->ucd_rsp_ptr->header.flags;
 	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
 	/*
 	 * Test !overflow instead of underflow to support UFS devices that do
@@ -5257,8 +5223,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
-		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
-					MASK_RSP_UPIU_RESULT)
+		if (lrbp->ucd_rsp_ptr->header.response ||
+		    lrbp->ucd_rsp_ptr->header.status)
 			ocs = OCS_SUCCESS;
 	}
 
@@ -5267,17 +5233,11 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
 		case UPIU_TRANSACTION_RESPONSE:
-			/*
-			 * get the response UPIU result to extract
-			 * the SCSI command status
-			 */
-			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
-
 			/*
 			 * get the result based on SCSI status response
 			 * to notify the SCSI midlayer of the command status
 			 */
-			scsi_status = result & MASK_SCSI_STATUS;
+			scsi_status = lrbp->ucd_rsp_ptr->header.status;
 			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
 
 			/*
@@ -6967,7 +6927,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
 		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
-	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
+	treq->upiu_req.req_header.task_tag = task_tag;
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
@@ -7034,9 +6994,9 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	treq.header.ocs = OCS_INVALID_COMMAND_STATUS;
 
 	/* Configure task request UPIU */
-	treq.upiu_req.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
-				  cpu_to_be32(UPIU_TRANSACTION_TASK_REQ << 24);
-	treq.upiu_req.req_header.dword_1 = cpu_to_be32(tm_function << 16);
+	treq.upiu_req.req_header.transaction_code = UPIU_TRANSACTION_TASK_REQ;
+	treq.upiu_req.req_header.lun = lun_id;
+	treq.upiu_req.req_header.tm_function = tm_function;
 
 	/*
 	 * The host shall provide the same value for LUN field in the basic
@@ -7143,8 +7103,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
 	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
-		u16 resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
-			       MASK_QUERY_DATA_SEG_LEN;
+		u16 resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
+					   .data_segment_length);
 
 		if (*buff_len >= resp_len) {
 			memcpy(desc_buff, descp, resp_len);
@@ -7306,9 +7266,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 		/* Just copy the upiu response as it is */
 		memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
 		/* Get the response UPIU result */
-		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
+		result = (lrbp->ucd_rsp_ptr->header.response << 8) |
+			lrbp->ucd_rsp_ptr->header.status;
 
-		ehs_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) >> 24;
+		ehs_len = lrbp->ucd_rsp_ptr->header.ehs_length;
 		/*
 		 * Since the bLength in EHS indicates the total size of the EHS Header and EHS Data
 		 * in 32 Byte units, the value of the bLength Request/Response for Advanced RPMB
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 41a2b3d1e0d8..fb7f91603e58 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -476,12 +476,6 @@ enum {
 #define UPIU_RSP_CODE_OFFSET		8
 
 enum {
-	MASK_SCSI_STATUS		= 0xFF,
-	MASK_TASK_RESPONSE              = 0xFF00,
-	MASK_RSP_UPIU_RESULT            = 0xFFFF,
-	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
-	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
-	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
 	MASK_TM_SERVICE_RESP		= 0xFF,
 	MASK_TM_FUNC			= 0xFF,
 };
@@ -505,6 +499,49 @@ enum ufs_dev_pwr_mode {
 
 #define UFS_WB_BUF_REMAIN_PERCENT(val) ((val) / 10)
 
+/**
+ * struct utp_upiu_hdr - UFS UPIU header
+ * @transaction_code: Type of request or response. See also enum
+ *	upiu_request_transaction and enum upiu_response_transaction.
+ * @flags: UPIU flags. The meaning of individual flags depends on the
+ *	transaction code.
+ * @lun: Logical unit number.
+ * @task_tag: Task tag.
+ * @iid: Initiator ID.
+ * @command_set_type: 0 for SCSI command set; 1 for UFS specific.
+ * @tm_function: Task management function.
+ * @response: 0 for success; 1 for failure.
+ * @status: SCSI status if this is the header of a response to a SCSI command.
+ * @ehs_length: EHS length in units of 32 bytes.
+ * @device_information:
+ * @data_segment_length: data segment length.
+ *
+ * This data structure has the same role as struct utp_upiu_header.
+ */
+struct utp_upiu_hdr {
+	u8 transaction_code;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+#if defined(__BIG_ENDIAN)
+	u8 iid:4
+	u8 command_set_type:4;
+#elif defined(__LITTLE_ENDIAN)
+	u8 command_set_type:4;
+	u8 iid:4;
+#else
+#error
+#endif
+	u8 tm_function;
+	u8 response;
+	u8 status;
+	u8 ehs_length;
+	u8 device_information;
+	__be16 data_segment_length;
+};
+
+static_assert(sizeof(struct utp_upiu_hdr) == 12);
+
 /**
  * struct utp_cmd_rsp - Response UPIU structure
  * @residual_transfer_count: Residual transfer count DW-3
@@ -526,7 +563,7 @@ struct utp_cmd_rsp {
  * @qr: fields structure for query request DW-3 to DW-7
  */
 struct utp_upiu_rsp {
-	struct utp_upiu_header header;
+	struct utp_upiu_hdr header;
 	union {
 		struct utp_cmd_rsp sr;
 		struct utp_upiu_query qr;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bf4070a4b95f..002f075ed0a0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -19,6 +19,7 @@
 #include <linux/msi.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-direction.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <ufs/unipro.h>
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 583155c7ef56..5b760d538f15 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -12,6 +12,7 @@
 #define _UFSHCI_H
 
 #include <linux/types.h>
+#include <ufs/ufs.h>
 
 enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,
@@ -592,7 +593,7 @@ struct utp_task_req_desc {
 
 	/* DW 4-11 - Task request UPIU structure */
 	struct {
-		struct utp_upiu_header	req_header;
+		struct utp_upiu_hdr	req_header;
 		__be32			input_param1;
 		__be32			input_param2;
 		__be32			input_param3;
@@ -601,7 +602,7 @@ struct utp_task_req_desc {
 
 	/* DW 12-19 - Task Management Response UPIU structure */
 	struct {
-		struct utp_upiu_header	rsp_header;
+		struct utp_upiu_hdr	rsp_header;
 		__be32			output_param1;
 		__be32			output_param2;
 		__be32			__reserved2[3];
