From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] clean up sd bdev methods
Date: Thu, 28 Nov 2002 16:59:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021128165906.A1550@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1) move all bdev methods in one place instead of spreading them all
    around the file
(2) consistant naming: everything is sd_<operation> now
(3) use scsi_device_get/scsi_device_put
(4) remove bogus checks scsi_disk->device set, since 2.5.4x it always is
(5) clean up some coding style issues


--- 1.93/drivers/scsi/sd.c	Sun Nov 17 23:31:56 2002
+++ edited/drivers/scsi/sd.c	Thu Nov 28 15:39:22 2002
@@ -87,9 +87,6 @@
 static LIST_HEAD(sd_devlist);
 static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
 
-static int check_scsidisk_media_change(struct gendisk *);
-static int sd_revalidate(struct gendisk *);
-
 static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
@@ -148,91 +145,6 @@
 }
 
 /**
- *	sd_ioctl - process an ioctl
- *	@inode: only i_rdev member may be used
- *	@filp: only f_mode and f_flags may be used
- *	@cmd: ioctl command number
- *	@arg: this is third argument given to ioctl(2) system call.
- *	Often contains a pointer.
- *
- *	Returns 0 if successful (some ioctls return postive numbers on
- *	success as well). Returns a negated errno value in case of error.
- *
- *	Note: most ioctls are forward onto the block subsystem or further
- *	down in the scsi subsytem.
- **/
-static int sd_ioctl(struct inode * inode, struct file * filp, 
-		    unsigned int cmd, unsigned long arg)
-{
-	struct block_device *bdev = inode->i_bdev;
-	struct gendisk *disk = bdev->bd_disk;
-	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
-	sector_t capacity = sdkp->capacity;
-	struct Scsi_Host *host;
-	int diskinfo[4];
-	int error;
-    
-	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
-						disk->disk_name, cmd));
-	if (!sdp)
-		return -ENODEV;
-	/*
-	 * If we are in the middle of error recovery, don't let anyone
-	 * else try and use this device.  Also, if error recovery fails, it
-	 * may try and take the device offline, in which case all further
-	 * access to the device is prohibited.
-	 */
-
-	if (!scsi_block_when_processing_errors(sdp))
-		return -ENODEV;
-
-	error = scsi_cmd_ioctl(bdev, cmd, arg);
-	if (error != -ENOTTY)
-		return error;
-
-	switch (cmd) {
-		case HDIO_GETGEO:   /* Return BIOS disk parameters */
-		{
-			struct hd_geometry *loc = (struct hd_geometry *)arg;
-
-			if (!loc)
-				return -EINVAL;
-
-			host = sdp->host;
-	
-			/* default to most commonly used values */
-	
-		        diskinfo[0] = 0x40;	/* 1 << 6 */
-	        	diskinfo[1] = 0x20;	/* 1 << 5 */
-	        	diskinfo[2] = sdkp->capacity >> 11;
-	
-			/* override with calculated, extended default, 
-			   or driver values */
-	
-			if (host->hostt->bios_param) {
-				host->hostt->bios_param(sdp, bdev,
-							capacity, diskinfo);
-			} else
-				scsicam_bios_param(bdev, capacity, diskinfo);
-
-			if (put_user(diskinfo[0], &loc->heads))
-				return -EFAULT;
-			if (put_user(diskinfo[1], &loc->sectors))
-				return -EFAULT;
-			if (put_user(diskinfo[2], &loc->cylinders))
-				return -EFAULT;
-			if (put_user((unsigned)get_start_sect(bdev),
-				     (unsigned long *)&loc->start))
-				return -EFAULT;
-			return 0;
-		}
-		default:
-			return scsi_ioctl(sdp, cmd, (void *)arg);
-	}
-}
-
-/**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
  *	@SCpnt: pointer to mid-level's per scsi command structure that
@@ -434,68 +346,61 @@
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device * sdp = sdkp->device;
-	int retval = -ENXIO;
+	struct scsi_device *sdev = sdkp->device;
+	int retval;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
 
-	if (!sdkp)
-		return -ENXIO;	/* No such device */
+	retval = scsi_device_get(sdev);
+	if (retval)
+		return retval;
 
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
 	 */
-	if (!scsi_block_when_processing_errors(sdp))
-		return -ENXIO;
-	/*
-	 * The following code can sleep.
-	 * Module unloading must be prevented
-	 */
-	if(!try_module_get(sdp->host->hostt->module))
-		return -ENOMEM;
-	sdp->access_count++;
+	retval = -ENXIO;
+	if (!scsi_block_when_processing_errors(sdev))
+		goto error_out;
 
