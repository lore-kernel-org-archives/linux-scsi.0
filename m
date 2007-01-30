From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/12] libsas: Provide a generic SATL registration function
Date: Tue, 30 Jan 2007 01:19:01 -0800
Message-ID: <20070130091901.31530.59048.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39258 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965463AbXA3JQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:29 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9H6DZ018401
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:17:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GRC2297864
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GRkM011068
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:27 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Decouple libsas and sas_ata so that the latter can be provided as a
plug-in module for the former.  Any module wishing to provide SATL
services registers itself with libsas; when SATA devices are
discovered, libsas will module_get/put as necessary to ensure that
the module cannot go away accidentally.  At this time, we cannot
start a SAS HBA without a SATL, load a SATL later, and then
rerun device discovery; that may be addressed in a later patch.
A phy reset will do the job quite nicely.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/Kconfig         |   11 +++
 drivers/scsi/libsas/sas_discover.c  |    6 --
 drivers/scsi/libsas/sas_scsi_host.c |  137 ++++++++++++++++++++++++++++++++---
 include/scsi/libsas.h               |   30 +-------
 include/scsi/sas_ata.h              |   38 +++++++++-
 5 files changed, 176 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index b64e391..9c06eec 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,12 +24,21 @@ #
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI && ATA
+	depends on SCSI
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
 	  use the domain device construct (like the aic94xxx).
 
+config SCSI_SAS_SATL
+	tristate "Serial ATA Translation Layer (SATL) on SAS controllers"
+	depends on SCSI_SAS_LIBSAS && ATA
+	default y
+	help
+	  This provides an ATA translation layer between libsas and
+	  libata to load SATA devices that are connected to SAS
+	  controllers.
+
 config SCSI_SAS_LIBSAS_DEBUG
 	bool "Compile the SAS Domain Transport Attributes in debug mode"
 	default y
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index a18c0f6..56cc8da 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -476,12 +476,6 @@ cont1:
 	if (!dev->parent)
 		sas_sata_propagate_sas_addr(dev);
 
-	/* XXX Hint: register this SATA device with SATL.
-	   When this returns, dev->sata_dev->lu is alive and
-	   present.
-	sas_satl_register_dev(dev);
-	*/
-
 	sas_fill_in_rphy(dev, dev->rphy);
 
 	return 0;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index a30c0b7..073b6a7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -44,6 +44,10 @@ #include <linux/libata.h>
 
 /* ---------- SCSI Host glue ---------- */
 
+
+static DEFINE_SPINLOCK(satl_ops_lock);
+static struct satl_operations *satl_ops;
+
 static void sas_scsi_task_done(struct sas_task *task)
 {
 	struct task_status_struct *ts = &task->task_status;
@@ -213,8 +217,8 @@ int sas_queuecommand(struct scsi_cmnd *c
 			unsigned long flags;
 
 			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-			res = ata_sas_queuecmd(cmd, scsi_done,
-					       dev->sata_dev.ap);
+			res = satl_ops->queuecommand(cmd, scsi_done,
+						     dev->sata_dev.ap);
 			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 			goto out;
 		}
@@ -663,8 +667,9 @@ int sas_ioctl(struct scsi_device *sdev, 
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
-	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+	if (dev_is_sata(dev)) {
+		return satl_ops->ioctl(sdev, cmd, arg);
+	}
 
 	return -EINVAL;
 }
@@ -705,6 +710,29 @@ static inline struct domain_device *sas_
 	return sas_find_dev_by_rphy(rphy);
 }
 
