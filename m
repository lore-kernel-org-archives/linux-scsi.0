From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/2] [RFC] block: Don't let blk_put_request leak BIOs
Date: Thu, 12 Feb 2009 19:27:43 +0200
Message-ID: <49945C0F.8040704@panasas.com>
References: <4993DCCA.8080508@panasas.com>	<20090212174124S.fujita.tomonori@lab.ntt.co.jp>	<4993E85A.20805@panasas.com> <20090212184208X.fujita.tomonori@lab.ntt.co.jp> <499413DB.2020208@panasas.com> <499428E1.1000009@panasas.com> <49942A9E.8090405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758122AbZBLR2K@vger.kernel.org>
In-Reply-To: <49942A9E.8090405@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


If a block ULD had allocated a request and mapped some memory into it,
but then for some reason failed to execute the request through one of
the blk_execute_request_xxx routines. Then the associated bio would leak,
unless ULD resorts to low-level loops intimate of block internals.

For this to work I have fixed a couple of places in block/ where
request->bio != NULL ownership was not honored. And a small cleanup
at sg_io() while at it.

[RFC]
  This code will also catch situations where LLD failed to complete
  the request before aborting it. Such situations are a BUG. Should we
  use WARN_ON_ONCE() in that case. The situation above is possible and
  can happen normally in memory pressure situations so maybe we should
  devise a bit-flag that ULD denotes that the request was aborted and
  only WARN_ON if flag was not set.
  For the duration of linux-next I'm leaving the WARN_ON to catch any
  problems like found above, and possible memory leaks. Before submission
  a complimentary patch should remove the WARN_ON. (Or this patch can be
  rebased)

  Please comment on possible pitfalls.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c   |   17 +++++++++++++++++
 block/blk-merge.c  |    2 ++
 block/scsi_ioctl.c |   21 ++++-----------------
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..3c1f920 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1055,6 +1055,22 @@ void part_round_stats(int cpu, struct hd_struct *part)
 EXPORT_SYMBOL_GPL(part_round_stats);
 
 /*
+ * If one of the blk_rq_map_xxx() was called but the request was not
+ * executed by the block layer, then we must release BIOs. Otherwise they
+ * will leak.
+ */
+static void _abort_unexecuted_bios(struct request *req)
+{
+	struct bio *bio;
+
+	WARN_ON(req->bio != NULL);
+	while (unlikely((bio = req->bio) != NULL)) {
+		req->bio = bio->bi_next;
+		bio_endio(bio, 0);
+	}
+}
+
+/*
  * queue lock must be held
  */
 void __blk_put_request(struct request_queue *q, struct request *req)
@@ -1066,6 +1082,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 
 	elv_completed_request(q, req);
 
+	_abort_unexecuted_bios(req);
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b92f5b0..463e797 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -398,6 +398,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_rq_cpu_valid(next))
 		req->cpu = next->cpu;
 
+	/* owner-ship of bio passed from next to req */
+	next->bio = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ee9c67d..626ee27 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -214,21 +214,10 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 	return 0;
 }
 
-/*
- * unmap a request that was previously mapped to this sg_io_hdr. handles
- * both sg and non-sg sg_io_hdr.
- */
-static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
-{
-	blk_rq_unmap_user(rq->bio);
-	blk_put_request(rq);
-	return 0;
-}
-
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
-	int r, ret = 0;
+	int ret = 0;
 
 	/*
 	 * fill in all the output members
@@ -253,12 +242,10 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	rq->bio = bio;
-	r = blk_unmap_sghdr_rq(rq, hdr);
-	if (ret)
-		r = ret;
+	blk_rq_unmap_user(bio);
+	blk_put_request(rq);
 
-	return r;
+	return ret;
 }
 
 static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
-- 
1.6.0.1
