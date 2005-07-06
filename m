From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Patch for SCSI CD-ROM getting wrong size
Date: Tue, 5 Jul 2005 18:18:08 -0700
Message-ID: <20050705181808.51810d90.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:11493 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262030AbVGFBSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2005 21:18:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: zaitcev@redhat.com, viro@parcelfarce.linux.theplanet.co.uk, James.Bottomley@SteelEye.com

Hi, All:

Here's the problem. Try to do this on 2.6.12:
- Kill udev and HAL
- Insert a CD-ROM into a SCSI or USB CD-ROM drive
- Run dd if=/dev/scd0
- cat /sys/block/sr0/size
- Eject the CD, insert a different one
- Run dd if=/dev/scd0
This is likely to do "access beyond the end of device", if you let it
- cat /sys/block/sr0/size
This shows the size of a previous CD, even though dd was supposed
to revalidate the device.
- Run dd if=/dev/scd0
The second run of dd works correctly!

The bug was introduced in 2.5.31, when Al fixes the recursive opens
in partitioning. Before, the code worked like this:
- Block layer called cdrom_open directly
- cdrom_open called sr_open
- sr_open called check_disk_change
- check_disk_change called sr_media_change
- sr_media_change did cd->needs_disk_change=1
- before returning sr_open tested cd->needs_disk_change
  and called get_sector_size.

In 2.6.12, the check_disk_change is called from cdrom_open only. Thus:
- Block layer calls sr_bd_open
- sr_bd_open calls cdrom_open
- cdrom_open calls sr_open
- sr_open tests cd->needs_disk_change, which wasn't set yet; returns
- cdrom_open calls check_disk_change
- check_disk_change calls sr_media_change
- sr_media_change does cd->needs_disk_change=1, but nobody cares

I propose this patch:

diff -urp -X dontdiff linux-2.6.12/drivers/scsi/sr.c linux-2.6.12-lem/drivers/scsi/sr.c
--- linux-2.6.12/drivers/scsi/sr.c	2005-06-21 12:58:43.000000000 -0700
+++ linux-2.6.12-lem/drivers/scsi/sr.c	2005-07-05 16:17:40.000000000 -0700
@@ -199,15 +199,7 @@ int sr_media_change(struct cdrom_device_
 		/* check multisession offset etc */
 		sr_cd_check(cdi);
 
-		/* 
-		 * If the disk changed, the capacity will now be different,
-		 * so we force a re-read of this information 
-		 * Force 2048 for the sector size so that filesystems won't
-		 * be trying to use something that is too small if the disc
-		 * has changed.
-		 */
-		cd->needs_sector_size = 1;
-		cd->device->sector_size = 2048;
+		get_sectorsize(cd);
 	}
 	return retval;
 }
@@ -538,13 +530,6 @@ static int sr_open(struct cdrom_device_i
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	/*
-	 * If this device did not have media in the drive at boot time, then
-	 * we would have been unable to get the sector size.  Check to see if
-	 * this is the case, and try again.
-	 */
-	if (cd->needs_sector_size)
-		get_sectorsize(cd);
 	return 0;
 
 error_out:
@@ -604,7 +589,6 @@ static int sr_probe(struct device *dev)
 	cd->driver = &sr_template;
 	cd->disk = disk;
 	cd->capacity = 0x1fffff;
-	cd->needs_sector_size = 1;
 	cd->device->changed = 1;	/* force recheck CD type */
 	cd->use = 1;
 	cd->readcd_known = 0;
@@ -694,7 +678,6 @@ static void get_sectorsize(struct scsi_c
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-		cd->needs_sector_size = 1;
 	} else {
 #if 0
 		if (cdrom_get_last_written(&cd->cdi,
@@ -727,7 +710,6 @@ static void get_sectorsize(struct scsi_c
 			printk("%s: unsupported sector size %d.\n",
 			       cd->cdi.name, sector_size);
 			cd->capacity = 0;
-			cd->needs_sector_size = 1;
 		}
 
 		cd->device->sector_size = sector_size;
@@ -736,7 +718,6 @@ static void get_sectorsize(struct scsi_c
 		 * Add this so that we have the ability to correctly gauge
 		 * what the device is capable of.
 		 */
-		cd->needs_sector_size = 0;
 		set_capacity(cd->disk, cd->capacity);
 	}
 
@@ -748,8 +729,7 @@ out:
 
 Enomem:
 	cd->capacity = 0x1fffff;
-	sector_size = 2048;	/* A guess, just in case */
-	cd->needs_sector_size = 1;
+	cd->device->sector_size = 2048;	/* A guess, just in case */
 	if (SRpnt)
 		scsi_release_request(SRpnt);
 	goto out;
diff -urp -X dontdiff linux-2.6.12/drivers/scsi/sr.h linux-2.6.12-lem/drivers/scsi/sr.h
--- linux-2.6.12/drivers/scsi/sr.h	2004-08-19 17:15:55.000000000 -0700
+++ linux-2.6.12-lem/drivers/scsi/sr.h	2005-07-05 16:12:33.000000000 -0700
@@ -33,7 +33,6 @@ typedef struct scsi_cd {
 	struct scsi_device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
 	unsigned long ms_offset;	/* for reading multisession-CD's        */
-	unsigned needs_sector_size:1;	/* needs to get sector size */
 	unsigned use:1;		/* is this device still supportable     */
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

It looks obvious that "needs_sector_size" is entirely unnecessary in 2.6,
because our opening sequence is much streamlined now. It made sense
in 2.4 only.

Al, James, do you approve?

-- Pete
