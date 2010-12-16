From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Thu, 16 Dec 2010 16:51:18 +0100
Message-ID: <4D0A3576.7040908@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org>	 <1292440246.4688.416.camel@mulgrave.site>  <4D0914B5.20208@kernel.org>	 <1292441610.4688.457.camel@mulgrave.site>  <4D091A20.3060202@kernel.org> <1292510372.3024.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292510372.3024.12.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On 12/16/2010 03:39 PM, James Bottomley wrote:
>> But, anyways, I don't think that's gonna happen here.  If the last put
>> hasn't been executed the module reference wouldn't be zero, so module
>> unload can't initiate, right?
> 
> Wrong I'm afraid.  There's a nasty two level complexity in module
> references:  Anything which takes an external reference (like open or
> mount) does indeed take the module reference and prevent removal.
> Anything that takes an internal reference doesn't ... we wait for all of
> them to come back in the final removal of the bus type.  The is to
> prevent a module removal deadlock.  The callbacks are internal
> references, so we wait for them in module_exit() but don't block
> module_exit() from being called ... meaning the double callback scenario
> could be outstanding.

Okay, so something like the following should solve the problem.  Once
destroy_workqueue() is called, queueing is allowed from only the same
workqueue and flush is repeated until the queue is drained, which
seems to be the right thing to do on destruction regardless of the
SCSI changes.

With the following change, the previous patch should do fine for SCSI
and the ew can be removed.  Please note that the following patch is
still only compile tested.

Are we in agreement now?

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..8dd0b80 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -932,6 +932,32 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 		wake_up_worker(gcwq);
 }

+/*
+ * Test whether @work is being queued from another work executing on the
+ * same workqueue.
+ */
+static bool is_chained_work(struct work_struct *work)
+{
+	struct workqueue_struct *wq = get_work_cwq(work)->wq;
+	unsigned long flags;
+	unsigned int cpu;
+
+	for_each_gcwq_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker *worker;
+
+		spin_lock_irqsave(&gcwq->lock, flags);
+		worker = find_worker_executing_work(gcwq, work);
+		if (worker && worker->task == current &&
+		    worker->current_cwq->wq == wq) {
+			spin_unlock_irqrestore(&gcwq->lock, flags);
+			return true;
+		}
+		spin_unlock_irqrestore(&gcwq->lock, flags);
+	}
+	return false;
+}
+
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
@@ -943,7 +969,8 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,

 	debug_work_activate(work);

-	if (WARN_ON_ONCE(wq->flags & WQ_DYING))
+	/* if dying, only works from the same workqueue are allowed */
+	if (WARN_ON_ONCE((wq->flags & WQ_DYING) && !is_chained_work(work)))
 		return;

 	/* determine gcwq to use */
@@ -2936,11 +2963,34 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	unsigned int flush_cnt = 0;
 	unsigned int cpu;

+	/*
+	 * Mark @wq dying and drain all pending works.  Once WQ_DYING is
+	 * set, only chain queueing is allowed.  IOW, only currently
+	 * pending or running works on @wq can queue further works on it.
+	 * @wq is flushed repeatedly until it becomes empty.  The number of
+	 * flushing is detemined by the depth of chaining and should be
+	 * relatively short.  Whine if it takes too long.
+	 */
 	wq->flags |= WQ_DYING;
+reflush:
 	flush_workqueue(wq);

+	for_each_cwq_cpu(cpu, wq) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+			continue;
+
+		if (flush_cnt++ == 10 || flush_cnt % 100 == 0)
+			printk(KERN_WARNING "workqueue %s: flush on "
+			       "destruction isn't complete after %u tries\n",
+			       wq->name, flush_cnt);
+		goto reflush;
+	}
+
 	/*
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
