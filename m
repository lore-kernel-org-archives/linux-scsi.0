From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/11] zfcp: Remove initial device data from zfcp_data
Date: Fri, 19 Dec 2008 16:56:57 +0100
Message-ID: <20081219155754.029951000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:39512 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYLSP54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:56 -0500
Content-Disposition: inline; filename=705-zfcp-initdev.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The information from the kernel parameter is only needed during init.
Keep the three pieces (busid, wwpn and lun) local to simplify the
global zfcp_data structures. While at it, also remove the unused
loglevel variable and give the module parameter variable a better
name.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   95 ++++++++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_def.h |    4 -
 2 files changed, 46 insertions(+), 53 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:34.000000000 +0100
@@ -28,13 +28,14 @@
 #include <linux/miscdevice.h>
 #include "zfcp_ext.h"
 
-static char *device;
+#define ZFCP_BUS_ID_SIZE	20
 
 MODULE_AUTHOR("IBM Deutschland Entwicklung GmbH - linux390@de.ibm.com");
 MODULE_DESCRIPTION("FCP HBA driver");
 MODULE_LICENSE("GPL");
 
-module_param(device, charp, 0400);
+static char *init_device;
+module_param_named(device, init_device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
 static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
@@ -67,46 +68,7 @@ int zfcp_reqlist_isempty(struct zfcp_ada
 	return 1;
 }
 
-static int __init zfcp_device_setup(char *devstr)
-{
-	char *token;
-	char *str;
-
-	if (!devstr)
-		return 0;
-
-	/* duplicate devstr and keep the original for sysfs presentation*/
-	str = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
-	if (!str)
-		return 0;
-
-	strcpy(str, devstr);
-
-	token = strsep(&str, ",");
-	if (!token || strlen(token) >= BUS_ID_SIZE)
-		goto err_out;
-	strncpy(zfcp_data.init_busid, token, BUS_ID_SIZE);
-
-	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0,
-				(unsigned long long *) &zfcp_data.init_wwpn))
-		goto err_out;
-
-	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0,
-				(unsigned long long *) &zfcp_data.init_fcp_lun))
-		goto err_out;
-
-	kfree(str);
-	return 1;
-
- err_out:
-	kfree(str);
-	pr_err("zfcp: %s is not a valid SCSI device\n", devstr);
-	return 0;
-}
-
-static void __init zfcp_init_device_configure(void)
+static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
@@ -114,17 +76,17 @@ static void __init zfcp_init_device_conf
 
 	down(&zfcp_data.config_sema);
 	read_lock_irq(&zfcp_data.config_lock);
-	adapter = zfcp_get_adapter_by_busid(zfcp_data.init_busid);
+	adapter = zfcp_get_adapter_by_busid(busid);
 	if (adapter)
 		zfcp_adapter_get(adapter);
 	read_unlock_irq(&zfcp_data.config_lock);
 
 	if (!adapter)
 		goto out_adapter;
-	port = zfcp_port_enqueue(adapter, zfcp_data.init_wwpn, 0, 0);
+	port = zfcp_port_enqueue(adapter, wwpn, 0, 0);
 	if (IS_ERR(port))
 		goto out_port;
-	unit = zfcp_unit_enqueue(port, zfcp_data.init_fcp_lun);
+	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
 	up(&zfcp_data.config_sema);
@@ -154,6 +116,42 @@ static struct kmem_cache *zfcp_cache_cre
 	return kmem_cache_create(name , size, align, 0, NULL);
 }
 
+static void __init zfcp_init_device_setup(char *devstr)
+{
+	char *token;
+	char *str;
+	char busid[ZFCP_BUS_ID_SIZE];
+	u64 wwpn, lun;
+
+	/* duplicate devstr and keep the original for sysfs presentation*/
+	str = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	if (!str)
+		return;
+
+	strcpy(str, devstr);
+
+	token = strsep(&str, ",");
+	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
+		goto err_out;
+	strncpy(busid, token, ZFCP_BUS_ID_SIZE);
+
+	token = strsep(&str, ",");
+	if (!token || strict_strtoull(token, 0, (unsigned long long *) &wwpn))
+		goto err_out;
+
+	token = strsep(&str, ",");
+	if (!token || strict_strtoull(token, 0, (unsigned long long *) &lun))
+		goto err_out;
+
+	kfree(str);
+	zfcp_init_device_configure(busid, wwpn, lun);
+	return;
+
+ err_out:
+	kfree(str);
+	pr_err("%s is not a valid SCSI device\n", devstr);
+}
+
 static int __init zfcp_module_init(void)
 {
 	int retval = -ENOMEM;
@@ -196,10 +194,9 @@ static int __init zfcp_module_init(void)
 		goto out_ccw_register;
 	}
 
-	if (zfcp_device_setup(device))
-		zfcp_init_device_configure();
-
-	goto out;
+	if (init_device)
+		zfcp_init_device_setup(init_device);
+	return 0;
 
 out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:34.000000000 +0100
@@ -595,10 +595,6 @@ struct zfcp_data {
 						       lists */
 	struct semaphore        config_sema;        /* serialises configuration
 						       changes */
-	atomic_t		loglevel;            /* current loglevel */
-	char			init_busid[20];
-	u64			init_wwpn;
-	u64			init_fcp_lun;
 	struct kmem_cache	*fsf_req_qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;

-- 
