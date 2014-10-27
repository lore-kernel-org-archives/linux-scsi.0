From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 33/36] atari_NCR5380: Introduce FLAG_TAGGED_QUEUING
Date: Mon, 27 Oct 2014 16:26:40 +1100
Message-ID: <20141027052615.105777702@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48351 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaJ0KcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:32:08 -0400
Content-Disposition: inline; filename=atari_NCR5380-introduce-FLAG_TAGGED_QUEUING
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The static variable setup_use_tagged_queuing is declared in mac_scsi.c,
sun3_scsi.c and atari_scsi.c and doesn't belong in the core driver.
None of the other NCR5380 drivers suffer from this layering issue which
makes merging the core drivers more difficult and will likely hinder plans
for future use of platform data to configure the driver.

Replace the static variable with a host flag. This way it can be reported
along with the other flags.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.h       |    1 +
 drivers/scsi/atari_NCR5380.c |   22 +++++++++++++---------
 drivers/scsi/atari_scsi.c    |    8 ++++----
 drivers/scsi/mac_scsi.c      |    8 ++++----
 drivers/scsi/sun3_scsi.c     |   12 ++++++------
 5 files changed, 28 insertions(+), 23 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:25:54.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:26:00.000000000 +1100
@@ -242,6 +242,7 @@
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
 #define FLAG_DTC3181E			16	/* DTC3181E */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
