From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] sdd scsi-ml event wq
Date: Fri, 28 May 2004 00:59:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6F16B.6070909@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000209070400020608090903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33033 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S263032AbUE1H7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 03:59:47 -0400
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i4S7xeP13339
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2004 02:59:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000209070400020608090903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch just adds a scsi-ml work queue to handle all
events. It also converts the transport_scsi_fc class to use it,
so drivers using that class do not have to worry about calling
the event functions from a process context.

The attached patch was built against my previous patch set.

Mike Christie

--------------000209070400020608090903
Content-Type: text/plain;
 name="scsi-ml-event.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-ml-event.patch"

diff -Naurp linux-2.6.7-rc1/drivers/scsi/scsi.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi.c
--- linux-2.6.7-rc1/drivers/scsi/scsi.c	2004-05-27 00:36:22.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi.c	2004-05-27 20:46:30.000000000 -0700
@@ -1193,6 +1193,10 @@ static int __init init_scsi(void)
 	if (error)
 		goto cleanup_sysctl;
 
+	error = scsi_init_event_daemon();
+	if (error)
+		goto cleanup_sysfs;
+
 	for (i = 0; i < NR_CPUS; i++)
 		INIT_LIST_HEAD(&per_cpu(scsi_done_q, i));
 
@@ -1202,6 +1206,8 @@ static int __init init_scsi(void)
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1219,6 +1225,7 @@ cleanup_queue:
 
 static void __exit exit_scsi(void)
 {
+	scsi_shutdown_event_daemon();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff -Naurp linux-2.6.7-rc1/drivers/scsi/scsi_lib.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_lib.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_lib.c	2004-05-09 19:32:37.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_lib.c	2004-05-27 23:53:36.000000000 -0700
@@ -15,9 +15,11 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/kobject.h>
 
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_event.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -1691,3 +1693,88 @@ scsi_device_resume(struct scsi_device *s
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+static struct workqueue_struct *scsi_eventd;
+static kmem_cache_t *scsi_event_cache;
+static mempool_t *scsi_event_pool;
+#define EVENT_POOL_SIZE 64
+
+struct scsi_event {
+	struct work_struct work;
+	const char *action;
+	struct kobject *kobj;
+};
+
+int __init scsi_init_event_daemon(void)
+{
+	scsi_eventd = create_workqueue("scsi_event");
+	if (!scsi_eventd)
+		return -ENOMEM;
+
+	scsi_event_cache = kmem_cache_create("scsi_event",
+					     sizeof(struct scsi_event),
+					     0, 0, NULL, NULL);
+	if (!scsi_event_cache)
+		goto destroy_queue;
+
+	scsi_event_pool = mempool_create(EVENT_POOL_SIZE, mempool_alloc_slab,
+					 mempool_free_slab, scsi_event_cache);
+	if (scsi_event_pool)
+		return 0;
+
+	kmem_cache_destroy(scsi_event_cache);
+ destroy_queue:
+	destroy_workqueue(scsi_eventd);
+
+	return -ENOMEM;
+}
+
+void scsi_shutdown_event_daemon(void)
+{
+	mempool_destroy(scsi_event_pool);
+	kmem_cache_destroy(scsi_event_cache);
+	destroy_workqueue(scsi_eventd);
+}
+
+static void __scsi_hotplug_event(void *data)
+{
+	struct scsi_event *event = data;
+
+	kobject_hotplug(event->action, event->kobj);
+	kobject_put(event->kobj);
+	mempool_free(event, scsi_event_pool);
+}
+
+/**
+ *	scsi_hotplug_event - raises a userspace event.
+ *	@kobj: kobject from scsi data structure.
+ *	@action: the event type.
+ *
+ *	Sends an event through the kobject infrastructure.
+ *	returns 0 for success or an -Exxx value on error.
+ **/
+int scsi_hotplug_event(struct kobject *kobj, const char *action)
+{
+	struct scsi_event *event;
+
+	if (!kobj || !action)
+		return -EINVAL;
+
+	/* this handle is released in __scsi_hotplug_event */
+	if (!kobject_get(kobj))
+		return -EINVAL;
+
+	event = mempool_alloc(scsi_event_pool, GFP_ATOMIC);
+	if (!event) {
+		kobject_put(kobj);
+		return -ENOMEM;
+	}
+
+	event->kobj = kobj;
+	event->action = action;
+	INIT_WORK(&event->work, __scsi_hotplug_event, event);
+
+	queue_work(scsi_eventd, &event->work);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_hotplug_event);
diff -Naurp linux-2.6.7-rc1/drivers/scsi/scsi_priv.h linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_priv.h
--- linux-2.6.7-rc1/drivers/scsi/scsi_priv.h	2004-05-09 19:32:53.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_priv.h	2004-05-27 21:09:48.000000000 -0700
@@ -116,6 +116,8 @@ extern struct request_queue *scsi_alloc_
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+extern int scsi_init_event_daemon(void);
+extern void scsi_shutdown_event_daemon(void);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff -Naurp linux-2.6.7-rc1/drivers/scsi/scsi_transport_fc.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_transport_fc.c	2004-05-27 23:31:31.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_transport_fc.c	2004-05-27 22:24:53.000000000 -0700
@@ -22,6 +22,7 @@
 #include <linux/kobject.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_event.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
@@ -77,28 +78,30 @@ static void __exit fc_transport_exit(voi
  *
  * Sends a hotplug event to userspace utilizing the
  * kobject infrastructure.
+ *
+ * returns 0 for success or an -Exxx value on error.
  */
-void fc_link_up(struct Scsi_Host *shost)
+int fc_link_up(struct Scsi_Host *shost)
 {
 	struct kobject *kobj;
 
 	if (!shost)
-		return;
+		return -EINVAL;
 
 	kobj = &shost->transport_classdev.kobj;
-	kobject_hotplug("fc_link_up", kobj);
+	return scsi_hotplug_event(kobj, "fc_link_up");
 }
 EXPORT_SYMBOL(fc_link_up);
 
-void fc_link_down(struct Scsi_Host *shost)
+int fc_link_down(struct Scsi_Host *shost)
 {
 	struct kobject *kobj;
 
 	if (!shost)
-		return;
+		return -EINVAL;
 
 	kobj = &shost->transport_classdev.kobj;
-	kobject_hotplug("fc_link_down", kobj);
+	return scsi_hotplug_event(kobj, "fc_link_down");
 }
 EXPORT_SYMBOL(fc_link_down);
 
diff -Naurp linux-2.6.7-rc1/include/scsi/scsi_event.h linux-2.6.7-rc1-hotplug/include/scsi/scsi_event.h
--- linux-2.6.7-rc1/include/scsi/scsi_event.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.7-rc1-hotplug/include/scsi/scsi_event.h	2004-05-27 23:53:19.000000000 -0700
@@ -0,0 +1,8 @@
+#ifndef _SCSI_SCSI_EVENT_H
+#define _SCSI_SCSI_EVENT_H
+
+#include <linux/kobject.h>
+
+int scsi_hotplug_event(struct kobject *, const char *);
+
+#endif
diff -Naurp linux-2.6.7-rc1/include/scsi/scsi_transport_fc.h linux-2.6.7-rc1-hotplug/include/scsi/scsi_transport_fc.h
--- linux-2.6.7-rc1/include/scsi/scsi_transport_fc.h	2004-05-09 19:32:27.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/include/scsi/scsi_transport_fc.h	2004-05-27 22:02:35.000000000 -0700
@@ -52,5 +52,7 @@ struct fc_function_template {
 
 struct scsi_transport_template *fc_attach_transport(struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
+int fc_link_up(struct Scsi_Host *);
+int fc_link_up(struct Scsi_Host *);
 
 #endif /* SCSI_TRANSPORT_FC_H */

--------------000209070400020608090903--

