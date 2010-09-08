From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/12] zfcp: Move code for managing zfcp_unit devices to new file
Date: Wed, 08 Sep 2010 14:39:52 +0200
Message-ID: <20100908124352.982281545@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43205 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab0IHMn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:57 -0400
Content-Disposition: inline; filename=702-zfcp-device-mngt.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the code for managing zfcp_unit devices to the new file
zfcp_unit.c. This is in preparation for the change that zfcp_unit will
only track the LUNs configured via unit_add, other data will be moved
from zfcp_unit to the new struct zfcp_scsi_dev.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/Makefile     |    5 
 drivers/s390/scsi/zfcp_aux.c   |  122 -------------------
 drivers/s390/scsi/zfcp_ext.h   |   13 +-
 drivers/s390/scsi/zfcp_scsi.c  |   41 ------
 drivers/s390/scsi/zfcp_sysfs.c |   60 +--------
 drivers/s390/scsi/zfcp_unit.c  |  255 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 281 insertions(+), 215 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/Makefile linux-2.6-patched/drivers/s390/scsi/Makefile
--- linux-2.6/drivers/s390/scsi/Makefile	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/Makefile	2010-09-08 08:49:26.000000000 +0200
@@ -2,7 +2,8 @@
 # Makefile for the S/390 specific device drivers
 #
 
-zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
-	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs.o zfcp_fc.o zfcp_cfdc.o
+zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_cfdc.o zfcp_dbf.o zfcp_erp.o \
+	     zfcp_fc.o zfcp_fsf.o zfcp_qdio.o zfcp_scsi.o zfcp_sysfs.o \
+	     zfcp_unit.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:26.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:26.000000000 +0200
@@ -56,7 +56,6 @@ static void __init zfcp_init_device_conf
 	struct ccw_device *cdev;
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
-	struct zfcp_unit *unit;
 
 	cdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
 	if (!cdev)
@@ -72,18 +71,11 @@ static void __init zfcp_init_device_conf
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
 	if (!port)
 		goto out_port;
-
 	flush_work(&port->rport_work);
-	unit = zfcp_unit_enqueue(port, lun);
-	if (IS_ERR(unit))
-		goto out_unit;
-
-	zfcp_erp_unit_reopen(unit, 0, "auidc_1", NULL);
-	zfcp_erp_wait(adapter);
-	zfcp_scsi_scan(unit);
 
-out_unit:
+	zfcp_unit_add(port, lun);
 	put_device(&port->dev);
+
 out_port:
 	zfcp_ccw_adapter_put(adapter);
 out_ccw_device:
