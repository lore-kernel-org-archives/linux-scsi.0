Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F9DC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFA561168
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhEXDKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:41 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:50861 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbhEXDKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:38 -0400
Received: by mail-pj1-f44.google.com with SMTP id t11so14030559pjm.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9REewPRXrYQ26/Yrz6DO7KURHZ0CA9NseOl7nKEHG4=;
        b=RFCKV+ccqdJW7lT+KsXRfaV8iTXMTQt4Tn1dEk6YOfYduD9GzIhfjtHd3ieSM6vdLc
         7XARYKe7jhNb1euqrcjhwOBV+66a8AWJ3U/16AQzjhSICL8FAJgPu9e7mw8U1dix3a1v
         XWGQk7QVjGvBLVAVCSSs3adeNWmY6QyuNiTrgdtBm60SfCej9ct3rYDF+3BdOMwHA0FH
         5EyjnV7roVgWLkunzpMmSuPuoFQCOnsRI/o5wtHvJIAytztg/rEzSXKVEdz7Zmj8tF1F
         iWpt4oAsEf+7+P0h5HgPtyILiuI5SqErl/VTzSMKApvhyADCeQkJOgFR0bVvFDPKRlhL
         KAkA==
X-Gm-Message-State: AOAM531CY1M7MOw52CeiltLclgIagfAxOVwCl4ToFeWU4JdLRYN8d6YJ
        YoZgD2QbY8HZRU1zc2u+M3g=
X-Google-Smtp-Source: ABdhPJxh2w2rpu6q11EKovEi75wAC2wW704ROJu+9UaOWKezGIz86TnZh6Hh/+iW82l8euMOEnODWg==
X-Received: by 2002:a17:90a:b38d:: with SMTP id e13mr22155597pjr.222.1621825749843;
        Sun, 23 May 2021 20:09:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 04/51] sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:09 -0700
Message-Id: <20210524030856.2824-5-bvanassche@acm.org>
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
