From: pc-linscsi2@crowcastle.net
Subject: [PATCH] always check write protect
Date: 24 Jun 2003 21:04:48 -0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624210448.486.qmail@emc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [168.159.2.8] ([168.159.2.8]:52935 "EHLO mailhub.lss.emc.com")
	by vger.kernel.org with ESMTP id S261960AbTFXUvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 16:51:20 -0400
Received: from emc.com (somebody@d5110227.lss.emc.com [10.243.10.227])
	by mailhub.lss.emc.com (Switch-2.2.5/Switch-2.2.0) with SMTP id h5OL5RR00232
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2003 17:05:27 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The current version of sd.c only checks the write protect status for
removable media.  This is wrong--you can have write-protected non-removable
media.  This is common with high-end storage arrays.  This patch corrects
the behaviour.  It applies with slight line offsets to recent 2.4 kernels,
including 2.4.21.

Without this fix, using dd to write to a read-only drive results in
success, but as the buffers are flushed out, syslog is flooded with scsi
errors and the system becomes sluggish.

(Note: I've tested the same configuration with Solaris, and it does
recognize the write-protect state correctly.)

I also have a version for 2.5.73, though I haven't tested it yet.

--PC



--- linux-orig/drivers/scsi/sd.c	2003-06-13 10:51:36.000000000 -0400
+++ linux/drivers/scsi/sd.c	2003-06-24 15:48:43.000000000 -0400
@@ -493,17 +493,32 @@
 			retval = -ENOMEDIUM;
 			goto error_out;
 		}
+        }
 
+	/*
+	 * Similarly, if the device has the write protect tab set,
+	 * have the open fail if the user expects to be able to write
+	 * to the thing.
+	 */
+	if ((rscsi_disks[target].write_prot) && (filp->f_mode & 2)) {
 		/*
-		 * Similarly, if the device has the write protect tab set,
-		 * have the open fail if the user expects to be able to write
-		 * to the thing.
+		 * This is incomplete!
+		 *
+		 * We really need to issue a MODE_SENSE command to the device
+		 * and see if the write protect is still set.  In theory (and
+		 * in practice with high-end storage systems), the write-protect
+		 * status can be changed dynamically without the operating system
+		 * knowing anything happened.
+		 *
+		 * It may be safe to assume that removable write-protected media
+		 * won't have the write-protect status change without a media
+		 * change, but I wouldn't stake my life on it (hey, I wouldn't
+		 * even stake your life on it).
 		 */
-		if ((rscsi_disks[target].write_prot) && (filp->f_mode & 2)) {
-			retval = -EROFS;
-			goto error_out;
-		}
+		retval = -EROFS;
+		goto error_out;
 	}
+
 	/*
 	 * It is possible that the disk changing stuff resulted in the device
 	 * being taken offline.  If this is the case, report this to the user,
@@ -1034,10 +1049,16 @@
 	 * Unless otherwise specified, this is not write protected.
 	 */
 	rscsi_disks[i].write_prot = 0;
-	if (rscsi_disks[i].device->removable && rscsi_disks[i].ready) {
+	if (rscsi_disks[i].ready) {
 		/* FLOPTICAL */
 
 		/*
+		 * Actually, any scsi disk can be write protected.  Sure, it
+		 * would be weird to set the jumper on the drive for most people,
+		 * but you can do it.  Also, high-end storage systems such as
+		 * the EMC Symmetrix(tm) use this.
+		 * Preston Crow ( pc-scsi@crowcastle.net )
+		 *
 		 * For removable scsi disk ( FLOPTICAL ) we have to recognise
 		 * the Write Protect Flag. This flag is kept in the Scsi_Disk
 		 * struct and tested at open !
