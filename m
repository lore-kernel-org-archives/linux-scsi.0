From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] driver model for scsi upper drivers, take 2
Date: Tue, 27 May 2003 09:32:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527073218.GA11467@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:26541 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262457AbTE0HTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 03:19:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - removed the tape sysfs pseudodevice crap that caused hangs
 - switched sg to a class_interface.  This means sg can be used
   on devices already claimed be an upper driver again.  This
   also means I had to remove the sg sysfs attributes temporarily
   because the old mechanism is gone, but I'll restore them
   differently in a followon patch.


--- 1.64/drivers/scsi/hosts.c	Tue May 13 00:50:42 2003
+++ edited/drivers/scsi/hosts.c	Fri May 16 17:34:35 2003
@@ -229,27 +229,18 @@
 int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 {
 	Scsi_Host_Template *sht = shost->hostt;
-	struct scsi_device *sdev;
-	int error = 0, saved_error = 0;
+	int error;
 
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
 	error = scsi_sysfs_add_host(shost, dev);
-	if (error)
-		return error;
-
-	scsi_proc_host_add(shost);
-
-	scsi_scan_host(shost);
+	if (!error) {
+		scsi_proc_host_add(shost);
+		scsi_scan_host(shost);
+	};
 			
-	list_for_each_entry (sdev, &shost->my_devices, siblings) {
-		error = scsi_attach_device(sdev);
-		if (error)
-			saved_error = error;
-	}
-
-	return saved_error;
+	return error;
 }
 
 /**
===== drivers/scsi/hosts.h 1.63 vs edited =====
--- 1.63/drivers/scsi/hosts.h	Thu May  8 20:24:14 2003
+++ edited/drivers/scsi/hosts.h	Fri May 16 17:34:35 2003
@@ -532,25 +532,18 @@
         return shost->host_gendev.parent;
 }
 
-struct Scsi_Device_Template
-{
-    struct list_head list;
-    const char * name;
-    struct module * module;	  /* Used for loadable modules */
-    unsigned char scsi_type;
-    int (*attach)(Scsi_Device *); /* Attach devices to arrays */
-    void (*detach)(Scsi_Device *);
-    int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
-                                           Selects command for blkdevs */
-    void (*rescan)(Scsi_Device *);
-    struct device_driver scsi_driverfs_driver;
+struct scsi_driver {
+	struct module		*owner;
+	struct device_driver	gendrv;
+
+	int (*init_command)(struct scsi_cmnd *);
+	void (*rescan)(struct device *);
 };
+#define to_scsi_driver(drv) \
+	container_of((drv), struct scsi_driver, gendrv)
 
-/*
- * Highlevel driver registration/unregistration.
- */
-extern int scsi_register_device(struct Scsi_Device_Template *);
-extern int scsi_unregister_device(struct Scsi_Device_Template *);
+extern int scsi_register_driver(struct scsi_driver *);
+extern void scsi_unregister_driver(struct scsi_driver *);
 
 /*
  * HBA allocation/freeing.
===== drivers/scsi/ide-scsi.c 1.23 vs edited =====
--- 1.23/drivers/scsi/ide-scsi.c	Tue Jan 28 18:01:08 2003
+++ edited/drivers/scsi/ide-scsi.c	Fri May 16 17:34:35 2003
@@ -770,8 +770,8 @@
 	struct gendisk *disk = cmd->request->rq_disk;
 
 	if (disk) {
-		struct Scsi_Device_Template **p = disk->private_data;
-		if (strcmp((*p)->scsi_driverfs_driver.name, "sg") == 0)
+		struct scsi_driver **p = disk->private_data;
+		if (strcmp((*p)->gendrv.name, "sg") == 0)
 			return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 	}
 	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
===== drivers/scsi/osst.c 1.43 vs edited =====
--- 1.43/drivers/scsi/osst.c	Wed May  7 16:15:37 2003
+++ edited/drivers/scsi/osst.c	Fri May 16 17:34:35 2003
@@ -160,19 +160,15 @@
 static int osst_copy_to_buffer(OSST_buffer *, unsigned char *);
 static int osst_copy_from_buffer(OSST_buffer *, unsigned char *);
 
-static int osst_attach(Scsi_Device *);
-static void osst_detach(Scsi_Device *);
+static int osst_probe(struct device *);
+static int osst_remove(struct device *);
 
-struct Scsi_Device_Template osst_template =
-{
-	.module =       THIS_MODULE,
-	.list =         LIST_HEAD_INIT(osst_template.list),
-	.name =         "OnStream Tape",
-	.scsi_type =    TYPE_TAPE,
-	.attach =       osst_attach,
-	.detach =       osst_detach,
-	.scsi_driverfs_driver = {
-		.name =  "osst",
+struct scsi_driver osst_template = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name		=  "osst",
+		.probe		= osst_probe,
+		.remove		= osst_remove,
 	}
 };
 
@@ -5385,8 +5381,9 @@
  * osst startup / cleanup code
  */
 
-static int osst_attach(Scsi_Device * SDp)
+static int osst_probe(struct device *dev)
 {
+	Scsi_Device    * SDp = to_scsi_device(dev);
 	OS_Scsi_Tape   * tpnt;
 	ST_mode        * STm;
 	ST_partstat    * STps;
@@ -5395,12 +5392,12 @@
 	int              i, mode, dev_num;
 
 	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
-		return 1;
+		return -ENODEV;
 
 	drive = alloc_disk(1);
 	if (!drive) {
 		printk(KERN_ERR "osst :E: Out of memory. Device not attached.\n");
-		return 1;
+		return -ENODEV;
 	}
 
 	/* if this is the first attach, build the infrastructure */
@@ -5576,16 +5573,17 @@
 
 out_put_disk:
         put_disk(drive);
-        return 1;
+        return -ENODEV;
 };
 
