From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs cleanups
Date: Tue, 19 Nov 2002 07:30:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119153008.GA1544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAJFSYsr017854
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2002 10:28:35 -0500
Received: from hmsbounty (sig-9-65-59-167.mts.ibm.com [9.65.59.167])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAJFSW4n054428
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2002 08:28:32 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a re-roll of a previous patch for SCSI sysfs cleanups. The
update includes changes from comments on previous patch posted and the
removal of the extra h file (some name change updates where postponed to
avoid clashing with others).

This patch is against  bk://linux-scsi.bkbits.net/scsi-for-linus-2.5

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

[upper level]
	- Minor changes to Scsi_Device_Template init.

[scsi_debug]
	- scsi_debug will not compile with this patch. This patch depends
	  on a previous patch posted to linux-scsi for scsi_debug 1.64
	  or use 1.65
Testing:
	2x with ips, aic, qlogicisp.
	also tested on bk current.

Note: To get successful insmod / rmmod combinations and clean shutdowns
please use the previously posted sysfs core fixups.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 Makefile     |    3 
 hosts.c      |    9 -
 hosts.h      |   31 +++++-
 scsi.c       |   41 +-------
 scsi.h       |   10 +-
 scsi_scan.c  |   81 ----------------
 scsi_syms.c  |    8 +
 scsi_sysfs.c |  289 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 sd.c         |    5 -
 sg.c         |    8 +
 sr.c         |    6 -
 st.c         |   10 +-
 12 files changed, 359 insertions(+), 142 deletions(-)
------

diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/Makefile	Mon Nov 18 23:29:19 2002
@@ -123,7 +123,8 @@
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 
 scsi_mod-objs	:= scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
-		   scsi_error.o scsi_lib.o scsi_scan.o scsi_syms.o
+		   scsi_error.o scsi_lib.o scsi_scan.o scsi_syms.o \
+		   scsi_sysfs.o
 
 ifdef CONFIG_PROC_FS
 scsi_mod-objs	+= scsi_proc.o
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/hosts.c	Mon Nov 18 23:29:19 2002
@@ -280,7 +280,7 @@
 			return 1;
 		}
 		devfs_unregister(sdev->de);
-		device_unregister(&sdev->sdev_driverfs_dev);
+		scsi_device_unregister(sdev);
 	}
 
 	/* Next we free up the Scsi_Cmnd structures for this host */
@@ -307,7 +307,6 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	device_register(&shost->host_driverfs_dev);
 	scan_scsis(shost, 0, 0, 0, 0);
 			
 	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
@@ -348,7 +347,6 @@
 
 	/* Cleanup proc and driverfs */
 	scsi_proc_host_rm(shost);
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }
@@ -462,11 +460,6 @@
 	spin_unlock(&scsi_host_list_lock);
 
 	scsi_proc_host_add(shost);
-
-	strncpy(shost->host_driverfs_dev.name, shost_tp->proc_name,
-		DEVICE_NAME_SIZE-1);
-	sprintf(shost->host_driverfs_dev.bus_id, "scsi%d",
-		shost->host_no);
 
 	shost->eh_notify = &sem;
 	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/hosts.h	Mon Nov 18 23:29:19 2002
@@ -476,7 +476,7 @@
     /* 
      * Support for driverfs filesystem
      */
-    struct device host_driverfs_dev;
+    struct device *host_driverfs_dev;
 
     /*
      * We should ensure that this is aligned, both for better performance
@@ -521,7 +521,7 @@
                                        struct pci_dev *pdev)
 {
 	shost->pci_dev = pdev;
-	shost->host_driverfs_dev.parent=&pdev->dev;
+	shost->host_driverfs_dev = &pdev->dev;
 }
 
 
@@ -534,7 +534,6 @@
 {
     struct list_head list;
     const char * name;
-    const char * tag;
     struct module * module;	  /* Used for loadable modules */
     unsigned char scsi_type;
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
@@ -602,6 +601,32 @@
                         break;
         return sdev;
 }
+
+
+/*
+ * sysfs host class
+ */
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
     
 #endif
 /*
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/scsi.c	Mon Nov 18 23:29:19 2002
@@ -2028,10 +2028,7 @@
 	list_add_tail(&tpnt->list, &scsi_devicelist);
 	up_write(&scsi_devicelist_mutex);
 
-	tpnt->scsi_driverfs_driver.name = (char *)tpnt->tag;
-	tpnt->scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-
-	driver_register(&tpnt->scsi_driverfs_driver);
+	scsi_device_driver_register(tpnt);
 
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) {
@@ -2056,7 +2053,6 @@
 	Scsi_Device *SDpnt;
 	struct Scsi_Host *shpnt;
 	
-	driver_unregister(&tpnt->scsi_driverfs_driver);
 
 	/*
 	 * Next, detach the devices from the driver.
@@ -2077,6 +2073,8 @@
 	list_del(&tpnt->list);
 	up_write(&scsi_devicelist_mutex);
 
+	scsi_device_driver_unregister(tpnt);
+
 	/*
 	 * Final cleanup for the driver is done in the driver sources in the
 	 * cleanup function.
@@ -2175,34 +2173,6 @@
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
-
 static int __init init_scsi(void)
 {
 	int i;
@@ -2227,7 +2197,7 @@
 
 	scsi_host_init();
 	scsi_dev_info_list_init(scsi_dev_flags);
-	bus_register(&scsi_driverfs_bus_type);
+	scsi_sysfs_register();
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
 	return 0;
 }
@@ -2237,6 +2207,7 @@
 	int i;
 
 	devfs_unregister(scsi_devfs_handle);
+	scsi_sysfs_unregister();
 	scsi_exit_procfs();
 	scsi_dev_info_list_delete();
 
@@ -2249,7 +2220,7 @@
 	}
 }
 
-module_init(init_scsi);
+subsys_initcall(init_scsi);
 module_exit(exit_scsi);
 
 /*
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/scsi.h	Mon Nov 18 23:29:19 2002
@@ -411,8 +411,6 @@
 
 extern unsigned int scsi_logging_level;		/* What do we log? */
 
