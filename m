From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs update (base 1/3)
Date: Wed, 6 Nov 2002 23:36:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107073619.GA1390@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gA77YsYO039014
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 02:34:54 -0500
Received: from hmsbounty (sig-9-65-25-153.mts.ibm.com [9.65.25.153])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gA77YqOU253888
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 00:34:53 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against scsi-for-linus-2.5 ChangeSet@1.926.

I have made some changes to scsi sysfs support.

There is still a ways to go on scsi sysfs. The biggest issue is mapping
sg into the device model of one driver per device. I have got the upper
level drivers to use the probe / remove interfaces, but this previous
issue needs to be solved before these can be used. 

Changes:

[base]
	- Tried to concentrate scsi sysfs support functions into one file
	  so that as things are still in flux with sysfs the other scsi
	  files would not be hit as much.
	- Added wrapper functions the reduce init / cleanup issues and
	  mixed object issues (use of container_of with mixed types).
	- Moved init_scsi initcall level to subsys_initcall.
	- Added scsi-host class support. Future ../class/scsi_host/devices
	  should equal scsi_host_list.
	- Removed extra scsi(n) level in tree. Future
	  ../class/scsi_host/devices/(n) children should equal host_queue.

[upper level]
	- Minor changes to Scsi_Device_Template init.
	- Change template registration / deregistration functions.

[scsi_debug]
	These will need to be reviewed by Douglas Gilbert.
	- Create a fake bus and adapter slot for scsi_debug to attach to.
	- Added sysfs probe, remove and devclass interfaces. scsi_debug
	  can now use new scsi_add_host / scsi_remove_host interfaces.

Note: To get successful insmod / rmmod combinations and clean shutdowns
please use the previously posted sysfs core fixups.


-andmike
--
Michael Anderson
andmike@us.ibm.com

 Makefile     |    2 
 hosts.c      |    9 -
 hosts.h      |    9 +
 scsi.c       |   41 +-------
 scsi.h       |    2 
 scsi_scan.c  |   81 ----------------
 scsi_syms.c  |    9 +
 scsi_sysfs.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scsi_sysfs.h |   50 ++++++++++
 9 files changed, 365 insertions(+), 128 deletions(-)
------

diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/Makefile	Wed Nov  6 23:06:51 2002
@@ -124,7 +124,7 @@
 
 scsi_mod-objs	:= scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
 			scsi_proc.o scsi_error.o scsi_lib.o scsi_scan.o \
-			scsi_syms.o
+			scsi_syms.o scsi_sysfs.o
 			
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/hosts.c	Wed Nov  6 23:06:51 2002
@@ -44,6 +44,7 @@
 
 #include "scsi.h"
 #include "hosts.h"
+#include "scsi_sysfs.h"
 
 static LIST_HEAD(scsi_host_hn_list);
 static LIST_HEAD(scsi_host_list);
@@ -196,7 +197,7 @@
 			return 1;
 		}
 		devfs_unregister(sdev->de);
-		device_unregister(&sdev->sdev_driverfs_dev);
+		scsi_bus_device_unregister(sdev);
 	}
 
 	/* Next we free up the Scsi_Cmnd structures for this host */
@@ -223,7 +224,6 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	device_register(&shost->host_driverfs_dev);
 	scan_scsis(shost, 0, 0, 0, 0);
 			
 	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
@@ -278,7 +278,6 @@
 	if (!shost->hostt->present)
 		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
 #endif
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }
@@ -456,10 +455,6 @@
 	scsi_proc_host_add(shost);
 #endif
 
-	strncpy(shost->host_driverfs_dev.name, shost_tp->proc_name,
-		DEVICE_NAME_SIZE-1);
-	sprintf(shost->host_driverfs_dev.bus_id, "scsi%d",
-		shost->host_no);
 
 	shost->eh_notify = &sem;
 	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/hosts.h	Wed Nov  6 23:06:51 2002
@@ -476,9 +476,9 @@
     struct pci_dev *pci_dev;
 
     /* 
-     * Support for driverfs filesystem
+     * Support for device model
      */
