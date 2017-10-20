From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/6] block: convert io_context.active_ref from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 11:16:00 +0300
Message-ID: <1508487362-26663-5-git-send-email-elena.reshetova@intel.com>
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

The variable io_context.active_ref is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 block/bfq-iosched.c       | 2 +-
 block/blk-ioc.c           | 4 ++--
 block/cfq-iosched.c       | 4 ++--
 include/linux/iocontext.h | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a4783da..1ec9b22 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4030,7 +4030,7 @@ static void bfq_update_has_short_ttime(struct bfq_data *bfqd,
 	 * bfqq. Otherwise check average think time to
 	 * decide whether to mark as has_short_ttime
 	 */
-	if (atomic_read(&bic->icq.ioc->active_ref) == 0 ||
+	if (refcount_read(&bic->icq.ioc->active_ref) == 0 ||
 	    (bfq_sample_valid(bfqq->ttime.ttime_samples) &&
 	     bfqq->ttime.ttime_mean > bfqd->bfq_slice_idle))
 		has_short_ttime = false;
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 63898d2..69704d2 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -176,7 +176,7 @@ void put_io_context_active(struct io_context *ioc)
 	unsigned long flags;
 	struct io_cq *icq;
 
-	if (!atomic_dec_and_test(&ioc->active_ref)) {
+	if (!refcount_dec_and_test(&ioc->active_ref)) {
 		put_io_context(ioc);
 		return;
 	}
@@ -275,7 +275,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
 	atomic_set(&ioc->nr_tasks, 1);
-	atomic_set(&ioc->active_ref, 1);
+	refcount_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9f342ef..e6d5d6d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2941,7 +2941,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !atomic_read(&cic->icq.ioc->active_ref))
+	if (!cic || !refcount_read(&cic->icq.ioc->active_ref))
 		return;
 
 	/*
@@ -3933,7 +3933,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	if (cfqq->next_rq && req_noidle(cfqq->next_rq))
 		enable_idle = 0;
-	else if (!atomic_read(&cic->icq.ioc->active_ref) ||
+	else if (!refcount_read(&cic->icq.ioc->active_ref) ||
 		 !cfqd->cfq_slice_idle ||
 		 (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index df38db2..a1e28c3 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -3,6 +3,7 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 
 enum {
@@ -96,7 +97,7 @@ struct io_cq {
  */
 struct io_context {
 	atomic_long_t refcount;
-	atomic_t active_ref;
+	refcount_t active_ref;
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -128,9 +129,9 @@ struct io_context {
 static inline void get_io_context_active(struct io_context *ioc)
 {
 	WARN_ON_ONCE(atomic_long_read(&ioc->refcount) <= 0);
-	WARN_ON_ONCE(atomic_read(&ioc->active_ref) <= 0);
+	WARN_ON_ONCE(refcount_read(&ioc->active_ref) == 0);
 	atomic_long_inc(&ioc->refcount);
-	atomic_inc(&ioc->active_ref);
+	refcount_inc(&ioc->active_ref);
 }
 
 static inline void ioc_task_link(struct io_context *ioc)
-- 
2.7.4
