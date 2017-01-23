From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/16] block: fix elevator init check
Date: Mon, 23 Jan 2017 16:29:06 +0100
Message-ID: <1485185361-29786-2-git-send-email-hch@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

We can't initalize the elevator fields for flushes as flush share space
in struct request with the elevator data.  But currently we can't
commnicate that a request is a flush through blk_get_request as we
can only pass READ or WRITE, and the low-level code looks at the
possible NULL bio to check for a flush.

Fix this by allowing to pass any block op and flags, and by checking for
the flush flags in __get_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a61f140..732b719 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1022,25 +1022,6 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
 	return 0;
 }
 
-/*
- * Determine if elevator data should be initialized when allocating the
- * request associated with @bio.
- */
-static bool blk_rq_should_init_elevator(struct bio *bio)
-{
-	if (!bio)
-		return true;
-
-	/*
-	 * Flush requests do not use the elevator so skip initialization.
-	 * This allows a request to share the flush and elevator data.
-	 */
-	if (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA))
-		return false;
-
-	return true;
-}
-
 /**
  * __get_request - get a free request
  * @rl: request list to allocate from
@@ -1119,10 +1100,13 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
 	 * request is freed.  This guarantees icq's won't be destroyed and
 	 * makes creating new ones safe.
 	 *
+	 * Flush requests do not use the elevator so skip initialization.
+	 * This allows a request to share the flush and elevator data.
+	 *
 	 * Also, lookup icq while holding queue_lock.  If it doesn't exist,
 	 * it will be created after releasing queue_lock.
 	 */
-	if (blk_rq_should_init_elevator(bio) && !blk_queue_bypass(q)) {
+	if (!(op & (REQ_PREFLUSH | REQ_FUA)) && !blk_queue_bypass(q)) {
 		rq_flags |= RQF_ELVPRIV;
 		q->nr_rqs_elvpriv++;
 		if (et->icq_cache && ioc)
@@ -1276,8 +1260,6 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 {
 	struct request *rq;
 
-	BUG_ON(rw != READ && rw != WRITE);
-
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-- 
2.1.4

