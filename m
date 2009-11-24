From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/22] zfcp: Remove global config_mutex
Date: Tue, 24 Nov 2009 16:54:00 +0100
Message-ID: <20091124160136.519250000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59644 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=702-zfcp-config-mutex.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The global config_mutex was required for the serialization of a
configuration change within the zfcp driver.  This global locking is
now obsolete and can be removed.  The requirement of serializing the
access to a zfcp_adapter reference via a ccw_device is realized wth a
static spinlock.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   86 +++++++++++--------------
 drivers/s390/scsi/zfcp_ccw.c   |  138 ++++++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_cfdc.c  |   25 ++-----
 drivers/s390/scsi/zfcp_def.h   |    1 
 drivers/s390/scsi/zfcp_ext.h   |    5 +
 drivers/s390/scsi/zfcp_fc.c    |    3 
 drivers/s390/scsi/zfcp_sysfs.c |  132 ++++++++++++++++++++++++++++++---------
 7 files changed, 232 insertions(+), 158 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:38.000000000 +0100
@@ -80,23 +80,21 @@ int zfcp_reqlist_isempty(struct zfcp_ada
 
 static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 {
-	struct ccw_device *ccwdev;
+	struct ccw_device *cdev;
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 
-	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
-	if (!ccwdev)
+	cdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!cdev)
 		return;
 
-	if (ccw_device_set_online(ccwdev))
-		goto out_ccwdev;
+	if (ccw_device_set_online(cdev))
+		goto out_ccw_device;
 
-	mutex_lock(&zfcp_data.config_mutex);
-	adapter = dev_get_drvdata(&ccwdev->dev);
+	adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	if (!adapter)
-		goto out_unlock;
-	kref_get(&adapter->ref);
+		goto out_ccw_device;
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
 	if (!port)
@@ -105,21 +103,17 @@ static void __init zfcp_init_device_conf
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
-	mutex_unlock(&zfcp_data.config_mutex);
 
 	zfcp_erp_unit_reopen(unit, 0, "auidc_1", NULL);
 	zfcp_erp_wait(adapter);
 	flush_work(&unit->scsi_work);
 
-	mutex_lock(&zfcp_data.config_mutex);
 out_unit:
 	put_device(&port->sysfs_device);
 out_port:
-	kref_put(&adapter->ref, zfcp_adapter_release);
-out_unlock:
-	mutex_unlock(&zfcp_data.config_mutex);
-out_ccwdev:
-	put_device(&ccwdev->dev);
+	zfcp_ccw_adapter_put(adapter);
+out_ccw_device:
+	put_device(&cdev->dev);
 	return;
 }
 
@@ -184,8 +178,6 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	mutex_init(&zfcp_data.config_mutex);
-
 	zfcp_data.scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
 	if (!zfcp_data.scsi_transport_template)
