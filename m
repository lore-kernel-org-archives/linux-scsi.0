Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B503FEB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGXU3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjGXU3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:29:07 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9518712C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:29:05 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6689430d803so2831154b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230545; x=1690835345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOAK7b+D21hI7x2VaqGsDnhtGGAKEfoxb0S5c0H7b+4=;
        b=fMLM2RwUYt6osMUuy+KkZMqG+MHLU9vb8oTyCWEa+piTTgS3sw3jlLR5cXRQZwkdjO
         LwfBuJncIZVBlohFxzkWC4xlJS1cXU2Xi+N/4DJr4IKjcie5AUorLh42SQics5hmaf+y
         nA7YRr+yvy6wk//NQ+u2ntBcEkgF0QzJDShPUZOQIAZJ+vytl/jDnaPJ8fEZIDpOeJ1x
         WTRl1hOYqvAlPhnw+SIpZgFjZTJEht13h8hvNE/7JHBJFteb3aJGgPC1PhP6OQzTFb2n
         A4KnwmbUWJE7hRcNe9RvDPJrYr4boqDs5FApLr4GEW2+aTMx8pFeMR0W/9ffcl9YL21u
         AjFQ==
X-Gm-Message-State: ABy/qLbpkMKtp7oFj8KZX7wJT7AvwzpLPk4/asWmoWE5Y/ArrX2JCLRe
        plDwJp2+Tup2aXuiRVf2H64=
X-Google-Smtp-Source: APBJJlHzv6X18JrsIwzmOqWkEVTPC4BGFhzYri7ZRw6CVQd0qG1DWgg4KjTOn86iTohIxpM10VUAwg==
X-Received: by 2002:a05:6a20:7486:b0:132:d029:e2d7 with SMTP id p6-20020a056a20748600b00132d029e2d7mr11827373pzd.55.1690230544885;
        Mon, 24 Jul 2023 13:29:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:29:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Eric Biggers <ebiggers@google.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Alice Chao <alice.chao@mediatek.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 11/12] scsi: ufs: Simplify transfer request header initialization
Date:   Mon, 24 Jul 2023 13:16:46 -0700
Message-ID: <20230724202024.3379114-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the code that initializes UTP transfer request headers easier to
read by using bitfields instead of __le32 where appropriate.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c       |  7 +--
 drivers/ufs/core/ufshcd-crypto.h | 20 ++++-----
 drivers/ufs/core/ufshcd.c        | 75 ++++++++++++++++++++++----------
 include/ufs/ufs.h                |  3 --
 include/ufs/ufshci.h             | 48 +++++++++++++-------
 5 files changed, 97 insertions(+), 56 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index a3d4ef8aa3b9..66a4e24484a3 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -558,12 +558,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
  */
 static void ufshcd_mcq_nullify_sqe(struct utp_transfer_req_desc *utrd)
 {
-	u32 dword_0;
-
-	dword_0 = le32_to_cpu(utrd->header.dword_0);
-	dword_0 &= ~UPIU_COMMAND_TYPE_MASK;
-	dword_0 |= FIELD_PREP(UPIU_COMMAND_TYPE_MASK, 0xF);
-	utrd->header.dword_0 = cpu_to_le32(dword_0);
+	utrd->header.command_type = 0xf;
 }
 
 /**
diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index 504cc841540b..be8596f20ba2 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -26,15 +26,15 @@ static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 }
 
 static inline void
-ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp, u32 *dword_0,
-				   u32 *dword_1, u32 *dword_3)
+ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp,
+				   struct request_desc_header *h)
 {
-	if (lrbp->crypto_key_slot >= 0) {
-		*dword_0 |= UTP_REQ_DESC_CRYPTO_ENABLE_CMD;
-		*dword_0 |= lrbp->crypto_key_slot;
-		*dword_1 = lower_32_bits(lrbp->data_unit_num);
-		*dword_3 = upper_32_bits(lrbp->data_unit_num);
-	}
+	if (lrbp->crypto_key_slot < 0)
+		return;
+	h->enable_crypto = 1;
+	h->cci = lrbp->crypto_key_slot;
+	h->dunl = cpu_to_le32(lower_32_bits(lrbp->data_unit_num));
+	h->dunu = cpu_to_le32(upper_32_bits(lrbp->data_unit_num));
 }
 
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
@@ -51,8 +51,8 @@ static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 					      struct ufshcd_lrb *lrbp) { }
 
 static inline void
-ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp, u32 *dword_0,
-				   u32 *dword_1, u32 *dword_3) { }
+ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp,
+				   struct request_desc_header *h) { }
 
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4348b0dfde29..84a6ad4c5550 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -794,7 +794,7 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp,
 	if (cqe)
 		return le32_to_cpu(cqe->status) & MASK_OCS;
 
-	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
+	return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
 }
 
 /**
@@ -2587,10 +2587,10 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp, u8 *upiu_flags,
 					enum dma_data_direction cmd_dir, int ehs_length)
 {
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
+	struct request_desc_header *h = &req_desc->header;
 	u32 data_direction;
-	u32 dword_0;
-	u32 dword_1 = 0;
-	u32 dword_3 = 0;
+
+	*h = (typeof(*h)){ };
 
 	if (cmd_dir == DMA_FROM_DEVICE) {
 		data_direction = UTP_DEVICE_TO_HOST;
@@ -2603,25 +2603,22 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp, u8 *upiu_flags,
 		*upiu_flags = UPIU_CMD_FLAGS_NONE;
 	}
 
-	dword_0 = data_direction | (lrbp->command_type << UPIU_COMMAND_TYPE_OFFSET) |
-		ehs_length << 8;
+	h->command_type = lrbp->command_type;
+	h->data_direction = data_direction;
+	h->ehs_length = ehs_length;
+
 	if (lrbp->intr_cmd)
-		dword_0 |= UTP_REQ_DESC_INT_CMD;
+		h->interrupt = 1;
 
 	/* Prepare crypto related dwords */
