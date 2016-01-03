From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 24/78] ncr5380: Implement NCR5380_dma_xfer_len and remove
 LIMIT_TRANSFERSIZE macro
Date: Sun, 03 Jan 2016 16:05:25 +1100
Message-ID: <20160103050507.391774791@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-implement-NCR5380_dma_xfer_len
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Follow the example of the atari_NCR5380.c core driver and adopt the
NCR5380_dma_xfer_len() hook. Implement NCR5380_dma_xfer_len() for dtc.c
and g_NCR5380.c to take care of the limitations of these cards. Keep the
default for drivers using PSEUDO_DMA.

Eliminate the unused macro LIMIT_TRANSFERSIZE. 

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   32 +++++---------------------------
 drivers/scsi/arm/cumana_1.c  |    3 +++
 drivers/scsi/arm/oak.c       |    2 ++
 drivers/scsi/atari_NCR5380.c |    8 +++++---
 drivers/scsi/dtc.c           |   14 ++++++++++++++
 drivers/scsi/dtc.h           |    3 +++
 drivers/scsi/g_NCR5380.c     |   15 +++++++++++++++
 drivers/scsi/g_NCR5380.h     |    3 +++
 drivers/scsi/mac_scsi.c      |    1 +
 drivers/scsi/pas16.h         |    2 ++
 drivers/scsi/t128.h          |    2 ++
 11 files changed, 55 insertions(+), 30 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:30.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:31.000000000 +1100
@@ -201,11 +201,6 @@
  * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
  *      override-configure an IRQ.
  *
- * LIMIT_TRANSFERSIZE - if defined, limit the pseudo-dma transfers to 512
- *      bytes at a time.  Since interrupts are disabled by default during
- *      these transfers, we might need this to give reasonable interrupt
- *      service time if the transfer size gets too large.
- *
  * LINKED - if defined, linked commands are supported.
  *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
@@ -2000,29 +1995,12 @@ static void NCR5380_information_transfer
 				 */
 
 #if defined(PSEUDO_DMA) || defined(REAL_DMA_POLL)
