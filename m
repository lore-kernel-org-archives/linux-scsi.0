From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 8/9] zfcp: Keep ccw device and model id in zfcp_ccw.c
Date: Fri, 15 May 2009 13:18:21 +0200
Message-ID: <20090515112222.343264000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62809 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=707-zfcp-ccw-device-model.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Keep the information about the device and model id in zfcp_ccw. This
requires an additional helper function to check for the privileged
cfdc subchannel, but it allows the removal of the redundant defines
from the zfcp_def header file.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |   26 ++++++++++++++++++--------
 drivers/s390/scsi/zfcp_def.h |    7 -------
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 4 files changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/s390/scsi/zfcp_ccw.c	2009-05-15 12:56:11.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-05-15 12:56:22.000000000 +0200
@@ -11,6 +11,24 @@
 
 #include "zfcp_ext.h"
 
+#define ZFCP_MODEL_PRIV 0x4
+
+static struct ccw_device_id zfcp_ccw_device_id[] = {
+	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x3) },
+	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, ZFCP_MODEL_PRIV) },
+	{},
+};
+MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
+
+/**
+ * zfcp_ccw_priv_sch - check if subchannel is privileged
+ * @adapter: Adapter/Subchannel to check
+ */
+int zfcp_ccw_priv_sch(struct zfcp_adapter *adapter)
+{
+	return adapter->ccw_device->id.dev_model == ZFCP_MODEL_PRIV;
+}
+
 /**
  * zfcp_ccw_probe - probe function of zfcp driver
  * @ccw_device: pointer to belonging ccw device
@@ -199,14 +217,6 @@ static void zfcp_ccw_shutdown(struct ccw
 	up(&zfcp_data.config_sema);
 }
 
-static struct ccw_device_id zfcp_ccw_device_id[] = {
-	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x3) },
-	{ CCW_DEVICE_DEVTYPE(0x1731, 0x3, 0x1732, 0x4) }, /* priv. */
-	{},
-};
-
-MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
-
 static struct ccw_driver zfcp_ccw_driver = {
 	.owner       = THIS_MODULE,
 	.name        = "zfcp",
--- a/drivers/s390/scsi/zfcp_def.h	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-05-15 12:56:22.000000000 +0200
@@ -50,13 +50,6 @@
 
 /********************* CIO/QDIO SPECIFIC DEFINES *****************************/
 
-/* Adapter Identification Parameters */
-#define ZFCP_CONTROL_UNIT_TYPE  0x1731
-#define ZFCP_CONTROL_UNIT_MODEL 0x03
-#define ZFCP_DEVICE_TYPE        0x1732
-#define ZFCP_DEVICE_MODEL       0x03
-#define ZFCP_DEVICE_MODEL_PRIV	0x04
-
 /* DMQ bug workaround: don't use last SBALE */
 #define ZFCP_MAX_SBALES_PER_SBAL	(QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
 
--- a/drivers/s390/scsi/zfcp_ext.h	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-05-15 12:56:22.000000000 +0200
@@ -27,6 +27,7 @@ extern int zfcp_sg_setup_table(struct sc
 
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
+extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
 extern struct zfcp_adapter *zfcp_get_adapter_by_busid(char *);
 
 /* zfcp_cfdc.c */
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:19.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:22.000000000 +0200
@@ -1887,7 +1887,7 @@ static void zfcp_fsf_open_unit_handler(s
 
 		if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE) &&
 		    (adapter->adapter_features & FSF_FEATURE_LUN_SHARING) &&
-		    (adapter->ccw_device->id.dev_model != ZFCP_DEVICE_MODEL_PRIV)) {
+		    !zfcp_ccw_priv_sch(adapter)) {
 			exclusive = (bottom->lun_access_info &
 					FSF_UNIT_ACCESS_EXCLUSIVE);
 			readwrite = (bottom->lun_access_info &

