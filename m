From: akpm@linux-foundation.org
Subject: [patch 25/28] Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Thu, 10 May 2007 23:01:09 -0700
Message-ID: <200705110601.l4B619oS008190@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758617AbXEKGBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:01:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The CD-ROM layer doesn't bounce requests for old ISA controllers (and nor
should it).  However they get injected into the SCSI layer via sr_ioctl
which also doesn't bounce them and SCSI then passes the buffer along to a
device with unchecked_isa_dma set which either panics or truncates the
buffer to 24bits.

According to Jens the right long term fix is for the CD layer to route the
requests differently but in the mean time this has been tested by a victim
and verified to sort the problem out.  For the other 99.9% of users it's a
no-op and doesn't bounce data.

(akpm: placeholder fix.  Apparently the metaphorical Mike is working on a real
fix).

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr_ioctl.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sr_ioctl.c~fix-old-scsi-adapter-crashes-with-cd-rom-take-2 drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c~fix-old-scsi-adapter-crashes-with-cd-rom-take-2
+++ a/drivers/scsi/sr_ioctl.c
@@ -187,6 +187,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
+	void *zebedee = cgc->buffer;
 
 	SDev = cd->device;
 
@@ -198,6 +199,21 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 		}
 	}
 
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
@@ -206,11 +222,16 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 
 	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, (char *)sense,
+			      zebedee, cgc->buflen, (char *)sense,
 			      cgc->timeout, IOCTL_RETRIES, 0);
 
 	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
 
+	if (zebedee != cgc->buffer) {
+		if (cgc->data_direction == DMA_FROM_DEVICE)
+			memcpy(cgc->buffer, zebedee, cgc->buflen);
+	}
+
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
 		switch (sshdr.sense_key) {
@@ -266,6 +287,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 
 	/* Wake up a process waiting for device */
       out:
+	if (zebedee != cgc->buffer)
+		kfree(zebedee);	/* Time for bed */
 	if (!cgc->sense)
 		kfree(sense);
 	cgc->stat = err;
_
