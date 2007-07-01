From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 2/4] scsi: megaraid_sas -- add module param fast_load
Date: Sun, 01 Jul 2007 12:42:33 -0400
Message-ID: <1183308153.4723.8.camel@dhcp-75-197.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64995 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbXGCVVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jul 2007 17:21:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

Driver will skip physical devices scan for the first time if the
fast_load is set.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---

drivers/scsi/megaraid/megaraid_sas.c |   64 +++++++++++++++++++------
 1 files changed, 50 insertions(+), 14 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c
linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c 2007-06-30
03:36:39.000000000 -0400
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c 2007-06-30
03:59:27.000000000 -0400
@@ -46,6 +46,21 @@
 #include <scsi/scsi_host.h>
 #include "megaraid_sas.h"
 
+/*
+ * Modules parameters
+ */
+
+/*
+ * Fast driver load option, skip scanning for physical devices during
load.
+ * This would result in physical devices being skipped during driver
load
+ * time. These can be later added though, using /proc/scsi/scsi
+ */
+static unsigned int fast_load = 0;
+module_param_named(fast_load, fast_load, int, 0);
+MODULE_PARM_DESC(fast_load,
+ "megasas: Faster loading of the driver, skips physical devices! \
+  (default=0)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -1094,6 +1109,40 @@ megasas_service_aen(struct megasas_insta
 	megasas_return_cmd(instance, cmd);
 }
 
+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+		if ((megasas_mgmt_info.instance[i]) &&
+		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+			return megasas_mgmt_info.instance[i];
+	}
+
+	return NULL;
+}
+
+static int megasas_slave_alloc(struct scsi_device *sdev) {
+	struct megasas_instance *instance ;
+	int tmp_fastload = fast_load;
+	instance = megasas_lookup_instance(sdev->host->host_no);
+
+	if (tmp_fastload && sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
+		if ((sdev->id == MEGASAS_MAX_DEV_PER_CHANNEL -1) &&
+			(sdev->channel == MEGASAS_MAX_PD_CHANNELS - 1)) {
+			/* If fast load option was set and scan for last device is
+			 * over, reset the fast_load flag so that during a possible
+			 * next scan, devices can be made available
+			 */
+			fast_load = 0;
+		}
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -1103,6 +1152,7 @@ static struct scsi_host_template megasas
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
+	.slave_alloc = megasas_slave_alloc,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -2969,20 +3019,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	return error;
 }
 
-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-	int i;
-
-	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-		if ((megasas_mgmt_info.instance[i]) &&
-      (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-   return megasas_mgmt_info.instance[i];
- }
-
- return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =



