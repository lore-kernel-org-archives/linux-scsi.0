From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 28/37] atari_NCR5380: Refactor Falcon special cases
Date: Wed, 12 Nov 2014 16:12:14 +1100
Message-ID: <20141112051153.095458676@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40990 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaKLFnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:20 -0500
Content-Disposition: inline; filename=atari_NCR5380-refactor-falcon-special-case
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Make the atari_NCR5380.c core driver usable by sun3_scsi, mac_scsi and
others by moving some of the Falcon-specific code out of the core driver:
!IS_A_TT, atari_read_overruns and falcon_dont_release. Replace these with
hostdata variables and flags. FLAG_CHECK_LAST_BYTE_SENT is unused in
atari_NCR5380.c so don't set it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.h       |    4 ++++
 drivers/scsi/atari_NCR5380.c |   30 +++++++++++++++---------------
 drivers/scsi/atari_scsi.c    |   21 ++++++++++++---------
 3 files changed, 31 insertions(+), 24 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:11:31.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:11:32.000000000 +1100
@@ -196,8 +196,6 @@ static char		*atari_dma_orig_addr;
 /* mask for address bits that can't be used with the ST-DMA */
 static unsigned long	atari_dma_stram_mask;
 #define STRAM_ADDR(a)	(((a) & atari_dma_stram_mask) == 0)
-/* number of bytes to cut from a transfer to handle NCR overruns */
-static int atari_read_overruns;
 #endif
 
 static int setup_can_queue = -1;
