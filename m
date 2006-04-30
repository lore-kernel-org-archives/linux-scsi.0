From: Eric Moore <eric.moore@lsil.com>
Subject: [RFC] fusion - merge mptctl into mpbase
Date: Sat, 29 Apr 2006 20:17:12 -0600
Message-ID: <20060430021712.GA28053@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9383 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750863AbWD3CTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Apr 2006 22:19:03 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k3U2D3NI020598
	for <linux-scsi@vger.kernel.org>; Sat, 29 Apr 2006 19:13:03 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k3U2J2pk015225
	for <linux-scsi@vger.kernel.org>; Sat, 29 Apr 2006 19:19:02 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It is a request of one of our customers to merge our mptctl ioctl module
into our mptbase driver, so ioctls are always enabled when our
driver stack loads. Currently we have to provide a special service
script that is placed in /etc/init.d, that is auto loading mptctl.ko
at boot time.  Our customer want to move away from using that script, so
having the ioclts aways enabled at boot time.

Here is a minimal patch that merges mptctl.c into mptbase.c.
This is done by merely having the mptctl_init and mptctl_exit entry
points called directly by mptbase, from mptbase_init and mptbase_exit.

The problem I'm facing is we would like to keep the mptbase.ko module
named the same as mptbase.ko, instead of mptbase_mod.ko, as I have done
in this patch.

Can someone help me with this.  How do you link several c files
into a single KO, meaning mptbase.o + mptctl.o = mptbase.ko.
Is there a way to have the KO named the same as one of the original c
files?

I was tyring to get some hints from
/usr/src/linux/Documentation/kbuild/makefile.txt

Eric Moore



diff -uarN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2006-04-20 12:39:28.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2006-04-28 10:12:17.000000000 -0600
@@ -66,25 +66,6 @@
 	  Decreasing this parameter will reduce memory requirements
 	  on a per controller instance.
 
-config FUSION_CTL
-	tristate "Fusion MPT misc device (ioctl) driver"
-	depends on FUSION_SPI || FUSION_FC
-	---help---
-	  The Fusion MPT misc device driver provides specialized control
-	  of MPT adapters via system ioctl calls.  Use of ioctl calls to
-	  the MPT driver requires that you create and use a misc device
-	  node ala:
-	  mknod /dev/mptctl c 10 240
-
-	  One use of this ioctl interface is to perform an upgrade (reflash)
-	  of the MPT adapter firmware.  Refer to readme file(s) distributed
-	  with the Fusion MPT linux driver for additional details.
-
-	  If enabled by saying M to this, a driver named: mptctl
-	  will be compiled.
-
-	  If unsure whether you really want or need this, say N.
-
 config FUSION_LAN
 	tristate "Fusion MPT LAN driver"
 	depends on FUSION_FC && NET_FC
diff -uarN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2006-04-25 09:26:13.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2006-04-29 17:45:12.000000000 -0600
@@ -35,8 +35,9 @@
 
 #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-} LSI_LOGIC
 
-obj-$(CONFIG_FUSION_SPI)	+= mptbase.o mptscsih.o mptspi.o
-obj-$(CONFIG_FUSION_FC)		+= mptbase.o mptscsih.o mptfc.o
-obj-$(CONFIG_FUSION_SAS)	+= mptbase.o mptscsih.o mptsas.o
-obj-$(CONFIG_FUSION_CTL)	+= mptctl.o
+mptbase_mod-objs      		:= mptctl.o mptbase.o
+
+obj-$(CONFIG_FUSION_SPI)	+= mptbase_mod.o mptscsih.o mptspi.o
+obj-$(CONFIG_FUSION_FC)		+= mptbase_mod.o mptscsih.o mptfc.o
+obj-$(CONFIG_FUSION_SAS)	+= mptbase_mod.o mptscsih.o mptsas.o
 obj-$(CONFIG_FUSION_LAN)	+= mptlan.o
diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-04-25 09:25:18.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-04-28 10:54:57.000000000 -0600
@@ -68,6 +68,8 @@
 #endif
 
 #include "mptbase.h"
+extern int mptctl_init(void);
+extern void mptctl_exit(void);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define my_NAME		"Fusion MPT base driver"
@@ -6508,6 +6510,7 @@
 #ifdef CONFIG_PROC_FS
 	(void) procmpt_create();
 #endif
+	mptctl_init();
 	return 0;
 }
 
@@ -6521,7 +6524,7 @@
 static void __exit
 fusion_exit(void)
 {
-
+	mptctl_exit();
 	dexitprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
 
 	mpt_reset_deregister(mpt_base_index);
diff -uarN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-04-20 12:39:28.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2006-04-29 17:47:42.000000000 -0600
@@ -66,20 +66,12 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
-#define COPYRIGHT	"Copyright (c) 1999-2005 LSI Logic Corporation"
-#define MODULEAUTHOR	"LSI Logic Corporation"
 #include "mptbase.h"
 #include "mptctl.h"
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-#define my_NAME		"Fusion MPT misc device (ioctl) driver"
-#define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptctl"
 
-MODULE_AUTHOR(MODULEAUTHOR);
-MODULE_DESCRIPTION(my_NAME);
-MODULE_LICENSE("GPL");
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 static int mptctl_id = -1;
@@ -2927,13 +2919,11 @@
 };
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static int __init mptctl_init(void)
+int mptctl_init(void)
 {
 	int err;
 	int where = 1;
 
-	show_mptmod_ver(my_NAME, my_VERSION);
-
 	if(mpt_device_driver_register(&mptctl_driver,
 	  MPTCTL_DRIVER) != 0 ) {
 		dprintk((KERN_INFO MYNAM
@@ -2946,7 +2936,6 @@
 		printk(KERN_ERR MYNAM ": Can't register misc device [minor=%d].\n", MPT_MINOR);
 		goto out_fail;
 	}
-	printk(KERN_INFO MYNAM ": Registered with Fusion MPT base driver\n");
 	printk(KERN_INFO MYNAM ": /dev/%s @ (major,minor=%d,%d)\n",
 			 mptctl_miscdev.name, MISC_MAJOR, mptctl_miscdev.minor);
 
@@ -2980,9 +2969,10 @@
 
 	return err;
 }
+EXPORT_SYMBOL(mptctl_init);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static void mptctl_exit(void)
+void mptctl_exit(void)
 {
 	misc_deregister(&mptctl_miscdev);
 	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
@@ -2994,13 +2984,10 @@
 
 	/* De-register callback handler from base module */
 	mpt_deregister(mptctl_id);
-	printk(KERN_INFO MYNAM ": Deregistered from Fusion MPT base driver\n");
 
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
 }
+EXPORT_SYMBOL(mptctl_exit);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-
-module_init(mptctl_init);
-module_exit(mptctl_exit);
