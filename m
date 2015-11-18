From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 41/71] ncr5380: Replace redundant flags with FLAG_NO_DMA_FIXUP
Date: Wed, 18 Nov 2015 19:35:36 +1100
Message-ID: <20151118083507.511702423@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-FLAG_NCR53C400
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The flags DMA_WORKS_RIGHT, FLAG_NCR53C400 and FLAG_HAS_LAST_BYTE_SENT
all mean the same thing, i.e. the chip is not a 538[01]. (More recent
devices such as the 53C80 have a 'Last Byte Sent' bit in the Target
Command Register as well as other fixes for End-of-DMA errata.)

These flags have no additional meanings since previous cleanup patches
eliminated the NCR53C400 macro, moved g_NCR5380-specific code out of the
core driver and standardized interrupt handling.

Use the FLAG_NO_DMA_FIXUP flag to suppress End-of-DMA errata workarounds,
for those cards and drivers that make use of the TCR_LAST_BYTE_SENT bit.
Remove the old flags.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c   |   68 +++++++++++++++--------------------------------
 drivers/scsi/NCR5380.h   |    4 --
 drivers/scsi/dtc.c       |    4 --
 drivers/scsi/g_NCR5380.c |    5 +--
 4 files changed, 26 insertions(+), 55 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:55.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:56.000000000 +1100
@@ -552,7 +552,7 @@ static void prepare_info(struct Scsi_Hos
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
-	         hostdata->flags & FLAG_NCR53C400     ? "NCR53C400 "     : "",
+	         hostdata->flags & FLAG_NO_DMA_FIXUP  ? "NO_DMA_FIXUP "  : "",
 	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
@@ -712,6 +712,7 @@ static int NCR5380_init(struct Scsi_Host
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
+	hostdata->flags = flags;
 	
 	INIT_WORK(&hostdata->main_task, NCR5380_main);
 	hostdata->work_q = alloc_workqueue("ncr5380_%d",
@@ -720,12 +721,6 @@ static int NCR5380_init(struct Scsi_Host
 	if (!hostdata->work_q)
 		return -ENOMEM;
 
-	/* The CHECK code seems to break the 53C400. Will check it later maybe */
-	if (flags & FLAG_NCR53C400)
-		hostdata->flags = FLAG_HAS_LAST_BYTE_SENT | flags;
-	else
-		hostdata->flags = FLAG_CHECK_LAST_BYTE_SENT | flags;
-
 	hostdata->host = instance;
 
 	prepare_info(instance);
@@ -1609,7 +1604,7 @@ static int NCR5380_transfer_dma(struct S
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
-	if (hostdata->flags & FLAG_NCR53C400)
+	if (hostdata->flags & FLAG_NO_DMA_FIXUP)
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
 		                        MR_ENABLE_EOP_INTR);
 	else
@@ -1729,14 +1724,9 @@ static int NCR5380_transfer_dma(struct S
 	return 0;
 #else				/* defined(REAL_DMA_POLL) */
 	if (p & SR_IO) {
-#ifdef DMA_WORKS_RIGHT
-		foo = NCR5380_pread(instance, d, c);
-#else
-		int diff = 1;
-		if (hostdata->flags & FLAG_NCR53C400) {
-			diff = 0;
-		}
-		if (!(foo = NCR5380_pread(instance, d, c - diff))) {
+		foo = NCR5380_pread(instance, d,
+			hostdata->flags & FLAG_NO_DMA_FIXUP ? c : c - 1);
+		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
 			/*
 			 * We can't disable DMA mode after successfully transferring 
 			 * what we plan to be the last byte, since that would open up
@@ -1759,46 +1749,32 @@ static int NCR5380_transfer_dma(struct S
 			 * byte.
 			 */
 
-			if (!(hostdata->flags & FLAG_NCR53C400)) {
-				while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ));
-				/* Wait for clean handshake */
-				while (NCR5380_read(STATUS_REG) & SR_REQ);
-				d[c - 1] = NCR5380_read(INPUT_DATA_REG);
+			if (NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
+				foo = -1;
+				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
+			}
+			if (NCR5380_poll_politely(instance, STATUS_REG,
+			                          SR_REQ, 0, HZ) < 0) {
+				foo = -1;
+				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
 			}
+			d[c - 1] = NCR5380_read(INPUT_DATA_REG);
 		}
-#endif
 	} else {
-#ifdef DMA_WORKS_RIGHT
 		foo = NCR5380_pwrite(instance, d, c);
-#else
-		int timeout;
-		dprintk(NDEBUG_C400_PWRITE, "About to pwrite %d bytes\n", c);
-		if (!(foo = NCR5380_pwrite(instance, d, c))) {
+		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for 
 			 * the byte we're interested, we'll ACK it and it will go false.  
 			 */
-			if (!(hostdata->flags & FLAG_HAS_LAST_BYTE_SENT)) {
-				timeout = 20000;
-				while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) && (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH));
-
-				if (!timeout)
-					dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : timed out on last byte\n", instance->host_no);
-
-				if (hostdata->flags & FLAG_CHECK_LAST_BYTE_SENT) {
-					hostdata->flags &= ~FLAG_CHECK_LAST_BYTE_SENT;
-					if (NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT) {
-						hostdata->flags |= FLAG_HAS_LAST_BYTE_SENT;
-						dprintk(NDEBUG_LAST_BYTE_SENT, "scsi%d : last byte sent works\n", instance->host_no);
-					}
-				}
-			} else {
-				dprintk(NDEBUG_C400_PWRITE, "Waiting for LASTBYTE\n");
-				while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT));
-				dprintk(NDEBUG_C400_PWRITE, "Got LASTBYTE\n");
+			if (NCR5380_poll_politely2(instance,
+			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
+			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
+				foo = -1;
+				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
 			}
 		}
-#endif
 	}
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:33:51.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:33:56.000000000 +1100
@@ -226,9 +226,7 @@
 #define NO_IRQ		0
 #endif
 
-#define FLAG_HAS_LAST_BYTE_SENT		1	/* NCR53c81 or better */
-#define FLAG_CHECK_LAST_BYTE_SENT	2	/* Only test once */
-#define FLAG_NCR53C400			4	/* NCR53c400 */
+#define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
 #define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-11-18 19:33:53.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-11-18 19:33:56.000000000 +1100
@@ -1,7 +1,5 @@
 #define PSEUDO_DMA
 #define DONT_USE_INTR
-#define DMA_WORKS_RIGHT
-
 
 /*
  * DTC 3180/3280 driver, by
@@ -233,7 +231,7 @@ found:
 		instance->base = addr;
 		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
 
-		if (NCR5380_init(instance, 0))
+		if (NCR5380_init(instance, FLAG_NO_DMA_FIXUP))
 			goto out_unregister;
 
 		NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:53.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:56.000000000 +1100
@@ -320,9 +320,8 @@ static int __init generic_NCR5380_detect
 			flags = FLAG_NO_PSEUDO_DMA;
 			break;
 		case BOARD_NCR53C400:
-#ifdef PSEUDO_DMA
-			flags = FLAG_NCR53C400;
-#else
+			flags = FLAG_NO_DMA_FIXUP;
+#ifndef PSEUDO_DMA
 			flags = FLAG_NO_PSEUDO_DMA;
 #endif
 			break;
