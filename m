From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 25/27] zfcp: Handle failures during device allocation correctly
Date: Tue, 18 Aug 2009 15:43:30 +0200
Message-ID: <20090818135032.094912000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34183 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=721-zfcp-device-allocation.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

dev_set_name tries to allocate memory, so check the return value for
allocation failures. After dev_set_name succeeds, call device_register
as next step to be able to use put_device during error handling.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   65 +++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:26.000000000 +0200
@@ -274,6 +274,13 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 {
 	struct zfcp_unit *unit;
 
+	read_lock_irq(&zfcp_data.config_lock);
+	if (zfcp_get_unit_by_lun(port, fcp_lun)) {
+		read_unlock_irq(&zfcp_data.config_lock);
+		return ERR_PTR(-EINVAL);
+	}
+	read_unlock_irq(&zfcp_data.config_lock);
+
 	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
 	if (!unit)
 		return ERR_PTR(-ENOMEM);
@@ -285,8 +292,11 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
 
-	dev_set_name(&unit->sysfs_device, "0x%016llx",
-		     (unsigned long long) fcp_lun);
+	if (dev_set_name(&unit->sysfs_device, "0x%016llx",
+			 (unsigned long long) fcp_lun)) {
+		kfree(unit);
+		return ERR_PTR(-ENOMEM);
+	}
 	unit->sysfs_device.parent = &port->sysfs_device;
 	unit->sysfs_device.release = zfcp_sysfs_unit_release;
 	dev_set_drvdata(&unit->sysfs_device, unit);
@@ -302,13 +312,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
 	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
 
-	read_lock_irq(&zfcp_data.config_lock);
-	if (zfcp_get_unit_by_lun(port, fcp_lun)) {
-		read_unlock_irq(&zfcp_data.config_lock);
-		goto err_out_free;
-	}
-	read_unlock_irq(&zfcp_data.config_lock);
-
 	if (device_register(&unit->sysfs_device)) {
 		put_device(&unit->sysfs_device);
 		return ERR_PTR(-EINVAL);
@@ -317,7 +320,7 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	if (sysfs_create_group(&unit->sysfs_device.kobj,
 			       &zfcp_sysfs_unit_attrs)) {
 		device_unregister(&unit->sysfs_device);
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-EINVAL);
 	}
 
 	zfcp_unit_get(unit);
@@ -332,10 +335,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	zfcp_port_get(port);
 
 	return unit;
-
-err_out_free:
-	kfree(unit);
-	return ERR_PTR(-EINVAL);
 }
 
 /**
@@ -642,7 +641,13 @@ struct zfcp_port *zfcp_port_enqueue(stru
 				     u32 status, u32 d_id)
 {
 	struct zfcp_port *port;
-	int retval;
+
+	read_lock_irq(&zfcp_data.config_lock);
+	if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
+		read_unlock_irq(&zfcp_data.config_lock);
+		return ERR_PTR(-EINVAL);
+	}
+	read_unlock_irq(&zfcp_data.config_lock);
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
@@ -663,31 +668,24 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set(&port->refcount, 0);
 
-	dev_set_name(&port->sysfs_device, "0x%016llx",
-		     (unsigned long long)wwpn);
+	if (dev_set_name(&port->sysfs_device, "0x%016llx",
+			 (unsigned long long)wwpn)) {
+		kfree(port);
+		return ERR_PTR(-ENOMEM);
+	}
 	port->sysfs_device.parent = &adapter->ccw_device->dev;
-
 	port->sysfs_device.release = zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
 
-	read_lock_irq(&zfcp_data.config_lock);
-	if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
-		read_unlock_irq(&zfcp_data.config_lock);
-		goto err_out_free;
-	}
-	read_unlock_irq(&zfcp_data.config_lock);
-
 	if (device_register(&port->sysfs_device)) {
 		put_device(&port->sysfs_device);
-		goto err_out;
+		return ERR_PTR(-EINVAL);
 	}
 
-	retval = sysfs_create_group(&port->sysfs_device.kobj,
-				    &zfcp_sysfs_port_attrs);
-
-	if (retval) {
+	if (sysfs_create_group(&port->sysfs_device.kobj,
+			       &zfcp_sysfs_port_attrs)) {
 		device_unregister(&port->sysfs_device);
-		goto err_out;
+		return ERR_PTR(-EINVAL);
 	}
 
 	zfcp_port_get(port);
@@ -701,11 +699,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	zfcp_adapter_get(adapter);
 	return port;
-
-err_out_free:
-	kfree(port);
-err_out:
-	return ERR_PTR(-EINVAL);
 }
 
 /**

