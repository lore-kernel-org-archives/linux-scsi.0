From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] check whether a disk got writeable in sd_open
Date: Mon, 25 Aug 2003 21:36:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825193648.GA21396@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:5537 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262146AbTHYTgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:36:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is the 2.5 version of a 2.4 patch posted to the list long
ago, the aacraid thread reminded me of it.

The problem is that certain highend arrays allow to mark a r/o
volume writeable on the fly so we have to call check_disk_change
for write-protected devices in sd_open, too.


diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Wed Jun 25 11:47:26 2003
+++ b/drivers/scsi/sd.c	Wed Jun 25 11:47:26 2003
@@ -368,25 +368,24 @@
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	if (sdev->removable) {
+	if (sdev->removable || sdkp->write_prot)
 		check_disk_change(inode->i_bdev);
 
-		/*
-		 * If the drive is empty, just let the open fail.
-		 */
-		retval = -ENOMEDIUM;
-		if ((!sdkp->media_present) && !(filp->f_flags & O_NDELAY))
-			goto error_out;
+	/*
+	 * If the drive is empty, just let the open fail.
+	 */
+	retval = -ENOMEDIUM;
+	if (sdev->removable && !sdkp->media_present &&
+	    !(filp->f_flags & O_NDELAY))
+		goto error_out;
 
-		/*
-		 * Similarly, if the device has the write protect tab set,
-		 * have the open fail if the user expects to be able to write
-		 * to the thing.
-		 */
-		retval = -EROFS;
-		if ((sdkp->write_prot) && (filp->f_mode & FMODE_WRITE))
-			goto error_out;
-	}
+	/*
+	 * If the device has the write protect tab set, have the open fail
+	 * if the user expects to be able to write to the thing.
+	 */
+	retval = -EROFS;
+	if (sdkp->write_prot && (filp->f_mode & FMODE_WRITE))
+		goto error_out;
 
 	/*
 	 * It is possible that the disk changing stuff resulted in
