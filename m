From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/22] zfcp: Replace local reference counting with common kref
Date: Tue, 24 Nov 2009 16:53:59 +0100
Message-ID: <20091124160136.369042000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44302 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=701-zfcp-kref.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Replace the local reference counting by already available mechanisms
offered by kref. Where possible existing device structures were used,
including the same functionality.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |  231 +++++++++++++++++++----------------------
 drivers/s390/scsi/zfcp_ccw.c   |   16 +-
 drivers/s390/scsi/zfcp_cfdc.c  |    5 
 drivers/s390/scsi/zfcp_dbf.c   |    2 
 drivers/s390/scsi/zfcp_def.h   |   53 ---------
 drivers/s390/scsi/zfcp_erp.c   |   20 +--
 drivers/s390/scsi/zfcp_ext.h   |    6 -
 drivers/s390/scsi/zfcp_fc.c    |   42 ++++---
 drivers/s390/scsi/zfcp_fsf.c   |   12 +-
 drivers/s390/scsi/zfcp_scsi.c  |   23 +---
 drivers/s390/scsi/zfcp_sysfs.c |   46 +++-----
 11 files changed, 197 insertions(+), 259 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-11-24 12:36:36.000000000 +0100
@@ -96,13 +96,12 @@ static void __init zfcp_init_device_conf
 	adapter = dev_get_drvdata(&ccwdev->dev);
 	if (!adapter)
 		goto out_unlock;
-	zfcp_adapter_get(adapter);
+	kref_get(&adapter->ref);
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
 	if (!port)
 		goto out_port;
 
-	zfcp_port_get(port);
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
@@ -113,11 +112,10 @@ static void __init zfcp_init_device_conf
 	flush_work(&unit->scsi_work);
 
 	mutex_lock(&zfcp_data.config_mutex);
-	zfcp_unit_put(unit);
 out_unit:
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 out_port:
-	zfcp_adapter_put(adapter);
+	kref_put(&adapter->ref, zfcp_adapter_release);
 out_unlock:
 	mutex_unlock(&zfcp_data.config_mutex);
 out_ccwdev:
@@ -244,7 +242,7 @@ struct zfcp_unit *zfcp_get_unit_by_lun(s
 	list_for_each_entry(unit, &port->unit_list, list)
 		if ((unit->fcp_lun == fcp_lun) &&
 		    !(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_REMOVE)) {
-			zfcp_unit_get(unit);
+			get_device(&unit->sysfs_device);
 			read_unlock_irqrestore(&port->unit_list_lock, flags);
 			return unit;
 		}
@@ -269,7 +267,7 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	list_for_each_entry(port, &adapter->port_list, list)
 		if ((port->wwpn == wwpn) &&
 		    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE)) {
-			zfcp_port_get(port);
+			get_device(&port->sysfs_device);
 			read_unlock_irqrestore(&adapter->port_list_lock, flags);
 			return port;
 		}
@@ -277,9 +275,20 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	return NULL;
 }
 
