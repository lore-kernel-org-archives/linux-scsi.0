From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] abstract out more scsi_device acess out of the low-level drivers
Date: Thu, 28 Nov 2002 16:07:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021128160754.A848@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Two new helpers: scsi_device_get and scsi_device_put that get/release a
reference to the underlying HBA driver and increment/decrement
->access_count.  Cleanup ->attach/->detach routines in the upper layer
drivers a bit to consolidate the error pathes once we're cleaning them
up.

->attach and ->detach in upper layer drivers are mandatory now (not
having them would be rather pointless).

(note that the sd.c changes are not in this patch, it'll be part of
my next, bigger patch)


--- 1.31/drivers/scsi/osst.c	Sat Nov 23 19:53:29 2002
+++ edited/drivers/scsi/osst.c	Thu Nov 28 15:01:07 2002
@@ -4232,14 +4232,14 @@
 #endif
 		return (-EBUSY);
 	}
-	if (!try_module_get(STp->device->host->hostt->module)) {
+
+	if (!scsi_device_get(STp->device)) {
 		write_unlock(&os_scsi_tapes_lock);
 #if DEBUG
-                printk(OSST_DEB_MSG "%s:D: Failed try_module_get.\n", name);
+                printk(OSST_DEB_MSG "%s:D: Failed scsi_device_get.\n", name);
 #endif
 		return (-ENXIO);
 	}
-	STp->device->access_count++;
 	filp->private_data = STp;
 	STp->in_use = 1;
 	write_unlock(&os_scsi_tapes_lock);
@@ -4587,9 +4587,7 @@
 	normalize_buffer(STp->buffer);
 	STp->header_ok = 0;
 	STp->in_use = 0;
-	STp->device->access_count--;
-
-	module_put(STp->device->host->hostt->module);
+	scsi_device_put(STp->device);
 
 	return retval;
 }
@@ -4717,9 +4715,8 @@
 	write_lock(&os_scsi_tapes_lock);
 	STp->in_use = 0;
 	write_unlock(&os_scsi_tapes_lock);
-	STp->device->access_count--;
 
-	module_put(STp->device->host->hostt->module);
+	scsi_device_put(STp->device);
 
 	return result;
 }
===== drivers/scsi/scsi.c 1.75 vs edited =====
--- 1.75/drivers/scsi/scsi.c	Sat Nov 23 03:58:22 2002
+++ edited/drivers/scsi/scsi.c	Thu Nov 28 14:09:53 2002
@@ -1875,24 +1875,16 @@
 int scsi_attach_device(struct scsi_device *sdev)
 {
 	struct Scsi_Device_Template *sdt;
 
 	down_read(&scsi_devicelist_mutex);
-	list_for_each_entry(sdt, &scsi_devicelist, list)
-		if (sdt->attach) {
-			/*
-			 * XXX check result when the upper level attach
-			 * return values are fixed, and on failure goto
-			 * fail.
-			 */
-			if(try_module_get(sdt->module)) {
-				(*sdt->attach)(sdev);
-				module_put(sdt->module);
-			} else {
-				printk(KERN_WARNING "SCSI module %s not ready, skipping attach.\n", sdt->name);
-			}
-		}
+	list_for_each_entry(sdt, &scsi_devicelist, list) {
+		if (!try_module_get(sdt->module))
+			continue;
+		(*sdt->attach)(sdev);
+		module_put(sdt->module);
+	}
 	up_read(&scsi_devicelist_mutex);
 	return 0;
 }
 
 void scsi_detach_device(struct scsi_device *sdev)
@@ -1900,18 +1896,30 @@
 	struct Scsi_Device_Template *sdt;
 
 	down_read(&scsi_devicelist_mutex);
