Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B7DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 438C561074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351188AbhERRqW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:22 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:33730 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351139AbhERRqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:20 -0400
Received: by mail-pj1-f52.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so2117789pjo.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9REewPRXrYQ26/Yrz6DO7KURHZ0CA9NseOl7nKEHG4=;
        b=kFZkWRey4KmaHYK4fsjVDfrOn7mDgMCfTn3GASs60UhGCwE/FYg4jqsNgcyykPOEtB
         K78lVO2Po2S3anN+iDI+/2JbTivb/tDu3Uchr3yiry6PGI1D+h+FcZMoG9ibdCm/kHcu
         /34bKy26kmxbF6Kdr2pGTLtmChlnEbd2zqCyU6CEspfLHIEgM68k+zCAFQ2NhGZbWyDp
         CLYgqcJ+DgRKpoOWp9u2MRy20OuNfoT3K2DW9IAJp2sGB2ARp5qbdttwBTpUA+dIHXaE
         pdXLM58DjUxeHM/cW4/jgZGLn4puW6vCteNJnXxNMtr4FV+WwRah6ggN78toNHM7Bui6
         pcRw==
X-Gm-Message-State: AOAM531RDF62itaQUJd5BXS9hgYY0BfREhEkGOpR257PRmxAdRjgLfI2
        5zoe1h8P2oVsgbPh7NrWsmLGnpct6LA=
X-Google-Smtp-Source: ABdhPJzzZikj8XD6mHCyZUzkdI0ukFePbrk+BRhNMqaCn3IPDEp4Fx+v1j0q20WnddFX20be9ND3qw==
X-Received: by 2002:a17:90a:6046:: with SMTP id h6mr3660584pjm.152.1621359901795;
        Tue, 18 May 2021 10:45:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 04/50] sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:04 -0700
Message-Id: <20210518174450.20664-5-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e4633b84c556..439e8198a528 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -326,7 +326,8 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
-	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct request *rq = scsi_cmd_to_rq(SCpnt);
+	struct scsi_cd *cd = scsi_cd(rq->rq_disk);
 
 #ifdef DEBUG
 	scmd_printk(KERN_INFO, SCpnt, "done: %x\n", result);
@@ -348,16 +349,14 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 				break;
 			error_sector =
 				get_unaligned_be32(&SCpnt->sense_buffer[3]);
-			if (SCpnt->request->bio != NULL)
-				block_sectors =
-					bio_sectors(SCpnt->request->bio);
+			if (rq->bio != NULL)
+				block_sectors = bio_sectors(rq->bio);
 			if (block_sectors < 4)
 				block_sectors = 4;
 			if (cd->device->sector_size == 2048)
 				error_sector <<= 2;
 			error_sector &= ~(block_sectors - 1);
-			good_bytes = (error_sector -
-				      blk_rq_pos(SCpnt->request)) << 9;
+			good_bytes = (error_sector - blk_rq_pos(rq)) << 9;
 			if (good_bytes < 0 || good_bytes >= this_count)
 				good_bytes = 0;
 			/*
@@ -389,7 +388,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 {
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
-	struct request *rq = SCpnt->request;
+	struct request *rq = scsi_cmd_to_rq(SCpnt);
 	blk_status_t ret;
 
 	ret = scsi_alloc_sgtables(SCpnt);
