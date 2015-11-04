From: mchristi@redhat.com
Subject: [PATCH 11/32] gfs2: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:08 -0600
Message-ID: <1446674909-5371-12-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031070AbbKDWIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 17:08:48 -0500
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

This patch prepares gfs2's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/gfs2/log.c  |  8 ++++----
 fs/gfs2/lops.c | 11 ++++++-----
 fs/gfs2/lops.h |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 536e7a6..8324af5 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -657,7 +657,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	struct gfs2_log_header *lh;
 	unsigned int tail;
 	u32 hash;
-	int rw = WRITE_FLUSH_FUA | REQ_META;
+	int op_flags = WRITE_FLUSH_FUA | REQ_META;
 	struct page *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 	enum gfs2_freeze_state state = atomic_read(&sdp->sd_freeze_state);
 	lh = page_address(page);
@@ -682,12 +682,12 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags)) {
 		gfs2_ordered_wait(sdp);
 		log_flush_wait(sdp);
-		rw = WRITE_SYNC | REQ_META | REQ_PRIO;
+		op_flags = WRITE_SYNC | REQ_META | REQ_PRIO;
 	}
 
 	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
 	gfs2_log_write_page(sdp, page);
-	gfs2_log_flush_bio(sdp, rw);
+	gfs2_log_flush_bio(sdp, REQ_OP_WRITE, op_flags);
 	log_flush_wait(sdp);
 
 	if (sdp->sd_log_tail != tail)
@@ -735,7 +735,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
 
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp, tr);
-	gfs2_log_flush_bio(sdp, WRITE);
+	gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
 		log_flush_wait(sdp);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index d5369a1..36b047a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -230,17 +230,18 @@ static void gfs2_end_log_write(struct bio *bio)
 /**
  * gfs2_log_flush_bio - Submit any pending log bio
  * @sdp: The superblock
- * @rw: The rw flags
+ * @op: REQ_OP
+ * @op_flags: rq_flag_bits
  *
  * Submit any pending part-built or full bio to the block device. If
  * there is no pending bio, then this is a no-op.
  */
 
-void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw)
+void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int op, int op_flags)
 {
 	if (sdp->sd_log_bio) {
 		atomic_inc(&sdp->sd_log_in_flight);
-		submit_bio(rw, sdp->sd_log_bio);
+		submit_bio(op | op_flags, sdp->sd_log_bio);
 		sdp->sd_log_bio = NULL;
 	}
 }
@@ -299,7 +300,7 @@ static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno)
 		nblk >>= sdp->sd_fsb2bb_shift;
 		if (blkno == nblk)
 			return bio;
-		gfs2_log_flush_bio(sdp, WRITE);
+		gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 	}
 
 	return gfs2_log_alloc_bio(sdp, blkno);
@@ -328,7 +329,7 @@ static void gfs2_log_write(struct gfs2_sbd *sdp, struct page *page,
 	bio = gfs2_log_get_bio(sdp, blkno);
 	ret = bio_add_page(bio, page, size, offset);
 	if (ret == 0) {
-		gfs2_log_flush_bio(sdp, WRITE);
+		gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 		bio = gfs2_log_alloc_bio(sdp, blkno);
 		ret = bio_add_page(bio, page, size, offset);
 		WARN_ON(ret == 0);
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index a65a7ba..e529f53 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -27,7 +27,7 @@ extern const struct gfs2_log_operations gfs2_databuf_lops;
 
 extern const struct gfs2_log_operations *gfs2_log_ops[];
 extern void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page);
-extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw);
+extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int op, int op_flags);
 extern void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
 
 static inline unsigned int buf_limit(struct gfs2_sbd *sdp)
-- 
1.8.3.1

