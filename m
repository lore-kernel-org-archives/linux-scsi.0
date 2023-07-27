Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C3EC00528
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjG0TtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjG0TtL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:49:11 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF572D45
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:49:09 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-267fcd6985cso937006a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487349; x=1691092149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6FRZ3SqmP6RePALHs9uuKS1y6V1MePErm6g0fU1OETc=;
        b=HsGW5/NaGvWpj2Hu9zIfmWkO86IEjYCkUiRhyPzPaANLFiUXDz6ktkDPLmbRoVunOE
         xTelx04VSV438VKSm/QRR66Pxa3+G0gwYXyktTvgrY91LZqYwxOwthr1zG+M37ZpflX2
         mVZjH9R3LiaPnMhMRZjT9oLcQllzkmk7ZeeR1HOgkZe+AMcvSG6K7bqakfZ4IlJfvXKY
         opBE2/s9F4hh2oCj5p1jwc58t8bkaYvVlg5/4MhqNPSTCznJs2STltymhlRUuS7swpzd
         M/Aw4l4IE1sbb9Wk/E2KpvG89kd7JhCupKKAC0GcZ67IZXehEKgSasotfEzvSOqfivV8
         a30Q==
X-Gm-Message-State: ABy/qLalJygEcs09xJUy2ACn3w7UErM81iIQkEjKoonWZcstDHPHih26
        09Y9TbdqZM9hlCJ7nFVgHi0=
X-Google-Smtp-Source: APBJJlEC6/v1Am22RFgPDwknP9DHX38TuuXVFj8GLMD14y5QgixMrVvVqDEkk8qh84ZHvTieOyZnCA==
X-Received: by 2002:a17:90a:cb14:b0:268:71e4:ec2a with SMTP id z20-20020a17090acb1400b0026871e4ec2amr218334pjt.48.1690487348473;
        Thu, 27 Jul 2023 12:49:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:49:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 12/12] scsi: ufs: Simplify response header parsing
Date:   Thu, 27 Jul 2023 12:41:24 -0700
Message-ID: <20230727194457.3152309-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the code that parses UTP transfer request headers easier to read by
using u8 instead of __be32 where appropriate.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c        | 153 ++++++++++++-------------------
 include/uapi/scsi/scsi_bsg_ufs.h |  52 ++++++++++-
 include/ufs/ufs.h                |  18 ++--
 3 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b85c7a28fff5..2e669e64872c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
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
@@ -2224,10 +2195,11 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
 	u8 *const sense_buffer = lrbp->cmd->sense_buffer;
+	u16 resp_len;
 	int len;
 
