Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787E4C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE8D610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344976AbhIRAJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:21 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35633 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbhIRAJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:09 -0400
Received: by mail-pl1-f177.google.com with SMTP id bb10so7240184plb.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h56QCgPf2uCu3KptNp50HCOmxx+b3YeaL9N0yvLZ6hw=;
        b=6w2UlS/lkmCnUvSZa4h3/rU5wZnT2txLeNKX4o6fLIxAp47jTx/hXL92bFjc6ITvsh
         wbuUMtqyq9FFqjLPAFBeQZ5SgTCg5Gr2UQQ0BHmOya8mjp2o25ZwXoifU+jv+7J/fLJf
         LmmXzW3aFs1V9j8JcS2zEi07KIHCc75Tcu2MRQhqqtOy5H0I672SG9lP3R2lPDRRXYj1
         xEjt7QrvOMVes8bdHvQgtoiHkdyoCzA89JB5/TcUzo7p0Fu1G6MzmkZr1MjB6ADUI90k
         uoijfKtqeMmlrUrsg0N3AZTTPWwcXQu/lwVpbv8uChZN8wlx6Xlcc2Ysx3UD9BqTqt8M
         DQpg==
X-Gm-Message-State: AOAM532FFTPun+KKvyUb2Qn9Ewkska7rxRtxMIAcM8jSyyM5oucFiE2v
        RZYp0TQSyfQSCw3v0wpSQ1k=
X-Google-Smtp-Source: ABdhPJyZX/x/PGKM2bY3rSgD0xLF86bA/InjrHvGLwG1PIFxFH3jdjk8TrG2Qn4tlK5PFoFd+ylVvw==
X-Received: by 2002:a17:90b:23d7:: with SMTP id md23mr15641346pjb.76.1631923666221;
        Fri, 17 Sep 2021 17:07:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 55/84] myrs: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:38 -0700
Message-Id: <20210918000607.450448-56-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
