From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] zfcp: kfree patch
Date: Sat, 8 Jan 2005 11:36:41 +0100
Message-ID: <20050108103641.GA8018@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:22743 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261789AbVAHKwF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jan 2005 05:52:05 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j08Aq1bP217284
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jan 2005 10:52:01 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j08Aqrtk166610
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jan 2005 11:52:53 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j08Aq0PN003347
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jan 2005 11:52:01 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <greg@kroah.com>

Hi James,

this is my next attempt to try to get the patch below merged. Last
time Greg KH objected and it didn't get merged.

This patch addresses the following problem: the zfcp device driver
creates own sysfs objects and therefore has its own release function
within the zfcp device driver itself. Upon module unloading there
exists a problem: the module count reaches zero and the module gets
unloaded. _But_ there might still be references to sysfs objects
created by the zfcp device driver (a device driver can't wait until
there are no more references to its created sysfs objects as this
might lead to a deadlock situation, which was already discussed).
So we finally have no more zfcp module code in the kernel but zfcp
generated sysfs objects. If the reference count of these objects
finally drops to zero zfcp's release function will be called...
Which will lead to unpredictable results since the module was already
unloaded.
One solution to this problem is to simply use kfree as release
function since its always there. This doesn't look nice, but it works
and it's safe. And finally would allow module unloading of the zfcp
device driver again.

That's the only solution to this problem that I know of. If anybody
objects to this patch it would be nice if the one comes up with a
better solution.

Thanks,
Heiko

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

===== zfcp_aux.c 1.17 vs edited =====
--- 1.17/drivers/s390/scsi/zfcp_aux.c	2004-11-19 08:03:14 +01:00
+++ edited/zfcp_aux.c	2005-01-08 10:50:32 +01:00
@@ -40,6 +40,7 @@
 
 /* written against the module interface */
 static int __init  zfcp_module_init(void);
+static void __exit zfcp_module_exit(void);
 
 /* FCP related */
 static void zfcp_ns_gid_pn_handler(unsigned long);
@@ -77,6 +78,7 @@
 
 /* declare driver module init/cleanup functions */
 module_init(zfcp_module_init);
+module_exit(zfcp_module_exit);
 
 MODULE_AUTHOR("Heiko Carstens <heiko.carstens@de.ibm.com>, "
 	      "Andreas Herrman <aherrman@de.ibm.com>, "
@@ -354,6 +356,15 @@
 	return retval;
 }
 
+static void __exit
+zfcp_module_exit(void)
+{
+	zfcp_ccw_unregister();
+	misc_deregister(&zfcp_cfdc_misc);
+	unregister_ioctl32_conversion(zfcp_ioctl_trans.cmd);
+  	fc_release_transport(zfcp_transport_template);
+}
+
 /*
  * function:    zfcp_cfdc_dev_ioctl
  *
@@ -871,7 +882,7 @@
 	/* setup for sysfs registration */
 	snprintf(unit->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx", fcp_lun);
 	unit->sysfs_device.parent = &port->sysfs_device;
-	unit->sysfs_device.release = zfcp_sysfs_unit_release;
+	unit->sysfs_device.release = (void (*)(struct device *))kfree;
 	dev_set_drvdata(&unit->sysfs_device, unit);
 
 	/* mark unit unusable as long as sysfs registration is not complete */
@@ -1098,12 +1109,6 @@
 	adapter->in_els_dbf = NULL;
 }
 
