Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE7AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8446611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351277AbhERRq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:56 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:41817 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351261AbhERRqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:53 -0400
Received: by mail-pj1-f43.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1979411pji.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWCkbl9gtDCSQSGnzA3xMbegNxrAgeyKupcSi9N6TCY=;
        b=ens4Rx1Xph2YDqHy2hXjKHdVf0h64yVkX3jQkqyQM5PJs5gOtWX/yE1us7FfTENdx4
         0BElkIxVZ1S8kfK+C1gk4mbt0SCaZltOS5y3CxqZ4g+AUBYT6kTGt/fCcZIYFZAbHfff
         36PuwN58KODnjn0jBIPSUD8fx0q5AbITHInQPNsbKapOfsPbjDvdk9MF4D1B3QyK74yy
         qqmdtpdSgbCRnqOGbcO5c/DwQ2ift7Nf2Xe5G0q0Z4mzcMbXgJRHSbjn/VeVuov6eIvT
         +jhpZScAkj50RtxYbd48Wz4fOnBDY1O3NnyDqN1LWNtn4B2jIx40J4bmeXbu4OLTHzO/
         /9+w==
X-Gm-Message-State: AOAM532EK+Pul51t4JH+icKkg20mUlU/fkT7UccSPXKRmUNuT2bY+xCr
        CywZ9dzsq6V2K94byTwoDEbc3fLbxbAb6w==
X-Google-Smtp-Source: ABdhPJym3Npcg1wflzuXvDASOWCPL9mpy2q2u4lqLvYnvPiI8moTdrl5zE1PzdFPPuw/Embn0zATKw==
X-Received: by 2002:a17:902:d204:b029:f0:b65d:a14d with SMTP id t4-20020a170902d204b02900f0b65da14dmr5819308ply.25.1621359934565;
        Tue, 18 May 2021 10:45:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 30/50] myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:30 -0700
Message-Id: <20210518174450.20664-31-bvanassche@acm.org>
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