-static void zfcp_sysfs_unit_release(struct device *dev)
+/**
+ * zfcp_unit_release - dequeue unit
+ * @dev: pointer to device
+ *
+ * waits until all work is done on unit and removes it then from the unit->list
+ * of the associated port.
+ */
+static void zfcp_unit_release(struct device *dev)
 {
-	kfree(container_of(dev, struct zfcp_unit, sysfs_device));
+	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit,
+					      sysfs_device);
+
+	put_device(&unit->port->sysfs_device);
+	kfree(unit);
 }
 
 /**
@@ -294,36 +303,39 @@ static void zfcp_sysfs_unit_release(stru
 struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, u64 fcp_lun)
 {
 	struct zfcp_unit *unit;
+	int retval = -ENOMEM;
+
+	get_device(&port->sysfs_device);
 
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
 	if (unit) {
-		zfcp_unit_put(unit);
-		return ERR_PTR(-EINVAL);
+		put_device(&unit->sysfs_device);
+		retval = -EEXIST;
+		goto err_out;
 	}
 
 	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
 	if (!unit)
-		return ERR_PTR(-ENOMEM);
-
-	atomic_set(&unit->refcount, 0);
-	init_waitqueue_head(&unit->remove_wq);
-	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
+		goto err_out;
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
+	unit->sysfs_device.parent = &port->sysfs_device;
+	unit->sysfs_device.release = zfcp_unit_release;
 
 	if (dev_set_name(&unit->sysfs_device, "0x%016llx",
 			 (unsigned long long) fcp_lun)) {
 		kfree(unit);
-		return ERR_PTR(-ENOMEM);
+		goto err_out;
 	}
-	unit->sysfs_device.parent = &port->sysfs_device;
-	unit->sysfs_device.release = zfcp_sysfs_unit_release;
 	dev_set_drvdata(&unit->sysfs_device, unit);
+	retval = -EINVAL;
 
 	/* mark unit unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 
+	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
+
 	spin_lock_init(&unit->latencies.lock);
 	unit->latencies.write.channel.min = 0xFFFFFFFF;
 	unit->latencies.write.fabric.min = 0xFFFFFFFF;
@@ -334,16 +346,12 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 
 	if (device_register(&unit->sysfs_device)) {
 		put_device(&unit->sysfs_device);
-		return ERR_PTR(-EINVAL);
+		goto err_out;
 	}
 
 	if (sysfs_create_group(&unit->sysfs_device.kobj,
-			       &zfcp_sysfs_unit_attrs)) {
-		device_unregister(&unit->sysfs_device);
-		return ERR_PTR(-EINVAL);
-	}
-
-	zfcp_unit_get(unit);
+			       &zfcp_sysfs_unit_attrs))
+		goto err_out_put;
 
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
@@ -352,27 +360,13 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
 
-	zfcp_port_get(port);
-
 	return unit;
-}
-
-/**
- * zfcp_unit_dequeue - dequeue unit
- * @unit: pointer to zfcp_unit
- *
- * waits until all work is done on unit and removes it then from the unit->list
- * of the associated port.
- */
-void zfcp_unit_dequeue(struct zfcp_unit *unit)
-{
-	struct zfcp_port *port = unit->port;
 
-	wait_event(unit->remove_wq, atomic_read(&unit->refcount) == 0);
-	list_del(&unit->list); /* no list locking required */
-	zfcp_port_put(port);
-	sysfs_remove_group(&unit->sysfs_device.kobj, &zfcp_sysfs_unit_attrs);
+err_out_put:
 	device_unregister(&unit->sysfs_device);
+err_out:
+	put_device(&port->sysfs_device);
+	return ERR_PTR(retval);
 }
 
 static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
