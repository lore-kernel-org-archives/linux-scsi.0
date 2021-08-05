Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABB5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6F06112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242674AbhHETT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:59 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44920 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbhHETT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:57 -0400
Received: by mail-pj1-f44.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11975043pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5frQuBfvw3TO6BJtxyQj/5vO0rFo/9Rm653FDty9kM=;
        b=cgw6flFNtNYmwCaR1VrMoH23uhD0cWhnlyXiN0aBmqFp1ze9kZkVF+0TCpOtlfSOqm
         3zigXNNlO00q3NtTOgoVWiA8msTjvTVIyfVEP6SAPtRTIRck93Arv8uxJEr+/O5plkSR
         83vTmx2L+IPNovcUppXjIiTt5mo/XbzMSIysU7Ht/ZMQtCRtWV4e2fXhwHjKkbtoeDxE
         kwCLP+jZdYzutf0MbGSGleRHMblrrn71rsVIr9h3daR0F0u95LguL7QiOy77LHc8hLJI
         +tfthPZYhRXT/EP+VmXaMPK479zr6UQtOe7aRuB6y3zdd3LR8ul538x/VmwHlSLat5tB
         VHxg==
X-Gm-Message-State: AOAM530FlfOKkZi7YmYQVOyvIiyDfzya9xCcaiWPpQKVIVThJGfBbOIn
        bg1j3u3H8iW18JrbepVOZ3U=
X-Google-Smtp-Source: ABdhPJwCvn5AbX///vOweOVMKQH7Tf8e0+ZOSQ8BShc+MTQFmPrapzfel1hI1hCLB5K4cwdg5ZFwwA==
X-Received: by 2002:a63:a01:: with SMTP id 1mr178903pgk.360.1628191182250;
        Thu, 05 Aug 2021 12:19:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 33/52] myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:09 -0700
Message-Id: <20210805191828.3559897-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
