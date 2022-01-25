Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFD1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 07:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442133AbiAYHWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 02:22:09 -0500
Received: from verein.lst.de ([213.95.11.211]:34284 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444118AbiAYHTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 02:19:16 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B0AB868BEB; Tue, 25 Jan 2022 08:19:06 +0100 (CET)
Date:   Tue, 25 Jan 2022 08:19:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220125071906.GA27674@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-6-ming.lei@redhat.com> <20220124130555.GD27269@lst.de> <Ye8xleeYZfmwA3D7@T590> <20220125061634.GA26495@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125061634.GA26495@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 07:16:34AM +0100, Christoph Hellwig wrote:
> So why not key off accouning off "rq->bio && rq->bio->bi_bdev"
> and remove the need for the flag and the second half of the assignment
> above?  That is much less error probe and removes code size.

Something like this, lightly tested:

---
From 5499d013341b492899d1fecde7680ff8ebd232e9 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 25 Jan 2022 07:29:06 +0100
Subject: block: remove the part field from struct request

All file system I/O and most userspace passthrough bios have bi_bdev set.
Switch I/O accounting to directly use the bio and stop copying it into a
separate struct request field.

This changes behavior in that e.g. /dev/sgX requests are not accounted
to the gendisk for the SCSI disk any more, which is the correct thing to
do as they never went through that gendisk, and fixes a potential race
when the disk driver is unbound while /dev/sgX I/O is in progress.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c      | 12 ++++++------
 block/blk-mq.c         | 32 +++++++++++++-------------------
 block/blk.h            |  6 +++---
 include/linux/blk-mq.h |  1 -
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4de34a332c9fd..43e46ea2f0152 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -739,11 +739,11 @@ void blk_rq_set_mixed_merge(struct request *rq)
 
 static void blk_account_io_merge_request(struct request *req)
 {
-	if (blk_do_io_stat(req)) {
-		part_stat_lock();
-		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
-		part_stat_unlock();
-	}
+	if (!blk_do_io_stat(req))
+		return;
+	part_stat_lock();
+	part_stat_inc(req->bio->bi_bdev, merges[op_stat_group(req_op(req))]);
+	part_stat_unlock();
 }
 
 static enum elv_merge blk_try_req_merge(struct request *req,
@@ -947,7 +947,7 @@ static void blk_account_io_merge_bio(struct request *req)
 		return;
 
 	part_stat_lock();
-	part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
+	part_stat_inc(req->bio->bi_bdev, merges[op_stat_group(req_op(req))]);
 	part_stat_unlock();
 }
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f3bf3358a3bb2..01b3862347965 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -132,10 +132,12 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv,
 {
 	struct mq_inflight *mi = priv;
 
-	if ((!mi->part->bd_partno || rq->part == mi->part) &&
-	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
-		mi->inflight[rq_data_dir(rq)]++;
+	if (blk_mq_rq_state(rq) != MQ_RQ_IN_FLIGHT)
+		return true;
+	if (mi->part->bd_partno && rq->bio && rq->bio->bi_bdev != mi->part)
+		return true;
 
+	mi->inflight[rq_data_dir(rq)]++;
 	return true;
 }
 
@@ -331,7 +333,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->tag = BLK_MQ_NO_TAG;
 	rq->internal_tag = BLK_MQ_NO_TAG;
 	rq->start_time_ns = ktime_get_ns();
-	rq->part = NULL;
 	blk_crypto_rq_set_defaults(rq);
 }
 EXPORT_SYMBOL(blk_rq_init);
@@ -368,7 +369,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		rq->start_time_ns = ktime_get_ns();
 	else
 		rq->start_time_ns = 0;
-	rq->part = NULL;
 #ifdef CONFIG_BLK_RQ_ALLOC_TIME
 	rq->alloc_time_ns = alloc_time_ns;
 #endif
@@ -687,11 +687,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
-	if (req->part && blk_do_io_stat(req)) {
+	if (blk_do_io_stat(req)) {
 		const int sgrp = op_stat_group(req_op(req));
 
 		part_stat_lock();
-		part_stat_add(req->part, sectors[sgrp], bytes >> 9);
+		part_stat_add(req->bio->bi_bdev, sectors[sgrp], bytes >> 9);
 		part_stat_unlock();
 	}
 }
@@ -859,11 +859,12 @@ EXPORT_SYMBOL_GPL(blk_update_request);
 static void __blk_account_io_done(struct request *req, u64 now)
 {
 	const int sgrp = op_stat_group(req_op(req));
+	struct block_device *bdev = req->bio->bi_bdev;
 
 	part_stat_lock();
-	update_io_ticks(req->part, jiffies, true);
-	part_stat_inc(req->part, ios[sgrp]);
-	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
+	update_io_ticks(bdev, jiffies, true);
+	part_stat_inc(bdev, ios[sgrp]);
+	part_stat_add(bdev, nsecs[sgrp], now - req->start_time_ns);
 	part_stat_unlock();
 }
 
@@ -874,21 +875,14 @@ static inline void blk_account_io_done(struct request *req, u64 now)
 	 * normal IO on queueing nor completion.  Accounting the
 	 * containing request is enough.
 	 */
-	if (blk_do_io_stat(req) && req->part &&
-	    !(req->rq_flags & RQF_FLUSH_SEQ))
+	if (blk_do_io_stat(req) && !(req->rq_flags & RQF_FLUSH_SEQ))
 		__blk_account_io_done(req, now);
 }
 
 static void __blk_account_io_start(struct request *rq)
 {
-	/* passthrough requests can hold bios that do not have ->bi_bdev set */
-	if (rq->bio && rq->bio->bi_bdev)
-		rq->part = rq->bio->bi_bdev;
-	else if (rq->q->disk)
-		rq->part = rq->q->disk->part0;
-
 	part_stat_lock();
-	update_io_ticks(rq->part, jiffies, false);
+	update_io_ticks(rq->bio->bi_bdev, jiffies, false);
 	part_stat_unlock();
 }
 
diff --git a/block/blk.h b/block/blk.h
index 8bd43b3ad33d5..a7a5a5435e09d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -320,12 +320,12 @@ int blk_dev_init(void);
 /*
  * Contribute to IO statistics IFF:
  *
- *	a) it's attached to a gendisk, and
- *	b) the queue had IO stats enabled when this request was started
+ *	a) the queue had IO stats enabled when this request was started, and
+ *	b) it has an assigned block_device
  */
 static inline bool blk_do_io_stat(struct request *rq)
 {
-	return (rq->rq_flags & RQF_IO_STAT) && rq->q->disk;
+	return (rq->rq_flags & RQF_IO_STAT) && rq->bio && rq->bio->bi_bdev;
 }
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d319ffa59354a..81769c01e6e4b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -99,7 +99,6 @@ struct request {
 		struct request *rq_next;
 	};
 
-	struct block_device *part;
 #ifdef CONFIG_BLK_RQ_ALLOC_TIME
 	/* Time that the first bio started allocating this request. */
 	u64 alloc_time_ns;
-- 
2.30.2

