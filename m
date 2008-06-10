From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/8] zfcp: Cleanup code in zfcp_ccw
Date: Tue, 10 Jun 2008 18:20:56 +0200
Message-ID: <20080610162514.720265000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30378 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYFJQZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:19 -0400
Content-Disposition: inline; filename=zfcp-cleanup-ccw.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Overall cleanup in file zfcp_ccw.c. Fix coding style issues, remove
useless macros and messages and convert remaining messages to standard
macros.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |  150 ++++++++++++++-----------------------------
 1 file changed, 50 insertions(+), 100 deletions(-)

--- a/drivers/s390/scsi/zfcp_ccw.c	2008-06-02 09:33:12.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-06-02 09:41:55.000000000 +0200
@@ -1,64 +1,13 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Registration and callback for the s390 common I/O layer.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
 
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_CONFIG
-
-static int zfcp_ccw_probe(struct ccw_device *);
-static void zfcp_ccw_remove(struct ccw_device *);
-static int zfcp_ccw_set_online(struct ccw_device *);
-static int zfcp_ccw_set_offline(struct ccw_device *);
-static int zfcp_ccw_notify(struct ccw_device *, int);
-static void zfcp_ccw_shutdown(struct ccw_device *);
-
-static struct ccw_device_id zfcp_ccw_device_id[] = {
-	{CCW_DEVICE_DEVTYPE(ZFCP_CONTROL_UNIT_TYPE,
-			    ZFCP_CONTROL_UNIT_MODEL,
-			    ZFCP_DEVICE_TYPE,
-			    ZFCP_DEVICE_MODEL)},
-	{CCW_DEVICE_DEVTYPE(ZFCP_CONTROL_UNIT_TYPE,
-			    ZFCP_CONTROL_UNIT_MODEL,
-			    ZFCP_DEVICE_TYPE,
-			    ZFCP_DEVICE_MODEL_PRIV)},
-	{},
-};
-
-static struct ccw_driver zfcp_ccw_driver = {
-	.owner       = THIS_MODULE,
-	.name        = ZFCP_NAME,
-	.ids         = zfcp_ccw_device_id,
-	.probe       = zfcp_ccw_probe,
-	.remove      = zfcp_ccw_remove,
-	.set_online  = zfcp_ccw_set_online,
-	.set_offline = zfcp_ccw_set_offline,
-	.notify      = zfcp_ccw_notify,
-	.shutdown    = zfcp_ccw_shutdown,
-	.driver = {
-		.groups = zfcp_driver_attr_groups,
-	},
-};
-
-MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
-
 /**
  * zfcp_ccw_probe - probe function of zfcp driver
  * @ccw_device: pointer to belonging ccw device
@@ -69,19 +18,18 @@ MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device
  * In addition the nameserver port will be added to the ports of the adapter
  * and its sysfs representation will be created too.
  */
-static int
-zfcp_ccw_probe(struct ccw_device *ccw_device)
+static int zfcp_ccw_probe(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 	int retval = 0;
 
 	down(&zfcp_data.config_sema);
 	adapter = zfcp_adapter_enqueue(ccw_device);
-	if (!adapter)
+	if (!adapter) {
+		dev_err(&ccw_device->dev,
+			"Setup of data structures failed.\n");
 		retval = -EINVAL;
-	else
-		ZFCP_LOG_DEBUG("Probed adapter %s\n",
-			       zfcp_get_busid_by_adapter(adapter));
+	}
 	up(&zfcp_data.config_sema);
 	return retval;
 }
