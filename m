From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 4/4] sd: misc checkpatch.pl fixes
Date: Wed, 29 Apr 2009 22:09:33 +0200
Message-ID: <200904292209.33446.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:40971 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZD2UHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:07:20 -0400
Received: by bwz7 with SMTP id 7so1401173bwz.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 13:07:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Fix

	ERROR: trailing whitespace
	ERROR: code indent should use tabs where possible
	WARNING: line over 80 characters
	WARNING: braces {} are not necessary for single statement blocks
	ERROR: switch and case should be at the same indent
	ERROR: space required before the open parenthesis '('

issues detected by checkpatch.pl.

While at it:
- remove superfluous 'ret' local variable in sd_compat_ioctl()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/sd.c |  128 +++++++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 62 deletions(-)

Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -7,20 +7,20 @@
  *              Subsequent revisions: Eric Youngdale
  *	Modification history:
  *       - Drew Eckhardt <drew@colorado.edu> original
- *       - Eric Youngdale <eric@andante.org> add scatter-gather, multiple 
+ *	 - Eric Youngdale <eric@andante.org> add scatter-gather, multiple
  *         outstanding request, and other enhancements.
  *         Support loadable low-level scsi drivers.
- *       - Jirka Hanika <geo@ff.cuni.cz> support more scsi disks using 
+ *	 - Jirka Hanika <geo@ff.cuni.cz> support more scsi disks using
  *         eight major numbers.
  *       - Richard Gooch <rgooch@atnf.csiro.au> support devfs.
- *	 - Torben Mathiasen <tmm@image.dk> Resource allocation fixes in 
+ *	 - Torben Mathiasen <tmm@image.dk> Resource allocation fixes in
  *	   sd_init and cleanups.
  *	 - Alex Davis <letmein@erols.com> Fix problem where partition info
- *	   not being read in sd_open. Fix problem where removable media 
+ *	   not being read in sd_open. Fix problem where removable media
  *	   could be ejected after sd_open.
  *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
- *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox 
- *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>: 
+ *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox
+ *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>:
  *	   Support 32k/1M disks.
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
@@ -29,7 +29,7 @@
  *	 - entering sd_ioctl: SCSI_LOG_IOCTL level 1
  *	 - entering other commands: SCSI_LOG_HLQUEUE level 3
  *	Note: when the logging level is set by the user, it must be greater
- *	than the level indicated above to trigger output.	
+ *	than the level indicated above to trigger output.
  */
 
 #include <linux/module.h>
@@ -296,16 +296,16 @@ static struct scsi_driver sd_template = 
 
 /*
  * Device no to disk mapping:
- * 
+ *
  *       major         disc2     disc  p1
  *   |............|.............|....|....| <- dev_t
  *    31        20 19          8 7  4 3  0
- * 
+ *
  * Inside a major, we have 16k disks, however mapped non-
  * contiguously. The first 16 disks are for major0, the next
- * ones with major1, ... Disk 256 is for major0 again, disk 272 
- * for major1, ... 
- * As we stay compatible with our numbering scheme, we can reuse 
+ * ones with major1, ... Disk 256 is for major0 again, disk 272
+ * for major1, ...
+ * As we stay compatible with our numbering scheme, we can reuse
  * the well-know SCSI majors 8, 65--71, 136--143.
  */
 static int sd_major(int major_idx)
@@ -412,7 +412,7 @@ static int sd_prep_fn(struct request_que
 					this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
- 	    block + rq->nr_sectors > get_capacity(disk)) {
+	    block + rq->nr_sectors > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Finishing %ld sectors\n",
 						rq->nr_sectors));