-void
-zfcp_dummy_release(struct device *dev)
-{
-	return;
-}
-
 /*
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
@@ -1119,6 +1124,7 @@
 {
 	int retval = 0;
 	struct zfcp_adapter *adapter;
+	struct device *gs;
 
 	/*
 	 * Note: It is safe to release the list_lock, as any list changes 
@@ -1195,13 +1201,19 @@
 	if (zfcp_sysfs_adapter_create_files(&ccw_device->dev))
 		goto sysfs_failed;
 
-	adapter->generic_services.parent = &adapter->ccw_device->dev;
-	adapter->generic_services.release = zfcp_dummy_release;
-	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
-		 "generic_services");
+	gs = kmalloc(sizeof(struct device), GFP_KERNEL);
+	if (!gs)
+		goto gs_failed;
+	memset(gs, 0, sizeof(struct device));
+
+	gs->parent = &adapter->ccw_device->dev;
+	gs->release = (void (*)(struct device *))kfree;
+	snprintf(gs->bus_id, BUS_ID_SIZE, "generic_services");
+
+	if (device_register(gs))
+		goto gs_free;
 
-	if (device_register(&adapter->generic_services))
-		goto generic_services_failed;
+	adapter->generic_services = gs;
 
 	/* put allocated adapter at list tail */
 	write_lock_irq(&zfcp_data.config_lock);
@@ -1213,7 +1225,9 @@
 
 	goto out;
 
- generic_services_failed:
+ gs_free:
+	kfree(gs);
+ gs_failed:
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
  sysfs_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
@@ -1245,7 +1259,7 @@
 	int retval = 0;
 	unsigned long flags;
 
-	device_unregister(&adapter->generic_services);
+	device_unregister(adapter->generic_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
@@ -1370,13 +1384,13 @@
 			return NULL;
 		}
 		port->d_id = d_id;
-		port->sysfs_device.parent = &adapter->generic_services;
+		port->sysfs_device.parent = adapter->generic_services;
 	} else {
 		snprintf(port->sysfs_device.bus_id,
 			 BUS_ID_SIZE, "0x%016llx", wwpn);
-	port->sysfs_device.parent = &adapter->ccw_device->dev;
+		port->sysfs_device.parent = &adapter->ccw_device->dev;
 	}
-	port->sysfs_device.release = zfcp_sysfs_port_release;
+	port->sysfs_device.release = (void (*)(struct device *))kfree;
 	dev_set_drvdata(&port->sysfs_device, port);
 
 	/* mark port unusable as long as sysfs registration is not complete */
===== zfcp_def.h 1.20 vs edited =====
--- 1.20/drivers/s390/scsi/zfcp_def.h	2004-12-07 11:19:06 +01:00
+++ edited/zfcp_def.h	2005-01-08 10:50:33 +01:00
@@ -903,7 +903,7 @@
 	spinlock_t              dbf_lock;
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
-	struct device           generic_services;  /* directory for WKA ports */
+	struct device           *generic_services; /* directory for WKA ports */
 };
 
 /*
===== zfcp_ext.h 1.13 vs edited =====
--- 1.13/drivers/s390/scsi/zfcp_ext.h	2004-12-07 11:19:06 +01:00
+++ edited/zfcp_ext.h	2005-01-08 10:50:34 +01:00
@@ -47,8 +47,6 @@
 extern void zfcp_sysfs_port_remove_files(struct device *, u32);
 extern int  zfcp_sysfs_unit_create_files(struct device *);
 extern void zfcp_sysfs_unit_remove_files(struct device *);
-extern void zfcp_sysfs_port_release(struct device *);
-extern void zfcp_sysfs_unit_release(struct device *);
 
 /**************************** CONFIGURATION  *********************************/
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, fcp_lun_t);
===== zfcp_sysfs_port.c 1.11 vs edited =====
--- 1.11/drivers/s390/scsi/zfcp_sysfs_port.c	2004-11-16 04:29:22 +01:00
+++ edited/zfcp_sysfs_port.c	2005-01-08 10:50:35 +01:00
@@ -35,16 +35,6 @@
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
 
 /**
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
  * ZFCP_DEFINE_PORT_ATTR
  * @_name:   name of show attribute
  * @_format: format string
===== zfcp_sysfs_unit.c 1.9 vs edited =====
--- 1.9/drivers/s390/scsi/zfcp_sysfs_unit.c	2004-11-16 04:29:22 +01:00
+++ edited/zfcp_sysfs_unit.c	2005-01-08 10:50:36 +01:00
@@ -35,16 +35,6 @@
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
 
 /**
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
  * ZFCP_DEFINE_UNIT_ATTR
  * @_name:   name of show attribute
  * @_format: format string
