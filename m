From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/9] target: remove transport_generic_free_device
Date: Mon, 08 Nov 2010 10:56:08 -0500
Message-ID: <20101108155648.574374815@canuck.infradead.org>
References: <20101108155601.872926000@canuck.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:44175 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0KHP4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 10:56:49 -0500
Content-Disposition: inline; filename=lio-kill-transport_generic_free_device
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

It's simple enough to inline into the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core-2.6/drivers/target/target_core_device.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_device.c	2010-11-08 16:07:13.631529681 +0100
+++ lio-core-2.6/drivers/target/target_core_device.c	2010-11-08 16:08:56.528196347 +0100
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
+#include <linux/kthread.h>
 #include <linux/in.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -733,7 +734,11 @@ void se_release_device_for_hba(struct se
 	    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED))
 		se_dev_stop(dev);
 
-	transport_generic_free_device(dev);
+	if (dev->dev_ptr) {
+		kthread_stop(dev->process_thread);
+		if (dev->transport->free_device)
+			dev->transport->free_device(dev->dev_ptr);
+	}
 
 	spin_lock(&hba->device_lock);
 	list_del(&dev->dev_list);
Index: lio-core-2.6/drivers/target/target_core_transport.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-08 16:07:13.618196346 +0100
+++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-08 16:08:26.438196370 +0100
@@ -2367,22 +2367,6 @@ out:
 }
 EXPORT_SYMBOL(transport_add_device_to_core_hba);
 
-/*	transport_generic_free_device():
- *
- *
- */
-void transport_generic_free_device(struct se_device *dev)
-{
-	if (!(dev->dev_ptr))
-		return;
-
-	kthread_stop(dev->process_thread);
-
-	if (TRANSPORT(dev)->free_device)
-		TRANSPORT(dev)->free_device(dev->dev_ptr);
-}
-EXPORT_SYMBOL(transport_generic_free_device);
-
 static inline int transport_allocate_iovecs_for_cmd(
 	struct se_cmd *cmd,
 	u32 iov_count)
Index: lio-core-2.6/include/target/target_core_transport.h
===================================================================
--- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-08 16:08:08.554863013 +0100
+++ lio-core-2.6/include/target/target_core_transport.h	2010-11-08 16:08:10.134863013 +0100
@@ -190,7 +190,6 @@ extern struct se_device *transport_add_d
 					struct se_subsystem_dev *, u32,
 					void *, struct se_dev_limits *,
 					const char *, const char *);
-extern void transport_generic_free_device(struct se_device *);
 extern int transport_generic_allocate_iovecs(struct se_cmd *);
 extern void transport_device_setup_cmd(struct se_cmd *);
 extern int transport_check_alloc_task_attr(struct se_cmd *);

