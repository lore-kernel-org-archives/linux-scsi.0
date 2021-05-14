Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB6BC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5755561446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhENVf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:28 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:38544 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhENVfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:24 -0400
Received: by mail-pl1-f170.google.com with SMTP id 69so102626plc.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjjWgcGg3lNUdfmXQnaHe/oiHj8x1ZBHAFqCm8zQryA=;
        b=uSbIllRYp+9WZ65vyfK/XH4ouSiPevrkRnxAoPtFm+voWb0kMf4Mza9bOYEz+vM8rq
         auy7mo+KPAW19ZBLSwMF78GsQivMjTK48265mcUkNqSggO8vXM0NIzX6qPlfppI3EObw
         vVSFSBWVZhGjOVcUBJlxF6pIBzuEZXIHhYUzKN1P4qXxptk7wcjcRNk8ReaFbbD0wPoK
         n7BO18u2uuiW/KgxtzMt1sMG+FZf6BCFnxuVl1k2D3r2ycbZ6As7rIBwO8C+dXg/dhNb
         CXgAct8xvUhjmx9/9D3lZiOGvwkTm/j7OWaV8UuoARTB0WGNS2mZSwYdLlrh/OBA7+hq
         TARw==
X-Gm-Message-State: AOAM530hRAfcC1DKCBp+aLkWOQEEbHtjozo+7V6WqRpWg1Pew3s84Tqr
        zKO4d1X7xuLNtzaq+qdRuhs=
X-Google-Smtp-Source: ABdhPJzVKT1CknTzkG+0GuoOnKGalaimpbk5cg6yt+Oak824QFd5HDP5A4Gb3QMB5fX7rYcO3RPhdA==
X-Received: by 2002:a17:90a:e7c2:: with SMTP id kb2mr4752659pjb.193.1621028052735;
        Fri, 14 May 2021 14:34:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 04/50] sr: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:19 -0700
Message-Id: <20210514213356.5264-5-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e4633b84c556..5a23f4ca8698 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -326,7 +326,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
-	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct scsi_cd *cd = scsi_cd(blk_req(SCpnt)->rq_disk);
 
 #ifdef DEBUG
 	scmd_printk(KERN_INFO, SCpnt, "done: %x\n", result);
@@ -348,16 +348,16 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 				break;
 			error_sector =
 				get_unaligned_be32(&SCpnt->sense_buffer[3]);
-			if (SCpnt->request->bio != NULL)
+			if (blk_req(SCpnt)->bio != NULL)
 				block_sectors =
-					bio_sectors(SCpnt->request->bio);
+					bio_sectors(blk_req(SCpnt)->bio);
 			if (block_sectors < 4)
 				block_sectors = 4;
 			if (cd->device->sector_size == 2048)
 				error_sector <<= 2;
 			error_sector &= ~(block_sectors - 1);
 			good_bytes = (error_sector -
-				      blk_rq_pos(SCpnt->request)) << 9;
+				      blk_rq_pos(blk_req(SCpnt))) << 9;
 			if (good_bytes < 0 || good_bytes >= this_count)
 				good_bytes = 0;
 			/*
@@ -389,7 +389,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 {
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
-	struct request *rq = SCpnt->request;
+	struct request *rq = blk_req(SCpnt);
 	blk_status_t ret;
 
 	ret = scsi_alloc_sgtables(SCpnt);
