From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] add scsi bus for virtual drivers
Date: Fri, 11 Feb 2005 18:25:18 -0800
Message-ID: <420D690E.7060003@cs.wisc.edu>
References: <420D5E3C.3020005@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060802020208000605020309"
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54423 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262245AbVBLCZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 21:25:28 -0500
In-Reply-To: <420D5E3C.3020005@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------060802020208000605020309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

oops, I think my mailer wrapped some lines and I had some
extra formatting. Let me try a again.


Mike Christie wrote:
> Currently, LLDs using the newer driver model APIs use a driver's probe 
> routine to perform setup and call scsi_host_alloc and scsi_add_host. 
> And, then in remove the driver calls scsi_remove_host and scsi_host_put.
> 
> Virtual drivers like scsi_debug and software iscsi do not have a driver 
> model bus or device_driver, so scsi_debug impements its own and software 
> iscsi just adds and removes hosts from where ever makes it happy. A 
> review comment we recieved for the software iscsi driver was to use a 
> bus and driver and the callouts they provide. But instead of having the 
> driver implement its own driver model bus code, the attached patch has 
> scsi-ml maintain a virtual host bus for scsi_debug and software iscsi to 
> use.
> 
> I had tried to just use the existing scsi bus, but it ends up that the 
> host level device would need the bus's semaphore and the hosts' scanned 
> scsi devices would try to grab the bus's semaphore at the same time.
> 
> The attached patch was made against scsi-rc-fixes-2.6.
> I will also send a patch in the next mail to convert
> scsi_debug.
> 
> Mike
> 

--------------060802020208000605020309
Content-Type: text/x-patch;
 name="add-ml-virtual-bus2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-ml-virtual-bus2.patch"

diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/hosts.c scsi-rc-fixes-2.6.work/drivers/scsi/hosts.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/hosts.c	2005-02-04 22:10:09.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/hosts.c	2005-02-11 16:18:20.000000000 -0800
@@ -31,6 +31,7 @@
 #include <linux/transport_class.h>
 
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 
@@ -39,6 +40,7 @@
 
 
 static int scsi_host_next_hn;		/* host_no for next new host */
+static int scsi_host_next_vhn;		/* host_no for next new virtual host */
 
 
 static void scsi_host_cls_release(struct class_device *class_dev)
@@ -51,6 +53,16 @@ static struct class shost_class = {
 	.release	= scsi_host_cls_release,
 };
 