-extern struct bus_type scsi_driverfs_bus_type;
-
 
 /*
  * These are the error handling functions defined in scsi_error.c
@@ -988,5 +986,13 @@
 #define SCSI_SENSE_VALID(scmd) ((scmd->sense_buffer[0] & 0x70) == 0x70)
 
 int scsi_set_medium_removal(Scsi_Device *dev, char state);
+
+extern int scsi_device_driver_register(struct Scsi_Device_Template *);
+extern void scsi_device_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_unregister(struct scsi_device *);
+
+extern int scsi_sysfs_register(void);
+extern void scsi_sysfs_unregister(void);
 
 #endif
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/scsi_scan.c	Mon Nov 18 23:29:19 2002
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
@@ -1373,19 +1306,7 @@
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
+	scsi_device_register(sdev);
 
 	sprintf(devname, "scsi/host%d/bus%d/target%d/lun%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/scsi_syms.c	Mon Nov 18 23:29:19 2002
@@ -104,6 +104,10 @@
 EXPORT_SYMBOL(scsi_delete_timer);
 
 /*
- * driverfs support for determining driver types
+ * sysfs support
  */
-EXPORT_SYMBOL(scsi_driverfs_bus_type);
+EXPORT_SYMBOL(scsi_device_driver_register);
+EXPORT_SYMBOL(scsi_device_driver_unregister);
+EXPORT_SYMBOL(scsi_host_class_register);
+EXPORT_SYMBOL(scsi_host_class_unregister);
+EXPORT_SYMBOL(shost_devclass);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_sysfs.c	Mon Nov 18 23:29:19 2002
@@ -0,0 +1,289 @@
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
+ * scsi_device_driver_register - register upper level driver.
+ * @sdev_tp:	Upper level driver to register with the scsi bus.
+ *
+ * Return value:
+ * 	0 on Success / non-zero on Failure
+ **/
+int scsi_device_driver_register(struct Scsi_Device_Template *sdev_tp)
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
+ * scsi_device_driver_unregister - unregister upper level driver 
+ * @sdev_tp:	Upper level driver to unregister with the scsi bus.
+ *
+ **/
+void scsi_device_driver_unregister(struct Scsi_Device_Template *sdev_tp)
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
+ * scsi_bus_device_register - register a scsi device with the scsi bus
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
+ * scsi_device_unregister - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_device_unregister(struct scsi_device *sdev)
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
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/sd.c	Mon Nov 18 23:29:19 2002
@@ -105,11 +105,13 @@
 	.module		= THIS_MODULE,
 	.list		= LIST_HEAD_INIT(sd_template.list),
 	.name		= "disk",
-	.tag		= "sd",
 	.scsi_type	= TYPE_DISK,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
 	.init_command	= sd_init_command,
+	.scsi_driverfs_driver = {
+		.name   = "sd",
+	},
 };
 
 static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
@@ -1343,7 +1345,6 @@
 	scsi_unregister_device(&sd_template);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(SD_MAJOR(i), "sd");
-	driver_unregister(&sd_template.scsi_driverfs_driver);
 }
 
 /*
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/sg.c	Mon Nov 18 23:29:19 2002
@@ -122,10 +122,12 @@
 	.module = THIS_MODULE,
 	.list = LIST_HEAD_INIT(sg_template.list),
 	.name = "generic",
-	.tag = "sg",
 	.scsi_type = 0xff,
 	.attach = sg_attach,
-	.detach = sg_detach
+	.detach = sg_detach,
+	.scsi_driverfs_driver = {
+		.name = "sg",
+	},
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -1464,7 +1466,7 @@
 	sprintf(sdp->sg_driverfs_dev.name, "%sgeneric",
 		scsidp->sdev_driverfs_dev.name);
 	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
-	sdp->sg_driverfs_dev.bus = &scsi_driverfs_bus_type;
+	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;
 
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/sr.c	Mon Nov 18 23:29:19 2002
@@ -73,11 +73,13 @@
 	.module		= THIS_MODULE,
 	.list		= LIST_HEAD_INIT(sr_template.list),
 	.name		= "cdrom",
-	.tag		= "sr",
 	.scsi_type	= TYPE_ROM,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
-	.init_command	= sr_init_command
+	.init_command	= sr_init_command,
+	.scsi_driverfs_driver = {
+		.name   = "sr",
+	},
 };
 
 static int sr_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Mon Nov 18 23:29:19 2002
+++ b/drivers/scsi/st.c	Mon Nov 18 23:29:19 2002
@@ -176,10 +176,12 @@
 	.module =	THIS_MODULE,
 	.list =		LIST_HEAD_INIT(st_template.list),
 	.name =		"tape", 
-	.tag =		"st", 
 	.scsi_type =	TYPE_TAPE,
 	.attach =	st_attach, 
-	.detach =	st_detach
+	.detach =	st_detach,
+	.scsi_driverfs_driver = {
+		.name = "st",
+	},
 };
 
 static int st_compression(Scsi_Tape *, int);
@@ -3838,7 +3840,7 @@
 	    sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_r[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_r[mode].driver_data =
 			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5));
 	    device_register(&tpnt->driverfs_dev_r[mode]);
@@ -3857,7 +3859,7 @@
 	    sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_n[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_n[mode].driver_data =
 			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5) + 128);
 	    device_register(&tpnt->driverfs_dev_n[mode]);

