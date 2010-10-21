From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [USB] Use normalized sense when emulating autosense
Date: Thu, 21 Oct 2010 15:23:14 -0700 (PDT)
Message-ID: <407253.45995.qm@web31802.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:26351 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751149Ab0JUWXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2010 18:23:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch solves two things:
1) Enables autosense emulation code to correctly
interpret descriptor format sense data, and
2) Fixes a bug whereby the autosense emulation
code would overwrite descriptor format sense data
with SENSE KEY HARDWARE ERROR in fixed format, to
incorrectly look like this:

Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  Sense Key : Recovered Error [current] [descriptor]
Oct 21 14:11:07 localhost kernel: Descriptor sense data with sense descriptors (in hex):
Oct 21 14:11:07 localhost kernel:        72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
Oct 21 14:11:07 localhost kernel:        00 4f 00 c2 00 50
Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/transport.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 64ec073..46165de 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -691,6 +691,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -774,17 +775,15 @@ Retry_Sense:
 			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
 		}
 
+		scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+
 		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
 		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
-			  srb->sense_buffer[0],
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+			  sshdr.response_code, sshdr.sense_key,
+			  sshdr.asc, sshdr.ascq);
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		usb_stor_show_sense(
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+		usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
 #endif
 
 		/* set the result so the higher layers expect this data */
@@ -794,12 +793,7 @@ Retry_Sense:
 		 * everything worked or that there was an unspecified
 		 * problem.  We have to decide which.
 		 */
-		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
-				(srb->sense_buffer[2] & 0xaf) == 0 &&
-			/* No ASC or ASCQ */
-				srb->sense_buffer[12] == 0 &&
-				srb->sense_buffer[13] == 0) {
-
+		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0) {
 			/* If things are really okay, then let's show that.
 			 * Zero out the sense buffer so the higher layers
 			 * won't realize we did an unsolicited auto-sense.
@@ -814,7 +808,10 @@ Retry_Sense:
 			 */
 			} else {
 				srb->result = DID_ERROR << 16;
-				srb->sense_buffer[2] = HARDWARE_ERROR;
+				if ((sshdr.response_code & 0x72) == 0x72)
+					srb->sense_buffer[1] = HARDWARE_ERROR;
+				else
+					srb->sense_buffer[2] = HARDWARE_ERROR;
 			}
 		}
 	}
-- 
1.7.0.1

