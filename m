From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH] scsi: use notifier chain for Asynchronous Event
 Notification
Date: Wed, 12 Sep 2007 11:02:36 -0700
Message-ID: <20070912110236.e51d05e7.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967656AbXILSGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Sep 2007 14:06:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org, akpm@linux-foundation.org

Add a notifier chain for SCSI asynchronous events.  Add a 
notifier block for events which should be sent to user
space, and add support for the MEDIA_CHANGE event, which
would be used by a driver when new media has been inserted.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
---
This patch is against the latest -mm and is on top of what
has already been put in for AN support.  It just moves the 
event notification thread out of scsi_lib.c and into it's own
file, as well as adding notifier chain support. 

Index: 2.6-mm/drivers/scsi/scsi.c
===================================================================
--- 2.6-mm.orig/drivers/scsi/scsi.c
+++ 2.6-mm/drivers/scsi/scsi.c
@@ -1045,6 +1045,8 @@ static int __init init_scsi(void)
 	if (error)
 		goto cleanup_sysctl;
 
+	scsi_aen_init();
+
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
Index: 2.6-mm/drivers/scsi/scsi_aen.c
===================================================================
--- /dev/null
+++ 2.6-mm/drivers/scsi/scsi_aen.c
@@ -0,0 +1,168 @@
+/*
+ *  SCSI Asynchronous Event Notification
+ *
+ *  Copyright (c) 2007, Intel Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *  Send Feedback to:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
+ */
+#include <linux/notifier.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
+
+static int scsi_aen_uevent_notifier(struct notifier_block *nb,
+				    unsigned long action, void *sdev);
+
+BLOCKING_NOTIFIER_HEAD(scsi_aen_chain);
+
+static struct notifier_block scsi_aen_nb = {
+	.notifier_call = scsi_aen_uevent_notifier,
+};
+
+/* must match scsi_device_event enum in scsi_device.h */
+static char * scsi_device_event_strings[] = {
+	"MEDIA_CHANGE=1",
+};
+
+/**	scsi_aen_notifier_register - register to receive aen events
+ * 	@nb: callers notifier_block
+ *
+ * 	Add a callers notifier_block to the AEN notify chain.
+ */
+int scsi_aen_notifier_register(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&scsi_aen_chain, nb);
+}
+EXPORT_SYMBOL_GPL(scsi_aen_notifier_register);
+
+/**	scsi_aen_notifier_register - register to receive aen events
+ * 	@nb: callers notifier_block
+ *
+ * 	remove a callers notifier_block from the AEN notify chain.
+ */
+int scsi_aen_notifier_unregister(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&scsi_aen_chain, nb);
+}
+EXPORT_SYMBOL_GPL(scsi_aen_notifier_unregister);
+
+/**
+ * 	scsi_device_set_event - Add a new Async event to the event list
+ *	@sdev: scsi_device event occurred on
+ *	@event: the scsi device event
+ *
+ * 	Add a new scsi_device_event_info struct to the scsi_device_event_list
+ * 	queue.  This may be called from interrupt context.
+ *
+ * 	Returns 0 if successful, -ENOMEM otherwise.
+ */
+static int
+scsi_device_set_event(struct scsi_device *sdev, enum scsi_device_event event)
+{
+	struct scsi_device_event_info *scsi_event;
+	unsigned long flags;
+
+	scsi_event = kzalloc(sizeof(*scsi_event), GFP_ATOMIC);
+	if (!scsi_event)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&scsi_event->link);
+	scsi_event->event = event;
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_add_tail(&scsi_event->link, &sdev->sdev_event_list);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	return 0;
+}
+
+/**
+ * 	scsi_device_event_notify_thread - send a uevent for each scsi event
+ *	@work: work struct for scsi_device
+ *
+ * 	Traverse the queue of scsi device events, dequeue each event and
+ * 	send a uevent.  Frees event.  May not be called from interrupt.
+ */
+static void scsi_event_notify_thread(struct work_struct *work)
+{
+	struct scsi_device *sdev;
+	struct list_head *tmp;
+	struct list_head *next;
+	struct scsi_device_event_info *sdev_event;
+	unsigned long flags;
+
+	sdev = container_of(work, struct scsi_device, ew.work);
+	list_for_each_safe(tmp, next, &sdev->sdev_event_list) {
+		sdev_event = list_entry(tmp, struct scsi_device_event_info,
+					link);
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_del(&sdev_event->link);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+		/* ignore return code for now */
+		blocking_notifier_call_chain(&scsi_aen_chain,
+			sdev_event->event, sdev);
+		kfree(sdev_event);
+	}
+}
+
+static int scsi_aen_uevent_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct scsi_device *sdev = data;
+	char *envp[] = { NULL, NULL };
+
+	if (action == SDEV_MEDIA_CHANGE) {
+		envp[0] = scsi_device_event_strings[action-1];
+		kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+	}
+	return NOTIFY_OK;
+}
+
+/**
+ * 	scsi_device_event_notify - store event info and send an event
+ *	@sdev: scsi_device event occurred on
+ *	@event: the scsi device event
+ *
+ * 	Store the event information and then switch process context
+ * 	so that the event may be sent to user space.
+ * 	This may be called from interrupt context.
+ *
+ * 	Returns 0 if successful, -ENOMEM otherwise.
+ */
+int scsi_device_event_notify(struct scsi_device *sdev, enum scsi_device_event event)
+{
+	int rc;
+
+	rc = scsi_device_set_event(sdev, event);
+	if (!rc)
+		execute_in_process_context(scsi_event_notify_thread, &sdev->ew);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(scsi_device_event_notify);
+
+__init int scsi_aen_init(void)
+{
+	return scsi_aen_notifier_register(&scsi_aen_nb);
+}
+
+void scsi_aen_exit(void)
+{
+	scsi_aen_notifier_unregister(&scsi_aen_nb);
+}
+
Index: 2.6-mm/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6-mm.orig/drivers/scsi/scsi_lib.c
+++ 2.6-mm/drivers/scsi/scsi_lib.c
@@ -51,11 +51,6 @@ static struct scsi_host_sg_pool scsi_sg_
 };
 #undef SP
 