+#define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
 
 #ifndef ASM
 struct NCR5380_hostdata {
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:59.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:26:00.000000000 +1100
@@ -283,12 +283,12 @@ typedef struct {
 static TAG_ALLOC TagAlloc[8][8];	/* 8 targets and 8 LUNs */
 
 
-static void __init init_tags(void)
+static void __init init_tags(struct NCR5380_hostdata *hostdata)
 {
 	int target, lun;
 	TAG_ALLOC *ta;
 
-	if (!setup_use_tagged_queuing)
+	if (!(hostdata->flags & FLAG_TAGGED_QUEUING))
 		return;
 
 	for (target = 0; target < 8; ++target) {
@@ -321,7 +321,8 @@ static int is_lun_busy(struct scsi_cmnd
 	if (hostdata->busy[cmd->device->id] & (1 << lun))
 		return 1;
 	if (!should_be_tagged ||
-	    !setup_use_tagged_queuing || !cmd->device->tagged_supported)
+	    !(hostdata->flags & FLAG_TAGGED_QUEUING) ||
+	    !cmd->device->tagged_supported)
 		return 0;
 	if (TagAlloc[cmd->device->id][lun].nr_allocated >=
 	    TagAlloc[cmd->device->id][lun].queue_size) {
@@ -347,7 +348,8 @@ static void cmd_get_tag(struct scsi_cmnd
 	 * an untagged command.
 	 */
 	if (!should_be_tagged ||
-	    !setup_use_tagged_queuing || !cmd->device->tagged_supported) {
+	    !(hostdata->flags & FLAG_TAGGED_QUEUING) ||
+	    !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
 		hostdata->busy[cmd->device->id] |= (1 << lun);
 		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
@@ -392,12 +394,12 @@ static void cmd_free_tag(struct scsi_cmn
 }
 
 
-static void free_all_tags(void)
+static void free_all_tags(struct NCR5380_hostdata *hostdata)
 {
 	int target, lun;
 	TAG_ALLOC *ta;
 
-	if (!setup_use_tagged_queuing)
+	if (!(hostdata->flags & FLAG_TAGGED_QUEUING))
 		return;
 
 	for (target = 0; target < 8; ++target) {
@@ -653,11 +655,13 @@ static void prepare_info(struct Scsi_Hos
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
+	         "flags { %s}, "
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
+	         hostdata->flags & FLAG_TAGGED_QUEUING ? "TAGGED_QUEUING " : "",
 #ifdef DIFFERENTIAL
 	         "DIFFERENTIAL "
 #endif
@@ -799,7 +803,7 @@ static int __init NCR5380_init(struct Sc
 	for (i = 0; i < 8; ++i)
 		hostdata->busy[i] = 0;
 #ifdef SUPPORT_TAGS
-	init_tags();
+	init_tags(hostdata);
 #endif
 #if defined (REAL_DMA)
 	hostdata->dma_len = 0;
@@ -2569,7 +2573,7 @@ static void NCR5380_reselect(struct Scsi
 	 * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
 	 */
 	tag = TAG_NONE;
-	if (phase == PHASE_MSGIN && setup_use_tagged_queuing) {
+	if (phase == PHASE_MSGIN && (hostdata->flags & FLAG_TAGGED_QUEUING)) {
 		/* Accept previous IDENTIFY message by clearing ACK */
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		len = 2;
@@ -3025,7 +3029,7 @@ static int NCR5380_bus_reset(struct scsi
 	hostdata->connected = NULL;
 	hostdata->disconnected_queue = NULL;
 #ifdef SUPPORT_TAGS
-	free_all_tags();
+	free_all_tags(hostdata);
 #endif
 	for (i = 0; i < 8; ++i)
 		hostdata->busy[i] = 0;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:56.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:26:00.000000000 +1100
@@ -891,10 +891,6 @@ static int __init atari_scsi_probe(struc
 		}
 	}
 
-#ifdef SUPPORT_TAGS
-	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = 0;
-#endif
 
 #ifdef REAL_DMA
 	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
@@ -930,6 +926,10 @@ static int __init atari_scsi_probe(struc
 
 	host_flags |= IS_A_TT() ? 0 : FLAG_LATE_DMA_SETUP;
 
+#ifdef SUPPORT_TAGS
+	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
+#endif
+
 	NCR5380_init(instance, host_flags);
 
 	if (IS_A_TT()) {
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:58.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:26:00.000000000 +1100
@@ -522,6 +522,7 @@ static int __init sun3_scsi_probe(struct
 	int error;
 	struct resource *irq, *mem;
 	unsigned char *ioaddr;
+	int host_flags = 0;
 #ifdef SUN3_SCSI_VME
 	int i;
 #endif
@@ -535,11 +536,6 @@ static int __init sun3_scsi_probe(struct
 	if (setup_hostid >= 0)
 		sun3_scsi_template.this_id = setup_hostid & 7;
 
-#ifdef SUPPORT_TAGS
-	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = 1;
-#endif
-
 #ifdef SUN3_SCSI_VME
 	ioaddr = NULL;
 	for (i = 0; i < 2; i++) {
@@ -601,7 +597,11 @@ static int __init sun3_scsi_probe(struct
 	instance->io_port = (unsigned long)ioaddr;
 	instance->irq = irq->start;
 
-	NCR5380_init(instance, 0);
+#ifdef SUPPORT_TAGS
+	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
+#endif
+
+	NCR5380_init(instance, host_flags);
 
 	error = request_irq(instance->irq, scsi_sun3_intr, 0,
 	                    "NCR5380", instance);
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:44.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:26:00.000000000 +1100
@@ -411,10 +411,6 @@ static int __init mac_scsi_probe(struct
 		mac_scsi_template.sg_tablesize = setup_sg_tablesize;
 	if (setup_hostid >= 0)
 		mac_scsi_template.this_id = setup_hostid & 7;
-#ifdef SUPPORT_TAGS
-	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = 0;
-#endif
 	if (setup_use_pdma < 0)
 		setup_use_pdma = 0;
 
@@ -440,6 +436,10 @@ static int __init mac_scsi_probe(struct
 	mac_scsi_reset_boot(instance);
 #endif
 
+#ifdef SUPPORT_TAGS
+	host_flags |= setup_use_tagged_queuing > 0 ? FLAG_TAGGED_QUEUING : 0;
+#endif
+
 	NCR5380_init(instance, host_flags);
 
 	if (instance->irq != NO_IRQ) {


