Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A133FC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90ED1206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgF2TLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:11:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:53726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731065AbgF2TL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E5AA3AF3A;
        Mon, 29 Jun 2020 07:20:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/22] block: add flag for internal commands
Date:   Mon, 29 Jun 2020 09:20:01 +0200
Message-Id: <20200629072021.9864-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200629072021.9864-1-hare@suse.de>
References: <20200629072021.9864-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some drivers require to allocate requests for internal command
submission. These request will never be passed through the block
layer, but nevertheless require a valid tag to avoid them clashing
with normal I/O commands.
This patch adds a new request flag REQ_INTERNAL to mark such
requests and a terminates any such commands in blk_execute_rq_nowait()
with a WARN_ON_ONCE to signal such an invalid usage.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-exec.c          | 5 +++++
 include/linux/blk_types.h | 2 ++
 include/linux/blkdev.h    | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 85324d53d072..6869877e0d21 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -55,6 +55,11 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 
+	if (WARN_ON_ONCE(blk_rq_is_internal(rq))) {
+		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
+		return;
+	}
+
 	blk_account_io_start(rq);
 
 	/*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..e386c43e4d77 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -360,6 +360,7 @@ enum req_flag_bits {
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
+	__REQ_INTERNAL,		/* driver-internal command */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -384,6 +385,7 @@ enum req_flag_bits {
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
+#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8fd900998b4e..d09210d4591e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -273,6 +273,11 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
 	return blk_rq_is_scsi(rq) || blk_rq_is_private(rq);
 }
 
+static inline bool blk_rq_is_internal(struct request *rq)
+{
+	return rq->cmd_flags & REQ_INTERNAL;
+}
+
 static inline bool bio_is_passthrough(struct bio *bio)
 {
 	unsigned op = bio_op(bio);
-- 
2.16.4

