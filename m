From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs update (scsi_debug 3/3)
Date: Wed, 6 Nov 2002 23:42:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107074222.GC1390@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gA77gILI018918
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 02:42:18 -0500
Received: from hmsbounty (sig-9-65-25-153.mts.ibm.com [9.65.25.153])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gA77etOU153854
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 00:40:56 -0700
Content-Disposition: inline
In-Reply-To: <20021107073943.GB1390@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against scsi-for-linus-2.5 ChangeSet@1.926.

[scsi_debug]
	These will need to be reviewed by Douglas Gilbert.
	- Create a fake bus and adapter slot for scsi_debug to attach to.
	- Added sysfs probe, remove and devclass interfaces. scsi_debug
	  can now use new scsi_add_host / scsi_remove_host interfaces.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi_debug.c |  292 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 224 insertions(+), 68 deletions(-)
------

diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/scsi_debug.c	Wed Nov  6 23:06:51 2002
@@ -41,6 +41,7 @@
 #include <linux/blk.h>
 #include "scsi.h"
 #include "hosts.h"
+#include "scsi_sysfs.h"
 
 #include <linux/stat.h>
 
@@ -52,7 +53,8 @@
 
 static const char * scsi_debug_version_str = "Version: 1.63 (20021103)";
 
-#define DRIVERFS_SUPPORT 1	/* comment out whole line to disable */
+#define SYSFS_SUPPORT 1 /* comment out whole line to disable */
+#define SYSFS_PROBE 1  /* comment out whole line to disable */
 
 
 #ifndef SCSI_CMD_READ_16
@@ -146,9 +148,7 @@
 static spinlock_t queued_arr_lock = SPIN_LOCK_UNLOCKED;
 static rwlock_t atomic_rw = RW_LOCK_UNLOCKED;
 
-#ifdef DRIVERFS_SUPPORT
-static struct device_driver sdebug_driverfs_driver;
-#endif
+static char sdebug_name[] = "scsi_debug";
 
 /* function declarations */
 static int resp_inquiry(unsigned char * cmd, int target, unsigned char * buff,
@@ -176,11 +176,6 @@
 static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
 static int inquiry_evpd_83(unsigned char * arr, int dev_id_num,
                            const char * dev_id_str, int dev_id_str_len);
-#ifdef DRIVERFS_SUPPORT
-static void do_create_driverfs_files(void);
-static void do_remove_driverfs_files(void);
-#endif
-
 
 static unsigned char * scatg2virt(const struct scatterlist * sclp)
 {
@@ -811,67 +806,73 @@
 
 static int initialized = 0;
 static int num_hosts_present = 0;
-static const char * sdebug_proc_name = "scsi_debug";
 
-static int scsi_debug_detect(struct SHT * tpnt)
+static int scsi_debug_alloc(void)
 {
-	int k, sz;
-	struct Scsi_Host * hpnt;
+	int sz;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: detect\n");
+		printk(KERN_INFO "%s: Entered\n", __FUNCTION__);
 	if (0 == initialized) {
 		++initialized;
 		sz = sizeof(struct sdebug_dev_info) * scsi_debug_num_devs;
 		devInfop = vmalloc(sz);
 		if (NULL == devInfop) {
-			printk(KERN_ERR "scsi_debug_detect: out of "
-			       "memory\n");
+			printk(KERN_ERR "%s: out of "
+			       "memory, 0.5\n", __FUNCTION__);
 			return 0;
 		}
 		memset(devInfop, 0, sz);
 		sz = STORE_SIZE;
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
-			printk(KERN_ERR "scsi_debug_detect: out of memory"
-			       ", 1\n");
+			printk(KERN_ERR "%s: out of memory"
+			       ", 0\n", __FUNCTION__);
 			return 0;
 		}
 		memset(fake_storep, 0, sz);
 		init_all_queued();
-#ifdef DRIVERFS_SUPPORT
-		sdebug_driverfs_driver.name = (char *)sdebug_proc_name;
-		sdebug_driverfs_driver.bus = &scsi_driverfs_bus_type;
-		driver_register(&sdebug_driverfs_driver);
-		do_create_driverfs_files();
-#endif
-		tpnt->proc_name = (char *)sdebug_proc_name;
-		for (num_hosts_present = 0, k = 0; k < NR_HOSTS_PRESENT; k++) {
-			if ((hpnt = scsi_register(tpnt, 0)) == NULL)
-				printk(KERN_ERR "scsi_debug_detect: "
-					"scsi_register failed k=%d\n", k);
-			else {
-				hpnt->max_lun = scsi_debug_max_luns;
-				++num_hosts_present;
-			}
-		}
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: ... built %d host(s)\n",
-			       num_hosts_present);
-		return num_hosts_present;
 	} else {
-		printk(KERN_WARNING "scsi_debug_detect: called again\n");
-		return 0;
+		printk(KERN_WARNING "%s: called again\n", __FUNCTION__);	
 	}
+
+	return 0;
 }
 
