Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03D1EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGXU1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjGXU1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:27:49 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97AB12C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:48 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-666e916b880so2769006b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230468; x=1690835268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HEvR+PYvaCh3prcpnLyz9kqawhcIRBBbKx385YlGLo=;
        b=HiulyL8gyhszuo4G2LuigRW76adTMpO0G+9H4QAv4HqVqKN3kqdAhSyX7ldTYmBwEs
         vAKXXyhk8/fqmzxQPLq9keS8dQ5NKETW76pLUlpNHK4HBNBNWqLiCZNJw4LFxP4metdG
         3HT6kQwqsMKgE2I+tfWF6xIGcn/jCIvOkq4pGq9HcIL0PpqWe8xfhTGtrPisO9u7BnHT
         WNDGGmTyZGvdJ0mLP1f4LUxXLDmRZ8sIuU5Sa56HTE7ZUoOurWyGyWNSoUzu/a4TNwqX
         YszmWrzB6rQGul+BYYzufXWbzhnwb97mEmy37mcNxFsYLvQ8BGZL5gy+dCq9I4XonAPf
         Txag==
X-Gm-Message-State: ABy/qLazhHrONFS8A95R0H60AaXJs64P6EzFmWj3rAY0BYuShuPwS65A
        lWfBNr0qEtiv2r9naKvMmYc=
X-Google-Smtp-Source: APBJJlErGEhAayItdy6BMDOB+4iR388ytCyAgEMmCHyIVwq8X40HknnHqi4k7/599s4KwUAcDtQ15g==
X-Received: by 2002:a05:6a20:198:b0:133:b3a9:90d with SMTP id 24-20020a056a20019800b00133b3a9090dmr7969959pzy.36.1690230468362;
        Mon, 24 Jul 2023 13:27:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:27:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [PATCH 07/12] scsi: ufs: Improve type safety
Date:   Mon, 24 Jul 2023 13:16:42 -0700
Message-ID: <20230724202024.3379114-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Assign names to the enumeration types for UPIU types. Use these
enumeration types where appropriate.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 2 +-
 drivers/ufs/core/ufshcd.c      | 9 ++++-----
 include/ufs/ufs.h              | 4 ++--
 include/ufs/ufshcd.h           | 6 ------
 4 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 4feccd5c1ba2..f42d99ce5bf1 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -93,7 +93,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
 			     struct utp_upiu_req *rsp_upiu,
-			     int msgcode,
+			     enum upiu_request_transaction msgcode,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e248c60f887..19c210ef74f5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -879,7 +879,7 @@ static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
  *
  * Return: UPIU type.
  */
-static inline int
+static inline enum upiu_response_transaction
 ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
 {
 	return be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24;
@@ -3032,7 +3032,7 @@ ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int
 ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	int resp;
+	enum upiu_response_transaction resp;
 	int err = 0;
 
 	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
@@ -5271,9 +5271,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 
 	switch (ocs) {
 	case OCS_SUCCESS:
-		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
 		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
-		switch (result) {
+		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
 		case UPIU_TRANSACTION_RESPONSE:
 			/*
 			 * get the response UPIU result to extract
@@ -7199,7 +7198,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
 			     struct utp_upiu_req *rsp_upiu,
-			     int msgcode,
+			     enum upiu_request_transaction msgcode,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op)
 {
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8d3187c83dcd..6ee7844b9670 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -77,7 +77,7 @@ enum {
 };
 
 /* UTP UPIU Transaction Codes Initiator to Target */
-enum {
+enum upiu_request_transaction {
 	UPIU_TRANSACTION_NOP_OUT	= 0x00,
 	UPIU_TRANSACTION_COMMAND	= 0x01,
 	UPIU_TRANSACTION_DATA_OUT	= 0x02,
@@ -86,7 +86,7 @@ enum {
 };
 
 /* UTP UPIU Transaction Codes Target to Initiator */
-enum {
+enum upiu_response_transaction {
 	UPIU_TRANSACTION_NOP_IN		= 0x20,
 	UPIU_TRANSACTION_RESPONSE	= 0x21,
 	UPIU_TRANSACTION_DATA_IN	= 0x22,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 67bd089e70bc..2b1f4f2a4464 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1357,12 +1357,6 @@ int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
-int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
-			     struct utp_upiu_req *req_upiu,
-			     struct utp_upiu_req *rsp_upiu,
-			     int msgcode,
-			     u8 *desc_buff, int *buff_len,
-			     enum query_opcode desc_op);
 int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *req_upiu,
 				     struct utp_upiu_req *rsp_upiu, struct ufs_ehs *ehs_req,
 				     struct ufs_ehs *ehs_rsp, int sg_cnt,
