From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/22] zfcp: Remove STATUS_COMMON_REMOVE flag as it is not required anymore
Date: Tue, 24 Nov 2009 16:54:05 +0100
Message-ID: <20091124160137.288123000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59646 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=707-zfcp-remove-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The flag ZFCP_STATUS_COMMON_REMOVE was used to indicate that a 
resource is not ready to be used or about to be removed from the
system. This is now better done by an improved list handling
and therefore the additional indicator is not required anymore.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   27 ++++-----------
 drivers/s390/scsi/zfcp_ccw.c   |    7 ----
 drivers/s390/scsi/zfcp_def.h   |    1 
 drivers/s390/scsi/zfcp_erp.c   |    6 ++-
 drivers/s390/scsi/zfcp_fc.c    |    1 
 drivers/s390/scsi/zfcp_sysfs.c |   70 ++++++++++++-----------------------------
 6 files changed, 34 insertions(+), 78 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:40.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:40.000000000 +0100
@@ -245,9 +245,9 @@ struct zfcp_unit *zfcp_get_unit_by_lun(s
 
 	read_lock_irqsave(&port->unit_list_lock, flags);
 	list_for_each_entry(unit, &port->unit_list, list)
-		if ((unit->fcp_lun == fcp_lun) &&
-		    !(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_REMOVE)) {
-			get_device(&unit->sysfs_device);
+		if (unit->fcp_lun == fcp_lun) {
+			if (!get_device(&unit->sysfs_device))
+				unit = NULL;
 			read_unlock_irqrestore(&port->unit_list_lock, flags);
 			return unit;
 		}
@@ -270,9 +270,9 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
-		if ((port->wwpn == wwpn) &&
-		    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE)) {
-			get_device(&port->sysfs_device);
+		if (port->wwpn == wwpn) {
+			if (!get_device(&port->sysfs_device))
+				port = NULL;
 			read_unlock_irqrestore(&adapter->port_list_lock, flags);
 			return port;
 		}
@@ -334,9 +334,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	}
 	retval = -EINVAL;
 
-	/* mark unit unusable as long as sysfs registration is not complete */
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-
 	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
 
 	spin_lock_init(&unit->latencies.lock);
@@ -360,7 +357,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
 
 	return unit;
@@ -565,17 +561,12 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 
 	adapter->service_level.seq_print = zfcp_print_sl;
 
-	/* mark adapter unusable as long as sysfs registration is not complete */
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-
 	dev_set_drvdata(&ccw_device->dev, adapter);
 
 	if (sysfs_create_group(&ccw_device->dev.kobj,
 			       &zfcp_sysfs_adapter_attrs))
 		goto failed;
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-
 	if (!zfcp_adapter_scsi_register(adapter))
 		return adapter;
 
@@ -692,9 +683,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	port->sysfs_device.parent = &adapter->ccw_device->dev;
 	port->sysfs_device.release = zfcp_port_release;
 
-	/* mark port unusable as long as sysfs registration is not complete */
-	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
-
 	if (dev_set_name(&port->sysfs_device, "0x%016llx",
 			 (unsigned long long)wwpn)) {
 		kfree(port);
@@ -715,8 +703,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	list_add_tail(&port->list, &adapter->port_list);
 	write_unlock_irq(&adapter->port_list_lock);
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
-	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
+	atomic_set_mask(status | ZFCP_STATUS_COMMON_RUNNING, &port->status);
 
 	return port;
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:40.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:40.000000000 +0100
@@ -113,16 +113,11 @@ static void zfcp_ccw_remove(struct ccw_d
 	write_lock_irq(&adapter->port_list_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list, list) {
 		write_lock(&port->unit_list_lock);
-		list_for_each_entry_safe(unit, u, &port->unit_list, list) {
-			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
-					&unit->status);
+		list_for_each_entry_safe(unit, u, &port->unit_list, list)
 			list_move(&unit->list, &unit_remove_lh);
-		}
 		write_unlock(&port->unit_list_lock);
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 		list_move(&port->list, &port_remove_lh);
 	}
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 	write_unlock_irq(&adapter->port_list_lock);
 	zfcp_ccw_adapter_put(adapter); /* put from zfcp_ccw_adapter_by_cdev */
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:40.000000000 +0100
@@ -205,7 +205,6 @@ struct zfcp_ls_adisc {
 #define ZFCP_COMMON_FLAGS			0xfff00000
 
 /* common status bits */
-#define ZFCP_STATUS_COMMON_REMOVE		0x80000000
 #define ZFCP_STATUS_COMMON_RUNNING		0x40000000
 #define ZFCP_STATUS_COMMON_ERP_FAILED		0x20000000
 #define ZFCP_STATUS_COMMON_UNBLOCKED		0x10000000
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-11-23 09:59:40.000000000 +0100
@@ -174,7 +174,8 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	switch (need) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		get_device(&unit->sysfs_device);
+		if (!get_device(&unit->sysfs_device))
+			return NULL;
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
 		erp_action = &unit->erp_action;
 		if (!(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_RUNNING))
@@ -183,7 +184,8 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		get_device(&port->sysfs_device);
+		if (!get_device(&port->sysfs_device))
+			return NULL;
 		zfcp_erp_action_dismiss_port(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:40.000000000 +0100
@@ -589,7 +589,6 @@ static void zfcp_fc_validate_port(struct
 	    !list_empty(&port->unit_list))
 		return;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	list_move_tail(&port->list, lh);
 }
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:40.000000000 +0100
@@ -104,10 +104,8 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 	unsigned long val;						       \
 	int retval = 0;							       \
 									       \
-	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_REMOVE) {	       \
-		retval = -EBUSY;					       \
-		goto out;						       \
-	}								       \
+	if (!(_feat && get_device(&_feat->sysfs_device)))		       \
+		return -EBUSY;						       \
 									       \
 	if (strict_strtoul(buf, 0, &val) || val != 0) {			       \
 		retval = -EINVAL;					       \
@@ -120,6 +118,7 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 				  _reopen_id, NULL);			       \
 	zfcp_erp_wait(_adapter);					       \
 out:									       \
+	put_device(&_feat->sysfs_device);				       \
 	return retval ? retval : (ssize_t) count;			       \
 }									       \
 static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
@@ -161,11 +160,6 @@ static ssize_t zfcp_sysfs_adapter_failed
 	if (!adapter)
 		return -ENODEV;
 
-	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
-		retval = -EBUSY;
-		goto out;
-	}
-
 	if (strict_strtoul(buf, 0, &val) || val != 0) {
 		retval = -EINVAL;
 		goto out;
@@ -195,14 +189,9 @@ static ssize_t zfcp_sysfs_port_rescan_st
 	if (!adapter)
 		return -ENODEV;
 
-	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = zfcp_fc_scan_ports(adapter);
-out:
 	zfcp_ccw_adapter_put(adapter);
+
 	return ret ? ret : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
@@ -216,28 +205,19 @@ static ssize_t zfcp_sysfs_port_remove_st
 	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	struct zfcp_port *port;
 	u64 wwpn;
-	int retval = 0;
+	int retval = -EINVAL;
 
 	if (!adapter)
 		return -ENODEV;
 
-	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
-		retval = -EBUSY;
+	if (strict_strtoull(buf, 0, (unsigned long long *) &wwpn))
 		goto out;
-	}
-
-	if (strict_strtoull(buf, 0, (unsigned long long *) &wwpn)) {
-		retval = -EINVAL;
-		goto out;
-	}
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
-	if (!port) {
-		retval = -ENXIO;
+	if (!port)
 		goto out;
-	}
-
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+	else
+		retval = 0;
 
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
@@ -283,10 +263,8 @@ static ssize_t zfcp_sysfs_unit_add_store
 	u64 fcp_lun;
 	int retval = -EINVAL;
 