-	if (sdp->removable) {
+	if (sdev->removable) {
 		check_disk_change(inode->i_bdev);
 
 		/*
 		 * If the drive is empty, just let the open fail.
 		 */
-		if ((!sdkp->media_present) && !(filp->f_flags & O_NDELAY)) {
-			retval = -ENOMEDIUM;
+		retval = -ENOMEDIUM;
+		if ((!sdkp->media_present) && !(filp->f_flags & O_NDELAY))
 			goto error_out;
-		}
 
 		/*
 		 * Similarly, if the device has the write protect tab set,
 		 * have the open fail if the user expects to be able to write
 		 * to the thing.
 		 */
-		if ((sdkp->write_prot) && (filp->f_mode & FMODE_WRITE)) {
-			retval = -EROFS;
+		retval = -EROFS;
+		if ((sdkp->write_prot) && (filp->f_mode & FMODE_WRITE))
 			goto error_out;
-		}
 	}
+
 	/*
-	 * It is possible that the disk changing stuff resulted in the device
-	 * being taken offline.  If this is the case, report this to the user,
-	 * and don't pretend that the open actually succeeded.
+	 * It is possible that the disk changing stuff resulted in
+	 * the device being taken offline.  If this is the case,
+	 * report this to the user, and don't pretend that the
+	 * open actually succeeded.
 	 */
-	if (!sdp->online) {
+	retval = -ENXIO;
+	if (!sdev->online)
 		goto error_out;
-	}
 
-	if (sdp->removable)
-		if (sdp->access_count==1)
-			if (scsi_block_when_processing_errors(sdp))
-				scsi_set_medium_removal(sdp, SCSI_REMOVAL_PREVENT);
+	if (sdev->removable && sdev->access_count == 1)
+		if (scsi_block_when_processing_errors(sdev))
+			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 
 	return 0;
 
 error_out:
-	sdp->access_count--;
-	module_put(sdp->host->hostt->module);
+	scsi_device_put(sdev);
 	return retval;	
 }
 
@@ -513,36 +418,189 @@
 static int sd_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
+	struct scsi_device *sdev = scsi_disk(disk)->device;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
-	if (!sdp)
-		return -ENODEV; /* open uses ENXIO ?? */
 
-	/* ... and what if there are packets in flight and this close()
-	 * is followed by a "rmmod sd_mod" */
+	if (sdev->removable && sdev->access_count == 1)
+		if (scsi_block_when_processing_errors(sdev))
+			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
+
+	/*
+	 * XXX and what if there are packets in flight and this close()
+	 * XXX is followed by a "rmmod sd_mod"?
+	 */
+	scsi_device_put(sdev);
+	return 0;
+}
 
-	sdp->access_count--;
+static int sd_hdio_getgeo(struct block_device *bdev, struct hd_geometry *loc)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdp = sdkp->device;
+	struct Scsi_Host *host = sdp->host;
+	int diskinfo[4];
 
-	if (sdp->removable) {
-		if (!sdp->access_count)
-			if (scsi_block_when_processing_errors(sdp))
-				scsi_set_medium_removal(sdp, SCSI_REMOVAL_ALLOW);
-	}
-	module_put(sdp->host->hostt->module);
+	/* default to most commonly used values */
+        diskinfo[0] = 0x40;	/* 1 << 6 */
+       	diskinfo[1] = 0x20;	/* 1 << 5 */
+       	diskinfo[2] = sdkp->capacity >> 11;
+	
+	/* override with calculated, extended default, or driver values */
+	if (host->hostt->bios_param)
+		host->hostt->bios_param(sdp, bdev, sdkp->capacity, diskinfo);
+	else
+		scsicam_bios_param(bdev, sdkp->capacity, diskinfo);
 
+	if (put_user(diskinfo[0], &loc->heads))
+		return -EFAULT;
+	if (put_user(diskinfo[1], &loc->sectors))
+		return -EFAULT;
+	if (put_user(diskinfo[2], &loc->cylinders))
+		return -EFAULT;
+	if (put_user((unsigned)get_start_sect(bdev),
+	             (unsigned long *)&loc->start))
+		return -EFAULT;
 	return 0;
 }
 
