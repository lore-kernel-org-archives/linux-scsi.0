Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6E2C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1614B61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhJGUdD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:03 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:36441 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242466AbhJGUdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:00 -0400
Received: by mail-pg1-f182.google.com with SMTP id 75so927691pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h56QCgPf2uCu3KptNp50HCOmxx+b3YeaL9N0yvLZ6hw=;
        b=xmiTi2sRxlHrfc9GWe4+kOIxwLOmoulmeTqEH++e0b5yngKgUjyAlX+F0Z4IKmcXmE
         96jz+JyofBb0rTOFyQwmeop4cVlLdxy2GFvlnhDcN24g29vpa7zAj1IfB+UXkuPA2WTu
         NqQi1PIIOF5Gx0OAJPDqMw4rjhJu8G26GVeZSTBuufvITt91OnmXso6tUiCVcrgKwIrl
         UX7ms31FMHWN/caBw3HtF+DU/gA4gM8yxAaCC+Q9+plm/oOtxJYS9KpnnKWRRgg7qk6E
         qnL+xC9A0oD75SuKqVf5ULjXFDL1Dl0VroZL8/tuHInTYA1bH5vSDtIBemrMYzarRKz0
         qxOg==
X-Gm-Message-State: AOAM533ViEQ7TmFpTGiZXO1DmUBj9Y3ZZvknZ9GqVNvdChvUYWR/O6C8
        KWUdMX5uRNa/Ow3pB6V2NLY=
X-Google-Smtp-Source: ABdhPJxET04iU713sIwOPx04efl/7QHU2ThBWMWSB9Gi3hsmzRni/tQrPuJYipq5wIb1MqUadzZRTQ==
X-Received: by 2002:a05:6a00:8c7:b0:44c:a7f9:d8d1 with SMTP id s7-20020a056a0008c700b0044ca7f9d8d1mr6170779pfu.49.1633638666106;
        Thu, 07 Oct 2021 13:31:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 55/88] myrs: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:50 -0700
Message-Id: <20211007202923.2174984-56-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..2ffe3cadda66 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1595,14 +1595,14 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 
 	if (!scmd->device->hostdata) {
 		scmd->result = (DID_NO_CONNECT << 16);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
 		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
 		if (scmd->device->channel >= cs->ctlr_info->physchan_present) {
@@ -1616,7 +1616,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 				myrs_mode_sense(cs, scmd, ldev_info);
 				scmd->result = (DID_OK << 16);
 			}
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 		break;
@@ -1756,7 +1756,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			if (WARN_ON(!hw_sgl)) {
 				scsi_dma_unmap(scmd);
 				scmd->result = (DID_ERROR << 16);
-				scmd->scsi_done(scmd);
+				scsi_done(scmd);
 				return 0;
 			}
 			hw_sgl->sge_addr = (u64)sg_dma_address(sgl);
@@ -2083,7 +2083,7 @@ static void myrs_handle_scsi(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk,
 		scmd->result = (DID_BAD_TARGET << 16);
 	else
 		scmd->result = (DID_OK << 16) | status;
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 }
 
 static void myrs_handle_cmdblk(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk)
