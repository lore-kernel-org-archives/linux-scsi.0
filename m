From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB mass storage stopped working in 2.6?
Date: Fri, 8 Aug 2003 09:59:53 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0308080957090.794-100000@ida.rowland.org>
References: <20030808074732.8960.qmail@daitarn.register.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3076 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S271343AbTHHN7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 09:59:55 -0400
In-Reply-To: <20030808074732.8960.qmail@daitarn.register.it>
List-Id: linux-scsi@vger.kernel.org
To: Alessandro Fiorino <a.fiorino@chibacity.it>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 8 Aug 2003, Alessandro Fiorino wrote:

> I installed the 2.6 kernel to test it and I have some problems with the USB
> mass storage driver: my external HD enclousure doesn't work anymore (the
> device works perfectly with the 2.4.21 version).
> My computer is an Acer TravelMate 521TE with an ALI USB 1.1 controller, the
> device is an USB2 2.5" HD enclousure.
> When I plug it the kernel detects it, but it gives a lots of errors and I
> can't access the drive content.
> I've tested it with the 2.6.0-test2 kernel version, attached there are the
> lsusb output (from 2.4.21) for the device and the kernel log (compiled with
> usb mass storage debug enabled).

I have submitted a patch to the SCSI people, but haven't heard back from
them about it.  It applies to 2.6.0; maybe it will fix your problem.  
Please try it out and let us know what happens.

Alan Stern


===== sd.c 1.52 vs edited =====
--- 1.52/drivers/scsi/sd.c	Tue Jul  1 17:54:19 2003
+++ edited/drivers/scsi/sd.c	Thu Jul 31 11:05:01 2003
@@ -1080,6 +1080,7 @@
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int res;
+	const int dbd = 0;	   /* Some devices don't like DBD */
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
+	const int dbd = 0;	   /* Some devices don't like DBD */
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
 
@@ -1134,10 +1135,11 @@
 
 	if (scsi_status_is_good(res)) {
 		/* that went OK, now ask for the proper length */
-		len = data.length;
-		if (len > 128)
-			len = 128;
-		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
+		len = data.header_length + data.block_descriptor_length + 4;
+		if (len > 512)
+			res = SAM_STAT_BUSY;
+		else
+			res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
 				       len, &data);
 	}
 

