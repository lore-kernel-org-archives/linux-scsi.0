From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some sd.c code consolidation
Date: Mon, 9 Jun 2003 18:24:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609162402.GA1890@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:48014 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264494AbTFIQK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 12:10:26 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

fold sd_init_onedisk into sd_revalidate_disk and sd_synchronize_cache
into sd_shutdown.


diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sun Jun  8 20:33:57 2003
+++ b/drivers/scsi/sd.c	Sun Jun  8 20:33:57 2003
@@ -88,7 +88,7 @@
 static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
 
-static void sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk);
+static int sd_revalidate_disk(struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
 static int sd_probe(struct device *);
@@ -96,7 +96,6 @@
 static void sd_shutdown(struct device *dev);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
-static int sd_synchronize_cache(struct scsi_disk *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
 		 struct scsi_request *SRpnt, unsigned char *buffer);
 
@@ -570,7 +569,7 @@
 	 * UNIT ATTENTION, or with same cartridge - GOOD STATUS.
 	 *
 	 * Drives that auto spin down. eg iomega jaz 1G, will be started
-	 * by sd_spinup_disk() from sd_init_onedisk(), which happens whenever
+	 * by sd_spinup_disk() from sd_revalidate_disk(), which happens whenever
 	 * sd_revalidate() is called.
 	 */
 	retval = -ENODEV;
@@ -636,15 +635,6 @@
 	kfree(buffer);
 }
 
-static int sd_revalidate_disk(struct gendisk *disk)
-{
-	struct scsi_disk *sdkp = scsi_disk(disk);
-
-	sd_init_onedisk(sdkp, disk);
-	set_capacity(disk, sdkp->capacity);
-	return 0;
-}
-
 static struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
@@ -776,7 +766,7 @@
 }
 
 /*
- * spinup disk - called only in sd_init_onedisk()
+ * spinup disk - called only in sd_revalidate_disk()
  */
 static void
 sd_spinup_disk(struct scsi_disk *sdkp, char *diskname,
@@ -896,7 +886,7 @@
 }
 
 /*
- * read disk capacity - called only in sd_init_onedisk()
+ * read disk capacity
  */
 static void
 sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
@@ -1109,7 +1099,7 @@
 }
 
 /*
- * read write protect setting, if possible - called only in sd_init_onedisk()
+ * read write protect setting, if possible - called only in sd_revalidate_disk()
  * called with buffer of length 512
  */
 static void
@@ -1151,7 +1141,7 @@
 }
 
 /*
- * sd_read_cache_type - called only from sd_init_onedisk()
+ * sd_read_cache_type - called only from sd_revalidate_disk()
  * called with buffer of length 512
  */
 static void
@@ -1210,71 +1200,72 @@
 }
 
 /**
- *	sd_init_onedisk - called the first time a new disk is seen,
+ *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
- *	@sdkp: pointer to associated struct scsi_disk object
- *	@dsk_nr: disk number within this driver (e.g. 0->/dev/sda,
- *	1->/dev/sdb, etc)
- *
- *	Note: this function is local to this driver.
+ *	@disk: struct gendisk we care about
  **/