@@ -215,30 +207,6 @@ static void __exit zfcp_module_exit(void
 module_exit(zfcp_module_exit);
 
 /**
- * zfcp_get_unit_by_lun - find unit in unit list of port by FCP LUN
- * @port: pointer to port to search for unit
- * @fcp_lun: FCP LUN to search for
- *
- * Returns: pointer to zfcp_unit or NULL
- */
-struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *port, u64 fcp_lun)
-{
-	unsigned long flags;
-	struct zfcp_unit *unit;
-
-	read_lock_irqsave(&port->unit_list_lock, flags);
-	list_for_each_entry(unit, &port->unit_list, list)
-		if (unit->fcp_lun == fcp_lun) {
-			if (!get_device(&unit->dev))
-				unit = NULL;
-			read_unlock_irqrestore(&port->unit_list_lock, flags);
-			return unit;
-		}
-	read_unlock_irqrestore(&port->unit_list_lock, flags);
-	return NULL;
-}
-
-/**
  * zfcp_get_port_by_wwpn - find port in port list of adapter by wwpn
  * @adapter: pointer to adapter to search for port
  * @wwpn: wwpn to search for
@@ -263,92 +231,6 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	return NULL;
 }
 
-/**
- * zfcp_unit_release - dequeue unit
- * @dev: pointer to device
- *
- * waits until all work is done on unit and removes it then from the unit->list
- * of the associated port.
- */
-static void zfcp_unit_release(struct device *dev)
-{
-	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
-
-	put_device(&unit->port->dev);
-	kfree(unit);
-}
-
-/**
- * zfcp_unit_enqueue - enqueue unit to unit list of a port.
- * @port: pointer to port where unit is added
- * @fcp_lun: FCP LUN of unit to be enqueued
- * Returns: pointer to enqueued unit on success, ERR_PTR on error
- *
- * Sets up some unit internal structures and creates sysfs entry.
- */
-struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, u64 fcp_lun)
-{
-	struct zfcp_unit *unit;
-	int retval = -ENOMEM;
-
-	get_device(&port->dev);
-
-	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (unit) {
-		put_device(&unit->dev);
-		retval = -EEXIST;
-		goto err_out;
-	}
-
-	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
-	if (!unit)
-		goto err_out;
-
-	unit->port = port;
-	unit->fcp_lun = fcp_lun;
-	unit->dev.parent = &port->dev;
-	unit->dev.release = zfcp_unit_release;
-
-	if (dev_set_name(&unit->dev, "0x%016llx",
-			 (unsigned long long) fcp_lun)) {
-		kfree(unit);
-		goto err_out;
-	}
-	retval = -EINVAL;
-
-	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan_work);
-
-	spin_lock_init(&unit->latencies.lock);
-	unit->latencies.write.channel.min = 0xFFFFFFFF;
-	unit->latencies.write.fabric.min = 0xFFFFFFFF;
-	unit->latencies.read.channel.min = 0xFFFFFFFF;
-	unit->latencies.read.fabric.min = 0xFFFFFFFF;
-	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
-	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
-
-	if (device_register(&unit->dev)) {
-		put_device(&unit->dev);
-		goto err_out;
-	}
-
-	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs))
-		goto err_out_put;
-
-	write_lock_irq(&port->unit_list_lock);
-	list_add_tail(&unit->list, &port->unit_list);
-	write_unlock_irq(&port->unit_list_lock);
-
-	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
-
-	return unit;
-
-err_out_put:
-	device_unregister(&unit->dev);
-err_out:
-	put_device(&port->dev);
-	return ERR_PTR(retval);
-}
-
 static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	adapter->pool.erp_req =
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:26.000000000 +0200
@@ -15,12 +15,10 @@
 #include "zfcp_fc.h"
 
 /* zfcp_aux.c */
-extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, u64);
 extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, u64);
 extern struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *);
 extern struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *, u64, u32,
 					   u32);
-extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, u64);
 extern void zfcp_sg_free_table(struct scatterlist *, int);
 extern int zfcp_sg_setup_table(struct scatterlist *, int);
 extern void zfcp_device_unregister(struct device *,
@@ -163,8 +161,6 @@ extern void zfcp_scsi_rport_work(struct
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
-extern void zfcp_scsi_scan(struct zfcp_unit *);
-extern void zfcp_scsi_scan_work(struct work_struct *);
 extern void zfcp_scsi_set_prot(struct zfcp_adapter *);
 extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
 
@@ -175,4 +171,13 @@ extern struct attribute_group zfcp_sysfs
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
 
+/* zfcp_unit.c */
+extern int zfcp_unit_add(struct zfcp_port *, u64);
+extern int zfcp_unit_remove(struct zfcp_port *, u64);
+extern struct zfcp_unit *zfcp_unit_find(struct zfcp_port *, u64);
+extern struct scsi_device *zfcp_unit_sdev(struct zfcp_unit *unit);
+extern void zfcp_unit_scsi_scan(struct zfcp_unit *);
+extern void zfcp_unit_queue_scsi_scan(struct zfcp_port *);
+extern unsigned int zfcp_unit_sdev_status(struct zfcp_unit *);
+
 #endif	/* ZFCP_EXT_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:26.000000000 +0200
@@ -144,7 +144,7 @@ static struct zfcp_unit *zfcp_unit_looku
 	list_for_each_entry(port, &adapter->port_list, list) {
 		if (!port->rport || (id != port->rport->scsi_target_id))
 			continue;
-		unit = zfcp_get_unit_by_lun(port, lun);
+		unit = zfcp_unit_find(port, lun);
 		if (unit)
 			break;
 	}
@@ -534,20 +534,6 @@ static void zfcp_scsi_terminate_rport_io
 	}
 }
 
