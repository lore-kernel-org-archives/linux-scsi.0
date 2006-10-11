From: Alan Stern <stern@rowland.harvard.edu>
Subject: Rejected patch to reduce polling I/O
Date: Wed, 11 Oct 2006 10:32:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610111027370.6950-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45318 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1030444AbWJKOcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 10:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

Andrew Morton says you rejected the patch below.  Any particular reason?

Alan Stern



If a drive reports that no media is present, there's no point in
continuing to ask it about media status.  This patch (as696) cuts the
TUR polling short as soon as the drive reports no media instead of
going a full 3 iterations.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1046,6 +1046,14 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 						      &sshdr, SD_TIMEOUT,
 						      SD_MAX_RETRIES);
 
+			/*
+			 * If the drive has indicated to us that it
+			 * doesn't have any media in it, don't bother
+			 * with any of the rest of this crap.
+			 */
+			if (media_not_present(sdkp, &sshdr))
+				return;
+
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
@@ -1054,14 +1062,6 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		/*
-		 * If the drive has indicated to us that it doesn't have
-		 * any media in it, don't bother with any of the rest of
-		 * this crap.
-		 */
-		if (media_not_present(sdkp, &sshdr))
-			return;
-
 		if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */

