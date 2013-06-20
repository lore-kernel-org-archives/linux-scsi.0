From: Matthew Wilcox <willy@linux.intel.com>
Subject: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Thu, 20 Jun 2013 16:17:13 -0400
Message-ID: <20130620201713.GV8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


A paper at FAST2012
(http://static.usenix.org/events/fast12/tech/full_papers/Yang.pdf) pointed
out the performance overhead of taking interrupts for low-latency block
I/Os.  The solution the author investigated was to spin waiting for each
I/O to complete.  This is inefficient as Linux submits many I/Os which
are not latency-sensitive, and even when we do submit latency-sensitive
I/Os (eg swap-in), we frequently submit several I/Os before waiting.

This RFC takes a different approach, only spinning when we would
otherwise sleep.  To implement this, I add an 'io_poll' function pointer
to backing_dev_info.  I include a sample implementation for the NVMe
driver.  Next, I add an io_wait() function which will call io_poll()
if it is set.  It falls back to calling io_schedule() if anything goes
wrong with io_poll() or the task exceeds its timeslice.  Finally, all
that is left is to judiciously replace calls to io_schedule() with
calls to io_wait().  I think I've covered the main contenders with
sleep_on_page(), sleep_on_buffer() and the DIO path.

I've measured the performance benefits of this with a Chatham NVMe
prototype device and a simple
# dd if=/dev/nvme0n1 of=/dev/null iflag=direct bs=512 count=1000000
The latency of each I/O reduces by about 2.5us (from around 8.0us to
around 5.5us).  This matches up quite well with the performance numbers
shown in the FAST2012 paper (which used a similar device).

Is backing_dev_info the right place for this function pointer?
Have I made any bad assumptions about the correct way to retrieve
the backing_dev_info from (eg) a struct page, buffer_head or kiocb?
Should I pass a 'state' into io_wait() instead of retrieving it from
'current'?  Is kernel/sched/core.c the right place for io_wait()?
Should it be bdi_wait() instead?  Should it be marked with __sched?
Where should I add documentation for the io_poll() function pointer?

NB: The NVMe driver piece of this is for illustrative purposes only and
should not be applied.  I've rearranged the diff so that the interesting
pieces appear first.

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c388155..97f8fde 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -68,6 +68,7 @@ struct backing_dev_info {
 	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
+	int (*io_poll)(struct backing_dev_info *);
 
 	char *name;
 
@@ -126,6 +127,8 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
 void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
 
+void io_wait(struct backing_dev_info *bdi);
+
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..4840065 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4527,6 +4527,36 @@ long __sched io_schedule_timeout(long timeout)
 	return ret;
 }
 
+/*
+ * Wait for an I/O to complete against this backing_dev_info.  If the
+ * task exhausts its timeslice polling for completions, call io_schedule()
+ * anyway.  If a signal comes pending, return so the task can handle it.
+ * If the io_poll returns an error, give up and call io_schedule(), but
+ * swallow the error.  We may miss an I/O completion (eg if the interrupt
+ * handler gets to it first).  Guard against this possibility by returning
+ * if we've been set back to TASK_RUNNING.
+ */
+void io_wait(struct backing_dev_info *bdi)
+{
+	if (bdi && bdi->io_poll) {
+		long state = current->state;
+		while (!need_resched()) {
+			int ret = bdi->io_poll(bdi);
+			if ((ret > 0) || signal_pending_state(state, current)) {
+				set_current_state(TASK_RUNNING);
+				return;
+			}
+			if (current->state == TASK_RUNNING)
+				return;
+			if (ret < 0)
+				break;
+			cpu_relax();
+		}
+	}
+
+	io_schedule();
+}
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
diff --git a/fs/aio.c b/fs/aio.c
index 2bbcacf..7b20397 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -453,11 +453,15 @@ static void kill_ioctx(struct kioctx *ctx)
  */
 ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 {
+	struct backing_dev_info *bdi = NULL;
+
+	if (iocb->ki_filp)
+		bdi = iocb->ki_filp->f_mapping->backing_dev_info;
 	while (atomic_read(&iocb->ki_users)) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!atomic_read(&iocb->ki_users))
 			break;
-		io_schedule();
+		io_wait(bdi);
 	}
 	__set_current_state(TASK_RUNNING);
 	return iocb->ki_user_data;
