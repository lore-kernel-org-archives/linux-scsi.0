From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement a
 kludge for SCSI blk-mq stall during probe
Date: Tue, 23 Sep 2014 15:24:32 -0400
Message-ID: <20140923192432.GA24441@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de>
 <20140923061152.GI11740@mtj.dyndns.org>
 <5421968B.7080309@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5421968B.7080309@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

blk-mq uses percpu_ref for its usage counter which tracks the number
of in-flight commands and used to synchronously drain the queue on
freeze.  percpu_ref shutdown takes measureable wallclock time as it
involves a sched RCU grace period.  This means that draining a blk-mq
takes measureable wallclock time.  One would think that this shouldn't
matter as queue shutdown should be a rare event which takes place
asynchronously w.r.t. userland.

Unfortunately, SCSI probing involves synchronously setting up and then
tearing down a lot of request_queues back-to-back for non-existent
LUNs.  This means that SCSI probing may take more than ten seconds
when scsi-mq is used.

This will be properly fixed by implementing a mechanism to keep
q->mq_usage_counter in atomic mode till genhd registration; however,
that involves rather big updates to percpu_ref which is difficult to
apply late in the devel cycle (v3.17-rc6 at the moment).  As a
stop-gap measure till the proper fix can be implemented in the next
cycle, this patch introduces __percpu_ref_kill_expedited() and makes
blk_mq_freeze_queue() use it.  This is heavy-handed but should work
for testing the experimental SCSI blk-mq implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Christoph Hellwig <hch@infradead.org>
Link: http://lkml.kernel.org/g/20140919113815.GA10791@lst.de
Fixes: add703fda981 ("blk-mq: use percpu_ref for mq usage count")
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
Hello, Jens, Christoph.

How about this one?  This is kinda ugly but should work fine in most
cases and easy to apply to v3.17 and take out during v3.18.

Thanks.

 block/blk-mq.c                  |   11 ++++++++++-
 include/linux/percpu-refcount.h |    1 +
 lib/percpu-refcount.c           |   16 ++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -120,7 +120,16 @@ void blk_mq_freeze_queue(struct request_
 	spin_unlock_irq(q->queue_lock);
 
 	if (freeze) {
-		percpu_ref_kill(&q->mq_usage_counter);
+		/*
+		 * XXX: Temporary kludge to work around SCSI blk-mq stall.
+		 * SCSI synchronously creates and destroys many queues
+		 * back-to-back during probe leading to lengthy stalls.
+		 * This will be fixed by keeping ->mq_usage_counter in
+		 * atomic mode until genhd registration, but, for now,
+		 * let's work around using expedited synchronization.
+		 */
+		__percpu_ref_kill_expedited(&q->mq_usage_counter);
+
 		blk_mq_run_queues(q, false);
 	}
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -72,6 +72,7 @@ void percpu_ref_reinit(struct percpu_ref
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
+void __percpu_ref_kill_expedited(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -189,3 +189,19 @@ void percpu_ref_kill_and_confirm(struct
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
+
+/*
+ * XXX: Temporary kludge to work around SCSI blk-mq stall.  Used only by
+ * block/blk-mq.c::blk_mq_freeze_queue().  Will be removed during v3.18
+ * devel cycle.  Do not use anywhere else.
+ */
+void __percpu_ref_kill_expedited(struct percpu_ref *ref)
+{
+	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
+		  "percpu_ref_kill() called more than once on %pf!",
+		  ref->release);
+
+	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
+	synchronize_sched_expedited();
+	percpu_ref_kill_rcu(&ref->rcu);
+}
