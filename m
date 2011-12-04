From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] workqueue: defer work to a draining queue
Date: Sat, 03 Dec 2011 23:12:47 -0800
Message-ID: <1322982769.30484.12.camel@ultramagnus.opencreations.com>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
	 <20111202235655.24470.24712.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:44945 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751774Ab1LDHMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2011 02:12:51 -0500
In-Reply-To: <20111202235655.24470.24712.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2011-12-02 at 15:56 -0800, Dan Williams wrote:
> commit 9c5a2ba7 "workqueue: separate out drain_workqueue() from
> destroy_workqueue()" provided drain_workqueue() for users like libsas to
> use for flushing events.

Any reason to allow drain requests to stack?  If draining is under a
mutex then we don't break workqueue semantics (at least with respect to
draining), all chained work is flushed and all unchained work is
registered in the queue.  But it still leaves deferred work invisible to
flush_workqueue().  drain_workqueue() users would need to be careful not
to mix 'flush' and 'drain'.

Untested incremental changes to implement above:

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 363a4ef..24563d6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -236,12 +236,12 @@ struct workqueue_struct {
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct mutex		drain_mutex;	/* 1 drainer at a time */
 	struct list_head	drain_defer;	/* W: unchained work to defer */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
@@ -2427,14 +2427,10 @@ static int __drain_workqueue(struct workqueue_struct *wq, int flags)
 	unsigned int cpu;
 	int ret = 0;
 
-	/*
-	 * __queue_work() needs to test whether there are drainers, is much
-	 * hotter than drain_workqueue() and already looks at @wq->flags.
-	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
-	 */
+	mutex_lock(&wq->drain_mutex);
+
 	spin_lock_irq(&workqueue_lock);
-	if (!wq->nr_drainers++)
-		wq->flags |= WQ_DRAINING | flags;
+	wq->flags |= WQ_DRAINING | flags;
 	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
@@ -2458,24 +2454,26 @@ reflush:
 	}
 
 	spin_lock_irq(&workqueue_lock);
-	if (!--wq->nr_drainers) {
-		wq->flags &= ~(WQ_DRAINING | WQ_NO_DEFER);
-		list_splice_init(&wq->drain_defer, &drain_defer);
-		ret = !list_empty(&drain_defer);
-	}
+	wq->flags &= ~(WQ_DRAINING | WQ_NO_DEFER);
+	list_splice_init(&wq->drain_defer, &drain_defer);
+	ret = !list_empty(&drain_defer);
 	spin_unlock_irq(&workqueue_lock);
 
-	/* requeue work on this queue provided it was not being destroyed */
+	/* submit deferred work provided wq was not being destroyed */
 	list_for_each_entry_safe(work, w, &drain_defer, entry) {
 		list_del_init(&work->entry);
 		queue_work(wq, work);
 	}
 
+	mutex_unlock(&wq->drain_mutex);
+
 	return ret;
 }
 
 int drain_workqueue(struct workqueue_struct *wq)
 {
+	if (WARN_ON_ONCE(wq->flags & WQ_NO_DEFER))
+		return 0; /* lost drain vs destroy race */
 	return __drain_workqueue(wq, 0);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
@@ -3032,6 +3030,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
+	mutex_init(&wq->drain_mutex);
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);