-static void zfcp_scsi_queue_unit_register(struct zfcp_port *port)
-{
-	struct zfcp_unit *unit;
-
-	read_lock_irq(&port->unit_list_lock);
-	list_for_each_entry(unit, &port->unit_list, list) {
-		get_device(&unit->dev);
-		if (scsi_queue_work(port->adapter->scsi_host,
-				    &unit->scsi_work) <= 0)
-			put_device(&unit->dev);
-	}
-	read_unlock_irq(&port->unit_list_lock);
-}
-
 static void zfcp_scsi_rport_register(struct zfcp_port *port)
 {
 	struct fc_rport_identifiers ids;
@@ -574,7 +560,7 @@ static void zfcp_scsi_rport_register(str
 	port->rport = rport;
 	port->starget_id = rport->scsi_target_id;
 
-	zfcp_scsi_queue_unit_register(port);
+	zfcp_unit_queue_scsi_scan(port);
 }
 
 static void zfcp_scsi_rport_block(struct zfcp_port *port)
@@ -638,29 +624,6 @@ void zfcp_scsi_rport_work(struct work_st
 }
 
 /**
- * zfcp_scsi_scan - Register LUN with SCSI midlayer
- * @unit: The LUN/unit to register
- */
-void zfcp_scsi_scan(struct zfcp_unit *unit)
-{
-	struct fc_rport *rport = unit->port->rport;
-
-	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
-		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-				 scsilun_to_int((struct scsi_lun *)
-						&unit->fcp_lun), 0);
-}
-
-void zfcp_scsi_scan_work(struct work_struct *work)
-{
-	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
-					      scsi_work);
-
-	zfcp_scsi_scan(unit);
-	put_device(&unit->dev);
-}
-
-/**
  * zfcp_scsi_set_prot - Configure DIF/DIX support in scsi_host
  * @adapter: The adapter where to configure DIF/DIX for the SCSI host
  */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:26.000000000 +0200
@@ -257,28 +257,15 @@ static ssize_t zfcp_sysfs_unit_add_store
 					 const char *buf, size_t count)
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
-	struct zfcp_unit *unit;
 	u64 fcp_lun;
-	int retval = -EINVAL;
-
-	if (!(port && get_device(&port->dev)))
-		return -EBUSY;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
-		goto out;
+		return -EINVAL;
+
+	if (zfcp_unit_add(port, fcp_lun))
+		return -EINVAL;
 
-	unit = zfcp_unit_enqueue(port, fcp_lun);
-	if (IS_ERR(unit))
-		goto out;
-	else
-		retval = 0;
-
-	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
-	zfcp_erp_wait(unit->port->adapter);
-	zfcp_scsi_scan(unit);
-out:
-	put_device(&port->dev);
-	return retval ? retval : (ssize_t) count;
+	return count;
 }
 static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
 
@@ -287,42 +274,15 @@ static ssize_t zfcp_sysfs_unit_remove_st
 					    const char *buf, size_t count)
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
-	struct zfcp_unit *unit;
 	u64 fcp_lun;
-	int retval = -EINVAL;
-	struct scsi_device *sdev;
-
-	if (!(port && get_device(&port->dev)))
-		return -EBUSY;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
-		goto out;
+		return -EINVAL;
+
+	if (zfcp_unit_remove(port, fcp_lun))
+		return -EINVAL;
 
