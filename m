From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Missing media patch sd.c 2.4.19
Date: Sun, 29 Sep 2002 12:55:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020929125502.0a01ef20.Scsi@PragmaSoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mdharm-usb@one-eyed-alien.net

My linux system (RH 7.1 w/ LK 2.4.19) has an SanDisk Imagemate (SDDR31) compact flash card reader connected to one of its USB ports.  My system is typically booted without any media inserted in the reader.  I recently became frustrated with the number error messages (read capacity, sense buffer, can't read partition table, etc.) that appear in my logs under this scenerio.

After quite a bit of poking around, I've come to the impression that most of the problem lies with the handling of "missing" media errors in the scsi disk driver.  I noticed that some work has been in this area for the LK 2.5 series, but was unable to locate any patches for LK 2.4.19.

As such, I have developed the following patch for the version of sd.c included in the Linux 2.4.19 Kernel.  I did not attempt to "back-port" any of the changes from the LK 2.5 tree, but focused instead on the smallest/safest patch to correct this problem in 2.4.19.

Comments/suggestions welcomed.  Best regards, Scott.

--- linux-2.4.19/drivers/scsi/sd.org	Sun Sep 29 11:02:28 2002
+++ linux-2.4.19/drivers/scsi/sd.c	Sun Sep 29 11:03:40 2002
@@ -28,6 +28,9 @@
  *	
  *	 Modified by Alex Davis <letmein@erols.com>
  *       Fix problem where removable media could be ejected after sd_open.
+ *
+ *       Modified by Scott Merritt <scsi@pragmasoft.com.>
+ *       Fix problems when removable media not present during boot.
  */
 
 #include <linux/config.h>
@@ -774,6 +777,8 @@
 	int sector_size;
 	Scsi_Request *SRpnt;
 
+	rscsi_disks[i].ready = 0;  /* not ready until proven otherwise */
+
 	/*
 	 * Get the name of the disk, in case we need to log it somewhere.
 	 */
@@ -839,13 +844,14 @@
 		 */
 		if( the_result != 0
 		    && ((driver_byte(the_result) & DRIVER_SENSE) != 0)
-		    && SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION
+		    && (SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION ||
+			SRpnt->sr_sense_buffer[2] == NOT_READY)
 		    && SRpnt->sr_sense_buffer[12] == 0x3A ) {
 			rscsi_disks[i].capacity = 0x1fffff;
 			sector_size = 512;
 			rscsi_disks[i].device->changed = 1;
 			rscsi_disks[i].ready = 0;
-			break;
+			goto exit_out;
 		}
 
 		/* Look for non-removable devices that return NOT_READY.
@@ -1075,6 +1081,8 @@
 	SRpnt->sr_device->ten = 1;
 	SRpnt->sr_device->remap = 1;
 	SRpnt->sr_device->sector_size = sector_size;
+
+exit_out:
 	/* Wake up a process waiting for device */
 	scsi_release_request(SRpnt);
 	SRpnt = NULL;
@@ -1236,7 +1244,7 @@
 	for (i = 0; i < sd_template.dev_max; ++i)
 		if (!rscsi_disks[i].capacity && rscsi_disks[i].device) {
 			sd_init_onedisk(i);
-			if (!rscsi_disks[i].has_part_table) {
+			if (rscsi_disks[i].ready && !rscsi_disks[i].has_part_table) {
 				sd_sizes[i << 4] = rscsi_disks[i].capacity;
 				register_disk(&SD_GENDISK(i), MKDEV_SD(i),
 						1<<4, &sd_fops,
@@ -1364,7 +1372,8 @@
 	MAYBE_REINIT;
 #endif
 
-	grok_partitions(&SD_GENDISK(target), target % SCSI_DISKS_PER_MAJOR,
+	if (rscsi_disks[target].ready)
+                grok_partitions(&SD_GENDISK(target), target % SCSI_DISKS_PER_MAJOR,
 			1<<4, CAPACITY);
 
 	DEVICE_BUSY = 0;
