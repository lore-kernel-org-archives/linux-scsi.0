Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A989CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F1061446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhENVgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:15 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35382 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhENVgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:12 -0400
Received: by mail-pj1-f53.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso2317659pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7VmxOno/PSZ8QeKNuENY9Y9ya4YIHoUlqmAutLYZyk=;
        b=GDJ44GGy+aTZpgD7dgVbx8akfSqAHRaDT/sAS1upkSlHIxPYkJe14uXE6LTsm079tx
         BqszOBwoRjKzfEN3hLeEXFuFDJDx0k8g+3hK02z55xyXoDZutI9RQ0y+2WnhAEoVhWi/
         XUU7hXmzgNUMfdz8cAXJKXDqcEv3+l3eQHBllq8Y/X8SFlq3MPQoEWTNqfM5ibGvsCUb
         VP+LK0j9YPUQwAPMUoV+EU5rGZL5OS0Nvu7YwPIm7dfRBGBz4zkehy95s8qj04nE4W1u
         4DmqMGVzCZJByYI+kUlkWylUqxekU2qHo2cTcmfNAZnx1YHTz8PSaumWkxYsP9I+g2nD
         FWug==
X-Gm-Message-State: AOAM531CHRJ5+CbYvmYLbL71fv+yhHQpsPQuBzke9HDCGfPmhUwpQisA
        W3y/Hbr4oRLcCXJVgICU1Z0=
X-Google-Smtp-Source: ABdhPJxkOOb0DuL9jl7HPGEsYGIKmQ2wVQvnQEzkzmmTFq4aHEAGwznokVgyhJNLR9pP4YpndF4Xgw==
X-Received: by 2002:a17:902:a401:b029:ef:4ee:6a7e with SMTP id p1-20020a170902a401b02900ef04ee6a7emr41575732plq.65.1621028099908;
        Fri, 14 May 2021 14:34:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 31/50] myrs: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:46 -0700
Message-Id: <20210514213356.5264-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b68c68d1716..390940919b6c 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1633,7 +1633,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	cmd_blk->sense_addr = sense_addr;
 
-	timeout = scmd->request->timeout;
+	timeout = blk_req(scmd)->timeout;
 	if (scmd->cmd_len <= 10) {
 		if (scmd->device->channel >= cs->ctlr_info->physchan_present) {
 			struct myrs_ldev_info *ldev_info = sdev->hostdata;
@@ -1649,10 +1649,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			mbox->SCSI_10.pdev.target = sdev->id;
 			mbox->SCSI_10.pdev.channel = sdev->channel;
 		}
-		mbox->SCSI_10.id = scmd->request->tag + 3;
+		mbox->SCSI_10.id = blk_req(scmd)->tag + 3;
 		mbox->SCSI_10.control.dma_ctrl_to_host =
 			(scmd->sc_data_direction == DMA_FROM_DEVICE);
-		if (scmd->request->cmd_flags & REQ_FUA)
+		if (blk_req(scmd)->cmd_flags & REQ_FUA)
 			mbox->SCSI_10.control.fua = true;
 		mbox->SCSI_10.dma_size = scsi_bufflen(scmd);
 		mbox->SCSI_10.sense_addr = cmd_blk->sense_addr;
@@ -1695,10 +1695,10 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			mbox->SCSI_255.pdev.target = sdev->id;
 			mbox->SCSI_255.pdev.channel = sdev->channel;
 		}
-		mbox->SCSI_255.id = scmd->request->tag + 3;
+		mbox->SCSI_255.id = blk_req(scmd)->tag + 3;
 		mbox->SCSI_255.control.dma_ctrl_to_host =
 			(scmd->sc_data_direction == DMA_FROM_DEVICE);
-		if (scmd->request->cmd_flags & REQ_FUA)
+		if (blk_req(scmd)->cmd_flags & REQ_FUA)
 			mbox->SCSI_255.control.fua = true;
 		mbox->SCSI_255.dma_size = scsi_bufflen(scmd);
 		mbox->SCSI_255.sense_addr = cmd_blk->sense_addr;
