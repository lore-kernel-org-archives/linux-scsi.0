Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8E2C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A758061168
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhEXDL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:26 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:34532 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhEXDL0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:26 -0400
Received: by mail-pl1-f176.google.com with SMTP id e15so7281935plh.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWCkbl9gtDCSQSGnzA3xMbegNxrAgeyKupcSi9N6TCY=;
        b=o1jq17EMTquNJVrHTMdhNuIFXiftA9879WMLAxoeThXGX9t+UpiKg9zYE0cq6B86b/
         9pzIZ8PgJWngK0i62CqvoFVAWGOJ8Iv94uIAvZf7iB6QPaLtCEfZxmEVAGruIi8C+0t4
         seoYfAOXQPENSIdhaYE2M3T/zXGSTp5IAyYsUeUzdTnRfsplqnYBZsfglfbOKMU70df3
         XxHh99E1zc7i/oRdZW8Bl5KNc7h3p2xTfKipVoDP2cnjF+WRMeMruSoKbQorf8a37lvX
         JBVzCXQ3c6L5L2m1bsha4mqiDy2kleV9yjtbtKDa8cdBpipgz83I+/TsJ4cxirYdfCWG
         VUrQ==
X-Gm-Message-State: AOAM533HItHNHP1XlJTiaaMjQirwx/nqSiDsCxGh84C1SRw83FgMxb76
        ZAcIHOmgFphHTr41kWta6Nw=
X-Google-Smtp-Source: ABdhPJzdIG9cW+V8ANnPEuw/c6YLPnojncCuebsYnl70q+r7jAzdxoU6ycSiZJtZL0Us/LIX0bqUtw==
X-Received: by 2002:a17:90a:2aca:: with SMTP id i10mr22660121pjg.110.1621825797816;
        Sun, 23 May 2021 20:09:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 31/51] myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:36 -0700
Message-Id: <20210524030856.2824-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d9c82e211ae7..27aabe1e635a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1263,6 +1263,7 @@ static int myrb_host_reset(struct scsi_cmnd *scmd)
 static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 		struct scsi_cmnd *scmd)
 {
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	struct myrb_hba *cb = shost_priv(shost);
 	struct myrb_cmdblk *cmd_blk = scsi_cmd_priv(scmd);
 	union myrb_cmd_mbox *mbox = &cmd_blk->mbox;
@@ -1286,7 +1287,7 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 	}
 
 	mbox->type3.opcode = MYRB_CMD_DCDB;
-	mbox->type3.id = scmd->request->tag + 3;
+	mbox->type3.id = rq->tag + 3;
 	mbox->type3.addr = dcdb_addr;
 	dcdb->channel = sdev->channel;
 	dcdb->target = sdev->id;
@@ -1305,11 +1306,11 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 		break;
 	}
 	dcdb->early_status = false;
-	if (scmd->request->timeout <= 10)
+	if (rq->timeout <= 10)
 		dcdb->timeout = MYRB_DCDB_TMO_10_SECS;
-	else if (scmd->request->timeout <= 60)
+	else if (rq->timeout <= 60)
 		dcdb->timeout = MYRB_DCDB_TMO_60_SECS;
-	else if (scmd->request->timeout <= 600)
+	else if (rq->timeout <= 600)
 		dcdb->timeout = MYRB_DCDB_TMO_10_MINS;
 	else
 		dcdb->timeout = MYRB_DCDB_TMO_24_HRS;
@@ -1577,7 +1578,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	}
 
 	myrb_reset_cmd(cmd_blk);
-	mbox->type5.id = scmd->request->tag + 3;
+	mbox->type5.id = scsi_cmd_to_rq(scmd)->tag + 3;
 	if (scmd->sc_data_direction == DMA_NONE)
 		goto submit;
 	nsge = scsi_dma_map(scmd);
