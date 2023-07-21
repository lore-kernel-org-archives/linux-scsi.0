Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC21C001DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjGUQDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjGUQCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:02:36 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844C22D7F
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:31 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b8bd586086so15808095ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689955351; x=1690560151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCam48Zy12ubzkeKJVe9IPNcRK9PBBPRsiE2hWsbUYw=;
        b=fBVn4OTF2lOqqo4K+NBO8Ehy+y/5+qptPGOwkYYTYdSu6u4z8dMxuNB0Zulasz2E3V
         2tBzW4Ty/UB03kpe2z9BKJxBOALpVQEPC5SJjKU3xUV/6pOo2RcRWtNx54/iz/KIzwY6
         0hPKUffqyrCW1YrKNP3WovmXXyDKo0BcbPjazGUBUtMb/OAc7wFrMVB0JLQ8M1nrRnNq
         Td9cISRztstEe4GxzhkN2kbEjxe9t9Mk5e+No1D2Mt5wa7cgtrrMmwY9BOY1hOd1hzcK
         MrwvT3nYl31aEuWb7ID+G000GzU/Wd5zoXaQfbkU3yBQBsZjqWEFj2i35BJZsZa1eaLR
         AYLg==
X-Gm-Message-State: ABy/qLYWdhz6Vx48yRamFi5jxVsfMhWjIeBzSH95DDjV1k+W9czR1nKJ
        ZzOnBQBBYmjSVXxnVM65Ou0Ady9Mo8w=
X-Google-Smtp-Source: APBJJlF0CMxEXcZSeJHQCu95Ry5GWpTLa6nvq9z2efezK7p83bOklNCacTYT6WgTyf4CscSdwGnbSA==
X-Received: by 2002:a17:902:a986:b0:1b8:954c:1f6 with SMTP id bh6-20020a170902a98600b001b8954c01f6mr1950632plb.36.1689955350768;
        Fri, 21 Jul 2023 09:02:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5043:9124:70cb:43f9])
        by smtp.gmail.com with ESMTPSA id s24-20020a170902a51800b001b890b3bbb1sm3652298plq.211.2023.07.21.09.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:02:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 2/3] scsi: ufs: Fix residual handling
Date:   Fri, 21 Jul 2023 09:01:33 -0700
Message-ID: <20230721160154.874010-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230721160154.874010-1-bvanassche@acm.org>
References: <20230721160154.874010-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only call scsi_set_resid() in case of an underflow. Do not call
scsi_set_resid() in case of an overflow.

Cc: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 ++++++++++++++++---
 include/ufs/ufs.h         |  6 ++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e31242fe0518..b27372f9b488 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5241,12 +5241,25 @@ static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 			   struct cq_entry *cqe)
 {
+	bool overflow, underflow;
+	u8 upiu_flags;
 	int result = 0;
 	int scsi_status;
 	enum utp_ocs ocs;
-
-	scsi_set_resid(lrbp->cmd,
-		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
+	u32 resid;
+
+	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
+	overflow = upiu_flags & UPIU_RSP_FLAG_OVERFLOW;
+	underflow = upiu_flags & UPIU_RSP_FLAG_UNDERFLOW;
+	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
+	WARN_ON_ONCE(overflow && underflow);
+	WARN_ON_ONCE(!overflow && !underflow && resid);
+	/*
+	 * Test !overflow instead of underflow to support UFS devices that do
+	 * not set either flag.
+	 */
+	if (!overflow)
+		scsi_set_resid(lrbp->cmd, resid);
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8316e2408ac3..bee5ccc6e7ce 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -104,6 +104,12 @@ enum {
 	UPIU_CMD_FLAGS_READ	= 0x40,
 };
 
+/* UPIU response flags */
+enum {
+	UPIU_RSP_FLAG_UNDERFLOW	= 0x20,
+	UPIU_RSP_FLAG_OVERFLOW	= 0x40,
+};
+
 /* UPIU Task Attributes */
 enum {
 	UPIU_TASK_ATTR_SIMPLE	= 0x00,
