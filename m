From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/11] zfcp: consolidate sysfs things into one file.
Date: Wed, 02 Jul 2008 10:56:38 +0200
Message-ID: <20080702085952.603158000@de.ibm.com>
References: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50909 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266AbYGBJAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 05:00:14 -0400
Content-Disposition: inline; filename=sysfs-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

zfcp was using three files to deal with sysfs representation
for adapters, ports and units. The consolidation into one file
prevents code-duplication and eases maintainability.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/Makefile             |    3 
 drivers/s390/scsi/zfcp_aux.c           |   42 ++
 drivers/s390/scsi/zfcp_def.h           |    9 
 drivers/s390/scsi/zfcp_ext.h           |   16 -
 drivers/s390/scsi/zfcp_scsi.c          |  206 -------------
 drivers/s390/scsi/zfcp_sysfs.c         |  496 +++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_sysfs_adapter.c |  232 ---------------
 drivers/s390/scsi/zfcp_sysfs_port.c    |  278 ------------------
 drivers/s390/scsi/zfcp_sysfs_unit.c    |  150 ---------
 9 files changed, 539 insertions(+), 893 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2008-07-02 10:41:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-07-02 10:41:34.000000000 +0200
@@ -627,11 +627,6 @@ struct zfcp_adapter {
 	struct work_struct	scan_work;
 };
 
