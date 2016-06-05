From: mchristi@redhat.com
Subject: [PATCH 35/45] block: convert merge/insert code to
	check for REQ_OPs.
Date: Sun,  5 Jun 2016 14:32:15 -0500
Message-ID: <1465155145-10812-36-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch converts the block layer merging code to use separate variables
for the operation and flags, and to check req_op for the REQ_OP.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-core.c       |  2 +-
 block/blk-merge.c      | 10 ++++++----
 include/linux/blkdev.h | 20 ++++++++++----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 090e55d..1333bb7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2161,7 +2161,7 @@ EXPORT_SYMBOL(submit_bio);
 static int blk_cloned_rq_check_limits(struct request_queue *q,
 				      struct request *rq)
 {
-	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
+	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, req_op(rq))) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5a03f96..c265348 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -649,7 +649,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
-	if (!blk_check_merge_flags(req->cmd_flags, next->cmd_flags))
+	if (!blk_check_merge_flags(req->cmd_flags, req_op(req), next->cmd_flags,
+				   req_op(next)))
 		return 0;
 
 	/*
@@ -663,7 +664,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || req_no_special_merge(next))
 		return 0;
 
-	if (req->cmd_flags & REQ_WRITE_SAME &&
+	if (req_op(req) == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(req->bio, next->bio))
 		return 0;
 
@@ -751,7 +752,8 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
-	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
+	if (!blk_check_merge_flags(rq->cmd_flags, req_op(rq), bio->bi_rw,
+				   bio_op(bio)))
 		return false;
 
 	/* different data direction or already started, don't merge */
@@ -767,7 +769,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 
 	/* must be using the same buffer */
-	if (rq->cmd_flags & REQ_WRITE_SAME &&
+	if (req_op(rq) == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(rq->bio, bio))
 		return false;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8c78aca..25f01ff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -666,16 +666,16 @@ static inline bool rq_mergeable(struct request *rq)
 	return true;
 }
 
-static inline bool blk_check_merge_flags(unsigned int flags1,
-					 unsigned int flags2)
+static inline bool blk_check_merge_flags(unsigned int flags1, unsigned int op1,
+					 unsigned int flags2, unsigned int op2)
 {
-	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
+	if ((op1 == REQ_OP_DISCARD) != (op2 == REQ_OP_DISCARD))
 		return false;
 
 	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
 		return false;
 
-	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
+	if ((op1 == REQ_OP_WRITE_SAME) != (op2 == REQ_OP_WRITE_SAME))
 		return false;
 
 	return true;
@@ -887,12 +887,12 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 }
 
 static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     unsigned int cmd_flags)
+						     int op)
 {
-	if (unlikely(cmd_flags & REQ_DISCARD))
+	if (unlikely(op == REQ_OP_DISCARD))
 		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-	if (unlikely(cmd_flags & REQ_WRITE_SAME))
+	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
 
 	return q->limits.max_sectors;
@@ -919,11 +919,11 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 	if (unlikely(rq->cmd_type != REQ_TYPE_FS))
 		return q->limits.max_hw_sectors;
 
-	if (!q->limits.chunk_sectors || (rq->cmd_flags & REQ_DISCARD))
-		return blk_queue_get_max_sectors(q, rq->cmd_flags);
+	if (!q->limits.chunk_sectors || (req_op(rq) == REQ_OP_DISCARD))
+		return blk_queue_get_max_sectors(q, req_op(rq));
 
 	return min(blk_max_size_offset(q, blk_rq_pos(rq)),
-			blk_queue_get_max_sectors(q, rq->cmd_flags));
+			blk_queue_get_max_sectors(q, req_op(rq)));
 }
 
 static inline unsigned int blk_rq_count_bios(struct request *rq)
-- 
2.7.2
