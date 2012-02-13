From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Mon, 13 Feb 2012 17:19:43 -0500
Message-ID: <yq1hayugyv4.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
	<20120207214005.GG6346@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42713 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2BMWTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 17:19:52 -0500
In-Reply-To: <20120207214005.GG6346@redhat.com> (Vivek Goyal's message of
	"Tue, 7 Feb 2012 16:40:05 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> In elv_rq_merge_ok() we don't allow merge of WRITE_SAME requests
Vivek> but in rq_mergeable() we do say that requests having WRITE_SAME
Vivek> can be merged.

Thanks for spotting this! I was blindly hooking into all the places
where REQ_DISCARD was present. However, the way we special-case discard
merging all over is broken.

I propose we do the following. I'll update the write same patch kit
accordingly.


block: Mark discard requests unmergeable

Discards were globally marked as mergeable and as a result we had
several code paths that explicitly disabled merging when REQ_DISCARD was
set.

Mark discard requests as unmergable and remove special-casing of
REQ_DISCARD.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..32bbdb1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1545,8 +1545,8 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
-		     nr_sectors > queue_max_hw_sectors(q))) {
+	if (likely(bio_has_data(bio) &&
+		   nr_sectors > queue_max_hw_sectors(q))) {
 		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 		       bdevname(bio->bi_bdev, b),
 		       bio_sectors(bio),
@@ -1698,7 +1698,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..3f73823 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -371,12 +371,6 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		return 0;
 
 	/*
-	 * Don't merge file system requests and discard requests
-	 */
-	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
-		return 0;
-
-	/*
 	 * Don't merge discard requests and secure discard requests
 	 */
 	if ((req->cmd_flags & REQ_SECURE) != (next->cmd_flags & REQ_SECURE))
@@ -477,10 +471,6 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq))
 		return false;
 
-	/* don't merge file system requests and discard requests */
-	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
-		return false;
-
 	/* don't merge discard requests and secure discard requests */
 	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
 		return false;
diff --git a/block/elevator.c b/block/elevator.c
index f016855..cccfdbf 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -591,8 +591,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
+		if (rq->cmd_type == REQ_TYPE_FS) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
@@ -634,8 +633,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		if (elv_attempt_insert_merge(q, rq))
 			break;
 	case ELEVATOR_INSERT_SORT:
-		BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
-		       !(rq->cmd_flags & REQ_DISCARD));
+		BUG_ON(rq->cmd_type != REQ_TYPE_FS);
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 129a9c0..b0d25ea 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -358,9 +358,15 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
-static inline int bio_has_data(struct bio *bio)
+static inline unsigned int bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	if (!bio)
+		return 0;
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return 0;
+
+	return bio->bi_io_vec != NULL;
 }
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 606cf33..4bfa699 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -575,11 +575,12 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
+	 REQ_DISCARD)
 #define rq_mergeable(rq)	\
-	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (((rq)->cmd_flags & REQ_DISCARD) || \
-	  (rq)->cmd_type == REQ_TYPE_FS))
+	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && (rq)->cmd_type == REQ_TYPE_FS)
+
+
 
 /*
  * q->prep_rq_fn return values