-/*
- * the struct device sysfs_device must be at the beginning of this structure.
- * pointer to struct device is used to free port structure in release function
- * of the device. don't change!
- */
 struct zfcp_port {
 	struct device          sysfs_device;   /* sysfs device */
 	struct fc_rport        *rport;         /* rport of fc transport class */
@@ -655,10 +650,6 @@ struct zfcp_port {
 	u32                    supported_classes;
 };
 
-/* the struct device sysfs_device must be at the beginning of this structure.
- * pointer to struct device is used to free unit structure in release function
- * of the device. don't change!
- */
 struct zfcp_unit {
 	struct device          sysfs_device;   /* sysfs device */
 	struct list_head       list;	       /* list of logical units */
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-07-02 10:41:33.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,278 +0,0 @@
-/*
- * zfcp device driver
- *
- * sysfs attributes for zfcp port.
- *
- * Copyright IBM Corporation 2002, 2008
- */
-
-#include "zfcp_ext.h"
-
-/**
- * zfcp_sysfs_port_release - gets called when a struct device port is released
- * @dev: pointer to belonging device
- */
-void
-zfcp_sysfs_port_release(struct device *dev)
-{
-	kfree(dev);
-}
-
-/**
- * ZFCP_DEFINE_PORT_ATTR
- * @_name:   name of show attribute
- * @_format: format string
- * @_value:  value to print
- *
- * Generates attributes for a port.
- */
-#define ZFCP_DEFINE_PORT_ATTR(_name, _format, _value)                    \
-static ssize_t zfcp_sysfs_port_##_name##_show(struct device *dev, struct device_attribute *attr,        \
-                                              char *buf)                 \
-{                                                                        \
-        struct zfcp_port *port;                                          \
-                                                                         \
-        port = dev_get_drvdata(dev);                                     \
-        return sprintf(buf, _format, _value);                            \
-}                                                                        \
-                                                                         \
-static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_port_##_name##_show, NULL);
-
-ZFCP_DEFINE_PORT_ATTR(status, "0x%08x\n", atomic_read(&port->status));
-ZFCP_DEFINE_PORT_ATTR(in_recovery, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_COMMON_ERP_INUSE, &port->status));
-ZFCP_DEFINE_PORT_ATTR(access_denied, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status));
-
-/**
- * zfcp_sysfs_unit_add_store - add a unit to sysfs tree
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "unit_add" attribute of a port.
- */
-static ssize_t
-zfcp_sysfs_unit_add_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	fcp_lun_t fcp_lun;
-	char *endp;
-	struct zfcp_port *port;
-	struct zfcp_unit *unit;
-	int retval = -EINVAL;
-
-	down(&zfcp_data.config_sema);
-
-	port = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	fcp_lun = simple_strtoull(buf, &endp, 0);
-	if ((endp + 1) < (buf + count))
-		goto out;
-
-	unit = zfcp_unit_enqueue(port, fcp_lun);
-	if (IS_ERR(unit))
-		goto out;
-
-	retval = 0;
-
-	zfcp_erp_unit_reopen(unit, 0, 94, NULL);
-	zfcp_erp_wait(unit->port->adapter);
-	zfcp_unit_put(unit);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
-
-/**
- * zfcp_sysfs_unit_remove_store - remove a unit from sysfs tree
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- */
-static ssize_t
-zfcp_sysfs_unit_remove_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct zfcp_port *port;
-	struct zfcp_unit *unit;
-	fcp_lun_t fcp_lun;
-	char *endp;
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-
-	port = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	fcp_lun = simple_strtoull(buf, &endp, 0);
-	if ((endp + 1) < (buf + count)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	write_lock_irq(&zfcp_data.config_lock);
-	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (unit && (atomic_read(&unit->refcount) == 0)) {
-		zfcp_unit_get(unit);
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-		list_move(&unit->list, &port->unit_remove_lh);
-	}
-	else {
-		unit = NULL;
-	}
-	write_unlock_irq(&zfcp_data.config_lock);
-
-	if (!unit) {
-		retval = -ENXIO;
-		goto out;
-	}
-
-	zfcp_erp_unit_shutdown(unit, 0, 95, NULL);
-	zfcp_erp_wait(unit->port->adapter);
-	zfcp_unit_put(unit);
-	zfcp_unit_dequeue(unit);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);
-
-/**
- * zfcp_sysfs_port_failed_store - failed state of port
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "failed" attribute of a port.
- * If a "0" gets written to "failed", error recovery will be
- * started for the belonging port.
- */
-static ssize_t
-zfcp_sysfs_port_failed_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct zfcp_port *port;
-	unsigned int val;
-	char *endp;
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-
-	port = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	val = simple_strtoul(buf, &endp, 0);
-	if (((endp + 1) < (buf + count)) || (val != 0)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	zfcp_erp_modify_port_status(port, 45, NULL,
-				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, 96, NULL);
-	zfcp_erp_wait(port->adapter);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-/**
- * zfcp_sysfs_port_failed_show - failed state of port
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- *
- * Show function of "failed" attribute of port. Will be
- * "0" if port is working, otherwise "1".
- */
-static ssize_t
-zfcp_sysfs_port_failed_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct zfcp_port *port;
-
-	port = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status))
-		return sprintf(buf, "1\n");
-	else
-		return sprintf(buf, "0\n");
-}
-
-static DEVICE_ATTR(failed, S_IWUSR | S_IRUGO, zfcp_sysfs_port_failed_show,
-		   zfcp_sysfs_port_failed_store);
-
-/**
- * zfcp_port_common_attrs
- * sysfs attributes that are common for all kind of fc ports.
- */
-static struct attribute *zfcp_port_common_attrs[] = {
-	&dev_attr_failed.attr,
-	&dev_attr_in_recovery.attr,
-	&dev_attr_status.attr,
-	&dev_attr_access_denied.attr,
-	NULL
-};
-
-static struct attribute_group zfcp_port_common_attr_group = {
-	.attrs = zfcp_port_common_attrs,
-};
-
-/**
- * zfcp_port_no_ns_attrs
- * sysfs attributes not to be used for nameserver ports.
- */
-static struct attribute *zfcp_port_no_ns_attrs[] = {
-	&dev_attr_unit_add.attr,
-	&dev_attr_unit_remove.attr,
-	NULL
-};
-
-static struct attribute_group zfcp_port_no_ns_attr_group = {
-	.attrs = zfcp_port_no_ns_attrs,
-};
-
-/**
- * zfcp_sysfs_port_create_files - create sysfs port files
- * @dev: pointer to belonging device
- *
- * Create all attributes of the sysfs representation of a port.
- */
-int
-zfcp_sysfs_port_create_files(struct device *dev, u32 flags)
-{
-	int retval;
-
-	retval = sysfs_create_group(&dev->kobj, &zfcp_port_common_attr_group);
-
-	if ((flags & ZFCP_STATUS_PORT_WKA) || retval)
-		return retval;
-
-	retval = sysfs_create_group(&dev->kobj, &zfcp_port_no_ns_attr_group);
-	if (retval)
-		sysfs_remove_group(&dev->kobj, &zfcp_port_common_attr_group);
-
-	return retval;
-}
-
-/**
- * zfcp_sysfs_port_remove_files - remove sysfs port files
- * @dev: pointer to belonging device
- *
- * Remove all attributes of the sysfs representation of a port.
- */
-void
-zfcp_sysfs_port_remove_files(struct device *dev, u32 flags)
-{
-	sysfs_remove_group(&dev->kobj, &zfcp_port_common_attr_group);
-	if (!(flags & ZFCP_STATUS_PORT_WKA))
-		sysfs_remove_group(&dev->kobj, &zfcp_port_no_ns_attr_group);
-}
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-07-02 10:41:23.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,150 +0,0 @@
-/*
- * zfcp device driver
- *
- * sysfs interface for zfcp unit.
- *
- * Copyright IBM Corporation 2002, 2008
- */
-
-#include "zfcp_ext.h"
-
-/**
- * zfcp_sysfs_unit_release - gets called when a struct device unit is released
- * @dev: pointer to belonging device
- */
-void
-zfcp_sysfs_unit_release(struct device *dev)
-{
-	kfree(dev);
-}
-
-/**
- * ZFCP_DEFINE_UNIT_ATTR
- * @_name:   name of show attribute
- * @_format: format string
- * @_value:  value to print
- *
- * Generates attribute for a unit.
- */
-#define ZFCP_DEFINE_UNIT_ATTR(_name, _format, _value)                    \
-static ssize_t zfcp_sysfs_unit_##_name##_show(struct device *dev, struct device_attribute *attr,        \
-                                              char *buf)                 \
-{                                                                        \
-        struct zfcp_unit *unit;                                          \
-                                                                         \
-        unit = dev_get_drvdata(dev);                                     \
-        return sprintf(buf, _format, _value);                            \
-}                                                                        \
-                                                                         \
-static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_unit_##_name##_show, NULL);
-
-ZFCP_DEFINE_UNIT_ATTR(status, "0x%08x\n", atomic_read(&unit->status));
-ZFCP_DEFINE_UNIT_ATTR(in_recovery, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status));
-ZFCP_DEFINE_UNIT_ATTR(access_denied, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_COMMON_ACCESS_DENIED, &unit->status));
-ZFCP_DEFINE_UNIT_ATTR(access_shared, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_UNIT_SHARED, &unit->status));
-ZFCP_DEFINE_UNIT_ATTR(access_readonly, "%d\n", atomic_test_mask
-		      (ZFCP_STATUS_UNIT_READONLY, &unit->status));
-
-/**
- * zfcp_sysfs_unit_failed_store - failed state of unit
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "failed" attribute of a unit.
- * If a "0" gets written to "failed", error recovery will be
- * started for the belonging unit.
- */
-static ssize_t
-zfcp_sysfs_unit_failed_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct zfcp_unit *unit;
-	unsigned int val;
-	char *endp;
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-	unit = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	val = simple_strtoul(buf, &endp, 0);
-	if (((endp + 1) < (buf + count)) || (val != 0)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	zfcp_erp_modify_unit_status(unit, 46, NULL,
-				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, 97, NULL);
-	zfcp_erp_wait(unit->port->adapter);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-/**
- * zfcp_sysfs_unit_failed_show - failed state of unit
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- *
- * Show function of "failed" attribute of unit. Will be
- * "0" if unit is working, otherwise "1".
- */
-static ssize_t
-zfcp_sysfs_unit_failed_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct zfcp_unit *unit;
-
-	unit = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status))
-		return sprintf(buf, "1\n");
-	else
-		return sprintf(buf, "0\n");
-}
-
-static DEVICE_ATTR(failed, S_IWUSR | S_IRUGO, zfcp_sysfs_unit_failed_show,
-		   zfcp_sysfs_unit_failed_store);
-
-static struct attribute *zfcp_unit_attrs[] = {
-	&dev_attr_failed.attr,
-	&dev_attr_in_recovery.attr,
-	&dev_attr_status.attr,
-	&dev_attr_access_denied.attr,
-	&dev_attr_access_shared.attr,
-	&dev_attr_access_readonly.attr,
-	NULL
-};
-
-static struct attribute_group zfcp_unit_attr_group = {
-	.attrs = zfcp_unit_attrs,
-};
-
-/**
- * zfcp_sysfs_create_unit_files - create sysfs unit files
- * @dev: pointer to belonging device
- *
- * Create all attributes of the sysfs representation of a unit.
- */
-int
-zfcp_sysfs_unit_create_files(struct device *dev)
-{
-	return sysfs_create_group(&dev->kobj, &zfcp_unit_attr_group);
-}
-
-/**
- * zfcp_sysfs_remove_unit_files - remove sysfs unit files
- * @dev: pointer to belonging device
- *
- * Remove all attributes of the sysfs representation of a unit.
- */
-void
-zfcp_sysfs_unit_remove_files(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &zfcp_unit_attr_group);
-}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2008-07-02 10:41:34.000000000 +0200
@@ -0,0 +1,496 @@
+/*
+ * zfcp device driver
+ *
+ * sysfs attributes.
+ *
+ * Copyright IBM Corporation 2008
+ */
+
+#include "zfcp_ext.h"
+
+#define ZFCP_DEV_ATTR(_feat, _name, _mode, _show, _store) \
+struct device_attribute dev_attr_##_feat##_##_name = __ATTR(_name, _mode,\
+							    _show, _store)
+#define ZFCP_DEFINE_ATTR(_feat_def, _feat, _name, _format, _value)	       \
+static ssize_t zfcp_sysfs_##_feat##_##_name##_show(struct device *dev,	       \
+						   struct device_attribute *at,\
+						   char *buf)		       \
+{									       \
+	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+									       \
+	return sprintf(buf, _format, _value);				       \
+}									       \
+static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
+		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
+
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, status, "0x%08x\n",
+		 atomic_read(&adapter->status));
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwnn, "0x%016llx\n",
+		 adapter->peer_wwnn);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_wwpn, "0x%016llx\n",
+		 adapter->peer_wwpn);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, peer_d_id, "0x%06x\n",
+		 adapter->peer_d_id);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, card_version, "0x%04x\n",
+		 adapter->hydra_version);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, lic_version, "0x%08x\n",
+		 adapter->fsf_lic_version);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, hardware_version, "0x%08x\n",
+		 adapter->hardware_version);
+ZFCP_DEFINE_ATTR(zfcp_adapter, adapter, in_recovery, "%d\n",
+		 (atomic_read(&adapter->status) &
+		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
+
+ZFCP_DEFINE_ATTR(zfcp_port, port, status, "0x%08x\n",
+		 atomic_read(&port->status));
+ZFCP_DEFINE_ATTR(zfcp_port, port, in_recovery, "%d\n",
+		 (atomic_read(&port->status) &
+		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
+ZFCP_DEFINE_ATTR(zfcp_port, port, access_denied, "%d\n",
+		 (atomic_read(&port->status) &
+		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+
+ZFCP_DEFINE_ATTR(zfcp_unit, unit, status, "0x%08x\n",
+		 atomic_read(&unit->status));
+ZFCP_DEFINE_ATTR(zfcp_unit, unit, in_recovery, "%d\n",
+		 (atomic_read(&unit->status) &
+		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
+ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_denied, "%d\n",
+		 (atomic_read(&unit->status) &
+		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_shared, "%d\n",
+		 (atomic_read(&unit->status) &
+		  ZFCP_STATUS_UNIT_SHARED) != 0);
+ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_readonly, "%d\n",
+		 (atomic_read(&unit->status) &
+		  ZFCP_STATUS_UNIT_READONLY) != 0);
+
+#define ZFCP_SYSFS_FAILED(_feat_def, _feat, _adapter, _mod_id, _reopen_id)     \
+static ssize_t zfcp_sysfs_##_feat##_failed_show(struct device *dev,	       \
+						struct device_attribute *attr, \
+						char *buf)		       \
+{									       \
+	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+									       \
+	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_ERP_FAILED)       \
+		return sprintf(buf, "1\n");				       \
+	else								       \
+		return sprintf(buf, "0\n");				       \
+}									       \
+static ssize_t zfcp_sysfs_##_feat##_failed_store(struct device *dev,	       \
+						 struct device_attribute *attr,\
+						 const char *buf, size_t count)\
+{									       \
+	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+	unsigned long val;						       \
+	int retval = 0;							       \
+									       \
+	down(&zfcp_data.config_sema);					       \
+	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_REMOVE) {	       \
+		retval = -EBUSY;					       \
+		goto out;						       \
+	}								       \
+									       \
+	if (strict_strtoul(buf, 0, &val) || val != 0) {			       \
+		retval = -EINVAL;					       \
+		goto out;						       \
+	}								       \
+									       \
+	zfcp_erp_modify_##_feat##_status(_feat, _mod_id, NULL,		       \
+					 ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);\
+	zfcp_erp_##_feat##_reopen(_feat, ZFCP_STATUS_COMMON_ERP_FAILED,	       \
+				  _reopen_id, NULL);			       \
+	zfcp_erp_wait(_adapter);					       \
+out:									       \
+	up(&zfcp_data.config_sema);					       \
+	return retval ? retval : (ssize_t) count;			       \
+}									       \
+static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
+		     zfcp_sysfs_##_feat##_failed_show,			       \
+		     zfcp_sysfs_##_feat##_failed_store);
+
+ZFCP_SYSFS_FAILED(zfcp_adapter, adapter, adapter, 44, 93);
+ZFCP_SYSFS_FAILED(zfcp_port, port, port->adapter, 45, 96);
+ZFCP_SYSFS_FAILED(zfcp_unit, unit, unit->port->adapter, 46, 97);
+
+static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_adapter *adapter = dev_get_drvdata(dev);
+	int ret;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE)
+		return -EBUSY;
+
+	ret = zfcp_scan_ports(adapter);
+	return ret ? ret : (ssize_t) count;
+}
+static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
+		     zfcp_sysfs_port_rescan_store);
+
+static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_adapter *adapter = dev_get_drvdata(dev);
+	struct zfcp_port *port;
+	wwn_t wwpn;
+	int retval = 0;
+
+	down(&zfcp_data.config_sema);
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	if (strict_strtoull(buf, 0, &wwpn)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	write_lock_irq(&zfcp_data.config_lock);
+	port = zfcp_get_port_by_wwpn(adapter, wwpn);
+	if (port && (atomic_read(&port->refcount) == 0)) {
+		zfcp_port_get(port);
+		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+		list_move(&port->list, &adapter->port_remove_lh);
+	} else
+		port = NULL;
+	write_unlock_irq(&zfcp_data.config_lock);
+
+	if (!port) {
+		retval = -ENXIO;
+		goto out;
+	}
+
+	zfcp_erp_port_shutdown(port, 0, 92, NULL);
+	zfcp_erp_wait(adapter);
+	zfcp_port_put(port);
+	zfcp_port_dequeue(port);
+ out:
+	up(&zfcp_data.config_sema);
+	return retval ? retval : (ssize_t) count;
+}
+static ZFCP_DEV_ATTR(adapter, port_remove, S_IWUSR, NULL,
+		     zfcp_sysfs_port_remove_store);
+
+static struct attribute *zfcp_adapter_attrs[] = {
+	&dev_attr_adapter_failed.attr,
+	&dev_attr_adapter_in_recovery.attr,
+	&dev_attr_adapter_port_remove.attr,
+	&dev_attr_adapter_port_rescan.attr,
+	&dev_attr_adapter_peer_wwnn.attr,
+	&dev_attr_adapter_peer_wwpn.attr,
+	&dev_attr_adapter_peer_d_id.attr,
+	&dev_attr_adapter_card_version.attr,
+	&dev_attr_adapter_lic_version.attr,
+	&dev_attr_adapter_status.attr,
+	&dev_attr_adapter_hardware_version.attr,
+	NULL
+};
+
+struct attribute_group zfcp_sysfs_adapter_attrs = {
+	.attrs = zfcp_adapter_attrs,
+};
+
+static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct zfcp_port *port = dev_get_drvdata(dev);
+	struct zfcp_unit *unit;
+	fcp_lun_t fcp_lun;
+	int retval = -EINVAL;
+
+	down(&zfcp_data.config_sema);
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	if (strict_strtoull(buf, 0, &fcp_lun))
+		goto out;
+
+	unit = zfcp_unit_enqueue(port, fcp_lun);
+	if (IS_ERR(unit))
+		goto out;
+
+	retval = 0;
+
+	zfcp_erp_unit_reopen(unit, 0, 94, NULL);
+	zfcp_erp_wait(unit->port->adapter);
+	zfcp_unit_put(unit);
+out:
+	up(&zfcp_data.config_sema);
+	return retval ? retval : (ssize_t) count;
+}
+static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
+
+static ssize_t zfcp_sysfs_unit_remove_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_port *port = dev_get_drvdata(dev);
+	struct zfcp_unit *unit;
+	fcp_lun_t fcp_lun;
+	int retval = 0;
+
+	down(&zfcp_data.config_sema);
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	if (strict_strtoull(buf, 0, &fcp_lun)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	write_lock_irq(&zfcp_data.config_lock);
+	unit = zfcp_get_unit_by_lun(port, fcp_lun);
+	if (unit && (atomic_read(&unit->refcount) == 0)) {
+		zfcp_unit_get(unit);
+		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
+		list_move(&unit->list, &port->unit_remove_lh);
+	} else
+		unit = NULL;
+
+	write_unlock_irq(&zfcp_data.config_lock);
+
+	if (!unit) {
+		retval = -ENXIO;
+		goto out;
+	}
+
+	zfcp_erp_unit_shutdown(unit, 0, 95, NULL);
+	zfcp_erp_wait(unit->port->adapter);
+	zfcp_unit_put(unit);
+	zfcp_unit_dequeue(unit);
+out:
+	up(&zfcp_data.config_sema);
+	return retval ? retval : (ssize_t) count;
+}
+static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);
+
+static struct attribute *zfcp_port_ns_attrs[] = {
+	&dev_attr_port_failed.attr,
+	&dev_attr_port_in_recovery.attr,
+	&dev_attr_port_status.attr,
+	&dev_attr_port_access_denied.attr,
+	NULL
+};
+
+/**
+ * zfcp_sysfs_ns_port_attrs - sysfs attributes for nameserver
+ */
+struct attribute_group zfcp_sysfs_ns_port_attrs = {
+	.attrs = zfcp_port_ns_attrs,
+};
+
+static struct attribute *zfcp_port_no_ns_attrs[] = {
+	&dev_attr_unit_add.attr,
+	&dev_attr_unit_remove.attr,
+	&dev_attr_port_failed.attr,
+	&dev_attr_port_in_recovery.attr,
+	&dev_attr_port_status.attr,
+	&dev_attr_port_access_denied.attr,
+	NULL
+};
+
+/**
+ * zfcp_sysfs_port_attrs - sysfs attributes for all other ports
+ */
+struct attribute_group zfcp_sysfs_port_attrs = {
+	.attrs = zfcp_port_no_ns_attrs,
+};
+
+static struct attribute *zfcp_unit_attrs[] = {
+	&dev_attr_unit_failed.attr,
+	&dev_attr_unit_in_recovery.attr,
+	&dev_attr_unit_status.attr,
+	&dev_attr_unit_access_denied.attr,
+	&dev_attr_unit_access_shared.attr,
+	&dev_attr_unit_access_readonly.attr,
+	NULL
+};
+
+struct attribute_group zfcp_sysfs_unit_attrs = {
+	.attrs = zfcp_unit_attrs,
+};
+
+#define ZFCP_DEFINE_LATENCY_ATTR(_name) 				\
+static ssize_t								\
+zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf) {			\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct zfcp_unit *unit = sdev->hostdata;			\
+	struct zfcp_latencies *lat = &unit->latencies;			\
+	struct zfcp_adapter *adapter = unit->port->adapter;		\
+	unsigned long flags;						\
+	unsigned long long fsum, fmin, fmax, csum, cmin, cmax, cc;	\
+									\
+	spin_lock_irqsave(&lat->lock, flags);				\
+	fsum = lat->_name.fabric.sum * adapter->timer_ticks;		\
+	fmin = lat->_name.fabric.min * adapter->timer_ticks;		\
+	fmax = lat->_name.fabric.max * adapter->timer_ticks;		\
+	csum = lat->_name.channel.sum * adapter->timer_ticks;		\
+	cmin = lat->_name.channel.min * adapter->timer_ticks;		\
+	cmax = lat->_name.channel.max * adapter->timer_ticks;		\
+	cc  = lat->_name.counter;					\
+	spin_unlock_irqrestore(&lat->lock, flags);			\
+									\
+	do_div(fsum, 1000);						\
+	do_div(fmin, 1000);						\
+	do_div(fmax, 1000);						\
+	do_div(csum, 1000);						\
+	do_div(cmin, 1000);						\
+	do_div(cmax, 1000);						\
+									\
+	return sprintf(buf, "%llu %llu %llu %llu %llu %llu %llu\n",	\
+		       fmin, fmax, fsum, cmin, cmax, csum, cc); 	\
+}									\
+static ssize_t								\
+zfcp_sysfs_unit_##_name##_latency_store(struct device *dev,		\
+					struct device_attribute *attr,	\
+					const char *buf, size_t count)	\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct zfcp_unit *unit = sdev->hostdata;			\
+	struct zfcp_latencies *lat = &unit->latencies;			\
+	unsigned long flags;						\
+									\
+	spin_lock_irqsave(&lat->lock, flags);				\
+	lat->_name.fabric.sum = 0;					\
+	lat->_name.fabric.min = 0xFFFFFFFF;				\
+	lat->_name.fabric.max = 0;					\
+	lat->_name.channel.sum = 0;					\
+	lat->_name.channel.min = 0xFFFFFFFF;				\
+	lat->_name.channel.max = 0;					\
+	lat->_name.counter = 0;						\
+	spin_unlock_irqrestore(&lat->lock, flags);			\
+									\
+	return (ssize_t) count;						\
+}									\
+static DEVICE_ATTR(_name##_latency, S_IWUSR | S_IRUGO,			\
+		   zfcp_sysfs_unit_##_name##_latency_show,		\
+		   zfcp_sysfs_unit_##_name##_latency_store);
+
+ZFCP_DEFINE_LATENCY_ATTR(read);
+ZFCP_DEFINE_LATENCY_ATTR(write);
+ZFCP_DEFINE_LATENCY_ATTR(cmd);
+
+#define ZFCP_DEFINE_SCSI_ATTR(_name, _format, _value)			\
+static ssize_t zfcp_sysfs_scsi_##_name##_show(struct device *dev,	\
+					      struct device_attribute *attr,\
+					      char *buf)                 \
+{                                                                        \
+	struct scsi_device *sdev  = to_scsi_device(dev);		 \
+	struct zfcp_unit *unit = sdev->hostdata;			 \
+									 \
+	return sprintf(buf, _format, _value);                            \
+}                                                                        \
+static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, NULL);
+
+ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
+	unit->port->adapter->ccw_device->dev.bus_id);
+ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
+ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);
+
+struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
+	&dev_attr_fcp_lun,
+	&dev_attr_wwpn,
+	&dev_attr_hba_id,
+	&dev_attr_read_latency,
+	&dev_attr_write_latency,
+	&dev_attr_cmd_latency,
+	NULL
+};
+
+static ssize_t zfcp_sysfs_adapter_util_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct Scsi_Host *scsi_host = dev_to_shost(dev);
+	struct fsf_qtcb_bottom_port *qtcb_port;
+	struct zfcp_adapter *adapter;
+	int retval;
+
+	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
+		return -EOPNOTSUPP;
+
+	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
+	if (!qtcb_port)
+		return -ENOMEM;
+
+	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
+	if (!retval)
+		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
+				 qtcb_port->cb_util, qtcb_port->a_util);
+	kfree(qtcb_port);
+	return retval;
+}
+static DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_util_show, NULL);
+
+static int zfcp_sysfs_adapter_ex_config(struct device *dev,
+					struct fsf_statistics_info *stat_inf)
+{
+	struct Scsi_Host *scsi_host = dev_to_shost(dev);
+	struct fsf_qtcb_bottom_config *qtcb_config;
+	struct zfcp_adapter *adapter;
+	int retval;
+
+	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
+		return -EOPNOTSUPP;
+
+	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
+			      GFP_KERNEL);
+	if (!qtcb_config)
+		return -ENOMEM;
+
+	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
+	if (!retval)
+		*stat_inf = qtcb_config->stat_info;
+
+	kfree(qtcb_config);
+	return retval;
+}
+
+#define ZFCP_SHOST_ATTR(_name, _format, _arg...)			\
+static ssize_t zfcp_sysfs_adapter_##_name##_show(struct device *dev,	\
+						 struct device_attribute *attr,\
+						 char *buf)		\
+{									\
+	struct fsf_statistics_info stat_info;				\
+	int retval;							\
+									\
+	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);		\
+	if (retval)							\
+		return retval;						\
+									\
+	return sprintf(buf, _format, ## _arg);				\
+}									\
+static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_adapter_##_name##_show, NULL);
+
+ZFCP_SHOST_ATTR(requests, "%llu %llu %llu\n",
+		(unsigned long long) stat_info.input_req,
+		(unsigned long long) stat_info.output_req,
+		(unsigned long long) stat_info.control_req);
+
+ZFCP_SHOST_ATTR(megabytes, "%llu %llu\n",
+		(unsigned long long) stat_info.input_mb,
+		(unsigned long long) stat_info.output_mb);
+
+ZFCP_SHOST_ATTR(seconds_active, "%llu\n",
+		(unsigned long long) stat_info.seconds_act);
+
+struct device_attribute *zfcp_sysfs_shost_attrs[] = {
+	&dev_attr_utilization,
+	&dev_attr_requests,
+	&dev_attr_megabytes,
+	&dev_attr_seconds_active,
+	NULL
+};
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-07-02 10:41:23.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,232 +0,0 @@
-/*
- * zfcp device driver
- *
- * sysfs attributes for CCW device.
- *
- * Copyright IBM Corporation 2002, 2008
- */
-
-#include "zfcp_ext.h"
-
-/**
- * ZFCP_DEFINE_ADAPTER_ATTR
- * @_name:   name of show attribute
- * @_format: format string
- * @_value:  value to print
- *
- * Generates attributes for an adapter.
- */
-#define ZFCP_DEFINE_ADAPTER_ATTR(_name, _format, _value)                      \
-static ssize_t zfcp_sysfs_adapter_##_name##_show(struct device *dev, struct device_attribute *attr,          \
-						 char *buf)                   \
-{                                                                             \
-	struct zfcp_adapter *adapter;                                         \
-                                                                              \
-	adapter = dev_get_drvdata(dev);                                       \
-	return sprintf(buf, _format, _value);                                 \
-}                                                                             \
-                                                                              \
-static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_adapter_##_name##_show, NULL);
-
-ZFCP_DEFINE_ADAPTER_ATTR(status, "0x%08x\n", atomic_read(&adapter->status));
-ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
-ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
-ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
-ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
-ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
-ZFCP_DEFINE_ADAPTER_ATTR(hardware_version, "0x%08x\n",
-			 adapter->hardware_version);
-ZFCP_DEFINE_ADAPTER_ATTR(in_recovery, "%d\n", atomic_test_mask
-			 (ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status));
-
-/**
- * zfcp_sysfs_port_rescan - trigger manual port rescan
- * @dev: pointer to belonging device
- * @attr: pointer to struct device_attribute
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- */
-static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf, size_t count)
-{
-	struct zfcp_adapter *adapter;
-	int ret;
-
-	adapter = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status))
-		return -EBUSY;
-
-	ret = zfcp_scan_ports(adapter);
-
-	return ret ? ret : (ssize_t) count;
-}
-static DEVICE_ATTR(port_rescan, S_IWUSR, NULL, zfcp_sysfs_port_rescan_store);
-
-/**
- * zfcp_sysfs_port_remove_store - remove a port from sysfs tree
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "port_remove" attribute of an adapter.
- */
-static ssize_t
-zfcp_sysfs_port_remove_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	wwn_t wwpn;
-	char *endp;
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-
-	adapter = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	wwpn = simple_strtoull(buf, &endp, 0);
-	if ((endp + 1) < (buf + count)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	write_lock_irq(&zfcp_data.config_lock);
-	port = zfcp_get_port_by_wwpn(adapter, wwpn);
-	if (port && (atomic_read(&port->refcount) == 0)) {
-		zfcp_port_get(port);
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
-		list_move(&port->list, &adapter->port_remove_lh);
-	}
-	else {
-		port = NULL;
-	}
-	write_unlock_irq(&zfcp_data.config_lock);
-
-	if (!port) {
-		retval = -ENXIO;
-		goto out;
-	}
-
-	zfcp_erp_port_shutdown(port, 0, 92, NULL);
-	zfcp_erp_wait(adapter);
-	zfcp_port_put(port);
-	zfcp_port_dequeue(port);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-static DEVICE_ATTR(port_remove, S_IWUSR, NULL, zfcp_sysfs_port_remove_store);
-
-/**
- * zfcp_sysfs_adapter_failed_store - failed state of adapter
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- * @count: number of bytes in buffer
- *
- * Store function of the "failed" attribute of an adapter.
- * If a "0" gets written to "failed", error recovery will be
- * started for the belonging adapter.
- */
-static ssize_t
-zfcp_sysfs_adapter_failed_store(struct device *dev, struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct zfcp_adapter *adapter;
-	unsigned int val;
-	char *endp;
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-
-	adapter = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status)) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	val = simple_strtoul(buf, &endp, 0);
-	if (((endp + 1) < (buf + count)) || (val != 0)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	zfcp_erp_modify_adapter_status(adapter, 44, NULL,
-				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 93,
-				NULL);
-	zfcp_erp_wait(adapter);
- out:
-	up(&zfcp_data.config_sema);
-	return retval ? retval : (ssize_t) count;
-}
-
-/**
- * zfcp_sysfs_adapter_failed_show - failed state of adapter
- * @dev: pointer to belonging device
- * @buf: pointer to input buffer
- *
- * Show function of "failed" attribute of adapter. Will be
- * "0" if adapter is working, otherwise "1".
- */
-static ssize_t
-zfcp_sysfs_adapter_failed_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct zfcp_adapter *adapter;
-
-	adapter = dev_get_drvdata(dev);
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status))
-		return sprintf(buf, "1\n");
-	else
-		return sprintf(buf, "0\n");
-}
-
-static DEVICE_ATTR(failed, S_IWUSR | S_IRUGO, zfcp_sysfs_adapter_failed_show,
-		   zfcp_sysfs_adapter_failed_store);
-
-static struct attribute *zfcp_adapter_attrs[] = {
-	&dev_attr_failed.attr,
-	&dev_attr_in_recovery.attr,
-	&dev_attr_port_remove.attr,
-	&dev_attr_port_rescan.attr,
-	&dev_attr_peer_wwnn.attr,
-	&dev_attr_peer_wwpn.attr,
-	&dev_attr_peer_d_id.attr,
-	&dev_attr_card_version.attr,
-	&dev_attr_lic_version.attr,
-	&dev_attr_status.attr,
-	&dev_attr_hardware_version.attr,
-	NULL
-};
-
-static struct attribute_group zfcp_adapter_attr_group = {
-	.attrs = zfcp_adapter_attrs,
-};
-
-/**
- * zfcp_sysfs_create_adapter_files - create sysfs adapter files
- * @dev: pointer to belonging device
- *
- * Create all attributes of the sysfs representation of an adapter.
- */
-int
-zfcp_sysfs_adapter_create_files(struct device *dev)
-{
-	return sysfs_create_group(&dev->kobj, &zfcp_adapter_attr_group);
-}
-
-/**
- * zfcp_sysfs_remove_adapter_files - remove sysfs adapter files
- * @dev: pointer to belonging device
- *
- * Remove all attributes of the sysfs representation of an adapter.
- */
-void
-zfcp_sysfs_adapter_remove_files(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &zfcp_adapter_attr_group);
-}
--- a/drivers/s390/scsi/zfcp_aux.c	2008-07-02 10:41:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-07-02 10:41:34.000000000 +0200
@@ -262,6 +262,11 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	return NULL;
 }
 