+static struct device scsi_dbg_fake_bus_dev;
+
+static int scsi_debug_detect(struct SHT * tpnt)
+{
+	int k;
+	struct Scsi_Host *hpnt;
+
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "%s: Entered\n", __FUNCTION__);
+
+	scsi_debug_alloc();
+
+	for (num_hosts_present = 0, k = 0; k < NR_HOSTS_PRESENT; k++) {
+		if ((hpnt = scsi_register(tpnt, 0)) == NULL)
+				printk(KERN_ERR "%s: "
+					"scsi_register failed k=%d\n",
+					__FUNCTION__, k);
+		else {
+			hpnt->max_lun = scsi_debug_max_luns;
+			++num_hosts_present;
+			scsi_host_dev_set(hpnt, &scsi_dbg_fake_bus_dev);
+		}
+	}
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug: ... built %d host(s)\n",
+			       num_hosts_present);
+
+	return num_hosts_present;
+}
 
 static int num_releases = 0;
 
-static int scsi_debug_release(struct Scsi_Host * hpnt)
+static int scsi_debug_free(int host_no)
 {
-	int host_no = hpnt->host_no;
-
 	if (++num_releases == num_hosts_present) {
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 			printk(KERN_INFO "scsi_debug: [last] release, "
@@ -879,10 +880,6 @@
 		num_releases = 0;
 		initialized = 0;
 		stop_all_queued();
-#ifdef DRIVERFS_SUPPORT
-		do_remove_driverfs_files();
-		driver_unregister(&sdebug_driverfs_driver);
-#endif
 		vfree(fake_storep);
 		vfree(devInfop);
 	}
@@ -891,7 +888,16 @@
 			printk(KERN_INFO "scsi_debug: release, host_no=%u\n",
 			       host_no);
 	}
+	return 0;
+}
+
+static int scsi_debug_release(struct Scsi_Host * hpnt)
+{
+	int host_no = hpnt->host_no;
+
 	scsi_unregister(hpnt);
+	scsi_debug_free(host_no);
+
 	return 0;
 }
 
@@ -1372,7 +1378,112 @@
 	return len;
 }
 
-#ifdef DRIVERFS_SUPPORT
+void scsi_debug_sysfs_register(void);
+void scsi_debug_sysfs_unregister(void);
+
+static int __init scsi_debug_init(void)
+{
+	driver_template.proc_name = (char *)sdebug_name;
+	scsi_debug_sysfs_register();
+	return 0;
+}
+
+static void __exit scsi_debug_exit(void)
+{
+	scsi_debug_sysfs_unregister();
+}
+
+device_initcall(scsi_debug_init);
+module_exit(scsi_debug_exit);
+
+#ifdef SYSFS_SUPPORT
+
+static struct device scsi_dbg_primary_bus = {
+	.name		= "scsi_dbg_fake_root",
+	.bus_id		= "scsi_dbg_fake",
+};
+
+static int scsi_debug_fake_bus_match(struct device *dev, 
+                          struct device_driver *dev_driver)
+{
+        return 1;
+}
+
+static struct bus_type scsi_dbg_fake_bus_type = {
+        name: "scsi_dbg_fake",
+        match: scsi_debug_fake_bus_match,
+};
+
+static struct device scsi_dbg_fake_bus_dev = {
+	.name		= "scsi debug adapater",
+	.bus_id		= "02:05.0",
+	.bus		= &scsi_dbg_fake_bus_type,
+	.parent		= &scsi_dbg_primary_bus,
+};
+
+int scsi_debug_fake_bus_register_driver(struct device_driver *dev_driver)
+{
+	dev_driver->bus = &scsi_dbg_fake_bus_type;
+	driver_register(dev_driver);
+
+	return 0;
+}
+
+int scsi_debug_fake_bus_unregister_driver(struct device_driver *dev_driver)
+{
+	driver_unregister(dev_driver);
+	return 0;
+}
+
+#ifdef SYSFS_PROBE
+static int scsi_debug_probe (struct device *dev)
+{
+	struct Scsi_Host *hpnt;
+
+	hpnt = scsi_register(&driver_template, 0);
+	if (!hpnt) {
+		printk(KERN_ERR "%s: "
+			"scsi_register failed\n", __FUNCTION__);
+		return 1;
+	}
+
+	++num_hosts_present;
+
+	scsi_debug_alloc();
+
+	scsi_host_class_register(dev, hpnt);
+	
+	return 0;
+}
+
+static int scsi_debug_remove (struct device *dev)
+{
+	int host_no;
+	struct Scsi_Host *hpnt;
+
+	hpnt = scsi_class_data_get(dev);
+	host_no = hpnt->host_no;
+
+	scsi_host_class_unregister(dev);
+
+	scsi_debug_free(host_no);
+
+	return 0;
+}
+#else 
+
+static int scsi_debug_probe (struct device *dev)
+{
+	return 0;
+}
+
+static int scsi_debug_remove (struct device *dev)
+{
+	return 0;
+}
+
+#endif
+
 static ssize_t sdebug_delay_read(struct device_driver * ddp, char * buf, 
 				 size_t count, loff_t off)
 {
@@ -1464,27 +1575,72 @@
 }
 DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_read, NULL) 
 
