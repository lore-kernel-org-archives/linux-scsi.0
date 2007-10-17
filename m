From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 8/32] arm: scsi convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 19:41:29 +0200
Message-ID: <47164949.7040200@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30583 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758250AbXJQRmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:42:33 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/arm/acornscsi.c |   14 +++++++-------
 drivers/scsi/arm/scsi.h      |   34 +++++++++++-----------------------
 2 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index eceacf6..3bedf24 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1790,7 +1790,7 @@ int acornscsi_starttransfer(AS_Host *host)
 	return 0;
     }
 
-    residual = host->SCpnt->request_bufflen - host->scsi.SCp.scsi_xferred;
+    residual = scsi_bufflen(host->SCpnt) - host->scsi.SCp.scsi_xferred;
 
     sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
     sbic_arm_writenext(host->scsi.io_port, residual >> 16);
@@ -2270,7 +2270,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA IN -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_readstatusbyte(host);
@@ -2281,7 +2281,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA IN -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_sendmessage(host);
@@ -2291,7 +2291,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA IN -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_message(host);	/* -> PHASE_MSGIN, PHASE_DISCONNECT		*/
@@ -2319,7 +2319,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA OUT -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2331,7 +2331,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA OUT -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2342,7 +2342,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA OUT -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
index 21ba571..95cfb21 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/scsi.h
@@ -70,48 +70,36 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
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
 		SCpnt->SCp.ptr = (char *)
 			 (page_address(SCpnt->SCp.buffer->page) +
 			  SCpnt->SCp.buffer->offset);
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
-- 
1.5.3.1


