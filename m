From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs update (upper 2/3)
Date: Wed, 6 Nov 2002 23:39:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107073943.GB1390@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gA77cHLI031162
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 02:38:17 -0500
Received: from hmsbounty (sig-9-65-25-153.mts.ibm.com [9.65.25.153])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gA77cGOU146944
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 00:38:16 -0700
Content-Disposition: inline
In-Reply-To: <20021107073619.GA1390@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 This patch is against scsi-for-linus-2.5 ChangeSet@1.926.

 [upper level]
 	- Minor changes to Scsi_Device_Template init.
 	- Change template registration / deregistration functions.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 sd.c |   10 ++++++----
 sg.c |   13 ++++++++-----
 sr.c |   10 +++++++---
 st.c |   15 +++++++++------
 4 files changed, 30 insertions(+), 18 deletions(-)
------

diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/sd.c	Wed Nov  6 23:06:51 2002
@@ -53,6 +53,7 @@
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include "scsi_sysfs.h"
 
 /*
  * Remaining dev_t-handling stuff
@@ -105,12 +106,14 @@
 static struct Scsi_Device_Template sd_template = {
 	.module		= THIS_MODULE,
 	.name		= "disk",
-	.tag		= "sd",
 	.scsi_type	= TYPE_DISK,
 	.detect		= sd_detect,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
 	.init_command	= sd_init_command,
+	.scsi_driverfs_driver   = {
+		.name   = "sd",
+	},
 };
 
 static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
@@ -1346,7 +1349,7 @@
 	if (!majors)
 		return -ENODEV;
 
-	rc = scsi_register_device(&sd_template);
+	rc = scsi_bus_driver_register(&sd_template);
 	if (rc)
 		return rc;
 	register_reboot_notifier(&sd_notifier_block);
@@ -1365,10 +1368,9 @@
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
 	unregister_reboot_notifier(&sd_notifier_block);
-	scsi_unregister_device(&sd_template);
+	scsi_bus_driver_unregister(&sd_template);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(SD_MAJOR(i), "sd");
-	driver_unregister(&sd_template.scsi_driverfs_driver);
 }
 
 /*
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/sg.c	Wed Nov  6 23:06:51 2002
@@ -66,6 +66,7 @@
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
+#include "scsi_sysfs.h"
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
@@ -122,11 +123,13 @@
 static struct Scsi_Device_Template sg_template = {
 	.module = THIS_MODULE,
 	.name = "generic",
-	.tag = "sg",
 	.scsi_type = 0xff,
 	.detect = sg_detect,
 	.attach = sg_attach,
-	.detach = sg_detach
+	.detach = sg_detach,
+	.scsi_driverfs_driver = {
+		.name   = "sg",
+	},
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -1479,7 +1482,7 @@
 	sprintf(sdp->sg_driverfs_dev.name, "%sgeneric",
 		scsidp->sdev_driverfs_dev.name);
 	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
-	sdp->sg_driverfs_dev.bus = &scsi_driverfs_bus_type;
+	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;
 
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
@@ -1605,7 +1608,7 @@
 	rc = register_chrdev(SCSI_GENERIC_MAJOR, "sg", &sg_fops);
 	if (rc)
 		return rc;
-	rc = scsi_register_device(&sg_template);
+	rc =  scsi_bus_driver_register(&sg_template);
 	if (rc)
 		return rc;
 #ifdef CONFIG_PROC_FS
@@ -1620,7 +1623,7 @@
 #ifdef CONFIG_PROC_FS
 	sg_proc_cleanup();
 #endif				/* CONFIG_PROC_FS */
-	scsi_unregister_device(&sg_template);
+	scsi_bus_driver_unregister(&sg_template);
 	unregister_chrdev(SCSI_GENERIC_MAJOR, "sg");
 	if (sg_dev_arr != NULL) {
 		vfree((char *) sg_dev_arr);
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/sr.c	Wed Nov  6 23:06:51 2002
@@ -51,6 +51,7 @@
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
+#include "scsi_sysfs.h"
 
 #include "sr.h"
 
@@ -78,7 +79,10 @@
 	.detect		= sr_detect,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
-	.init_command	= sr_init_command
+	.init_command	= sr_init_command,
+	.scsi_driverfs_driver   = {
+		.name	= "sr",
+	},
 };
 
 static int sr_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
@@ -823,12 +827,12 @@
 	rc = register_blkdev(MAJOR_NR, "sr", &sr_bdops);
 	if (rc)
 		return rc;
-	return scsi_register_device(&sr_template);
+	return scsi_bus_driver_register(&sr_template);
 }
 
 static void __exit exit_sr(void)
 {
-	scsi_unregister_device(&sr_template);
+	scsi_bus_driver_unregister(&sr_template);
 	unregister_blkdev(MAJOR_NR, "sr");
 }
 
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/st.c	Wed Nov  6 23:06:51 2002
@@ -61,6 +61,7 @@
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
+#include "scsi_sysfs.h"
 
 #define ST_KILOBYTE 1024
 
@@ -176,11 +177,13 @@
 static struct Scsi_Device_Template st_template = {
 	.module =	THIS_MODULE,
 	.name =		"tape", 
-	.tag =		"st", 
 	.scsi_type =	TYPE_TAPE,
 	.detect =	st_detect, 
 	.attach =	st_attach, 
-	.detach =	st_detach
+	.detach =	st_detach,
+	.scsi_driverfs_driver = {
+		.name	= "st",
+	},
 };
 
 static int st_compression(Scsi_Tape *, int);
@@ -3841,7 +3844,7 @@
 	    sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_r[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_r[mode].driver_data =
 			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5));
 	    device_register(&tpnt->driverfs_dev_r[mode]);
@@ -3860,7 +3863,7 @@
 	    sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_n[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_n[mode].driver_data =
 			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5) + 128);
 	    device_register(&tpnt->driverfs_dev_n[mode]);
@@ -3951,7 +3954,7 @@
 		st_max_sg_segs);
 
 	if (register_chrdev(SCSI_TAPE_MAJOR, "st", &st_fops) >= 0) {
-		if (scsi_register_device(&st_template) == 0)
+		if (scsi_bus_driver_register(&st_template) == 0) 
 			return 0;
 	}
 
@@ -3963,7 +3966,7 @@
 {
 	int i;
 
-	scsi_unregister_device(&st_template);
+	scsi_bus_driver_unregister(&st_template);
 	unregister_chrdev(SCSI_TAPE_MAJOR, "st");
 	if (scsi_tapes != NULL) {
 		for (i=0; i < st_dev_max; ++i)