-	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
-		retval = -EBUSY;
-		goto out;
-	}
+	if (!(port && get_device(&port->sysfs_device)))
+		return -EBUSY;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		goto out;
@@ -294,13 +272,14 @@ static ssize_t zfcp_sysfs_unit_add_store
 	unit = zfcp_unit_enqueue(port, fcp_lun);
 	if (IS_ERR(unit))
 		goto out;
-
-	retval = 0;
+	else
+		retval = 0;
 
 	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	flush_work(&unit->scsi_work);
 out:
+	put_device(&port->sysfs_device);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
@@ -313,29 +292,23 @@ static ssize_t zfcp_sysfs_unit_remove_st
 					      sysfs_device);
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
-	int retval = 0;
+	int retval = -EINVAL;
 
-	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
-		retval = -EBUSY;
-		goto out;
-	}
+	if (!(port && get_device(&port->sysfs_device)))
+		return -EBUSY;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun)) {
-		retval = -EINVAL;
+	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		goto out;
-	}
 
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (!unit) {
-		retval = -EINVAL;
+	if (!unit)
 		goto out;
-	}
+	else
+		retval = 0;
 
 	/* wait for possible timeout during SCSI probe */
 	flush_work(&unit->scsi_work);
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-
 	write_lock_irq(&port->unit_list_lock);
 	list_del(&unit->list);
 	write_unlock_irq(&port->unit_list_lock);
@@ -345,6 +318,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
 	zfcp_device_unregister(&unit->sysfs_device, &zfcp_sysfs_unit_attrs);
 out:
+	put_device(&port->sysfs_device);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);

