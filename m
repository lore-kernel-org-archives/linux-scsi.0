From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs (base 1/3)
Date: Tue, 26 Nov 2002 00:10:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021126081047.GA3280@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAQ89GLV075088
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 03:09:16 -0500
Received: from hmsbounty (sig-9-65-8-42.mts.ibm.com [9.65.8.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAQ89EUC068222
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 01:09:14 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is re-roll 3 of previous patch for SCSI sysfs cleanups. It includes
updates from previous email comments.

This patch is against  bk://linux-scsi.bkbits.net/scsi-misc-2.5

Changes:
[base]
	- Concentrate scsi sysfs support functions into one file
	- Added wrapper functions the reduce init / cleanup issues and
	  mixed object issues (use of container_of with mixed types).
	- Moved init_scsi initcall level to subsys_initcall.
	- Added scsi-host class support. Future ../class/scsi_host/devices
	  should equal scsi_host_list.
	- Removed extra scsi(n) level in tree. Future
	  ../class/scsi_host/devices/(n) children should equal host_queue.
	- Changed call to scsi_add_host in scsi_debug to new format.
	- Added support for scsi-host class.

[upper level]
	- Minor changes to Scsi_Device_Template init.

[arm scsi]
	- Added support for newer scsi_add_host.
	- Needs compile check on arm.

Testing:
	2x with ips, aic, qlogicisp, scsi_debug.
	insmod / rmmod with shutdown.


-andmike
--
Michael Anderson
andmike@us.ibm.com

 Makefile     |    3 
 hosts.c      |   29 ++++--
 hosts.h      |   19 +++-
 scsi.c       |   42 +--------
 scsi.h       |    9 +-
 scsi_debug.c |    3 
 scsi_scan.c  |   85 -------------------
 scsi_syms.c  |    4 
 scsi_sysfs.c |  259 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 313 insertions(+), 140 deletions(-)
------

diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Mon Nov 25 14:51:53 2002
+++ b/drivers/scsi/Makefile	Mon Nov 25 14:51:53 2002
@@ -123,7 +123,8 @@
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 
 scsi_mod-objs	:= scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
-		   scsi_error.o scsi_lib.o scsi_scan.o scsi_syms.o
+		   scsi_error.o scsi_lib.o scsi_scan.o scsi_syms.o \
+		   scsi_sysfs.o
 
 ifdef CONFIG_PROC_FS
 scsi_mod-objs	+= scsi_proc.o
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/hosts.c	Mon Nov 25 14:51:52 2002
@@ -288,7 +288,7 @@
 	return 0;
 }
 
-int scsi_add_host(struct Scsi_Host *shost)
+int __scsi_add_host(struct Scsi_Host *shost)
 {
 	Scsi_Host_Template *sht = shost->hostt;
 	struct scsi_device *sdev;
@@ -297,7 +297,6 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	device_register(&shost->host_driverfs_dev);
 	scsi_scan_host(shost);
 			
 	list_for_each_entry (sdev, &shost->my_devices, siblings) {
@@ -310,6 +309,22 @@
 }
 
 /**
+ * scsi_add_host - add a scsi host
+ * @shost:	scsi host pointer to add
+ * @dev:	a struct device of type scsi class
+ *
+ * Return value: 
+ * 	0 on success / != 0 for error
+ **/
+int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
+{
+	dev->class_data = shost;
+	shost->host_gendev = dev;
+
+	return __scsi_add_host(shost);
+}
+
+/**
  * scsi_unregister - unregister a scsi host
  * @shost:	scsi host to be unregistered
  **/
@@ -333,9 +348,8 @@
 
 	shost->hostt->present--;
 
-	/* Cleanup proc and driverfs */
+	/* Cleanup proc */
 	scsi_proc_host_rm(shost);
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }
@@ -448,11 +462,6 @@
 
 	scsi_proc_host_add(shost);
 
-	strncpy(shost->host_driverfs_dev.name, shost_tp->proc_name,
-		DEVICE_NAME_SIZE-1);
-	sprintf(shost->host_driverfs_dev.bus_id, "scsi%d",
-		shost->host_no);
-
 	shost->eh_notify = &sem;
 	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);
 	/*
@@ -509,7 +518,7 @@
 	 */
 	list_for_each_entry(shost, &scsi_host_list, sh_list)
 		if (shost->hostt == shost_tp)
