From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/5] block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
Date: Thu, 20 Apr 2017 14:27:21 +0300
Message-ID: <1492687644-4405-3-git-send-email-elena.reshetova@intel.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 block/blk-tag.c        | 8 ++++----
 include/linux/blkdev.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 07cc329..d83555e 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL(blk_queue_find_tag);
  */
 void blk_free_tags(struct blk_queue_tag *bqt)
 {
-	if (atomic_dec_and_test(&bqt->refcnt)) {
+	if (refcount_dec_and_test(&bqt->refcnt)) {
 		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
 							bqt->max_depth);
 
@@ -130,7 +130,7 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	atomic_set(&tags->refcnt, 1);
+	refcount_set(&tags->refcnt, 1);
 	tags->alloc_policy = alloc_policy;
 	tags->next_tag = 0;
 	return tags;
@@ -180,7 +180,7 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
 		queue_flag_set(QUEUE_FLAG_QUEUED, q);
 		return 0;
 	} else
-		atomic_inc(&tags->refcnt);
+		refcount_inc(&tags->refcnt);
 
 	/*
 	 * assign it, all done
@@ -225,7 +225,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	 * Currently cannot replace a shared tag map with a new
 	 * one, so error out if this is the case
 	 */
-	if (atomic_read(&bqt->refcnt) != 1)
+	if (refcount_read(&bqt->refcnt) != 1)
 		return -EBUSY;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aecca0e..95ef11c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -25,6 +25,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/blkzoned.h>
+#include <linux/refcount.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -288,7 +289,7 @@ struct blk_queue_tag {
 	unsigned long *tag_map;		/* bit map of free/busy tags */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
-	atomic_t refcnt;		/* map can be shared */
+	refcount_t refcnt;		/* map can be shared */
 	int alloc_policy;		/* tag allocation policy */
 	int next_tag;			/* next tag */
 };
-- 
2.7.4