@@ -518,41 +512,44 @@ int zfcp_adapter_enqueue(struct ccw_devi
 {
 	struct zfcp_adapter *adapter;
 
-	/*
-	 * Note: It is safe to release the list_lock, as any list changes
-	 * are protected by the config_mutex, which must be held to get here
-	 */
+	if (!get_device(&ccw_device->dev))
+		return -ENODEV;
 
 	adapter = kzalloc(sizeof(struct zfcp_adapter), GFP_KERNEL);
-	if (!adapter)
+	if (!adapter) {
+		put_device(&ccw_device->dev);
 		return -ENOMEM;
+	}
+
+	kref_init(&adapter->ref);
 
 	ccw_device->handler = NULL;
 	adapter->ccw_device = ccw_device;
-	atomic_set(&adapter->refcount, 0);
+
+	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
+	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
 
 	if (zfcp_qdio_setup(adapter))
-		goto qdio_failed;
+		goto failed;
 
 	if (zfcp_allocate_low_mem_buffers(adapter))
-		goto low_mem_buffers_failed;
+		goto failed;
 
 	if (zfcp_reqlist_alloc(adapter))
-		goto low_mem_buffers_failed;
+		goto failed;
 
 	if (zfcp_dbf_adapter_register(adapter))
-		goto debug_register_failed;
+		goto failed;
 
 	if (zfcp_setup_adapter_work_queue(adapter))
-		goto work_queue_failed;
+		goto failed;
 
 	if (zfcp_fc_gs_setup(adapter))
-		goto generic_services_failed;
+		goto failed;
 
 	rwlock_init(&adapter->port_list_lock);
 	INIT_LIST_HEAD(&adapter->port_list);
 
-	init_waitqueue_head(&adapter->remove_wq);
 	init_waitqueue_head(&adapter->erp_ready_wq);
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
@@ -565,10 +562,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	rwlock_init(&adapter->abort_lock);
 
 	if (zfcp_erp_thread_setup(adapter))
-		goto erp_thread_failed;
-
-	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
-	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
+		goto failed;
 
 	adapter->service_level.seq_print = zfcp_print_sl;
 
@@ -579,54 +573,37 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	if (sysfs_create_group(&ccw_device->dev.kobj,
 			       &zfcp_sysfs_adapter_attrs))
-		goto sysfs_failed;
+		goto failed;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
 
-sysfs_failed:
-	zfcp_erp_thread_kill(adapter);
-erp_thread_failed:
-	zfcp_fc_gs_destroy(adapter);
-generic_services_failed:
-	zfcp_destroy_adapter_work_queue(adapter);
-work_queue_failed:
-	zfcp_dbf_adapter_unregister(adapter->dbf);
-debug_register_failed:
-	dev_set_drvdata(&ccw_device->dev, NULL);
-	kfree(adapter->req_list);
-low_mem_buffers_failed:
-	zfcp_free_low_mem_buffers(adapter);
-qdio_failed:
-	zfcp_qdio_destroy(adapter->qdio);
-	kfree(adapter);
+failed:
+	kref_put(&adapter->ref, zfcp_adapter_release);
 	return -ENOMEM;
 }
 
 /**
- * zfcp_adapter_dequeue - remove the adapter from the resource list
- * @adapter: pointer to struct zfcp_adapter which should be removed
+ * zfcp_adapter_release - remove the adapter from the resource list
+ * @ref: pointer to struct kref
  * locks:	adapter list write lock is assumed to be held by caller
  */
-void zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
+void zfcp_adapter_release(struct kref *ref)
 {
-	int retval = 0;
-	unsigned long flags;
+	struct zfcp_adapter *adapter = container_of(ref, struct zfcp_adapter,
+						    ref);
+	struct ccw_device *ccw_device = adapter->ccw_device;
 
 	cancel_work_sync(&adapter->stat_work);
+
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
-			   &zfcp_sysfs_adapter_attrs);
-	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
-	/* sanity check: no pending FSF requests */
-	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	retval = zfcp_reqlist_isempty(adapter);
-	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-	if (!retval)
-		return;
+	sysfs_remove_group(&ccw_device->dev.kobj, &zfcp_sysfs_adapter_attrs);
+
+	dev_set_drvdata(&ccw_device->dev, NULL);
 
+	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	zfcp_fc_gs_destroy(adapter);
 	zfcp_erp_thread_kill(adapter);
 	zfcp_destroy_adapter_work_queue(adapter);
@@ -637,11 +614,30 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
 	kfree(adapter);
+	put_device(&ccw_device->dev);
+}
+
+/**
+ * zfcp_device_unregister - remove port, unit from system
+ * @dev: reference to device which is to be removed
+ * @grp: related reference to attribute group
+ *
+ * Helper function to unregister port, unit from system
+ */
+void zfcp_device_unregister(struct device *dev,
+			    const struct attribute_group *grp)
+{
+	sysfs_remove_group(&dev->kobj, grp);
+	device_unregister(dev);
 }
 
-static void zfcp_sysfs_port_release(struct device *dev)
+static void zfcp_port_release(struct device *dev)
 {
-	kfree(container_of(dev, struct zfcp_port, sysfs_device));
+	struct zfcp_port *port = container_of(dev, struct zfcp_port,
+					      sysfs_device);
+
+	kref_put(&port->adapter->ref, zfcp_adapter_release);
+	kfree(port);
 }
 
 /**
@@ -661,21 +657,24 @@ struct zfcp_port *zfcp_port_enqueue(stru
 				     u32 status, u32 d_id)
 {
 	struct zfcp_port *port;
+	int retval = -ENOMEM;
+
+	kref_get(&adapter->ref);
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
 	if (port) {
-		zfcp_port_put(port);
-		return ERR_PTR(-EEXIST);
+		put_device(&port->sysfs_device);
+		retval = -EEXIST;
+		goto err_out;
 	}
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
-		return ERR_PTR(-ENOMEM);
+		goto err_out;
 
 	rwlock_init(&port->unit_list_lock);
 	INIT_LIST_HEAD(&port->unit_list);
 
-	init_waitqueue_head(&port->remove_wq);
 	INIT_WORK(&port->gid_pn_work, zfcp_fc_port_did_lookup);
 	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
 	INIT_WORK(&port->rport_work, zfcp_scsi_rport_work);
@@ -684,32 +683,28 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	port->d_id = d_id;
 	port->wwpn = wwpn;
 	port->rport_task = RPORT_NONE;
+	port->sysfs_device.parent = &adapter->ccw_device->dev;
+	port->sysfs_device.release = zfcp_port_release;
 
 	/* mark port unusable as long as sysfs registration is not complete */
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
-	atomic_set(&port->refcount, 0);
 
 	if (dev_set_name(&port->sysfs_device, "0x%016llx",
 			 (unsigned long long)wwpn)) {
 		kfree(port);
-		return ERR_PTR(-ENOMEM);
+		goto err_out;
 	}
