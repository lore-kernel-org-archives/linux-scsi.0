From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 15:43:11 -0800 (PST)
Message-ID: <929551.13749.qm@web31805.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

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

Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Acked-by: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
---
 drivers/usb/storage/transport.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 64ec073..cb04664 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -691,6 +691,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
+		const u8 *scdd;
+		u8 fm_ili;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -774,32 +777,30 @@ Retry_Sense:
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
 		srb->result = SAM_STAT_CHECK_CONDITION;
 
+		scdd = scsi_sense_desc_find(srb->sense_buffer,
+					    SCSI_SENSE_BUFFERSIZE, 4);
+		fm_ili = (scdd ? scdd[3] : srb->sense_buffer[2]) & 0xA0;
+
 		/* We often get empty sense data.  This could indicate that
 		 * everything worked or that there was an unspecified
 		 * problem.  We have to decide which.
 		 */
-		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
-				(srb->sense_buffer[2] & 0xaf) == 0 &&
-			/* No ASC or ASCQ */
-				srb->sense_buffer[12] == 0 &&
-				srb->sense_buffer[13] == 0) {