-static struct block_device_operations sd_fops =
+/**
+ *	sd_ioctl - process an ioctl
+ *	@inode: only i_rdev/i_bdev members may be used
+ *	@filp: only f_mode and f_flags may be used
+ *	@cmd: ioctl command number
+ *	@arg: this is third argument given to ioctl(2) system call.
+ *	Often contains a pointer.
+ *
+ *	Returns 0 if successful (some ioctls return postive numbers on
+ *	success as well). Returns a negated errno value in case of error.
+ *
+ *	Note: most ioctls are forward onto the block subsystem or further
+ *	down in the scsi subsytem.
+ **/
+static int sd_ioctl(struct inode * inode, struct file * filp, 
+		    unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+	struct scsi_device *sdp = scsi_disk(disk)->device;
+	int error;
+    
+	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
+						disk->disk_name, cmd));
+
+	/*
+	 * If we are in the middle of error recovery, don't let anyone
+	 * else try and use this device.  Also, if error recovery fails, it
+	 * may try and take the device offline, in which case all further
+	 * access to the device is prohibited.
+	 */
+	if (!scsi_block_when_processing_errors(sdp))
+		return -ENODEV;
+
+	if (cmd == HDIO_GETGEO) {
+		if (!arg)
+			return -EINVAL;
+		return sd_hdio_getgeo(bdev, (struct hd_geometry *)arg);
+	}
+
+	error = scsi_cmd_ioctl(bdev, cmd, arg);
+	if (error != -ENOTTY)
+		return error;
+	return scsi_ioctl(sdp, cmd, (void *)arg);
+}
+
+static void set_media_not_present(struct scsi_disk *sdkp)
 {
-	.owner		= THIS_MODULE,
-	.open		= sd_open,
-	.release	= sd_release,
-	.ioctl		= sd_ioctl,
-	.media_changed	= check_scsidisk_media_change,
-	.revalidate_disk= sd_revalidate
+	sdkp->media_present = 0;
+	sdkp->capacity = 0;
+	sdkp->device->changed = 1;
+}
+
+/**
+ *	sd_media_changed - check if our medium changed
+ *	@disk: kernel device descriptor 
+ *
+ *	Returns 0 if not applicable or no change; 1 if change
+ *
+ *	Note: this function is invoked from the block subsystem.
+ **/
+static int sd_media_changed(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	int retval;
+
+	SCSI_LOG_HLQUEUE(3, printk("sd_media_changed: disk=%s\n",
+						disk->disk_name));
+
+	if (!sdp->removable)
+		return 0;
+
+	/*
+	 * If the device is offline, don't send any commands - just pretend as
+	 * if the command failed.  If the device ever comes back online, we
+	 * can deal with it then.  It is only because of unrecoverable errors
+	 * that we would ever take a device offline in the first place.
+	 */
+	if (!sdp->online)
+		goto not_present;
+
+	/*
+	 * Using TEST_UNIT_READY enables differentiation between drive with
+	 * no cartridge loaded - NOT READY, drive with changed cartridge -
+	 * UNIT ATTENTION, or with same cartridge - GOOD STATUS.
+	 *
+	 * Drives that auto spin down. eg iomega jaz 1G, will be started
+	 * by sd_spinup_disk() from sd_init_onedisk(), which happens whenever
+	 * sd_revalidate() is called.
+	 */
+	retval = -ENODEV;
+	if (scsi_block_when_processing_errors(sdp))
+		retval = scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL);
+
+	/*
+	 * Unable to test, unit probably not ready.   This usually
+	 * means there is no disc in the drive.  Mark as changed,
+	 * and we will figure it out later once the drive is
+	 * available again.
+	 */
+	if (retval)
+		 goto not_present;
+
+	/*
+	 * For removable scsi disk we have to recognise the presence
+	 * of a disk in the drive. This is kept in the struct scsi_disk
+	 * struct and tested at open !  Daniel Roche (dan@lectra.fr)
+	 */
+	sdkp->media_present = 1;
+
+	retval = sdp->changed;
+	sdp->changed = 0;
+
+	return retval;
+
+not_present:
+	set_media_not_present(sdkp);
+	return 1;
+}
+
+static int sd_revalidate_disk(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+
+	sd_init_onedisk(sdkp, disk);
+	set_capacity(disk, sdkp->capacity);
+	return 0;
+}
+
+static struct block_device_operations sd_fops = {
+	.owner			= THIS_MODULE,
+	.open			= sd_open,
+	.release		= sd_release,
+	.ioctl			= sd_ioctl,
+	.media_changed		= sd_media_changed,
+	.revalidate_disk	= sd_revalidate_disk,
 };
 
 /**
@@ -647,99 +705,20 @@
 	scsi_io_completion(SCpnt, good_sectors, block_sectors);
 }
 
-static void
-sd_set_media_not_present(struct scsi_disk *sdkp) {
-	sdkp->media_present = 0;
-	sdkp->capacity = 0;
-	sdkp->device->changed = 1;
-}
-
-/**
- *	check_scsidisk_media_change - self descriptive
- *	@full_dev: kernel device descriptor (kdev_t)
- *
- *	Returns 0 if not applicable or no change; 1 if change
- *
- *	Note: this function is invoked from the block subsystem.
- **/
-static int check_scsidisk_media_change(struct gendisk *disk)
+static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
 {
-	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
-	int retval;
-	int flag = 0;	/* <<<< what is this for?? */
-
-	SCSI_LOG_HLQUEUE(3, printk("check_scsidisk_media_change: "
-			    "disk=%s\n", disk->disk_name));
-	if (!sdp) {
-		printk(KERN_ERR "check_scsidisk_media_change: disk=%s, "
-		       "invalid device\n", disk->disk_name);
+	if (!srp->sr_result)
 		return 0;
-	}
-	if (!sdp->removable)
+	if (!(driver_byte(srp->sr_result) & DRIVER_SENSE))
+		return 0;
+	if (srp->sr_sense_buffer[2] != NOT_READY &&
+	    srp->sr_sense_buffer[2] != UNIT_ATTENTION)
+	    	return 0;
+	if (srp->sr_sense_buffer[12] != 0x3A) /* medium not present */
 		return 0;
 
-	/*
-	 * If the device is offline, don't send any commands - just pretend as
-	 * if the command failed.  If the device ever comes back online, we
-	 * can deal with it then.  It is only because of unrecoverable errors
-	 * that we would ever take a device offline in the first place.
-	 */
-	if (sdp->online == FALSE) {
-		sd_set_media_not_present(sdkp);
-		return 1;	/* This will force a flush, if called from
-				 * check_disk_change */
-	}
-
-	/* Using TEST_UNIT_READY enables differentiation between drive with
-	 * no cartridge loaded - NOT READY, drive with changed cartridge -
-	 * UNIT ATTENTION, or with same cartridge - GOOD STATUS.
-	 *
-	 * Drives that auto spin down. eg iomega jaz 1G, will be started
-	 * by sd_spinup_disk() from sd_init_onedisk(), which happens whenever
-	 * sd_revalidate() is called.
-	 */
-	retval = -ENODEV;
-	if (scsi_block_when_processing_errors(sdp))
-		retval = scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL);
-
-	if (retval) {		/* Unable to test, unit probably not ready.
-				 * This usually means there is no disc in the
-				 * drive.  Mark as changed, and we will figure
-				 * it out later once the drive is available
-				 * again.  */
-
-		sd_set_media_not_present(sdkp);
-		return 1;	/* This will force a flush, if called from
-				 * check_disk_change */
-	}
-	/*
-	 * For removable scsi disk we have to recognise the presence
-	 * of a disk in the drive. This is kept in the struct scsi_disk
-	 * struct and tested at open !  Daniel Roche ( dan@lectra.fr )
-	 */
-
-	sdkp->media_present = 1;
-
-	retval = sdp->changed;
-	if (!flag)
-		sdp->changed = 0;
-	return retval;
-}
-
-static int
-sd_media_not_present(struct scsi_disk *sdkp, struct scsi_request *SRpnt) {
-	int the_result = SRpnt->sr_result;
-
-	if (the_result != 0
-	    && (driver_byte(the_result) & DRIVER_SENSE) != 0
-	    && (SRpnt->sr_sense_buffer[2] == NOT_READY ||
-		SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION)
-	    && SRpnt->sr_sense_buffer[12] == 0x3A /* medium not present */) {
-		sd_set_media_not_present(sdkp);
-		return 1;
-	}
-	return 0;
+	set_media_not_present(sdkp);
+	return 1;
 }
 
 /*
@@ -783,7 +762,7 @@
 		 * any media in it, don't bother with any of the rest of
 		 * this crap.
 		 */