-static void osst_detach(Scsi_Device * SDp)
+static int osst_remove(struct device *dev)
 {
+  Scsi_Device * SDp = to_scsi_device(dev);
   OS_Scsi_Tape * tpnt;
   int i, mode;
 
   if ((SDp->type != TYPE_TAPE) || (osst_nr_dev <= 0))
-	  return;
+	  return 0;
 
   write_lock(&os_scsi_tapes_lock);
   for(i=0; i < osst_max_dev; i++) {
@@ -5618,11 +5616,11 @@
 			kfree(tpnt->buffer);
 		}
 		kfree(tpnt);
-		return;
+		return 0;
 	}
   }
   write_unlock(&os_scsi_tapes_lock);
-  return;
+  return 0;
 }
 
 static int __init init_osst(void) 
@@ -5631,7 +5629,7 @@
 
 	validate_options();
 	
-	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_device(&osst_template)) {
+	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_driver(&osst_template)) {
 		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n", OSST_MAJOR);
 		return 1;
 	}
@@ -5644,7 +5642,7 @@
 	int i;
 	OS_Scsi_Tape * STp;
 
-	scsi_unregister_device(&osst_template);
+	scsi_unregister_driver(&osst_template);
 	unregister_chrdev(OSST_MAJOR, "osst");
 
 	if (os_scsi_tapes) {
===== drivers/scsi/osst.h 1.9 vs edited =====
--- 1.9/drivers/scsi/osst.h	Fri Apr 18 17:57:20 2003
+++ edited/drivers/scsi/osst.h	Fri May 16 17:34:35 2003
@@ -530,7 +530,7 @@
 
 /* The OnStream tape drive descriptor */
 typedef struct {
-  struct Scsi_Device_Template *driver;
+  struct scsi_driver *driver;
   unsigned capacity;
   Scsi_Device* device;
   struct semaphore lock;       /* for serialization */
===== drivers/scsi/scsi.c 1.112 vs edited =====
--- 1.112/drivers/scsi/scsi.c	Thu May  8 20:31:08 2003
+++ edited/drivers/scsi/scsi.c	Fri May 16 17:34:35 2003
@@ -86,12 +86,6 @@
 static unsigned long serial_number;
 
 /*
- * List of all highlevel drivers.
- */
-LIST_HEAD(scsi_devicelist);
-static DECLARE_RWSEM(scsi_devicelist_mutex);
-
-/*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
@@ -931,50 +925,6 @@
 	return depth;
 }
 
-int scsi_attach_device(struct scsi_device *sdev)
-{
-	struct Scsi_Device_Template *sdt;
-
-	down_read(&scsi_devicelist_mutex);
-	list_for_each_entry(sdt, &scsi_devicelist, list) {
-		if (!try_module_get(sdt->module))
-			continue;
-		(*sdt->attach)(sdev);
-		module_put(sdt->module);
-	}
-	up_read(&scsi_devicelist_mutex);
-	return 0;
-}
-
-void scsi_detach_device(struct scsi_device *sdev)
-{
-	struct Scsi_Device_Template *sdt;
-
-	down_read(&scsi_devicelist_mutex);
-	list_for_each_entry(sdt, &scsi_devicelist, list) {
-		if (!try_module_get(sdt->module))
-			continue;
-		(*sdt->detach)(sdev);
-		module_put(sdt->module);
-	}
-	up_read(&scsi_devicelist_mutex);
-}
-
-void scsi_rescan_device(struct scsi_device *sdev)
-{
-	struct Scsi_Device_Template *sdt;
-
-	down_read(&scsi_devicelist_mutex);
-	list_for_each_entry(sdt, &scsi_devicelist, list) {
-		if (!try_module_get(sdt->module))
-			continue;
-		if (*sdt->rescan)
-			(*sdt->rescan)(sdev);
-		module_put(sdt->module);
-	}
-	up_read(&scsi_devicelist_mutex);
-}
-
 int scsi_device_get(struct scsi_device *sdev)
 {
 	if (!try_module_get(sdev->host->hostt->module))
@@ -1028,71 +978,6 @@
 	} else {
 		/* FIXME: Send online state change hotplug event */
 	}
-}
-
-/*
- * This entry point is called from the upper level module's module_init()
- * routine.  That implies that when this function is called, the
- * scsi_mod module is locked down because of upper module layering and
- * that the high level driver module is locked down by being in it's
- * init routine.  So, the *only* thing we have to do to protect adds 
- * we perform in this function is to make sure that all call's
- * to the high level driver's attach() and detach() call in points, other
- * than via scsi_register_device and scsi_unregister_device which are in
- * the module_init and module_exit code respectively and therefore already
- * locked down by the kernel module loader, are wrapped by try_module_get()
- * and module_put() to avoid races on device adds and removes.
- */
-int scsi_register_device(struct Scsi_Device_Template *tpnt)
-{
-	struct scsi_device *sdev;
-	struct Scsi_Host *shpnt;
-
-#ifdef CONFIG_KMOD
-	if (scsi_host_get_next(NULL) == NULL)
-		request_module("scsi_hostadapter");
-#endif
-
-	if (!list_empty(&tpnt->list))
-		return 1;
-
-	down_write(&scsi_devicelist_mutex);
-	list_add_tail(&tpnt->list, &scsi_devicelist);
-	up_write(&scsi_devicelist_mutex);
-
-	scsi_upper_driver_register(tpnt);
-
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) 
-		list_for_each_entry(sdev, &shpnt->my_devices, siblings)
-			(*tpnt->attach)(sdev);
-
-	return 0;
-}
-
-int scsi_unregister_device(struct Scsi_Device_Template *tpnt)
-{
-	struct scsi_device *sdev;
-	struct Scsi_Host *shpnt;
-
-	/*
-	 * Next, detach the devices from the driver.
-	 */
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		list_for_each_entry(sdev, &shpnt->my_devices, siblings)
-			(*tpnt->detach)(sdev);
-	}
-
-	/*
-	 * Extract the template from the linked list.
-	 */
-	down_write(&scsi_devicelist_mutex);
-	list_del(&tpnt->list);
-	up_write(&scsi_devicelist_mutex);
-
-	scsi_upper_driver_unregister(tpnt);
-	return 0;
 }
 
 MODULE_DESCRIPTION("SCSI core");
