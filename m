From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Sun, 25 Jun 2006 16:15:26 -0500
Message-ID: <1151270127.3617.26.camel@mulgrave.il.steeleye.com>
References: <20060511143352.GI12272@parisc-linux.org>
	<20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060601132315.GD32143@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2006-06-01 at 07:23 -0600, Matthew Wilcox wrote:
> > What are the expected interactions of this code with early userspace aka 
> > "kinit" that comes with (soon to be merged) klibc? Does this 
> > scsi_complete_async_scans() function get called at all if such "default" 
> > initramfs with kinit is used?
> 
> It gets called as a late_initcall -- before initramfs gets started.  The
> problem comes when you load your scsi driver as a module.

Actually, the first problem is that SCSI doesn't compile as a module at
all:  late_initcalls are defined to be module_init calls for modules.
Your adding this to scsi_scan.c now gives us two module_init calls,
which won't build.  I fixed this by putting an #ifdef MODULE around the
late_initcall.

> There's a potential solution to this.  If we add a hook to sys_module_init
> such that it'll call a specified function before returning, we can make
> it wait until all scans are done.  This way, userspace never sees the
> asynchronous scanning behaviour.  But if you have devices of different
> types, you won't get the overlapping scans.

How about this solution which works for me with debian on a huge 6 bus
scsi machine:  it introduces a new module scsi_wait_scan.ko whose sole
job is to wait for the scans to complete in its init function.  The
initrd/initramfs sequence now becomes:

insert all other modules
modprobe scsi_wait_scan

James

---

Index: linux-2.6/drivers/scsi/Makefile
===================================================================
--- linux-2.6.orig/drivers/scsi/Makefile	2006-06-24 13:37:50.000000000 -0500
+++ linux-2.6/drivers/scsi/Makefile	2006-06-24 13:38:08.000000000 -0500
@@ -22,6 +22,10 @@
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 
+ifeq ("$(CONFIG_SCSI)", "m")
+	obj-m			+= scsi_wait_scan.o
+endif
+
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
 # --- NOTE ORDERING HERE ---
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h	2006-06-24 13:37:50.000000000 -0500
+++ linux-2.6/drivers/scsi/scsi_priv.h	2006-06-24 13:38:08.000000000 -0500
@@ -49,6 +49,9 @@
 	{ };
 #endif
 
+/* scsi_scan.c */
+int scsi_complete_async_scans(void);
+
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
Index: linux-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_scan.c	2006-06-24 13:37:50.000000000 -0500
+++ linux-2.6/drivers/scsi/scsi_scan.c	2006-06-24 13:38:08.000000000 -0500
@@ -125,7 +125,7 @@
 	struct completion prev_finished;
 };
 
-static int scsi_complete_async_scans(void)
+int scsi_complete_async_scans(void)
 {
 	struct async_scan_data *data;
 
@@ -157,8 +157,10 @@
 	kfree(data);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
+#ifndef MODULE
 late_initcall(scsi_complete_async_scans);
-
+#endif
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
Index: linux-2.6/drivers/scsi/scsi_wait_scan.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/scsi/scsi_wait_scan.c	2006-06-24 13:38:45.000000000 -0500
@@ -0,0 +1,31 @@
+/*
+ * scsi_wait_scan.c
+ *
+ * Copyright (C) 2006 James Bottomley <James.Bottomley@SteelEye.com>
+ *
+ * This is a simple module to wait until all the async scans are
+ * complete.  The idea is to use it in initrd/initramfs scripts.  You
+ * modprobe it after all the modprobes of the root SCSI drivers and it
+ * will wait until they have all finished scanning their busses before
+ * allowing the boot to proceed
+ */
+
+#include <linux/module.h>
+#include "scsi_priv.h"
+
+static int __init wait_scan_init(void)
+{
+	scsi_complete_async_scans();
+	return 0;
+}
+
+static void __exit wait_scan_exit(void)
+{
+}
+
+MODULE_DESCRIPTION("SCSI wait for scans");
+MODULE_AUTHOR("James Bottomley");
+MODULE_LICENSE("GPL");
+
+module_init(wait_scan_init);
+module_exit(wait_scan_exit);



Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
