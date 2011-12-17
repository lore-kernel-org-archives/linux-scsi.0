From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/24] workqueue: defer work to a draining queue
Date: Fri, 16 Dec 2011 18:33:18 -0800
Message-ID: <20111217023318.15036.77389.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

commit 9c5a2ba7 "workqueue: separate out drain_workqueue() from
destroy_workqueue()" provided drain_workqueue() for users like libsas to
use for flushing events.

When libsas drains it wants currently queued and chained events to be
flushed, but it fully expects to continue issuing unchained events with
the expectation that they are serviced sometime after the drain.

For external users of drain_workqueue() arrange for unchained work to be
queued after the drain completes, if the caller cares if unchained work
was queued as a result of the drain it can check for a non-zero return
value.  Deferred work is guaranteed to be at least queued when
drain_workqueue() returns, and visible to flush_workqueue() users as
well.

Unfortunately this causes the promotion of workqueue_lock to hard-irq
safe and does not guarantee that work submitted via queue_work_on() runs
on the specified cpu if it gets deferred.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/workqueue.h |    3 +
 kernel/workqueue.c        |   97 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 79 insertions(+), 21 deletions(-)

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
index 247c59d..fc4687a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -236,11 +236,12 @@ struct workqueue_struct {
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct mutex		drain_mutex;	/* 1 drainer at a time */
+	struct list_head	drain_defer;	/* W: unchained work to defer */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
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
@@ -2227,7 +2249,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 }
 
 /**
- * flush_workqueue - ensure that any scheduled work has run to completion.
+ * __flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
  *
  * Forces execution of the workqueue and blocks until its completion.
@@ -2236,7 +2258,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
  * We sleep until all works which were queued on entry have been handled,
  * but we are not livelocked by new incoming ones.
  */
-void flush_workqueue(struct workqueue_struct *wq)
+static void __flush_workqueue(struct workqueue_struct *wq)
 {
 	struct wq_flusher this_flusher = {
 		.list = LIST_HEAD_INIT(this_flusher.list),
@@ -2380,11 +2402,20 @@ void flush_workqueue(struct workqueue_struct *wq)
 out_unlock:
 	mutex_unlock(&wq->flush_mutex);
 }
+
+
+void flush_workqueue(struct workqueue_struct *wq)
+{
+	mutex_lock(&wq->drain_mutex);
+	__flush_workqueue(wq);
+	mutex_unlock(&wq->drain_mutex);
+}
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /**
- * drain_workqueue - drain a workqueue
+ * __drain_workqueue - drain a workqueue
  * @wq: workqueue to drain
+ * @flags: WQ_NO_DEFER - reject unchained work
  *
  * Wait until the workqueue becomes empty.  While draining is in progress,
  * only chain queueing is allowed.  IOW, only currently pending or running
@@ -2392,23 +2423,25 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
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
+
+	mutex_lock(&wq->drain_mutex);
 
-	/*
-	 * __queue_work() needs to test whether there are drainers, is much
-	 * hotter than drain_workqueue() and already looks at @wq->flags.
-	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
-	 */
 	spin_lock_irq(&workqueue_lock);
-	if (!wq->nr_drainers++)
-		wq->flags |= WQ_DRAINING;
+	wq->flags |= WQ_DRAINING | flags;
 	spin_unlock_irq(&workqueue_lock);
 reflush:
-	flush_workqueue(wq);
+	__flush_workqueue(wq);
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
@@ -2429,9 +2462,27 @@ reflush:
 	}
 
 	spin_lock_irq(&workqueue_lock);
-	if (!--wq->nr_drainers)
-		wq->flags &= ~WQ_DRAINING;
+	wq->flags &= ~(WQ_DRAINING | WQ_NO_DEFER);
+	list_splice_init(&wq->drain_defer, &drain_defer);
+	ret = !list_empty(&drain_defer);
 	spin_unlock_irq(&workqueue_lock);
+
+	/* submit deferred work provided wq was not being destroyed */
+	list_for_each_entry_safe(work, w, &drain_defer, entry) {
+		list_del_init(&work->entry);
+		queue_work(wq, work);
+	}
+
+	mutex_unlock(&wq->drain_mutex);
+
+	return ret;
+}
+
+int drain_workqueue(struct workqueue_struct *wq)
+{
+	if (WARN_ON_ONCE(wq->flags & WQ_NO_DEFER))
+		return 0; /* lost drain vs destroy race */
+	return __drain_workqueue(wq, 0);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -2987,9 +3038,11 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
+	mutex_init(&wq->drain_mutex);
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
+	INIT_LIST_HEAD(&wq->drain_defer);
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -3065,8 +3118,12 @@ void destroy_workqueue(struct workqueue_struct *wq)
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