===== drivers/scsi/scsi_lib.c 1.90 vs edited =====
--- 1.90/drivers/scsi/scsi_lib.c	Thu May  8 21:14:09 2003
+++ edited/drivers/scsi/scsi_lib.c	Fri May 16 17:34:35 2003
@@ -613,29 +613,6 @@
 }
 
 /*
- * Function:    scsi_get_request_dev()
- *
- * Purpose:     Find the upper-level driver that is responsible for this
- *              request
- *
- * Arguments:   request   - I/O request we are preparing to queue.
- *
- * Lock status: No locks assumed to be held, but as it happens the
- *              q->queue_lock is held when this is called.
- *
- * Returns:     Nothing
- *
- * Notes:       The requests in the request queue may have originated
- *              from any block device driver.  We need to find out which
- *              one so that we can later form the appropriate command.
- */
-static struct Scsi_Device_Template *scsi_get_request_dev(struct request *req)
-{
-	struct gendisk *p = req->rq_disk;
-	return p ? *(struct Scsi_Device_Template **)p->private_data : NULL;
-}
-
-/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -847,11 +824,7 @@
 		return;
 	}
 	if (result) {
-		struct Scsi_Device_Template *sdt;
-
-		sdt = scsi_get_request_dev(cmd->request);
-		printk("SCSI %s error : <%d %d %d %d> return code = 0x%x\n",
-		       (sdt ? sdt->name : "device"),
+		printk("SCSI error : <%d %d %d %d> return code = 0x%x\n",
 		       cmd->device->host->host_no,
 		       cmd->device->channel,
 		       cmd->device->id,
@@ -945,7 +918,6 @@
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
-	struct Scsi_Device_Template *sdt;
 	struct scsi_device *sdev = q->queuedata;
 	struct scsi_cmnd *cmd;
 
@@ -1001,6 +973,7 @@
 	 * happening now.
 	 */
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+		struct scsi_driver *drv;
 		int ret;
 
 		/*
@@ -1015,8 +988,6 @@
 		 * some kinds of consistency checking may cause the	
 		 * request to be rejected immediately.
 		 */
-		sdt = scsi_get_request_dev(req);
-		BUG_ON(!sdt);
 
 		/* 
 		 * This sets up the scatter-gather table (allocating if
@@ -1029,7 +1000,8 @@
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		if (unlikely(!sdt->init_command(cmd))) {
+		drv = *(struct scsi_driver **)req->rq_disk->private_data;
+		if (unlikely(!drv->init_command(cmd))) {
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
 			return BLKPREP_KILL;
===== drivers/scsi/scsi_priv.h 1.6 vs edited =====
--- 1.6/drivers/scsi/scsi_priv.h	Mon May 12 00:12:54 2003
+++ edited/drivers/scsi/scsi_priv.h	Fri May 16 17:34:35 2003
@@ -41,9 +41,6 @@
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
 
-struct Scsi_Device_Template;
-
-
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -68,9 +65,6 @@
 extern void scsi_done(struct scsi_cmnd *cmd);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern int scsi_retry_command(struct scsi_cmnd *cmd);
-extern int scsi_attach_device(struct scsi_device *sdev);
-extern void scsi_detach_device(struct scsi_device *sdev);
-extern void scsi_rescan_device(struct scsi_device *sdev);
 extern int scsi_insert_special_req(struct scsi_request *sreq, int);
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
@@ -117,12 +111,11 @@
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_free_shost(struct Scsi_Host *);
 extern void scsi_host_get(struct Scsi_Host *);
+extern void scsi_rescan_device(struct device *dev);
 
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
 extern void scsi_device_unregister(struct scsi_device *);
-extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
-extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
 extern void scsi_sysfs_init_host(struct Scsi_Host *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_sysfs_remove_host(struct Scsi_Host *);
===== drivers/scsi/scsi_scan.c 1.85 vs edited =====
--- 1.85/drivers/scsi/scsi_scan.c	Thu May  8 20:24:15 2003
+++ edited/drivers/scsi/scsi_scan.c	Fri May 16 17:34:36 2003
@@ -1091,22 +1091,29 @@
 				    uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev;
-	int error = -ENODEV, res;
+	int res;
 
 	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev);
-	if (res == SCSI_SCAN_LUN_PRESENT)
-		error = scsi_attach_device(sdev);
-
-	if (error)
-		sdev = ERR_PTR(error);
+	if (res != SCSI_SCAN_LUN_PRESENT)
+		sdev = ERR_PTR(-ENODEV);
 	return sdev;
 }
 
 int scsi_remove_device(struct scsi_device *sdev)
 {
-	scsi_detach_device(sdev);
 	scsi_device_unregister(sdev);
 	return 0;
+}
+
+void scsi_rescan_device(struct device *dev)
+{
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (try_module_get(drv->owner)) {
+		if (drv->rescan)
+			drv->rescan(dev);
+		module_put(drv->owner);
+	}
 }
 
 /**
===== drivers/scsi/scsi_syms.c 1.36 vs edited =====
--- 1.36/drivers/scsi/scsi_syms.c	Thu May  8 20:24:15 2003
+++ edited/drivers/scsi/scsi_syms.c	Fri May 16 17:34:36 2003
@@ -29,8 +29,8 @@
  * This source file contains the symbol table used by scsi loadable
  * modules.
  */
-EXPORT_SYMBOL(scsi_register_device);
-EXPORT_SYMBOL(scsi_unregister_device);
+EXPORT_SYMBOL(scsi_register_driver);
+EXPORT_SYMBOL(scsi_unregister_driver);
 EXPORT_SYMBOL(scsi_register_host);
 EXPORT_SYMBOL(scsi_unregister_host);
 EXPORT_SYMBOL(scsi_add_host);
===== drivers/scsi/scsi_sysfs.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsi_sysfs.c	Mon May 12 00:12:40 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Fri May 16 17:34:36 2003
@@ -57,32 +57,12 @@
 	.name		= "scsi_host",
 };
 
-/**
- * scsi_bus_match:
- * @dev:
- * @dev_driver:
- *
- * Return value:
- **/
-static int scsi_bus_match(struct device *dev, 
-                          struct device_driver *dev_driver)
+/* all probing is done in the individual ->probe routines */
+static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-        if (!strcmp("sg", dev_driver->name)) {
-                if (strstr(dev->bus_id, ":gen"))
-                        return 1;
-        } else if (!strcmp("st",dev_driver->name)) {
-                if (strstr(dev->bus_id,":mt"))
-                        return 1;
-        } else if (!strcmp("sd", dev_driver->name)) {
-                if ((!strstr(dev->bus_id, ":gen")) && 
-		    (!strstr(dev->bus_id, ":mt"))) { 
-                        return 1;
-                }
-	}
-        return 0;
+	return 1;
 }
 
-
 static struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
@@ -109,34 +89,6 @@
 	bus_unregister(&scsi_bus_type);
 }
 