-	list_for_each_entry(sdt, &scsi_devicelist, list)
-		if (sdt->detach) {
-			if(try_module_get(sdt->module)) {
-				(*sdt->detach)(sdev);
-				module_put(sdt->module);
-			} else {
-				printk(KERN_WARNING "SCSI module %s not ready, skipping detach.\n", sdt->name);
-			}
-		}
+	list_for_each_entry(sdt, &scsi_devicelist, list) {
+		if (!try_module_get(sdt->module))
+			continue;
+		(*sdt->detach)(sdev);
+		module_put(sdt->module);
+	}
 	up_read(&scsi_devicelist_mutex);
 }
 
+int scsi_device_get(struct scsi_device *sdev)
+{
+	if (!try_module_get(sdev->host->hostt->module))
+		return -ENXIO;
+
+	sdev->access_count++;
+	return 0;
+}
+
+void scsi_device_put(struct scsi_device *sdev)
+{
+	sdev->access_count--;
+	module_put(sdev->host->hostt->module);
+}
+
 /*
  * Function:	scsi_slave_attach()
  *
@@ -1935,7 +1943,7 @@
 			printk(KERN_ERR "scsi: Allocation failure during"
 			       " attach, some SCSI devices might not be"
 			       " configured\n");
-			return 1;
+			return -ENOMEM;
 		}
 		if (sdev->host->hostt->slave_configure != NULL) {
 			if (sdev->host->hostt->slave_configure(sdev) != 0) {
@@ -1943,7 +1951,7 @@
 				       " attach, some SCSI device might not be"
 				       " configured\n");
 				scsi_release_commandblocks(sdev);
-				return 1;
+				return -ENOMEM;
 			}
 		} else if (sdev->host->cmd_per_lun != 0)
 			scsi_adjust_queue_depth(sdev, 0,
===== drivers/scsi/scsi.h 1.48 vs edited =====
--- 1.48/drivers/scsi/scsi.h	Thu Nov 28 01:25:58 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 28 14:09:53 2002
@@ -451,8 +451,10 @@
 extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern int scsi_track_queue_full(Scsi_Device *, int);
-extern int scsi_slave_attach(struct scsi_device *sdev);
-extern void scsi_slave_detach(struct scsi_device *sdev);
+extern int scsi_slave_attach(struct scsi_device *);
+extern void scsi_slave_detach(struct scsi_device *);
+extern int scsi_device_get(struct scsi_device *);
+extern void scsi_device_put(struct scsi_device *);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
===== drivers/scsi/scsi_scan.c 1.45 vs edited =====
--- 1.45/drivers/scsi/scsi_scan.c	Thu Nov 28 01:25:58 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 28 14:09:53 2002
@@ -1419,7 +1419,7 @@
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static int scsi_remove_lun(struct scsi_device *sdev)
+static void scsi_remove_lun(struct scsi_device *sdev)
 {
 	devfs_unregister(sdev->de);
 	device_unregister(&sdev->sdev_driverfs_dev);
===== drivers/scsi/scsi_syms.c 1.21 vs edited =====
--- 1.21/drivers/scsi/scsi_syms.c	Thu Nov 21 18:55:52 2002
+++ edited/drivers/scsi/scsi_syms.c	Thu Nov 28 14:09:53 2002
@@ -81,6 +81,8 @@
 EXPORT_SYMBOL(scsi_deregister_blocked_host);
 EXPORT_SYMBOL(scsi_slave_attach);
 EXPORT_SYMBOL(scsi_slave_detach);
+EXPORT_SYMBOL(scsi_device_get);
+EXPORT_SYMBOL(scsi_device_put);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
--- 1.41/drivers/scsi/sg.c	Thu Nov 21 19:00:56 2002
+++ edited/drivers/scsi/sg.c	Thu Nov 28 14:09:53 2002
@@ -259,9 +259,9 @@
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
-	if (!try_module_get(sdp->device->host->hostt->module))
-		return -ENXIO;
-	sdp->device->access_count++;
+	retval = scsi_device_get(sdp->device);
+	if (retval)
+		return retval;
 
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
@@ -314,8 +314,7 @@
 	return 0;
 
       error_out:
-	sdp->device->access_count--;
-	module_put(sdp->device->host->hostt->module);
+	scsi_device_put(sdp->device);
 	return retval;
 }
 
@@ -332,8 +331,7 @@
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
 		if (!sdp->detached) {
-			sdp->device->access_count--;
-			module_put(sdp->device->host->hostt->module);
+			scsi_device_put(sdp->device);
 		}
 		sdp->exclude = 0;
 		wake_up_interruptible(&sdp->o_excl_wait);
@@ -1296,8 +1294,7 @@
 		if (NULL == sfp->headrp) {
 			SCSI_LOG_TIMEOUT(1, printk("sg...bh: already closed, final cleanup\n"));
 			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
-				sdp->device->access_count--;
-				module_put(sdp->device->host->hostt->module);
+				scsi_device_put(sdp->device);
 			}
 			sfp = NULL;
 		}
@@ -1372,15 +1369,19 @@
 static int
 sg_attach(Scsi_Device * scsidp)
 {
-	struct gendisk *disk = alloc_disk(1);
+	struct gendisk *disk;
 	Sg_device *sdp = NULL;
 	unsigned long iflags;
-	int k;
+	int k, error;
 
+	disk = alloc_disk(1);
 	if (!disk)
-		return 1;
-	if (scsi_slave_attach(scsidp))
-		return 1;
+		return -ENOMEM;
+
+	error = scsi_slave_attach(scsidp);
+	if (error)
+		goto out_put;
+		
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
 	if (sg_nr_dev >= sg_dev_max) {	/* try to resize */
 		Sg_device **tmp_da;