@@ -446,8 +444,6 @@ static void atari_scsi_fetch_restbytes(v
 #endif /* REAL_DMA */
 
 
-static int falcon_dont_release = 0;
-
 /* This function releases the lock on the DMA chip if there is no
  * connected command and the disconnected queue is empty.
  */
@@ -464,7 +460,7 @@ static void falcon_release_lock_if_possi
 	if (!hostdata->disconnected_queue &&
 	    !hostdata->issue_queue &&
 	    !hostdata->connected &&
-	    !falcon_dont_release &&
+	    !hostdata->retain_dma_intr &&
 	    stdma_is_locked_by(scsi_falcon_intr))
 		stdma_release();
 
@@ -846,6 +842,7 @@ static int __init atari_scsi_probe(struc
 	struct Scsi_Host *instance;
 	int error;
 	struct resource *irq;
+	int host_flags = 0;
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq)
@@ -942,7 +939,9 @@ static int __init atari_scsi_probe(struc
 
 	instance->irq = irq->start;
 
-	NCR5380_init(instance, 0);
+	host_flags |= IS_A_TT() ? 0 : FLAG_LATE_DMA_SETUP;
+
+	NCR5380_init(instance, host_flags);
 
 	if (IS_A_TT()) {
 		error = request_irq(instance->irq, scsi_tt_intr, 0,
@@ -965,12 +964,16 @@ static int __init atari_scsi_probe(struc
 		 *
 		 * In principle it should be sufficient to do max. 1 byte with
 		 * PIO, but there is another problem on the Medusa with the DMA
-		 * rest data register. So 'atari_read_overruns' is currently set
+		 * rest data register. So read_overruns is currently set
 		 * to 4 to avoid having transfers that aren't a multiple of 4.
 		 * If the rest data bug is fixed, this can be lowered to 1.
 		 */
-		if (MACH_IS_MEDUSA)
-			atari_read_overruns = 4;
+		if (MACH_IS_MEDUSA) {
+			struct NCR5380_hostdata *hostdata =
+				shost_priv(instance);
+
+			hostdata->read_overruns = 4;
+		}
 #endif
 	} else {
 		/* Nothing to do for the interrupt: the ST-DMA is initialized
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:11:16.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:11:32.000000000 +1100
@@ -241,6 +241,7 @@
 #define FLAG_NCR53C400			4	/* NCR53c400 */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
 #define FLAG_DTC3181E			16	/* DTC3181E */
+#define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 
 #ifndef ASM
 struct NCR5380_hostdata {
@@ -269,6 +270,9 @@ struct NCR5380_hostdata {
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
+	int read_overruns;                /* number of bytes to cut from a
+	                                   * transfer to handle chip overruns */
+	int retain_dma_intr;
 #ifdef PSEUDO_DMA
 	unsigned spin_max_r;
 	unsigned spin_max_w;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:31.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:32.000000000 +1100
@@ -839,7 +839,7 @@ static int __init NCR5380_init(struct Sc
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
-	hostdata->flags = FLAG_CHECK_LAST_BYTE_SENT;
+	hostdata->flags = flags;
 
 	if (!the_template) {
 		the_template = instance->hostt;
@@ -1054,7 +1054,7 @@ static void NCR5380_main(struct work_str
 						hostdata->issue_queue = NEXT(tmp);
 					}
 					SET_NEXT(tmp, NULL);
-					falcon_dont_release++;
+					hostdata->retain_dma_intr++;
 
 					/* reenable interrupts after finding one */
 					local_irq_restore(flags);
@@ -1082,7 +1082,7 @@ static void NCR5380_main(struct work_str
 					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
 #endif
 					if (!NCR5380_select(instance, tmp)) {
-						falcon_dont_release--;
+						hostdata->retain_dma_intr--;
 						/* release if target did not response! */
 						falcon_release_lock_if_possible(hostdata);
 						break;
@@ -1094,7 +1094,7 @@ static void NCR5380_main(struct work_str
 #ifdef SUPPORT_TAGS
 						cmd_free_tag(tmp);
 #endif
-						falcon_dont_release--;
+						hostdata->retain_dma_intr--;
 						local_irq_restore(flags);
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
@@ -1151,7 +1151,7 @@ static void NCR5380_dma_complete(struct
 		return;
 	}
 
-	if (atari_read_overruns) {
+	if (hostdata->read_overruns) {
 		p = hostdata->connected->SCp.phase;
 		if (p & SR_IO) {
 			udelay(10);
@@ -1181,9 +1181,9 @@ static void NCR5380_dma_complete(struct
 	*data += transfered;
 	*count -= transfered;
 
-	if (atari_read_overruns) {
+	if (hostdata->read_overruns) {
 		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) == p && (p & SR_IO)) {
-			cnt = toPIO = atari_read_overruns;
+			cnt = toPIO = hostdata->read_overruns;
 			if (overrun) {
 				dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
 				*(*data)++ = saved_data;
@@ -1838,8 +1838,8 @@ static int NCR5380_transfer_dma(struct S
 		return -1;
 	}
 
-	if (atari_read_overruns && (p & SR_IO))
-		c -= atari_read_overruns;
+	if (hostdata->read_overruns && (p & SR_IO))
+		c -= hostdata->read_overruns;
 
 	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
 		   HOSTNO, (p & SR_IO) ? "reading" : "writing",
@@ -1851,7 +1851,7 @@ static int NCR5380_transfer_dma(struct S
 	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
 #endif /* def REAL_DMA  */
 
-	if (IS_A_TT()) {
+	if (!(hostdata->flags & FLAG_LATE_DMA_SETUP)) {
 		/* On the Medusa, it is a must to initialize the DMA before
 		 * starting the NCR. This is also the cleaner way for the TT.
 		 */
@@ -1869,7 +1869,7 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_write(START_DMA_SEND_REG, 0);
 	}
 
-	if (!IS_A_TT()) {
+	if (hostdata->flags & FLAG_LATE_DMA_SETUP) {
 		/* On the Falcon, the DMA setup must be done after the last */
 		/* NCR access, else the DMA setup gets trashed!
 		 */
@@ -2084,7 +2084,7 @@ static void NCR5380_information_transfer
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					/* ++guenther: possible race with Falcon locking */
-					falcon_dont_release++;
+					hostdata->retain_dma_intr++;
 					hostdata->connected = NULL;
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
@@ -2167,7 +2167,7 @@ static void NCR5380_information_transfer
 					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
 						barrier();
 
-					falcon_dont_release--;
+					hostdata->retain_dma_intr--;
 					/* ++roman: For Falcon SCSI, release the lock on the
 					 * ST-DMA here if no other commands are waiting on the
 					 * disconnected queue.
@@ -2474,7 +2474,7 @@ static void NCR5380_reselect(struct Scsi
 #endif
 		    ) {
 			/* ++guenther: prevent race with falcon_release_lock */
-			falcon_dont_release++;
+			hostdata->retain_dma_intr++;
 			if (prev) {
 				REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 				SET_NEXT(prev, NEXT(tmp));
@@ -2512,7 +2512,7 @@ static void NCR5380_reselect(struct Scsi
 	hostdata->connected = tmp;
 	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %llu, tag = %d\n",
 		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
-	falcon_dont_release--;
+	hostdata->retain_dma_intr--;
 }
 
 