-/**
- * scsi_upper_driver_register - register upper level driver.
- * @sdev_tp:	Upper level driver to register with the scsi bus.
- *
- * Return value:
- * 	0 on Success / non-zero on Failure
- **/
-int scsi_upper_driver_register(struct Scsi_Device_Template *sdev_tp)
-{
-	int error = 0;
-
-	sdev_tp->scsi_driverfs_driver.bus = &scsi_bus_type;
-	error = driver_register(&sdev_tp->scsi_driverfs_driver);
-
-	return error;
-}
-
-/**
- * scsi_upper_driver_unregister - unregister upper level driver 
- * @sdev_tp:	Upper level driver to unregister with the scsi bus.
- *
- **/
-void scsi_upper_driver_unregister(struct Scsi_Device_Template *sdev_tp)
-{
-	driver_unregister(&sdev_tp->scsi_driverfs_driver);
-}
-
-
 /*
  * sdev_show_function: macro to create an attr function that can be used to
  * show a non-bit field.
@@ -237,7 +189,7 @@
 static ssize_t
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
 {
-	scsi_rescan_device(to_scsi_device(dev));
+	scsi_rescan_device(dev);
 	return 0;
 }
 
@@ -310,6 +262,18 @@
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
 
+int scsi_register_driver(struct scsi_driver *drv)
+{
+	drv->gendrv.bus = &scsi_bus_type;
+
+	return driver_register(&drv->gendrv);
+}
+
+void scsi_unregister_driver(struct scsi_driver *drv)
+{
+	driver_unregister(&drv->gendrv);
+}
+
 static void scsi_host_release(struct device *dev)
 {
 	struct Scsi_Host *shost;
@@ -347,7 +311,7 @@
 	int i, error;
 
 	if (!shost->host_gendev.parent)
-		shost->host_gendev.parent = (dev) ? dev : &legacy_bus;
+		shost->host_gendev.parent = dev ? dev : &legacy_bus;
 
 	error = device_add(&shost->host_gendev);
 	if (error)
===== drivers/scsi/sd.c 1.112 vs edited =====
--- 1.112/drivers/scsi/sd.c	Thu May  8 12:16:20 2003
+++ edited/drivers/scsi/sd.c	Fri May 16 17:34:40 2003
@@ -73,8 +73,7 @@
 #define SD_MAX_RETRIES		5
 
 struct scsi_disk {
-	struct list_head list;		/* list of all scsi_disks */
-	struct Scsi_Device_Template *driver;	/* always &sd_template */
+	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
 	struct gendisk	*disk;
 	sector_t	capacity;	/* size in 512-byte sectors */
@@ -85,37 +84,31 @@
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 };
 
-static LIST_HEAD(sd_devlist);
-static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
-
 static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
 
 static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
-static int sd_attach(struct scsi_device *);
-static void sd_detach(struct scsi_device *);
-static void sd_rescan(struct scsi_device *);
+static int sd_probe(struct device *);
+static int sd_remove(struct device *);
+static void sd_shutdown(struct device *dev);
+static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
 static int sd_synchronize_cache(struct scsi_disk *, int);
-static int sd_notifier(struct notifier_block *, unsigned long, void *);
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
 		 struct scsi_request *SRpnt, unsigned char *buffer);
-static struct notifier_block sd_notifier_block = {sd_notifier, NULL, 0}; 
 
-static struct Scsi_Device_Template sd_template = {
-	.module		= THIS_MODULE,
-	.list		= LIST_HEAD_INIT(sd_template.list),
-	.name		= "disk",
-	.scsi_type	= TYPE_DISK,
-	.attach		= sd_attach,
-	.detach		= sd_detach,
-	.rescan		= sd_rescan,
-	.init_command	= sd_init_command,
-	.scsi_driverfs_driver = {
-		.name   = "sd",
+static struct scsi_driver sd_template = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name		= "sd",
+		.probe		= sd_probe,
+		.remove		= sd_remove,
+		.shutdown	= sd_shutdown,
 	},
+	.rescan			= sd_rescan,
+	.init_command		= sd_init_command,
 };
 
 static int sd_major(int major_idx)
@@ -133,36 +126,6 @@
 	}
 }
 
