From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 04/23] atari_NCR5380: Remove DMA_MIN_SIZE macro
Date: Mon, 21 Mar 2016 13:31:53 +1100
Message-ID: <20160321023150.654436098@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52784 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbcCUEF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 00:05:27 -0400
Content-Disposition: inline; filename=atari_NCR5380-remove-DMA_MIN_SIZE-macro
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

Only the atari_scsi and sun3_scsi drivers define DMA_MIN_SIZE.
Both drivers also define NCR5380_dma_xfer_len, which means
DMA_MIN_SIZE can be removed from the core driver.

This removes another discrepancy between the two core drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

Changes since v1:
- Retain MIN_DMA_SIZE macro in wrapper drivers.

---
 drivers/scsi/atari_NCR5380.c |   16 ++++++++--------
 drivers/scsi/atari_scsi.c    |    6 +++++-
 drivers/scsi/sun3_scsi.c     |   19 +++++++++----------
 3 files changed, 22 insertions(+), 19 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-03-21 13:31:10.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-03-21 13:31:13.000000000 +1100
@@ -1857,12 +1857,11 @@ static void NCR5380_information_transfer
 					d = cmd->SCp.ptr;
 				}
 				/* this command setup for dma yet? */
-				if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != cmd)) {
-					if (cmd->request->cmd_type == REQ_TYPE_FS) {
-						sun3scsi_dma_setup(instance, d, count,
-						                   rq_data_dir(cmd->request));
-						sun3_dma_setup_done = cmd;
-					}
+				if (sun3_dma_setup_done != cmd &&
+				    sun3scsi_dma_xfer_len(count, cmd) > 0) {
+					sun3scsi_dma_setup(instance, d, count,
+					                   rq_data_dir(cmd->request));
+					sun3_dma_setup_done = cmd;
 				}
 #ifdef SUN3_SCSI_VME
 				dregs->csr |= CSR_INTR;
@@ -1927,7 +1926,7 @@ static void NCR5380_information_transfer
 #endif
 					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
 
-				if (transfersize >= DMA_MIN_SIZE) {
+				if (transfersize > 0) {
 					len = transfersize;
 					cmd->SCp.phase = phase;
 					if (NCR5380_transfer_dma(instance, &phase,
@@ -2366,7 +2365,8 @@ static void NCR5380_reselect(struct Scsi
 			d = tmp->SCp.ptr;
 		}
 		/* setup this command for dma if not already */
-		if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != tmp)) {
+		if (sun3_dma_setup_done != tmp &&
+		    sun3scsi_dma_xfer_len(count, tmp) > 0) {
 			sun3scsi_dma_setup(instance, d, count,
 			                   rq_data_dir(tmp->request));
 			sun3_dma_setup_done = tmp;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-21 13:31:10.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-21 13:31:13.000000000 +1100
@@ -83,11 +83,12 @@
 
 #include <scsi/scsi_host.h>
 
+#define DMA_MIN_SIZE                    32
+
 /* Definitions for the core NCR5380 driver. */
 
 #define SUPPORT_TAGS
 #define MAX_TAGS                        32
-#define DMA_MIN_SIZE                    32
 
 #define NCR5380_implementation_fields   /* none */
 
@@ -605,6 +606,9 @@ static unsigned long atari_dma_xfer_len(
 {
 	unsigned long	possible_len, limit;
 
+	if (wanted_len < DMA_MIN_SIZE)
+		return 0;
+
 	if (IS_A_TT())
 		/* TT SCSI DMA can transfer arbitrary #bytes */
 		return wanted_len;
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2016-03-21 13:31:10.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2016-03-21 13:31:13.000000000 +1100
@@ -36,12 +36,12 @@
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 
-/* Definitions for the core NCR5380 driver. */
-
-/* #define SUPPORT_TAGS */
 /* minimum number of bytes to do dma on */
 #define DMA_MIN_SIZE                    129
 
+/* Definitions for the core NCR5380 driver. */
+
+/* #define SUPPORT_TAGS */
 /* #define MAX_TAGS                     32 */
 
 #define NCR5380_implementation_fields   /* none */
@@ -61,7 +61,7 @@
 #define NCR5380_dma_residual(instance) \
         sun3scsi_dma_residual(instance)
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
+        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd)
 
 #define NCR5380_acquire_dma_irq(instance)    (1)
 #define NCR5380_release_dma_irq(instance)
@@ -262,14 +262,13 @@ static inline unsigned long sun3scsi_dma
 	return last_residual;
 }
 
-static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted,
-						  struct scsi_cmnd *cmd,
-						  int write_flag)
+static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted_len,
+                                                  struct scsi_cmnd *cmd)
 {
-	if (cmd->request->cmd_type == REQ_TYPE_FS)
- 		return wanted;
-	else
+	if (wanted_len < DMA_MIN_SIZE || cmd->request->cmd_type != REQ_TYPE_FS)
 		return 0;
+
+	return wanted_len;
 }
 
 static inline int sun3scsi_dma_start(unsigned long count, unsigned char *data)