-	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (!unit)
-		goto out;
-	else
-		retval = 0;
-
-	sdev = scsi_device_lookup(port->adapter->scsi_host, 0,
-				  port->starget_id,
-				  scsilun_to_int((struct scsi_lun *)&fcp_lun));
-	if (sdev) {
-		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
-	}
-
-	write_lock_irq(&port->unit_list_lock);
-	list_del(&unit->list);
-	write_unlock_irq(&port->unit_list_lock);
-
-	put_device(&unit->dev);
-
-	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
-	zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
-out:
-	put_device(&port->dev);
-	return retval ? retval : (ssize_t) count;
+	return count;
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_unit.c linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c
--- linux-2.6/drivers/s390/scsi/zfcp_unit.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c	2010-09-08 08:49:26.000000000 +0200
@@ -0,0 +1,255 @@
+/*
+ * zfcp device driver
+ *
+ * Tracking of manually configured LUNs and helper functions to
+ * register the LUNs with the SCSI midlayer.
+ *
+ * Copyright IBM Corporation 2010
+ */
+
+#include "zfcp_def.h"
+#include "zfcp_ext.h"
+
+/**
+ * zfcp_unit_scsi_scan - Register LUN with SCSI midlayer
+ * @unit: The zfcp LUN/unit to register
+ *
+ * When the SCSI midlayer is not allowed to automatically scan and
+ * attach SCSI devices, zfcp has to register the single devices with
+ * the SCSI midlayer.
+ */
+void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
+{
+	struct fc_rport *rport = unit->port->rport;
+	unsigned int lun;
+
+	lun = scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
+
+	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
+		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1);
+}
+
+static void zfcp_unit_scsi_scan_work(struct work_struct *work)
+{
+	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
+					      scsi_work);
+
+	zfcp_unit_scsi_scan(unit);
+	put_device(&unit->dev);
+}
+
+/**
+ * zfcp_unit_queue_scsi_scan - Register configured units on port
+ * @port: The zfcp_port where to register units
+ *
+ * After opening a port, all units configured on this port have to be
+ * registered with the SCSI midlayer. This function should be called
+ * after calling fc_remote_port_add, so that the fc_rport is already
+ * ONLINE and the call to scsi_scan_target runs the same way as the
+ * call in the FC transport class.
+ */
+void zfcp_unit_queue_scsi_scan(struct zfcp_port *port)
+{
+	struct zfcp_unit *unit;
+
+	read_lock_irq(&port->unit_list_lock);
+	list_for_each_entry(unit, &port->unit_list, list) {
+		get_device(&unit->dev);
+		if (scsi_queue_work(port->adapter->scsi_host,
+				    &unit->scsi_work) <= 0)
+			put_device(&unit->dev);
+	}
+	read_unlock_irq(&port->unit_list_lock);
+}
+
+static struct zfcp_unit *_zfcp_unit_find(struct zfcp_port *port, u64 fcp_lun)
+{
+	struct zfcp_unit *unit;
+
+	list_for_each_entry(unit, &port->unit_list, list)
+		if (unit->fcp_lun == fcp_lun) {
+			get_device(&unit->dev);
+			return unit;
+		}
+
+	return NULL;
+}
+
+/**
+ * zfcp_unit_find - Find and return zfcp_unit with specified FCP LUN
+ * @port: zfcp_port where to look for the unit
+ * @fcp_lun: 64 Bit FCP LUN used to identify the zfcp_unit
+ *
+ * If zfcp_unit is found, a reference is acquired that has to be
+ * released later.
+ *
+ * Returns: Pointer to the zfcp_unit, or NULL if there is no zfcp_unit
+ *          with the specified FCP LUN.
+ */
+struct zfcp_unit *zfcp_unit_find(struct zfcp_port *port, u64 fcp_lun)
+{
+	struct zfcp_unit *unit;
+
+	read_lock_irq(&port->unit_list_lock);
+	unit = _zfcp_unit_find(port, fcp_lun);
+	read_unlock_irq(&port->unit_list_lock);
+	return unit;
+}
+
+/**
+ * zfcp_unit_release - Drop reference to zfcp_port and free memory of zfcp_unit.
+ * @dev: pointer to device in zfcp_unit
+ */
+static void zfcp_unit_release(struct device *dev)
+{
+	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
+
+	put_device(&unit->port->dev);
+	kfree(unit);
+}
+
+/**
+ * zfcp_unit_enqueue - enqueue unit to unit list of a port.
+ * @port: pointer to port where unit is added
+ * @fcp_lun: FCP LUN of unit to be enqueued
+ * Returns: 0 success
+ *
+ * Sets up some unit internal structures and creates sysfs entry.
+ */
+int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
+{
+	struct zfcp_unit *unit;
+
+	unit = zfcp_unit_find(port, fcp_lun);
+	if (unit) {
+		put_device(&unit->dev);
+		return -EEXIST;
+	}
+
+	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
+	if (!unit)
+		return -ENOMEM;
+
+	unit->port = port;
+	unit->fcp_lun = fcp_lun;
+	unit->dev.parent = &port->dev;
+	unit->dev.release = zfcp_unit_release;
+	unit->latencies.write.channel.min = 0xFFFFFFFF;
+	unit->latencies.write.fabric.min = 0xFFFFFFFF;
+	unit->latencies.read.channel.min = 0xFFFFFFFF;
+	unit->latencies.read.fabric.min = 0xFFFFFFFF;
+	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
+	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
+	INIT_WORK(&unit->scsi_work, zfcp_unit_scsi_scan_work);
+	spin_lock_init(&unit->latencies.lock);
+
+	if (dev_set_name(&unit->dev, "0x%016llx",
+			 (unsigned long long) fcp_lun)) {
+		kfree(unit);
+		return -ENOMEM;
+	}
+
+	if (device_register(&unit->dev)) {
+		put_device(&unit->dev);
+		return -ENOMEM;
+	}
+
+	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs)) {
+		device_unregister(&unit->dev);
+		return -EINVAL;
+	}
+
+	get_device(&port->dev);
+
+	write_lock_irq(&port->unit_list_lock);
+	list_add_tail(&unit->list, &port->unit_list);
+	write_unlock_irq(&port->unit_list_lock);
+
+	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
+	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
+	zfcp_erp_wait(unit->port->adapter);
+	zfcp_unit_scsi_scan(unit);
+
+	return 0;
+}
+
+/**
+ * zfcp_unit_sdev - Return SCSI device for zfcp_unit
+ * @unit: The zfcp_unit where to get the SCSI device for
+ *
+ * Returns: scsi_device pointer on success, NULL if there is no SCSI
+ *          device for this zfcp_unit
+ *
+ * On success, the caller also holds a reference to the SCSI device
+ * that must be released with scsi_device_put.
+ */
+struct scsi_device *zfcp_unit_sdev(struct zfcp_unit *unit)
+{
+	struct Scsi_Host *shost;
+	struct zfcp_port *port;
+	unsigned int lun;
+
+	lun = scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
+	port = unit->port;
+	shost = port->adapter->scsi_host;
+	return scsi_device_lookup(shost, 0, port->starget_id, lun);
+}
+
+/**
+ * zfcp_unit_sdev_status - Return zfcp LUN status for SCSI device
+ * @unit: The unit to lookup the SCSI device for
+ *
+ * Returns the zfcp LUN status field of the SCSI device if the SCSI device
+ * for the zfcp_unit exists, 0 otherwise.
+ */
+unsigned int zfcp_unit_sdev_status(struct zfcp_unit *unit)
+{
+	unsigned int status = 0;
+	struct scsi_device *sdev;
+	struct zfcp_scsi_dev *zfcp_sdev;
+
+	sdev = zfcp_unit_sdev(unit);
+	if (sdev) {
+		zfcp_sdev = sdev_to_zfcp(sdev);
+		status = atomic_read(&zfcp_sdev->status);
+		scsi_device_put(sdev);
+	}
+
+	return status;
+}
+
+/**
+ * zfcp_unit_remove - Remove entry from list of configured units
+ * @port: The port where to remove the unit from the configuration
+ * @fcp_lun: The 64 bit LUN of the unit to remove
+ *
+ * Returns: -EINVAL if a unit with the specified LUN does not exist,
+ *          0 on success.
+ */
+int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
+{
+	struct zfcp_unit *unit;
+	struct scsi_device *sdev;
+
+	write_lock_irq(&port->unit_list_lock);
+	unit = _zfcp_unit_find(port, fcp_lun);
+	if (unit)
+		list_del(&unit->list);
+	write_unlock_irq(&port->unit_list_lock);
+
+	if (!unit)
+		return -EINVAL;
+
+	sdev = zfcp_unit_sdev(unit);
+	if (sdev) {
+		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
+	}
+
+	put_device(&unit->dev);
+
+	zfcp_erp_unit_shutdown(unit, 0, "unrem_1", NULL);
+	zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
+
+	return 0;
+}

