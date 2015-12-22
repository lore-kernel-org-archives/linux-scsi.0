From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 42/77] ncr5380: Replace READ_OVERRUNS macro with FLAG_NO_DMA_FIXUPS
Date: Tue, 22 Dec 2015 12:18:20 +1100
Message-ID: <20151222011749.446042594@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-READ_OVERRUNS
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

The workarounds for chip errata appear twice, in slightly different
forms. One is used when defined(REAL_DMA) || defined(REAL_DMA_POLL), the
other when defined(PSEUDO_DMA). In the PDMA case, the workarounds have
been made conditional on FLAG_NO_DMA_FIXUPS. Do the same for the DMA case,
to eliminate the READ_OVERRUNS macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:32.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:34.000000000 +1100
@@ -94,11 +94,6 @@
 #undef REAL_DMA
 #endif
 
-#ifdef REAL_DMA_POLL
-#undef READ_OVERRUNS
-#define READ_OVERRUNS
-#endif
-
 #ifdef BOARD_REQUIRES_NO_DELAY
 #define io_recovery_delay(x)
 #else
@@ -1586,11 +1581,10 @@ static int NCR5380_transfer_dma(struct S
 		return -1;
 	}
 #if defined(REAL_DMA) || defined(REAL_DMA_POLL)
-#ifdef READ_OVERRUNS
 	if (p & SR_IO) {
-		c -= 2;
+		if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS))
+			c -= 2;
 	}
-#endif
 	dprintk(NDEBUG_DMA, "scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d);
 	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
 #endif
@@ -1676,13 +1670,14 @@ static int NCR5380_transfer_dma(struct S
  */
 
 	if (p & SR_IO) {
-#ifdef READ_OVERRUNS
-		udelay(10);
-		if (((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_ACK)) == (BASR_PHASE_MATCH | BASR_ACK))) {
-			saved_data = NCR5380_read(INPUT_DATA_REGISTER);
-			overrun = 1;
+		if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS)) {
+			udelay(10);
+			if ((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_ACK)) ==
+			    (BASR_PHASE_MATCH | BASR_ACK)) {
+				saved_data = NCR5380_read(INPUT_DATA_REGISTER);
+				overrun = 1;
+			}
 		}
-#endif
 	} else {
 		int limit = 100;
 		while (((tmp = NCR5380_read(BUS_AND_STATUS_REG)) & BASR_ACK) || (NCR5380_read(STATUS_REG) & SR_REQ)) {
@@ -1704,8 +1699,8 @@ static int NCR5380_transfer_dma(struct S
 	*data += c;
 	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
 
-#ifdef READ_OVERRUNS
-	if (*phase == p && (p & SR_IO) && residue == 0) {
+	if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS) &&
+	    *phase == p && (p & SR_IO) && residue == 0) {
 		if (overrun) {
 			dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 			**data = saved_data;
@@ -1720,7 +1715,6 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_transfer_pio(instance, phase, &cnt, data);
 		*count -= toPIO - cnt;
 	}
-#endif
 
 	dprintk(NDEBUG_DMA, "Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count));
 	return 0;
