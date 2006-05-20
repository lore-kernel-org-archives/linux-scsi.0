From: Alan Stern <stern@rowland.harvard.edu>
Subject: sd.c: speed up detection of missing media
Date: Sat, 20 May 2006 15:54:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0605201549370.29313-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.rowland.org ([192.131.102.7]:34565 "HELO mx2.rowland.org")
	by vger.kernel.org with SMTP id S1751474AbWETTyB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 15:54:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

The patch below is intended to improve medium-not-present detection in
sd_spinup_disk.  Is there any reason why it shouldn't work better than the
current code?

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1047,6 +1048,14 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
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
@@ -1055,14 +1064,6 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
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

