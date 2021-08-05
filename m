Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB719C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B081960BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhHETTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:04 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:42641 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhHETTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:00 -0400
Received: by mail-pj1-f53.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso12008038pjo.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8zxBgk79cdBC45+HLy/e1lDboxU7tCb3KFICdDIvz0=;
        b=EHEr/9MkUclsB9ngVByU3X52hyBS5xkI1mjD3nHKiXlg1FT3OYqqOjfMTfsqXJ2Iy9
         AUUPf/adRIFLuyW6eTpstONgA5/dzq+0vopn23mQQ3K0DOk7K0uvNQ3iCtvoOgrmINZK
         uNNvL/6kY+HqYC464RYa2dfjB9KP7CjzSGWn0hM/XqwZDkeEBynbsEjKt/MLtlyONPYw
         smnasUUCP6lDyO8PMgL5z19g0zO6HOUu2JfOBKHdfwNmF4g52dnQf0i5s3QrZiLgDMc8
         SnI974Xctox3cYX7s9lA0PaWZ8g2QvegJcK3ovRul4D82+Bsjp7fEInM3q+Fymm79IHl
         qTPA==
X-Gm-Message-State: AOAM5304Pdq9asIYVFBQmE1ucO/eIiF3jmV1Pg19bMST5j2CdlTki+x/
        QyIc8UUUruYoR9xEusSKBhE=
X-Google-Smtp-Source: ABdhPJyPdbhpOerC32YMTM3iyQYq5G+8rLvGZxlH7QplSx1f3qgbKRImrSQE8Ivi1Qk+dWiQYVF18w==
X-Received: by 2002:a63:6441:: with SMTP id y62mr78735pgb.400.1628191125390;
        Thu, 05 Aug 2021 12:18:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 04/52] sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:40 -0700
Message-Id: <20210805191828.3559897-5-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 6203a8b58d40..6a96151d3630 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -331,7 +331,8 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
-	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct request *rq = scsi_cmd_to_rq(SCpnt);
+	struct scsi_cd *cd = scsi_cd(rq->rq_disk);
 
 #ifdef DEBUG
 	scmd_printk(KERN_INFO, SCpnt, "done: %x\n", result);
@@ -353,16 +354,14 @@ static int sr_done(struct scsi_cmnd *SCpnt)
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
@@ -394,7 +393,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 {
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
-	struct request *rq = SCpnt->request;
+	struct request *rq = scsi_cmd_to_rq(SCpnt);
 	blk_status_t ret;
 
 	ret = scsi_alloc_sgtables(SCpnt);
