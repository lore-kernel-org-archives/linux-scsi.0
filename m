From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/6] block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 11:15:58 +0300
Message-ID: <1508487362-26663-3-git-send-email-elena.reshetova@intel.com>
References: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-Id: linux-scsi@vger.kernel.org

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable blk_queue_tag.refcnt is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 block/blk-tag.c        | 8 ++++----
 include/linux/blkdev.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e1a9c15..a7263e3 100644
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
index 02fa42d..1fefdbb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -26,6 +26,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/blkzoned.h>
+#include <linux/refcount.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -295,7 +296,7 @@ struct blk_queue_tag {
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