-				/* KLL
-				 * PSEUDO_DMA is defined here. If this is the g_NCR5380
-				 * driver then it will always be defined, so the
-				 * FLAG_NO_PSEUDO_DMA is used to inhibit PDMA in the base
-				 * NCR5380 case.  I think this is a fairly clean solution.
-				 * We supplement these 2 if's with the flag.
-				 */
-#ifdef NCR5380_dma_xfer_len
-				if (!cmd->device->borken && !(hostdata->flags & FLAG_NO_PSEUDO_DMA) && (transfersize = NCR5380_dma_xfer_len(instance, cmd)) != 0) {
-#else
-				transfersize = cmd->transfersize;
+				transfersize = 0;
+				if (!cmd->device->borken &&
+				    !(hostdata->flags & FLAG_NO_PSEUDO_DMA))
+					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
 
-#ifdef LIMIT_TRANSFERSIZE	/* If we have problems with interrupt service */
-				if (transfersize > 512)
-					transfersize = 512;
-#endif				/* LIMIT_TRANSFERSIZE */
-
-				if (!cmd->device->borken && transfersize && !(hostdata->flags & FLAG_NO_PSEUDO_DMA) && cmd->SCp.this_residual && !(cmd->SCp.this_residual % transfersize)) {
-					/* Limit transfers to 32K, for xx400 & xx406
-					 * pseudoDMA that transfers in 128 bytes blocks. */
-					if (transfersize > 32 * 1024)
-						transfersize = 32 * 1024;
-#endif
+				if (transfersize) {
 					len = transfersize;
 					if (NCR5380_transfer_dma(instance, &phase, &len, (unsigned char **) &cmd->SCp.ptr)) {
 						/*
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:30.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:31.000000000 +1100
@@ -2170,11 +2170,13 @@ static void NCR5380_information_transfer
 				 */
 
 #if defined(REAL_DMA)
-				if (
 #if !defined(CONFIG_SUN3)
-				    !cmd->device->borken &&
+				transfersize = 0;
+				if (!cmd->device->borken)
 #endif
-				    (transfersize = NCR5380_dma_xfer_len(instance, cmd, phase)) >= DMA_MIN_SIZE) {
+					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
+
+				if (transfersize >= DMA_MIN_SIZE) {
 					len = transfersize;
 					cmd->SCp.phase = phase;
 					if (NCR5380_transfer_dma(instance, &phase,
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:03:31.000000000 +1100
@@ -419,6 +419,20 @@ static inline int NCR5380_pwrite(struct
 	return (0);
 }
 
+static int dtc_dma_xfer_len(struct scsi_cmnd *cmd)
+{
+	int transfersize = cmd->transfersize;
+
+	/* Limit transfers to 32K, for xx400 & xx406
+	 * pseudoDMA that transfers in 128 bytes blocks.
+	 */
+	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
+	    !(cmd->SCp.this_residual % transfersize))
+		transfersize = 32 * 1024;
+
+	return transfersize;
+}
+
 MODULE_LICENSE("GPL");
 
 #include "NCR5380.c"
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:31.000000000 +1100
@@ -699,6 +699,21 @@ static inline int NCR5380_pwrite(struct
 		; 	// TIMEOUT
 	return 0;
 }
+
+static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
+{
+	int transfersize = cmd->transfersize;
+
+	/* Limit transfers to 32K, for xx400 & xx406
+	 * pseudoDMA that transfers in 128 bytes blocks.
+	 */
+	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
+	    !(cmd->SCp.this_residual % transfersize))
+		transfersize = 32 * 1024;
+
+	return transfersize;
+}
+
 #endif /* PSEUDO_DMA */
 
 /*
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:03:06.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:03:31.000000000 +1100
@@ -73,6 +73,9 @@
 
 #endif
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase) \
+        generic_NCR5380_dma_xfer_len(cmd)
+
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command
 #define NCR5380_abort generic_NCR5380_abort
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-01-03 16:02:56.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-01-03 16:03:31.000000000 +1100
@@ -27,6 +27,9 @@
 #define NCR5380_read(reg) (readb(DTC_address(reg)))
 #define NCR5380_write(reg, value) (writeb(value, DTC_address(reg)))
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase) \
+        dtc_dma_xfer_len(cmd)
+
 #define NCR5380_intr			dtc_intr
 #define NCR5380_queue_command		dtc_queue_command
 #define NCR5380_abort			dtc_abort
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-01-03 16:03:31.000000000 +1100
@@ -22,6 +22,9 @@
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 #define NCR5380_read(reg)		cumanascsi_read(instance, reg)
 #define NCR5380_write(reg, value)	cumanascsi_write(instance, reg, value)
+
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
 #define NCR5380_info			cumanascsi_info
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-01-03 16:03:31.000000000 +1100
@@ -26,6 +26,8 @@
 #define NCR5380_write(reg, value) \
 	writeb(value, priv(instance)->base + ((reg) << 2))
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
 #define NCR5380_show_info		oakscsi_show_info
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-01-03 16:03:31.000000000 +1100
@@ -38,6 +38,7 @@
 
 #define NCR5380_pread                   macscsi_pread
 #define NCR5380_pwrite                  macscsi_pwrite
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2016-01-03 16:02:56.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2016-01-03 16:03:31.000000000 +1100
@@ -110,6 +110,8 @@
 #define NCR5380_read(reg) ( inb(PAS16_io_port(reg)) )
 #define NCR5380_write(reg, value) ( outb((value),PAS16_io_port(reg)) )
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+
 #define NCR5380_intr pas16_intr
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-01-03 16:02:56.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-01-03 16:03:31.000000000 +1100
@@ -84,6 +84,8 @@
 #define NCR5380_read(reg) readb(T128_address(reg))
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+
 #define NCR5380_intr t128_intr
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