-static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
-{
-	struct scsi_disk *sdkp;
-
-	spin_lock(&sd_devlist_lock);
-	list_for_each_entry(sdkp, &sd_devlist, list) {
-		if (sdkp->device == sd) {
-			spin_unlock(&sd_devlist_lock);
-			return sdkp;
-		}
-	}
-
-	spin_unlock(&sd_devlist_lock);
-	return NULL;
-}
-
-static inline void sd_devlist_insert(struct scsi_disk *sdkp)
-{
-	spin_lock(&sd_devlist_lock);
-	list_add(&sdkp->list, &sd_devlist);
-	spin_unlock(&sd_devlist_lock);
-}
-
-static inline void sd_devlist_remove(struct scsi_disk *sdkp)
-{
-	spin_lock(&sd_devlist_lock);
-	list_del(&sdkp->list);
-	spin_unlock(&sd_devlist_lock);
-}
- 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
 	return container_of(disk->private_data, struct scsi_disk, driver);
@@ -635,12 +598,13 @@
 	return 1;
 }
 
-static void sd_rescan(struct scsi_device * sdp)
+static void sd_rescan(struct device *dev)
 {
-	unsigned char *buffer;
-	struct scsi_disk *sdkp = sd_find_by_sdev(sdp);
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct gendisk *gd;
 	struct scsi_request *SRpnt;
+	unsigned char *buffer;
 
 	if (!sdkp || sdp->online == FALSE || !sdkp->media_present)
 		return;
@@ -1288,10 +1252,10 @@
 }
 
 /**
- *	sd_attach - called during driver initialization and whenever a
+ *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
- *	@sdp: pointer to mid level scsi device object
+ *	@dev: pointer to device object
  *
  *	Returns 0 if successful (or not interested in this scsi device 
  *	(e.g. scanner)); 1 when there is an error.
@@ -1303,17 +1267,19 @@
  *	and minor number that is chosen here.
  *
  *	Assume sd_attach is not re-entrant (for time being)
- *	Also think about sd_attach() and sd_detach() running coincidentally.
+ *	Also think about sd_attach() and sd_remove() running coincidentally.
  **/
-static int sd_attach(struct scsi_device * sdp)
+static int sd_probe(struct device *dev)
 {
+	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	u32 index;
 	int error;
 
+	error = -ENODEV;
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
-		return 1;
+		goto out;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
@@ -1365,8 +1331,8 @@
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
-	sd_devlist_insert(sdkp);
 	set_capacity(gd, sdkp->capacity);
+	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
@@ -1385,44 +1351,42 @@
 }
 
 /**
- *	sd_detach - called whenever a scsi disk (previously recognized by
- *	sd_attach) is detached from the system. It is called (potentially
+ *	sd_remove - called whenever a scsi disk (previously recognized by
+ *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
  *	@sdp: pointer to mid level scsi device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)
- *	that could be re-used by a subsequent sd_attach().
+ *	that could be re-used by a subsequent sd_probe().
  *	This function is not called when the built-in sd driver is "exit-ed".
  **/
-static void sd_detach(struct scsi_device * sdp)
+static int sd_remove(struct device *dev)
 {
-	struct scsi_disk *sdkp;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_detach: <%d,%d,%d,%d>\n", 
-			    sdp->host->host_no, sdp->channel, sdp->id, 
-			    sdp->lun));
-
-	sdkp = sd_find_by_sdev(sdp);
-	if (!sdkp)
-		return;
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	/* check that we actually have a write back cache to synchronize */
-	if (sdkp->WCE) {
-		printk(KERN_NOTICE "Synchronizing SCSI cache: ");
-		sd_synchronize_cache(sdkp, 1);
-		printk("\n");
-	}
-
-	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
 
 	spin_lock(&sd_index_lock);
 	clear_bit(sdkp->index, sd_index_bits);
 	spin_unlock(&sd_index_lock);
 
+	sd_shutdown(dev);
 	put_disk(sdkp->disk);
 	kfree(sdkp);
+
+	return 0;
+}
+
+static void sd_shutdown(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	if (sdkp->WCE) {
+		printk(KERN_NOTICE "Synchronizing SCSI cache: ");
+		sd_synchronize_cache(sdkp, 1);
+		printk("\n");
+	}
 }
 
 /**
@@ -1433,7 +1397,7 @@
  **/
 static int __init init_sd(void)
 {
-	int majors = 0, rc = -ENODEV, i;
+	int majors = 0, i;
 
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
 
@@ -1444,11 +1408,7 @@
 	if (!majors)
 		return -ENODEV;
 
-	rc = scsi_register_device(&sd_template);
-	if (rc)
-		return rc;
-	register_reboot_notifier(&sd_notifier_block);
-	return rc;
+	return scsi_register_driver(&sd_template);
 }
 
 /**
@@ -1462,35 +1422,9 @@
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
-	unregister_reboot_notifier(&sd_notifier_block);
-	scsi_unregister_device(&sd_template);
+	scsi_unregister_driver(&sd_template);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
-}
-
-/*
- * XXX: this function does not take sd_devlist_lock to synchronize
- *	access to sd_devlist.  This should be safe as no other reboot
- *	notifier can access it.
- */
-static int sd_notifier(struct notifier_block *n, unsigned long event, void *p)
-{
-	if (event != SYS_RESTART &&
-	    event != SYS_HALT &&
-	    event != SYS_POWER_OFF)
-		return NOTIFY_DONE;
-
-	if (!list_empty(&sd_devlist)) {
-		struct scsi_disk *sdkp;
-
-		printk(KERN_NOTICE "Synchronizing SCSI caches: ");
-		list_for_each_entry(sdkp, &sd_devlist, list)
-			if (sdkp->WCE)
-				sd_synchronize_cache(sdkp, 1);
-		printk("\n");
-	}
-
-	return NOTIFY_OK;
 }
 
 /* send a SYNCHRONIZE CACHE instruction down to the device through the
===== drivers/scsi/sg.c 1.54 vs edited =====
--- 1.54/drivers/scsi/sg.c	Wed May  7 16:15:40 2003
+++ edited/drivers/scsi/sg.c	Fri May 16 17:34:40 2003
@@ -112,23 +112,20 @@
 
 #define SG_DEV_ARR_LUMP 6	/* amount to over allocate sg_dev_arr by */
 
