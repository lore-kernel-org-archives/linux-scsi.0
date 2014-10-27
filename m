From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 06/36] ncr5380: Remove more useless prototypes
Date: Mon, 27 Oct 2014 16:26:13 +1100
Message-ID: <20141027052608.595432496@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48323 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaJ0Kbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:31:51 -0400
Content-Disposition: inline; filename=ncr5380-remove-more-useless-prototypes
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Make use of the host template static initializer instead of assigning
handlers at run-time. Move __maybe_unused qualifiers from declarations
to definitions. Move the atari_scsi_bus_reset() wrapper after the
definition of NCR5380_bus_reset(). All of the host template handler
prototypes are now redundant so remove them.

The write_info() handler is only relevant to drivers using PSEUDO_DMA so
this patch fixes the compiler warning in atari_NCR5380.c and sun3_NCR5380.c:

  CC      drivers/scsi/atari_scsi.o
  drivers/scsi/NCR5380.h:329: warning: 'NCR5380_write_info' declared 'static' but never defined

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.h       |    8 ----
 drivers/scsi/atari_NCR5380.c |    3 +
 drivers/scsi/atari_scsi.c    |   76 ++++++++++++++++++++-----------------------
 drivers/scsi/dtc.c           |    7 +--
 drivers/scsi/pas16.c         |    7 +--
 drivers/scsi/sun3_NCR5380.c  |    3 +
 drivers/scsi/t128.c          |    7 +--
 7 files changed, 50 insertions(+), 61 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:25:06.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:25:14.000000000 +1100