@@ -95,8 +43,7 @@ zfcp_ccw_probe(struct ccw_device *ccw_de
  * ports that belong to this adapter. And in addition all resources of this
  * adapter will be freed too.
  */
-static void
-zfcp_ccw_remove(struct ccw_device *ccw_device)
+static void zfcp_ccw_remove(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port, *p;
@@ -106,8 +53,6 @@ zfcp_ccw_remove(struct ccw_device *ccw_d
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 
-	ZFCP_LOG_DEBUG("Removing adapter %s\n",
-		       zfcp_get_busid_by_adapter(adapter));
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_list_head, list) {
@@ -145,8 +90,7 @@ zfcp_ccw_remove(struct ccw_device *ccw_d
  * registered with the SCSI stack, that the QDIO queues will be set up
  * and that the adapter will be opened (asynchronously).
  */
-static int
-zfcp_ccw_set_online(struct ccw_device *ccw_device)
+static int zfcp_ccw_set_online(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 	int retval;
@@ -155,12 +99,8 @@ zfcp_ccw_set_online(struct ccw_device *c
 	adapter = dev_get_drvdata(&ccw_device->dev);
 
 	retval = zfcp_erp_thread_setup(adapter);
-	if (retval) {
-		ZFCP_LOG_INFO("error: start of error recovery thread for "
-			      "adapter %s failed\n",
-			      zfcp_get_busid_by_adapter(adapter));
+	if (retval)
 		goto out;
-	}
 
 	retval = zfcp_adapter_scsi_register(adapter);
 	if (retval)
@@ -191,8 +131,7 @@ zfcp_ccw_set_online(struct ccw_device *c
  * This function gets called by the common i/o layer and sets an adapter
  * into state offline.
  */
-static int
-zfcp_ccw_set_offline(struct ccw_device *ccw_device)
+static int zfcp_ccw_set_offline(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 
@@ -206,15 +145,14 @@ zfcp_ccw_set_offline(struct ccw_device *
 }
 
 /**
- * zfcp_ccw_notify
+ * zfcp_ccw_notify - ccw notify function
  * @ccw_device: pointer to belonging ccw device
  * @event: indicates if adapter was detached or attached
  *
  * This function gets called by the common i/o layer if an adapter has gone
  * or reappeared.
  */
-static int
-zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
+static int zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
 {
 	struct zfcp_adapter *adapter;
 
@@ -222,18 +160,15 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	switch (event) {
 	case CIO_GONE:
-		ZFCP_LOG_NORMAL("adapter %s: device gone\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&adapter->ccw_device->dev, "device gone\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 87, NULL);
 		break;
 	case CIO_NO_PATH:
-		ZFCP_LOG_NORMAL("adapter %s: no path\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_warn(&adapter->ccw_device->dev, "no path\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 88, NULL);
 		break;
 	case CIO_OPER:
-		ZFCP_LOG_NORMAL("adapter %s: operational again\n",
-				zfcp_get_busid_by_adapter(adapter));
+		dev_info(&adapter->ccw_device->dev, "operational again\n");
 		zfcp_erp_modify_adapter_status(adapter, 11, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
@@ -247,24 +182,10 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 }
 
 /**
- * zfcp_ccw_register - ccw register function
- *
- * Registers the driver at the common i/o layer. This function will be called
- * at module load time/system start.
+ * zfcp_ccw_shutdown - handle shutdown from cio
+ * @cdev: device for adapter to shutdown.
  */
-int __init
-zfcp_ccw_register(void)
-{
-	return ccw_driver_register(&zfcp_ccw_driver);
-}
-
-/**
- * zfcp_ccw_shutdown - gets called on reboot/shutdown
- *
- * Makes sure that QDIO queues are down when the system gets stopped.
- */
-static void
-zfcp_ccw_shutdown(struct ccw_device *cdev)
+static void zfcp_ccw_shutdown(struct ccw_device *cdev)
 {
 	struct zfcp_adapter *adapter;
 
@@ -275,4 +196,33 @@ zfcp_ccw_shutdown(struct ccw_device *cde
 	up(&zfcp_data.config_sema);
 }
 
-#undef ZFCP_LOG_AREA
+static struct ccw_device_id zfcp_ccw_device_id[] = {
+	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x3) },
+	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x4) }, /* priv. */
+	{},
+};
+
+MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
+
+static struct ccw_driver zfcp_ccw_driver = {
+	.owner       = THIS_MODULE,
+	.name        = "zfcp",
+	.ids         = zfcp_ccw_device_id,
+	.probe       = zfcp_ccw_probe,
+	.remove      = zfcp_ccw_remove,
+	.set_online  = zfcp_ccw_set_online,
+	.set_offline = zfcp_ccw_set_offline,
+	.notify      = zfcp_ccw_notify,
+	.shutdown    = zfcp_ccw_shutdown,
+};
+
+/**
+ * zfcp_ccw_register - ccw register function
+ *
+ * Registers the driver at the common i/o layer. This function will be called
+ * at module load time/system start.
+ */
+int __init zfcp_ccw_register(void)
+{
+	return ccw_driver_register(&zfcp_ccw_driver);
+}

-- 
