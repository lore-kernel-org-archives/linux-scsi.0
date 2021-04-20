Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0F3C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CCA3613AE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhDTCOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:51 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:34795 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhDTCOq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:46 -0400
Received: by mail-pg1-f176.google.com with SMTP id z16so25557300pga.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=im6qXSZkvjMJRs29RklLPWv4PSomjWzB0ZubKwq62JU=;
        b=QKie+yyi/bIim/jL9zIVVGYnAMj/7HVYQawy2gSQMXKfw3eZVlHE5R2UL1GrC/SXJW
         0ZXl+ssOV5rbRE3CWS3zyg3puioGokynk7Rh6MkdqP1/SWVxYtMEMliX/6H4U9HMXLo9
         xnRWndoOOouq5XSo36pfn4ucsCJ6dbc03llQCImfadaDOhI/v75LNhGv/wYi8qY1BgHG
         AdNlS4pxQwJxkMfHVqaXmFMXnDJ7j6Kj+/rSE2y80wzzqm7wfedDNJvkRmbRh1P/fjIP
         ITui0VK0k44aL2vPS1F/UHHntY9E01NZaOFRijbAH6krWDvmQAXKuCBsqwD6YzXIoSkP
         K8HQ==
X-Gm-Message-State: AOAM533VOiHw0Mf5cguL0Wo/TjQNVADppaNaBN2XJ0YC0NRG9mLIMveu
        eYDZZPhgYPNxsiJh+MsvcRY=
X-Google-Smtp-Source: ABdhPJz0FV9GGrBxu51lHcg/6vIyFgq9OgCOi0PCVSbvgAe91LvM8cMbrX/WXOhmFHw9pF3YubPNJQ==
X-Received: by 2002:aa7:91d1:0:b029:1fe:2a02:73b9 with SMTP id z17-20020aa791d10000b02901fe2a0273b9mr22672647pfa.2.1618884855425;
        Mon, 19 Apr 2021 19:14:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 096/117] sym53c8xx_2: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:41 -0700
Message-Id: <20210420021402.27678-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..a4976becbff5 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -235,7 +235,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		cam_status = sym_xerr_cam_status(DID_ERROR, cp->xerr_status);
 	}
 	scsi_set_resid(cmd, resid);
-	cmd->result = (drv_status << 24) | (cam_status << 16) | scsi_status;
+	cmd->status.combined = (drv_status << 24) | (cam_status << 16) | scsi_status;
 }
 
 static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index 7d5c9b988b5b..65468fe6db0d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -224,8 +224,8 @@ static inline struct sym_hcb * sym_get_hcb(struct Scsi_Host *host)
 static inline void
 sym_set_cam_status(struct scsi_cmnd *cmd, int status)
 {
-	cmd->result &= ~(0xff  << 16);
-	cmd->result |= (status << 16);
+	cmd->status.combined &= ~(0xff  << 16);
+	cmd->status.combined |= (status << 16);
 }
 
 /*
@@ -234,7 +234,7 @@ sym_set_cam_status(struct scsi_cmnd *cmd, int status)
 static inline int
 sym_get_cam_status(struct scsi_cmnd *cmd)
 {
-	return host_byte(cmd->result);
+	return host_byte(cmd->status);
 }
 
 /*
@@ -243,7 +243,7 @@ sym_get_cam_status(struct scsi_cmnd *cmd)
 static inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
 {
 	scsi_set_resid(cmd, resid);
-	cmd->result = (DID_OK << 16) | (cp->ssss_status & 0x7f);
+	cmd->status.combined = (DID_OK << 16) | (cp->ssss_status & 0x7f);
 }
 void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid);
 
