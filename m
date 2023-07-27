Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BC6EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjG0Trd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjG0Trc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:47:32 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704B0273C
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:31 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3a04e5baffcso1131485b6e.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487250; x=1691092050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99f9Zmz7SfmPPbgOPeJRJXrn42bGx7gsE3vgZOY64KU=;
        b=atSXX2zKLoCKJTQRYQIdjuBf0fxO8aX0wD88PNR7Hk+n5DWAGY6VFiSKkmBr6ywoai
         1uKpuyJHsdsGirEw8dvdSlM/Jy81GfHlLEF+CPPk4oG5wiWyYYtEIjiz7IdaOZfvey7F
         TUlVprDGnkEfqaABRIsRFwsLdAJIANt2jeKCTS0fBq1PzRC8fFPI2E78ab/YGazKgzGJ
         eZHZyIF+pf0Yh3KTnL5zkusqYXKAdhvjijtrSOpCvdvYN/jHWfQT3QClyeC922O2E3//
         iXxnF0+rO812OpD/p2eeHELBNod6vSROmkJUeGQWkX2ZZDVAQ9IQwTuyAwUCUVEuVa30
         darA==
X-Gm-Message-State: ABy/qLaTUMJeJWYJKoHbcPZ4+tgQobtUDQ2bhTtthHa/niQs18tGlUhw
        rPKLRO86RQjC7N+I35XkJgA=
X-Google-Smtp-Source: APBJJlGQxi19hqaPatADZDUyPVkY8lv1v/+I34mXh4Y3bOzGfiChsDogTfyJYu5spOIB2SntR3zpwA==
X-Received: by 2002:a05:6808:1287:b0:3a3:6536:dd89 with SMTP id a7-20020a056808128700b003a36536dd89mr209077oiw.49.1690487250537;
        Thu, 27 Jul 2023 12:47:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:47:30 -0700 (PDT)
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
Subject: [PATCH v2 07/12] scsi: ufs: Improve type safety
Date:   Thu, 27 Jul 2023 12:41:19 -0700
Message-ID: <20230727194457.3152309-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
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
index 0fb733683953..797bf033c19a 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -78,7 +78,7 @@ enum {
 };
 
 /* UTP UPIU Transaction Codes Initiator to Target */
-enum {
+enum upiu_request_transaction {
 	UPIU_TRANSACTION_NOP_OUT	= 0x00,
 	UPIU_TRANSACTION_COMMAND	= 0x01,
 	UPIU_TRANSACTION_DATA_OUT	= 0x02,
@@ -87,7 +87,7 @@ enum {
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