-	port->sysfs_device.parent = &adapter->ccw_device->dev;
-	port->sysfs_device.release = zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
+	retval = -EINVAL;
 
 	if (device_register(&port->sysfs_device)) {
 		put_device(&port->sysfs_device);
-		return ERR_PTR(-EINVAL);
+		goto err_out;
 	}
 
 	if (sysfs_create_group(&port->sysfs_device.kobj,
-			       &zfcp_sysfs_port_attrs)) {
-		device_unregister(&port->sysfs_device);
-		return ERR_PTR(-EINVAL);
-	}
-
-	zfcp_port_get(port);
+			       &zfcp_sysfs_port_attrs))
+		goto err_out_put;
 
 	write_lock_irq(&adapter->port_list_lock);
 	list_add_tail(&port->list, &adapter->port_list);
@@ -718,23 +713,13 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
 
-	zfcp_adapter_get(adapter);
 	return port;
-}
 
-/**
- * zfcp_port_dequeue - dequeues a port from the port list of the adapter
- * @port: pointer to struct zfcp_port which should be removed
- */
-void zfcp_port_dequeue(struct zfcp_port *port)
-{
-	struct zfcp_adapter *adapter = port->adapter;
-
-	list_del(&port->list); /* no list locking required here */
-	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
-	zfcp_adapter_put(adapter);
-	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
+err_out_put:
 	device_unregister(&port->sysfs_device);
+err_out:
+	kref_put(&adapter->ref, zfcp_adapter_release);
+	return ERR_PTR(retval);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-11-24 12:36:36.000000000 +0100
@@ -128,13 +128,15 @@ static void zfcp_ccw_remove(struct ccw_d
 	write_unlock_irq(&adapter->port_list_lock);
 	mutex_unlock(&zfcp_data.config_mutex);
 
-	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
-		list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
-			zfcp_unit_dequeue(unit);
-		zfcp_port_dequeue(port);
-	}
-	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
-	zfcp_adapter_dequeue(adapter);
+	list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
+		zfcp_device_unregister(&unit->sysfs_device,
+				       &zfcp_sysfs_unit_attrs);
+
+	list_for_each_entry_safe(port, p, &port_remove_lh, list)
+		zfcp_device_unregister(&port->sysfs_device,
+				       &zfcp_sysfs_port_attrs);
+
+	kref_put(&adapter->ref, zfcp_adapter_release);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_cfdc.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_cfdc.c	2009-11-24 12:36:36.000000000 +0100
@@ -98,7 +98,7 @@ static struct zfcp_adapter *zfcp_cfdc_ge
 	if (!adapter)
 		goto out_put;
 
-	zfcp_adapter_get(adapter);
+	kref_get(&adapter->ref);
 out_put:
 	put_device(&ccwdev->dev);
 out:
@@ -212,7 +212,6 @@ static long zfcp_cfdc_dev_ioctl(struct f
 		retval = -ENXIO;
 		goto free_buffer;
 	}
-	zfcp_adapter_get(adapter);
 
 	retval = zfcp_cfdc_sg_setup(data->command, fsf_cfdc->sg,
 				    data_user->control_file);
@@ -245,7 +244,7 @@ static long zfcp_cfdc_dev_ioctl(struct f
  free_sg:
 	zfcp_sg_free_table(fsf_cfdc->sg, ZFCP_CFDC_PAGES);
  adapter_put:
-	zfcp_adapter_put(adapter);
+	kref_put(&adapter->ref, zfcp_adapter_release);
  free_buffer:
 	kfree(data);
  no_mem_sense:
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 12:36:36.000000000 +0100
@@ -1067,6 +1067,8 @@ err_out:
  */
 void zfcp_dbf_adapter_unregister(struct zfcp_dbf *dbf)
 {
+	if (!dbf)
+		return;
 	debug_unregister(dbf->scsi);
 	debug_unregister(dbf->san);
 	debug_unregister(dbf->hba);
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:36:36.000000000 +0100
@@ -446,9 +446,7 @@ struct zfcp_qdio {
 };
 
 struct zfcp_adapter {
-	atomic_t                refcount;          /* reference count */
-	wait_queue_head_t	remove_wq;         /* can be used to wait for
-						      refcount drop to zero */
+	struct kref		ref;
 	u64			peer_wwnn;	   /* P2P peer WWNN */
 	u64			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
@@ -501,9 +499,6 @@ struct zfcp_port {
 	struct device          sysfs_device;   /* sysfs device */
 	struct fc_rport        *rport;         /* rport of fc transport class */
 	struct list_head       list;	       /* list of remote ports */
-	atomic_t               refcount;       /* reference count */
-	wait_queue_head_t      remove_wq;      /* can be used to wait for
-						  refcount drop to zero */
 	struct zfcp_adapter    *adapter;       /* adapter used to access port */
 	struct list_head	unit_list;	/* head of logical unit list */
 	rwlock_t		unit_list_lock; /* unit list lock */
@@ -525,9 +520,6 @@ struct zfcp_port {
 struct zfcp_unit {
 	struct device          sysfs_device;   /* sysfs device */
 	struct list_head       list;	       /* list of logical units */
-	atomic_t               refcount;       /* reference count */
-	wait_queue_head_t      remove_wq;      /* can be used to wait for
-						  refcount drop to zero */
 	struct zfcp_port       *port;	       /* remote port of unit */
 	atomic_t	       status;	       /* status of this logical unit */
 	u64		       fcp_lun;	       /* own FCP_LUN */
@@ -656,47 +648,4 @@ zfcp_reqlist_find_safe(struct zfcp_adapt
 	return NULL;
 }
 
-/*
- *  functions needed for reference/usage counting
- */
-
-static inline void
-zfcp_unit_get(struct zfcp_unit *unit)
-{
-	atomic_inc(&unit->refcount);
-}
-
-static inline void
-zfcp_unit_put(struct zfcp_unit *unit)
-{
-	if (atomic_dec_return(&unit->refcount) == 0)
-		wake_up(&unit->remove_wq);
-}
-
-static inline void
-zfcp_port_get(struct zfcp_port *port)
-{
-	atomic_inc(&port->refcount);
-}
-
-static inline void
-zfcp_port_put(struct zfcp_port *port)
-{
-	if (atomic_dec_return(&port->refcount) == 0)
-		wake_up(&port->remove_wq);
-}
-
-static inline void
-zfcp_adapter_get(struct zfcp_adapter *adapter)
-{
-	atomic_inc(&adapter->refcount);
-}
-
-static inline void
-zfcp_adapter_put(struct zfcp_adapter *adapter)
-{
-	if (atomic_dec_return(&adapter->refcount) == 0)
-		wake_up(&adapter->remove_wq);
-}
-
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_erp.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-11-24 12:36:36.000000000 +0100
@@ -174,7 +174,7 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	switch (need) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		zfcp_unit_get(unit);
+		get_device(&unit->sysfs_device);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
 		erp_action = &unit->erp_action;
 		if (!(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_RUNNING))
@@ -183,7 +183,7 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		zfcp_port_get(port);
+		get_device(&port->sysfs_device);
 		zfcp_erp_action_dismiss_port(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
@@ -192,7 +192,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		zfcp_adapter_get(adapter);
+		kref_get(&adapter->ref);
 		zfcp_erp_action_dismiss_adapter(adapter);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
 		erp_action = &adapter->erp_action;
@@ -1177,19 +1177,19 @@ static void zfcp_erp_action_cleanup(stru
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
-			zfcp_unit_get(unit);
+			get_device(&unit->sysfs_device);
 			if (scsi_queue_work(unit->port->adapter->scsi_host,
 					    &unit->scsi_work) <= 0)
-				zfcp_unit_put(unit);
+				put_device(&unit->sysfs_device);
 		}
-		zfcp_unit_put(unit);
+		put_device(&unit->sysfs_device);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (result == ZFCP_ERP_SUCCEEDED)
 			zfcp_scsi_schedule_rport_register(port);
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
@@ -1198,7 +1198,7 @@ static void zfcp_erp_action_cleanup(stru
 			schedule_work(&adapter->scan_work);
 		} else
 			unregister_service_level(&adapter->service_level);
-		zfcp_adapter_put(adapter);
+		kref_put(&adapter->ref, zfcp_adapter_release);
 		break;
 	}
 }
@@ -1224,8 +1224,9 @@ static int zfcp_erp_strategy(struct zfcp
 	unsigned long flags;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	write_lock_irqsave(&adapter->erp_lock, flags);
+	kref_get(&adapter->ref);
 
+	write_lock_irqsave(&adapter->erp_lock, flags);
 	zfcp_erp_strategy_check_fsfreq(erp_action);
 
 	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED) {
@@ -1282,6 +1283,7 @@ static int zfcp_erp_strategy(struct zfcp
 	if (retval != ZFCP_ERP_CONTINUES)
 		zfcp_erp_action_cleanup(erp_action, retval);
 
+	kref_put(&adapter->ref, zfcp_adapter_release);
 	return retval;
 }
 
--- a/drivers/s390/scsi/zfcp_ext.h	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-11-24 12:36:36.000000000 +0100
@@ -15,15 +15,15 @@
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, u64);
 extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, u64);
 extern int zfcp_adapter_enqueue(struct ccw_device *);
-extern void zfcp_adapter_dequeue(struct zfcp_adapter *);
 extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
-extern void zfcp_port_dequeue(struct zfcp_port *);
 extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, u64);
-extern void zfcp_unit_dequeue(struct zfcp_unit *);
 extern int zfcp_reqlist_isempty(struct zfcp_adapter *);
 extern void zfcp_sg_free_table(struct scatterlist *, int);
 extern int zfcp_sg_setup_table(struct scatterlist *, int);
+extern void zfcp_device_unregister(struct device *,
+				   const struct attribute_group *);
+extern void zfcp_adapter_release(struct kref *);
 
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 12:36:36.000000000 +0100
@@ -134,6 +134,8 @@ static void zfcp_fc_wka_port_force_offli
 
 void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *gs)
 {
+	if (!gs)
+		return;
 	zfcp_fc_wka_port_force_offline(&gs->ms);
 	zfcp_fc_wka_port_force_offline(&gs->ts);
 	zfcp_fc_wka_port_force_offline(&gs->ds);
@@ -356,7 +358,7 @@ void zfcp_fc_port_did_lookup(struct work
 
 	zfcp_erp_port_reopen(port, 0, "fcgpn_3", NULL);
 out:
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 }
 
 /**
@@ -365,9 +367,9 @@ out:
  */
 void zfcp_fc_trigger_did_lookup(struct zfcp_port *port)
 {
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 	if (!queue_work(port->adapter->work_queue, &port->gid_pn_work))
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 }
 
 /**
@@ -426,7 +428,7 @@ static void zfcp_fc_adisc_handler(unsign
 	zfcp_scsi_schedule_rport_register(port);
  out:
 	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 	kfree(adisc);
 }
 
@@ -468,7 +470,7 @@ void zfcp_fc_link_test_work(struct work_
 		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 	port->rport_task = RPORT_DEL;
 	zfcp_scsi_rport_work(&port->rport_work);
 
@@ -487,7 +489,7 @@ void zfcp_fc_link_test_work(struct work_
 	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
 
 out:
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 }
 
 /**
@@ -500,9 +502,9 @@ out:
  */
 void zfcp_fc_test_link(struct zfcp_port *port)
 {
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 	if (!queue_work(port->adapter->work_queue, &port->test_link_work))
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 }
 
 static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft, int buf_num)
@@ -576,7 +578,7 @@ static int zfcp_fc_send_gpn_ft(struct zf
 	return ret;
 }
 
-static void zfcp_fc_validate_port(struct zfcp_port *port)
+static void zfcp_fc_validate_port(struct zfcp_port *port, struct list_head *lh)
 {
 	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC))
 		return;
@@ -584,13 +586,11 @@ static void zfcp_fc_validate_port(struct
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
 	if ((port->supported_classes != 0) ||
-	    !list_empty(&port->unit_list)) {
-		zfcp_port_put(port);
+	    !list_empty(&port->unit_list))
 		return;
-	}
-	zfcp_erp_port_shutdown(port, 0, "fcpval1", NULL);
-	zfcp_port_put(port);
-	zfcp_port_dequeue(port);
+
+	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+	list_move_tail(&port->list, lh);
 }
 
 static int zfcp_fc_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
@@ -602,6 +602,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	struct zfcp_adapter *adapter = ct->wka_port->adapter;
 	struct zfcp_port *port, *tmp;
 	unsigned long flags;
+	LIST_HEAD(remove_lh);
 	u32 d_id;
 	int ret = 0, x, last = 0;
 
@@ -652,9 +653,16 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	zfcp_erp_wait(adapter);
 	write_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry_safe(port, tmp, &adapter->port_list, list)
-		zfcp_fc_validate_port(port);
+		zfcp_fc_validate_port(port, &remove_lh);
 	write_unlock_irqrestore(&adapter->port_list_lock, flags);
 	mutex_unlock(&zfcp_data.config_mutex);
+
+	list_for_each_entry_safe(port, tmp, &remove_lh, list) {
+		zfcp_erp_port_shutdown(port, 0, "fcegpf2", NULL);
+		zfcp_device_unregister(&port->sysfs_device,
+				       &zfcp_sysfs_port_attrs);
+	}
+
 	return ret;
 }
 