-static void do_create_driverfs_files()
+static struct device_driver sdebug_driver = {
+	.name           = sdebug_name,
+	.probe          = scsi_debug_probe,
+	.remove         = scsi_debug_remove,
+	.devclass       = &shost_devclass,
+};
+
+static void do_create_driverfs_files(void)
 {
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_delay);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_opts);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_devs);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
-}
-
-static void do_remove_driverfs_files()
-{
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_devs);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_opts);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_delay);
+	driver_create_file(&sdebug_driver, &driver_attr_delay);
+	driver_create_file(&sdebug_driver, &driver_attr_opts);
+	driver_create_file(&sdebug_driver, &driver_attr_num_devs);
+	driver_create_file(&sdebug_driver, &driver_attr_dev_size_mb);
+	driver_create_file(&sdebug_driver, &driver_attr_every_nth);
+	driver_create_file(&sdebug_driver, &driver_attr_max_luns);
+	driver_create_file(&sdebug_driver, &driver_attr_scsi_level);
 }
+
+static void do_remove_driverfs_files(void)
+{
+	driver_remove_file(&sdebug_driver, &driver_attr_scsi_level);
+	driver_remove_file(&sdebug_driver, &driver_attr_max_luns);
+	driver_remove_file(&sdebug_driver, &driver_attr_every_nth);
+	driver_remove_file(&sdebug_driver, &driver_attr_dev_size_mb);
+	driver_remove_file(&sdebug_driver, &driver_attr_num_devs);
+	driver_remove_file(&sdebug_driver, &driver_attr_opts);
+	driver_remove_file(&sdebug_driver, &driver_attr_delay);
+}
+
+
+void scsi_debug_sysfs_register(void)
+{
+	device_register(&scsi_dbg_primary_bus);
+	bus_register(&scsi_dbg_fake_bus_type);
+	device_register(&scsi_dbg_fake_bus_dev);
+
+	scsi_debug_fake_bus_register_driver(&sdebug_driver);
+	do_create_driverfs_files();
+#ifndef SYSFS_PROBE
+	scsi_register_host(&driver_template);
 #endif
+}
+
+void scsi_debug_sysfs_unregister(void)
+{
+#ifndef SYSFS_PROBE
+	scsi_unregister_host(&driver_template);
+#endif
+	do_remove_driverfs_files();
+	scsi_debug_fake_bus_unregister_driver(&sdebug_driver);
+
+	device_unregister(&scsi_dbg_fake_bus_dev);
+	bus_unregister(&scsi_dbg_fake_bus_type);
+	device_unregister(&scsi_dbg_primary_bus);
+}
+
+#else
 
-#include "scsi_module.c"
+void scsi_debug_sysfs_register(void)
+{
+	scsi_register_host(&driver_template);
+}
+
+void scsi_debug_sysfs_unregister(void)
+{
+	scsi_unregister_host(&driver_template);
+}
+
+#endif