-			if (scsi_add_host(shost))
+			if (__scsi_add_host(shost))
 				goto out_of_space;
 
 	return 0;
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/hosts.h	Mon Nov 25 14:51:52 2002
@@ -488,7 +488,7 @@
     /* 
      * Support for driverfs filesystem
      */
-    struct device host_driverfs_dev;
+    struct device *host_gendev;
 
     /*
      * We should ensure that this is aligned, both for better performance
@@ -499,6 +499,8 @@
         __attribute__ ((aligned (sizeof(unsigned long))));
 };
 
+#define	to_scsi_host(d)	d->class_data
+	
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
@@ -524,7 +526,7 @@
                                        struct pci_dev *pdev)
 {
 	shost->pci_dev = pdev;
-	shost->host_driverfs_dev.parent=&pdev->dev;
+	shost->host_gendev = &pdev->dev;
 }
 
 
@@ -539,7 +541,6 @@
 {
     struct list_head list;
     const char * name;
-    const char * tag;
     struct module * module;	  /* Used for loadable modules */
     unsigned char scsi_type;
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
@@ -567,7 +568,7 @@
 /*
  * HBA registration/unregistration.
  */
-extern int scsi_add_host(struct Scsi_Host *);
+extern int scsi_add_host(struct Scsi_Host *, struct device *);
 extern int scsi_remove_host(struct Scsi_Host *);
 
 /*
@@ -605,7 +606,15 @@
                         break;
         return sdev;
 }
-    
+
+/*
+ * sysfs support
+ */
+extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
+extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+
+extern struct device_class shost_devclass;
+
 #endif
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/scsi.c	Mon Nov 25 14:51:52 2002
@@ -2001,10 +2001,7 @@
 	list_add_tail(&tpnt->list, &scsi_devicelist);
 	up_write(&scsi_devicelist_mutex);
 
-	tpnt->scsi_driverfs_driver.name = (char *)tpnt->tag;
-	tpnt->scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-
-	driver_register(&tpnt->scsi_driverfs_driver);
+	scsi_upper_driver_register(tpnt);
 
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) 
@@ -2019,7 +2016,6 @@
 	Scsi_Device *SDpnt;
 	struct Scsi_Host *shpnt;
 	
-	driver_unregister(&tpnt->scsi_driverfs_driver);
 
 	/*
 	 * Next, detach the devices from the driver.
@@ -2037,6 +2033,8 @@
 	list_del(&tpnt->list);
 	up_write(&scsi_devicelist_mutex);
 
+	scsi_upper_driver_unregister(tpnt);
+
 	/*
 	 * Final cleanup for the driver is done in the driver sources in the
 	 * cleanup function.
@@ -2135,34 +2133,6 @@
 	mempool_free(sgl, sgp->pool);
 }
 
-static int scsi_bus_match(struct device *scsi_driverfs_dev, 
-                          struct device_driver *scsi_driverfs_drv)
-{
-        char *p=0;
-
-        if (!strcmp("sd", scsi_driverfs_drv->name)) {
-                if ((p = strstr(scsi_driverfs_dev->bus_id, ":disc")) || 
-		    (p = strstr(scsi_driverfs_dev->bus_id, ":p"))) { 
-                        return 1;
-                }
-        } else if (!strcmp("sg", scsi_driverfs_drv->name)) {
-                if (strstr(scsi_driverfs_dev->bus_id, ":gen"))
-                        return 1;
-        } else if (!strcmp("sr",scsi_driverfs_drv->name)) {
-                if (strstr(scsi_driverfs_dev->bus_id,":cd"))
-                        return 1;
-        } else if (!strcmp("st",scsi_driverfs_drv->name)) {
-                if (strstr(scsi_driverfs_dev->bus_id,":mt"))
-                        return 1;
-        }
-        return 0;
-}
-
-struct bus_type scsi_driverfs_bus_type = {
-        .name	= "scsi",
-        .match	= scsi_bus_match,
-};
-
 static int __init init_scsi(void)
 {
 	int i;
@@ -2189,7 +2159,7 @@
 	scsi_devfs_handle = devfs_mk_dir(NULL, "scsi", NULL);
 	scsi_host_init();
 	scsi_dev_info_list_init(scsi_dev_flags);
-	bus_register(&scsi_driverfs_bus_type);
+	scsi_sysfs_register();
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
 	return 0;
 }
@@ -2198,7 +2168,7 @@
 {
 	int i;
 
-	bus_unregister(&scsi_driverfs_bus_type);
+	scsi_sysfs_unregister();
 	scsi_dev_info_list_delete();
 	devfs_unregister(scsi_devfs_handle);
 	scsi_exit_procfs();
@@ -2212,5 +2182,5 @@
 	}
 }
 
-module_init(init_scsi);
+subsys_initcall(init_scsi);
 module_exit(exit_scsi);
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/scsi.h	Mon Nov 25 14:51:52 2002
@@ -401,9 +401,6 @@
 
 extern unsigned int scsi_logging_level;		/* What do we log? */
 
