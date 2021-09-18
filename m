Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BC6C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482EA60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbhIRAJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:08 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44864 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbhIRAI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:56 -0400
Received: by mail-pj1-f44.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso8526135pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZB60LWHAfkiS/kmf0g0evgkoAU3LFMVjB0yLlO/psCo=;
        b=KtZ9YjDmsHT67x2s2lrwSXzewLY9lDwuLlRXPChf7ktiFXDpYBZtvO0x9LgrkNfVg2
         PeQBgeOxftLuPzc+ZrX9EpWPlfn/ilu8fLcf06T5SerWJofLQrmIBM7N5z5OSKEHXEzH
         p19syr7HD0Ixct8lRhXXKJzKOQ4KTSWmcD3n3XAxZgY1EbTPMHwHjiVF4x89IrHkIQOY
         imy3GlpVv+dnGNgW2c7TmG3UUzktjpO9J9Pt+ptV/caa/lr5uKTWWGsgdlO8AKKv4wNb
         4U69oUAdPdolBKzReWLYQ2YMuvSV5MLidXEI2ijA85dWJ+tvezPNnCp4L8g71P+UgLX3
         H9PA==
X-Gm-Message-State: AOAM533AuTS0XD9z4K5ji8KISn8qW618SudayOSLdmAj25bZ+VbtEUN0
        Ljb4OZaI183p8GLdX3rWNg0=
X-Google-Smtp-Source: ABdhPJzJB/Assmo3hkrDViZQl8oE5XzG0DLCkl4EJUjgZxMz2SXLrgW3UfDinxP9pTKZWFMRGcs+AA==
X-Received: by 2002:a17:90b:1c09:: with SMTP id oc9mr8799049pjb.128.1631923653169;
        Fri, 17 Sep 2021 17:07:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 46/84] lpfc: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:29 -0700
Message-Id: <20210918000607.450448-47-bvanassche@acm.org>
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
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 078fbea3f436..ca604ae166c6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -564,7 +564,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				 * scsi_done upcall.
 				 */
 				if (cmd)
-					cmd->scsi_done(cmd);
+					scsi_done(cmd);
 
 				/*
 				 * We expect there is an abort thread waiting
@@ -4502,7 +4502,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		goto out;
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	/*
 	 * If there is an abort thread waiting for command completion
@@ -4771,7 +4771,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 #endif
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	/*
 	 * If there is an abort thread waiting for command completion
@@ -5847,7 +5847,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			     shost);
 
  out_fail_command:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