-static void
-sd_init_onedisk(struct scsi_disk * sdkp, struct gendisk *disk)
+static int sd_revalidate_disk(struct gendisk *disk)
 {
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_request *sreq;
 	unsigned char *buffer;
-	struct scsi_device *sdp;
-	struct scsi_request *SRpnt;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_init_onedisk: disk=%s\n", disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, printk("sd_revalidate_disk: disk=%s\n", disk->disk_name));
 
 	/*
 	 * If the device is offline, don't try and read capacity or any
 	 * of the other niceties.
 	 */
-	sdp = sdkp->device;
-	if (sdp->online == FALSE)
-		return;
+	if (!sdp->online)
+		goto out;
 
-	SRpnt = scsi_allocate_request(sdp);
-	if (!SRpnt) {
-		printk(KERN_WARNING "(sd_init_onedisk:) Request allocation "
+	sreq = scsi_allocate_request(sdp);
+	if (!sreq) {
+		printk(KERN_WARNING "(sd_revalidate_disk:) Request allocation "
 		       "failure.\n");
-		return;
+		goto out;
 	}
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL | __GFP_DMA);
 	if (!buffer) {
-		printk(KERN_WARNING "(sd_init_onedisk:) Memory allocation "
+		printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
 		       "failure.\n");
-		goto leave;
+		goto out_release_request;
 	}
 
 	/* defaults, until the device tells us otherwise */
+	sdp->sector_size = 512;
 	sdkp->capacity = 0;
-	sdkp->device->sector_size = 512;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 
-	sd_spinup_disk(sdkp, disk->disk_name, SRpnt, buffer);
+	sd_spinup_disk(sdkp, disk->disk_name, sreq, buffer);
 
-	if (sdkp->media_present)
-		sd_read_capacity(sdkp, disk->disk_name, SRpnt, buffer);
-	
-	if (sdp->removable && sdkp->media_present)
-		sd_read_write_protect_flag(sdkp, disk->disk_name, SRpnt, buffer);
-	/* without media there is no reason to ask;
-	   moreover, some devices react badly if we do */
-	if (sdkp->media_present)
-		sd_read_cache_type(sdkp, disk->disk_name, SRpnt, buffer);
+	/*
+	 * Without media there is no reason to ask; moreover, some devices
+	 * react badly if we do.
+	 */
+	if (sdkp->media_present) {
+		sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
+		if (sdp->removable)
+			sd_read_write_protect_flag(sdkp, disk->disk_name,
+					sreq, buffer);
+		sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
+	}
 		
-	SRpnt->sr_device->use_10_for_rw = 1;
-	SRpnt->sr_device->use_10_for_ms = 0;
- leave:
-	scsi_release_request(SRpnt);
+	sdp->use_10_for_rw = 1;
+	sdp->use_10_for_ms = 0;
 
+	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
+
+ out_release_request: 
+	scsi_release_request(sreq);
+ out:
+	return 0;
 }
 
 /**
@@ -1349,7 +1340,7 @@
 
 	strcpy(gd->devfs_name, sdp->devfs_name);
 
-	sd_init_onedisk(sdkp, gd);
+	sd_revalidate_disk(gd);
 
 	gd->driverfs_dev = &sdp->sdev_driverfs_dev;
 	gd->flags = GENHD_FL_DRIVERFS;
@@ -1358,7 +1349,6 @@
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
-	set_capacity(gd, sdkp->capacity);
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
@@ -1405,16 +1395,57 @@
 	return 0;
 }
 
+/*
+ * Send a SYNCHRONIZE CACHE instruction down to the device through
+ * the normal SCSI command structure.  Wait for the command to
+ * complete.
+ */
 static void sd_shutdown(struct device *dev)
 {
+	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_request *sreq;
+	int retries, res;
+
+	if (!sdp->online || !sdkp->WCE)
+		return;
+
+	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: ",
+			sdkp->disk->disk_name);
+
+	sreq = scsi_allocate_request(sdp);
+	if (!sreq) {
+		printk("FAILED\n  No memory for request\n");
+		return;
+	}
 
-	if (sdkp->WCE) {
-		printk(KERN_NOTICE "Synchronizing SCSI cache: ");
-		sd_synchronize_cache(sdkp, 1);
-		printk("\n");
+	sreq->sr_data_direction = SCSI_DATA_NONE;
+	for (retries = 3; retries > 0; --retries) {
+		unsigned char cmd[10] = { 0 };
+
+		cmd[0] = SYNCHRONIZE_CACHE;
+		/*
+		 * Leave the rest of the command zero to indicate
+		 * flush everything.
+		 */
+		scsi_wait_req(sreq, cmd, NULL, 0, SD_TIMEOUT, SD_MAX_RETRIES);
+		if (sreq->sr_result == 0)
+			break;
 	}
-}
+
+	res = sreq->sr_result;
+	if (res) {
+		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n  ",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+			if (driver_byte(res) & DRIVER_SENSE)
+				print_req_sense("sd", sreq);
+	}
+	
+	scsi_release_request(sreq);
+	printk("\n");
+}	
 
 /**
  *	init_sd - entry point for this driver (both when built in or when
@@ -1452,60 +1483,6 @@
 	scsi_unregister_driver(&sd_template.gendrv);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
-}
-
-/* send a SYNCHRONIZE CACHE instruction down to the device through the
- * normal SCSI command structure.  Wait for the command to complete (must
- * have user context) */
-static int sd_synchronize_cache(struct scsi_disk *sdkp, int verbose)
-{
-	struct scsi_request *SRpnt;
-	struct scsi_device *SDpnt = sdkp->device;
-	int retries, the_result;
-
-	if (!SDpnt->online)
-		return 0;
-
-	if (verbose)
-		printk("%s ", sdkp->disk->disk_name);
-
-	SRpnt = scsi_allocate_request(SDpnt);
-	if(!SRpnt) {
-		if(verbose)
-			printk("FAILED\n  No memory for request\n");
-		return 0;
-	}
-
-	SRpnt->sr_data_direction = SCSI_DATA_NONE;
-
-	for(retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/* leave the rest of the command zero to indicate 
-		 * flush everything */
-		scsi_wait_req(SRpnt, (void *)cmd, NULL, 0,
-			      SD_TIMEOUT, SD_MAX_RETRIES);
-
-		if(SRpnt->sr_result == 0)
-			break;
-	}
-
-	the_result = SRpnt->sr_result;
-	if(verbose) {
-		if(the_result != 0) {
-			printk("FAILED\n  status = %x, message = %02x, host = %d, driver = %02x\n  ",
-			       status_byte(the_result),
-			       msg_byte(the_result),
-			       host_byte(the_result),
-			       driver_byte(the_result));
-			if (driver_byte(the_result) & DRIVER_SENSE)
-				print_req_sense("sd", SRpnt);
-
-		}
-	}
-	scsi_release_request(SRpnt);
-	return (the_result == 0);
 }
 
 MODULE_LICENSE("GPL");