diff --git a/fs/buffer.c b/fs/buffer.c
index d2a4d1b..4502909 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -63,7 +63,13 @@ EXPORT_SYMBOL(touch_buffer);
 
 static int sleep_on_buffer(void *word)
 {
-	io_schedule();
+	struct buffer_head *bh;
+	struct backing_dev_info *bdi = NULL;
+
+	bh = container_of(word, struct buffer_head, b_state);
+	if (bh->b_assoc_map)
+		bdi = bh->b_assoc_map->backing_dev_info;
+	io_wait(bdi);
 	return 0;
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7ab90f5..5a0fe06 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -410,6 +410,8 @@ static struct bio *dio_await_one(struct dio *dio)
 {
 	unsigned long flags;
 	struct bio *bio = NULL;
+	struct address_space *mapping = dio->iocb->ki_filp->f_mapping;
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 
@@ -423,7 +425,7 @@ static struct bio *dio_await_one(struct dio *dio)
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		dio->waiter = current;
 		spin_unlock_irqrestore(&dio->bio_lock, flags);
-		io_schedule();
+		io_wait(bdi);
 		/* wake up sets us TASK_RUNNING */
 		spin_lock_irqsave(&dio->bio_lock, flags);
 		dio->waiter = NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index 7905fe7..25d3d51 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -178,7 +178,14 @@ EXPORT_SYMBOL(delete_from_page_cache);
 
 static int sleep_on_page(void *word)
 {
-	io_schedule();
+	struct page *page = container_of(word, struct page, flags);
+	struct backing_dev_info *bdi = NULL;
+	struct address_space *mapping = page->mapping;
+
+	if (mapping && !((unsigned long)mapping & 1))
+		bdi = mapping->backing_dev_info;
+
+	io_wait(bdi);
 	return 0;
 }
 
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ce79a59..8fe4f27 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -79,7 +82,8 @@ struct nvme_queue {
 	u16 sq_head;
 	u16 sq_tail;
 	u16 cq_head;
-	u16 cq_phase;
+	u8 cq_phase;
+	u8 irq_processed;
 	unsigned long cmdid_data[];
 };
 
@@ -727,7 +732,7 @@ static void nvme_make_request(struct request_queue *q, struct bio *bio)
 	put_nvmeq(nvmeq);
 }
 
-static irqreturn_t nvme_process_cq(struct nvme_queue *nvmeq)
+static int nvme_process_cq(struct nvme_queue *nvmeq)
 {
 	u16 head, phase;
 
@@ -758,13 +767,14 @@ static irqreturn_t nvme_process_cq(struct nvme_queue *nvmeq)
 	 * a big problem.
 	 */
 	if (head == nvmeq->cq_head && phase == nvmeq->cq_phase)
-		return IRQ_NONE;
+		return 0;
 
 	writel(head, nvmeq->q_db + (1 << nvmeq->dev->db_stride));
 	nvmeq->cq_head = head;
 	nvmeq->cq_phase = phase;
 
-	return IRQ_HANDLED;
+	nvmeq->irq_processed = 1;
+	return 1;
 }
 
 static irqreturn_t nvme_irq(int irq, void *data)
@@ -772,7 +782,9 @@ static irqreturn_t nvme_irq(int irq, void *data)
 	irqreturn_t result;
 	struct nvme_queue *nvmeq = data;
 	spin_lock(&nvmeq->q_lock);
-	result = nvme_process_cq(nvmeq);
+	nvme_process_cq(nvmeq);
+	result = nvmeq->irq_processed ? IRQ_HANDLED : IRQ_NONE;
+	nvmeq->irq_processed = 0;
 	spin_unlock(&nvmeq->q_lock);
 	return result;
 }
@@ -1556,6 +1567,27 @@ static void nvme_config_discard(struct nvme_ns *ns)
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, ns->queue);
 }
 
+static int nvme_io_poll(struct backing_dev_info *bdi)
+{
+	struct request_queue *q = container_of(bdi, struct request_queue,
+							backing_dev_info);
+	struct nvme_ns *ns = q->queuedata;
+	struct nvme_dev *dev = ns->dev;
+	int i, found = 0;
+
+	for (i = 1; i < dev->queue_count; i++) {
+		struct nvme_queue *nvmeq = dev->queues[i];
+		if (!nvmeq)
+			continue;
+		spin_lock_irq(&nvmeq->q_lock);
+		if (nvme_process_cq(nvmeq))
+			found++;
+		spin_unlock_irq(&nvmeq->q_lock);
+	}
+
+	return found;
+}
+
 static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 			struct nvme_id_ns *id, struct nvme_lba_range_type *rt)
 {
@@ -1578,6 +1610,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 	blk_queue_make_request(ns->queue, nvme_make_request);
 	ns->dev = dev;
 	ns->queue->queuedata = ns;
+	ns->queue->backing_dev_info.io_poll = nvme_io_poll;
 
 	disk = alloc_disk(NVME_MINORS);
 	if (!disk)
