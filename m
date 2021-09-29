Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17E1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C2B61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347163AbhI2WJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:37 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:42706 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbhI2WJc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:32 -0400
Received: by mail-pl1-f173.google.com with SMTP id l6so2519322plh.9
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RgGlM8P/QQlRdlbgU8H0YeA1POp4/CiTfwOXkTtPbSg=;
        b=m1+b3TtqONUGDQ5JxtfutMd27oSA4z+UKmKqSgx6ZGAx23jC4W5lUFSSiz4DBVRZI9
         zZAJYPF8efXy+qIV9+I/IztMIs3SRisLdk7xfLRs+qIuOCwEt3sKmKn9EHAPtMmlYX5Q
         MW2q9hH3HKaVBmyBC5fd8jdmU34/dbdFBuNjzq3VrGZ0y3c5K7fMMLESglJOFhFhSdSv
         4J8+BeDJZB2dY0DV1vG+dJnw5zBi/OW2nPhnfY1rh+D7PIsL18Meq5AA1YM3s1faWmfl
         6UR3uCusNEFwpVu1oeU9t8S8H28j8xmI30bFfE0CxFnXhcEnKlED0ZYE+iJUUdmvj5Yw
         E+5A==
X-Gm-Message-State: AOAM530RNsjS60idyEJrrNk6LkrV9/8nWfg3hEs/URAzaeBdN+hw68F2
        1TfPM8dLCvtl+KjPlC7HMgc=
X-Google-Smtp-Source: ABdhPJxgGPut767qbUOqKF8E1adhi8poPACYiTWrwP2kVYWIQeS7iudmpBc6vLj3Bv04rQdLMkp4mA==
X-Received: by 2002:a17:902:a3c1:b0:13a:47a:1c5a with SMTP id q1-20020a170902a3c100b0013a047a1c5amr779392plb.13.1632953270860;
        Wed, 29 Sep 2021 15:07:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 58/84] pcmcia: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:34 -0700
Message-Id: <20210929220600.3509089-59-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c       | 4 +---
 drivers/scsi/pcmcia/sym53c500_cs.c | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 7c0f931e55e8..0271d534133a 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -178,7 +178,7 @@ static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
 
 	data->CurrentSC = NULL;
 
-	SCpnt->scsi_done(SCpnt);
+	scsi_done(SCpnt);
 }
 
 static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
@@ -197,8 +197,6 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 		scsi_bufflen(SCpnt), scsi_sg_count(SCpnt));
 	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "before CurrentSC=0x%p", data->CurrentSC);
 
-	SCpnt->scsi_done	= done;
-
 	if (data->CurrentSC != NULL) {
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..d2adda815d7b 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -492,7 +492,7 @@ SYM53C500_intr(int irq, void *dev_id)
 
 idle_out:
 	curSC->SCp.phase = idle;
-	curSC->scsi_done(curSC);
+	scsi_done(curSC);
 	goto out;
 }
 
@@ -556,7 +556,6 @@ SYM53C500_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	VDEB(printk("\n"));
 
 	data->current_SC = SCpnt;
-	data->current_SC->scsi_done = done;
 	data->current_SC->SCp.phase = command_ph;
 	data->current_SC->SCp.Status = 0;
 	data->current_SC->SCp.Message = 0;
