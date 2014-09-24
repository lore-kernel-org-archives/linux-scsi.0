From: Tejun Heo <tj@kernel.org>
Subject: [PATCH percpu/for-3.18] Revert "blk-mq, percpu_ref: implement a
 kludge for SCSI blk-mq stall during probe"
Date: Wed, 24 Sep 2014 13:20:51 -0400
Message-ID: <20140924172051.GA29067@mtj.dyndns.org>
References: <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de>
 <20140923061152.GI11740@mtj.dyndns.org>
 <5421968B.7080309@kernel.dk>
 <20140923192432.GA24441@mtj.dyndns.org>
 <20140924082348.GB8894@lst.de>
 <5422D589.5070009@kernel.dk>
 <20140924143320.GG16555@htj.dyndns.org>
 <5422D656.7020006@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5422D656.7020006@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

>From 9eca80461a45177e456219a9cd944c27675d6512 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 24 Sep 2014 13:07:33 -0400

This reverts commit 0a30288da1aec914e158c2d7a3482a85f632750f, which
was a temporary fix for SCSI blk-mq stall issue.  The following
patches will fix the issue properly by introducing atomic mode to
percpu_ref.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
---
Hello,

I pulled in block/for-linus into percpu/for-3.18 and reverted the temp
fix.  Will apply the patchset to implement the proper fix on top of
it.

Thanks.

 block/blk-mq.c                  | 11 +----------
 include/linux/percpu-refcount.h |  1 -
 lib/percpu-refcount.c           | 16 ----------------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 255d79c..44a78ae 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -119,16 +119,7 @@ void blk_mq_freeze_queue(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	if (freeze) {
-		/*
-		 * XXX: Temporary kludge to work around SCSI blk-mq stall.
-		 * SCSI synchronously creates and destroys many queues
-		 * back-to-back during probe leading to lengthy stalls.
-		 * This will be fixed by keeping ->mq_usage_counter in
-		 * atomic mode until genhd registration, but, for now,
-		 * let's work around using expedited synchronization.
-		 */
-		__percpu_ref_kill_expedited(&q->mq_usage_counter);
-
+		percpu_ref_kill(&q->mq_usage_counter);
 		blk_mq_run_queues(q, false);
 	}
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 11b38ce..5df6784 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -72,7 +72,6 @@ void percpu_ref_reinit(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
-void __percpu_ref_kill_expedited(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index c6c31e2..559ee0b 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -189,19 +189,3 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
-
-/*
- * XXX: Temporary kludge to work around SCSI blk-mq stall.  Used only by
- * block/blk-mq.c::blk_mq_freeze_queue().  Will be removed during v3.18
- * devel cycle.  Do not use anywhere else.
- */
-void __percpu_ref_kill_expedited(struct percpu_ref *ref)
-{
-	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
-		  "percpu_ref_kill() called more than once on %pf!",
-		  ref->release);
-
-	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
-	synchronize_sched_expedited();
-	percpu_ref_kill_rcu(&ref->rcu);
-}
-- 
1.9.3
