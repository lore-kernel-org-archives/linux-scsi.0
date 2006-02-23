From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix scsi process problems and clean up the target reap
	issues
Date: Thu, 23 Feb 2006 14:27:18 -0600
Message-ID: <1140726438.2809.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42956 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932106AbWBWU1a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 15:27:30 -0500
Received: from jet.il.steeleye.com (il-ppp.sc.steeleye.com [172.17.6.240])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k1NKRI208133
	for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2006 15:27:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

In order to use the new execute_in_process_context() API, you have to
provide it with the work storage, which I do in SCSI in scsi_device and
scsi_target, but which also means that we can no longer queue up the
target reaps, so instead I moved the target to a state model which
allows target_alloc to detect if we've received a dying target and wait
for it to be gone.  Hopefully, this should also solve the target
namespace race.

James

---

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2006-02-20 08:57:40.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2006-02-23 12:37:21.000000000 -0600
@@ -2248,61 +2248,3 @@
 		device_for_each_child(dev, NULL, target_unblock);
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
-
-
-struct work_queue_work {
-	struct work_struct	work;
-	void			(*fn)(void *);
-	void			*data;
-};
-
-static void execute_in_process_context_work(void *data)
-{
-	void (*fn)(void *data);
-	struct work_queue_work *wqw = data;
-
-	fn = wqw->fn;
-	data = wqw->data;
-
-	kfree(wqw);
-
-	fn(data);
-}
-
-/**
- * scsi_execute_in_process_context - reliably execute the routine with user context
- * @fn:		the function to execute
- * @data:	data to pass to the function
- *
- * Executes the function immediately if process context is available,
- * otherwise schedules the function for delayed execution.
- *
- * Returns:	0 - function was executed
- *		1 - function was scheduled for execution
- *		<0 - error
- */
-int scsi_execute_in_process_context(void (*fn)(void *data), void *data)
-{
-	struct work_queue_work *wqw;
-
-	if (!in_interrupt()) {
-		fn(data);
-		return 0;
-	}
-
-	wqw = kmalloc(sizeof(struct work_queue_work), GFP_ATOMIC);
-
-	if (unlikely(!wqw)) {
-		printk(KERN_ERR "Failed to allocate memory\n");
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
-	INIT_WORK(&wqw->work, execute_in_process_context_work, wqw);
-	wqw->fn = fn;
-	wqw->data = data;
-	schedule_work(&wqw->work);
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(scsi_execute_in_process_context);
Index: BUILD-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_scan.c	2006-02-20 08:57:40.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_scan.c	2006-02-23 14:18:20.000000000 -0600
@@ -349,6 +349,8 @@
 	starget->channel = channel;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
+	starget->state = STARGET_RUNNING;
+ retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	found_target = __scsi_find_target(parent, channel, id);
@@ -381,8 +383,15 @@
 	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(parent);
-	kfree(starget);
-	return found_target;
+	if (found_target->state != STARGET_DEL) {
+		kfree(starget);
+		return found_target;
+	}
+	/* Unfortunately, we found a dying target; need to
+	 * wait until it's dead before we can get a new one */
+	put_device(&found_target->dev);
+	flush_scheduled_work();
+	goto retry;
 }
 
 static void scsi_target_reap_usercontext(void *data)
@@ -391,21 +400,13 @@
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 
+	transport_remove_device(&starget->dev);
+	device_del(&starget->dev);
+	transport_destroy_device(&starget->dev);
 	spin_lock_irqsave(shost->host_lock, flags);
-
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
-		list_del_init(&starget->siblings);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		transport_remove_device(&starget->dev);
-		device_del(&starget->dev);
-		transport_destroy_device(&starget->dev);
-		put_device(&starget->dev);
-		return;
-
-	}
+	list_del_init(&starget->siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	return;
+	put_device(&starget->dev);
 }
 
 /**
@@ -419,7 +420,23 @@
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	scsi_execute_in_process_context(scsi_target_reap_usercontext, starget);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+		BUG_ON(starget->state == STARGET_DEL);
+		starget->state = STARGET_DEL;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		execute_in_process_context(scsi_target_reap_usercontext,
+					   starget, &starget->ew);
+		return;
+
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return;
 }
 
 /**
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2006-02-20 08:57:40.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2006-02-20 10:02:58.000000000 -0600
@@ -256,7 +256,9 @@
 
 static void scsi_device_dev_release(struct device *dev)
 {
-	scsi_execute_in_process_context(scsi_device_dev_release_usercontext,	dev);
+	struct scsi_device *sdp = to_scsi_device(dev);
+	execute_in_process_context(scsi_device_dev_release_usercontext, dev,
+				   &sdp->ew);
 }
 
 static struct class sdev_class = {
Index: BUILD-2.6/include/scsi/scsi.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi.h	2006-02-20 08:57:40.000000000 -0600
+++ BUILD-2.6/include/scsi/scsi.h	2006-02-20 10:02:58.000000000 -0600
@@ -433,6 +433,4 @@
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-int scsi_execute_in_process_context(void (*fn)(void *data), void *data);
-
 #endif /* _SCSI_SCSI_H */
Index: BUILD-2.6/include/scsi/scsi_device.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_device.h	2006-02-20 08:57:40.000000000 -0600
+++ BUILD-2.6/include/scsi/scsi_device.h	2006-02-20 10:02:58.000000000 -0600
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -137,6 +138,8 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
+	struct execute_work	ew; /* used to get process context on put */
+
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -153,6 +156,11 @@
 #define scmd_printk(prefix, scmd, fmt, a...)	\
 	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
 
+enum scsi_target_state {
+	STARGET_RUNNING = 1,
+	STARGET_DEL,
+};
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -169,6 +177,8 @@
 				     * scsi_device.id eventually */
 	unsigned long		create:1; /* signal that it needs to be added */
 	char			scsi_level;
+	struct execute_work	ew;
+	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
 	/* starget_data must be the last element!!!! */


