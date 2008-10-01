From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/13] zfcp: Simplify get_adapter_by_busid
Date: Wed, 01 Oct 2008 12:42:19 +0200
Message-ID: <20081001104800.675874000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:54506 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJAKsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:10 -0400
Content-Disposition: inline; filename=zfcp_ccw_by_busid.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Call the helper function from cio instead looping through all zfcp
adapters.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |   13 -------------
 drivers/s390/scsi/zfcp_ccw.c |   17 +++++++++++++++++
 drivers/s390/scsi/zfcp_ext.h |    1 +
 3 files changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:51:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-09-30 13:51:20.000000000 +0200
@@ -106,19 +106,6 @@ static int __init zfcp_device_setup(char
 	return 0;
 }
 
-static struct zfcp_adapter *zfcp_get_adapter_by_busid(char *bus_id)
-{
-	struct zfcp_adapter *adapter;
-
-	list_for_each_entry(adapter, &zfcp_data.adapter_list_head, list)
-		if ((strncmp(bus_id, adapter->ccw_device->dev.bus_id,
-			     BUS_ID_SIZE) == 0) &&
-		    !(atomic_read(&adapter->status) &
-		      ZFCP_STATUS_COMMON_REMOVE))
-		    return adapter;
-	return NULL;
-}
-
 static void __init zfcp_init_device_configure(void)
 {
 	struct zfcp_adapter *adapter;
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-09-30 13:50:29.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-09-30 13:51:20.000000000 +0200
@@ -224,3 +224,20 @@ int __init zfcp_ccw_register(void)
 {
 	return ccw_driver_register(&zfcp_ccw_driver);
 }
+
+/**
+ * zfcp_get_adapter_by_busid - find zfcp_adapter struct
+ * @busid: bus id string of zfcp adapter to find
+ */
+struct zfcp_adapter *zfcp_get_adapter_by_busid(char *busid)
+{
+	struct ccw_device *ccw_device;
+	struct zfcp_adapter *adapter = NULL;
+
+	ccw_device = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (ccw_device) {
+		adapter = dev_get_drvdata(&ccw_device->dev);
+		put_device(&ccw_device->dev);
+	}
+	return adapter;
+}
--- a/drivers/s390/scsi/zfcp_ext.h	2008-09-30 13:51:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-09-30 13:51:20.000000000 +0200
@@ -27,6 +27,7 @@ extern int zfcp_sg_setup_table(struct sc
 
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
+extern struct zfcp_adapter *zfcp_get_adapter_by_busid(char *);
 
 /* zfcp_cfdc.c */
 extern struct miscdevice zfcp_cfdc_misc;

-- 