-		if (sd_media_not_present(sdkp, SRpnt))
+		if (media_not_present(sdkp, SRpnt))
 			return;
 
 		/* Look for devices that return NOT_READY.
@@ -926,7 +905,7 @@
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
 			      8, SD_TIMEOUT, SD_MAX_RETRIES);
 
-		if (sd_media_not_present(sdkp, SRpnt))
+		if (media_not_present(sdkp, SRpnt))
 			return;
 
 		the_result = SRpnt->sr_result;
@@ -1176,18 +1155,20 @@
 static int sd_attach(struct scsi_device * sdp)
 {
 	struct scsi_disk *sdkp = NULL;	/* shut up lame gcc warning */
-	int dsk_nr;
 	struct gendisk *gd;
+	int dsk_nr, error;
 
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
-		return 0;
+		return 1;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
-	if (scsi_slave_attach(sdp))
+	error = scsi_slave_attach(sdp);
+	if (error)
 		goto out;
 
+	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
 		goto out_detach;
@@ -1244,19 +1225,7 @@
 out_detach:
 	scsi_slave_detach(sdp);
 out:
-	return 1;
-}
-
-static int sd_revalidate(struct gendisk *disk)
-{
-	struct scsi_disk *sdkp = scsi_disk(disk);
-
-	if (!sdkp->device)
-		return -ENODEV;
-
-	sd_init_onedisk(sdkp, disk);
-	set_capacity(disk, sdkp->capacity);
-	return 0;
+	return error;
 }
 
 /**