-static int sg_attach(Scsi_Device *);
-static void sg_detach(Scsi_Device *);
+static int sg_probe(struct device *);
+static int sg_remove(struct device *);
 
 static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
 
 static rwlock_t sg_dev_arr_lock = RW_LOCK_UNLOCKED;	/* Also used to lock
 							   file descriptor list for device */
 
-static struct Scsi_Device_Template sg_template = {
-	.module = THIS_MODULE,
-	.list = LIST_HEAD_INIT(sg_template.list),
-	.name = "generic",
-	.scsi_type = 0xff,
-	.attach = sg_attach,
-	.detach = sg_detach,
-	.scsi_driverfs_driver = {
-		.name = "sg",
+static struct scsi_driver sg_template = {
+	.owner		= THIS_MODULE,
+	.gendrv = {
+		.name	= "sg",
+		.probe	= sg_probe,
+		.remove	= sg_remove,
 	},
 };
 
@@ -180,15 +177,14 @@
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
-	struct Scsi_Device_Template *driver;
-	Scsi_Device *device;
+	struct scsi_driver *driver;
+	struct scsi_device *device;
 	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	Sg_fd *headfp;		/* first open fd belonging to this device */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	volatile char exclude;	/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
-	struct device sg_driverfs_dev;
 	struct gendisk *disk;
 } Sg_device;
 
@@ -1332,7 +1328,7 @@
 static ssize_t
 sg_device_kdev_read(struct device *driverfs_dev, char *page)
 {
-	Sg_device *sdp = list_entry(driverfs_dev, Sg_device, sg_driverfs_dev);
+	Sg_device *sdp = dev_get_drvdata(driverfs_dev);
 	return sprintf(page, "%x\n", MKDEV(sdp->disk->major,
 					   sdp->disk->first_minor));
 }
@@ -1347,8 +1343,9 @@
 static DEVICE_ATTR(type,S_IRUGO,sg_device_type_read,NULL);
 
 static int
-sg_attach(Scsi_Device * scsidp)
+sg_probe(struct device *dev)
 {
+	struct scsi_device *scsidp = to_scsi_device(dev);
 	struct gendisk *disk;
 	Sg_device *sdp = NULL;
 	unsigned long iflags;
@@ -1431,21 +1428,12 @@
 	sdp->detached = 0;
 	sdp->sg_tablesize = scsidp->host ? scsidp->host->sg_tablesize : 0;
 
-	memset(&sdp->sg_driverfs_dev, 0, sizeof (struct device));
-	snprintf(sdp->sg_driverfs_dev.bus_id, BUS_ID_SIZE, "%s:gen",
-		scsidp->sdev_driverfs_dev.bus_id);
-	snprintf(sdp->sg_driverfs_dev.name, DEVICE_NAME_SIZE, "%sgeneric",
-		scsidp->sdev_driverfs_dev.name);
-	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
-	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;
-
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
-	device_register(&sdp->sg_driverfs_dev);
-	device_create_file(&sdp->sg_driverfs_dev, &dev_attr_type);
-	device_create_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
+	device_create_file(&scsidp->sdev_driverfs_dev, &dev_attr_type);
+	device_create_file(&scsidp->sdev_driverfs_dev, &dev_attr_kdev);
 
 	sprintf(devfs_name, "%s/generic", scsidp->devfs_name);
 	devfs_register(NULL, devfs_name, 0,
@@ -1453,20 +1441,13 @@
 			S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
 			&sg_fops, sdp);
 
-	switch (scsidp->type) {
-	case TYPE_DISK:
-	case TYPE_MOD:
-	case TYPE_ROM:
-	case TYPE_WORM:
-	case TYPE_TAPE:
-		break;
-	default:
-		printk(KERN_NOTICE
-		       "Attached scsi generic sg%d at scsi%d, channel"
-		       " %d, id %d, lun %d,  type %d\n", k,
-		       scsidp->host->host_no, scsidp->channel, scsidp->id,
-		       scsidp->lun, scsidp->type);
-	}
+	printk(KERN_NOTICE
+	       "Attached scsi generic sg%d at scsi%d, channel"
+	       " %d, id %d, lun %d,  type %d\n", k,
+	       scsidp->host->host_no, scsidp->channel, scsidp->id,
+	       scsidp->lun, scsidp->type);
+
+	dev_set_drvdata(dev, sdp);
 	return 0;
 
 out:
@@ -1474,9 +1455,10 @@
 	return error;
 }
 
-static void
-sg_detach(Scsi_Device * scsidp)
+static int
+sg_remove(struct device *dev)
 {
+	struct scsi_device *scsidp = to_scsi_device(dev);
 	Sg_device *sdp = NULL;
 	unsigned long iflags;
 	Sg_fd *sfp;
@@ -1486,7 +1468,7 @@
 	int k, delay;
 
 	if (NULL == sg_dev_arr)
-		return;
+		return 0;
 	delay = 0;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
 	for (k = 0; k < sg_dev_max; k++) {
@@ -1527,9 +1509,8 @@
 
 	if (sdp) {
 		devfs_remove("%s/generic", scsidp->devfs_name);
-		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_type);
-		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
-		device_unregister(&sdp->sg_driverfs_dev);
+		device_remove_file(&scsidp->sdev_driverfs_dev, &dev_attr_type);
+		device_remove_file(&scsidp->sdev_driverfs_dev, &dev_attr_kdev);
 		put_disk(sdp->disk);
 		sdp->disk = NULL;
 		if (NULL == sdp->headfp)
@@ -1538,6 +1519,8 @@
 
 	if (delay)
 		scsi_sleep(2);	/* dirty detach so delay device destruction */
+
+	return 0;
 }
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
@@ -1595,7 +1578,7 @@
 
 static void do_create_driverfs_files(void)
 {
-	struct device_driver * driverfs = &sg_template.scsi_driverfs_driver;
+	struct device_driver * driverfs = &sg_template.gendrv;
 
 	driver_create_file(driverfs, &driver_attr_allow_dio);
 	driver_create_file(driverfs, &driver_attr_def_reserved_size);
@@ -1604,7 +1587,7 @@
 
 static void do_remove_driverfs_files(void)
 {
-	struct device_driver * driverfs = &sg_template.scsi_driverfs_driver;
+	struct device_driver * driverfs = &sg_template.gendrv;
 
 	driver_remove_file(driverfs, &driver_attr_version);
 	driver_remove_file(driverfs, &driver_attr_def_reserved_size);
@@ -1622,7 +1605,7 @@
 	rc = register_chrdev(SCSI_GENERIC_MAJOR, "sg", &sg_fops);
 	if (rc)
 		return rc;
-	rc = scsi_register_device(&sg_template);
+	rc = scsi_register_driver(&sg_template);
 	if (rc)
 		return rc;
 #ifdef CONFIG_PROC_FS
@@ -1639,7 +1622,7 @@
 #ifdef CONFIG_PROC_FS
 	sg_proc_cleanup();
 #endif				/* CONFIG_PROC_FS */
-	scsi_unregister_device(&sg_template);
+	scsi_unregister_driver(&sg_template);
 	unregister_chrdev(SCSI_GENERIC_MAJOR, "sg");
 	if (sg_dev_arr != NULL) {
 		vfree((char *) sg_dev_arr);
===== drivers/scsi/sr.c 1.78 vs edited =====
--- 1.78/drivers/scsi/sr.c	Wed May  7 16:15:41 2003
+++ edited/drivers/scsi/sr.c	Fri May 16 17:34:40 2003
@@ -67,26 +67,20 @@
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_GENERIC_PACKET)
 
-static int sr_attach(struct scsi_device *);
-static void sr_detach(struct scsi_device *);
+static int sr_probe(struct device *);
+static int sr_remove(struct device *);
 static int sr_init_command(struct scsi_cmnd *);
 
-static struct Scsi_Device_Template sr_template = {
-	.module		= THIS_MODULE,
-	.list		= LIST_HEAD_INIT(sr_template.list),
-	.name		= "cdrom",
-	.scsi_type	= TYPE_ROM,
-	.attach		= sr_attach,
-	.detach		= sr_detach,
-	.init_command	= sr_init_command,
-	.scsi_driverfs_driver = {
-		.name   = "sr",
+static struct scsi_driver sr_template = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name   	= "sr",
+		.probe		= sr_probe,
+		.remove		= sr_remove,
 	},
+	.init_command		= sr_init_command,
 };
 
-static LIST_HEAD(sr_devlist);
-static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
-
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
 
@@ -99,37 +93,6 @@
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
 
-static Scsi_CD *sr_find_by_sdev(Scsi_Device *sd)
-{
-	struct list_head *p;
-	Scsi_CD *cd;
-
-	spin_lock(&sr_devlist_lock);
-	list_for_each(p, &sr_devlist) {
-		cd = list_entry(p, Scsi_CD, list);
-		if (cd->device == sd) {
-			spin_unlock(&sr_devlist_lock);
-			return cd;
-		}
-	}
-	spin_unlock(&sr_devlist_lock);
-	return NULL;
-}
-
-static inline void sr_devlist_insert(Scsi_CD *cd)
-{
-	spin_lock(&sr_devlist_lock);
-	list_add(&cd->list, &sr_devlist);
-	spin_unlock(&sr_devlist_lock);
-}
-
-static inline void sr_devlist_remove(Scsi_CD *cd)
-{
-	spin_lock(&sr_devlist_lock);
-	list_del(&cd->list);
-	spin_unlock(&sr_devlist_lock);
-}
-
 static struct cdrom_device_ops sr_dops = {
 	.open			= sr_open,
 	.release	 	= sr_release,
@@ -506,14 +469,16 @@
 	scsi_device_put(cd->device);
 }
 
-static int sr_attach(struct scsi_device *sdev)
+static int sr_probe(struct device *dev)
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
 	struct gendisk *disk;
 	struct scsi_cd *cd;
 	int minor, error;
 
+	error = -ENODEV;
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
-		return 1;
+		goto fail;
 
 	error = -ENOMEM;
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
@@ -574,8 +539,8 @@
 	disk->private_data = &cd->driver;
 	disk->queue = sdev->request_queue;
 
+	dev_set_drvdata(dev, cd);
 	add_disk(disk);
-	sr_devlist_insert(cd);
 
 	printk(KERN_DEBUG
 	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
@@ -806,15 +771,10 @@
 	return cgc->stat;
 }
 
-static void sr_detach(struct scsi_device * SDp)
+static int sr_remove(struct device *dev)
 {
-	struct scsi_cd *cd;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	cd = sr_find_by_sdev(SDp);
-	if (!cd)
-		return;
-
-	sr_devlist_remove(cd);
 	del_gendisk(cd->disk);
 
 	spin_lock(&sr_index_lock);
@@ -824,6 +784,8 @@
 	put_disk(cd->disk);
 	unregister_cdrom(&cd->cdi);
 	kfree(cd);
+
+	return 0;
 }
 
 static int __init init_sr(void)
@@ -833,12 +795,12 @@
 	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
 	if (rc)
 		return rc;
-	return scsi_register_device(&sr_template);
+	return scsi_register_driver(&sr_template);
 }
 
 static void __exit exit_sr(void)
 {
-	scsi_unregister_device(&sr_template);
+	scsi_unregister_driver(&sr_template);
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
 
===== drivers/scsi/sr.h 1.9 vs edited =====
--- 1.9/drivers/scsi/sr.h	Sun Nov  3 14:46:32 2002
+++ edited/drivers/scsi/sr.h	Fri May 16 17:34:40 2003
@@ -25,8 +25,7 @@
 #define IOCTL_TIMEOUT 30*HZ
 
 typedef struct scsi_cd {
-	struct Scsi_Device_Template *driver;
-	struct list_head list;
+	struct scsi_driver *driver;
 	unsigned capacity;	/* size in blocks                       */
 	Scsi_Device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
===== drivers/scsi/st.c 1.61 vs edited =====
--- 1.61/drivers/scsi/st.c	Wed May  7 16:15:41 2003
+++ edited/drivers/scsi/st.c	Fri May 16 17:35:26 2003
@@ -170,22 +170,19 @@
 			      unsigned long, size_t, int);
 static int sgl_unmap_user_pages(struct scatterlist *, const unsigned int, int);
 
-static int st_attach(Scsi_Device *);
-static void st_detach(Scsi_Device *);
+static int st_probe(struct device *);
+static int st_remove(struct device *);
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
 
 
-static struct Scsi_Device_Template st_template = {
-	.module =	THIS_MODULE,
-	.list =		LIST_HEAD_INIT(st_template.list),
-	.name =		"tape", 
-	.scsi_type =	TYPE_TAPE,
-	.attach =	st_attach, 
-	.detach =	st_detach,
-	.scsi_driverfs_driver = {
-		.name = "st",
+static struct scsi_driver st_template = {
+	.owner			= THIS_MODULE,
+	.gendrv = {
+		.name		= "st",
+		.probe		= st_probe,
+		.remove		= st_remove,
 	},
 };
 
@@ -3704,8 +3701,9 @@
 	.release =	st_release,
 };
 
-static int st_attach(Scsi_Device * SDp)
+static int st_probe(struct device *dev)
 {
+	struct scsi_device *SDp = to_scsi_device(dev);
 	struct gendisk *disk;
 	Scsi_Tape *tpnt;
 	ST_mode *STm;
@@ -3716,13 +3714,13 @@
 	u64 bounce_limit;
 
 	if (SDp->type != TYPE_TAPE)
-		return 1;
+		return -ENODEV;
 	if ((stp = st_incompatible(SDp))) {
 		printk(KERN_INFO
 		       "st: Found incompatible tape at scsi%d, channel %d, id %d, lun %d\n",
 		       SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
 		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
-		return 1;
+		return -ENODEV;
 	}
 
 	i = SDp->host->sg_tablesize;
@@ -3921,11 +3919,12 @@
 out_buffer_free:
 	kfree(buffer);
 out:
-	return 1;
+	return -ENODEV;
 };
 
-static void st_detach(Scsi_Device * SDp)
+static int st_remove(struct device *dev)
 {
+	Scsi_Device *SDp = to_scsi_device(dev);
 	Scsi_Tape *tpnt;
 	int i, mode;
 
@@ -3960,12 +3959,12 @@
 			}
 			put_disk(tpnt->disk);
 			kfree(tpnt);
-			return;
+			return 0;
 		}
 	}
 
 	write_unlock(&st_dev_arr_lock);
-	return;
+	return 0;
 }
 
 static int __init init_st(void)
@@ -3977,7 +3976,7 @@
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
 
 	if (register_chrdev(SCSI_TAPE_MAJOR, "st", &st_fops) >= 0) {
-		if (scsi_register_device(&st_template) == 0) {
+		if (scsi_register_driver(&st_template) == 0) {
 			do_create_driverfs_files();
 			return 0;
 		}
@@ -3990,20 +3989,10 @@
 
 static void __exit exit_st(void)
 {
-	int i;
-
 	do_remove_driverfs_files();
-	scsi_unregister_device(&st_template);
+	scsi_unregister_driver(&st_template);
 	unregister_chrdev(SCSI_TAPE_MAJOR, "st");
-	if (scsi_tapes != NULL) {
-		for (i=0; i < st_dev_max; ++i)
-			if (scsi_tapes[i]) {
-				printk(KERN_WARNING "st: scsi_tapes[] not "
-				    "empty after scsi_unregister_device\n");
-				st_detach(scsi_tapes[i]->device);
-			}
-		kfree(scsi_tapes);
-	}
+	kfree(scsi_tapes);
 	printk(KERN_INFO "st: Unloaded.\n");
 }
 
@@ -4038,7 +4027,7 @@
 
 static void do_create_driverfs_files(void)
 {
-	struct device_driver *driverfs = &st_template.scsi_driverfs_driver;
+	struct device_driver *driverfs = &st_template.gendrv;
 
 	driver_create_file(driverfs, &driver_attr_try_direct_io);
 	driver_create_file(driverfs, &driver_attr_fixed_buffer_size);
@@ -4048,7 +4037,7 @@
 
 static void do_remove_driverfs_files(void)
 {
-	struct device_driver *driverfs = &st_template.scsi_driverfs_driver;
+	struct device_driver *driverfs = &st_template.gendrv;
 
 	driver_remove_file(driverfs, &driver_attr_version);
 	driver_remove_file(driverfs, &driver_attr_max_sg_segs);
===== drivers/scsi/st.h 1.13 vs edited =====
--- 1.13/drivers/scsi/st.h	Fri Apr 18 17:57:20 2003
+++ edited/drivers/scsi/st.h	Fri May 16 17:34:37 2003
@@ -70,7 +70,7 @@
 
 /* The tape drive descriptor */
 typedef struct {
-	struct Scsi_Device_Template *driver;
+	struct scsi_driver *driver;
 	Scsi_Device *device;
 	struct semaphore lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
