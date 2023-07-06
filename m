Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF23BEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 21:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjGFVvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 17:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGFVvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 17:51:02 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E21BEE
        for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2023 14:51:01 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-666eb03457cso798593b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jul 2023 14:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688680261; x=1691272261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tvPlisZ7Pt2Orng9dXGSsoAS+S5+QpVuhnlaeSH9qLo=;
        b=mCF857RwW5CEpnYobpyL3M5zdp4tjkLuhwcndiYNbKS6HZVaZxtXIohe5WJG1kolug
         keMPyPLr9vk0P2xKNgMEBAQZlPOkyLp7xOpAsPaSRqSPqg8Hakqhrw9C89I/wBsznvQ2
         f5cerEs634hHm9ZoNknDPqTmOjQGYGDBi/V2tJbr528I9x6Lm+fyM9ospnavrn7fwptq
         cWpsQKzj1NuA08f4XwbD8xDxyQlbcgVTHagryWTeyI2Yswq/fy/CHCrKDwPGIAzruWa2
         o9kIBU3mka2ou2hHBbpmAzdXTKK2u2c7DDUfzjV/+fuzAKZ9T9I9sRyadxdWbb0p0OgM
         h7UA==
X-Gm-Message-State: ABy/qLZaK1MgoWinJ5ZLXmiyxv/KK5ORczY+VV7HcfrA+MCdcrRcCsF4
        nbq2Yhn3sdwT3+7CvznQVq8=
X-Google-Smtp-Source: APBJJlHvQFmZhXsBUML8rkyHYhWtSWktY/nrlrBRUXrVQhzu9D8lG1HFHU8zplTv3SJYXHeJxUvWGg==
X-Received: by 2002:a05:6a00:230b:b0:662:f0d0:a77d with SMTP id h11-20020a056a00230b00b00662f0d0a77dmr3126162pfh.30.1688680261006;
        Thu, 06 Jul 2023 14:51:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a75c:9545:5328:a233])
        by smtp.gmail.com with ESMTPSA id x1-20020a62fb01000000b00663b712bfbdsm1691024pfm.57.2023.07.06.14.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 14:51:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Markus Fuchs <mklntf@gmail.com>
Subject: [PATCH] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
Date:   Thu,  6 Jul 2023 14:50:24 -0700
Message-ID: <20230706215054.4113469-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This change reduces the number of parentheses that are required in the
definition of this function and also when using this function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++-------
 drivers/ufs/core/ufshpb.c |  2 +-
 include/ufs/ufs.h         |  8 +++++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 358b3240b6c5..384537511c7e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2637,10 +2637,10 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	unsigned short cdb_len;
 
 	/* command descriptor fields */
-	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+	ucd_req_ptr->header.dword_0 = upiu_header_dword(
 				UPIU_TRANSACTION_COMMAND, upiu_flags,
 				lrbp->lun, lrbp->task_tag);
-	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+	ucd_req_ptr->header.dword_1 = upiu_header_dword(
 				UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
 
 	/* Total EHS length and Data segment length will be zero */
@@ -2669,16 +2669,16 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	u16 len = be16_to_cpu(query->request.upiu_req.length);
 
 	/* Query request header */
-	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+	ucd_req_ptr->header.dword_0 = upiu_header_dword(
 			UPIU_TRANSACTION_QUERY_REQ, upiu_flags,
 			lrbp->lun, lrbp->task_tag);
-	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+	ucd_req_ptr->header.dword_1 = upiu_header_dword(
 			0, query->request.query_func, 0, 0);
 
 	/* Data segment length only need for WRITE_DESC */
 	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
 		ucd_req_ptr->header.dword_2 =
-			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
+			upiu_header_dword(0, 0, len >> 8, (u8)len);
 	else
 		ucd_req_ptr->header.dword_2 = 0;
 
@@ -2700,8 +2700,7 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
 
 	/* command descriptor fields */
-	ucd_req_ptr->header.dword_0 =
-		UPIU_HEADER_DWORD(
+	ucd_req_ptr->header.dword_0 = upiu_header_dword(
 			UPIU_TRANSACTION_NOP_OUT, 0, 0, lrbp->task_tag);
 	/* clear rest of the fields of basic header */
 	ucd_req_ptr->header.dword_1 = 0;
diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index 255f8b38d0c2..92398db10e33 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -121,7 +121,7 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
 {
 	/* Check HPB_UPDATE_ALERT */
 	if (!(lrbp->ucd_rsp_ptr->header.dword_2 &
-	      UPIU_HEADER_DWORD(0, 2, 0, 0)))
+	      upiu_header_dword(0, 2, 0, 0)))
 		return false;
 
 	if (be16_to_cpu(rsp_field->sense_data_len) != DEV_SENSE_SEG_LEN ||
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 4e8d6240e589..a2bc025a748e 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -23,9 +23,11 @@
 					(sizeof(struct utp_upiu_header)))
 #define UFS_SENSE_SIZE	18
 
-#define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
-			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
-			 (byte1 << 8) | (byte0))
+static inline __be32 upiu_header_dword(u8 byte3, u8 byte2, u8 byte1, u8 byte0)
+{
+	return cpu_to_be32(byte3 << 24 | byte2 << 16 | byte1 << 8 | byte0);
+}
+
 /*
  * UFS device may have standard LUs and LUN id could be from 0x00 to
  * 0x7F. Standard LUs use "Peripheral Device Addressing Format".
