From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sd medium removal handling
Date: Tue, 3 Jun 2003 23:15:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603211558.GA9471@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:21673 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261861AbTFCVCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 17:02:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

sdev->access_count is incremented not only by sd but also e.g. by
sg.  Now if sd opens first, then sg, then sd closes and sg last
medium removal will still be prevented.

Add a counter in scsi_disk for doorlocking instead.


diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Tue Jun  3 01:21:25 2003
+++ b/drivers/scsi/sd.c	Tue Jun  3 01:21:25 2003
@@ -76,6 +76,7 @@
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
 	struct gendisk	*disk;
+	unsigned int	openers;	/* protected by BKL for now, yuck */
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		index;
 	u8		media_present;
@@ -396,9 +397,10 @@
 	if (!sdev->online)
 		goto error_out;
 
-	if (sdev->removable && sdev->access_count == 1)
+	if (!sdkp->openers++ && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
+	}
 
 	return 0;
 
@@ -421,13 +423,15 @@
 static int sd_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct scsi_device *sdev = scsi_disk(disk)->device;
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdev = sdkp->device;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
 
-	if (sdev->removable && sdev->access_count == 1)
+	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
+	}
 
 	/*
 	 * XXX and what if there are packets in flight and this close()
@@ -1331,6 +1335,7 @@
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
+	sdkp->openers = 0;
 
 	gd->major = sd_major(index >> 4);
 	gd->first_minor = (index & 15) << 4;