-	ufshcd_prepare_req_desc_hdr_crypto(lrbp, &dword_0, &dword_1, &dword_3);
+	ufshcd_prepare_req_desc_hdr_crypto(lrbp, h);
 
-	/* Transfer request descriptor header fields */
-	req_desc->header.dword_0 = cpu_to_le32(dword_0);
-	req_desc->header.dword_1 = cpu_to_le32(dword_1);
 	/*
 	 * assigning invalid value for command status. Controller
 	 * updates OCS on command completion, with the command
 	 * status
 	 */
-	req_desc->header.dword_2 =
-		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
-	req_desc->header.dword_3 = cpu_to_le32(dword_3);
+	h->ocs = OCS_INVALID_COMMAND_STATUS;
 
 	req_desc->prd_table_length = 0;
 }
@@ -5445,8 +5442,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		if (hba->dev_cmd.complete) {
 			if (cqe) {
 				ocs = le32_to_cpu(cqe->status) & MASK_OCS;
-				lrbp->utr_descriptor_ptr->header.dword_2 =
-					cpu_to_le32(ocs);
+				lrbp->utr_descriptor_ptr->header.ocs = ocs;
 			}
 			complete(hba->dev_cmd.complete);
 			ufshcd_clk_scaling_update_busy(hba);
@@ -7034,8 +7030,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	int err;
 
 	/* Configure task request descriptor */
-	treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
-	treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+	treq.header.interrupt = 1;
+	treq.header.ocs = OCS_INVALID_COMMAND_STATUS;
 
 	/* Configure task request UPIU */
 	treq.upiu_req.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
@@ -7053,7 +7049,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	if (err == -ETIMEDOUT)
 		return err;
 
-	ocs_value = le32_to_cpu(treq.header.dword_2) & MASK_OCS;
+	ocs_value = treq.header.ocs & MASK_OCS;
 	if (ocs_value != OCS_SUCCESS)
 		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
 				__func__, ocs_value);
@@ -7213,8 +7209,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 
 		break;
 	case UPIU_TRANSACTION_TASK_REQ:
-		treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
-		treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+		treq.header.interrupt = 1;
+		treq.header.ocs = OCS_INVALID_COMMAND_STATUS;
 
 		memcpy(&treq.upiu_req, req_upiu, sizeof(*req_upiu));
 
@@ -7222,7 +7218,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		if (err == -ETIMEDOUT)
 			break;
 