-extern struct bus_type scsi_driverfs_bus_type;
-
-
 /*
  * These are the error handling functions defined in scsi_error.c
  */
@@ -986,5 +983,11 @@
 #define SCSI_SENSE_VALID(scmd) ((scmd->sense_buffer[0] & 0x70) == 0x70)
 
 int scsi_set_medium_removal(Scsi_Device *dev, char state);
+
+extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_unregister(struct scsi_device *);
+
+extern int scsi_sysfs_register(void);
+extern void scsi_sysfs_unregister(void);
 
 #endif
diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/scsi_debug.c	Mon Nov 25 14:51:52 2002
@@ -155,6 +155,7 @@
 static char sdebug_proc_name[] = "scsi_debug";
 static struct device_driver sdebug_driverfs_driver = {
 	.name = sdebug_proc_name,
+	.devclass = &shost_devclass,
 };
 
 /* function declarations */
@@ -1501,7 +1502,7 @@
 		printk(KERN_ERR "sdebug_add_shost: scsi_register failed\n");
 		return;
 	}
-	err = scsi_add_host(hpnt);
+	err = scsi_add_host(hpnt, scsi_debug_hosts[num].dev);
 	if (err) {
 		printk(KERN_ERR "sdebug_add_shost: scsi_add_host failed\n");
 		scsi_unregister(hpnt);
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Nov 25 14:51:53 2002
+++ b/drivers/scsi/scsi_scan.c	Mon Nov 25 14:51:53 2002
@@ -306,73 +306,6 @@
 }
 
 /**
- * scsi_device_type_read - copy out the SCSI type
- * @driverfs_dev:	driverfs device to check
- * @page:		copy data into this area
- * @count:		number of bytes to copy
- * @off:		start at this offset in page
- *
- * Description:
- *     Called via driverfs when the "type" (in scsi_device_type_file)
- *     field is read. Copy the appropriate SCSI type string into @page,
- *     followed by a newline and a '\0'. Go through gyrations so we don't
- *     write more than @count, and we don't write past @off.
- *
- * Notes:
- *     This is for the top-most scsi entry in driverfs, the upper-level
- *     drivers have their own type file. XXX This is not part of scanning,
- *     other than we reference the attr struct in this file, move to
- *     scsi.c or scsi_lib.c.
- *
- * Return:
- *     number of bytes written into page.
- **/
-static ssize_t scsi_device_type_read(struct device *driverfs_dev, char *page,
-	size_t count, loff_t off)
-{
-	struct scsi_device *sdev = to_scsi_device(driverfs_dev);
-	const char *type;
-	size_t size, len;
-
-	if ((sdev->type > MAX_SCSI_DEVICE_CODE) ||
-	    (scsi_device_types[(int)sdev->type] == NULL))
-		type = "Unknown";
-	else
-		type = scsi_device_types[(int)sdev->type];
-	size = strlen(type);
-	/*
-	 * Check if off is past size + 1 for newline + 1 for a '\0'.
-	 */
-	if (off >= (size + 2))
-		return 0;
-	if (size > off) {
-		len = min((size_t) (size - off), count);
-		memcpy(page + off, type + off, len);
-	} else
-		len = 0;
-	if (((len + off) == size) && (len < count))
-		/*
-		 * We are at the end of the string and have space, add a
-		 * new line.
-		 */
-		*(page + off + len++) = '\n';
-	if (((len + off) == (size + 1)) && (len < count))
-		/*
-		 * We are past the newline and have space, add a
-		 * terminating '\0'.
-		 */
-		*(page + off + len++) = '\0';
-	return len;
-}
-
-/*
- * Create dev_attr_type. This is different from the dev_attr_type in scsi
- * upper level drivers.
- */
-static DEVICE_ATTR(type,S_IRUGO,scsi_device_type_read,NULL);
-
-
-/**
  * print_inquiry - printk the inquiry information
  * @inq_result:	printk this SCSI INQUIRY
  *
@@ -1358,20 +1291,8 @@
 	 * function.
 	 */
 	scsi_load_identifier(sdev, sreq);
