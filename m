Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAB8C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272E36109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhDTAKL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:11 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:41503 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhDTAJz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:55 -0400
Received: by mail-pl1-f175.google.com with SMTP id e2so14366812plh.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUc8U2ftArdv73hIF2MA5A7z8Pvd/rAvL6Fang6y8uI=;
        b=jgVCl27owyN2J20khNgXqGQiZM4gIcQZhMqoVw+rTrNGOtPV3VxBYRdOWGig6OSNwN
         I/Kj2Y1QXGuANBHEMFv3wYIu/fJcp5ZlP7kJu1A37ol4dM6BSHfyWznSWOGcW5BRqmrm
         rzXsErN7onhtQLubwUQ32ZDsH25STIBKlOI/2kWS/jOva5UUSoseNcwI7aVeapdlvKBd
         anvTV2APeNXfuB49uBcQf4MKUyOxuH8YnPE2QXY7h3TWjVlgmXf79/xhcoNgPGWkvAsJ
         v4kMcPRBhyWtIL6CM9tUu7rzaKO3Ib/w4gifEoRkqN9+yuVCHbFNF2WPTOWYPr0Wbup9
         y16A==
X-Gm-Message-State: AOAM5327qUzVitlUqyeT/Lc/nGWNJ0ceEtivIoq37QtwJwrK+t7Z/Adf
        bI5WZ+l6MT0kQjPB766MkzFRKp3HuE/wZg==
X-Google-Smtp-Source: ABdhPJyZLpCm6NMrO5bpr9RXO0+narMCWbrhn/F0FRC7CCzP651DhMLDHQaADucC2a10elhIDQjTdg==
X-Received: by 2002:a17:90b:34b:: with SMTP id fh11mr1845435pjb.105.1618877364677;
        Mon, 19 Apr 2021 17:09:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>
Subject: [PATCH 028/117] aha*: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:16 -0700
Message-Id: <20210420000845.25873-29-bvanassche@acm.org>
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

Cc: "Juergen E. Fischer" <fischer@norbit.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 4 ++--
 drivers/scsi/aha1542.c | 4 ++--
 drivers/scsi/aha1740.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d8e19afa7a14..a1f5764d3577 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1281,7 +1281,7 @@ static void done(struct Scsi_Host *shpnt, int error)
 
 		DONE_SC = CURRENT_SC;
 		CURRENT_SC = NULL;
-		DONE_SC->result = error;
+		DONE_SC->status.combined = error;
 	} else
 		printk(KERN_ERR "aha152x: done() called outside of command\n");
 }
@@ -2254,7 +2254,7 @@ static void rsti_run(struct Scsi_Host *shpnt)
 			kfree(ptr->host_scribble);
 			ptr->host_scribble=NULL;
 
-			ptr->result =  DID_RESET << 16;
+			ptr->status.combined = DID_RESET << 16;
 			ptr->scsi_done(ptr);
 		}
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 21aab9f5b117..4d4864120f30 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -398,7 +398,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		if (errstatus)
 			printk("aha1542_intr_handle: returning %6x\n", errstatus);
 #endif
-		tmp_cmd->result = errstatus;
+		tmp_cmd->status.combined = errstatus;
 		aha1542->int_cmds[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
 						 * far as queuecommand is concerned
 						 */
@@ -422,7 +422,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
-		cmd->result = 0;
+		cmd->status.combined = 0;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 0dc831026e9e..a105599872e8 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -275,7 +275,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 			DEB(if (errstatus)
 			    printk("aha1740_intr_handle: returning %6x\n",
 				   errstatus));
-			SCtmp->result = errstatus;
+			SCtmp->status.combined = errstatus;
 			my_done = ecbptr->done;
 			memset(ecbptr,0,sizeof(struct ecb)); 
 			if ( my_done )
@@ -326,7 +326,7 @@ static int aha1740_queuecommand_lck(struct scsi_cmnd * SCpnt,
 	DEB(int i);
 
 	if(*cmd == REQUEST_SENSE) {
-		SCpnt->result = 0;
+		SCpnt->status.combined = 0;
 		done(SCpnt); 
 		return 0;
 	}
