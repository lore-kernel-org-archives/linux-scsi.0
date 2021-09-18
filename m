Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9428C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95CFD610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbhIRAJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:02 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:46632 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbhIRAIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:45 -0400
Received: by mail-pj1-f48.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so8518600pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQERA3T4j1mewJlnCoSDIbhMa8LyGqwprFKISLrkUiY=;
        b=yoOL9D3qpbvCz/vQBwza7kglN+quWPEEg8nhC9iuB5uW9dWVfLndGncaO5Vf1DflA4
         vF8lGNb5UYSNa4CwyxfmsyMTasHRZwceF0ZT8rN6/4wcvZWfaOD+dEHCnGUlIRSUn3Zo
         HUaglMOrI8QQlUN39XwY6nQIBpygvgSOplsfOgLqeVgzlcHZuG4HJVaGcJmK8f01ikrX
         yiDXIg4KodzicIxIa+TvyUTyNTP9tr89HBu8IZlKSAOf27xPCDW5W+tY/bwBozUaCbvC
         uSoO+JAecrjM6bpAiHt31VtN/vfme+k70+5bbwO8tninxDpPNax7aa2ORTkwEiFWBktk
         /+Qg==
X-Gm-Message-State: AOAM531FHbgLTN2gWnOJhAUarjdsgLFR9lmDJBz9rfeAE3ET1czOhJCg
        Ij/1ljct+EEXvKlgjqhOfZh3LgFeqV3x1w==
X-Google-Smtp-Source: ABdhPJw3W/BHB1adcGWVupxlsLQHCseGWvyaRJUwBTAtOE6Mfi0si9dUnLzlG0R98KDchqggJldC7Q==
X-Received: by 2002:a17:90b:250e:: with SMTP id ns14mr15407378pjb.84.1631923642504;
        Fri, 17 Sep 2021 17:07:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 41/84] ipr: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:24 -0700
Message-Id: <20210918000607.450448-42-bvanassche@acm.org>
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
 drivers/scsi/ipr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..aa44216dcf9a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -866,7 +866,7 @@ static void __ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 	scsi_cmd->result |= (DID_ERROR << 16);
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6065,7 +6065,7 @@ static void __ipr_erp_done(struct ipr_cmnd *ipr_cmd)
 		res->in_erp = 0;
 	}
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6502,7 +6502,7 @@ static void ipr_erp_start(struct ipr_ioa_cfg *ioa_cfg,
 	}
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	if (ipr_cmd->eh_comp)
 		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6531,7 +6531,7 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
 		scsi_dma_unmap(scsi_cmd);
 
 		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		if (ipr_cmd->eh_comp)
 			complete(ipr_cmd->eh_comp);
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
@@ -6685,7 +6685,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
 	memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	scsi_cmd->result = (DID_NO_CONNECT << 16);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 	return 0;
 }