@@ -1392,9 +1393,8 @@
 		if (NULL == tmp_da) {
 			printk(KERN_ERR
 			       "sg_attach: device array cannot be resized\n");
-			put_disk(disk);
-			scsi_slave_detach(scsidp);
-			return 1;
+			error = -ENOMEM;
+			goto out_detach;
 		}
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
 		memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
@@ -1418,9 +1418,8 @@
 		       scsidp->lun, scsidp->type, SG_MAX_DEVS_MASK);
 		if (NULL != sdp)
 			vfree((char *) sdp);
-		put_disk(disk);
-		scsi_slave_detach(scsidp);
-		return 1;
+		error = -ENODEV;
+		goto out_detach;
 	}
 	if (k < sg_dev_max) {
 		if (NULL == sdp) {
@@ -1435,9 +1434,8 @@
 	if (NULL == sdp) {
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 		printk(KERN_ERR "sg_attach: Sg_device cannot be allocated\n");
-		put_disk(disk);
-		scsi_slave_detach(scsidp);
-		return 1;
+		error = -ENOMEM;
+		goto out_detach;
 	}
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_attach: dev=%d \n", k));
@@ -1490,6 +1488,12 @@
 		       scsidp->lun, scsidp->type);
 	}
 	return 0;
+
+out_detach:
+	scsi_slave_detach(scsidp);
+out_put:
+	put_disk(disk);
+	return error;
 }
 
 static void
@@ -1521,8 +1525,7 @@
 						sg_finish_rem_req(srp);
 				}
 				if (sfp->closed) {
-					sdp->device->access_count--;
-					module_put(sdp->device->host->hostt->module);
+					scsi_device_put(sdp->device);
 					__sg_remove_sfp(sdp, sfp);
 				} else {
 					delay = 1;
@@ -2510,8 +2513,7 @@
 		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
 		/* only bump the access_count if we actually succeeded in
 		 * throwing another counter on the host module */
-		if(try_module_get(sdp->device->host->hostt->module))
-			sdp->device->access_count++;
+		scsi_device_get(sdp->device);	/* XXX: retval ignored? */	
 		sfp->closed = 1;	/* flag dirty state on this fd */
 		SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d writes pending\n",
 				  dirty));
===== drivers/scsi/sr.c 1.66 vs edited =====
--- 1.66/drivers/scsi/sr.c	Sun Nov 17 23:22:12 2002
+++ edited/drivers/scsi/sr.c	Thu Nov 28 14:09:53 2002
@@ -85,6 +85,8 @@
 static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
 
 static int sr_open(struct cdrom_device_info *, int);
