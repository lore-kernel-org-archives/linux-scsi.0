From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2] Fix bugs found during bio_list update
Date: Sun, 19 Apr 2009 12:14:27 -0400
Message-ID: <20090419161427.GB12531@havoc.gtf.org>
References: <20090419161234.GA12105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090419161234.GA12105@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, hch@lst.de
List-Id: linux-scsi@vger.kernel.org


Note - the very first change is not so much a fix as a cleanup.
bio_list_pop(), however, is a fix.

commit 18f987e9059c08bd61e5bded13d019cf521ada13
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Apr 19 12:01:55 2009 -0400

    block: Be sure to initialize bio list tail properly
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 block/blk-core.c  |    5 +++--
 block/blk-map.c   |    3 ++-
 block/blk-merge.c |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0ec8621..a2cd281 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1753,11 +1753,12 @@ static int __end_that_request_first(struct request *req, int error,
 	blk_account_io_completion(req, nr_bytes);
 
 	total_bytes = bio_nbytes = 0;
-	while ((bio = req->bio_list.head) != NULL) {
+	bio = req->bio_list.head;
+	while (bio) {
 		int nbytes;
 
 		if (nr_bytes >= bio->bi_size) {
-			req->bio_list.head = bio->bi_next;
+			bio_list_pop(&req->bio_list);
 			nbytes = bio->bi_size;
 			req_bio_endio(req, bio, nbytes, error);
 			next_idx = 0;
diff --git a/block/blk-map.c b/block/blk-map.c
index 437b916..ca849d3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -159,7 +159,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	return 0;
 unmap_rq:
 	blk_rq_unmap_user(bio);
-	rq->bio_list.head = NULL;
+	rq->bio_list.head = rq->bio_list.tail = NULL;
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user);
@@ -312,6 +312,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 	blk_rq_bio_prep(q, rq, bio);
 	blk_queue_bounce(q, &rq->bio_list.head);
+	rq->bio_list.tail = rq->bio_list.head;
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index a1a23ae..6dc74d8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -409,7 +409,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		req->cpu = next->cpu;
 
 	/* owner-ship of bio passed from next to req */
-	next->bio_list.head = NULL;
+	next->bio_list.head = next->bio_list.tail = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
