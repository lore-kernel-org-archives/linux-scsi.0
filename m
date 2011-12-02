From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] workqueue: defer work to a draining queue
Date: Fri, 02 Dec 2011 15:56:55 -0800
Message-ID: <20111202235655.24470.24712.stgit@localhost6.localdomain6>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

commit 9c5a2ba7 "workqueue: separate out drain_workqueue() from
destroy_workqueue()" provided drain_workqueue() for users like libsas to
use for flushing events.

When libsas drains it wants currently queued and chained events to be
flushed, but it fully expects to continue issuing unchained events with
the expectation that they are serviced sometime after the drain.

For external users of drain_workqueue() let unchained work commence
after the drain completes, if the caller cares if unchained work was
queued as a result of the drain it can check for a non-zero return
value.

Unfortunately this causes the promotion of workqueue_lock to hard-irq
safe and can't support queue_work_on() users.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/workqueue.h |    3 +-
 kernel/workqueue.c        |   70 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0d556de..37de207 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -257,6 +257,7 @@ enum {
 
 	WQ_DRAINING		= 1 << 6, /* internal: workqueue is draining */
 	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */
+	WQ_NO_DEFER		= 1 << 8, /* internal: workqueue destructing */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -355,7 +356,7 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
-extern void drain_workqueue(struct workqueue_struct *wq);
+extern int drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
 extern int schedule_work(struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f476895..363a4ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -236,6 +236,7 @@ struct workqueue_struct {
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct list_head	drain_defer;	/* W: unchained work to defer */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -979,6 +980,19 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	return false;
 }
 
+static bool defer_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	if (is_chained_work(wq))
+		return false;
+
+	if (WARN_ON_ONCE(wq->flags & WQ_NO_DEFER))
+		return true;
+
+	list_add_tail(&work->entry, &wq->drain_defer);
+
+	return true;
+}
+
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
@@ -991,9 +1005,17 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 
 	/* if dying, only works from the same workqueue are allowed */
-	if (unlikely(wq->flags & WQ_DRAINING) &&
-	    WARN_ON_ONCE(!is_chained_work(wq)))
-		return;
+	if (unlikely(wq->flags & WQ_DRAINING)) {
+		unsigned long flags;
+		bool defer = false;
+
+		spin_lock_irqsave(&workqueue_lock, flags);
+		if (wq->flags & WQ_DRAINING)
+			defer = defer_work(wq, work);
+		spin_unlock_irqrestore(&workqueue_lock, flags);
+		if (defer)
+			return;
+	}
 
 	/* determine gcwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
@@ -2383,8 +2405,9 @@ out_unlock:
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /**
- * drain_workqueue - drain a workqueue
+ * __drain_workqueue - drain a workqueue
  * @wq: workqueue to drain
+ * @flags: WQ_NO_DEFER - reject unchained work
  *
  * Wait until the workqueue becomes empty.  While draining is in progress,
  * only chain queueing is allowed.  IOW, only currently pending or running
@@ -2392,11 +2415,17 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  * repeatedly until it becomes empty.  The number of flushing is detemined
  * by the depth of chaining and should be relatively short.  Whine if it
  * takes too long.
+ *
+ * Indicate to the caller if any deferred (unchained) work was queued
+ * during the drain.
  */
-void drain_workqueue(struct workqueue_struct *wq)
+static int __drain_workqueue(struct workqueue_struct *wq, int flags)
 {
+	struct work_struct *work, *w;
 	unsigned int flush_cnt = 0;
+	LIST_HEAD(drain_defer);
 	unsigned int cpu;
+	int ret = 0;
 
 	/*
 	 * __queue_work() needs to test whether there are drainers, is much
@@ -2405,7 +2434,7 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 */
 	spin_lock_irq(&workqueue_lock);
 	if (!wq->nr_drainers++)
-		wq->flags |= WQ_DRAINING;
+		wq->flags |= WQ_DRAINING | flags;
 	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
@@ -2429,9 +2458,25 @@ reflush:
 	}
 
 	spin_lock_irq(&workqueue_lock);
-	if (!--wq->nr_drainers)
-		wq->flags &= ~WQ_DRAINING;
+	if (!--wq->nr_drainers) {
+		wq->flags &= ~(WQ_DRAINING | WQ_NO_DEFER);
+		list_splice_init(&wq->drain_defer, &drain_defer);
+		ret = !list_empty(&drain_defer);
+	}
 	spin_unlock_irq(&workqueue_lock);
+
+	/* requeue work on this queue provided it was not being destroyed */
+	list_for_each_entry_safe(work, w, &drain_defer, entry) {
+		list_del_init(&work->entry);
+		queue_work(wq, work);
+	}
+
+	return ret;
+}
+
+int drain_workqueue(struct workqueue_struct *wq)
+{
+	return __drain_workqueue(wq, 0);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -2990,6 +3035,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
+	INIT_LIST_HEAD(&wq->drain_defer);
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -3065,8 +3111,12 @@ void destroy_workqueue(struct workqueue_struct *wq)
 {
 	unsigned int cpu;
 
-	/* drain it before proceeding with destruction */
-	drain_workqueue(wq);
+	/*
+	 * drain it before proceeding with destruction and disable drain
+	 * deferrement.  !is_chained_work() that arrives after this
+	 * point will be dropped on the floor
+	 */
+	__drain_workqueue(wq, WQ_NO_DEFER);
 
 	/*
 	 * wq list is used to freeze wq, remove from list after
