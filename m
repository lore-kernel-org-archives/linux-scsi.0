From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] libsas: remove task_collector mode
Date: Mon, 24 Nov 2014 09:41:42 +0100
Message-ID: <1416818502-19584-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaKXIly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 03:41:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Chen Gang <gang.chen.5i5j@gmail.com>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>

The task_collector mode (or "latency_injector", (C) Dan Willians) is an
optional I/O path in libsas that queues up scsi commands instead of
directly sending it to the hardware.  It generall increases latencies
to in the optiomal case slightly reduce mmio traffic to the hardware.

Only the obsolete aic94xx driver and the mvsas driver allowed to use
it without recompiling the kernel, and most drivers didn't support it
at all.

Remove the giant blob of code to allow better optimizations for scsi-mq
in the future.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/libsas.txt       |  82 +----------------
 drivers/scsi/aic94xx/aic94xx.h      |   2 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c  |   3 +-
 drivers/scsi/aic94xx/aic94xx_init.c |  11 ---
 drivers/scsi/aic94xx/aic94xx_task.c |  13 ++-
 drivers/scsi/isci/init.c            |   2 -
 drivers/scsi/isci/task.c            | 147 ++++++++++++++----------------
 drivers/scsi/isci/task.h            |   1 -
 drivers/scsi/libsas/sas_ata.c       |   9 +-
 drivers/scsi/libsas/sas_expander.c  |   2 +-
 drivers/scsi/libsas/sas_init.c      |  21 -----
 drivers/scsi/libsas/sas_internal.h  |   2 -
 drivers/scsi/libsas/sas_scsi_host.c | 176 +-----------------------------------
 drivers/scsi/mvsas/mv_init.c        |  22 -----
 drivers/scsi/mvsas/mv_sas.c         | 109 +---------------------
 drivers/scsi/mvsas/mv_sas.h         |  10 +-
 drivers/scsi/pm8001/pm8001_init.c   |   2 -
 drivers/scsi/pm8001/pm8001_sas.c    |  22 +----
 drivers/scsi/pm8001/pm8001_sas.h    |   3 +-
 include/scsi/libsas.h               |  14 +--
 20 files changed, 97 insertions(+), 556 deletions(-)

diff --git a/Documentation/scsi/libsas.txt b/Documentation/scsi/libsas.txt
index 3cc9c78..8cac649 100644
--- a/Documentation/scsi/libsas.txt
+++ b/Documentation/scsi/libsas.txt
@@ -226,9 +226,6 @@ static int register_sas_ha(struct my_sas_ha *my_ha)
 	my_ha->sas_ha.lldd_dev_found = my_dev_found;
 	my_ha->sas_ha.lldd_dev_gone = my_dev_gone;
 
-	my_ha->sas_ha.lldd_max_execute_num = lldd_max_execute_num; (1)
-
-	my_ha->sas_ha.lldd_queue_size = ha_can_queue;
 	my_ha->sas_ha.lldd_execute_task = my_execute_task;
 
 	my_ha->sas_ha.lldd_abort_task     = my_abort_task;
@@ -247,28 +244,6 @@ static int register_sas_ha(struct my_sas_ha *my_ha)
 	return sas_register_ha(&my_ha->sas_ha);
 }
 
-(1) This is normally a LLDD parameter, something of the
-lines of a task collector.  What it tells the SAS Layer is
-whether the SAS layer should run in Direct Mode (default:
-value 0 or 1) or Task Collector Mode (value greater than 1).
-
-In Direct Mode, the SAS Layer calls Execute Task as soon as
-it has a command to send to the SDS, _and_ this is a single
-command, i.e. not linked.
-
-Some hardware (e.g. aic94xx) has the capability to DMA more
-than one task at a time (interrupt) from host memory.  Task
-Collector Mode is an optional feature for HAs which support
-this in their hardware.  (Again, it is completely optional
-even if your hardware supports it.)
-
-In Task Collector Mode, the SAS Layer would do _natural_
-coalescing of tasks and at the appropriate moment it would
-call your driver to DMA more than one task in a single HA
-interrupt. DMBS may want to use this by insmod/modprobe
-setting the lldd_max_execute_num to something greater than
-1.
-
 (2) SAS 1.1 does not define I_T Nexus Reset TMF.
 
 Events
@@ -325,71 +300,22 @@ PHYE_SPINUP_HOLD -- SATA is present, COMWAKE not sent.
 
 The Execute Command SCSI RPC:
 
-	int (*lldd_execute_task)(struct sas_task *, int num,
-				 unsigned long gfp_flags);
+	int (*lldd_execute_task)(struct sas_task *, gfp_t gfp_flags);
 
-Used to queue a task to the SAS LLDD.  @task is the tasks to
-be executed.  @num should be the number of tasks being
-queued at this function call (they are linked listed via
-task::list), @gfp_mask should be the gfp_mask defining the
-context of the caller.
+Used to queue a task to the SAS LLDD.  @task is the task to be executed.
+@gfp_mask is the gfp_mask defining the context of the caller.
 
 This function should implement the Execute Command SCSI RPC,
-or if you're sending a SCSI Task as linked commands, you
-should also use this function.
 
-That is, when lldd_execute_task() is called, the command(s)
+That is, when lldd_execute_task() is called, the command
 go out on the transport *immediately*.  There is *no*
 queuing of any sort and at any level in a SAS LLDD.
 