+static void zfcp_sysfs_unit_release(struct device *dev)
+{
+	kfree(container_of(dev, struct zfcp_unit, sysfs_device));
+}
+
 /**
  * zfcp_unit_enqueue - enqueue unit to unit list of a port.
  * @port: pointer to port where unit is added
@@ -311,7 +316,8 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	if (device_register(&unit->sysfs_device))
 		goto err_out_free;
 
-	if (zfcp_sysfs_unit_create_files(&unit->sysfs_device)) {
+	if (sysfs_create_group(&unit->sysfs_device.kobj,
+			       &zfcp_sysfs_unit_attrs)) {
 		device_unregister(&unit->sysfs_device);
 		return ERR_PTR(-EIO);
 	}
@@ -351,7 +357,7 @@ void zfcp_unit_dequeue(struct zfcp_unit 
 	write_unlock_irq(&zfcp_data.config_lock);
 	unit->port->units--;
 	zfcp_port_put(unit->port);
-	zfcp_sysfs_unit_remove_files(&unit->sysfs_device);
+	sysfs_remove_group(&unit->sysfs_device.kobj, &zfcp_sysfs_unit_attrs);
 	device_unregister(&unit->sysfs_device);
 }
 
@@ -527,7 +533,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	dev_set_drvdata(&ccw_device->dev, adapter);
 
-	if (zfcp_sysfs_adapter_create_files(&ccw_device->dev))
+	if (sysfs_create_group(&ccw_device->dev.kobj,
+			       &zfcp_sysfs_adapter_attrs))
 		goto sysfs_failed;
 
 	adapter->generic_services.parent = &adapter->ccw_device->dev;
@@ -550,7 +557,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	return 0;
 
 generic_services_failed:
-	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
+	sysfs_remove_group(&ccw_device->dev.kobj,
+			   &zfcp_sysfs_adapter_attrs);
 sysfs_failed:
 	zfcp_adapter_debug_unregister(adapter);
 debug_register_failed:
@@ -578,7 +586,8 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
-	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
+	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
+			   &zfcp_sysfs_adapter_attrs);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
@@ -606,6 +615,11 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	kfree(adapter);
 }
 
+static void zfcp_sysfs_port_release(struct device *dev)
+{
+	kfree(container_of(dev, struct zfcp_port, sysfs_device));
+}
+
 /**
  * zfcp_port_enqueue - enqueue port to port list of adapter
  * @adapter: adapter where remote port is added
@@ -623,6 +637,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 				     u32 status, u32 d_id)
 {
 	struct zfcp_port *port;
+	int retval;
 	char *bus_id;
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
@@ -685,7 +700,14 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	if (device_register(&port->sysfs_device))
 		goto err_out_free;
 
-	if (zfcp_sysfs_port_create_files(&port->sysfs_device, status)) {
+	if (status & ZFCP_STATUS_PORT_WKA)
+		retval = sysfs_create_group(&port->sysfs_device.kobj,
+					    &zfcp_sysfs_ns_port_attrs);
+	else
+		retval = sysfs_create_group(&port->sysfs_device.kobj,
+					    &zfcp_sysfs_port_attrs);
+
+	if (retval) {
 		device_unregister(&port->sysfs_device);
 		goto err_out;
 	}
@@ -727,8 +749,12 @@ void zfcp_port_dequeue(struct zfcp_port 
 		fc_remote_port_delete(port->rport);
 	port->rport = NULL;
 	zfcp_adapter_put(port->adapter);
-	zfcp_sysfs_port_remove_files(&port->sysfs_device,
-				     atomic_read(&port->status));
+	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA)
+		sysfs_remove_group(&port->sysfs_device.kobj,
+				   &zfcp_sysfs_ns_port_attrs);
+	else
+		sysfs_remove_group(&port->sysfs_device.kobj,
+				   &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
 }
 
--- a/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:41:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:41:34.000000000 +0200
@@ -13,15 +13,13 @@
 
 extern struct zfcp_data zfcp_data;
 
-/******************************** SYSFS  *************************************/
-extern int  zfcp_sysfs_adapter_create_files(struct device *);
-extern void zfcp_sysfs_adapter_remove_files(struct device *);
-extern int  zfcp_sysfs_port_create_files(struct device *, u32);
-extern void zfcp_sysfs_port_remove_files(struct device *, u32);
-extern int  zfcp_sysfs_unit_create_files(struct device *);
-extern void zfcp_sysfs_unit_remove_files(struct device *);
-extern void zfcp_sysfs_port_release(struct device *);
-extern void zfcp_sysfs_unit_release(struct device *);
+/* zfcp_sysfs.c */
+extern struct attribute_group zfcp_sysfs_unit_attrs;
+extern struct attribute_group zfcp_sysfs_adapter_attrs;
+extern struct attribute_group zfcp_sysfs_ns_port_attrs;
+extern struct attribute_group zfcp_sysfs_port_attrs;
+extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
+extern struct device_attribute *zfcp_sysfs_shost_attrs[];
 
 /**************************** CONFIGURATION  *********************************/
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, fcp_lun_t);
--- a/drivers/s390/scsi/Makefile	2008-07-02 10:41:23.000000000 +0200
+++ b/drivers/s390/scsi/Makefile	2008-07-02 10:41:34.000000000 +0200
@@ -3,7 +3,6 @@
 #
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
-	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_fc.o zfcp_cfdc.o
+	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs.o zfcp_fc.o zfcp_cfdc.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-07-02 10:41:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-07-02 10:41:34.000000000 +0200
@@ -520,209 +520,6 @@ struct fc_function_template zfcp_transpo
 	.disable_target_scan = 1,
 };
 
