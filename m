Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E064DC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C092760F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhHIXFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:18 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39707 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbhHIXFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:16 -0400
Received: by mail-pl1-f176.google.com with SMTP id l11so6719397plk.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5frQuBfvw3TO6BJtxyQj/5vO0rFo/9Rm653FDty9kM=;
        b=o+N7thpo9nYFh/zJCbXeHVvhvlVqK75UEqUx9E6C40e7lnrgvcoJmzEnVwtWXL8kpY
         tf1v1iiL+tERNmhWiiVjvUSmIU5cgoVCowPuQi8yurJlHAtXB/NTAuEl/zGafp4LRtja
         uqW8FIMFnB+5SIbpDKnu2IxYP1eb4ABkJcNfk3k4Cy0fSpzvWuEFtra9lVpmIVxikJIm
         43/NahgT7xU/MW/8g35l3cggGCyZJ99rS1wjwpNmPJSQsdGzY3bi4ucakfJP/oB6XJpm
         PBvoJEgJWw4MoN2f7sYR+htVa0KmEfshwin3s63cLWy9ibD7TxNdjks0DlMWkXqtT/4I
         jpeA==
X-Gm-Message-State: AOAM532igPx3cHMl+YVPSaF+NclFLEeA6APqkoPTeJAiUf2foAax4e9z
        W/DiHt7PSluqtgJGM89VTIk=
X-Google-Smtp-Source: ABdhPJzG3yEiEYOpiGs/59ts5xJQa2SUmkr8DQDlBqsKXCmBuibCUDcJGserdcnJ/+f9hg+BmpqfjQ==
X-Received: by 2002:aa7:9af7:0:b029:3be:afdf:e75c with SMTP id y23-20020aa79af70000b02903beafdfe75cmr19928894pfp.77.1628550295096;
        Mon, 09 Aug 2021 16:04:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 33/52] myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:36 -0700
Message-Id: <20210809230355.8186-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 26326af23dbc..07f274afd7e5 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1582,6 +1582,7 @@ static void myrs_mode_sense(struct myrs_hba *cs, struct scsi_cmnd *scmd,
 static int myrs_queuecommand(struct Scsi_Host *shost,
 		struct scsi_cmnd *scmd)
 {
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	struct myrs_hba *cs = shost_priv(shost);
 	struct myrs_cmdblk *cmd_blk = scsi_cmd_priv(scmd);
 	union myrs_cmd_mbox *mbox = &cmd_blk->mbox;
@@ -1628,7 +1629,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	cmd_blk->sense_addr = sense_addr;
 
-	timeout = scmd->request->timeout;
+	timeout = rq->timeout;
 	if (scmd->cmd_len <= 10) {
 		if (scmd->device->channel >= cs->ctlr_info->physchan_present) {
 			struct myrs_ldev_info *ldev_info = sdev->hostdata;
@@ -1644,10 +1645,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			mbox->SCSI_10.pdev.target = sdev->id;
 			mbox->SCSI_10.pdev.channel = sdev->channel;
 		}
-		mbox->SCSI_10.id = scmd->request->tag + 3;
+		mbox->SCSI_10.id = rq->tag + 3;
 		mbox->SCSI_10.control.dma_ctrl_to_host =
 			(scmd->sc_data_direction == DMA_FROM_DEVICE);
-		if (scmd->request->cmd_flags & REQ_FUA)
+		if (rq->cmd_flags & REQ_FUA)
 			mbox->SCSI_10.control.fua = true;
 		mbox->SCSI_10.dma_size = scsi_bufflen(scmd);
 		mbox->SCSI_10.sense_addr = cmd_blk->sense_addr;
@@ -1690,10 +1691,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			mbox->SCSI_255.pdev.target = sdev->id;
 			mbox->SCSI_255.pdev.channel = sdev->channel;
 		}
-		mbox->SCSI_255.id = scmd->request->tag + 3;
+		mbox->SCSI_255.id = rq->tag + 3;
 		mbox->SCSI_255.control.dma_ctrl_to_host =
 			(scmd->sc_data_direction == DMA_FROM_DEVICE);
-		if (scmd->request->cmd_flags & REQ_FUA)
+		if (rq->cmd_flags & REQ_FUA)
 			mbox->SCSI_255.control.fua = true;
 		mbox->SCSI_255.dma_size = scsi_bufflen(scmd);
 		mbox->SCSI_255.sense_addr = cmd_blk->sense_addr;
