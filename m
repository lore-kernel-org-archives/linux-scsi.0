From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] always check write protect
Date: Thu, 26 Jun 2003 08:37:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030626083719.A22880@infradead.org>
References: <20030624210448.486.qmail@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:23821 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265447AbTFZHXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 03:23:08 -0400
Content-Disposition: inline
In-Reply-To: <20030624210448.486.qmail@emc.com>; from pc-linscsi2@crowcastle.net on Tue, Jun 24, 2003 at 09:04:48PM -0000
List-Id: linux-scsi@vger.kernel.org
To: pc-linscsi2@crowcastle.net
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 24, 2003 at 09:04:48PM -0000, pc-linscsi2@crowcastle.net wrote:
> The current version of sd.c only checks the write protect status for
> removable media.  This is wrong--you can have write-protected non-removable
> media.  This is common with high-end storage arrays.  This patch corrects
> the behaviour.  It applies with slight line offsets to recent 2.4 kernels,
> including 2.4.21.

What about a patch like the following for 2.5?  It also address your
fixme by calling check_disk_change (and thus sd_revalidate_disk) in
->open when the write_prot flag is set.


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
+	if ((sdkp->write_prot) && (filp->f_mode & FMODE_WRITE))
+		goto error_out;
 
 	/*
 	 * It is possible that the disk changing stuff resulted in