-/* must match scsi_device_event enum in scsi_device.h */
-static char * scsi_device_event_strings[] = {
-	"MEDIA_CHANGE=1",
-};
-
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -2136,84 +2131,6 @@ scsi_device_set_state(struct scsi_device
 EXPORT_SYMBOL(scsi_device_set_state);
 
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
- * 	scsi_device_event_notify_thread - send a uevent for each scsi event
- *	@work: work struct for scsi_device
- *
- * 	Traverse the queue of scsi device events, dequeue each event and
- * 	send a uevent.  Frees event.  May not be called from interrupt.
- */
-static void scsi_event_notify_thread(struct work_struct *work)
-{
-	struct scsi_device *sdev;
-	char *envp[] = { NULL, NULL };
-	struct list_head *tmp;
-	struct list_head *next;
-	struct scsi_device_event_info *sdev_event;
-	unsigned long flags;
-
-	sdev = container_of(work, struct scsi_device, ew.work);
-	list_for_each_safe(tmp, next, &sdev->sdev_event_list) {
-		sdev_event = list_entry(tmp, struct scsi_device_event_info,
-					link);
-		spin_lock_irqsave(&sdev->list_lock, flags);
-		list_del(&sdev_event->link);
-		spin_unlock_irqrestore(&sdev->list_lock, flags);
-		envp[0] = scsi_device_event_strings[sdev_event->event-1];
-		kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
-		kfree(sdev_event);
-	}
-}
-
-/**
- * 	scsi_device_event_notify - store event info and send an event
- *	@sdev: scsi_device event occurred on
- *	@event: the scsi device event
- *
- * 	Store the event information and then switch process context
- * 	so that the event may be sent to user space.
- * 	This may be called from interrupt context.
- *
- * 	Returns 0 if successful, -ENOMEM otherwise.
- */
-int scsi_device_event_notify(struct scsi_device *sdev, enum scsi_device_event event)
-{
-	int rc;
-
-	rc = scsi_device_set_event(sdev, event);
-	if (!rc)
-		execute_in_process_context(scsi_event_notify_thread, &sdev->ew);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(scsi_device_event_notify);
-
-/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
Index: 2.6-mm/drivers/scsi/Makefile
===================================================================
--- 2.6-mm.orig/drivers/scsi/Makefile
+++ 2.6-mm/drivers/scsi/Makefile
@@ -150,7 +150,7 @@ obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wait_scan.o
 
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
-				   scsicam.o scsi_error.o scsi_lib.o
+				   scsicam.o scsi_error.o scsi_lib.o scsi_aen.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
Index: 2.6-mm/drivers/scsi/scsi_priv.h
===================================================================
--- 2.6-mm.orig/drivers/scsi/scsi_priv.h
+++ 2.6-mm/drivers/scsi/scsi_priv.h
@@ -128,6 +128,10 @@ static inline void scsi_netlink_init(voi
 static inline void scsi_netlink_exit(void) {}
 #endif
 
+/* scsi_aen.c */
+extern int scsi_aen_init(void);
+extern void scsi_aen_exit(void);
+
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
