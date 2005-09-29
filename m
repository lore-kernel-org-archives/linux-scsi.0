From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Improve code for detecting errors near the end of a CD
Date: Thu, 29 Sep 2005 14:44:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509291416540.6137-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:13787 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932291AbVI2Sot
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 14:44:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as572) beefs up the code in sr.c that detects where read/write
errors occurred and moves it to a separate (but inline) routine for
greater clarity.

The original code contained one glaring mistake: testing
(SCpnt->sense_buffer[0] & 0x90) to see if the Information field in the
sense data is valid.  The Valid bit is 0x80; the test against 0x90 can
never fail, thanks to the earlier test: (SCpnt->sense_buffer[0] & 0x7f) ==
0x70).

The code also contained a rather puzzling line:

			error_sector &= ~(block_sectors - 1);

This makes no sense at all, so I have removed it.  The patch does of 
course check that error_sector is within the range of blocks that were 
supposed to be transferred.

The major enhancement is that the patch uses the Residue to calculate the 
error sector, if the sense data doesn't already provide it.  This helps 
with a drive I use.  Since the Residue isn't always reported correctly, 
the patch is careful to check that it has a reasonable value: somewhere 
strictly between 0 and the total transfer length.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -203,7 +203,41 @@ int sr_media_change(struct cdrom_device_
 	}
 	return retval;
 }
- 
+
+/* 
+ * Use the information from a failed command to compute how much data
+ * was transferred successfully, and find the sector that caused the
+ * error.
+ */
+static inline int calc_good_bytes(struct scsi_cmnd *SCpnt,
+		long *error_sector, int blocksize)
+{
+	int num_bytes = SCpnt->bufflen;
+	unsigned int start_block, error_block, num_blocks = 0;
+
+	start_block = (unsigned int) SCpnt->request->sector / (blocksize >> 9);
+
+	if (SCpnt->sense_buffer[0] & 0x80) {
+		/* The Information field is valid; use it */
+		error_block = (SCpnt->sense_buffer[3] << 24) |
+				(SCpnt->sense_buffer[4] << 16) |
+				(SCpnt->sense_buffer[5] << 8) |
+				SCpnt->sense_buffer[6];
+		if (error_block >= start_block)
+			num_blocks = error_block - start_block;
+
+	} else {
+		/* Fall back on the Residue */
+		if (SCpnt->resid > 0 && SCpnt->resid < num_bytes)
+			num_blocks = (num_bytes - SCpnt->resid) / blocksize;
+	}
+
+	if (num_blocks >= num_bytes / blocksize)
+		num_blocks = 0;
+	*error_sector = (start_block + num_blocks) * (blocksize >> 9);
+	return num_blocks * blocksize;
+}
+
 /*
  * rw_intr is the interrupt routine for the device driver.
  *
@@ -235,25 +269,16 @@ static void rw_intr(struct scsi_cmnd * S
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
+					cd->device->sector_size);
 			/*
 			 * The SCSI specification allows for the value
 			 * returned by READ CAPACITY to be up to 75 2K

