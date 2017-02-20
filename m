From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/5] block: convert io_context.active_ref from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 13:16:07 +0200
Message-ID: <1487589368-17666-5-git-send-email-elena.reshetova@intel.com>
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
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
 block/blk-ioc.c           | 4 ++--
 block/cfq-iosched.c       | 4 ++--
 include/linux/iocontext.h | 7 ++++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index b12f9c8..130dc23 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -173,7 +173,7 @@ void put_io_context_active(struct io_context *ioc)
 	unsigned long flags;
 	struct io_cq *icq;
 
-	if (!atomic_dec_and_test(&ioc->active_ref)) {
+	if (!refcount_dec_and_test(&ioc->active_ref)) {
 		put_io_context(ioc);
 		return;
 	}
@@ -256,7 +256,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
 	atomic_set(&ioc->nr_tasks, 1);
-	atomic_set(&ioc->active_ref, 1);
+	refcount_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9212627..2871bb9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2959,7 +2959,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !atomic_read(&cic->icq.ioc->active_ref))
+	if (!cic || !refcount_read(&cic->icq.ioc->active_ref))
 		return;
 
 	/*
@@ -3959,7 +3959,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
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