-#define ZFCP_DEFINE_LATENCY_ATTR(_name) 				\
-static ssize_t								\
-zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		\
-				       struct device_attribute *attr,	\
-				       char *buf) {			\
-	struct scsi_device *sdev = to_scsi_device(dev);			\
-	struct zfcp_unit *unit = sdev->hostdata;			\
-	struct zfcp_latencies *lat = &unit->latencies;			\
-	struct zfcp_adapter *adapter = unit->port->adapter;		\
-	unsigned long flags;						\
-	unsigned long long fsum, fmin, fmax, csum, cmin, cmax, cc;	\
-									\
-	spin_lock_irqsave(&lat->lock, flags);				\
-	fsum = lat->_name.fabric.sum * adapter->timer_ticks;		\
-	fmin = lat->_name.fabric.min * adapter->timer_ticks;		\
-	fmax = lat->_name.fabric.max * adapter->timer_ticks;		\
-	csum = lat->_name.channel.sum * adapter->timer_ticks;		\
-	cmin = lat->_name.channel.min * adapter->timer_ticks;		\
-	cmax = lat->_name.channel.max * adapter->timer_ticks;		\
-	cc  = lat->_name.counter;					\
-	spin_unlock_irqrestore(&lat->lock, flags);			\
-									\
-	do_div(fsum, 1000);						\
-	do_div(fmin, 1000);						\
-	do_div(fmax, 1000);						\
-	do_div(csum, 1000);						\
-	do_div(cmin, 1000);						\
-	do_div(cmax, 1000);						\
-									\
-	return sprintf(buf, "%llu %llu %llu %llu %llu %llu %llu\n",	\
-		       fmin, fmax, fsum, cmin, cmax, csum, cc); 	\
-}									\
-static ssize_t								\
-zfcp_sysfs_unit_##_name##_latency_store(struct device *dev,		\
-					struct device_attribute *attr,	\
-					const char *buf, size_t count)	\
-{									\
-	struct scsi_device *sdev = to_scsi_device(dev);			\
-	struct zfcp_unit *unit = sdev->hostdata;			\
-	struct zfcp_latencies *lat = &unit->latencies;			\
-	unsigned long flags;						\
-									\
-	spin_lock_irqsave(&lat->lock, flags);				\
-	lat->_name.fabric.sum = 0;					\
-	lat->_name.fabric.min = 0xFFFFFFFF;				\
-	lat->_name.fabric.max = 0;					\
-	lat->_name.channel.sum = 0;					\
-	lat->_name.channel.min = 0xFFFFFFFF;				\
-	lat->_name.channel.max = 0;					\
-	lat->_name.counter = 0;						\
-	spin_unlock_irqrestore(&lat->lock, flags);			\
-									\
-	return (ssize_t) count;						\
-}									\
-static DEVICE_ATTR(_name##_latency, S_IWUSR | S_IRUGO,			\
-		   zfcp_sysfs_unit_##_name##_latency_show,		\
-		   zfcp_sysfs_unit_##_name##_latency_store);
-
-ZFCP_DEFINE_LATENCY_ATTR(read);
-ZFCP_DEFINE_LATENCY_ATTR(write);
-ZFCP_DEFINE_LATENCY_ATTR(cmd);
-
-#define ZFCP_DEFINE_SCSI_ATTR(_name, _format, _value)                    \
-static ssize_t zfcp_sysfs_scsi_##_name##_show(struct device *dev, struct device_attribute *attr,        \
-                                              char *buf)                 \
-{                                                                        \
-        struct scsi_device *sdev;                                        \
-        struct zfcp_unit *unit;                                          \
-                                                                         \
-        sdev = to_scsi_device(dev);                                      \
-        unit = sdev->hostdata;                                           \
-        return sprintf(buf, _format, _value);                            \
-}                                                                        \
-                                                                         \
-static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, NULL);
-
-ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
-	unit->port->adapter->ccw_device->dev.bus_id);
-ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
-ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);
-
-static struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
-	&dev_attr_fcp_lun,
-	&dev_attr_wwpn,
-	&dev_attr_hba_id,
-	&dev_attr_read_latency,
-	&dev_attr_write_latency,
-	&dev_attr_cmd_latency,
-	NULL
-};
-
-static ssize_t zfcp_sysfs_adapter_util_show(struct device *dev,
-					    struct device_attribute *attr,
-					    char *buf)
-{
-	struct Scsi_Host *scsi_host = dev_to_shost(dev);
-	struct fsf_qtcb_bottom_port *qtcb_port;
-	struct zfcp_adapter *adapter;
-	int retval;
-
-	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
-	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
-		return -EOPNOTSUPP;
-
-	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
-	if (!qtcb_port)
-		return -ENOMEM;
-
-	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
-	if (!retval)
-		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
-				 qtcb_port->cb_util, qtcb_port->a_util);
-	kfree(qtcb_port);
-	return retval;
-}
-
-static int zfcp_sysfs_adapter_ex_config(struct device *dev,
-					struct fsf_statistics_info *stat_inf)
-{
-	struct Scsi_Host *scsi_host = dev_to_shost(dev);
-	struct fsf_qtcb_bottom_config *qtcb_config;
-	struct zfcp_adapter *adapter;
-	int retval;
-
-	adapter = (struct zfcp_adapter *) scsi_host->hostdata[0];
-	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
-		return -EOPNOTSUPP;
-
-	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
-			      GFP_KERNEL);
-	if (!qtcb_config)
-		return -ENOMEM;
-
-	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
-	if (!retval)
-		*stat_inf = qtcb_config->stat_info;
-
-	kfree(qtcb_config);
-	return retval;
-}
-
-static ssize_t zfcp_sysfs_adapter_request_show(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
-{
-	struct fsf_statistics_info stat_info;
-	int retval;
-
-	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
-	if (retval)
-		return retval;
-
-	return sprintf(buf, "%llu %llu %llu\n",
-		       (unsigned long long) stat_info.input_req,
-		       (unsigned long long) stat_info.output_req,
-		       (unsigned long long) stat_info.control_req);
-}
-
-static ssize_t zfcp_sysfs_adapter_mb_show(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	struct fsf_statistics_info stat_info;
-	int retval;
-
-	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
-	if (retval)
-		return retval;
-
-	return sprintf(buf, "%llu %llu\n",
-		       (unsigned long long) stat_info.input_mb,
-		       (unsigned long long) stat_info.output_mb);
-}
-
-static ssize_t zfcp_sysfs_adapter_sec_active_show(struct device *dev,
-						  struct device_attribute *attr,
-						  char *buf)
-{
-	struct fsf_statistics_info stat_info;
-	int retval;
-
-	retval = zfcp_sysfs_adapter_ex_config(dev, &stat_info);
-	if (retval)
-		return retval;
-
-	return sprintf(buf, "%llu\n",
-		       (unsigned long long) stat_info.seconds_act);
-}
-
-static DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_util_show, NULL);
-static DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show, NULL);
-static DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NULL);
-static DEVICE_ATTR(seconds_active, S_IRUGO,
-		   zfcp_sysfs_adapter_sec_active_show, NULL);
-
-static struct device_attribute *zfcp_a_stats_attrs[] = {
-	&dev_attr_utilization,
-	&dev_attr_requests,
-	&dev_attr_megabytes,
-	&dev_attr_seconds_active,
-	NULL
-};
-
 struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
 		.name			 = "zfcp",
@@ -743,7 +540,6 @@ struct zfcp_data zfcp_data = {
 		.use_clustering		 = 1,
 		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
 		.max_sectors		 = (ZFCP_MAX_SBALES_PER_REQ * 8),
-		.shost_attrs		 = zfcp_a_stats_attrs,
+		.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	},
 };
-

-- 