@@ -763,7 +771,7 @@ int zfcp_fc_execute_els_fc_job(struct fc
 		}
 
 		els_fc_job->els.d_id = port->d_id;
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 	} else {
 		port_did = job->request->rqst_data.h_els.port_id;
 		els_fc_job->els.d_id = (port_did[0] << 16) +
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:36:36.000000000 +0100
@@ -1492,7 +1492,7 @@ static void zfcp_fsf_open_port_handler(s
 	}
 
 out:
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 }
 
 /**
@@ -1530,14 +1530,14 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	req->data = port;
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -2335,7 +2335,7 @@ skip_fsfstatus:
 	else {
 		zfcp_fsf_send_fcp_command_task_handler(req);
 		req->unit = NULL;
-		zfcp_unit_put(unit);
+		put_device(&unit->sysfs_device);
 	}
 }
 
@@ -2387,7 +2387,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	zfcp_unit_get(unit);
+	get_device(&unit->sysfs_device);
 	req->unit = unit;
 	req->data = scsi_cmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
@@ -2463,7 +2463,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	goto out;
 
 failed_scsi_cmnd:
-	zfcp_unit_put(unit);
+	put_device(&unit->sysfs_device);
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:36.000000000 +0100
@@ -52,7 +52,7 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 	unit->device = NULL;
-	zfcp_unit_put(unit);
+	put_device(&unit->sysfs_device);
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
@@ -335,8 +335,7 @@ void zfcp_adapter_scsi_unregister(struct
 
 	read_lock_irq(&adapter->port_list_lock);
 	list_for_each_entry(port, &adapter->port_list, list)
-		if (port->rport)
-			port->rport = NULL;
+		port->rport = NULL;
 	read_unlock_irq(&adapter->port_list_lock);
 
 	fc_remove_host(shost);
@@ -356,7 +355,7 @@ zfcp_init_fc_host_stats(struct zfcp_adap
 		fc_stats = kmalloc(sizeof(*fc_stats), GFP_KERNEL);
 		if (!fc_stats)
 			return NULL;
-		adapter->fc_stats = fc_stats; /* freed in adater_dequeue */
+		adapter->fc_stats = fc_stats; /* freed in adapter_release */
 	}
 	memset(adapter->fc_stats, 0, sizeof(*adapter->fc_stats));
 	return adapter->fc_stats;