-		ocs_value = le32_to_cpu(treq.header.dword_2) & MASK_OCS;
+		ocs_value = treq.header.ocs & MASK_OCS;
 		if (ocs_value != OCS_SUCCESS) {
 			dev_err(hba->dev, "%s: failed, ocs = 0x%x\n", __func__,
 				ocs_value);
@@ -10567,6 +10563,39 @@ static const struct dev_pm_ops ufshcd_wl_pm_ops = {
 	SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
 };
 
+static void ufshcd_check_header_layout(void)
+{
+	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
+				.cci = 3})[0] != 3);
+
+	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
+				.ehs_length = 2})[1] != 2);
+
+	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
+				.enable_crypto = 1})[2]
+		     != 0x80);
+
+	BUILD_BUG_ON((((u8 *)&(struct request_desc_header){
+					.command_type = 5,
+					.data_direction = 3,
+					.interrupt = 1,
+				})[3]) != ((5 << 4) | (3 << 1) | 1));
+
+	BUILD_BUG_ON(((__le32 *)&(struct request_desc_header){
+				.dunl = cpu_to_le32(0xdeadbeef)})[1] !=
+		cpu_to_le32(0xdeadbeef));
+
+	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
+				.ocs = 4})[8] != 4);
+
+	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
+				.cds = 5})[9] != 5);
+
+	BUILD_BUG_ON(((__le32 *)&(struct request_desc_header){
+				.dunu = cpu_to_le32(0xbadcafe)})[3] !=
+		cpu_to_le32(0xbadcafe));
+}
+
 /*
  * ufs_dev_wlun_template - describes ufs device wlun
  * ufs-device wlun - used to send pm commands
@@ -10592,6 +10621,8 @@ static int __init ufshcd_core_init(void)
 {
 	int ret;
 
+	ufshcd_check_header_layout();
+
 	ufs_debugfs_init();
 
 	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 20063a2f01a4..41a2b3d1e0d8 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -472,9 +472,6 @@ enum {
 	UPIU_COMMAND_SET_TYPE_QUERY	= 0x2,
 };
 
-/* UTP Transfer Request Command Offset */
-#define UPIU_COMMAND_TYPE_OFFSET	28
-
 /* Offset of the response code in the UPIU header */
 #define UPIU_RSP_CODE_OFFSET		8
 
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 4941ffb068ef..583155c7ef56 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -126,7 +126,6 @@ enum {
 };
 
 #define SQ_ICU_ERR_CODE_MASK		GENMASK(7, 4)
-#define UPIU_COMMAND_TYPE_MASK		GENMASK(31, 28)
 #define UFS_MASK(mask, offset)		((mask) << (offset))
 
 /* UFS Version 08h */
@@ -438,15 +437,13 @@ enum {
 	UTP_SCSI_COMMAND		= 0x00000000,
 	UTP_NATIVE_UFS_COMMAND		= 0x10000000,
 	UTP_DEVICE_MANAGEMENT_FUNCTION	= 0x20000000,
-	UTP_REQ_DESC_INT_CMD		= 0x01000000,
-	UTP_REQ_DESC_CRYPTO_ENABLE_CMD	= 0x00800000,
 };
 
 /* UTP Transfer Request Data Direction (DD) */
 enum {
-	UTP_NO_DATA_TRANSFER	= 0x00000000,
-	UTP_HOST_TO_DEVICE	= 0x02000000,
-	UTP_DEVICE_TO_HOST	= 0x04000000,
+	UTP_NO_DATA_TRANSFER	= 0,
+	UTP_HOST_TO_DEVICE	= 1,
+	UTP_DEVICE_TO_HOST	= 2,
 };
 
 /* Overall command status values */
@@ -505,17 +502,38 @@ struct utp_transfer_cmd_desc {
 
 /**
  * struct request_desc_header - Descriptor Header common to both UTRD and UTMRD
- * @dword0: Descriptor Header DW0
- * @dword1: Descriptor Header DW1
- * @dword2: Descriptor Header DW2
- * @dword3: Descriptor Header DW3
  */
 struct request_desc_header {
-	__le32 dword_0;
-	__le32 dword_1;
-	__le32 dword_2;
-	__le32 dword_3;
-};
+	u8 cci;
+	u8 ehs_length;
+#if defined(__BIG_ENDIAN)
+	u8 enable_crypto:1;
+	u8 reserved2:7;
+
+	u8 command_type:4;
+	u8 reserved1:1;
+	u8 data_direction:2;
+	u8 interrupt:1;
+#elif defined(__LITTLE_ENDIAN)
+	u8 reserved2:7;
+	u8 enable_crypto:1;
+
+	u8 interrupt:1;
+	u8 data_direction:2;
+	u8 reserved1:1;
+	u8 command_type:4;
+#else
+#error
+#endif
+
+	__le32 dunl;
+	u8 ocs;
+	u8 cds;
+	__le16 ldbc;
+	__le32 dunu;
+};
+
+static_assert(sizeof(struct request_desc_header) == 16);
 
 /**
  * struct utp_transfer_req_desc - UTP Transfer Request Descriptor (UTRD)