+static void sr_release(struct cdrom_device_info *);
+
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
 
@@ -122,16 +124,6 @@
 	spin_unlock(&sr_devlist_lock);
 }
 
-static void sr_release(struct cdrom_device_info *cdi)
-{
-	struct scsi_cd *cd = cdi->handle;
-
-	if (cd->device->sector_size > 2048)
-		sr_set_blocklength(cd, 2048);
-	cd->device->access_count--;
-	module_put(cd->device->host->hostt->module);
-}
-
 static struct cdrom_device_ops sr_dops = {
 	.open			= sr_open,
 	.release	 	= sr_release,
@@ -458,43 +450,59 @@
 static int sr_open(struct cdrom_device_info *cdi, int purpose)
 {
 	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
+	int retval;
 
-	if (!cd->device)
-		return -ENXIO;	/* No such device */
+	retval = scsi_device_get(sdev);
+	if (retval)
+		return retval;
+	
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
 	 */
-	if (!scsi_block_when_processing_errors(cd->device)) {
-		return -ENXIO;
-	}
-	if(!try_module_get(cd->device->host->hostt->module))
-		return -ENXIO;
-	cd->device->access_count++;
+	retval = -ENXIO;
+	if (!scsi_block_when_processing_errors(sdev))
+		goto error_out;
 
-	/* If this device did not have media in the drive at boot time, then
+	/*
+	 * If this device did not have media in the drive at boot time, then
 	 * we would have been unable to get the sector size.  Check to see if
 	 * this is the case, and try again.
 	 */
-
 	if (cd->needs_sector_size)
 		get_sectorsize(cd);
-
 	return 0;
+
+error_out:
+	scsi_device_put(sdev);
+	return retval;	
+}
+
+static void sr_release(struct cdrom_device_info *cdi)
+{
+	struct scsi_cd *cd = cdi->handle;
+
+	if (cd->device->sector_size > 2048)
+		sr_set_blocklength(cd, 2048);
+
+	scsi_device_put(cd->device);
 }
 
 static int sr_attach(struct scsi_device *sdev)
 {
 	struct gendisk *disk;
 	struct scsi_cd *cd;
-	int minor;
+	int minor, error;
 
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		return 1;
 
-	if (scsi_slave_attach(sdev))
-		return 1;
+	error = scsi_slave_attach(sdev);
+	if (error)
+		return error;
 
+	error = -ENOMEM;
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
 		goto fail;
@@ -564,7 +572,7 @@
 	kfree(cd);
 fail:
 	scsi_slave_detach(sdev);
-	return 1;
+	return error;
 }
 
 
===== drivers/scsi/st.c 1.45 vs edited =====
--- 1.45/drivers/scsi/st.c	Sat Nov 23 00:25:00 2002
+++ edited/drivers/scsi/st.c	Thu Nov 28 15:36:39 2002
@@ -991,9 +991,9 @@
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
-	if(!try_module_get(STp->device->host->hostt->module))
+
+	if(!scsi_device_get(STp->device))
 		return (-ENXIO);
-	STp->device->access_count++;
 	STp->in_use = 1;
 	write_unlock(&st_dev_arr_lock);
 	STp->rew_at_close = STp->autorew_dev = (minor(inode->i_rdev) & 0x80) == 0;
@@ -1038,8 +1038,7 @@
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
-	STp->device->access_count--;
-	module_put(STp->device->host->hostt->module);
+	scsi_device_put(STp->device);
 	return retval;
 
 }
@@ -1172,8 +1171,7 @@
 	write_lock(&st_dev_arr_lock);
 	STp->in_use = 0;
 	write_unlock(&st_dev_arr_lock);
-	STp->device->access_count--;
-	module_put(STp->device->host->hostt->module);
+	scsi_device_put(STp->device);
 
 	return result;
 }