-The use of task::list is two-fold, one for linked commands,
-the other discussed below.
-
-It is possible to queue up more than one task at a time, by
-initializing the list element of struct sas_task, and
-passing the number of tasks enlisted in this manner in num.
-
 Returns: -SAS_QUEUE_FULL, -ENOMEM, nothing was queued;
 	 0, the task(s) were queued.
 
-If you want to pass num > 1, then either
-A) you're the only caller of this function and keep track
-   of what you've queued to the LLDD, or
-B) you know what you're doing and have a strategy of
-   retrying.
-
-As opposed to queuing one task at a time (function call),
-batch queuing of tasks, by having num > 1, greatly
-simplifies LLDD code, sequencer code, and _hardware design_,
-and has some performance advantages in certain situations
-(DBMS).
-
-The LLDD advertises if it can take more than one command at
-a time at lldd_execute_task(), by setting the
-lldd_max_execute_num parameter (controlled by "collector"
-module parameter in aic94xx SAS LLDD).
-
-You should leave this to the default 1, unless you know what
-you're doing.
-
-This is a function of the LLDD, to which the SAS layer can
-cater to.
-
-int lldd_queue_size
-	The host adapter's queue size.  This is the maximum
-number of commands the lldd can have pending to domain
-devices on behalf of all upper layers submitting through
-lldd_execute_task().
-
-You really want to set this to something (much) larger than
-1.
-
-This _really_ has absolutely nothing to do with queuing.
-There is no queuing in SAS LLDDs.
-
 struct sas_task {
 	dev -- the device this task is destined to
-	list -- must be initialized (INIT_LIST_HEAD)
 	task_proto -- _one_ of enum sas_proto
 	scatter -- pointer to scatter gather list array
 	num_scatter -- number of elements in scatter
diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 66cda66..26d4ad9 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -78,7 +78,7 @@ void asd_dev_gone(struct domain_device *dev);
 
 void asd_invalidate_edb(struct asd_ascb *ascb, int edb_id);
 
-int  asd_execute_task(struct sas_task *, int num, gfp_t gfp_flags);
+int  asd_execute_task(struct sas_task *task, gfp_t gfp_flags);
 
 void asd_set_dmamode(struct domain_device *dev);
 
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 4df867e..9f636a3 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1200,8 +1200,7 @@ static void asd_start_scb_timers(struct list_head *list)
  * Case A: we can send the whole batch at once.  Increment "pending"
  * in the beginning of this function, when it is checked, in order to
  * eliminate races when this function is called by multiple processes.
- * Case B: should never happen if the managing layer considers
- * lldd_queue_size.
+ * Case B: should never happen.
  */
 int asd_post_ascb_list(struct asd_ha_struct *asd_ha, struct asd_ascb *ascb,
 		       int num)
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 579dc2f..49e4465 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -49,14 +49,6 @@ MODULE_PARM_DESC(use_msi, "\n"
 	"\tEnable(1) or disable(0) using PCI MSI.\n"
 	"\tDefault: 0");
 
-static int lldd_max_execute_num = 0;
-module_param_named(collector, lldd_max_execute_num, int, S_IRUGO);
-MODULE_PARM_DESC(collector, "\n"
-	"\tIf greater than one, tells the SAS Layer to run in Task Collector\n"
-	"\tMode.  If 1 or 0, tells the SAS Layer to run in Direct Mode.\n"
-	"\tThe aic94xx SAS LLDD supports both modes.\n"
-	"\tDefault: 0 (Direct Mode).\n");
-
 static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
@@ -710,9 +702,6 @@ static int asd_register_sas_ha(struct asd_ha_struct *asd_ha)
 	asd_ha->sas_ha.sas_port= sas_ports;
 	asd_ha->sas_ha.num_phys= ASD_MAX_PHYS;
 
-	asd_ha->sas_ha.lldd_queue_size = asd_ha->seq.can_queue;
-	asd_ha->sas_ha.lldd_max_execute_num = lldd_max_execute_num;
-
 	return sas_register_ha(&asd_ha->sas_ha);
 }
 
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 59b86e2..5ff1ce7 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -543,8 +543,7 @@ static int asd_can_queue(struct asd_ha_struct *asd_ha, int num)
 	return res;
 }
 
