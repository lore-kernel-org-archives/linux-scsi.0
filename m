From: akpm@linux-foundation.org
Subject: [patch 28/30] scsi: arm: convert to accessors and !use_sg cleanup
Date: Thu, 13 Dec 2007 16:14:30 -0800
Message-ID: <200712140014.lBE0EVmn026265@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933312AbXLNA3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:29:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, rmk@arm.linux.org.uk

From: Boaz Harrosh <bharrosh@panasas.com>

 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/arm/acornscsi.c |   14 ++++++-------
 drivers/scsi/arm/scsi.h      |   34 ++++++++++-----------------------
 2 files changed, 18 insertions(+), 30 deletions(-)

diff -puN drivers/scsi/arm/acornscsi.c~scsi-pending-arm-convert-to-accessors drivers/scsi/arm/acornscsi.c
--- a/drivers/scsi/arm/acornscsi.c~scsi-pending-arm-convert-to-accessors
+++ a/drivers/scsi/arm/acornscsi.c
@@ -1790,7 +1790,7 @@ int acornscsi_starttransfer(AS_Host *hos
 	return 0;
     }
 
-    residual = host->SCpnt->request_bufflen - host->scsi.SCp.scsi_xferred;
+    residual = scsi_bufflen(host->SCpnt) - host->scsi.SCp.scsi_xferred;
 
     sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
     sbic_arm_writenext(host->scsi.io_port, residual >> 16);
@@ -2270,7 +2270,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA IN -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_readstatusbyte(host);
@@ -2281,7 +2281,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA IN -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_sendmessage(host);
@@ -2291,7 +2291,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA IN -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_message(host);	/* -> PHASE_MSGIN, PHASE_DISCONNECT		*/
@@ -2319,7 +2319,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA OUT -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2331,7 +2331,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA OUT -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2342,7 +2342,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *h
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA OUT -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
diff -puN drivers/scsi/arm/scsi.h~scsi-pending-arm-convert-to-accessors drivers/scsi/arm/scsi.h
--- a/drivers/scsi/arm/scsi.h~scsi-pending-arm-convert-to-accessors
+++ a/drivers/scsi/arm/scsi.h
@@ -68,46 +68,34 @@ static inline void init_SCp(struct scsi_
 {
 	memset(&SCpnt->SCp, 0, sizeof(struct scsi_pointer));
 
-	if (SCpnt->use_sg) {
+	if (scsi_bufflen(SCpnt)) {
 		unsigned long len = 0;
 		int buf;
 
-		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
+		SCpnt->SCp.buffer = scsi_sglist(SCpnt);
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 		SCpnt->SCp.ptr = sg_virt(SCpnt->SCp.buffer);
 		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
+		SCpnt->SCp.phase = scsi_bufflen(SCpnt);
 
 #ifdef BELT_AND_BRACES
 		/*
 		 * Calculate correct buffer length.  Some commands
-		 * come in with the wrong request_bufflen.
+		 * come in with the wrong scsi_bufflen.
 		 */
 		for (buf = 0; buf <= SCpnt->SCp.buffers_residual; buf++)
 			len += SCpnt->SCp.buffer[buf].length;
 
-		if (SCpnt->request_bufflen != len)
+		if (scsi_bufflen(SCpnt) != len) {
+			WARN_ON(1);
 			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
 			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
-			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
-		SCpnt->request_bufflen = len;
+			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
+		}
 #endif
 	} else {
-		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
-		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
-	}
-
-	/*
-	 * If the upper SCSI layers pass a buffer, but zero length,
-	 * we aren't interested in the buffer pointer.
-	 */
-	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
-#if 0 //def BELT_AND_BRACES
-		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
-		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
-		__scsi_print_command(SCpnt->cmnd);
-#endif
 		SCpnt->SCp.ptr = NULL;
+		SCpnt->SCp.this_residual = 0;
+		SCpnt->SCp.phase = 0;
 	}
 }
_
