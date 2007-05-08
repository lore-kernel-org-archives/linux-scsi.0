From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH]: Fix old SCSI adapter crashes with CD-ROM
Date: Tue, 8 May 2007 17:03:35 +0100
Message-ID: <20070508170335.1b1f844c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60787 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964810AbXEHP7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 11:59:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org

The CD-ROM layer doesn't bounce requests for old ISA controllers (and
nor should it). However they get injected into the SCSI layer via
sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
along to a device with unchecked_isa_dma set which either panics or
truncates the buffer to 24bits.

According to Jens the right long term fix is for the CD layer to route
the requests differently but in the mean time this has been tested by a
victim and verified to sort the problem out. For the other 99.9% of users
it's a no-op and doesn't bounce data.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/scsi/sr_ioctl.c linux-2.6.21-rc6-mm1/drivers/scsi/sr_ioctl.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/scsi/sr_ioctl.c	2007-04-12 14:14:45.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/scsi/sr_ioctl.c	2007-05-01 14:23:40.000000000 +0100
@@ -187,9 +187,10 @@
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
-
+	void *zebedee = cgc->buffer;
+	
 	SDev = cd->device;
-
+	
 	if (!sense) {
 		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
 		if (!sense) {
@@ -197,7 +198,22 @@
 			goto out;
 		}
 	}
-
+	
+	if (cgc->buflen && cd->device->host->unchecked_isa_dma) {
+		switch(cgc->data_direction) {
+			case DMA_NONE:
+				break;
+			case DMA_FROM_DEVICE:
+			case DMA_TO_DEVICE:
+				zebedee = kmalloc(cgc->buflen, GFP_KERNEL|GFP_DMA);
+				if (zebedee ==NULL) {
+					err = -ENOMEM;
+					goto out;
+				}
+		}
+		if (cgc->data_direction == DMA_TO_DEVICE)
+			memcpy(zebedee, cgc->buffer, cgc->buflen);
+	}
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
@@ -206,10 +222,16 @@
 
 	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, (char *)sense,
+			      zebedee, cgc->buflen, (char *)sense,
 			      cgc->timeout, IOCTL_RETRIES, 0);
 
 	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
+	
+	if (zebedee != cgc->buffer) {
+		if (cgc->data_direction == DMA_FROM_DEVICE)
+			memcpy(cgc->buffer, zebedee, cgc->buflen);
+		kfree(zebedee);	/* Time for bed */
+	}
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