@@ -472,7 +471,7 @@ static void zfcp_reset_fc_host_stats(str
 		adapter->stats_reset = jiffies/HZ;
 		kfree(adapter->stats_reset_data);
 		adapter->stats_reset_data = data; /* finally freed in
-						     adapter_dequeue */
+						     adapter_release */
 	}
 }
 
@@ -517,7 +516,7 @@ static void zfcp_scsi_terminate_rport_io
 
 	if (port) {
 		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 	}
 }
 
@@ -559,23 +558,23 @@ static void zfcp_scsi_rport_block(struct
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
 {
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 	port->rport_task = RPORT_ADD;
 
 	if (!queue_work(port->adapter->work_queue, &port->rport_work))
-		zfcp_port_put(port);
+		put_device(&port->sysfs_device);
 }
 
 void zfcp_scsi_schedule_rport_block(struct zfcp_port *port)
 {
-	zfcp_port_get(port);
+	get_device(&port->sysfs_device);
 	port->rport_task = RPORT_DEL;
 
 	if (port->rport && queue_work(port->adapter->work_queue,
 				      &port->rport_work))
 		return;
 
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 }
 
 void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *adapter)
@@ -604,7 +603,7 @@ void zfcp_scsi_rport_work(struct work_st
 		}
 	}
 