@@ -296,7 +288,6 @@ static void zfcp_unit_release(struct dev
  * @port: pointer to port where unit is added
  * @fcp_lun: FCP LUN of unit to be enqueued
  * Returns: pointer to enqueued unit on success, ERR_PTR on error
- * Locks: config_mutex must be held to serialize changes to the unit list
  *
  * Sets up some unit internal structures and creates sysfs entry.
  */
@@ -371,7 +362,6 @@ err_out:
 
 static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
-	/* must only be called with zfcp_data.config_mutex taken */
 	adapter->pool.erp_req =
 		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
 	if (!adapter->pool.erp_req)
@@ -419,7 +409,6 @@ static int zfcp_allocate_low_mem_buffers
 
 static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
-	/* zfcp_data.config_mutex must be held */
 	if (adapter->pool.erp_req)
 		mempool_destroy(adapter->pool.erp_req);
 	if (adapter->pool.scsi_req)
@@ -501,24 +490,22 @@ static void zfcp_destroy_adapter_work_qu
  * zfcp_adapter_enqueue - enqueue a new adapter to the list
  * @ccw_device: pointer to the struct cc_device
  *
- * Returns:	0             if a new adapter was successfully enqueued
- *		-ENOMEM       if alloc failed
+ * Returns:	struct zfcp_adapter*
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
  * Proc-fs entries are also created.
- * locks: config_mutex must be held to serialize changes to the adapter list
  */
-int zfcp_adapter_enqueue(struct ccw_device *ccw_device)
+struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 
 	if (!get_device(&ccw_device->dev))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	adapter = kzalloc(sizeof(struct zfcp_adapter), GFP_KERNEL);
 	if (!adapter) {
 		put_device(&ccw_device->dev);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	kref_init(&adapter->ref);
@@ -578,11 +565,30 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
 	if (!zfcp_adapter_scsi_register(adapter))
-		return 0;
+		return adapter;
 
 failed:
-	kref_put(&adapter->ref, zfcp_adapter_release);
-	return -ENOMEM;
+	zfcp_adapter_unregister(adapter);
+	return ERR_PTR(-ENOMEM);
+}
+
+void zfcp_adapter_unregister(struct zfcp_adapter *adapter)
+{
+	struct ccw_device *cdev = adapter->ccw_device;
+
+	cancel_work_sync(&adapter->scan_work);
+	cancel_work_sync(&adapter->stat_work);
+	zfcp_destroy_adapter_work_queue(adapter);
+
+	zfcp_fc_wka_ports_force_offline(adapter->gs);
+	zfcp_adapter_scsi_unregister(adapter);
+	sysfs_remove_group(&cdev->dev.kobj, &zfcp_sysfs_adapter_attrs);
+
+	zfcp_erp_thread_kill(adapter);
+	zfcp_dbf_adapter_unregister(adapter->dbf);
+	zfcp_qdio_destroy(adapter->qdio);
+
+	zfcp_ccw_adapter_put(adapter); /* final put to release */
 }
 
 /**
@@ -594,27 +600,16 @@ void zfcp_adapter_release(struct kref *r
 {
 	struct zfcp_adapter *adapter = container_of(ref, struct zfcp_adapter,
 						    ref);
-	struct ccw_device *ccw_device = adapter->ccw_device;
-
-	cancel_work_sync(&adapter->stat_work);
-
-	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	sysfs_remove_group(&ccw_device->dev.kobj, &zfcp_sysfs_adapter_attrs);
-
-	dev_set_drvdata(&ccw_device->dev, NULL);
+	struct ccw_device *cdev = adapter->ccw_device;
 
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	zfcp_fc_gs_destroy(adapter);
-	zfcp_erp_thread_kill(adapter);
-	zfcp_destroy_adapter_work_queue(adapter);
-	zfcp_dbf_adapter_unregister(adapter->dbf);
 	zfcp_free_low_mem_buffers(adapter);
-	zfcp_qdio_destroy(adapter->qdio);
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
 	kfree(adapter);
-	put_device(&ccw_device->dev);
+	put_device(&cdev->dev);
 }
 
 /**
@@ -636,7 +631,7 @@ static void zfcp_port_release(struct dev
 	struct zfcp_port *port = container_of(dev, struct zfcp_port,
 					      sysfs_device);
 
-	kref_put(&port->adapter->ref, zfcp_adapter_release);
+	zfcp_ccw_adapter_put(port->adapter);
 	kfree(port);
 }
 
@@ -647,7 +642,6 @@ static void zfcp_port_release(struct dev
  * @status: initial status for the port
  * @d_id: destination id of the remote port to be enqueued
  * Returns: pointer to enqueued port on success, ERR_PTR on error
- * Locks: config_mutex must be held to serialize changes to the port list
  *
  * All port internal structures are set up and the sysfs entry is generated.
  * d_id is used to enqueue ports with a well known address like the Directory
@@ -718,7 +712,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 err_out_put:
 	device_unregister(&port->sysfs_device);
 err_out:
-	kref_put(&adapter->ref, zfcp_adapter_release);
+	zfcp_ccw_adapter_put(adapter);
 	return ERR_PTR(retval);
 }
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:38.000000000 +0100
@@ -13,20 +13,42 @@
 
 #define ZFCP_MODEL_PRIV 0x4
 
+static DEFINE_SPINLOCK(zfcp_ccw_adapter_ref_lock);
+
+struct zfcp_adapter *zfcp_ccw_adapter_by_cdev(struct ccw_device *cdev)
+{
+	struct zfcp_adapter *adapter;
+	unsigned long flags;
+
+	spin_lock_irqsave(&zfcp_ccw_adapter_ref_lock, flags);
+	adapter = dev_get_drvdata(&cdev->dev);
+	if (adapter)
+		kref_get(&adapter->ref);
+	spin_unlock_irqrestore(&zfcp_ccw_adapter_ref_lock, flags);
+	return adapter;
+}
+
+void zfcp_ccw_adapter_put(struct zfcp_adapter *adapter)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zfcp_ccw_adapter_ref_lock, flags);
+	kref_put(&adapter->ref, zfcp_adapter_release);
+	spin_unlock_irqrestore(&zfcp_ccw_adapter_ref_lock, flags);
+}
+
 static int zfcp_ccw_suspend(struct ccw_device *cdev)
 
 {
-	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 
 	if (!adapter)
 		return 0;
 
-	mutex_lock(&zfcp_data.config_mutex);
-
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsusp1", NULL);
 	zfcp_erp_wait(adapter);
 
-	mutex_unlock(&zfcp_data.config_mutex);
+	zfcp_ccw_adapter_put(adapter);
 
 	return 0;
 }
@@ -34,7 +56,7 @@ static int zfcp_ccw_suspend(struct ccw_d
 static int zfcp_ccw_activate(struct ccw_device *cdev)
 
 {
-	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 
 	if (!adapter)
 		return 0;
@@ -46,6 +68,8 @@ static int zfcp_ccw_activate(struct ccw_
 	zfcp_erp_wait(adapter);
 	flush_work(&adapter->scan_work);
 
+	zfcp_ccw_adapter_put(adapter);
+
 	return 0;
 }
 
@@ -67,28 +91,28 @@ int zfcp_ccw_priv_sch(struct zfcp_adapte
 
 /**
  * zfcp_ccw_probe - probe function of zfcp driver
- * @ccw_device: pointer to belonging ccw device
+ * @cdev: pointer to belonging ccw device
  *
  * This function gets called by the common i/o layer for each FCP
  * device found on the current system. This is only a stub to make cio
  * work: To only allocate adapter resources for devices actually used,
  * the allocation is deferred to the first call to ccw_set_online.
  */
-static int zfcp_ccw_probe(struct ccw_device *ccw_device)
+static int zfcp_ccw_probe(struct ccw_device *cdev)
 {
 	return 0;
 }
 
 /**
  * zfcp_ccw_remove - remove function of zfcp driver
- * @ccw_device: pointer to belonging ccw device
+ * @cdev: pointer to belonging ccw device
  *
  * This function gets called by the common i/o layer and removes an adapter
  * from the system. Task of this function is to get rid of all units and
  * ports that belong to this adapter. And in addition all resources of this
  * adapter will be freed too.
  */
-static void zfcp_ccw_remove(struct ccw_device *ccw_device)
+static void zfcp_ccw_remove(struct ccw_device *cdev)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port, *p;
@@ -96,22 +120,12 @@ static void zfcp_ccw_remove(struct ccw_d
 	LIST_HEAD(unit_remove_lh);
 	LIST_HEAD(port_remove_lh);
 
-	ccw_device_set_offline(ccw_device);
-
-	mutex_lock(&zfcp_data.config_mutex);
-	adapter = dev_get_drvdata(&ccw_device->dev);
-	mutex_unlock(&zfcp_data.config_mutex);
+	ccw_device_set_offline(cdev);
 
+	adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	if (!adapter)
 		return;
 
-	cancel_work_sync(&adapter->scan_work);
-
-	mutex_lock(&zfcp_data.config_mutex);
-
-	/* this also removes the scsi devices, so call it first */
-	zfcp_adapter_scsi_unregister(adapter);
-
 	write_lock_irq(&adapter->port_list_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list, list) {
 		write_lock(&port->unit_list_lock);
@@ -126,7 +140,7 @@ static void zfcp_ccw_remove(struct ccw_d
 	}
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 	write_unlock_irq(&adapter->port_list_lock);
-	mutex_unlock(&zfcp_data.config_mutex);
+	zfcp_ccw_adapter_put(adapter); /* put from zfcp_ccw_adapter_by_cdev */
 
 	list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
 		zfcp_device_unregister(&unit->sysfs_device,
@@ -136,12 +150,12 @@ static void zfcp_ccw_remove(struct ccw_d
 		zfcp_device_unregister(&port->sysfs_device,
 				       &zfcp_sysfs_port_attrs);
 
-	kref_put(&adapter->ref, zfcp_adapter_release);
+	zfcp_adapter_unregister(adapter);
 }
 
 /**
  * zfcp_ccw_set_online - set_online function of zfcp driver
- * @ccw_device: pointer to belonging ccw device
+ * @cdev: pointer to belonging ccw device
  *
  * This function gets called by the common i/o layer and sets an
  * adapter into state online.  The first call will allocate all
@@ -152,23 +166,20 @@ static void zfcp_ccw_remove(struct ccw_d
  * the SCSI stack, that the QDIO queues will be set up and that the
  * adapter will be opened.
  */
-static int zfcp_ccw_set_online(struct ccw_device *ccw_device)
+static int zfcp_ccw_set_online(struct ccw_device *cdev)
 {
-	struct zfcp_adapter *adapter;
-	int ret = 0;
-
-	mutex_lock(&zfcp_data.config_mutex);
-	adapter = dev_get_drvdata(&ccw_device->dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 
 	if (!adapter) {
-		ret = zfcp_adapter_enqueue(ccw_device);
-		if (ret) {
-			dev_err(&ccw_device->dev,
+		adapter = zfcp_adapter_enqueue(cdev);
+
+		if (IS_ERR(adapter)) {
+			dev_err(&cdev->dev,
 				"Setting up data structures for the "
 				"FCP adapter failed\n");
-			goto out;
+			return PTR_ERR(adapter);
 		}
-		adapter = dev_get_drvdata(&ccw_device->dev);
+		kref_get(&adapter->ref);
 	}
 
 	/* initialize request counter */
@@ -180,58 +191,61 @@ static int zfcp_ccw_set_online(struct cc
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"ccsonl2", NULL);
 	zfcp_erp_wait(adapter);
-out:
-	mutex_unlock(&zfcp_data.config_mutex);
-	if (!ret)
-		flush_work(&adapter->scan_work);
-	return ret;
+
+	flush_work(&adapter->scan_work);
+
+	zfcp_ccw_adapter_put(adapter);
+	return 0;
 }
 
 /**
  * zfcp_ccw_set_offline - set_offline function of zfcp driver
- * @ccw_device: pointer to belonging ccw device
+ * @cdev: pointer to belonging ccw device
  *
  * This function gets called by the common i/o layer and sets an adapter
  * into state offline.
  */
-static int zfcp_ccw_set_offline(struct ccw_device *ccw_device)
+static int zfcp_ccw_set_offline(struct ccw_device *cdev)
 {
-	struct zfcp_adapter *adapter;
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+
+	if (!adapter)
+		return 0;
 
-	mutex_lock(&zfcp_data.config_mutex);
-	adapter = dev_get_drvdata(&ccw_device->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
-	mutex_unlock(&zfcp_data.config_mutex);
+
+	zfcp_ccw_adapter_put(adapter);
 	return 0;
 }
 
 /**
  * zfcp_ccw_notify - ccw notify function
- * @ccw_device: pointer to belonging ccw device
+ * @cdev: pointer to belonging ccw device
  * @event: indicates if adapter was detached or attached
  *
  * This function gets called by the common i/o layer if an adapter has gone
  * or reappeared.
  */
-static int zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
+static int zfcp_ccw_notify(struct ccw_device *cdev, int event)
 {
-	struct zfcp_adapter *adapter = dev_get_drvdata(&ccw_device->dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+
+	if (!adapter)
+		return 1;
 
 	switch (event) {
 	case CIO_GONE:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The FCP device has been detached\n");
+		dev_warn(&cdev->dev, "The FCP device has been detached\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti1", NULL);
 		break;
 	case CIO_NO_PATH:
-		dev_warn(&adapter->ccw_device->dev,
+		dev_warn(&cdev->dev,
 			 "The CHPID for the FCP device is offline\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti2", NULL);
 		break;
 	case CIO_OPER:
-		dev_info(&adapter->ccw_device->dev,
-			 "The FCP device is operational again\n");
+		dev_info(&cdev->dev, "The FCP device is operational again\n");
 		zfcp_erp_modify_adapter_status(adapter, "ccnoti3", NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
@@ -239,11 +253,13 @@ static int zfcp_ccw_notify(struct ccw_de
 					"ccnoti4", NULL);
 		break;
 	case CIO_BOXED:
-		dev_warn(&adapter->ccw_device->dev, "The FCP device "
-			 "did not respond within the specified time\n");
+		dev_warn(&cdev->dev, "The FCP device did not respond within "
+				     "the specified time\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti5", NULL);
 		break;
 	}
+
+	zfcp_ccw_adapter_put(adapter);
 	return 1;
 }
 
@@ -253,18 +269,16 @@ static int zfcp_ccw_notify(struct ccw_de
  */
 static void zfcp_ccw_shutdown(struct ccw_device *cdev)
 {
-	struct zfcp_adapter *adapter;
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 
-	mutex_lock(&zfcp_data.config_mutex);
-	adapter = dev_get_drvdata(&cdev->dev);
 	if (!adapter)
-		goto out;
+		return;
 
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
-out:
-	mutex_unlock(&zfcp_data.config_mutex);
+
+	zfcp_ccw_adapter_put(adapter);
 }
 
 struct ccw_driver zfcp_ccw_driver = {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_cfdc.c linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c
--- linux-2.6/drivers/s390/scsi/zfcp_cfdc.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c	2009-11-23 09:59:38.000000000 +0100
@@ -86,22 +86,17 @@ static int zfcp_cfdc_copy_to_user(void _
 static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
 {
 	char busid[9];
-	struct ccw_device *ccwdev;
-	struct zfcp_adapter *adapter = NULL;
+	struct ccw_device *cdev;
+	struct zfcp_adapter *adapter;
 
 	snprintf(busid, sizeof(busid), "0.0.%04x", devno);
-	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
-	if (!ccwdev)
-		goto out;
-
-	adapter = dev_get_drvdata(&ccwdev->dev);
-	if (!adapter)
-		goto out_put;
-
-	kref_get(&adapter->ref);
-out_put:
-	put_device(&ccwdev->dev);
-out:
+	cdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!cdev)
+		return NULL;
+
+	adapter = zfcp_ccw_adapter_by_cdev(cdev);
+
+	put_device(&cdev->dev);
 	return adapter;
 }
 
@@ -244,7 +239,7 @@ static long zfcp_cfdc_dev_ioctl(struct f
  free_sg:
 	zfcp_sg_free_table(fsf_cfdc->sg, ZFCP_CFDC_PAGES);
  adapter_put:
-	kref_put(&adapter->ref, zfcp_adapter_release);
+	zfcp_ccw_adapter_put(adapter);
  free_buffer:
 	kfree(data);
  no_mem_sense:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:38.000000000 +0100
@@ -595,7 +595,6 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-	struct mutex		config_mutex;
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:38.000000000 +0100
@@ -14,7 +14,7 @@
 /* zfcp_aux.c */
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, u64);
 extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, u64);
-extern int zfcp_adapter_enqueue(struct ccw_device *);
+extern struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *);
 extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
 extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, u64);
@@ -24,11 +24,14 @@ extern int zfcp_sg_setup_table(struct sc
 extern void zfcp_device_unregister(struct device *,
 				   const struct attribute_group *);
 extern void zfcp_adapter_release(struct kref *);
+extern void zfcp_adapter_unregister(struct zfcp_adapter *);
 
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
 extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
 extern struct ccw_driver zfcp_ccw_driver;
+extern struct zfcp_adapter *zfcp_ccw_adapter_by_cdev(struct ccw_device *);
+extern void zfcp_ccw_adapter_put(struct zfcp_adapter *);
 
 /* zfcp_cfdc.c */
 extern struct miscdevice zfcp_cfdc_misc;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:38.000000000 +0100
@@ -622,8 +622,6 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 		return -E2BIG;
 	}
 
-	mutex_lock(&zfcp_data.config_mutex);
-
 	/* first entry is the header */
 	for (x = 1; x < max_entries && !last; x++) {
 		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
@@ -655,7 +653,6 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	list_for_each_entry_safe(port, tmp, &adapter->port_list, list)
 		zfcp_fc_validate_port(port, &remove_lh);
 	write_unlock_irqrestore(&adapter->port_list_lock, flags);
-	mutex_unlock(&zfcp_data.config_mutex);
 
 	list_for_each_entry_safe(port, tmp, &remove_lh, list) {
 		zfcp_erp_port_shutdown(port, 0, "fcegpf2", NULL);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:38.000000000 +0100
@@ -26,23 +26,36 @@ static ssize_t zfcp_sysfs_##_feat##_##_n
 static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
 		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
 
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, status, "0x%08x\n",
-		 atomic_read(&adapter->status));
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwnn, "0x%016llx\n",
-		 (unsigned long long) adapter->peer_wwnn);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwpn, "0x%016llx\n",
-		 (unsigned long long) adapter->peer_wwpn);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_d_id, "0x%06x\n",
-		 adapter->peer_d_id);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, card_version, "0x%04x\n",
-		 adapter->hydra_version);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, lic_version, "0x%08x\n",
-		 adapter->fsf_lic_version);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, hardware_version, "0x%08x\n",
-		 adapter->hardware_version);
-ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, in_recovery, "%d\n",
-		 (atomic_read(&adapter->status) &
-		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
+#define ZFCP_DEFINE_A_ATTR(_name, _format, _value)			     \
+static ssize_t zfcp_sysfs_adapter_##_name##_show(struct device *dev,	     \
+						 struct device_attribute *at,\
+						 char *buf)		     \
+{									     \
+	struct ccw_device *cdev = to_ccwdev(dev);			     \
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);	     \
+	int i;								     \
+									     \
+	if (!adapter)							     \
+		return -ENODEV;						     \
+									     \
+	i = sprintf(buf, _format, _value);				     \
+	zfcp_ccw_adapter_put(adapter);					     \
+	return i;							     \
+}									     \
+static ZFCP_DEV_ATTR(adapter, _name, S_IRUGO,				     \
+		     zfcp_sysfs_adapter_##_name##_show, NULL);
+
+ZFCP_DEFINE_A_ATTR(status, "0x%08x\n", atomic_read(&adapter->status));
+ZFCP_DEFINE_A_ATTR(peer_wwnn, "0x%016llx\n",
+		   (unsigned long long) adapter->peer_wwnn);
+ZFCP_DEFINE_A_ATTR(peer_wwpn, "0x%016llx\n",
+		   (unsigned long long) adapter->peer_wwpn);
+ZFCP_DEFINE_A_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
+ZFCP_DEFINE_A_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
+ZFCP_DEFINE_A_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
+ZFCP_DEFINE_A_ATTR(hardware_version, "0x%08x\n", adapter->hardware_version);
+ZFCP_DEFINE_A_ATTR(in_recovery, "%d\n", (atomic_read(&adapter->status) &
+					 ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
 
 ZFCP_DEFINE_ATTR(zfcp_port, port, status, "0x%08x\n",
 		 atomic_read(&port->status));
@@ -88,7 +101,6 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 	unsigned long val;						       \
 	int retval = 0;							       \
 									       \
-	mutex_lock(&zfcp_data.config_mutex);				       \
 	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_REMOVE) {	       \
 		retval = -EBUSY;					       \
 		goto out;						       \
@@ -105,28 +117,89 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 				  _reopen_id, NULL);			       \
 	zfcp_erp_wait(_adapter);					       \
 out:									       \
-	mutex_unlock(&zfcp_data.config_mutex);				       \
 	return retval ? retval : (ssize_t) count;			       \
 }									       \
 static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
 		     zfcp_sysfs_##_feat##_failed_show,			       \
 		     zfcp_sysfs_##_feat##_failed_store);
 
-ZFCP_SYSFS_FAILED(zfcp_adapter, adapter, adapter, "syafai1", "syafai2");
 ZFCP_SYSFS_FAILED(zfcp_port, port, port->adapter, "sypfai1", "sypfai2");
 ZFCP_SYSFS_FAILED(zfcp_unit, unit, unit->port->adapter, "syufai1", "syufai2");
 
+static ssize_t zfcp_sysfs_adapter_failed_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct ccw_device *cdev = to_ccwdev(dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+	int i;
+
+	if (!adapter)
+		return -ENODEV;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		i = sprintf(buf, "1\n");
+	else
+		i = sprintf(buf, "0\n");
+
+	zfcp_ccw_adapter_put(adapter);
+	return i;
+}
+
+static ssize_t zfcp_sysfs_adapter_failed_store(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	struct ccw_device *cdev = to_ccwdev(dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+	unsigned long val;
+	int retval = 0;
+
+	if (!adapter)
+		return -ENODEV;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	if (strict_strtoul(buf, 0, &val) || val != 0) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	zfcp_erp_modify_adapter_status(adapter, "syafai1", NULL,
+				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
+				"syafai2", NULL);
+	zfcp_erp_wait(adapter);
+out:
+	zfcp_ccw_adapter_put(adapter);
+	return retval ? retval : (ssize_t) count;
+}
+static ZFCP_DEV_ATTR(adapter, failed, S_IWUSR | S_IRUGO,
+		     zfcp_sysfs_adapter_failed_show,
+		     zfcp_sysfs_adapter_failed_store);
+
 static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
-	struct zfcp_adapter *adapter = dev_get_drvdata(dev);
+	struct ccw_device *cdev = to_ccwdev(dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	int ret;
 
-	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE)
-		return -EBUSY;
+	if (!adapter)
+		return -ENODEV;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	ret = zfcp_fc_scan_ports(adapter);
+out:
+	zfcp_ccw_adapter_put(adapter);
 	return ret ? ret : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
@@ -136,12 +209,15 @@ static ssize_t zfcp_sysfs_port_remove_st
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
-	struct zfcp_adapter *adapter = dev_get_drvdata(dev);
+	struct ccw_device *cdev = to_ccwdev(dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	struct zfcp_port *port;
 	u64 wwpn;
 	int retval = 0;
 
-	mutex_lock(&zfcp_data.config_mutex);
+	if (!adapter)
+		return -ENODEV;
+
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -169,7 +245,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	zfcp_erp_port_shutdown(port, 0, "syprs_1", NULL);
 	zfcp_device_unregister(&port->sysfs_device, &zfcp_sysfs_port_attrs);
  out:
-	mutex_unlock(&zfcp_data.config_mutex);
+	zfcp_ccw_adapter_put(adapter);
 	return retval ? retval : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_remove, S_IWUSR, NULL,
@@ -203,7 +279,6 @@ static ssize_t zfcp_sysfs_unit_add_store
 	u64 fcp_lun;
 	int retval = -EINVAL;
 
-	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -222,7 +297,6 @@ static ssize_t zfcp_sysfs_unit_add_store
 	zfcp_erp_wait(unit->port->adapter);
 	flush_work(&unit->scsi_work);
 out:
-	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
@@ -236,7 +310,6 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	u64 fcp_lun;
 	int retval = 0;
 
-	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -267,7 +340,6 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
 	zfcp_device_unregister(&unit->sysfs_device, &zfcp_sysfs_unit_attrs);
 out:
-	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);

