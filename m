From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 24/29] atari_scsi: Remove header
Date: Thu, 02 Oct 2014 16:56:52 +1000
Message-ID: <20141002065634.006164009@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33735 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaJBNEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:04:15 -0400
Content-Disposition: inline; filename=atari_scsi-remove-header
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The #defines in atari_scsi.h are intended to influence subsequent #includes
in atari_scsi.c. IMHO, that's too convoluted.

Remove atari_scsi.h by moving those macro definitions to atari_scsi.c,
consistent with other NCR5380 drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_scsi.c |   35 ++++++++++++++++++++++++++---------
 drivers/scsi/atari_scsi.h |   40 ----------------------------------------
 2 files changed, 26 insertions(+), 49 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-02 16:56:21.000000000 +1000
+++ linux/drivers/scsi/atari_scsi.c	2014-10-02 16:56:22.000000000 +1000
@@ -64,15 +64,7 @@
 /**************************************************************************/
 
 
-
 #include <linux/module.h>
-
-/* For the Atari version, use only polled IO or REAL_DMA */
-#define	REAL_DMA
-/* Support tagged queuing? (on devices that are able to... :-) */
-#define	SUPPORT_TAGS
-#define	MAX_TAGS 32
-
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
@@ -92,9 +84,34 @@
 
 #include <scsi/scsi_host.h>
 
-#include "atari_scsi.h"
+/* Definitions for the core NCR5380 driver. */
+
+#define REAL_DMA
+#define SUPPORT_TAGS
+#define MAX_TAGS                        32
+
+#define NCR5380_implementation_fields   /* none */
+
+#define NCR5380_read(reg)               atari_scsi_reg_read(reg)
+#define NCR5380_write(reg, value)       atari_scsi_reg_write(reg, value)
+
+#define NCR5380_queue_command           atari_scsi_queue_command
+#define NCR5380_abort                   atari_scsi_abort
+#define NCR5380_show_info               atari_scsi_show_info
+#define NCR5380_info                    atari_scsi_info
+
+#define NCR5380_dma_read_setup(instance, data, count) \
+        atari_scsi_dma_setup(instance, data, count, 0)
+#define NCR5380_dma_write_setup(instance, data, count) \
+        atari_scsi_dma_setup(instance, data, count, 1)
+#define NCR5380_dma_residual(instance) \
+        atari_scsi_dma_residual(instance)
+#define NCR5380_dma_xfer_len(instance, cmd, phase) \
+        atari_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
+
 #include "NCR5380.h"
 
+
 #define	IS_A_TT()	ATARIHW_PRESENT(TT_SCSI)
 
 #define	SCSI_DMA_WRITE_P(elt,val)				\
Index: linux/drivers/scsi/atari_scsi.h
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.h	2014-10-02 16:56:21.000000000 +1000
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,40 +0,0 @@
-/*
- * atari_scsi.h -- Header file for the Atari native SCSI driver
- *
- * Copyright 1994 Roman Hodek <Roman.Hodek@informatik.uni-erlangen.de>
- *
- * (Loosely based on the work of Robert De Vries' team)
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- *
- */
-
-
-#ifndef ATARI_SCSI_H
-#define ATARI_SCSI_H
-
-/* (I_HAVE_OVERRUNS stuff removed) */
-
-#ifndef ASM
-
-#define	NCR5380_implementation_fields	/* none */
-
-#define NCR5380_read(reg)		  atari_scsi_reg_read( reg )
-#define NCR5380_write(reg, value) atari_scsi_reg_write( reg, value )
-
-#define NCR5380_queue_command atari_scsi_queue_command
-#define NCR5380_abort atari_scsi_abort
-#define NCR5380_show_info atari_scsi_show_info
-#define NCR5380_info atari_scsi_info
-#define NCR5380_dma_read_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 0)
-#define NCR5380_dma_write_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 1)
-#define NCR5380_dma_residual(inst) atari_scsi_dma_residual( inst )
-#define	NCR5380_dma_xfer_len(i,cmd,phase) \
-	atari_dma_xfer_len(cmd->SCp.this_residual,cmd,((phase) & SR_IO) ? 0 : 1)
-
-#endif /* ndef ASM */
-#endif /* ATARI_SCSI_H */
-
-