-	zfcp_port_put(port);
+	put_device(&port->sysfs_device);
 }
 
 
@@ -622,7 +621,7 @@ void zfcp_scsi_scan(struct work_struct *
 				 scsilun_to_int((struct scsi_lun *)
 						&unit->fcp_lun), 0);
 
-	zfcp_unit_put(unit);
+	put_device(&unit->sysfs_device);
 }
 
 static int zfcp_execute_fc_job(struct fc_bsg_job *job)
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-11-24 12:36:31.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-11-24 12:36:36.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * sysfs attributes.
  *
- * Copyright IBM Corporation 2008
+ * Copyright IBM Corporation 2008, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -140,7 +140,6 @@ static ssize_t zfcp_sysfs_port_remove_st
 	struct zfcp_port *port;
 	u64 wwpn;
 	int retval = 0;
-	LIST_HEAD(port_remove_lh);
 
 	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
@@ -154,23 +153,21 @@ static ssize_t zfcp_sysfs_port_remove_st
 	}
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
-	if (port && (atomic_read(&port->refcount) == 1)) {
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
-		write_lock_irq(&adapter->port_list_lock);
-		list_move(&port->list, &port_remove_lh);
-		write_unlock_irq(&adapter->port_list_lock);
-	} else
-		port = NULL;
-
 	if (!port) {
 		retval = -ENXIO;
 		goto out;
 	}
 
