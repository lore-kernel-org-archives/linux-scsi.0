From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH] declare and export scsi_bus_type
Date: Wed, 11 Dec 2002 19:46:22 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212111943110.13262-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mochel@osdl.org

Below please find a patch, written by Pat Mochel, to declare and export
scsi_bus_type.  My EDD code requires this to be exported in order to walk
the list of SCSI devices to match what BIOS discovered.

Please apply.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

===== drivers/scsi/scsi.h 1.50 vs edited =====
--- 1.50/drivers/scsi/scsi.h	Thu Nov 28 08:09:53 2002
+++ edited/drivers/scsi/scsi.h	Thu Dec  5 19:05:27 2002
@@ -994,4 +994,6 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 
+extern struct bus_type scsi_bus_type;
+
 #endif
===== drivers/scsi/scsi_sysfs.c 1.1 vs edited =====
--- 1.1/drivers/scsi/scsi_sysfs.c	Thu Nov 28 12:54:06 2002
+++ edited/drivers/scsi/scsi_sysfs.c	Thu Dec  5 19:06:55 2002
@@ -84,7 +84,7 @@
 }
 
 
-static struct bus_type scsi_bus_type = {
+struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 };
@@ -202,3 +202,5 @@
 	device_remove_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
+
+EXPORT_SYMBOL(scsi_bus_type);


