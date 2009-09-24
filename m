From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/5] zfcp: Fix initial device and cfdc for delayed adapter allocation
Date: Thu, 24 Sep 2009 10:23:22 +0200
Message-ID: <20090924082602.914360000@de.ibm.com>
References: <20090924082320.374328000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:41379 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIXI0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 04:26:01 -0400
Content-Disposition: inline; filename=701-zfcp-delayed-alloc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change for delaying the allocation of zfcp_adapter, the
initial device parameter function has to first call
ccw_device_set_online which allocates the zfcp_adapter structure.
Change this and adapt the cfdc part accordingly.

Reviewed-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |   31 ++++++++++++++++++++-----------
 drivers/s390/scsi/zfcp_ccw.c  |   19 +------------------
 drivers/s390/scsi/zfcp_cfdc.c |   17 ++++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h  |    2 +-
 4 files changed, 38 insertions(+), 31 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:12:54.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:13:18.000000000 +0200
@@ -80,28 +80,35 @@ int zfcp_reqlist_isempty(struct zfcp_ada
 
 static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 {
+	struct ccw_device *ccwdev;
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 
-	mutex_lock(&zfcp_data.config_mutex);
-	read_lock_irq(&zfcp_data.config_lock);
-	adapter = zfcp_get_adapter_by_busid(busid);
-	if (adapter)
-		zfcp_adapter_get(adapter);
-	read_unlock_irq(&zfcp_data.config_lock);
+	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!ccwdev)
+		return;
+
+	if (ccw_device_set_online(ccwdev))
+		goto out_ccwdev;
 
+	mutex_lock(&zfcp_data.config_mutex);
+	adapter = dev_get_drvdata(&ccwdev->dev);
 	if (!adapter)
-		goto out_adapter;
-	port = zfcp_port_enqueue(adapter, wwpn, 0, 0);
-	if (IS_ERR(port))
+		goto out_unlock;
+	zfcp_adapter_get(adapter);
+
+	port = zfcp_get_port_by_wwpn(adapter, wwpn);
+	if (!port)
 		goto out_port;
+
+	zfcp_port_get(port);
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
 	mutex_unlock(&zfcp_data.config_mutex);
-	ccw_device_set_online(adapter->ccw_device);
 
+	zfcp_erp_unit_reopen(unit, 0, "auidc_1", NULL);
 	zfcp_erp_wait(adapter);
 	flush_work(&unit->scsi_work);
 
@@ -111,8 +118,10 @@ out_unit:
 	zfcp_port_put(port);
 out_port:
 	zfcp_adapter_put(adapter);
-out_adapter:
+out_unlock:
 	mutex_unlock(&zfcp_data.config_mutex);
+out_ccwdev:
+	put_device(&ccwdev->dev);
 	return;
 }
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:12:54.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:18.000000000 +0200
@@ -259,7 +259,7 @@ static void zfcp_ccw_shutdown(struct ccw
 	mutex_unlock(&zfcp_data.config_mutex);
 }
 
-static struct ccw_driver zfcp_ccw_driver = {
+struct ccw_driver zfcp_ccw_driver = {
 	.owner       = THIS_MODULE,
 	.name        = "zfcp",
 	.ids         = zfcp_ccw_device_id,
@@ -284,20 +284,3 @@ int __init zfcp_ccw_register(void)
 {
 	return ccw_driver_register(&zfcp_ccw_driver);
 }
-
-/**
- * zfcp_get_adapter_by_busid - find zfcp_adapter struct
- * @busid: bus id string of zfcp adapter to find
- */
-struct zfcp_adapter *zfcp_get_adapter_by_busid(char *busid)
-{
-	struct ccw_device *ccw_device;
-	struct zfcp_adapter *adapter = NULL;
-
-	ccw_device = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
-	if (ccw_device) {
-		adapter = dev_get_drvdata(&ccw_device->dev);
-		put_device(&ccw_device->dev);
-	}
-	return adapter;
-}
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_cfdc.c linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c
--- linux-2.6/drivers/s390/scsi/zfcp_cfdc.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c	2009-09-23 10:13:18.000000000 +0200
@@ -86,8 +86,23 @@ static int zfcp_cfdc_copy_to_user(void _
 static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
 {
 	char busid[9];
+	struct ccw_device *ccwdev;
+	struct zfcp_adapter *adapter = NULL;
+
 	snprintf(busid, sizeof(busid), "0.0.%04x", devno);
-	return zfcp_get_adapter_by_busid(busid);
+	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!ccwdev)
+		goto out;
+
+	adapter = dev_get_drvdata(&ccwdev->dev);
+	if (!adapter)
+		goto out_put;
+
+	zfcp_adapter_get(adapter);
+out_put:
+	put_device(&ccwdev->dev);
+out:
+	return adapter;
 }
 
 static int zfcp_cfdc_set_fsf(struct zfcp_fsf_cfdc *fsf_cfdc, int command)
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-09-23 10:12:54.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-09-23 10:13:18.000000000 +0200
@@ -28,7 +28,7 @@ extern int zfcp_sg_setup_table(struct sc
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
 extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
-extern struct zfcp_adapter *zfcp_get_adapter_by_busid(char *);
+extern struct ccw_driver zfcp_ccw_driver;
 
 /* zfcp_cfdc.c */
 extern struct miscdevice zfcp_cfdc_misc;