+static int scsi_host_match(struct device *dev, struct device_driver *gendrv)
+{
+	return 1;
+}
+
+static struct bus_type shost_bus_type = {
+        .name		= "scsi_host",
+        .match		= scsi_host_match,
+};
+
 /**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
@@ -379,12 +391,23 @@ EXPORT_SYMBOL(scsi_host_put);
 
 int scsi_init_hosts(void)
 {
-	return class_register(&shost_class);
+	int error;
+
+	error = class_register(&shost_class);
+	if (error)
+		return error;
+
+	error = bus_register(&shost_bus_type);
+	if (error)
+		class_unregister(&shost_class);
+
+	return 0;
 }
 
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	bus_unregister(&shost_bus_type);
 }
 
 int scsi_is_host_device(const struct device *dev)
@@ -392,3 +415,141 @@ int scsi_is_host_device(const struct dev
 	return dev->release == scsi_host_dev_release;
 }
 EXPORT_SYMBOL(scsi_is_host_device);
+
+static void __scsi_host_driver_remove_host(struct scsi_host_driver *sdrv,
+					   struct scsi_virt_host *vhost)
+{
+	spin_lock(&sdrv->devices_lock);
+	list_del(&vhost->list);
+	spin_unlock(&sdrv->devices_lock);
+	device_unregister(&vhost->dev);
+}
+
+static ssize_t scsi_host_driver_remove_host(struct device *dev,
+					    const char *buf, size_t count)
+{
+	struct scsi_host_driver *sdrv = to_scsi_host_driver(dev->driver);
+	struct scsi_virt_host *vhost = to_scsi_virt_host(dev);
+
+	__scsi_host_driver_remove_host(sdrv, vhost);
+	return count;
+}
+static DEVICE_ATTR(remove_host, S_IWUSR, NULL, scsi_host_driver_remove_host);
+
+static void scsi_virt_host_release(struct device *dev)
+{
+	struct scsi_virt_host *vhost;
+
+	vhost = to_scsi_virt_host(dev);
+	kfree(vhost);
+}
+
+static ssize_t scsi_host_driver_add_host(struct device_driver *drv,
+					 const char *buf, size_t count)
+{
+	struct scsi_host_driver *sdrv = to_scsi_host_driver(drv);
+	struct device *dev;
+	struct scsi_virt_host *vhost;
+	int error;
+
+	vhost = kmalloc(sizeof(*vhost), GFP_KERNEL);
+	if (!vhost)
+		return -ENOMEM;
+
+	memset(vhost, 0, sizeof(*vhost));
+	INIT_LIST_HEAD(&vhost->list);
+	spin_lock(&sdrv->devices_lock);
+	list_add_tail(&vhost->list, &sdrv->devices);
+	spin_unlock(&sdrv->devices_lock);
+
+	dev = &vhost->dev;
+	dev->bus = &shost_bus_type;
+	dev->release = scsi_virt_host_release;
+	snprintf(dev->bus_id, BUS_ID_SIZE, "virt_host%d",
+		 scsi_host_next_vhn++);
+	error = device_register(dev);
+	if (error) {
+		kfree(vhost);
+		return error;
+	}
+	/*
+	 * this is not a ciritical file, so we can fail and limp on
+	 */
+	dev_attr_remove_host.attr.owner = sdrv->owner;
+	device_create_file(dev, &dev_attr_remove_host);
+
+	return count;
+}
+static DRIVER_ATTR(add_host, S_IWUSR, NULL, scsi_host_driver_add_host);
+
+static int scsi_host_driver_probe(struct device *dev)
+{
+	struct scsi_host_driver *sdrv;
+
+	sdrv = to_scsi_host_driver(dev->driver);
+	if (!sdrv->probe)
+		return 0;
+	return sdrv->probe(to_scsi_virt_host(dev));
+}
+
+static int scsi_host_driver_remove(struct device *dev)
+{
+	struct scsi_host_driver *sdrv;
+
+	sdrv = to_scsi_host_driver(dev->driver);
+	if (!sdrv->remove)
+		return 0;
+	return sdrv->remove(to_scsi_virt_host(dev));
+}
+
+int scsi_register_host_driver(struct scsi_host_driver *sdrv)
+{
+	int error;
+
+	INIT_LIST_HEAD(&sdrv->devices);
+	spin_lock_init(&sdrv->devices_lock);
+
+	sdrv->gendrv.name = sdrv->name;
+	sdrv->gendrv.owner = sdrv->owner;
+	sdrv->gendrv.probe = scsi_host_driver_probe;
+	sdrv->gendrv.remove = scsi_host_driver_remove;
+	sdrv->gendrv.bus = &shost_bus_type;
+
+	error = driver_register(&sdrv->gendrv);
+	if (error)
+		return error;
+
+	driver_attr_add_host.attr.owner = sdrv->owner;
+	error = driver_create_file(&sdrv->gendrv, &driver_attr_add_host);
+	if (error)
+		goto unregister_drv;
+
+	error = sysfs_create_group(&sdrv->gendrv.kobj, sdrv->attrs);
+	if (error)
+		goto remove_add_file;
+
+	return 0;
+
+ remove_add_file:
+	driver_remove_file(&sdrv->gendrv, &driver_attr_add_host);
+ unregister_drv:
+	driver_unregister(&sdrv->gendrv);
+	return error;
+}
+EXPORT_SYMBOL(scsi_register_host_driver);
+
+void scsi_unregister_host_driver(struct scsi_host_driver *sdrv)
+{
+	struct scsi_virt_host *vhost, *tmp;
+
+	driver_remove_file(&sdrv->gendrv, &driver_attr_add_host);
+	sysfs_remove_group(&sdrv->gendrv.kobj, sdrv->attrs);
+	/*
+	 * this is only called from LLDs module_exit functions
+	 * so we should not need a lock.
+	 */
+	list_for_each_entry_safe(vhost, tmp, &sdrv->devices, list)
+		__scsi_host_driver_remove_host(sdrv, vhost);
+	driver_unregister(&sdrv->gendrv);
+}
+EXPORT_SYMBOL(scsi_unregister_host_driver);
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/osst.c scsi-rc-fixes-2.6.work/drivers/scsi/osst.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/osst.c	2005-02-04 22:10:56.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/osst.c	2005-02-11 16:28:05.000000000 -0800
@@ -170,7 +170,7 @@ static int osst_copy_from_buffer(struct 
 static int osst_probe(struct device *);
 static int osst_remove(struct device *);
 
-struct scsi_driver osst_template = {
+struct scsi_device_driver osst_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name		=  "osst",
@@ -5850,7 +5850,7 @@ static int __init init_osst(void) 
 	validate_options();
 	osst_sysfs_init();
 
-	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_driver(&osst_template.gendrv)) {
+	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_device_driver(&osst_template.gendrv)) {
 		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n", OSST_MAJOR);
 		osst_sysfs_cleanup();
 		return 1;
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_lib.c scsi-rc-fixes-2.6.work/drivers/scsi/scsi_lib.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_lib.c	2005-02-04 22:11:02.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/scsi_lib.c	2005-02-10 20:25:50.000000000 -0800
@@ -966,12 +966,12 @@ static int scsi_issue_flush_fn(request_q
 			       sector_t *error_sector)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct scsi_driver *drv;
+	struct scsi_device_driver *drv;
 
 	if (sdev->sdev_state != SDEV_RUNNING)
 		return -ENXIO;
 
-	drv = *(struct scsi_driver **) disk->private_data;
+	drv = *(struct scsi_device_driver **) disk->private_data;
 	if (drv->issue_flush)
 		return drv->issue_flush(&sdev->sdev_gendev, error_sector);
 
@@ -1073,7 +1073,7 @@ static int scsi_prep_fn(struct request_q
 	 * happening now.
 	 */
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
-		struct scsi_driver *drv;
+		struct scsi_device_driver *drv;
 		int ret;
 
 		/*
@@ -1100,7 +1100,7 @@ static int scsi_prep_fn(struct request_q
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		drv = *(struct scsi_driver **)req->rq_disk->private_data;
+		drv = *(struct scsi_device_driver **)req->rq_disk->private_data;
 		if (unlikely(!drv->init_command(cmd))) {
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_scan.c scsi-rc-fixes-2.6.work/drivers/scsi/scsi_scan.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_scan.c	2005-02-04 22:12:05.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/scsi_scan.c	2005-02-10 20:26:51.000000000 -0800
@@ -1089,12 +1089,12 @@ EXPORT_SYMBOL(__scsi_add_device);
 
 void scsi_rescan_device(struct device *dev)
 {
-	struct scsi_driver *drv;
+	struct scsi_device_driver *drv;
 	
 	if (!dev->driver)
 		return;
 
-	drv = to_scsi_driver(dev->driver);
+	drv = to_scsi_device_driver(dev->driver);
 	if (try_module_get(drv->owner)) {
 		if (drv->rescan)
 			drv->rescan(dev);
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_sysfs.c scsi-rc-fixes-2.6.work/drivers/scsi/scsi_sysfs.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_sysfs.c	2005-02-04 22:10:23.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/scsi_sysfs.c	2005-02-11 18:01:11.000000000 -0800
@@ -653,13 +653,13 @@ out:
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-int scsi_register_driver(struct device_driver *drv)
+int scsi_register_device_driver(struct device_driver *drv)
 {
 	drv->bus = &scsi_bus_type;
 
 	return driver_register(drv);
 }
-EXPORT_SYMBOL(scsi_register_driver);
+EXPORT_SYMBOL(scsi_register_device_driver);
 
 int scsi_register_interface(struct class_interface *intf)
 {
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/sd.c scsi-rc-fixes-2.6.work/drivers/scsi/sd.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/sd.c	2005-02-04 22:11:57.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/sd.c	2005-02-11 16:28:15.000000000 -0800
@@ -92,7 +92,7 @@
 static void scsi_disk_release(struct kref *kref);
 
 struct scsi_disk {
-	struct scsi_driver *driver;	/* always &sd_template */
+	struct scsi_device_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
 	struct kref	kref;
 	struct gendisk	*disk;
@@ -125,7 +125,7 @@ static int sd_issue_flush(struct device 
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
 		 struct scsi_request *SRpnt, unsigned char *buffer);
 
-static struct scsi_driver sd_template = {
+static struct scsi_device_driver sd_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name		= "sd",
@@ -1631,7 +1631,7 @@ static int __init init_sd(void)
 	if (!majors)
 		return -ENODEV;
 
-	return scsi_register_driver(&sd_template.gendrv);
+	return scsi_register_device_driver(&sd_template.gendrv);
 }
 
 /**
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/sr.c scsi-rc-fixes-2.6.work/drivers/scsi/sr.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/sr.c	2005-02-04 22:13:14.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/sr.c	2005-02-11 16:28:25.000000000 -0800
@@ -74,7 +74,7 @@ static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_init_command(struct scsi_cmnd *);
 
-static struct scsi_driver sr_template = {
+static struct scsi_device_driver sr_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name   	= "sr",
@@ -947,7 +947,7 @@ static int __init init_sr(void)
 	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
 	if (rc)
 		return rc;
-	return scsi_register_driver(&sr_template.gendrv);
+	return scsi_register_device_driver(&sr_template.gendrv);
 }
 
 static void __exit exit_sr(void)
diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/st.c scsi-rc-fixes-2.6.work/drivers/scsi/st.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/st.c	2005-02-04 22:11:33.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/st.c	2005-02-11 16:28:32.000000000 -0800
@@ -198,7 +198,7 @@ static void do_create_driverfs_files(voi
 static void do_remove_driverfs_files(void);
 static void do_create_class_files(struct scsi_tape *, int, int);
 
-static struct scsi_driver st_template = {
+static struct scsi_device_driver st_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name		= "st",
@@ -4062,7 +4062,7 @@ static int __init init_st(void)
 
 	if (!register_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				    ST_MAX_TAPE_ENTRIES, "st")) {
-		if (scsi_register_driver(&st_template.gendrv) == 0) {
+		if (scsi_register_device_driver(&st_template.gendrv) == 0) {
 			do_create_driverfs_files();
 			return 0;
 		}
diff -aurp scsi-rc-fixes-2.6.orig/include/scsi/scsi_driver.h scsi-rc-fixes-2.6.work/include/scsi/scsi_driver.h
--- scsi-rc-fixes-2.6.orig/include/scsi/scsi_driver.h	2005-02-04 22:11:49.000000000 -0800
+++ scsi-rc-fixes-2.6.work/include/scsi/scsi_driver.h	2005-02-11 16:26:50.000000000 -0800
@@ -7,7 +7,7 @@ struct module;
 struct scsi_cmnd;
 
 
-struct scsi_driver {
+struct scsi_device_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
 
@@ -15,15 +15,42 @@ struct scsi_driver {
 	void (*rescan)(struct device *);
 	int (*issue_flush)(struct device *, sector_t *);
 };
-#define to_scsi_driver(drv) \
-	container_of((drv), struct scsi_driver, gendrv)
+#define to_scsi_device_driver(drv) \
+	container_of((drv), struct scsi_device_driver, gendrv)
 
-extern int scsi_register_driver(struct device_driver *);
-#define scsi_unregister_driver(drv) \
+extern int scsi_register_device_driver(struct device_driver *);
+#define scsi_unregister_device_driver(drv) \
 	driver_unregister(drv);
 
 extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
 	class_interface_unregister(intf)
 
+struct scsi_virt_host {
+	struct device		dev;
+	struct list_head	list;
+};
+#define to_scsi_virt_host(_dev) \
+	container_of((_dev), struct scsi_virt_host, dev)
+
+struct scsi_host_driver {
+	char			*name;
+	struct module		*owner;
+	struct attribute_group	*attrs;
+
+	int (*probe)(struct scsi_virt_host *);
+	int (*remove)(struct scsi_virt_host *);
+	/*
+	 * internal fields
+	 */
+	struct device_driver	gendrv;
+	struct list_head	devices;
+	spinlock_t		devices_lock;
+};
+#define to_scsi_host_driver(_drv) \
+	container_of((_drv), struct scsi_host_driver, gendrv)
+
+extern int scsi_register_host_driver(struct scsi_host_driver *);
+extern void scsi_unregister_host_driver(struct scsi_host_driver *);
+
 #endif /* _SCSI_SCSI_DRIVER_H */

--------------060802020208000605020309--