-int asd_execute_task(struct sas_task *task, const int num,
-		     gfp_t gfp_flags)
+int asd_execute_task(struct sas_task *task, gfp_t gfp_flags)
 {
 	int res = 0;
 	LIST_HEAD(alist);
@@ -553,11 +552,11 @@ int asd_execute_task(struct sas_task *task, const int num,
 	struct asd_ha_struct *asd_ha = task->dev->port->ha->lldd_ha;
 	unsigned long flags;
 
-	res = asd_can_queue(asd_ha, num);
+	res = asd_can_queue(asd_ha, 1);
 	if (res)
 		return res;
 
-	res = num;
+	res = 1;
 	ascb = asd_ascb_alloc_list(asd_ha, &res, gfp_flags);
 	if (res) {
 		res = -ENOMEM;
@@ -568,7 +567,7 @@ int asd_execute_task(struct sas_task *task, const int num,
 	list_for_each_entry(a, &alist, list) {
 		a->uldd_task = t;
 		t->lldd_task = a;
-		t = list_entry(t->list.next, struct sas_task, list);
+		break;
 	}
 	list_for_each_entry(a, &alist, list) {
 		t = a->uldd_task;
@@ -601,7 +600,7 @@ int asd_execute_task(struct sas_task *task, const int num,
 	}
 	list_del_init(&alist);
 
-	res = asd_post_ascb_list(asd_ha, ascb, num);
+	res = asd_post_ascb_list(asd_ha, ascb, 1);
 	if (unlikely(res)) {
 		a = NULL;
 		__list_add(&alist, ascb->list.prev, &ascb->list);
@@ -639,6 +638,6 @@ out_err_unmap:
 out_err:
 	if (ascb)
 		asd_ascb_free_list(ascb);
-	asd_can_dequeue(asd_ha, num);
+	asd_can_dequeue(asd_ha, 1);
 	return res;
 }
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 8975620..5798910 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -259,8 +259,6 @@ static int isci_register_sas_ha(struct isci_host *isci_host)
 	sas_ha->sas_port = sas_ports;
 	sas_ha->num_phys = SCI_MAX_PHYS;
 
-	sas_ha->lldd_queue_size = ISCI_CAN_QUEUE_VAL;
-	sas_ha->lldd_max_execute_num = 1;
 	sas_ha->strict_wide_ports = 1;
 
 	sas_register_ha(sas_ha);
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 5d6fda7..3f63c63 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -117,104 +117,97 @@ static inline int isci_device_io_ready(struct isci_remote_device *idev,
  *    functions. This function is called by libsas to send a task down to
  *    hardware.
  * @task: This parameter specifies the SAS task to send.
- * @num: This parameter specifies the number of tasks to queue.
  * @gfp_flags: This parameter specifies the context of this call.
  *
  * status, zero indicates success.
  */
-int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
+int isci_task_execute_task(struct sas_task *task, gfp_t gfp_flags)
 {
 	struct isci_host *ihost = dev_to_ihost(task->dev);
 	struct isci_remote_device *idev;
 	unsigned long flags;
+	enum sci_status status = SCI_FAILURE;
 	bool io_ready;
 	u16 tag;
 
-	dev_dbg(&ihost->pdev->dev, "%s: num=%d\n", __func__, num);
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	idev = isci_lookup_device(task->dev);
+	io_ready = isci_device_io_ready(idev, task);
+	tag = isci_alloc_tag(ihost);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
-	for_each_sas_task(num, task) {
-		enum sci_status status = SCI_FAILURE;
+	dev_dbg(&ihost->pdev->dev,
+		"task: %p, dev: %p idev: %p:%#lx cmd = %p\n",
+		task, task->dev, idev, idev ? idev->flags : 0,
+		task->uldd_task);
 
-		spin_lock_irqsave(&ihost->scic_lock, flags);
-		idev = isci_lookup_device(task->dev);
-		io_ready = isci_device_io_ready(idev, task);
-		tag = isci_alloc_tag(ihost);
-		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+	if (!idev) {
+		isci_task_refuse(ihost, task, SAS_TASK_UNDELIVERED,
+				 SAS_DEVICE_UNKNOWN);
+	} else if (!io_ready || tag == SCI_CONTROLLER_INVALID_IO_TAG) {
+		/* Indicate QUEUE_FULL so that the scsi midlayer
+		 * retries.
+		  */
+		isci_task_refuse(ihost, task, SAS_TASK_COMPLETE,
+				 SAS_QUEUE_FULL);
+	} else {
+		/* There is a device and it's ready for I/O. */
+		spin_lock_irqsave(&task->task_state_lock, flags);
 
-		dev_dbg(&ihost->pdev->dev,
-			"task: %p, num: %d dev: %p idev: %p:%#lx cmd = %p\n",
-			task, num, task->dev, idev, idev ? idev->flags : 0,
-			task->uldd_task);
-
-		if (!idev) {
-			isci_task_refuse(ihost, task, SAS_TASK_UNDELIVERED,
-					 SAS_DEVICE_UNKNOWN);
-		} else if (!io_ready || tag == SCI_CONTROLLER_INVALID_IO_TAG) {
-			/* Indicate QUEUE_FULL so that the scsi midlayer
-			 * retries.
-			  */
-			isci_task_refuse(ihost, task, SAS_TASK_COMPLETE,
-					 SAS_QUEUE_FULL);
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			/* The I/O was aborted. */
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+			isci_task_refuse(ihost, task,
+					 SAS_TASK_UNDELIVERED,
+					 SAM_STAT_TASK_ABORTED);
 		} else {
-			/* There is a device and it's ready for I/O. */
-			spin_lock_irqsave(&task->task_state_lock, flags);
-
-			if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
-				/* The I/O was aborted. */
-				spin_unlock_irqrestore(&task->task_state_lock,
-						       flags);
-
-				isci_task_refuse(ihost, task,
-						 SAS_TASK_UNDELIVERED,
-						 SAM_STAT_TASK_ABORTED);
-			} else {
-				task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+			task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+			/* build and send the request. */
+			status = isci_request_execute(ihost, idev, task, tag);
+
+			if (status != SCI_SUCCESS) {
+				spin_lock_irqsave(&task->task_state_lock, flags);
+				/* Did not really start this command. */
+				task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 				spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-				/* build and send the request. */
-				status = isci_request_execute(ihost, idev, task, tag);
-
-				if (status != SCI_SUCCESS) {
-
-					spin_lock_irqsave(&task->task_state_lock, flags);
-					/* Did not really start this command. */
-					task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-					spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-					if (test_bit(IDEV_GONE, &idev->flags)) {
-
-						/* Indicate that the device
-						 * is gone.
-						 */
-						isci_task_refuse(ihost, task,
-							SAS_TASK_UNDELIVERED,
-							SAS_DEVICE_UNKNOWN);
-					} else {
-						/* Indicate QUEUE_FULL so that
-						 * the scsi midlayer retries.
-						 * If the request failed for
-						 * remote device reasons, it
-						 * gets returned as
-						 * SAS_TASK_UNDELIVERED next
-						 * time through.
-						 */
-						isci_task_refuse(ihost, task,
-							SAS_TASK_COMPLETE,
-							SAS_QUEUE_FULL);
-					}
+				if (test_bit(IDEV_GONE, &idev->flags)) {
+					/* Indicate that the device
+					 * is gone.
+					 */
+					isci_task_refuse(ihost, task,
+						SAS_TASK_UNDELIVERED,
+						SAS_DEVICE_UNKNOWN);
+				} else {
+					/* Indicate QUEUE_FULL so that
+					 * the scsi midlayer retries.
+					 * If the request failed for
+					 * remote device reasons, it
+					 * gets returned as
+					 * SAS_TASK_UNDELIVERED next
+					 * time through.
+					 */
+					isci_task_refuse(ihost, task,
+						SAS_TASK_COMPLETE,
+						SAS_QUEUE_FULL);
 				}
 			}
 		}
-		if (status != SCI_SUCCESS && tag != SCI_CONTROLLER_INVALID_IO_TAG) {
-			spin_lock_irqsave(&ihost->scic_lock, flags);
-			/* command never hit the device, so just free
-			 * the tci and skip the sequence increment
-			 */
-			isci_tci_free(ihost, ISCI_TAG_TCI(tag));
-			spin_unlock_irqrestore(&ihost->scic_lock, flags);
-		}
-		isci_put_device(idev);
 	}
+
+	if (status != SCI_SUCCESS && tag != SCI_CONTROLLER_INVALID_IO_TAG) {
+		spin_lock_irqsave(&ihost->scic_lock, flags);
+		/* command never hit the device, so just free
+		 * the tci and skip the sequence increment
+		 */
+		isci_tci_free(ihost, ISCI_TAG_TCI(tag));
+		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+	}
+
+	isci_put_device(idev);
 	return 0;
 }
 
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 9c06cba..8f4531f 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -131,7 +131,6 @@ static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)
 
 int isci_task_execute_task(
 	struct sas_task *task,
-	int num,
 	gfp_t gfp_flags);
 
 int isci_task_abort_task(
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..577770f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -171,7 +171,6 @@ static void sas_ata_task_done(struct sas_task *task)
 	spin_unlock_irqrestore(ap->lock, flags);
 
 qc_already_gone:
-	list_del_init(&task->list);
 	sas_free_task(task);
 }
 
@@ -244,12 +243,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	if (qc->scsicmd)
 		ASSIGN_SAS_TASK(qc->scsicmd, task);
 
-	if (sas_ha->lldd_max_execute_num < 2)
-		ret = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
-	else
-		ret = sas_queue_up(task);
-
-	/* Examine */
+	ret = i->dft->lldd_execute_task(task, GFP_ATOMIC);
 	if (ret) {
 		SAS_DPRINTK("lldd_execute_task returned: %d\n", ret);
 
@@ -485,7 +479,6 @@ static void sas_ata_internal_abort(struct sas_task *task)
 
 	return;
  out:
-	list_del_init(&task->list);
 	sas_free_task(task);
 }
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0cac7d8..022bb6e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -96,7 +96,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 		task->slow_task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
 		add_timer(&task->slow_task->timer);
 
-		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
+		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index dbc8a79..362da44 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -45,7 +45,6 @@ struct sas_task *sas_alloc_task(gfp_t flags)
 	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
 
 	if (task) {
-		INIT_LIST_HEAD(&task->list);
 		spin_lock_init(&task->task_state_lock);
 		task->task_state_flags = SAS_TASK_STATE_PENDING;
 	}
@@ -77,7 +76,6 @@ EXPORT_SYMBOL_GPL(sas_alloc_slow_task);
 void sas_free_task(struct sas_task *task)
 {
 	if (task) {
-		BUG_ON(!list_empty(&task->list));
 		kfree(task->slow_task);
 		kmem_cache_free(sas_task_cache, task);
 	}
@@ -127,11 +125,6 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 	spin_lock_init(&sas_ha->phy_port_lock);
 	sas_hash_addr(sas_ha->hashed_sas_addr, sas_ha->sas_addr);
 
-	if (sas_ha->lldd_queue_size == 0)
-		sas_ha->lldd_queue_size = 1;
-	else if (sas_ha->lldd_queue_size == -1)
-		sas_ha->lldd_queue_size = 128; /* Sanity */
-
 	set_bit(SAS_HA_REGISTERED, &sas_ha->state);
 	spin_lock_init(&sas_ha->lock);
 	mutex_init(&sas_ha->drain_mutex);
@@ -157,15 +150,6 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 		goto Undo_ports;
 	}
 
-	if (sas_ha->lldd_max_execute_num > 1) {
-		error = sas_init_queue(sas_ha);
-		if (error) {
-			printk(KERN_NOTICE "couldn't start queue thread:%d, "
-			       "running in direct mode\n", error);
-			sas_ha->lldd_max_execute_num = 1;
-		}
-	}
-
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
 	INIT_LIST_HEAD(&sas_ha->eh_ata_q);
 
@@ -201,11 +185,6 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	__sas_drain_work(sas_ha);
 	mutex_unlock(&sas_ha->drain_mutex);
 
-	if (sas_ha->lldd_max_execute_num > 1) {
-		sas_shutdown_queue(sas_ha);
-		sas_ha->lldd_max_execute_num = 1;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7e7ba83..9cf0bc2 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -66,9 +66,7 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
 enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
 
-int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
-void sas_shutdown_queue(struct sas_ha_struct *sas_ha);
 void sas_disable_revalidation(struct sas_ha_struct *ha);
 void sas_enable_revalidation(struct sas_ha_struct *ha);
 void __sas_drain_work(struct sas_ha_struct *ha);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3ebdfaf..f3a4094 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -112,7 +112,6 @@ static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 
 	sc->result = (hs << 16) | stat;
 	ASSIGN_SAS_TASK(sc, NULL);
-	list_del_init(&task->list);
 	sas_free_task(task);
 }
 
@@ -138,7 +137,6 @@ static void sas_scsi_task_done(struct sas_task *task)
 
 	if (unlikely(!sc)) {
 		SAS_DPRINTK("task_done called with non existing SCSI cmnd!\n");
-		list_del_init(&task->list);
 		sas_free_task(task);
 		return;
 	}
@@ -179,31 +177,10 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	return task;
 }
 
-int sas_queue_up(struct sas_task *task)
-{
-	struct sas_ha_struct *sas_ha = task->dev->port->ha;
-	struct scsi_core *core = &sas_ha->core;
-	unsigned long flags;
-	LIST_HEAD(list);
-
-	spin_lock_irqsave(&core->task_queue_lock, flags);
-	if (sas_ha->lldd_queue_size < core->task_queue_size + 1) {
-		spin_unlock_irqrestore(&core->task_queue_lock, flags);
-		return -SAS_QUEUE_FULL;
-	}
-	list_add_tail(&task->list, &core->task_queue);
-	core->task_queue_size += 1;
-	spin_unlock_irqrestore(&core->task_queue_lock, flags);
-	wake_up_process(core->queue_thread);
-
-	return 0;
-}
-
 int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct sas_internal *i = to_sas_internal(host->transportt);
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct sas_ha_struct *sas_ha = dev->port->ha;
 	struct sas_task *task;
 	int res = 0;
 
@@ -224,12 +201,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!task)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/* Queue up, Direct Mode or Task Collector Mode. */
-	if (sas_ha->lldd_max_execute_num < 2)
-		res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
-	else
-		res = sas_queue_up(task);
-
+	res = i->dft->lldd_execute_task(task, GFP_ATOMIC);
 	if (res)
 		goto out_free_task;
 	return 0;
@@ -323,37 +295,17 @@ enum task_disposition {
 	TASK_IS_DONE,
 	TASK_IS_ABORTED,
 	TASK_IS_AT_LU,
-	TASK_IS_NOT_AT_HA,
 	TASK_IS_NOT_AT_LU,
 	TASK_ABORT_FAILED,
 };
 
 static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 {
-	struct sas_ha_struct *ha = task->dev->port->ha;
 	unsigned long flags;
 	int i, res;
 	struct sas_internal *si =
 		to_sas_internal(task->dev->port->ha->core.shost->transportt);
 
-	if (ha->lldd_max_execute_num > 1) {
-		struct scsi_core *core = &ha->core;
-		struct sas_task *t, *n;
-
-		mutex_lock(&core->task_queue_flush);
-		spin_lock_irqsave(&core->task_queue_lock, flags);
-		list_for_each_entry_safe(t, n, &core->task_queue, list)
-			if (task == t) {
-				list_del_init(&t->list);
-				break;
-			}
-		spin_unlock_irqrestore(&core->task_queue_lock, flags);
-		mutex_unlock(&core->task_queue_flush);
-
-		if (task == t)
-			return TASK_IS_NOT_AT_HA;
-	}
-
 	for (i = 0; i < 5; i++) {
 		SAS_DPRINTK("%s: aborting task 0x%p\n", __func__, task);
 		res = si->dft->lldd_abort_task(task);
@@ -664,14 +616,6 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 		cmd->eh_eflags = 0;
 
 		switch (res) {
-		case TASK_IS_NOT_AT_HA:
-			SAS_DPRINTK("%s: task 0x%p is not at ha: %s\n",
-				    __func__, task,
-				    cmd->retries ? "retry" : "aborted");
-			if (cmd->retries)
-				cmd->retries--;
-			sas_eh_finish_cmd(cmd);
-			continue;
 		case TASK_IS_DONE:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
@@ -833,9 +777,6 @@ retry:
 		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
 out:
-	if (ha->lldd_max_execute_num > 1)
-		wake_up_process(ha->core.queue_thread);
-
 	sas_eh_handle_resets(shost);
 
 	/* now link into libata eh --- if we have any ata devices */
@@ -994,121 +935,6 @@ int sas_bios_param(struct scsi_device *scsi_dev,
 	return 0;
 }
 
-/* ---------- Task Collector Thread implementation ---------- */
-
-static void sas_queue(struct sas_ha_struct *sas_ha)
-{
-	struct scsi_core *core = &sas_ha->core;
-	unsigned long flags;
-	LIST_HEAD(q);
-	int can_queue;
-	int res;
-	struct sas_internal *i = to_sas_internal(core->shost->transportt);
-
-	mutex_lock(&core->task_queue_flush);
-	spin_lock_irqsave(&core->task_queue_lock, flags);
-	while (!kthread_should_stop() &&
-	       !list_empty(&core->task_queue) &&
-	       !test_bit(SAS_HA_FROZEN, &sas_ha->state)) {
-
-		can_queue = sas_ha->lldd_queue_size - core->task_queue_size;
-		if (can_queue >= 0) {
-			can_queue = core->task_queue_size;
-			list_splice_init(&core->task_queue, &q);
-		} else {
-			struct list_head *a, *n;
-
-			can_queue = sas_ha->lldd_queue_size;
-			list_for_each_safe(a, n, &core->task_queue) {
-				list_move_tail(a, &q);
-				if (--can_queue == 0)
-					break;
-			}
-			can_queue = sas_ha->lldd_queue_size;
-		}
-		core->task_queue_size -= can_queue;
-		spin_unlock_irqrestore(&core->task_queue_lock, flags);
-		{
-			struct sas_task *task = list_entry(q.next,
-							   struct sas_task,
-							   list);
-			list_del_init(&q);
-			res = i->dft->lldd_execute_task(task, can_queue,
-							GFP_KERNEL);
-			if (unlikely(res))
-				__list_add(&q, task->list.prev, &task->list);
-		}
-		spin_lock_irqsave(&core->task_queue_lock, flags);
-		if (res) {
-			list_splice_init(&q, &core->task_queue); /*at head*/
-			core->task_queue_size += can_queue;
-		}
-	}
-	spin_unlock_irqrestore(&core->task_queue_lock, flags);
-	mutex_unlock(&core->task_queue_flush);
-}
-
-/**
- * sas_queue_thread -- The Task Collector thread
- * @_sas_ha: pointer to struct sas_ha
- */
-static int sas_queue_thread(void *_sas_ha)
-{
-	struct sas_ha_struct *sas_ha = _sas_ha;
-
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-		sas_queue(sas_ha);
-		if (kthread_should_stop())
-			break;
-	}
-
-	return 0;
-}
-
-int sas_init_queue(struct sas_ha_struct *sas_ha)
-{
-	struct scsi_core *core = &sas_ha->core;
-
-	spin_lock_init(&core->task_queue_lock);
-	mutex_init(&core->task_queue_flush);
-	core->task_queue_size = 0;
-	INIT_LIST_HEAD(&core->task_queue);
-
-	core->queue_thread = kthread_run(sas_queue_thread, sas_ha,
-					 "sas_queue_%d", core->shost->host_no);
-	if (IS_ERR(core->queue_thread))
-		return PTR_ERR(core->queue_thread);
-	return 0;
-}
-
-void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
-{
-	unsigned long flags;
-	struct scsi_core *core = &sas_ha->core;
-	struct sas_task *task, *n;
-
-	kthread_stop(core->queue_thread);
-
-	if (!list_empty(&core->task_queue))
-		SAS_DPRINTK("HA: %llx: scsi core task queue is NOT empty!?\n",
-			    SAS_ADDR(sas_ha->sas_addr));
-
-	spin_lock_irqsave(&core->task_queue_lock, flags);
-	list_for_each_entry_safe(task, n, &core->task_queue, list) {
-		struct scsi_cmnd *cmd = task->uldd_task;
-
-		list_del_init(&task->list);
-
-		ASSIGN_SAS_TASK(cmd, NULL);
-		sas_free_task(task);
-		cmd->result = DID_ABORT << 16;
-		cmd->scsi_done(cmd);
-	}
-	spin_unlock_irqrestore(&core->task_queue_lock, flags);
-}
-
 /*
  * Tell an upper layer that it needs to initiate an abort for a given task.
  * This should only ever be called by an LLDD.
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d3c1fa5..c9a9d68 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -26,18 +26,9 @@
 
 #include "mv_sas.h"
 
-static int lldd_max_execute_num = 1;
-module_param_named(collector, lldd_max_execute_num, int, S_IRUGO);
-MODULE_PARM_DESC(collector, "\n"
-	"\tIf greater than one, tells the SAS Layer to run in Task Collector\n"
-	"\tMode.  If 1 or 0, tells the SAS Layer to run in Direct Mode.\n"
-	"\tThe mvsas SAS LLDD supports both modes.\n"
-	"\tDefault: 1 (Direct Mode).\n");
-
 int interrupt_coalescing = 0x80;
 
 static struct scsi_transport_template *mvs_stt;
-struct kmem_cache *mvs_task_list_cache;
 static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6320] =	{ 1, 2, 0x400, 17, 16, 6,  9, &mvs_64xx_dispatch, },
 	[chip_6440] =	{ 1, 4, 0x400, 17, 16, 6,  9, &mvs_64xx_dispatch, },
@@ -512,14 +503,11 @@ static void  mvs_post_sas_ha_init(struct Scsi_Host *shost,
 
 	sha->num_phys = nr_core * chip_info->n_phy;
 
-	sha->lldd_max_execute_num = lldd_max_execute_num;
-
 	if (mvi->flags & MVF_FLAG_SOC)
 		can_queue = MVS_SOC_CAN_QUEUE;
 	else
 		can_queue = MVS_CHIP_SLOT_SZ;
 
-	sha->lldd_queue_size = can_queue;
 	shost->sg_tablesize = min_t(u16, SG_ALL, MVS_MAX_SG);
 	shost->can_queue = can_queue;
 	mvi->shost->cmd_per_lun = MVS_QUEUE_SIZE;
@@ -832,16 +820,7 @@ static int __init mvs_init(void)
 	if (!mvs_stt)
 		return -ENOMEM;
 
-	mvs_task_list_cache = kmem_cache_create("mvs_task_list", sizeof(struct mvs_task_list),
-							 0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!mvs_task_list_cache) {
-		rc = -ENOMEM;
-		mv_printk("%s: mvs_task_list_cache alloc failed! \n", __func__);
-		goto err_out;
-	}
-
 	rc = pci_register_driver(&mvs_pci_driver);
-
 	if (rc)
 		goto err_out;
 
@@ -856,7 +835,6 @@ static void __exit mvs_exit(void)
 {
 	pci_unregister_driver(&mvs_pci_driver);
 	sas_release_transport(mvs_stt);
-	kmem_cache_destroy(mvs_task_list_cache);
 }
 
 struct device_attribute *mvst_host_attrs[] = {
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index ac52f7c..85d86a5 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -852,43 +852,7 @@ prep_out:
 	return rc;
 }
 
-static struct mvs_task_list *mvs_task_alloc_list(int *num, gfp_t gfp_flags)
-{
-	struct mvs_task_list *first = NULL;
-
-	for (; *num > 0; --*num) {
-		struct mvs_task_list *mvs_list = kmem_cache_zalloc(mvs_task_list_cache, gfp_flags);
-
-		if (!mvs_list)
-			break;
-
-		INIT_LIST_HEAD(&mvs_list->list);
-		if (!first)
-			first = mvs_list;
-		else
-			list_add_tail(&mvs_list->list, &first->list);
-
-	}
-
-	return first;
-}
-
-static inline void mvs_task_free_list(struct mvs_task_list *mvs_list)
-{
-	LIST_HEAD(list);
-	struct list_head *pos, *a;
-	struct mvs_task_list *mlist = NULL;
-
-	__list_add(&list, mvs_list->list.prev, &mvs_list->list);
-
-	list_for_each_safe(pos, a, &list) {
-		list_del_init(pos);
-		mlist = list_entry(pos, struct mvs_task_list, list);
-		kmem_cache_free(mvs_task_list_cache, mlist);
-	}
-}
-
-static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+static int mvs_task_exec(struct sas_task *task, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
@@ -912,74 +876,9 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 	return rc;
 }
 
-static int mvs_collector_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
-				struct completion *completion, int is_tmf,
-				struct mvs_tmf_task *tmf)
+int mvs_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
-	struct domain_device *dev = task->dev;
-	struct mvs_prv_info *mpi = dev->port->ha->lldd_ha;
-	struct mvs_info *mvi = NULL;
-	struct sas_task *t = task;
-	struct mvs_task_list *mvs_list = NULL, *a;
-	LIST_HEAD(q);
-	int pass[2] = {0};
-	u32 rc = 0;
-	u32 n = num;
-	unsigned long flags = 0;
-
-	mvs_list = mvs_task_alloc_list(&n, gfp_flags);
-	if (n) {
-		printk(KERN_ERR "%s: mvs alloc list failed.\n", __func__);
-		rc = -ENOMEM;
-		goto free_list;
-	}
-
-	__list_add(&q, mvs_list->list.prev, &mvs_list->list);
-
-	list_for_each_entry(a, &q, list) {
-		a->task = t;
-		t = list_entry(t->list.next, struct sas_task, list);
-	}
-
-	list_for_each_entry(a, &q , list) {
-
-		t = a->task;
-		mvi = ((struct mvs_device *)t->dev->lldd_dev)->mvi_info;
-
-		spin_lock_irqsave(&mvi->lock, flags);
-		rc = mvs_task_prep(t, mvi, is_tmf, tmf, &pass[mvi->id]);
-		if (rc)
-			dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
-		spin_unlock_irqrestore(&mvi->lock, flags);
-	}
-
-	if (likely(pass[0]))
-			MVS_CHIP_DISP->start_delivery(mpi->mvi[0],
-				(mpi->mvi[0]->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
-
-	if (likely(pass[1]))
-			MVS_CHIP_DISP->start_delivery(mpi->mvi[1],
-				(mpi->mvi[1]->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
-
-	list_del_init(&q);
-
-free_list:
-	if (mvs_list)
-		mvs_task_free_list(mvs_list);
-
-	return rc;
-}
-
-int mvs_queue_command(struct sas_task *task, const int num,
-			gfp_t gfp_flags)
-{
-	struct mvs_device *mvi_dev = task->dev->lldd_dev;
-	struct sas_ha_struct *sas = mvi_dev->mvi_info->sas;
-
-	if (sas->lldd_max_execute_num < 2)
-		return mvs_task_exec(task, num, gfp_flags, NULL, 0, NULL);
-	else
-		return mvs_collector_task_exec(task, num, gfp_flags, NULL, 0, NULL);
+	return mvs_task_exec(task, gfp_flags, NULL, 0, NULL);
 }
 
 static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
@@ -1411,7 +1310,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 		task->slow_task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
 		add_timer(&task->slow_task->timer);
 
-		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 1, tmf);
+		res = mvs_task_exec(task, GFP_KERNEL, NULL, 1, tmf);
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index d6b19dc..dc409c0 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -65,7 +65,6 @@ extern struct mvs_tgt_initiator mvs_tgt;
 extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
 extern const struct mvs_dispatch mvs_94xx_dispatch;
-extern struct kmem_cache *mvs_task_list_cache;
 
 #define DEV_IS_EXPANDER(type)	\
 	((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
@@ -440,12 +439,6 @@ struct mvs_task_exec_info {
 	int n_elem;
 };
 
-struct mvs_task_list {
-	struct sas_task *task;
-	struct list_head list;
-};
-
-
 /******************** function prototype *********************/
 void mvs_get_sas_addr(void *buf, u32 buflen);
 void mvs_tag_clear(struct mvs_info *mvi, u32 tag);
@@ -462,8 +455,7 @@ void mvs_set_sas_addr(struct mvs_info *mvi, int port_id, u32 off_lo,
 		      u32 off_hi, u64 sas_addr);
 void mvs_scan_start(struct Scsi_Host *shost);
 int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
-int mvs_queue_command(struct sas_task *task, const int num,
-			gfp_t gfp_flags);
+int mvs_queue_command(struct sas_task *task, gfp_t gfp_flags);
 int mvs_abort_task(struct sas_task *task);
 int mvs_abort_task_set(struct domain_device *dev, u8 *lun);
 int mvs_clear_aca(struct domain_device *dev, u8 *lun);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3ff759a..06dfd29 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -600,8 +600,6 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
 	sha->lldd_module = THIS_MODULE;
 	sha->sas_addr = &pm8001_ha->sas_addr[0];
 	sha->num_phys = chip_info->n_phy;
-	sha->lldd_max_execute_num = 1;
-	sha->lldd_queue_size = PM8001_CAN_QUEUE;
 	sha->core.shost = shost;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 76570e6..b93f289 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -350,7 +350,7 @@ static int sas_find_local_port_id(struct domain_device *dev)
   */
 #define DEV_IS_GONE(pm8001_dev)	\
 	((!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED)))
-static int pm8001_task_exec(struct sas_task *task, const int num,
+static int pm8001_task_exec(struct sas_task *task,
 	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
 {
 	struct domain_device *dev = task->dev;
@@ -360,7 +360,6 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 	struct sas_task *t = task;
 	struct pm8001_ccb_info *ccb;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
-	u32 n = num;
 	unsigned long flags = 0;
 
 	if (!dev->port) {
@@ -387,18 +386,12 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 				t->task_done(t);
 				spin_lock_irqsave(&pm8001_ha->lock, flags);
-				if (n > 1)
-					t = list_entry(t->list.next,
-							struct sas_task, list);
 				continue;
 			} else {
 				struct task_status_struct *ts = &t->task_status;
 				ts->resp = SAS_TASK_UNDELIVERED;
 				ts->stat = SAS_PHY_DOWN;
 				t->task_done(t);
-				if (n > 1)
-					t = list_entry(t->list.next,
-							struct sas_task, list);
 				continue;
 			}
 		}
@@ -460,9 +453,7 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
 		spin_unlock(&t->task_state_lock);
 		pm8001_dev->running_req++;
-		if (n > 1)
-			t = list_entry(t->list.next, struct sas_task, list);
-	} while (--n);
+	} while (0);
 	rc = 0;
 	goto out_done;
 
@@ -483,14 +474,11 @@ out_done:
   * pm8001_queue_command - register for upper layer used, all IO commands sent
   * to HBA are from this interface.
   * @task: the task to be execute.
-  * @num: if can_queue great than 1, the task can be queued up. for SMP task,
-  * we always execute one one time
   * @gfp_flags: gfp_flags
   */
-int pm8001_queue_command(struct sas_task *task, const int num,
-		gfp_t gfp_flags)
+int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 {
-	return pm8001_task_exec(task, num, gfp_flags, 0, NULL);
+	return pm8001_task_exec(task, gfp_flags, 0, NULL);
 }
 
 /**
@@ -708,7 +696,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT*HZ;
 		add_timer(&task->slow_task->timer);
 
-		res = pm8001_task_exec(task, 1, GFP_KERNEL, 1, tmf);
+		res = pm8001_task_exec(task, GFP_KERNEL, 1, tmf);
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index f6b2ac5..8dd8b78 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -623,8 +623,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
 void pm8001_scan_start(struct Scsi_Host *shost);
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time);
-int pm8001_queue_command(struct sas_task *task, const int num,
-	gfp_t gfp_flags);
+int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags);
 int pm8001_abort_task(struct sas_task *task);
 int pm8001_abort_task_set(struct domain_device *dev, u8 *lun);
 int pm8001_clear_aca(struct domain_device *dev, u8 *lun);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ef7872c..2c36368 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -365,12 +365,6 @@ struct asd_sas_phy {
 struct scsi_core {
 	struct Scsi_Host *shost;
 
-	struct mutex	  task_queue_flush;
-	spinlock_t        task_queue_lock;
-	struct list_head  task_queue;
-	int               task_queue_size;
-
-	struct task_struct *queue_thread;
 };
 
 struct sas_ha_event {
@@ -422,9 +416,6 @@ struct sas_ha_struct {
 	struct asd_sas_port **sas_port; /* array of valid pointers, must be set */
 	int             num_phys; /* must be set, gt 0, static */
 
-	/* The class calls this to send a task for execution. */
-	int lldd_max_execute_num;
-	int lldd_queue_size;
 	int strict_wide_ports; /* both sas_addr and attached_sas_addr must match
 				* their siblings when forming wide ports */
 
@@ -612,7 +603,6 @@ struct sas_ssp_task {
 
 struct sas_task {
 	struct domain_device *dev;
-	struct list_head      list;
 
 	spinlock_t   task_state_lock;
 	unsigned     task_state_flags;
@@ -665,8 +655,7 @@ struct sas_domain_function_template {
 	int  (*lldd_dev_found)(struct domain_device *);
 	void (*lldd_dev_gone)(struct domain_device *);
 
-	int (*lldd_execute_task)(struct sas_task *, int num,
-				 gfp_t gfp_flags);
+	int (*lldd_execute_task)(struct sas_task *, gfp_t gfp_flags);
 
 	/* Task Management Functions. Must be called from process context. */
 	int (*lldd_abort_task)(struct sas_task *);
@@ -700,7 +689,6 @@ extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 int sas_set_phy_speed(struct sas_phy *phy,
 		      struct sas_phy_linkrates *rates);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
-int sas_queue_up(struct sas_task *task);
 extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_configure(struct scsi_device *);
-- 
1.9.1