-    struct device host_driverfs_dev;
+    struct device *host_driverfs_dev;
 
     /*
      * We should ensure that this is aligned, both for better performance
@@ -534,7 +534,7 @@
                                        struct pci_dev *pdev)
 {
 	shost->pci_dev = pdev;
-	shost->host_driverfs_dev.parent=&pdev->dev;
+	shost->host_driverfs_dev = &pdev->dev;
 }
 
 
@@ -561,6 +561,9 @@
                                            Selects command for blkdevs */
     struct device_driver scsi_driverfs_driver;
 };
+
+#define to_scsi_dev_tp(d) \
+	container_of(d, struct Scsi_Device_Template, scsi_driverfs_driver)
 
 void  scsi_initialize_queue(Scsi_Device *, struct Scsi_Host *);
 
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/scsi.c	Wed Nov  6 23:06:51 2002
@@ -2084,11 +2084,6 @@
 	scsi_devicelist = tpnt;
 	up_write(&scsi_devicelist_mutex);
 
-	tpnt->scsi_driverfs_driver.name = (char *)tpnt->tag;
-	tpnt->scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-
-	driver_register(&tpnt->scsi_driverfs_driver);
-
 	/*
 	 * First scan the devices that we know about, and see if we notice them.
 	 */
@@ -2335,33 +2330,7 @@
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
-        name: "scsi",
-        match: scsi_bus_match,
-};
+extern int scsi_sysfs_register(void);
 
 static int __init init_scsi(void)
 {
@@ -2408,7 +2377,7 @@
 
 	scsi_host_hn_init(scsihosts);
 
-	bus_register(&scsi_driverfs_bus_type);
+	scsi_sysfs_register();
 
 	/* Where we handle work queued by scsi_done */
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
@@ -2416,12 +2385,16 @@
 	return 0;
 }
 
+extern void scsi_sysfs_unregister(void);
+
 static void __exit exit_scsi(void)
 {
 	int i;
 
         devfs_unregister (scsi_devfs_handle);
 
+	scsi_sysfs_unregister();
+
 	scsi_host_hn_release();
 
 #ifdef CONFIG_PROC_FS
@@ -2439,7 +2412,7 @@
 	}
 }
 
-module_init(init_scsi);
+subsys_initcall(init_scsi);
 module_exit(exit_scsi);
 
 /*
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/scsi.h	Wed Nov  6 23:06:51 2002
@@ -414,8 +414,6 @@
 						   * buffers */
 extern volatile int in_scan_scsis;
 
