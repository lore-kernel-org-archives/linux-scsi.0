From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_aen: fix event locking problems
Date: Sun, 28 Oct 2007 14:38:37 -0500
Message-ID: <1193600318.3333.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35752 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751538AbXJ1Tik (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2007 15:38:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

There was a fundamental flaw in the initial code, in that it had no
locking around scsi_device_event_notify().  This is a problem because
execute_in_process_context() also has no locking (it expects the caller
to do the work).  This means that two events firing simultaneously could
potentially corrupt each other.  This might be unlikely for media change
events, but it will become more likely as we use this call as the engine
for other SCSI AENs.

The best fix looks to be simply not to use sdev->ew for the source of
the execute_work queue.  Further, since kzalloc() always has to give us
at least 32 bytes and we're doing an allocation anyway, it's free to
shove the execute_work structure into scsi_device_event_info and
eliminate all of the other locking and the work queue list.

I also separated the aen headers out into scsi_aen.h and cleaned up the
uevent processing (there's no real need to define the strings anywhere
other than in scsi_aen_uevent_notifier() ... especially as I envisage
there will be more complex strings for some SCSI events.

Finally, I exported and made available scsi_aen_chain for the things
that will attach to it.

James

Index: BUILD-2.6/include/scsi/scsi_device.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_device.h	2007-10-28 13:45:42.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_device.h	2007-10-28 13:51:06.000000000 -0500
@@ -46,16 +46,6 @@ enum scsi_device_state {
 				 * to the scsi lld. */
 };
 
-/* must match scsi_device_event_strings in scsi_lib.c */
-enum scsi_device_event {
-	SDEV_MEDIA_CHANGE = 1,	/* media has changed */
-};
-
-struct scsi_device_event_info {
-	enum scsi_device_event event;
-	struct list_head link;
-};
-
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -154,7 +144,6 @@ struct scsi_device {
 	struct execute_work	ew; /* used to get process context on put */
 
 	enum scsi_device_state sdev_state;
-	struct list_head	sdev_event_list;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 #define	to_scsi_device(d)	\
@@ -286,8 +275,6 @@ extern int scsi_test_unit_ready(struct s
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
-extern int scsi_device_event_notify(struct scsi_device *sdev,
-				enum scsi_device_event event);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
Index: BUILD-2.6/drivers/scsi/scsi_aen.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_aen.c	2007-10-28 13:51:27.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_aen.c	2007-10-28 14:34:27.000000000 -0500
@@ -28,21 +28,18 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_aen.h>
 
 static int scsi_aen_uevent_notifier(struct notifier_block *nb,
 				    unsigned long action, void *sdev);
 
 BLOCKING_NOTIFIER_HEAD(scsi_aen_chain);
+EXPORT_SYMBOL_GPL(scsi_aen_chain);
 
 static struct notifier_block scsi_aen_nb = {
 	.notifier_call = scsi_aen_uevent_notifier,
 };
 
-/* must match scsi_device_event enum in scsi_device.h */
-static char * scsi_device_event_strings[] = {
-	"MEDIA_CHANGE=1",
-};
-
 /**	scsi_aen_notifier_register - register to receive aen events
  * 	@nb: callers notifier_block
  *
@@ -66,33 +63,6 @@ int scsi_aen_notifier_unregister(struct 
 EXPORT_SYMBOL_GPL(scsi_aen_notifier_unregister);
 
 /**
- * 	scsi_device_set_event - Add a new Async event to the event list
- *	@sdev: scsi_device event occurred on
- *	@event: the scsi device event
- *
- * 	Add a new scsi_device_event_info struct to the scsi_device_event_list
- * 	queue.  This may be called from interrupt context.
- *
- * 	Returns 0 if successful, -ENOMEM otherwise.
- */
-static int
-scsi_device_set_event(struct scsi_device *sdev, enum scsi_device_event event)
-{
-	struct scsi_device_event_info *scsi_event;
-	unsigned long flags;
-
-	scsi_event = kzalloc(sizeof(*scsi_event), GFP_ATOMIC);
-	if (!scsi_event)
-		return -ENOMEM;
-	INIT_LIST_HEAD(&scsi_event->link);
-	scsi_event->event = event;
-	spin_lock_irqsave(&sdev->list_lock, flags);
-	list_add_tail(&scsi_event->link, &sdev->sdev_event_list);
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
-	return 0;
-}
-
-/**
  * 	scsi_device_event_notify_thread - send a uevent for each scsi event
  *	@work: work struct for scsi_device
  *
@@ -101,24 +71,15 @@ scsi_device_set_event(struct scsi_device
  */
 static void scsi_event_notify_thread(struct work_struct *work)
 {
-	struct scsi_device *sdev;
-	struct list_head *tmp;
-	struct list_head *next;
 	struct scsi_device_event_info *sdev_event;
-	unsigned long flags;
 
-	sdev = container_of(work, struct scsi_device, ew.work);
-	list_for_each_safe(tmp, next, &sdev->sdev_event_list) {
-		sdev_event = list_entry(tmp, struct scsi_device_event_info,
-					link);
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_del(&sdev_event->link);
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-		/* ignore return code for now */
-		blocking_notifier_call_chain(&scsi_aen_chain,
-			sdev_event->event, sdev);
-		kfree(sdev_event);
-	}
+	sdev_event = container_of(work, struct scsi_device_event_info,
+				  ew.work);
+
+	/* ignore return code for now */
+	blocking_notifier_call_chain(&scsi_aen_chain,
+				     sdev_event->event, sdev_event);
+	kfree(sdev_event);
 }
 
 static int scsi_aen_uevent_notifier(struct notifier_block *nb,
@@ -127,10 +88,13 @@ static int scsi_aen_uevent_notifier(stru
 	struct scsi_device *sdev = data;
 	char *envp[] = { NULL, NULL };
 
-	if (action == SDEV_MEDIA_CHANGE) {
-		envp[0] = scsi_device_event_strings[action-1];
+	switch (action) {
+	case SDEV_MEDIA_CHANGE:
+		envp[0] = "MEDIA_CHANGE=1";
 		kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+		break;
 	}
+
 	return NOTIFY_OK;
 }
 
@@ -140,19 +104,25 @@ static int scsi_aen_uevent_notifier(stru
  *	@event: the scsi device event
  *
  * 	Store the event information and then switch process context
- * 	so that the event may be sent to user space.
+ * 	so< that the event may be sent to user space.
  * 	This may be called from interrupt context.
  *
  * 	Returns 0 if successful, -ENOMEM otherwise.
  */
 int scsi_device_event_notify(struct scsi_device *sdev, enum scsi_device_event event)
 {
-	int rc;
+	struct scsi_device_event_info *scsi_event;
 
-	rc = scsi_device_set_event(sdev, event);
-	if (!rc)
-		execute_in_process_context(scsi_event_notify_thread, &sdev->ew);
-	return rc;
+	scsi_event = kzalloc(sizeof(*scsi_event), GFP_ATOMIC);
+	if (!scsi_event)
+		return -ENOMEM;
+
+	scsi_event->event = event;
+	scsi_event->sdev = sdev;
+
+	execute_in_process_context(scsi_event_notify_thread, &scsi_event->ew);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scsi_device_event_notify);
 
Index: BUILD-2.6/include/scsi/scsi_aen.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ BUILD-2.6/include/scsi/scsi_aen.h	2007-10-28 14:35:25.000000000 -0500
@@ -0,0 +1,24 @@
+#ifndef _SCSI_SCSI_AEN_H
+#define _SCSI_SCSI_AEN_H
+
+#include <linux/workqueue.h>
+
+struct scsi_device;
+
+/* must match the event environment in scsi_aen.c:scsi_aen_uevent_notifier */
+enum scsi_device_event {
+	SDEV_MEDIA_CHANGE = 1,	/* media has changed */
+};
+
+struct scsi_device_event_info {
+	enum scsi_device_event event;
+	struct scsi_device *sdev;
+	struct execute_work ew;
+};
+
+extern struct blocking_notifier_head scsi_aen_chain;
+
+extern int scsi_device_event_notify(struct scsi_device *sdev,
+				    enum scsi_device_event event);
+
+#endif
Index: BUILD-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_scan.c	2007-10-28 14:03:10.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_scan.c	2007-10-28 14:03:17.000000000 -0500
@@ -254,7 +254,6 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
-	INIT_LIST_HEAD(&sdev->sdev_event_list);
 	spin_lock_init(&sdev->list_lock);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
Index: BUILD-2.6/drivers/scsi/sd.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sd.c	2007-10-28 14:04:14.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sd.c	2007-10-28 14:04:22.000000000 -0500
@@ -50,6 +50,7 @@
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_aen.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
Index: BUILD-2.6/drivers/scsi/sr.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sr.c	2007-10-28 14:04:46.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sr.c	2007-10-28 14:05:01.000000000 -0500
@@ -47,6 +47,7 @@
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_aen.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>


