Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A90C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 875D9611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351303AbhERRq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:58 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:40527 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351273AbhERRqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:54 -0400
Received: by mail-pg1-f180.google.com with SMTP id j12so7532914pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z/V8pQL9mMuI1DxSA21Jm+mA2NPyWWoO8bpgWSewBgw=;
        b=Hv0X1nyp0m/VltY+St2d8Zjp/ETU6HMDm1TIBZ4ZqRIiT2AxhkpL1vBjf0z4UUAap5
         gpPFKF2Vc5yDLKyd1VWzgWcHK0gDK5WXYyx8kWRRPayWB3UjnE4DsRHSxWnxBfbp00Co
         EmOPq1nwcrOd/mwo2D3hwI0dpkoFcHVIW/FyFoHyxpSbiVd0oo/KoYr2eU2LTK0rr9j+
         ZA50henzsTMwrjHtKYOfks1BI22jL2+yelhEK9NfxfKcKWUsBMS1qjqyOPhO4aCOOqtE
         vcY04Htjda7XbfnmgtlVniHGGp24hC6p0vqVqMY8fSkVdV87twedWf33tQHY3f4XING6
         Da+A==
X-Gm-Message-State: AOAM533UfiNydpxzY/8fSkrQRZty6kHJ/B9a8dtX8o215E07cjyxtXm5
        CLF77GTrevT1WLGLDqd/xD4=
X-Google-Smtp-Source: ABdhPJzp3EYjWoI3B8zvj+XnbI4AZaNaJpFSY9VSU7Bm9+5Cmv2XWwhJ65A4ySZygDMZy0Sy+CI9mQ==
X-Received: by 2002:a63:1109:: with SMTP id g9mr6399863pgl.88.1621359936179;
        Tue, 18 May 2021 10:45:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 31/50] myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:31 -0700
Message-Id: <20210518174450.20664-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
