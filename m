From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [1/2]
Date: Thu, 8 May 2003 23:34:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030509063453.GB3259@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:4349 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262303AbTEIGTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 02:19:48 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h496WKkc235310
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 02:32:20 -0400
Received: from hmsbounty (sig-9-65-19-60.mts.ibm.com [9.65.19.60])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h496WJKU122938
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 00:32:19 -0600
Content-Disposition: inline
In-Reply-To: <20030509063321.GA3259@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
scsi_debug cleanups for scsi-misc-2.5
- Remove release function.
- Remove scsi_debug wrapper driver register / unregister functions.
- Douglas's target == this_id fix.
- Remove some old cleanups that where incorrect.
- Move code back into sdebug_driver_remove.
EDESC


 drivers/scsi/scsi_debug.c |   78 ++++++++++++++--------------------------------
 drivers/scsi/scsi_debug.h |    1 
 2 files changed, 25 insertions(+), 54 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi_debug-misc-fix drivers/scsi/scsi_debug.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_debug.c~scsi_debug-misc-fix	Thu May  8 22:46:47 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_debug.c	Thu May  8 22:46:47 2003
@@ -55,7 +55,7 @@
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.70 (20030416)";
+static const char * scsi_debug_version_str = "Version: 1.70 (20030507)";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -169,7 +169,6 @@ static struct sdebug_queued_cmd queued_a
 static Scsi_Host_Template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.name =			"SCSI DEBUG",
-	.release =		scsi_debug_release,
 	.info =			scsi_debug_info,
 	.slave_alloc =		scsi_debug_slave_alloc,
 	.slave_configure =	scsi_debug_slave_configure,
@@ -207,9 +206,11 @@ static char sdebug_proc_name[] = "scsi_d
 
 static int sdebug_driver_probe(struct device *);
 static int sdebug_driver_remove(struct device *);
+static struct bus_type pseudo_lld_bus;
 
 static struct device_driver sdebug_driverfs_driver = {
 	.name 		= sdebug_proc_name,
+	.bus		= &pseudo_lld_bus,
 	.probe          = sdebug_driver_probe,
 	.remove         = sdebug_driver_remove,
 };
@@ -250,8 +251,6 @@ static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
 static struct device pseudo_primary;
 static struct bus_type pseudo_lld_bus;
-static int scsi_debug_register_driver(struct device_driver *);
-static int scsi_debug_unregister_driver(struct device_driver *);
 
 static unsigned char * scatg2virt(const struct scatterlist * sclp)
 {
@@ -296,10 +295,12 @@ int scsi_debug_queuecommand(struct scsi_
 		bufflen = SDEBUG_SENSE_LEN;
 	}
 
+
         if(target == sdebug_driver_template.this_id) {
-                printk(KERN_WARNING 
-		       "scsi_debug: initiator's id used as target!\n");
-		return schedule_resp(SCpnt, NULL, done, 0, 0);
+		printk(KERN_INFO "scsi_debug: initiator's id used as "
+		       "target!\n");
+		return schedule_resp(SCpnt, NULL, done,
+				     DID_NO_CONNECT << 16, 0);
         }
 
 	if (SCpnt->device->lun >= scsi_debug_max_luns)
@@ -1523,7 +1524,7 @@ static int __init scsi_debug_init(void)
 
 	device_register(&pseudo_primary);
 	bus_register(&pseudo_lld_bus);
-	scsi_debug_register_driver(&sdebug_driverfs_driver);
+	driver_register(&sdebug_driverfs_driver);
 	do_create_driverfs_files();
 
 	sdebug_driver_template.proc_name = (char *)sdebug_proc_name;
@@ -1554,7 +1555,7 @@ static void __exit scsi_debug_exit(void)
 	for (; k; k--)
 		sdebug_remove_adapter();
 	do_remove_driverfs_files();
-	scsi_debug_unregister_driver(&sdebug_driverfs_driver);
+	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	device_unregister(&pseudo_primary);
 
@@ -1580,20 +1581,6 @@ static struct bus_type pseudo_lld_bus = 
         .match = pseudo_lld_bus_match,
 };
 
-static int scsi_debug_register_driver(struct device_driver *dev_driver)
-{
-	dev_driver->bus = &pseudo_lld_bus;
-	driver_register(dev_driver);
-
-	return 0;
-}
-
-static int scsi_debug_unregister_driver(struct device_driver *dev_driver)
-{
-	driver_unregister(dev_driver);
-	return 0;
-}
-
 static void sdebug_release_adapter(struct device * dev)
 {
         struct sdebug_host_info *sdbg_host;
@@ -1698,7 +1685,7 @@ static int sdebug_driver_probe(struct de
         if (NULL == hpnt) {
                 printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
                 error = -ENODEV;
-                goto clean1;
+		return error;
         }
 
         sdbg_host->shost = hpnt;
@@ -1713,34 +1700,34 @@ static int sdebug_driver_probe(struct de
         if (error) {
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
                 error = -ENODEV;
-                goto clean2;
+		scsi_unregister(hpnt);
         }
 
 
-        return 0;
-
-clean2:
-        scsi_unregister(hpnt);
-clean1:
-        kfree(sdbg_host);
-
         return error;
 }
 
-static int scsi_debug_release(struct Scsi_Host * shost)
+static int sdebug_driver_remove(struct device * dev)
 {
         struct list_head *lh, *lh_sf;
-        struct sdebug_dev_info *sdbg_devinfo;
         struct sdebug_host_info *sdbg_host;
+        struct sdebug_dev_info *sdbg_devinfo;
 
-	sdbg_host = *(struct sdebug_host_info **)shost->hostdata;
-        scsi_unregister(shost);
+	sdbg_host = to_sdebug_host(dev);
 
 	if (!sdbg_host) {
-		printk(KERN_ERR "Unable to locate host info\n");
-		return 0;
+		printk(KERN_ERR "%s: Unable to locate host info\n",
+		       __FUNCTION__);
+		return -ENODEV;
 	}
 
+        if (scsi_remove_host(sdbg_host->shost)) {
+                printk(KERN_ERR "%s: scsi_remove_host failed\n", __FUNCTION__);
+                return -EBUSY;
+        }
+
+        scsi_unregister(sdbg_host->shost);
+
         list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
                 sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
                                           dev_list);
@@ -1749,19 +1736,4 @@ static int scsi_debug_release(struct Scs
         }
 
         return 0;
-
-}
-
-static int sdebug_driver_remove(struct device * dev)
-{
-        struct sdebug_host_info *sdbg_host;
-
-	sdbg_host = to_sdebug_host(dev);
-
-        if (sdbg_host && scsi_remove_host(sdbg_host->shost)) {
-                printk(KERN_ERR "%s: scsi_remove_host failed\n", __FUNCTION__);
-                return -EBUSY;
-        }
-
-        return 0;
 }
diff -puN drivers/scsi/scsi_debug.h~scsi_debug-misc-fix drivers/scsi/scsi_debug.h
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_debug.h~scsi_debug-misc-fix	Thu May  8 22:46:47 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_debug.h	Thu May  8 22:46:47 2003
@@ -16,7 +16,6 @@ static int scsi_debug_device_reset(struc
 static int scsi_debug_host_reset(struct scsi_cmnd *);
 static int scsi_debug_proc_info(char *, char **, off_t, int, int, int);
 static const char * scsi_debug_info(struct Scsi_Host *);
-static int scsi_debug_release(struct Scsi_Host *);
 
 /*
  * This driver is written for the lk 2.5 series

_