@@ -322,14 +322,6 @@ static irqreturn_t NCR5380_intr(int irq,
 #endif
 static void NCR5380_main(struct work_struct *work);
 static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
-static int NCR5380_abort(Scsi_Cmnd * cmd);
-static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
-static int NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int __maybe_unused NCR5380_show_info(struct seq_file *,
-	struct Scsi_Host *);
-static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
-	char *buffer, int length);
-
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-27 16:25:08.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2014-10-27 16:25:14.000000000 +1100
@@ -219,10 +219,6 @@ static int __init dtc_detect(struct scsi
 	void __iomem *base;
 	int sig, count;
 
-	tpnt->proc_name = "dtc3x80";
-	tpnt->show_info = dtc_show_info;
-	tpnt->write_info = dtc_write_info;
-
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 		addr = 0;
 		base = NULL;
@@ -477,6 +473,9 @@ static struct scsi_host_template driver_
 	.name				= "DTC 3180/3280 ",
 	.detect				= dtc_detect,
 	.release			= dtc_release,
+	.proc_name			= "dtc3x80",
+	.show_info			= dtc_show_info,
+	.write_info			= dtc_write_info,
 	.queuecommand			= dtc_queue_command,
 	.eh_abort_handler		= dtc_abort,
 	.eh_bus_reset_handler		= dtc_bus_reset,
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-27 16:25:12.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-10-27 16:25:14.000000000 +1100
@@ -390,10 +390,6 @@ static int __init pas16_detect(struct sc
     unsigned short io_port;
     int  count;
 
-    tpnt->proc_name = "pas16";
-    tpnt->show_info = pas16_show_info;
-    tpnt->write_info = pas16_write_info;
-
     if (pas16_addr != 0) {
 	overrides[0].io_port = pas16_addr;
 	/*
@@ -620,6 +616,9 @@ static struct scsi_host_template driver_
 	.name           = "Pro Audio Spectrum-16 SCSI",
 	.detect         = pas16_detect,
 	.release        = pas16_release,
+	.proc_name      = "pas16",
+	.show_info      = pas16_show_info,
+	.write_info     = pas16_write_info,
 	.queuecommand   = pas16_queue_command,
 	.eh_abort_handler = pas16_abort,
 	.eh_bus_reset_handler = pas16_bus_reset,
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-27 16:25:12.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-10-27 16:25:14.000000000 +1100
@@ -201,10 +201,6 @@ static int __init t128_detect(struct scs
     void __iomem *p;
     int sig, count;
 
-    tpnt->proc_name = "t128";
-    tpnt->show_info = t128_show_info;
-    tpnt->write_info = t128_write_info;
-
     for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 	base = 0;
 	p = NULL;
@@ -435,6 +431,9 @@ static struct scsi_host_template driver_
 	.name           = "Trantor T128/T128F/T228",
 	.detect         = t128_detect,
 	.release        = t128_release,
+	.proc_name      = "t128",
+	.show_info      = t128_show_info,
+	.write_info     = t128_write_info,
 	.queuecommand   = t128_queue_command,
 	.eh_abort_handler = t128_abort,
 	.eh_bus_reset_handler    = t128_bus_reset,
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:14.000000000 +1100
@@ -772,7 +772,8 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cm
 	seq_printf(m, "\n");
 }
 
-static int NCR5380_show_info(struct seq_file *m, struct Scsi_Host *instance)
+static int __maybe_unused NCR5380_show_info(struct seq_file *m,
+                                            struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
 	Scsi_Cmnd *ptr;
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:25:14.000000000 +1100
@@ -718,7 +718,8 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cm
 	seq_printf(m, "\n");
 }
 
-static int NCR5380_show_info(struct seq_file *m, struct Scsi_Host *instance)
+static int __maybe_unused NCR5380_show_info(struct seq_file *m,
+                                            struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
 	Scsi_Cmnd *ptr;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:12.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:14.000000000 +1100
@@ -783,45 +783,6 @@ static int __init atari_scsi_setup(char
 __setup("atascsi=", atari_scsi_setup);
 #endif /* !MODULE */
 
-static int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
-{
-	int rv;
-	struct NCR5380_hostdata *hostdata =
-		(struct NCR5380_hostdata *)cmd->device->host->hostdata;
-
-	/* For doing the reset, SCSI interrupts must be disabled first,
-	 * since the 5380 raises its IRQ line while _RST is active and we
-	 * can't disable interrupts completely, since we need the timer.
-	 */
-	/* And abort a maybe active DMA transfer */
-	if (IS_A_TT()) {
-		atari_turnoff_irq(IRQ_TT_MFP_SCSI);
-#ifdef REAL_DMA
-		tt_scsi_dma.dma_ctrl = 0;
-#endif /* REAL_DMA */
-	} else {
-		atari_turnoff_irq(IRQ_MFP_FSCSI);
-#ifdef REAL_DMA
-		st_dma.dma_mode_status = 0x90;
-		atari_dma_active = 0;
-		atari_dma_orig_addr = NULL;
-#endif /* REAL_DMA */
-	}
-
-	rv = NCR5380_bus_reset(cmd);
-
-	/* Re-enable ints */
-	if (IS_A_TT()) {
-		atari_turnon_irq(IRQ_TT_MFP_SCSI);
-	} else {
-		atari_turnon_irq(IRQ_MFP_FSCSI);
-	}
-	if (rv == SUCCESS)
-		falcon_release_lock_if_possible(hostdata);
-
-	return rv;
-}
-
 
 #ifdef CONFIG_ATARI_SCSI_RESET_BOOT
 static void __init atari_scsi_reset_boot(void)
@@ -1094,6 +1055,43 @@ static void atari_scsi_falcon_reg_write(
 
 #include "atari_NCR5380.c"
 
+static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
+{
+	int rv;
+	struct NCR5380_hostdata *hostdata = shost_priv(cmd->device->host);
+
+	/* For doing the reset, SCSI interrupts must be disabled first,
+	 * since the 5380 raises its IRQ line while _RST is active and we
+	 * can't disable interrupts completely, since we need the timer.
+	 */
+	/* And abort a maybe active DMA transfer */
+	if (IS_A_TT()) {
+		atari_turnoff_irq(IRQ_TT_MFP_SCSI);
+#ifdef REAL_DMA
+		tt_scsi_dma.dma_ctrl = 0;
+#endif
+	} else {
+		atari_turnoff_irq(IRQ_MFP_FSCSI);
+#ifdef REAL_DMA
+		st_dma.dma_mode_status = 0x90;
+		atari_dma_active = 0;
+		atari_dma_orig_addr = NULL;
+#endif
+	}
+
+	rv = NCR5380_bus_reset(cmd);
+
+	if (IS_A_TT())
+		atari_turnon_irq(IRQ_TT_MFP_SCSI);
+	else
+		atari_turnon_irq(IRQ_MFP_FSCSI);
+
+	if (rv == SUCCESS)
+		falcon_release_lock_if_possible(hostdata);
+
+	return rv;
+}
+
 static struct scsi_host_template driver_template = {
 	.show_info		= atari_scsi_show_info,
 	.name			= "Atari native SCSI",