-extern struct bus_type scsi_driverfs_bus_type;
-
 
 /*
  * These are the error handling functions defined in scsi_error.c
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/scsi_scan.c	Wed Nov  6 23:06:51 2002
@@ -33,6 +33,7 @@
 
 #include "scsi.h"
 #include "hosts.h"
+#include "scsi_sysfs.h"
 
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -306,72 +307,6 @@
 		      SCSI_TIMEOUT, 3);
 }
 
-/**
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
 
 /**
  * print_inquiry - printk the inquiry information
@@ -1431,19 +1366,7 @@
 	 */
 	scsi_load_identifier(sdev, sreq);
 
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
+	scsi_bus_device_register(sdev);
 
 	sprintf(devname, "host%d/bus%d/target%d/lun%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Wed Nov  6 23:06:51 2002
+++ b/drivers/scsi/scsi_syms.c	Wed Nov  6 23:06:51 2002
@@ -21,6 +21,7 @@
 #include "scsi.h"
 #include <scsi/scsi_ioctl.h>
 #include "hosts.h"
+#include "scsi_sysfs.h"
 
 #include <scsi/scsicam.h>
 
@@ -107,6 +108,10 @@
 EXPORT_SYMBOL(scsi_delete_timer);
 
 /*
- * driverfs support for determining driver types
+ * Symbols for scsi sysfs support
  */
-EXPORT_SYMBOL(scsi_driverfs_bus_type);
+EXPORT_SYMBOL(scsi_bus_driver_register);
+EXPORT_SYMBOL(scsi_bus_driver_unregister);
+EXPORT_SYMBOL(scsi_host_class_register);
+EXPORT_SYMBOL(scsi_host_class_unregister);
+EXPORT_SYMBOL(shost_devclass);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_sysfs.c	Wed Nov  6 23:06:51 2002
@@ -0,0 +1,290 @@
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
+#include "scsi_sysfs.h"
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
+	shost = scsi_class_data_get(dev);
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
+ * scsi_bus_driver_register - register upper level driver.
+ * @sdev_tp:	Upper level driver to register with the scsi bus.
+ *
+ * Return value:
+ * 	0 on Success / non-zero on Failure
+ **/
+int scsi_bus_driver_register(struct Scsi_Device_Template *sdev_tp)
+{
+	int error = 0;
+
+	error = scsi_register_device(sdev_tp);
+	if (error)
+		return error;
+	sdev_tp->scsi_driverfs_driver.bus = &scsi_bus_type;
+	error = driver_register(&sdev_tp->scsi_driverfs_driver);
+
+	return error;
+}
+
+/**
+ * scsi_bus_driver_unregister - unregister upper level driver 
+ * @sdev_tp:	Upper level driver to unregister with the scsi bus.
+ *
+ **/
+void scsi_bus_driver_unregister(struct Scsi_Device_Template *sdev_tp)
+{
+	driver_unregister(&sdev_tp->scsi_driverfs_driver);
+	scsi_unregister_device(sdev_tp);
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
+ * scsi_bus_device_register - register a scsi device with the scsi bus
+ * @sdev:	scsi_device to register
+ *
+ * Return value:
+ * 	0 on Success / non-zero on Failure
+ **/
+int scsi_bus_device_register(struct scsi_device *sdev)
+{
+	int error = 0;
+
+	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
+		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	sdev->sdev_driverfs_dev.parent = sdev->host->host_driverfs_dev;
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
+ * scsi_bus_device_unregister - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_bus_device_unregister(struct scsi_device *sdev)
+{
+	device_remove_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	device_unregister(&sdev->sdev_driverfs_dev);
+}
+
+/**
+ * scsi_host_class_register - register class scsi host
+ * @dev:	class device to register
+ * @shost:	scsi host associtated with class device
+ *
+ * Return value:
+ **/
+int scsi_host_class_register(struct device *dev, struct Scsi_Host *shost)
+{
+	scsi_class_data_set(dev, shost);
+	scsi_host_dev_set(shost, dev);
+
+	scsi_add_host(shost);
+
+	return 0;
+}
+
+/**
+ * scsi_host_class_unregister - unregister class scsi host.
+ * @dev:	class device to unregister
+ **/
+void scsi_host_class_unregister(struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	shost = scsi_class_data_get(dev);
+
+	scsi_remove_host(shost);
+
+	scsi_class_data_set(dev, NULL);
+
+}
diff -Nru a/drivers/scsi/scsi_sysfs.h b/drivers/scsi/scsi_sysfs.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_sysfs.h	Wed Nov  6 23:06:51 2002
@@ -0,0 +1,50 @@
+/*
+ * scsi_sysfs.h
+ *
+ * SCSI sysfs interface routines.
+ *
+ * Created to pull SCSI mid layer sysfs routines into one file.
+ * October 24, 2002 Mike Anderson (andmike@us.ibm.com)
+ */
+#ifndef _SCSI_SYSFS_H
+#define _SCSI_SYSFS_H
+
+#ifdef __KERNEL__
+
+#include <linux/config.h>
+#include <linux/blk.h>		/* for struct request */
+#include <linux/device.h>	/* for struct device */
+
+#include "scsi.h"
+#include "hosts.h"
+
+extern int scsi_sysfs_register(void);
+extern void scsi_sysfs_unregister(void);
+extern int scsi_bus_driver_register(struct Scsi_Device_Template *);
+extern void scsi_bus_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_bus_device_register(struct scsi_device *);
+extern void scsi_bus_device_unregister(struct scsi_device *);
+extern int scsi_host_class_register(struct device *, struct Scsi_Host *);
+extern void scsi_host_class_unregister(struct device *);
+
+extern struct device_class shost_devclass;
+
+static inline void scsi_host_dev_set(struct Scsi_Host *shost,
+					struct device *dev)
+{
+	shost->host_driverfs_dev = dev;
+}
+
+static inline void scsi_class_data_set(struct device *dev,
+				       struct Scsi_Host *host)
+{
+	dev->class_data = (void *)host;
+};
+
+static inline struct Scsi_Host *scsi_class_data_get(struct device *dev)
+{
+	return (struct Scsi_Host *) dev->class_data;
+};
+
+#endif  /* __KERNEL__ */
+#endif