@@ -423,10 +423,11 @@ static int sd_prep_fn(struct request_que
 
 	if (sdp->changed) {
 		/*
-		 * quietly refuse to do anything to a changed disc until 
+		 * quietly refuse to do anything to a changed disc until
 		 * the changed bit has been reset
 		 */
-		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
+		/* printk("SCSI disk has been changed. Prohibiting "
+			  "further I/O.\n"); */
 		goto out;
 	}
 
@@ -492,9 +493,9 @@ static int sd_prep_fn(struct request_que
 		}
 	}
 	if (rq_data_dir(rq) == WRITE) {
-		if (!sdp->writeable) {
+		if (!sdp->writeable)
 			goto out;
-		}
+
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 
@@ -506,7 +507,8 @@ static int sd_prep_fn(struct request_que
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
+		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n",
+			    rq->cmd_flags);
 		goto out;
 	}
 
@@ -603,7 +605,7 @@ static int sd_prep_fn(struct request_que
  *	@inode: only i_rdev member may be used
  *	@filp: only f_mode and f_flags may be used
  *
- *	Returns 0 if successful. Returns a negated errno value in case 
+ *	Returns 0 if successful. Returns a negated errno value in case
  *	of error.
  *
  *	Note: This can be called from a user context (e.g. fsck(1) )
@@ -669,7 +671,7 @@ static int sd_open(struct block_device *
 
 error_out:
 	scsi_disk_put(sdkp);
-	return retval;	
+	return retval;
 }
 
 /**
@@ -678,7 +680,7 @@ error_out:
  *	@inode: only i_rdev member may be used
  *	@filp: only f_mode and f_flags may be used
  *
- *	Returns 0. 
+ *	Returns 0.
  *
  *	Note: may block (uninterruptible) if error recovery is underway
  *	on this disk.
@@ -711,10 +713,10 @@ static int sd_getgeo(struct block_device
 	int diskinfo[4];
 
 	/* default to most commonly used values */
-        diskinfo[0] = 0x40;	/* 1 << 6 */
-       	diskinfo[1] = 0x20;	/* 1 << 5 */
-       	diskinfo[2] = sdkp->capacity >> 11;
-	
+	diskinfo[0] = 0x40;	/* 1 << 6 */
+	diskinfo[1] = 0x20;	/* 1 << 5 */
+	diskinfo[2] = sdkp->capacity >> 11;
+
 	/* override with calculated, extended default, or driver values */
 	if (host->hostt->bios_param)
 		host->hostt->bios_param(sdp, bdev, sdkp->capacity, diskinfo);
@@ -769,13 +771,13 @@ static int sd_ioctl(struct block_device 
 	 * resolved.
 	 */
 	switch (cmd) {
-		case SCSI_IOCTL_GET_IDLUN:
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			return scsi_ioctl(sdp, cmd, p);
-		default:
-			error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
-			if (error != -ENOTTY)
-				return error;
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+		return scsi_ioctl(sdp, cmd, p);
+	default:
+		error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
+		if (error != -ENOTTY)
+			return error;
 	}
 	return scsi_ioctl(sdp, cmd, p);
 }
@@ -789,7 +791,7 @@ static void set_media_not_present(struct
 
 /**
  *	sd_media_changed - check if our medium changed
- *	@disk: kernel device descriptor 
+ *	@disk: kernel device descriptor
  *
  *	Returns 0 if not applicable or no change; 1 if change
  *
@@ -922,9 +924,9 @@ static void sd_rescan(struct device *dev
 
 
 #ifdef CONFIG_COMPAT
-/* 
- * This gets directly called from VFS. When the ioctl 
- * is not recognized we go back to the other translation paths. 
+/*
+ * This gets directly called from VFS. When the ioctl
+ * is not recognized we go back to the other translation paths.
  */
 static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
@@ -939,19 +941,15 @@ static int sd_compat_ioctl(struct block_
 	 */
 	if (!scsi_block_when_processing_errors(sdev))
 		return -ENODEV;
-	       
-	if (sdev->host->hostt->compat_ioctl) {
-		int ret;
-
-		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 
-		return ret;
-	}
+	if (sdev->host->hostt->compat_ioctl)
+		return sdev->host->hostt->compat_ioctl(sdev, cmd,
+						       (void __user *)arg);
 
-	/* 
+	/*
 	 * Let the static ioctl translation table take care of it.
 	 */
-	return -ENOIOCTLCMD; 
+	return -ENOIOCTLCMD;
 }
 #endif
 
@@ -1143,7 +1141,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
-		} while (retries < 3 && 
+		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
@@ -1151,13 +1149,14 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
-			if(!spintime && !scsi_status_is_good(the_result)) {
-				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
+			if (!spintime && !scsi_status_is_good(the_result)) {
+				sd_printk(KERN_NOTICE, sdkp,
+					  "Unit Not Ready\n");
 				sd_print_result(sdkp, the_result);
 			}
 			break;
 		}
-					
+
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
@@ -1175,7 +1174,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
-				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
+				sd_printk(KERN_NOTICE, sdkp,
+					  "Spinning up disk...");
 				cmd[0] = START_STOP;
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
@@ -1210,13 +1210,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		} else {
 			/* we don't understand the sense code, so it's
 			 * probably pointless to loop */
-			if(!spintime) {
-				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
+			if (!spintime) {
+				sd_printk(KERN_NOTICE, sdkp,
+					  "Unit Not Ready\n");
 				sd_print_sense_hdr(sdkp, &sshdr);
 			}
 			break;
 		}
-				
 	} while (spintime && time_before_eq(jiffies, spintime_expire));
 
 	if (spintime) {
@@ -1592,7 +1592,8 @@ sd_read_write_protect_flag(struct scsi_d
 		 * CDB.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(sdp, 0, 0, buffer, 4, &data, NULL);
+			res = sd_do_mode_sense(sdp, 0, 0, buffer, 4,
+					       &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
@@ -1655,7 +1656,8 @@ sd_read_cache_type(struct scsi_disk *sdk
 
 	if (!data.header_length) {
 		modepage = 6;
-		sd_printk(KERN_ERR, sdkp, "Missing header in MODE_SENSE response\n");
+		sd_printk(KERN_ERR, sdkp, "Missing header in MODE_SENSE "
+					  "response\n");
 	}
 
 	/* that went OK, now ask for the proper length */
@@ -1682,7 +1684,8 @@ sd_read_cache_type(struct scsi_disk *sdk
 		int offset = data.header_length + data.block_descriptor_length;
 
 		if (offset >= SD_BUF_SIZE - 2) {
-			sd_printk(KERN_ERR, sdkp, "Malformed MODE SENSE response\n");
+			sd_printk(KERN_ERR, sdkp, "Malformed MODE SENSE "
+						  "response\n");
 			goto defaults;
 		}
 
@@ -1972,13 +1975,13 @@ static void sd_probe_async(void *data, a
  *	for each scsi device (not just disks) present.
  *	@dev: pointer to device object
  *
- *	Returns 0 if successful (or not interested in this scsi device 
+ *	Returns 0 if successful (or not interested in this scsi device
  *	(e.g. scanner)); 1 when there is an error.
  *
  *	Note: this function is invoked from the scsi mid-level.
- *	This function sets up the mapping between a given 
- *	<host,channel,id,lun> (found in sdp) and new device name 
- *	(e.g. /dev/sda). More precisely it is the block device major 
+ *	This function sets up the mapping between a given
+ *	<host,channel,id,lun> (found in sdp) and new device name
+ *	(e.g. /dev/sda). More precisely it is the block device major
  *	and minor number that is chosen here.
  *
  *	Assume sd_attach is not re-entrant (for time being)
@@ -1993,7 +1996,8 @@ static int sd_probe(struct device *dev)
 	int error;
 
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC)
 		goto out;
 
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
@@ -2087,7 +2091,7 @@ static void scsi_disk_release(struct dev
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
-	
+
 	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, sdkp->index);
 	spin_unlock(&sd_index_lock);