+static int sas_target_alloc_sata(struct domain_device *dev,
+				 struct scsi_target *starget)
+{
+	int res = -ENODEV;
+
+	/* Do we have a SATL available? */
+	if (!get_satl())
+		goto satl_found;
+
+	request_module("sas_ata");
+	if (!get_satl())
+		goto satl_found;
+
+	SAS_DPRINTK("sas_ata not loaded, ignoring SATA devices\n");
+	goto no_satl;
+
+satl_found:
+	res = satl_ops->init_target(dev, starget);
+
+no_satl:
+	return res;
+}
+
 int sas_target_alloc(struct scsi_target *starget)
 {
 	struct domain_device *found_dev = sas_find_target(starget);
@@ -714,7 +742,7 @@ int sas_target_alloc(struct scsi_target 
 		return -ENODEV;
 
 	if (dev_is_sata(found_dev)) {
-		res = sas_ata_init_host_and_port(found_dev, starget);
+		res = sas_target_alloc_sata(found_dev, starget);
 		if (res)
 			return res;
 	}
@@ -734,7 +762,7 @@ int sas_slave_configure(struct scsi_devi
 	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
 
 	if (dev_is_sata(dev)) {
-		ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
+		satl_ops->configure_port(scsi_dev, dev->sata_dev.ap);
 		return 0;
 	}
 
@@ -764,7 +792,7 @@ void sas_slave_destroy(struct scsi_devic
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	if (dev_is_sata(dev))
-		ata_port_disable(dev->sata_dev.ap);
+		satl_ops->deactivate_port(dev->sata_dev.ap);
 }
 
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
@@ -996,7 +1024,7 @@ void sas_task_abort(struct sas_task *tas
 	}
 
 	if (dev_is_sata(task->dev)) {
-		sas_ata_task_abort(task);
+		satl_ops->task_abort(task);
 		return;
 	}
 
@@ -1009,7 +1037,7 @@ int sas_slave_alloc(struct scsi_device *
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	if (dev_is_sata(dev))
-		return ata_sas_port_init(dev->sata_dev.ap);
+		return satl_ops->init_port(dev->sata_dev.ap);
 
 	return 0;
 }
@@ -1021,12 +1049,94 @@ void sas_target_destroy(struct scsi_targ
 	if (!found_dev)
 		return;
 
-	if (dev_is_sata(found_dev))
-		ata_sas_port_destroy(found_dev->sata_dev.ap);
+	if (dev_is_sata(found_dev)) {
+		if (found_dev->sata_dev.ap)
+			satl_ops->destroy_port(found_dev->sata_dev.ap);
+		put_satl();
+	}
 
 	return;
 }
 
+struct sas_task *sas_alloc_task(gfp_t flags)
+{
+	extern struct kmem_cache *sas_task_cache;
+	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
+
+	if (task) {
+		memset(task, 0, sizeof(*task));
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+
+	return task;
+}
+
+void sas_free_task(struct sas_task *task)
+{
+	if (task) {
+		extern struct kmem_cache *sas_task_cache;
+		BUG_ON(!list_empty(&task->list));
+		kmem_cache_free(sas_task_cache, task);
+	}
+}
+
+/* Jump table to ATA translation layer functions */
+int sas_register_satl(struct satl_operations *ops)
+{
+	int res = -ENODEV;
+
+	spin_lock(&satl_ops_lock);
+	if (satl_ops)
+		goto out;
+	satl_ops = ops;
+	res = 0;
+out:
+	spin_unlock(&satl_ops_lock);
+	return res;
+}
+
+int sas_unregister_satl(struct satl_operations *ops)
+{
+	int res = -ENODEV;
+
+	spin_lock(&satl_ops_lock);
+	if (satl_ops != ops)
+		goto out;
+	satl_ops = NULL;
+	res = 0;
+out:
+	spin_unlock(&satl_ops_lock);
+	return res;
+}
+
+int get_satl(void)
+{
+	int res = -ENODEV;
+
+	spin_lock(&satl_ops_lock);
+
+	if (!satl_ops)
+		goto out;
+	if (!try_module_get(satl_ops->owner))
+		goto out;
+	res = 0;
+
+out:
+	spin_unlock(&satl_ops_lock);
+	return res;
+}
+
+void put_satl(void)
+{
+	spin_lock(&satl_ops_lock);
+	module_put(satl_ops->owner);
+	spin_unlock(&satl_ops_lock);
+}
+
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
@@ -1043,3 +1153,8 @@ EXPORT_SYMBOL_GPL(sas_slave_alloc);
 EXPORT_SYMBOL_GPL(sas_target_destroy);
 EXPORT_SYMBOL_GPL(sas_ioctl);
 EXPORT_SYMBOL_GPL(sas_set_phy_speed);
+EXPORT_SYMBOL_GPL(sas_register_satl);
+EXPORT_SYMBOL_GPL(sas_unregister_satl);
+EXPORT_SYMBOL_GPL(sas_queue_up);
+EXPORT_SYMBOL_GPL(sas_alloc_task);
+EXPORT_SYMBOL_GPL(sas_free_task);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1400c3f..b97cca3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -572,31 +572,8 @@ #define SAS_TASK_STATE_ABORTED      4
 #define SAS_TASK_NEED_DEV_RESET     8
 #define SAS_TASK_AT_INITIATOR       16
 
-static inline struct sas_task *sas_alloc_task(gfp_t flags)
-{
-	extern struct kmem_cache *sas_task_cache;
-	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
-
-	if (task) {
-		memset(task, 0, sizeof(*task));
-		INIT_LIST_HEAD(&task->list);
-		spin_lock_init(&task->task_state_lock);
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
-	}
-
-	return task;
-}
-
-static inline void sas_free_task(struct sas_task *task)
-{
-	if (task) {
-		extern struct kmem_cache *sas_task_cache;
-		BUG_ON(!list_empty(&task->list));
-		kmem_cache_free(sas_task_cache, task);
-	}
-}
+struct sas_task *sas_alloc_task(gfp_t flags);
+void sas_free_task(struct sas_task *task);
 
 struct sas_domain_function_template {
 	/* The class calls these to notify the LLDD of an event. */
@@ -675,4 +652,7 @@ extern void sas_target_destroy(struct sc
 extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
+int get_satl(void);
+void put_satl(void);
+
 #endif /* _SASLIB_H_ */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 3407c81..f1d90f7 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -28,14 +28,46 @@ #define _SAS_ATA_H_
 #include <linux/libata.h>
 #include <scsi/libsas.h>
 
+struct satl_operations {
+	struct module *owner;
+
+	int (*init_target) (struct domain_device *found_dev,
+			    struct scsi_target *starget);
+	int  (*queuecommand) (struct scsi_cmnd *cmd,
+			      void (*done)(struct scsi_cmnd *),
+			      struct ata_port *ap);
+	int  (*ioctl) (struct scsi_device *dev, int cmd,
+		       void __user *arg);
+	int  (*configure_port) (struct scsi_device *,
+				struct ata_port *);
+	void (*deactivate_port) (struct ata_port *);
+	void (*destroy_port) (struct ata_port *);
+	int  (*init_port) (struct ata_port *);
+	void (*task_abort) (struct sas_task *);
+};
+
+int sas_register_satl(struct satl_operations *satl_ops);
+int sas_unregister_satl(struct satl_operations *satl_ops);
+
+#ifdef CONFIG_SCSI_SAS_SATL_MODULE
+# define SAS_ATA_AVAILABLE
+#endif
+
+#ifdef CONFIG_SCSI_SAS_SATL
+# define SAS_ATA_AVAILABLE
+#endif
+
+#ifdef SAS_ATA_AVAILABLE
+
 static inline int dev_is_sata(struct domain_device *dev)
 {
 	return (dev->rphy->identify.target_port_protocols & SAS_PROTOCOL_SATA);
 }
 
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget);
+#else
+
+#define dev_is_sata(x) (0)
 
-void sas_ata_task_abort(struct sas_task *task);
+#endif /* SAS_ATA_AVAILABLE */
 
 #endif /* _SAS_ATA_H_ */