-
-	/*
-	 * create driverfs files
-	 */
-	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_driverfs_dev.parent = &sdev->host->host_driverfs_dev;
-	sdev->sdev_driverfs_dev.bus = &scsi_driverfs_bus_type;
-	device_register(&sdev->sdev_driverfs_dev);
-
-	/*
-	 * Create driverfs file entries
-	 */
-	device_create_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	
+	scsi_device_register(sdev);
 
 	sprintf(devname, "scsi/host%d/bus%d/target%d/lun%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
@@ -1415,7 +1336,7 @@
 static int scsi_remove_lun(struct scsi_device *sdev)
 {
 	devfs_unregister(sdev->de);
-	device_unregister(&sdev->sdev_driverfs_dev);
+	scsi_device_unregister(sdev);
 
 	scsi_free_sdev(sdev);
 }
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/scsi_syms.c	Mon Nov 25 14:51:52 2002
@@ -104,6 +104,6 @@
 EXPORT_SYMBOL(scsi_delete_timer);
 
 /*
- * driverfs support for determining driver types
+ * sysfs support
  */
-EXPORT_SYMBOL(scsi_driverfs_bus_type);
+EXPORT_SYMBOL(shost_devclass);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_sysfs.c	Mon Nov 25 14:51:53 2002
@@ -0,0 +1,259 @@
+/*
+ * scsi_sysfs.c
+ *
+ * SCSI sysfs interface routines.
+ *
+ * Created to pull SCSI mid layer sysfs routines into one file.
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include "scsi.h"
+#include "hosts.h"
+
+/**
+ * scsi_host_class_name_show - copy out the SCSI host name
+ * @dev:		device to check
+ * @page:		copy data into this area
+ * @count:		number of bytes to copy
+ * @off:		start at this offset in page
+ * Return:
+ *     number of bytes written into page.
+ **/
+static ssize_t scsi_host_class_name_show(struct device *dev, char *page,
+	size_t count, loff_t off)
+{
+	struct Scsi_Host *shost;
+
+	if (off)
+		return 0;
+
+	shost = to_scsi_host(dev);
+
+	if (!shost)
+		return 0;
+	
+	return snprintf(page, count, "scsi%d\n", shost->host_no);
+}
+
+DEVICE_ATTR(class_name, S_IRUGO, scsi_host_class_name_show, NULL);
+
+static int scsi_host_class_add_dev(struct device * dev)
+{
+	device_create_file(dev, &dev_attr_class_name);
+	return 0;
+}
+
+static void scsi_host_class_rm_dev(struct device * dev)
+{
+	device_remove_file(dev, &dev_attr_class_name);
+}
+
+struct device_class shost_devclass = {
+	.name		= "scsi-host",
+	.add_device	= scsi_host_class_add_dev,
+	.remove_device	= scsi_host_class_rm_dev,
+};
+
+/**
+ * scsi_bus_match:
+ * @dev:
+ * @dev_driver:
+ *
+ * Return value:
+ **/
+static int scsi_bus_match(struct device *dev, 
+                          struct device_driver *dev_driver)
+{
+        if (!strcmp("sg", dev_driver->name)) {
+                if (strstr(dev->bus_id, ":gen"))
+                        return 1;
+        } else if (!strcmp("st",dev_driver->name)) {
+                if (strstr(dev->bus_id,":mt"))
+                        return 1;
+        } else if (!strcmp("sd", dev_driver->name)) {
+                if ((!strstr(dev->bus_id, ":gen")) && 
+		    (!strstr(dev->bus_id, ":mt"))) { 
+                        return 1;
+                }
+	}
+        return 0;
+}
+
+#ifdef  CONFIG_HOTPLUG
+
+/**
+ * scsi_bus_hotplug:
+ * @dev:
+ * @envp:
+ * @num_envp:
+ * @buffer:
+ * @buffer_size:
+ *
+ * Return value:
+ **/
+static int scsi_bus_hotplug (struct device *dev, char **envp,
+				int num_envp, char *buffer, int buffer_size)
+{
+	struct scsi_device *sdev;
+	char *scratch;
+	int i = 0;
+	int length = 0;
+
+	if (!dev)
+		return -ENODEV;
+	
+	if (strstr(dev->bus_id, ":gen")) /*Hack for sg devices*/
+		return -ENODEV;
+
+	sdev = to_scsi_device(dev);
+
+	scratch = buffer;
+
+	envp [i++] = scratch;
+	length += snprintf (scratch, buffer_size - length, "PRODUCT=%s/%s/%s",
+			    sdev->vendor,
+			    sdev->model,
+			    sdev->rev);
+	if ((buffer_size - length <= 0) || (i >= num_envp))
+		return -ENOMEM;
+	++length;
+	scratch += length;
+	
+	envp [i++] = 0;
+
+	return 0;
+}
+
+#else
+
+static int scsi_bus_hotplug (struct device *dev, char **envp,
+				int num_envp, char *buffer, int buffer_size)
+{
+	return -ENODEV;
+}
+
+#endif  /* CONFIG_HOTPLUG */
+
+static struct bus_type scsi_bus_type = {
+        .name		= "scsi",
+        .match		= scsi_bus_match,
+	.hotplug	= scsi_bus_hotplug,
+};
+
+
+int scsi_sysfs_register(void)
+{
+	bus_register(&scsi_bus_type);
+	devclass_register(&shost_devclass);
+
+	return 0;
+}
+
+void scsi_sysfs_unregister(void)
+{
+	devclass_unregister(&shost_devclass);
+	bus_unregister(&scsi_bus_type);
+}
+
+/**
+ * scsi_upper_driver_register - register upper level driver.
+ * @sdev_tp:	Upper level driver to register with the scsi bus.
+ *
+ * Return value:
+ * 	0 on Success / non-zero on Failure
+ **/
+int scsi_upper_driver_register(struct Scsi_Device_Template *sdev_tp)
+{
+	int error = 0;
+
+	sdev_tp->scsi_driverfs_driver.bus = &scsi_bus_type;
+	error = driver_register(&sdev_tp->scsi_driverfs_driver);
+
+	return error;
+}
+
+/**
+ * scsi_upper_driver_unregister - unregister upper level driver 
+ * @sdev_tp:	Upper level driver to unregister with the scsi bus.
+ *
+ **/
+void scsi_upper_driver_unregister(struct Scsi_Device_Template *sdev_tp)
+{
+	driver_unregister(&sdev_tp->scsi_driverfs_driver);
+}
+
+
+/**
+ * scsi_device_type_read - copy out the SCSI type
+ * @dev:		device to check
+ * @page:		copy data into this area
+ * @count:		number of bytes to copy
+ * @off:		start at this offset in page
+ *
+ * Return:
+ *     number of bytes written into page.
+ **/
+static ssize_t scsi_device_type_read(struct device *dev, char *page,
+	size_t count, loff_t off)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *type;
+
+	if (off)
+		return 0;
+
+	if ((sdev->type > MAX_SCSI_DEVICE_CODE) ||
+	    (scsi_device_types[(int)sdev->type] == NULL))
+		type = "Unknown";
+	else
+		type = scsi_device_types[(int)sdev->type];
+
+	return snprintf(page, count, "%s\n", type);
+}
+
+/*
+ * Create dev_attr_type. This is different from the dev_attr_type in scsi
+ * upper level drivers.
+ */
+static DEVICE_ATTR(type,S_IRUGO,scsi_device_type_read,NULL);
+
+/**
+ * scsi_device_register - register a scsi device with the scsi bus
+ * @sdev:	scsi_device to register
+ *
+ * Return value:
+ * 	0 on Success / non-zero on Failure
+ **/
+int scsi_device_register(struct scsi_device *sdev)
+{
+	int error = 0;
+
+	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
+		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	sdev->sdev_driverfs_dev.parent = sdev->host->host_gendev;
+	sdev->sdev_driverfs_dev.bus = &scsi_bus_type;
+
+	error = device_register(&sdev->sdev_driverfs_dev);
+	if (error)
+		return error;
+
+	error = device_create_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	if (error)
+		device_unregister(&sdev->sdev_driverfs_dev);
+
+	return error;
+}
+
+/**
+ * scsi_device_unregister - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_device_unregister(struct scsi_device *sdev)
+{
+	device_remove_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	device_unregister(&sdev->sdev_driverfs_dev);
+}