+	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+
+	write_lock_irq(&adapter->port_list_lock);
+	list_del(&port->list);
+	write_unlock_irq(&adapter->port_list_lock);
+
+	put_device(&port->sysfs_device);
+
 	zfcp_erp_port_shutdown(port, 0, "syprs_1", NULL);
-	zfcp_erp_wait(adapter);
-	zfcp_port_put(port);
-	zfcp_port_dequeue(port);
+	zfcp_device_unregister(&port->sysfs_device, &zfcp_sysfs_port_attrs);
  out:
 	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
@@ -224,7 +221,6 @@ static ssize_t zfcp_sysfs_unit_add_store
 	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	flush_work(&unit->scsi_work);
-	zfcp_unit_put(unit);
 out:
 	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
@@ -239,7 +235,6 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = 0;
-	LIST_HEAD(unit_remove_lh);
 
 	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
@@ -261,19 +256,16 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	/* wait for possible timeout during SCSI probe */
 	flush_work(&unit->scsi_work);
 
-	if (atomic_read(&unit->refcount) == 1) {
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
+	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
+
+	write_lock_irq(&port->unit_list_lock);
+	list_del(&unit->list);
+	write_unlock_irq(&port->unit_list_lock);
+
+	put_device(&unit->sysfs_device);
 
-		write_lock_irq(&port->unit_list_lock);
-		list_move(&unit->list, &unit_remove_lh);
-		write_unlock_irq(&port->unit_list_lock);
-
-		zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
-		zfcp_erp_wait(unit->port->adapter);
-		zfcp_unit_put(unit);
-		zfcp_unit_dequeue(unit);
-	} else
-		zfcp_unit_put(unit);
+	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
+	zfcp_device_unregister(&unit->sysfs_device, &zfcp_sysfs_unit_attrs);
 out:
 	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;

