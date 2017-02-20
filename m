From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/5] block: convert blkcg_gq.refcnt from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 13:16:06 +0200
Message-ID: <1487589368-17666-4-git-send-email-elena.reshetova@intel.com>
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
 block/blk-cgroup.c         |  2 +-
 include/linux/blk-cgroup.h | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 295e98c2..75de844 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -106,7 +106,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
-	atomic_set(&blkg->refcnt, 1);
+	refcount_set(&blkg->refcnt, 1);
 
 	/* root blkg uses @q->root_rl, init rl only for !root blkgs */
 	if (blkcg != &blkcg_root) {
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 01b62e7..0d3efa9 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/blkdev.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
 #define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
@@ -122,7 +123,7 @@ struct blkcg_gq {
 	struct request_list		rl;
 
 	/* reference count */
-	atomic_t			refcnt;
+	refcount_t			refcnt;
 
 	/* is this blkg online? protected by both blkcg and q locks */
 	bool				online;
@@ -354,8 +355,8 @@ static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
  */
 static inline void blkg_get(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	atomic_inc(&blkg->refcnt);
+	WARN_ON_ONCE(refcount_read(&blkg->refcnt) == 0);
+	refcount_inc(&blkg->refcnt);
 }
 
 void __blkg_release_rcu(struct rcu_head *rcu);
@@ -366,8 +367,8 @@ void __blkg_release_rcu(struct rcu_head *rcu);
  */
 static inline void blkg_put(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	if (atomic_dec_and_test(&blkg->refcnt))
+	WARN_ON_ONCE(refcount_read(&blkg->refcnt) == 0);
+	if (refcount_dec_and_test(&blkg->refcnt))
 		call_rcu(&blkg->rcu_head, __blkg_release_rcu);
 }
 
-- 
2.7.4
