Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83328C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646D661168
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhEXDL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:29 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:40666 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhEXDL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:27 -0400
Received: by mail-pg1-f175.google.com with SMTP id j12so19050118pgh.7
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z/V8pQL9mMuI1DxSA21Jm+mA2NPyWWoO8bpgWSewBgw=;
        b=igAP5xTQEitw4WRCCVjAtDanCumPT4o3iH5ixJ+sTm9k1b00OpyXWX9KQYaby4eYsZ
         B5rdf6urGx5XdsHvl6f+rFOjJUAgEtfG+Ktq88YS3VWuC7/hTK+SDiiTQBLVWjP2SFAu
         d3086sUeabD0ZOLB/iIUy92Gkoo0yqtu8DBvZh/1HYPKd06aMiaQUuu6jEhjTkLVr+jg
         eI+WnpYw26MDNNlsIjcaE7szdMn5n3/+71zqJO5oMtZiDdJMRZuEU0OHT8brXgL9mc7r
         buyimWW2YjRaskHmzS4z06Ew/Gaq7V4U4DMDqinmtKV/xwWW+PKj6pR98jXAIJ5KskDC
         uYSQ==
X-Gm-Message-State: AOAM531BNk3gY+vNSb6CepQ6pK3acOIReFcejNbT2nhGSvl9wmFDonf4
        XrsCzjiEcCiaRJlvN+gEXEA=
X-Google-Smtp-Source: ABdhPJytkDcDkPmu77fBvgG0+lNqAi4TgBtHMIcpSCHjNKjfZ7fz8Ik4SnZSAmmB0cdZSLyZGSYnxA==
X-Received: by 2002:a05:6a00:882:b029:24b:afda:acfa with SMTP id q2-20020a056a000882b029024bafdaacfamr22795478pfj.72.1621825799281;
        Sun, 23 May 2021 20:09:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 32/51] myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:37 -0700
Message-Id: <20210524030856.2824-33-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b68c68d1716..9b3090d59bb9 100644
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
@@ -1633,7 +1634,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	cmd_blk->sense_addr = sense_addr;
 
-	timeout = scmd->request->timeout;
+	timeout = rq->timeout;
 	if (scmd->cmd_len <= 10) {
 		if (scmd->device->channel >= cs->ctlr_info->physchan_present) {
 			struct myrs_ldev_info *ldev_info = sdev->hostdata;
@@ -1649,10 +1650,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
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
@@ -1695,10 +1696,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
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
