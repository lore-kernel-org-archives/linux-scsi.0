Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD93C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835F86103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbhJGUct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:49 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:45672 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242390AbhJGUcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:47 -0400
Received: by mail-pl1-f176.google.com with SMTP id n2so4640231plk.12
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygt+dWaafnpg+6+eXOTR14F/5++7Ta9sVTlI/vHYc08=;
        b=iKsrkwM7L6+o1RPsFFuUdS4M/hweLtMTcBy/XOTUxzEkOrZFrNwUy3eKsBczXVtkcy
         gPhE4/3Y752YNI5o9EafcYjffjUUF2FsLsMVySNrIQ33vLPdHm52thFLsTYgwCwekfO6
         aMzhDS7Tg2lO/OeUMx/HklhAdGVHBnXuLw0SuVZ81msc8dSZIr+FEKel3EbQlYrv7Uzx
         75nLgt26GiwwmgtuS2uLHKqejJpS3gZSENYXTiQF+LMeFKuOcy8rerFTEkShsuP398Ka
         En7qaEI97ewVYo9sQaEYJpFJfoFysQCmUqJHbNkWYiGuPNKGYjYwSnoscx/3e3PZr7n9
         BS2w==
X-Gm-Message-State: AOAM531ygjn/Z81SDs4e4gmPqnDZZJSFuLlsB/a04JIPY8d8iXiOHcVZ
        kqCIU82wa2awIYilgs8FwxI=
X-Google-Smtp-Source: ABdhPJylCH2+FGYFdNarUmXnDYn5h2aLt6de/oSgbIrd77YYsygx1ATJV50tiyuo0rDLuJB5ziBgQg==
X-Received: by 2002:a17:90b:1642:: with SMTP id il2mr7137278pjb.167.1633638653402;
        Thu, 07 Oct 2021 13:30:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 46/88] lpfc: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:41 -0700
Message-Id: <20211007202923.2174984-47-bvanassche@acm.org>
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
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 17e677cf8dcd..b005c6d39e16 100644
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
@@ -5843,7 +5843,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			     shost);
 
  out_fail_command:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
