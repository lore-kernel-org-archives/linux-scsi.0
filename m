Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DACCC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DBB160EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhHIXEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:35 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41740 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbhHIXEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:30 -0400
Received: by mail-pj1-f49.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so2487914pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8zxBgk79cdBC45+HLy/e1lDboxU7tCb3KFICdDIvz0=;
        b=sPkevpWcBuRoSsT3E0TfWNRiZjR0btR8bM74p/KrRDzAx8BL/jwQ6AMIaSdFOcpPSn
         PVVKXCVZsNMmmKWF6AmQHOp0BlWZZI+AnAxKrPvfUCd84N4c2BtHhCPYBF1K0x7ZnJgY
         UMftin039hywUhWH54dSumGRH1y0y6klmJB2ojcvsaxjyBFG6fmoOldIxFREwXz1bwD7
         J77yAZExBvE4x4XW5UUbdfL9DbHC72Cv06e2nWAsmOs6PK4wzrdXkfB2JvW6wruwIsqZ
         1TKXOGP+2YqBoslbcbzjQWPJ03L+/6HUkJy9DI/PC1yAsdD0UwJoIH30bsyL/c4+ORWc
         yklQ==
X-Gm-Message-State: AOAM5300hJRbkInqJhvXip6XV4/hAuHifQT3xlk34bnV2ieOT0vD2HUu
        Qg2TaPklg4e0CiEEjRpB4vQ=
X-Google-Smtp-Source: ABdhPJz1Ws5f6zydBqHZ/Ynl7W7+SGBbnQlWzVbrnlkcqGtMaGJDcnZpAOM1iFIIcTqAUF8vNAcLXQ==
X-Received: by 2002:a62:7b50:0:b029:3cd:e227:3486 with SMTP id w77-20020a627b500000b02903cde2273486mr62286pfc.74.1628550248993;
        Mon, 09 Aug 2021 16:04:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 04/52] sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:07 -0700
Message-Id: <20210809230355.8186-5-bvanassche@acm.org>
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
