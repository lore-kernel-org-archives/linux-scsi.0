From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support [1/4]
Date: Mon, 14 Apr 2003 11:39:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414183918.GB4162@beaverton.ibm.com>
References: <20030414183759.GA4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:17286 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263712AbTDNSZp (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 14:25:45 -0400
Content-Disposition: inline
In-Reply-To: <20030414183759.GA4162@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mochel@osdl.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch removes the shost_devclass device class support that was
previously added, but incomplete.
EDESC


 drivers/acorn/scsi/acornscsi.c |    1 -
 drivers/acorn/scsi/arxescsi.c  |    1 -
 drivers/acorn/scsi/cumana_1.c  |    1 -
 drivers/acorn/scsi/cumana_2.c  |    1 -
 drivers/acorn/scsi/eesox.c     |    1 -
 drivers/acorn/scsi/oak.c       |    1 -
 drivers/acorn/scsi/powertec.c  |    1 -
 drivers/scsi/hosts.h           |    1 -
 drivers/scsi/scsi_debug.c      |    1 -
 drivers/scsi/scsi_syms.c       |    4 ----
 drivers/scsi/scsi_sysfs.c      |   25 -------------------------
 11 files changed, 38 deletions(-)

diff -puN drivers/acorn/scsi/acornscsi.c~shost-devclass-clean drivers/acorn/scsi/acornscsi.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/acornscsi.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/acornscsi.c	Mon Apr 14 10:11:07 2003
@@ -3110,7 +3110,6 @@ static struct ecard_driver acornscsi_dri
 	.remove		= __devexit_p(acornscsi_remove),
 	.id_table	= acornscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "acornscsi",
 	},
 };
diff -puN drivers/acorn/scsi/arxescsi.c~shost-devclass-clean drivers/acorn/scsi/arxescsi.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/arxescsi.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/arxescsi.c	Mon Apr 14 10:11:07 2003
@@ -397,7 +397,6 @@ static struct ecard_driver arxescsi_driv
 	.remove		= __devexit_p(arxescsi_remove),
 	.id_table	= arxescsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "arxescsi",
 	},
 };
diff -puN drivers/acorn/scsi/cumana_1.c~shost-devclass-clean drivers/acorn/scsi/cumana_1.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/cumana_1.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/cumana_1.c	Mon Apr 14 10:11:07 2003
@@ -334,7 +334,6 @@ static struct ecard_driver cumanascsi1_d
 	.remove		= __devexit_p(cumanascsi1_remove),
 	.id_table	= cumanascsi1_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "cumanascsi1",
 	},
 };
diff -puN drivers/acorn/scsi/cumana_2.c~shost-devclass-clean drivers/acorn/scsi/cumana_2.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/cumana_2.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/cumana_2.c	Mon Apr 14 10:11:07 2003
@@ -572,7 +572,6 @@ static struct ecard_driver cumanascsi2_d
 	.remove		= __devexit_p(cumanascsi2_remove),
 	.id_table	= cumanascsi2_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "cumanascsi2",
 	},
 };
diff -puN drivers/acorn/scsi/eesox.c~shost-devclass-clean drivers/acorn/scsi/eesox.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/eesox.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/eesox.c	Mon Apr 14 10:11:07 2003
@@ -679,7 +679,6 @@ static struct ecard_driver eesoxscsi_dri
 	.remove		= __devexit_p(eesoxscsi_remove),
 	.id_table	= eesoxscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "eesoxscsi",
 	},
 };
diff -puN drivers/acorn/scsi/oak.c~shost-devclass-clean drivers/acorn/scsi/oak.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/oak.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/oak.c	Mon Apr 14 10:11:07 2003
@@ -192,7 +192,6 @@ static struct ecard_driver oakscsi_drive
 	.remove		= __devexit_p(oakscsi_remove),
 	.id_table	= oakscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "oakscsi",
 	},
 };
diff -puN drivers/acorn/scsi/powertec.c~shost-devclass-clean drivers/acorn/scsi/powertec.c
--- sysfs-bleed-2.5/drivers/acorn/scsi/powertec.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/acorn/scsi/powertec.c	Mon Apr 14 10:11:07 2003
@@ -475,7 +475,6 @@ static struct ecard_driver powertecscsi_
 	.remove		= __devexit_p(powertecscsi_remove),
 	.id_table	= powertecscsi_cids,
 	.drv = {
-		.devclass	= &shost_devclass,
 		.name		= "powertecscsi",
 	},
 };
diff -puN drivers/scsi/hosts.h~shost-devclass-clean drivers/scsi/hosts.h
--- sysfs-bleed-2.5/drivers/scsi/hosts.h~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/hosts.h	Mon Apr 14 10:11:07 2003
@@ -612,7 +612,6 @@ static inline Scsi_Device *scsi_find_dev
 extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
 extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
 
-extern struct device_class shost_devclass;
 
 #endif
 /*
diff -puN drivers/scsi/scsi_debug.c~shost-devclass-clean drivers/scsi/scsi_debug.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_debug.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_debug.c	Mon Apr 14 10:11:07 2003
@@ -183,7 +183,6 @@ static struct device_driver sdebug_drive
 	.name 		= sdebug_proc_name,
 	.probe          = sdebug_driver_probe,
 	.remove         = sdebug_driver_remove,
-	.devclass 	= &shost_devclass,
 };
 
 static const int check_condition_result = 
diff -puN drivers/scsi/scsi_syms.c~shost-devclass-clean drivers/scsi/scsi_syms.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_syms.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_syms.c	Mon Apr 14 10:11:07 2003
@@ -108,7 +108,3 @@ extern int scsi_delete_timer(Scsi_Cmnd *
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
 
-/*
- * sysfs support
- */
-EXPORT_SYMBOL(shost_devclass);
diff -puN drivers/scsi/scsi_sysfs.c~shost-devclass-clean drivers/scsi/scsi_sysfs.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_sysfs.c~shost-devclass-clean	Mon Apr 14 10:11:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_sysfs.c	Mon Apr 14 10:11:07 2003
@@ -52,34 +52,10 @@ static struct device_attribute *const sh
 	&dev_attr_unchecked_isa_dma,
 };
 
-/**
- * scsi_host_class_name_show - copy out the SCSI host name
- * @dev:		device to check
- * @page:		copy data into this area
- * @count:		number of bytes to copy
- * @off:		start at this offset in page
- * Return:
- *     number of bytes written into page.
- **/
-static ssize_t scsi_host_class_name_show(struct device *dev, char *page)
-{
-	struct Scsi_Host *shost;
-
-	shost = to_scsi_host(dev);
-
-	if (!shost)
-		return 0;
-	
-	return snprintf(page, 20, "scsi%d\n", shost->host_no);
-}
-
-DEVICE_ATTR(class_name, S_IRUGO, scsi_host_class_name_show, NULL);
-
 static int scsi_host_class_add_dev(struct device * dev)
 {
 	int i;
 
-	device_create_file(dev, &dev_attr_class_name);
 	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
 		device_create_file(dev, shost_attrs[i]);
 
@@ -92,7 +68,6 @@ static void scsi_host_class_rm_dev(struc
 
 	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
 		device_remove_file(dev, shost_attrs[i]);
-	device_remove_file(dev, &dev_attr_class_name);
 }
 
 struct device_class shost_devclass = {

_
