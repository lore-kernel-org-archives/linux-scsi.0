From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Improve code for detecting errors near the end of a CD
Date: Fri, 14 Oct 2005 16:07:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510141603110.6253-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44266 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750732AbVJNUHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 16:07:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This revised patch (as572b) improves the code in sr.c that detects where
read/write errors occurred and moves it to a separate (but inline) routine
for greater clarity.

The original code contained a glaring mistake: testing
(SCpnt->sense_buffer[0] & 0x90) to see if the Information field in the
sense data is valid.  The Valid bit is 0x80; the test against 0x90 can
never fail, thanks to an earlier test: (SCpnt->sense_buffer[0] & 0x7f) ==
0x70).

The patch is careful to check that the error sector is within the range of
blocks that were supposed to be transferred, and it rounds the reported 
number of bytes transferred down to a multiple of the block layer's block 
size.

The major enhancement is that the patch uses the Residue to calculate the 
error sector, if the sense data doesn't already provide it.  This helps 
with a drive I use.  Since the Residue isn't always reported correctly, 
the patch is careful to check that it has a reasonable value: somewhere 
strictly between 0 and the total transfer length.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -203,7 +203,44 @@ int sr_media_change(struct cdrom_device_
 	}
 	return retval;
 }
- 
+
+/* 
+ * Use the information from a failed command to compute how much data
+ * was transferred successfully, and find the sector that caused the
+ * error.  Be careful to avoid errors from numerical overflow.
+ */
+static inline int calc_good_bytes(struct scsi_cmnd *SCpnt,
+		long *error_sector, int hw_blocksize,
+		int sectors_per_bio_block)
+{
+	int req_bytes = SCpnt->bufflen;
+	unsigned int sectors = 0;
+
+	if (SCpnt->sense_buffer[0] & 0x80) {
+		/* The Information field is valid; use it */
+		unsigned int start_block, error_block, blocks;
+
+		start_block = (unsigned int) SCpnt->request->sector /
+				(hw_blocksize >> 9);
+		error_block = (SCpnt->sense_buffer[3] << 24) |
+				(SCpnt->sense_buffer[4] << 16) |
+				(SCpnt->sense_buffer[5] << 8) |
+				SCpnt->sense_buffer[6];
+		blocks = error_block - start_block;
+		if (blocks < req_bytes / hw_blocksize)
+			sectors = blocks * (hw_blocksize >> 9);
+	} else {
+		/* Fall back on the Residue */
+		if (SCpnt->resid > 0 && SCpnt->resid < req_bytes)
+			sectors = (req_bytes - SCpnt->resid) >> 9;
+	}
+	*error_sector = SCpnt->request->sector + sectors;
+
+	/* Round the amount to a multiple of the block layer's block size */
+	sectors &= ~(sectors_per_bio_block - 1);
+	return sectors << 9;
+}
+
 /*
  * rw_intr is the interrupt routine for the device driver.
  *
@@ -235,25 +272,17 @@ static void rw_intr(struct scsi_cmnd * S
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
-			if (!(SCpnt->sense_buffer[0] & 0x90))
-				break;
 			if (!blk_fs_request(SCpnt->request))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
 			if (SCpnt->request->bio != NULL)
 				block_sectors =
 					bio_sectors(SCpnt->request->bio);
 			if (block_sectors < 4)
 				block_sectors = 4;
-			if (cd->device->sector_size == 2048)
-				error_sector <<= 2;
-			error_sector &= ~(block_sectors - 1);
-			good_bytes = (error_sector - SCpnt->request->sector) << 9;
-			if (good_bytes < 0 || good_bytes >= this_count)
-				good_bytes = 0;
+
+			good_bytes = calc_good_bytes(SCpnt, &error_sector,
+					cd->device->sector_size,
+					block_sectors);
 			/*
 			 * The SCSI specification allows for the value
 			 * returned by READ CAPACITY to be up to 75 2K

