From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sun, 05 Feb 2006 12:02:35 -0600
Message-ID: <1139162555.3017.11.camel@mulgrave.il.steeleye.com>
References: <200602042315.k14NFwuS006966@fire-2.osdl.org>
	 <20060204153118.4b0270b4.akpm@osdl.org>
	 <1139098731.2957.2.camel@mulgrave.il.steeleye.com>
	 <20060204165156.6024702b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45537 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751296AbWBESCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 13:02:40 -0500
In-Reply-To: <20060204165156.6024702b.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, greg@kroah.com

On Sat, 2006-02-04 at 16:51 -0800, Andrew Morton wrote:
> in_interrupt() will return true in hard- or soft-irq context on all
> architectures and all .configs - you can certainly use that.
> 
> What we cannot use is in_atomic() to detect whether we're inside spinlock -
> that only works if CONFIG_PREEMPT.

OK, what do you think about this?  It introduces an extra api to ensure
user context.  I suppose one think that could be done is to get the
wrappers off a slab instead of using kmalloc, but that could be fixed up
later.

James

---

[PATCH] fix scsi function called from wrong context errors

There are several functions in our call tree that need to be called
with user context, but for which we cannot guarantee this.  The two
examples here are scsi_reap_target() and scsi_device_dev_release().
The problem is that SCSI commands can be retried from softirq context,
so it's very difficult to guarantee user context for anything in SCSI.

The solution is to introduce a new workqueue API:
execute_from_user_context() that checks the context and executes the
function directly if it has user context, otherwise schedules it for
execution via a workqueue.  This is the optimal behaviour for SCSI
because there are only rare occasions where we don't have context.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Index: BUILD-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_scan.c	2006-02-05 10:30:00.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_scan.c	2006-02-05 10:53:11.000000000 -0600
@@ -385,19 +385,12 @@
 	return found_target;
 }
 
-struct work_queue_wrapper {
-	struct work_struct	work;
-	struct scsi_target	*starget;
-};
-
-static void scsi_target_reap_work(void *data) {
-	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
-	struct scsi_target *starget = wqw->starget;
+static void scsi_target_reap_usercontext(void *data)
+{
+	struct scsi_target *starget = data;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 
-	kfree(wqw);
-
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
@@ -426,18 +419,8 @@
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	struct work_queue_wrapper *wqw = 
-		kzalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);
-
-	if (!wqw) {
-		starget_printk(KERN_ERR, starget,
-			       "Failed to allocate memory in scsi_reap_target()\n");
-		return;
-	}
-
-	INIT_WORK(&wqw->work, scsi_target_reap_work, wqw);
-	wqw->starget = starget;
-	schedule_work(&wqw->work);
+	execute_in_user_context(scsi_target_reap_usercontext,
+				starget);
 }
 
 /**
Index: BUILD-2.6/kernel/workqueue.c
===================================================================
--- BUILD-2.6.orig/kernel/workqueue.c	2006-02-05 10:41:28.000000000 -0600
+++ BUILD-2.6/kernel/workqueue.c	2006-02-05 11:21:14.000000000 -0600
@@ -27,6 +27,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/kthread.h>
+#include <linux/hardirq.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -476,6 +477,63 @@
 }
 EXPORT_SYMBOL(cancel_rearming_delayed_work);
 
+struct work_queue_wrapper {
+	struct work_struct	work;
+	void			(*fn)(void *);
+	void			*data;
+};
+
+static void execute_in_user_context_work(void *data)
+{
+	void (*fn)(void *data);
+	struct work_queue_wrapper *wqw = data;
+
+	fn = wqw->fn;
+	data = wqw->data;
+
+	kfree(wqw);
+
+	fn(data);
+}
+
+/**
+ * execute_in_user_context - reliably execute the routine with user context
+ * @fn:		the function to execute
+ * @data:	data to pass to the function
+ *
+ * Executes the function immediately if user context is available, otherwise
+ * schedules the function for delayed execution.
+ *
+ * Returns:	0 - function was executed
+ *		1 - function was scheduled for execution
+ *		<0 - error
+ */
+int execute_in_user_context(void (*fn)(void *data), void *data)
+{
+	struct work_queue_wrapper *wqw;
+
+	if(!in_interrupt()) {
+		fn(data);
+		return 0;
+	}
+
+		wqw = kmalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);
+
+	if (!wqw) {
+		printk(KERN_ERR "Failed to allocate memory\n");
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&wqw->work, execute_in_user_context_work, wqw);
+	wqw->fn = fn;
+	wqw->data = data;
+	schedule_work(&wqw->work);
+
+	return 1;
+}
+EXPORT_SYMBOL(execute_in_user_context);
+
 int keventd_up(void)
 {
 	return keventd_wq != NULL;
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2006-02-05 10:43:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2006-02-05 10:59:54.000000000 -0600
@@ -217,8 +217,9 @@
 	put_device(&sdev->sdev_gendev);
 }
 
-static void scsi_device_dev_release(struct device *dev)
+static void scsi_device_dev_release_usercontext(void *data)
 {
+	struct device *dev = data;
 	struct scsi_device *sdev;
 	struct device *parent;
 	struct scsi_target *starget;
@@ -237,6 +238,7 @@
 
 	if (sdev->request_queue) {
 		sdev->request_queue->queuedata = NULL;
+		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
 		/* temporary expedient, try to catch use of queue lock
 		 * after free of sdev */
@@ -252,6 +254,12 @@
 		put_device(parent);
 }
 
+static void scsi_device_dev_release(struct device *dev)
+{
+	execute_in_user_context(scsi_device_dev_release_usercontext,
+				dev);
+}
+
 static struct class sdev_class = {
 	.name		= "scsi_device",
 	.release	= scsi_device_cls_release,
Index: BUILD-2.6/include/linux/workqueue.h
===================================================================
--- BUILD-2.6.orig/include/linux/workqueue.h	2006-01-31 17:01:53.000000000 -0600
+++ BUILD-2.6/include/linux/workqueue.h	2006-02-05 10:51:30.000000000 -0600
@@ -74,6 +74,7 @@
 void cancel_rearming_delayed_work(struct work_struct *work);
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *,
 				       struct work_struct *);
+int execute_in_user_context(void (*fn)(void *), void *);
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback


