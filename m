From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as73) Do a minimal transfer for disk-cache mode-sense page
Date: Wed, 30 Jul 2003 16:36:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307301622410.2990-100000@ida.rowland.org>
References: <1056301585.1979.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:32516 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S272233AbTG3Ugq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 16:36:46 -0400
In-Reply-To: <1056301585.1979.58.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch for 2.6.0 makes 3 changes in the read-write- and cache-detect
mode-sense routines in sd.c:

	It sets the DBD flag to prevent the transfer of unwanted Block 
Descriptors.

	It uses 512 (the actual buffer size) as an upper limit, not 128
as in the current code.

	It transfers only the first 4 bytes of the cache page; the 
information we want is in the 3rd byte.

The last change is the real reason for submitting the patch.  Apparently
the Genesyslogic USB disk drive doesn't like being asked for more than 64
bytes of its cache page.  Doing so crashes the drive's firmware.  Since
the transfer size had to be reduced anyway, I decided to use the minimum
necessary (rounded up to a multiple of 4) -- similar to other changes that
have been made recently in various mode-sense transfers.

This fixes the problem with the Genesyslogic drive, and it ought to work 
correctly with any standards-conformant device.  If it looks okay with 
you, please apply it.

Alan Stern


===== sd.c 1.52 vs edited =====
--- 1.52/drivers/scsi/sd.c	Tue Jul  1 17:54:19 2003
+++ edited/drivers/scsi/sd.c	Wed Jul 30 16:15:46 2003
@@ -1080,6 +1080,7 @@
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int res;
+	const int dbd = 0x08;	   /* DBD */
 	struct scsi_mode_data data;
 
 	/*
@@ -1087,7 +1088,7 @@
 	 * We have to start carefully: some devices hang if we ask
 	 * for more than is available.
 	 */
-	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
+	res = sd_do_mode_sense(SRpnt, dbd, 0x3F, buffer, 4, &data);
 
 	/*
 	 * Second attempt: ask for page 0
@@ -1095,13 +1096,13 @@
 	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
+		res = sd_do_mode_sense(SRpnt, dbd, 0, buffer, 4, &data);
 
 	/*
 	 * Third attempt: ask 255 bytes, as we did earlier.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
+		res = sd_do_mode_sense(SRpnt, dbd, 0x3F, buffer, 255, &data);
 
 	if (!scsi_status_is_good(res)) {
 		printk(KERN_WARNING
@@ -1124,7 +1125,7 @@
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int len = 0, res;
 
-	const int dbd = 0;	   /* DBD */
+	const int dbd = 0x08;	   /* DBD */
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
 
@@ -1134,11 +1135,12 @@
 
 	if (scsi_status_is_good(res)) {
 		/* that went OK, now ask for the proper length */
-		len = data.length;
-		if (len > 128)
-			len = 128;
-		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
+		len = data.header_length + data.block_descriptor_length + 4;
+		if (len <= 512)
+			res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
 				       len, &data);
+		else
+			res = SAM_STAT_BUSY;
 	}
 
 	if (scsi_status_is_good(res)) {

