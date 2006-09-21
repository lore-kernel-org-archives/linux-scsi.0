From: Sumant Patro <sumantp@lsil.com>
Subject: [Patch 4/7] megaraid_sas: adds reboot handler
Date: Wed, 20 Sep 2006 19:02:51 -0700
Message-ID: <1158804171.4171.51.camel@dumbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-R6HCLmdY/wtImRhpIp5v"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750912AbWIUBC7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org, Neela.Kolli@lsil.com, Bo.Yang@lsil.com
List-Id: linux-scsi@vger.kernel.org


--=-R6HCLmdY/wtImRhpIp5v
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch adds handler to get reboot notification and fires flush command from 
the reboot notification handler. 

Signed-off-by: Sumant Patro <Sumant.Patro@lsil.com>


diff -uprN linux-2.6orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6orig/drivers/scsi/megaraid/megaraid_sas.c 2006-09-20 11:04:34.000000000 -0700
+++ linux-2.6new/drivers/scsi/megaraid/megaraid_sas.c 2006-09-20 11:05:52.000000000 -0700
@@ -36,6 +36,8 @@
 #include <linux/fs.h>
 #include <linux/compat.h>
 #include <linux/mutex.h>
+#include <linux/reboot.h>
+#include <linux/notifier.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2351,6 +2353,36 @@ static void megasas_flush_cache(struct m
 }
 
 /**
+ * megasas_reboot_notify- Flush adapter cache
+ * @this:   Our notifier block
+ * @code:   The event notified
+ * @unused:   Unused
+ */
+static int
+megasas_reboot_notify (struct notifier_block *this, unsigned long code,
+  void *unused)
+{
+	struct megasas_instance *instance;
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+		instance = megasas_mgmt_info.instance[i];
+		if (instance) {
+			megasas_flush_cache(instance);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * notifier block to get notification on system halt/reboot/shutdown/power off
+ */
+static struct notifier_block megasas_notifier = {
+	.notifier_call = megasas_reboot_notify
+};
+
+/**
  * megasas_shutdown_controller -	Instructs FW to shutdown the controller
  * @instance:				Adapter soft state
  */
@@ -2903,6 +2935,10 @@ static int __init megasas_init(void)
 	driver_create_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 
+	if(register_reboot_notifier(&megasas_notifier)) {
+		printk("megasas: reboot notify routine registration failed!!\n");
+	}
+
 	return rval;
 }
 
@@ -2917,6 +2953,7 @@ static void __exit megasas_exit(void)
 
  pci_unregister_driver(&megasas_pci_driver);
  unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl");
+ unregister_reboot_notifier(&megasas_notifier);
 }
 
 module_init(megasas_init);


--=-R6HCLmdY/wtImRhpIp5v
Content-Disposition: attachment; filename=reboot_noti-p4.patch
Content-Type: text/x-patch; name=reboot_noti-p4.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN linux-2.6orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6orig/drivers/scsi/megaraid/megaraid_sas.c	2006-09-20 11:04:34.000000000 -0700
+++ linux-2.6new/drivers/scsi/megaraid/megaraid_sas.c	2006-09-20 11:05:52.000000000 -0700
@@ -36,6 +36,8 @@
 #include <linux/fs.h>
 #include <linux/compat.h>
 #include <linux/mutex.h>
+#include <linux/reboot.h>
+#include <linux/notifier.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2351,6 +2353,36 @@ static void megasas_flush_cache(struct m
 }
 
 /**
+ * megasas_reboot_notify-	Flush adapter cache
+ * @this:			Our notifier block
+ * @code:			The event notified
+ * @unused:			Unused
+ */
+static int
+megasas_reboot_notify (struct notifier_block *this, unsigned long code,
+		void *unused)
+{
+	struct megasas_instance *instance;
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+		instance = megasas_mgmt_info.instance[i];
+		if (instance) {
+			megasas_flush_cache(instance);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * notifier block to get notification on system halt/reboot/shutdown/power off
+ */
+static struct notifier_block megasas_notifier = {
+	.notifier_call = megasas_reboot_notify
+};
+
+/**
  * megasas_shutdown_controller -	Instructs FW to shutdown the controller
  * @instance:				Adapter soft state
  */
@@ -2903,6 +2935,10 @@ static int __init megasas_init(void)
 	driver_create_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 
+	if(register_reboot_notifier(&megasas_notifier)) {
+		printk("megasas: reboot notify routine registration failed!!\n");
+	}
+
 	return rval;
 }
 
@@ -2917,6 +2953,7 @@ static void __exit megasas_exit(void)
 
 	pci_unregister_driver(&megasas_pci_driver);
 	unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl");
+	unregister_reboot_notifier(&megasas_notifier);
 }
 
 module_init(megasas_init);

--=-R6HCLmdY/wtImRhpIp5v--
