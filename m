Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CEBC83F11
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Aug 2023 23:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjH0XbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Aug 2023 19:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjH0Xa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2023 19:30:58 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85157B5
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 16:30:56 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5654051b27fso1505618a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 16:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693179056; x=1693783856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KfcB2EjLa6hn2Z/ucindWXkOFvXoh4Xoo0OHxfZyCrI=;
        b=W+DP89FRnhVC0/rQ8Ctz3UNvN5z+A7iN20bYW6J0omYN8KN2OOBNfBBC0rV21amkX1
         FzGKCdU/lrhgg3s/wZVdaeW/SiZknEzrsBSLaFp6Dk/dCSp0xvJhXOd4U+CaP371YSaf
         AWQXL1lDcf1lbLFe1Y9cwNGFsOHPwtLy3+RBRfyaMc8AQ8s4qEAkCEep33BHfaUWO2xk
         aglMnpWjHooPAf5dZTTlgM3sfvjYC02qPPOYvmZIJqQAK4DzuJ0akSKrt4XIM+s3rs+V
         Y38MUIj60FP00MM0wpgyx3TZIk9TOpAF3kxTHSp7mDFQg4s9iCIdvaC/b44DSeSXpm3q
         lTvA==
X-Gm-Message-State: AOJu0YyWre6gb8w+9AHc5HOtdnGhSmbXl+c4bbcc6h2kQWRVKNs7G4yn
        6EtrhOKyowcVIk1PRci75jo=
X-Google-Smtp-Source: AGHT+IG/LtzjjpPOzNHc3qZuB1LSpKPna9NuAG3mosZ9UrDSgfNGnYX4GWhIU2C9/HzdUAftNRLoqA==
X-Received: by 2002:a05:6a21:790a:b0:14d:72e2:686a with SMTP id bg10-20020a056a21790a00b0014d72e2686amr2441768pzc.36.1693179055789;
        Sun, 27 Aug 2023 16:30:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id y1-20020aa78541000000b006879493aca0sm5371837pfn.26.2023.08.27.16.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 16:30:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Fix the build for big endian 32-bit ARM systems
Date:   Sun, 27 Aug 2023 16:30:35 -0700
Message-ID: <20230827233042.12945-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although it is not clear to me why, this patch fixes the following build
error for big endian 32-bit ARM systems:

include/linux/build_bug.h:78:41: error: static assertion failed: "sizeof(struct utp_upiu_header) == 12"

Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308251634.tuRn4OVv-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c        |  6 +++---
 include/uapi/scsi/scsi_bsg_ufs.h | 10 +++-------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 88daf5cb0fe6..e124f66b1f77 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2645,7 +2645,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 		.flags = upiu_flags,
 		.lun = lrbp->lun,
 		.task_tag = lrbp->task_tag,
-		.query_function = query->request.query_func,
+		.tm_or_query_function = query->request.query_func,
 		/* Data segment length only need for WRITE_DESC */
 		.data_segment_length =
 			query->request.upiu_req.opcode ==
@@ -7004,7 +7004,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	/* Configure task request UPIU */
 	treq.upiu_req.req_header.transaction_code = UPIU_TRANSACTION_TASK_REQ;
 	treq.upiu_req.req_header.lun = lun_id;
-	treq.upiu_req.req_header.tm_function = tm_function;
+	treq.upiu_req.req_header.tm_or_query_function = tm_function;
 
 	/*
 	 * The host shall provide the same value for LUN field in the basic
@@ -7160,7 +7160,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
 	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
-	u8 tm_f = req_upiu->header.tm_function;
+	u8 tm_f = req_upiu->header.tm_or_query_function;
 
 	switch (msgcode) {
 	case UPIU_TRANSACTION_NOP_OUT:
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index bf1832dc35db..165b8443bde8 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -50,9 +50,8 @@ enum ufs_rpmb_op_type {
  * @task_tag: Task tag.
  * @iid: Initiator ID.
  * @command_set_type: 0 for SCSI command set; 1 for UFS specific.
- * @tm_function: Task management function in case of a task management request
- *	UPIU.
- * @query_function: Query function in case of a query request UPIU.
+ * @tm_or_query_function: Task management function in case of a task management
+ *	request	UPIU; query function in case of a query request UPIU.
  * @response: 0 for success; 1 for failure.
  * @status: SCSI status if this is the header of a response to a SCSI command.
  * @ehs_length: EHS length in units of 32 bytes.
@@ -80,10 +79,7 @@ struct utp_upiu_header {
 #else
 #error
 #endif
-			union {
-				__u8 tm_function;
-				__u8 query_function;
-			};
+			__u8 tm_or_query_function;
 			__u8 response;
 			__u8 status;
 			__u8 ehs_length;
