Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7671C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15416103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhJGUdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:22 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34614 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242586AbhJGUdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:09 -0400
Received: by mail-pf1-f176.google.com with SMTP id g14so6326988pfm.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RgGlM8P/QQlRdlbgU8H0YeA1POp4/CiTfwOXkTtPbSg=;
        b=y3jftVhz8qHMbPy89WHbG2u/r7iudTP2F3IqoyHbOYvHH4tw1I6/AI4wEhfiZnxH9O
         FYsf4Xintqebg1VIzQsaQVFO1CbzB418h4Y/+GhdB9/+mq9dJH3DYd7ttuSsLhWMr8FF
         SBkriY9nkuI5N5iVH9h1TKRf4mnNpJHIFYgXI2LAqJWHJgTWEqHvQ1sL+cchr/vlZy/G
         qNyfaKZH2i9UxJeruZ4Leus4boGR0+lUjKk9JmbH2PgoRr79BibCqRFhWApUAr8ik+KZ
         6lhLF5TVt31PFeJ+hJvkRZFQ8RNnCs3vusZvJuI/pOQMFT1GxhVGNzKakyDURhCoBEBd
         N40Q==
X-Gm-Message-State: AOAM530ISqWSa4zpkzyeK6xjMXLsGkw0XYgKthFfuznB5o5XWnTgfre0
        ghYKPDA83hWz1HHjsK9vhvEiXBZ8s0I=
X-Google-Smtp-Source: ABdhPJz141iWSfUZaGFaoCbcXriNRzyaOx26CMl6iv+lo1M5mIF29I7srjwWHsn0QeZwdEexidXjdQ==
X-Received: by 2002:a63:4457:: with SMTP id t23mr1373299pgk.354.1633638674736;
        Thu, 07 Oct 2021 13:31:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 59/88] pcmcia: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:54 -0700
Message-Id: <20211007202923.2174984-60-bvanassche@acm.org>
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
