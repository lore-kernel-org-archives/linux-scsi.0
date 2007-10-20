From: michaelc@cs.wisc.edu
Subject: [PATCH 07/10] fix blk_rq_map_user_iov bounce code
Date: Sat, 20 Oct 2007 00:44:41 -0500
Message-ID: <11928590894155-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
	<11928590871413-git-send-email-michaelc@cs.wisc.edu>
	<11928590871678-git-send-email-michaelc@cs.wisc.edu>
	<11928590884170-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590884170-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

bio_map_user_iov grabs a extra reference to the bio incase
a function that does not exist (bio_map_user_iov comments
reference __bio_map_user) bounced the bio.

This patch has blk_rq_map_user_iov grab a extra reference instead
of the bio function (blk_rq_map_user_iov was actually already
grabbing an extra reference), and it adds a blk_queue_bounce to bounce
the bio.

It also removes the bio_endio call in the failure path. This should
be needed because the bio layer did not bounce the bio.

There was also an extra bio_put in bio_unmap_user to handle the
extra get in bio_map_user_iov. This patch also removes that since
it is not needed.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c |    9 +++++++--
 fs/bio.c          |   43 +++++++++++--------------------------------
 2 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index fad17de..2e00bd2 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2692,13 +2692,18 @@ int blk_rq_map_user_iov(struct bio_set *bs, struct request *rq,
 		return PTR_ERR(bio);
 
 	if (bio->bi_size != len) {
-		bio_endio(bio, 0);
 		bio_unmap_user(bio);
 		return -EINVAL;
 	}
 
-	bio_get(bio);
 	blk_rq_bio_prep(rq->q, rq, bio);
+	blk_queue_bounce(rq->q, &rq->bio);
+	/*
+	 * If the bio was bounced then the bounced bio would be freed
+	 * when its endio is called, so we must grab an extra reference
+	 * for the unamp code.
+	 */
+	bio_get(rq->bio);
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
diff --git a/fs/bio.c b/fs/bio.c
index df90896..05ffe68 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -727,25 +727,19 @@ struct bio *bio_map_user_iov(struct request_queue *q, struct bio_set *bs,
 			     struct sg_iovec *iov, int iov_count,
 			     int write_to_vm, gfp_t gfp_mask)
 {
-	struct bio *bio;
-
-	bio = __bio_map_user_iov(q, bs, iov, iov_count, write_to_vm, gfp_mask);
-
-	if (IS_ERR(bio))
-		return bio;
-
-	/*
-	 * subtle -- if __bio_map_user() ended up bouncing a bio,
-	 * it would normally disappear when its bi_end_io is run.
-	 * however, we need it for the unmap, so grab an extra
-	 * reference to it
-	 */
-	bio_get(bio);
-
-	return bio;
+	return __bio_map_user_iov(q, bs, iov, iov_count, write_to_vm, gfp_mask);
 }
 
-static void __bio_unmap_user(struct bio *bio)
+/**
+ *	bio_unmap_user	-	unmap a bio
+ *	@bio:		the bio being unmapped
+ *
+ *	Unmap a bio previously mapped by bio_map_user(). Must be called with
+ *	a process context.
+ *
+ *	bio_unmap_user() may sleep.
+ */
+void bio_unmap_user(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	int i;
@@ -763,21 +757,6 @@ static void __bio_unmap_user(struct bio *bio)
 	bio_put(bio);
 }
 
-/**
- *	bio_unmap_user	-	unmap a bio
- *	@bio:		the bio being unmapped
- *
- *	Unmap a bio previously mapped by bio_map_user(). Must be called with
- *	a process context.
- *
- *	bio_unmap_user() may sleep.
- */
-void bio_unmap_user(struct bio *bio)
-{
-	__bio_unmap_user(bio);
-	bio_put(bio);
-}
-
 static void bio_map_kern_endio(struct bio *bio, int err)
 {
 	bio_put(bio);
-- 
1.5.1.2