-	if (sense_buffer &&
-	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
+	resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header.data_segment_length);
+	if (sense_buffer && resp_len) {
 		int len_to_copy;
 
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
@@ -2262,8 +2234,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		u16 buf_len;
 
 		/* data segment length */
-		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
-						MASK_QUERY_DATA_SEG_LEN;
+		resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
+				       .data_segment_length);
 		buf_len = be16_to_cpu(
 				hba->dev_cmd.query.request.upiu_req.length);
 		if (likely(buf_len >= resp_len)) {
@@ -2636,15 +2608,13 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
 
-	/* command descriptor fields */
-	ucd_req_ptr->header.dword_0 = upiu_header_dword(
-				UPIU_TRANSACTION_COMMAND, upiu_flags,
-				lrbp->lun, lrbp->task_tag);
-	ucd_req_ptr->header.dword_1 = upiu_header_dword(
-				UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
-
-	/* Total EHS length and Data segment length will be zero */
-	ucd_req_ptr->header.dword_2 = 0;
+	ucd_req_ptr->header = (struct utp_upiu_header){
+		.transaction_code = UPIU_TRANSACTION_COMMAND,
+		.flags = upiu_flags,
+		.lun = lrbp->lun,
+		.task_tag = lrbp->task_tag,
+		.command_set_type = UPIU_COMMAND_SET_TYPE_SCSI,
+	};
 
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
@@ -2669,18 +2639,19 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	u16 len = be16_to_cpu(query->request.upiu_req.length);
 
 	/* Query request header */
-	ucd_req_ptr->header.dword_0 = upiu_header_dword(
-			UPIU_TRANSACTION_QUERY_REQ, upiu_flags,
-			lrbp->lun, lrbp->task_tag);
-	ucd_req_ptr->header.dword_1 = upiu_header_dword(
-			0, query->request.query_func, 0, 0);
-
-	/* Data segment length only need for WRITE_DESC */
-	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
-		ucd_req_ptr->header.dword_2 =
-			upiu_header_dword(0, 0, len >> 8, (u8)len);
-	else
-		ucd_req_ptr->header.dword_2 = 0;
+	ucd_req_ptr->header = (struct utp_upiu_header){
+		.transaction_code = UPIU_TRANSACTION_QUERY_REQ,
+		.flags = upiu_flags,
+		.lun = lrbp->lun,
+		.task_tag = lrbp->task_tag,
+		.query_function = query->request.query_func,
+		/* Data segment length only need for WRITE_DESC */
+		.data_segment_length =
+			query->request.upiu_req.opcode ==
+					UPIU_QUERY_OPCODE_WRITE_DESC ?
+				cpu_to_be16(len) :
+				0,
+	};
 
 	/* Copy the Query Request buffer as is */
 	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
@@ -2699,12 +2670,10 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 
 	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
 
-	/* command descriptor fields */
-	ucd_req_ptr->header.dword_0 = upiu_header_dword(
-			UPIU_TRANSACTION_NOP_OUT, 0, 0, lrbp->task_tag);
-	/* clear rest of the fields of basic header */
-	ucd_req_ptr->header.dword_1 = 0;
-	ucd_req_ptr->header.dword_2 = 0;
+	ucd_req_ptr->header = (struct utp_upiu_header){
+		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
+		.task_tag = lrbp->task_tag,
+	};
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
@@ -3008,13 +2977,6 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
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
@@ -3039,11 +3001,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -5244,7 +5208,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	u8 upiu_flags;
 	u32 resid;
 
-	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
+	upiu_flags = lrbp->ucd_rsp_ptr->header.flags;
 	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
 	/*
 	 * Test !overflow instead of underflow to support UFS devices that do
@@ -5257,8 +5221,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
-		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
-					MASK_RSP_UPIU_RESULT)
+		if (lrbp->ucd_rsp_ptr->header.response ||
+		    lrbp->ucd_rsp_ptr->header.status)
 			ocs = OCS_SUCCESS;
 	}
 
@@ -5267,17 +5231,11 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
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
@@ -6967,7 +6925,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
 		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
-	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
+	treq->upiu_req.req_header.task_tag = task_tag;
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
@@ -7034,9 +6992,9 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
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
@@ -7110,7 +7068,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
 	/* update the task tag in the request upiu */
-	req_upiu->header.dword_0 |= cpu_to_be32(tag);
+	req_upiu->header.task_tag = tag;
 
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE, 0);
 
@@ -7143,8 +7101,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
 	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
-		u16 resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
-			       MASK_QUERY_DATA_SEG_LEN;
+		u16 resp_len = be16_to_cpu(lrbp->ucd_rsp_ptr->header
+					   .data_segment_length);
 
 		if (*buff_len >= resp_len) {
 			memcpy(desc_buff, descp, resp_len);
@@ -7192,7 +7150,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
 	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
-	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
+	u8 tm_f = req_upiu->header.tm_function;
 
 	switch (msgcode) {
 	case UPIU_TRANSACTION_NOP_OUT:
@@ -7284,7 +7242,9 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, dir, 2);
 
 	/* update the task tag and LUN in the request upiu */
-	req_upiu->header.dword_0 |= cpu_to_be32(upiu_flags << 16 | UFS_UPIU_RPMB_WLUN << 8 | tag);
+	req_upiu->header.flags = upiu_flags;
+	req_upiu->header.lun = UFS_UPIU_RPMB_WLUN;
+	req_upiu->header.task_tag = tag;
 
 	/* copy the UPIU(contains CDB) request as it is */
 	memcpy(lrbp->ucd_req_ptr, req_upiu, sizeof(*lrbp->ucd_req_ptr));
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
@@ -10594,6 +10555,12 @@ static void ufshcd_check_header_layout(void)
 	BUILD_BUG_ON(((__le32 *)&(struct request_desc_header){
 				.dunu = cpu_to_le32(0xbadcafe)})[3] !=
 		cpu_to_le32(0xbadcafe));
+
+	BUILD_BUG_ON(((u8 *)&(struct utp_upiu_header){
+			     .iid = 0xf })[4] != 0xf0);
+
+	BUILD_BUG_ON(((u8 *)&(struct utp_upiu_header){
+			     .command_set_type = 0xf })[4] != 0xf);
 }
 
 /*
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 2801b65299aa..bf1832dc35db 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -8,6 +8,7 @@
 #ifndef SCSI_BSG_UFS_H
 #define SCSI_BSG_UFS_H
 
+#include <asm/byteorder.h>
 #include <linux/types.h>
 /*
  * This file intended to be included by both kernel and user space
@@ -40,11 +41,56 @@ enum ufs_rpmb_op_type {
  * @dword_0: UPIU header DW-0
  * @dword_1: UPIU header DW-1
  * @dword_2: UPIU header DW-2
+ *
+ * @transaction_code: Type of request or response. See also enum
+ *	upiu_request_transaction and enum upiu_response_transaction.
+ * @flags: UPIU flags. The meaning of individual flags depends on the
+ *	transaction code.
+ * @lun: Logical unit number.
+ * @task_tag: Task tag.
+ * @iid: Initiator ID.
+ * @command_set_type: 0 for SCSI command set; 1 for UFS specific.
+ * @tm_function: Task management function in case of a task management request
+ *	UPIU.
+ * @query_function: Query function in case of a query request UPIU.
+ * @response: 0 for success; 1 for failure.
+ * @status: SCSI status if this is the header of a response to a SCSI command.
+ * @ehs_length: EHS length in units of 32 bytes.
+ * @device_information:
+ * @data_segment_length: data segment length.
  */
 struct utp_upiu_header {
-	__be32 dword_0;
-	__be32 dword_1;
-	__be32 dword_2;
+	union {
+		struct {
+			__be32 dword_0;
+			__be32 dword_1;
+			__be32 dword_2;
+		};
+		struct {
+			__u8 transaction_code;
+			__u8 flags;
+			__u8 lun;
+			__u8 task_tag;
+#if defined(__BIG_ENDIAN)
+			__u8 iid: 4;
+			__u8 command_set_type: 4;
+#elif defined(__LITTLE_ENDIAN)
+			__u8 command_set_type: 4;
+			__u8 iid: 4;
+#else
+#error
+#endif
+			union {
+				__u8 tm_function;
+				__u8 query_function;
+			};
+			__u8 response;
+			__u8 status;
+			__u8 ehs_length;
+			__u8 device_information;
+			__be16 data_segment_length;
+		};
+	};
 };
 
 /**
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 80fae9484807..3ebb677d993a 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -15,6 +15,12 @@
 #include <linux/types.h>
 #include <uapi/scsi/scsi_bsg_ufs.h>
 
+/*
+ * Using static_assert() is not allowed in UAPI header files. Hence the check
+ * in this header file of the size of struct utp_upiu_header.
+ */
+static_assert(sizeof(struct utp_upiu_header) == 12);
+
 #define GENERAL_UPIU_REQUEST_SIZE (sizeof(struct utp_upiu_req))
 #define QUERY_DESC_MAX_SIZE       255
 #define QUERY_DESC_MIN_SIZE       2
@@ -23,11 +29,6 @@
 					(sizeof(struct utp_upiu_header)))
 #define UFS_SENSE_SIZE	18
 
-static inline __be32 upiu_header_dword(u8 byte3, u8 byte2, u8 byte1, u8 byte0)
-{
-	return cpu_to_be32(byte3 << 24 | byte2 << 16 | byte1 << 8 | byte0);
-}
-
 /*
  * UFS device may have standard LUs and LUN id could be from 0x00 to
  * 0x7F. Standard LUs use "Peripheral Device Addressing Format".
@@ -477,14 +478,7 @@ enum {
 #define UPIU_RSP_CODE_OFFSET		8
 
 enum {
-	MASK_SCSI_STATUS		= 0xFF,
-	MASK_TASK_RESPONSE              = 0xFF00,
-	MASK_RSP_UPIU_RESULT            = 0xFFFF,
-	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
-	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
-	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
 	MASK_TM_SERVICE_RESP		= 0xFF,
-	MASK_TM_FUNC			= 0xFF,
 };
 
 /* Task management service response */
