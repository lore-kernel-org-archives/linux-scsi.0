Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DDAC433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE1D64E5C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhBVN1s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:27:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:45146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhBVNY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:24:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73D53AF3E;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/31] block: add flag for internal commands
Date:   Mon, 22 Feb 2021 14:23:35 +0100
Message-Id: <20210222132405.91369-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 866f74261b3b..27e248335ad5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -424,6 +424,7 @@ enum req_flag_bits {
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
+	__REQ_INTERNAL,		/* driver-internal command */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -448,6 +449,7 @@ enum req_flag_bits {
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
+#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94ee3089e01..5e1e2a549c37 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -269,6 +269,11 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
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
2.29.2

