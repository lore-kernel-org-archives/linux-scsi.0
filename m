From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 11/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:05:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415961AC.1090400@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:55498 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267743AbUI1NF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:05:57 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD5uW02815
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:05:56 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD5tm31102
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:05:55 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (2316-2391)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/aic7xxx/aic79xx.seq#102 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq ====
--- /tmp/tmp.26512.0	2004-09-27 13:04:43.138832816 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq	2003-10-16 18:15:00.000000000 -0400
@@ -40,7 +40,7 @@
   * $FreeBSD$
   */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#102 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#104 $"
  PATCH_ARG_LIST = "struct ahd_softc *ahd"
  PREFIX = "ahd_"

@@ -90,6 +90,13 @@
  	test	SSTAT2, NONPACKREQ jz . + 2;
  	call	unexpected_nonpkt_phase_find_ctxt;
  	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
+		/*
+		 * On Rev A. hardware, the busy LED is only
+		 * turned on automaically during selections
+		 * and re-selections.  Make the LED status
+		 * more useful by forcing it to be on so
+		 * long as one of our data FIFOs is active.
+		 */
  		and	A, FIFO0FREE|FIFO1FREE, DFFSTAT;
  		cmp	A, FIFO0FREE|FIFO1FREE jne . + 3;
  		and	SBLKCTL, ~DIAGLEDEN|DIAGLEDON;
@@ -180,26 +187,18 @@
  	 * bad SCSI status (currently only for underruns), we
  	 * queue the SCB for normal completion.  Otherwise, we
  	 * wait until any select-out activity has halted, and
-	 * then notify the host so that the transaction can be
-	 * dealt with.
+	 * then queue the completion.
  	 */
-	test	SCB_SCSI_STATUS, 0xff jnz scbdma_notify_host;
-	and	CCSCBCTL, ~(CCARREN|CCSCBEN);
-	bmov	COMPLETE_DMA_SCB_HEAD, SCB_NEXT_COMPLETE, 2;
-	bmov	SCB_NEXT_COMPLETE, COMPLETE_SCB_HEAD, 2;
-	bmov	COMPLETE_SCB_HEAD, SCBPTR, 2 ret;
-scbdma_notify_host:
+	test	SCB_SCSI_STATUS, 0xff jz scbdma_queue_completion;
  	SET_MODE(M_SCSI, M_SCSI)
  	test	SCSISEQ0, ENSELO jnz return;
  	test	SSTAT0, (SELDO|SELINGO) jnz return;
  	SET_MODE(M_CCHAN, M_CCHAN)
-	/*
-	 * Remove SCB and notify host.
-	 */
+scbdma_queue_completion:
  	and	CCSCBCTL, ~(CCARREN|CCSCBEN);
  	bmov	COMPLETE_DMA_SCB_HEAD, SCB_NEXT_COMPLETE, 2;
-	SET_SEQINTCODE(BAD_SCB_STATUS)
-	ret;
+	bmov	SCB_NEXT_COMPLETE, COMPLETE_SCB_HEAD, 2;
+	bmov	COMPLETE_SCB_HEAD, SCBPTR, 2 ret;
  fill_qoutfifo_dmadone:
  	and	CCSCBCTL, ~(CCARREN|CCSCBEN);
  	call	qoutfifo_updated;
@@ -491,6 +490,18 @@
  SET_DST_MODE	M_SCSI;
  select_in:
  	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
+		/*
+		 * On Rev A. hardware, the busy LED is only
+		 * turned on automaically during selections
+		 * and re-selections.  Make the LED status
+		 * more useful by forcing it to be on from
+		 * the point of selection until our idle
+		 * loop determines that neither of our FIFOs
+		 * are busy.  This handles the non-packetized
+		 * case nicely as we will not return to the
+		 * idle loop until the busfree at the end of
+		 * each transaction.
+		 */
  		or	SBLKCTL, DIAGLEDEN|DIAGLEDON;
  	}
  	if ((ahd->bugs & AHD_BUSFREEREV_BUG) != 0) {
@@ -531,6 +542,18 @@
  SET_DST_MODE	M_SCSI;
  select_out:
  	if ((ahd->bugs & AHD_FAINT_LED_BUG) != 0) {
+		/*
+		 * On Rev A. hardware, the busy LED is only
+		 * turned on automaically during selections
+		 * and re-selections.  Make the LED status
+		 * more useful by forcing it to be on from
+		 * the point of re-selection until our idle
+		 * loop determines that neither of our FIFOs
+		 * are busy.  This handles the non-packetized
+		 * case nicely as we will not return to the
+		 * idle loop until the busfree at the end of
+		 * each transaction.
+		 */
  		or	SBLKCTL, DIAGLEDEN|DIAGLEDON;
  	}
  BEGIN_CRITICAL;
==== //depot/aic7xxx/aic7xxx/aic79xx.c#210 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.26512.1	2004-09-27 13:04:45.345497352 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2003-10-16 18:15:00.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#210 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#216 $
   *
   * $FreeBSD$
   */
@@ -378,13 +378,7 @@
  	saved_modes = ahd_save_modes(ahd);

  	/*
-	 * Complete any SCBs that just finished being
-	 * DMA'ed into the qoutfifo.
-	 */
-	ahd_run_qoutfifo(ahd);
-
-	/*
-	 * Flush the good status FIFO for compelted packetized commands.
+	 * Flush the good status FIFO for completed packetized commands.
  	 */
  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
  	saved_scbptr = ahd_get_scbptr(ahd);
@@ -392,8 +386,7 @@
  		u_int fifo_mode;
  		u_int i;
  		
-		scbid = (ahd_inb(ahd, GSFIFO+1) << 8)
-		      | ahd_inb(ahd, GSFIFO);
+		scbid = ahd_inw(ahd, GSFIFO);
  		scb = ahd_lookup_scb(ahd, scbid);
  		if (scb == NULL) {
  			printf("%s: Warning - GSFIFO SCB %d invalid\n",
@@ -415,11 +408,24 @@

  			ahd_run_data_fifo(ahd, scb);

+			if (ahd_scb_active_in_fifo(ahd, scb) == 0) {
+				/*
+				 * Delay a bit so that status has
+				 * a chance to change before we look
+				 * at this FIFO again.
+				 */
+				ahd_delay(200);
+			}
+
  			/*
-			 * Clearing this transaction in this FIFO may
-			 * cause a CFG4DATA for this same transaction
-			 * to assert in the other FIFO.  Make sure we
-			 * loop one more time and check the other FIFO.
+			 * Running this FIFO may cause a CFG4DATA for
+			 * this same transaction to assert in the other
+			 * FIFO or a new snapshot SAVEPTRS interrupt
+			 * in this FIFO.  Even running a FIFO may not
+			 * clear the transaction if we are still waiting
+			 * for data to drain to the host. We must loop
+			 * until the transaction is not active in either
+			 * FIFO just to be sure.
  			 */
  			i = 0;
  		}
@@ -434,7 +440,7 @@
  			/*
  			 * The transfer completed with a residual.
  			 * Place this SCB on the complete DMA list
-			 * so that we Update our in-core copy of the
+			 * so that we update our in-core copy of the
  			 * SCB before completing the command.
  			 */
  			ahd_outb(ahd, SCB_SCSI_STATUS, 0);
@@ -444,9 +450,7 @@
  			ahd_outw(ahd, SCB_TAG, SCB_GET_TAG(scb));
  			comp_head = ahd_inw(ahd, COMPLETE_DMA_SCB_HEAD);
  			ahd_outw(ahd, SCB_NEXT_COMPLETE, comp_head);
-			if (SCBID_IS_NULL(comp_head))
-				ahd_outw(ahd, COMPLETE_DMA_SCB_HEAD,
-					 SCB_GET_TAG(scb));
+			ahd_outw(ahd, COMPLETE_DMA_SCB_HEAD, SCB_GET_TAG(scb));
  		} else
  			ahd_complete_scb(ahd, scb);
  	}
@@ -470,9 +474,22 @@
  			break;
  		ahd_delay(200);
  	}
-	if ((ccscbctl & CCSCBDIR) != 0)
+	/*
+	 * We leave the sequencer to cleanup in the case of DMA's to
+	 * update the qoutfifo.  In all other cases (DMA's to the
+	 * chip or a push of an SCB from the COMPLETE_DMA_SCB list),
+	 * we disable the DMA engine so that the sequencer will not
+	 * attempt to handle the DMA completion.
+	 */
+	if ((ccscbctl & CCSCBDIR) != 0 || (ccscbctl & ARRDONE) != 0)
  		ahd_outb(ahd, CCSCBCTL, ccscbctl & ~(CCARREN|CCSCBEN));

+	/*
+	 * Complete any SCBs that just finished
+	 * being DMA'ed into the qoutfifo.
+	 */
+	ahd_run_qoutfifo(ahd);
+
  	saved_scbptr = ahd_get_scbptr(ahd);
  	/*
  	 * Manually update/complete any completed SCBs that are waiting to be
@@ -563,150 +580,146 @@
  {
  	u_int seqintsrc;

-	while (1) {
-		seqintsrc = ahd_inb(ahd, SEQINTSRC);
-		if ((seqintsrc & CFG4DATA) != 0) {
-			uint32_t datacnt;
-			uint32_t sgptr;
-
-			/*
-			 * Clear full residual flag.
-			 */
-			sgptr = ahd_inl_scbram(ahd, SCB_SGPTR) & ~SG_FULL_RESID;
-			ahd_outb(ahd, SCB_SGPTR, sgptr);
+	seqintsrc = ahd_inb(ahd, SEQINTSRC);
+	if ((seqintsrc & CFG4DATA) != 0) {
+		uint32_t datacnt;
+		uint32_t sgptr;

-			/*
-			 * Load datacnt and address.
-			 */
-			datacnt = ahd_inl_scbram(ahd, SCB_DATACNT);
-			if ((datacnt & AHD_DMA_LAST_SEG) != 0) {
-				sgptr |= LAST_SEG;
-				ahd_outb(ahd, SG_STATE, 0);
-			} else
-				ahd_outb(ahd, SG_STATE, LOADING_NEEDED);
-			ahd_outq(ahd, HADDR, ahd_inq_scbram(ahd, SCB_DATAPTR));
-			ahd_outl(ahd, HCNT, datacnt & AHD_SG_LEN_MASK);
-			ahd_outb(ahd, SG_CACHE_PRE, sgptr);
-			ahd_outb(ahd, DFCNTRL, PRELOADEN|SCSIEN|HDMAEN);
+		/*
+		 * Clear full residual flag.
+		 */
+		sgptr = ahd_inl_scbram(ahd, SCB_SGPTR) & ~SG_FULL_RESID;
+		ahd_outb(ahd, SCB_SGPTR, sgptr);

-			/*
-			 * Initialize Residual Fields.
-			 */
-			ahd_outb(ahd, SCB_RESIDUAL_DATACNT+3, datacnt >> 24);
-			ahd_outl(ahd, SCB_RESIDUAL_SGPTR, sgptr & SG_PTR_MASK);
+		/*
+		 * Load datacnt and address.
+		 */
+		datacnt = ahd_inl_scbram(ahd, SCB_DATACNT);
+		if ((datacnt & AHD_DMA_LAST_SEG) != 0) {
+			sgptr |= LAST_SEG;
+			ahd_outb(ahd, SG_STATE, 0);
+		} else
+			ahd_outb(ahd, SG_STATE, LOADING_NEEDED);
+		ahd_outq(ahd, HADDR, ahd_inq_scbram(ahd, SCB_DATAPTR));
+		ahd_outl(ahd, HCNT, datacnt & AHD_SG_LEN_MASK);
+		ahd_outb(ahd, SG_CACHE_PRE, sgptr);
+		ahd_outb(ahd, DFCNTRL, PRELOADEN|SCSIEN|HDMAEN);

-			/*
-			 * Mark the SCB as having a FIFO in use.
-			 */
-			ahd_outb(ahd, SCB_FIFO_USE_COUNT,
-				 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT) + 1);
+		/*
+		 * Initialize Residual Fields.
+		 */
+		ahd_outb(ahd, SCB_RESIDUAL_DATACNT+3, datacnt >> 24);
+		ahd_outl(ahd, SCB_RESIDUAL_SGPTR, sgptr & SG_PTR_MASK);

-			/*
-			 * Install a "fake" handler for this FIFO.
-			 */
-			ahd_outw(ahd, LONGJMP_ADDR, 0);
+		/*
+		 * Mark the SCB as having a FIFO in use.
+		 */
+		ahd_outb(ahd, SCB_FIFO_USE_COUNT,
+			 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT) + 1);

-			/*
-			 * Notify the hardware that we have satisfied
-			 * this sequencer interrupt.
-			 */
-			ahd_outb(ahd, CLRSEQINTSRC, CLRCFG4DATA);
-		} else if ((seqintsrc & SAVEPTRS) != 0) {
-			uint32_t sgptr;
-			uint32_t resid;
+		/*
+		 * Install a "fake" handler for this FIFO.
+		 */
+		ahd_outw(ahd, LONGJMP_ADDR, 0);

-			if ((ahd_inb(ahd, LONGJMP_ADDR+1)&INVALID_ADDR) != 0) {
-				/*
-				 * Snapshot Save Pointers.  Clear
-				 * the snapshot and continue.
-				 */
-				ahd_outb(ahd, DFFSXFRCTL, CLRCHN);
-				continue;
-			}
+		/*
+		 * Notify the hardware that we have satisfied
+		 * this sequencer interrupt.
+		 */
+		ahd_outb(ahd, CLRSEQINTSRC, CLRCFG4DATA);
+	} else if ((seqintsrc & SAVEPTRS) != 0) {
+		uint32_t sgptr;
+		uint32_t resid;

+		if ((ahd_inb(ahd, LONGJMP_ADDR+1)&INVALID_ADDR) != 0) {
  			/*
-			 * Disable S/G fetch so the DMA engine
-			 * is available to future users.
+			 * Snapshot Save Pointers.  All that
+			 * is necessary to clear the snapshot
+			 * is a CLRCHN.
  			 */
-			if ((ahd_inb(ahd, SG_STATE) & FETCH_INPROG) != 0)
-				ahd_outb(ahd, CCSGCTL, 0);
-			ahd_outb(ahd, SG_STATE, 0);
+			goto clrchn;
+		}

-			/*
-			 * Flush the data FIFO.  Strickly only
-			 * necessary for Rev A parts.
-			 */
-			ahd_outb(ahd, DFCNTRL,
-				 ahd_inb(ahd, DFCNTRL) | FIFOFLUSH);
+		/*
+		 * Disable S/G fetch so the DMA engine
+		 * is available to future users.
+		 */
+		if ((ahd_inb(ahd, SG_STATE) & FETCH_INPROG) != 0)
+			ahd_outb(ahd, CCSGCTL, 0);
+		ahd_outb(ahd, SG_STATE, 0);

-			/*
-			 * Calculate residual.
-			 */
-			sgptr = ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR);
-			resid = ahd_inl(ahd, SHCNT);
-			resid |=
-			    ahd_inb_scbram(ahd, SCB_RESIDUAL_DATACNT+3) << 24;
-			ahd_outl(ahd, SCB_RESIDUAL_DATACNT, resid);
-			if ((ahd_inb(ahd, SG_CACHE_SHADOW) & LAST_SEG) == 0) {
-				/*
-				 * Must back up to the correct S/G element.
-				 * Typically this just means resetting our
-				 * low byte to the offset in the SG_CACHE,
-				 * but if we wrapped, we have to correct
-				 * the other bytes of the sgptr too.
-				 */
-				if ((ahd_inb(ahd, SG_CACHE_SHADOW) & 0x80) != 0
-				 && (sgptr & 0x80) == 0)
-					sgptr -= 0x100;
-				sgptr &= ~0xFF;
-				sgptr |= ahd_inb(ahd, SG_CACHE_SHADOW)
-				       & SG_ADDR_MASK;
-				ahd_outl(ahd, SCB_RESIDUAL_SGPTR, sgptr);
-				ahd_outb(ahd, SCB_RESIDUAL_DATACNT + 3, 0);
-			} else if ((resid & AHD_SG_LEN_MASK) == 0) {
-				ahd_outb(ahd, SCB_RESIDUAL_SGPTR,
-					 sgptr | SG_LIST_NULL);
-			}
-			/*
-			 * Save Pointers.
-			 */
-			ahd_outq(ahd, SCB_DATAPTR, ahd_inq(ahd, SHADDR));
-			ahd_outl(ahd, SCB_DATACNT, resid);
-			ahd_outl(ahd, SCB_SGPTR, sgptr);
-			ahd_outb(ahd, CLRSEQINTSRC, CLRSAVEPTRS);
-			ahd_outb(ahd, SEQIMODE,
-				 ahd_inb(ahd, SEQIMODE) | ENSAVEPTRS);
-			/*
-			 * If the data is to the SCSI bus, we are
-			 * done, otherwise wait for FIFOEMP.
-			 */
-			if ((ahd_inb(ahd, DFCNTRL) & DIRECTION) != 0)
-				break;
-		} else if ((ahd_inb(ahd, SG_STATE) & LOADING_NEEDED) != 0) {
-			uint32_t sgptr;
-			uint64_t data_addr;
-			uint32_t data_len;
-			u_int	 dfcntrl;
+		/*
+		 * Flush the data FIFO.  Strickly only
+		 * necessary for Rev A parts.
+		 */
+		ahd_outb(ahd, DFCNTRL, ahd_inb(ahd, DFCNTRL) | FIFOFLUSH);

-			/*
-			 * Disable S/G fetch so the DMA engine
-			 * is available to future users.
-			 */
-			if ((ahd_inb(ahd, SG_STATE) & FETCH_INPROG) != 0) {
-				ahd_outb(ahd, CCSGCTL, 0);
-				ahd_outb(ahd, SG_STATE, LOADING_NEEDED);
-			}
+		/*
+		 * Calculate residual.
+		 */
+		sgptr = ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR);
+		resid = ahd_inl(ahd, SHCNT);
+		resid |= ahd_inb_scbram(ahd, SCB_RESIDUAL_DATACNT+3) << 24;
+		ahd_outl(ahd, SCB_RESIDUAL_DATACNT, resid);
+		if ((ahd_inb(ahd, SG_CACHE_SHADOW) & LAST_SEG) == 0) {
+			/*
+			 * Must back up to the correct S/G element.
+			 * Typically this just means resetting our
+			 * low byte to the offset in the SG_CACHE,
+			 * but if we wrapped, we have to correct
+			 * the other bytes of the sgptr too.
+			 */
+			if ((ahd_inb(ahd, SG_CACHE_SHADOW) & 0x80) != 0
+			 && (sgptr & 0x80) == 0)
+				sgptr -= 0x100;
+			sgptr &= ~0xFF;
+			sgptr |= ahd_inb(ahd, SG_CACHE_SHADOW)
+			       & SG_ADDR_MASK;
+			ahd_outl(ahd, SCB_RESIDUAL_SGPTR, sgptr);
+			ahd_outb(ahd, SCB_RESIDUAL_DATACNT + 3, 0);
+		} else if ((resid & AHD_SG_LEN_MASK) == 0) {
+			ahd_outb(ahd, SCB_RESIDUAL_SGPTR,
+				 sgptr | SG_LIST_NULL);
+		}
+		/*
+		 * Save Pointers.
+		 */
+		ahd_outq(ahd, SCB_DATAPTR, ahd_inq(ahd, SHADDR));
+		ahd_outl(ahd, SCB_DATACNT, resid);
+		ahd_outl(ahd, SCB_SGPTR, sgptr);
+		ahd_outb(ahd, CLRSEQINTSRC, CLRSAVEPTRS);
+		ahd_outb(ahd, SEQIMODE,
+			 ahd_inb(ahd, SEQIMODE) | ENSAVEPTRS);
+		/*
+		 * If the data is to the SCSI bus, we are
+		 * done, otherwise wait for FIFOEMP.
+		 */
+		if ((ahd_inb(ahd, DFCNTRL) & DIRECTION) != 0)
+			goto clrchn;
+	} else if ((ahd_inb(ahd, SG_STATE) & LOADING_NEEDED) != 0) {
+		uint32_t sgptr;
+		uint64_t data_addr;
+		uint32_t data_len;
+		u_int	 dfcntrl;

-			/*
-			 * Wait for the DMA engine to notice that the
-			 * host transfer is enabled and that there is
-			 * space in the S/G FIFO for new segments before
-			 * loading more segments.
-			 */
-			if ((ahd_inb(ahd, DFSTATUS) & PRELOAD_AVAIL) == 0)
-				continue;
-			if ((ahd_inb(ahd, DFCNTRL) & HDMAENACK) == 0)
-				continue;
+		/*
+		 * Disable S/G fetch so the DMA engine
+		 * is available to future users.  We won't
+		 * be using the DMA engine to load segments.
+		 */
+		if ((ahd_inb(ahd, SG_STATE) & FETCH_INPROG) != 0) {
+			ahd_outb(ahd, CCSGCTL, 0);
+			ahd_outb(ahd, SG_STATE, LOADING_NEEDED);
+		}
+
+		/*
+		 * Wait for the DMA engine to notice that the
+		 * host transfer is enabled and that there is
+		 * space in the S/G FIFO for new segments before
+		 * loading more segments.
+		 */
+		if ((ahd_inb(ahd, DFSTATUS) & PRELOAD_AVAIL) != 0
+		 && (ahd_inb(ahd, DFCNTRL) & HDMAENACK) != 0) {

  			/*
  			 * Determine the offset of the next S/G
@@ -753,7 +766,7 @@
  			 * Advertise the segment to the hardware.
  			 */
  			dfcntrl = ahd_inb(ahd, DFCNTRL)|PRELOADEN|HDMAEN;
-			if ((ahd->features & AHD_NEW_DFCNTRL_OPTS)!=0) {
+			if ((ahd->features & AHD_NEW_DFCNTRL_OPTS) != 0) {
  				/*
  				 * Use SCSIENWRDIS so that SCSIEN
  				 * is never modified by this
@@ -762,30 +775,28 @@
  				dfcntrl |= SCSIENWRDIS;
  			}
  			ahd_outb(ahd, DFCNTRL, dfcntrl);
-		} else if ((ahd_inb(ahd, SG_CACHE_SHADOW)
-			 & LAST_SEG_DONE) != 0) {
-
-			/*
-			 * Transfer completed to the end of SG list
-			 * and has flushed to the host.
-			 */
-			ahd_outb(ahd, SCB_SGPTR,
-				 ahd_inb_scbram(ahd, SCB_SGPTR) | SG_LIST_NULL);
-			break;
-		} else if ((ahd_inb(ahd, DFSTATUS) & FIFOEMP) != 0) {
-			break;
  		}
-		ahd_delay(200);
+	} else if ((ahd_inb(ahd, SG_CACHE_SHADOW) & LAST_SEG_DONE) != 0) {
+
+		/*
+		 * Transfer completed to the end of SG list
+		 * and has flushed to the host.
+		 */
+		ahd_outb(ahd, SCB_SGPTR,
+			 ahd_inb_scbram(ahd, SCB_SGPTR) | SG_LIST_NULL);
+		goto clrchn;
+	} else if ((ahd_inb(ahd, DFSTATUS) & FIFOEMP) != 0) {
+clrchn:
+		/*
+		 * Clear any handler for this FIFO, decrement
+		 * the FIFO use count for the SCB, and release
+		 * the FIFO.
+		 */
+		ahd_outb(ahd, LONGJMP_ADDR + 1, INVALID_ADDR);
+		ahd_outb(ahd, SCB_FIFO_USE_COUNT,
+			 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT) - 1);
+		ahd_outb(ahd, DFFSXFRCTL, CLRCHN);
  	}
-	/*
-	 * Clear any handler for this FIFO, decrement
-	 * the FIFO use count for the SCB, and release
-	 * the FIFO.
-	 */
-	ahd_outb(ahd, LONGJMP_ADDR + 1, INVALID_ADDR);
-	ahd_outb(ahd, SCB_FIFO_USE_COUNT,
-		 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT) - 1);
-	ahd_outb(ahd, DFFSXFRCTL, CLRCHN);
  }

  void
@@ -881,26 +892,6 @@
  		       ahd_name(ahd), seqintcode);
  #endif
  	switch (seqintcode) {
-	case BAD_SCB_STATUS:
-	{
-		struct	scb *scb;
-		u_int	scbid;
-		int	cmds_pending;
-
-		scbid = ahd_get_scbptr(ahd);
-		scb = ahd_lookup_scb(ahd, scbid);
-		if (scb != NULL) {
-			ahd_complete_scb(ahd, scb);
-		} else {
-			printf("%s: WARNING no command for scb %d "
-			       "(bad status)\n", ahd_name(ahd), scbid);
-			ahd_dump_card_state(ahd);
-		}
-		cmds_pending = ahd_inw(ahd, CMDS_PENDING);
-		if (cmds_pending > 0)
-			ahd_outw(ahd, CMDS_PENDING, cmds_pending - 1);
-		break;
-	}
  	case ENTERING_NONPACK:
  	{
  		struct	scb *scb;
@@ -2315,8 +2306,7 @@
  		       "PRGMCNT == 0x%x\n",
  		       ahd_lookup_phase_entry(lastphase)->phasemsg,
  		       aborted,
-		       ahd_inb(ahd, PRGMCNT)
-			| (ahd_inb(ahd, PRGMCNT+1) << 8));
+		       ahd_inw(ahd, PRGMCNT));
  		ahd_dump_card_state(ahd);
  	}
  	/* Always restart the sequencer. */
@@ -2479,8 +2469,7 @@
  		u_int	i;

  		ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-		seqaddr = ahd_inb(ahd, CURADDR)
-			| (ahd_inb(ahd, CURADDR+1) << 8);
+		seqaddr = ahd_inw(ahd, CURADDR);

  		cs = ahd->critical_sections;
  		for (i = 0; i < ahd->num_critical_sections; i++, cs++) {
@@ -3209,6 +3198,15 @@
  			 */
  			con_opts |= ENSLOWCRC;
  		}
+
+		if ((ahd->bugs & AHD_PACED_NEGTABLE_BUG) != 0) {
+			/*
+			 * On H2A4, revert to a slower slewrate
+			 * on non-paced transfers.
+			 */
+			iocell_opts[AHD_PRECOMP_SLEW_INDEX] &=
+			    ~AHD_SLEWRATE_MASK;
+		}
  	}

  	ahd_outb(ahd, ANNEXCOL, AHD_ANNEXCOL_PRECOMP_SLEW);
@@ -4914,10 +4912,7 @@
  	 * Determine initial values for data_addr and data_cnt
  	 * for resuming the data phase.
  	 */
-	sgptr = (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 3) << 24)
-	      | (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 2) << 16)
-	      | (ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR + 1) << 8)
-	      |	ahd_inb_scbram(ahd, SCB_RESIDUAL_SGPTR);
+	sgptr = ahd_inl_scbram(ahd, SCB_RESIDUAL_SGPTR);
  	sgptr &= SG_PTR_MASK;

  	resid = (ahd_inb_scbram(ahd, SCB_RESIDUAL_DATACNT + 2) << 16)
@@ -4935,10 +4930,7 @@
  		dataptr = aic_le64toh(sg->addr)
  			+ (aic_le32toh(sg->len) & AHD_SG_LEN_MASK)
  			- resid;
-		ahd_outb(ahd, HADDR + 7, dataptr >> 56);
-		ahd_outb(ahd, HADDR + 6, dataptr >> 48);
-		ahd_outb(ahd, HADDR + 5, dataptr >> 40);
-		ahd_outb(ahd, HADDR + 4, dataptr >> 32);
+		ahd_outl(ahd, HADDR + 4, dataptr >> 32);
  	} else {
  		struct	 ahd_dma_seg *sg;

@@ -4953,10 +4945,7 @@
  		ahd_outb(ahd, HADDR + 4,
  			 (aic_le32toh(sg->len) & ~AHD_SG_LEN_MASK) >> 24);
  	}
-	ahd_outb(ahd, HADDR + 3, dataptr >> 24);
-	ahd_outb(ahd, HADDR + 2, dataptr >> 16);
-	ahd_outb(ahd, HADDR + 1, dataptr >> 8);
-	ahd_outb(ahd, HADDR, dataptr);
+	ahd_outl(ahd, HADDR, dataptr);
  	ahd_outb(ahd, HCNT + 2, resid >> 16);
  	ahd_outb(ahd, HCNT + 1, resid >> 8);
  	ahd_outb(ahd, HCNT, resid);
@@ -6641,14 +6630,8 @@
  	 * Tell the sequencer where it can find our arrays in memory.
  	 */
  	busaddr = ahd->shared_data_map.busaddr;
-	ahd_outb(ahd, SHARED_DATA_ADDR, busaddr & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, SHARED_DATA_ADDR + 3, (busaddr >> 24) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR, busaddr & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, QOUTFIFO_NEXT_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, SHARED_DATA_ADDR, busaddr);
+	ahd_outl(ahd, QOUTFIFO_NEXT_ADDR, busaddr);

  	/*
  	 * Setup the allowed SCSI Sequences based on operational mode.
@@ -6697,10 +6680,7 @@
  	 * Tell the sequencer which SCB will be the next one it receives.
  	 */
  	busaddr = aic_le32toh(ahd->next_queued_hscb->hscb_busaddr);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);

  	/*
  	 * Default to coalescing disabled.
@@ -7021,6 +7001,12 @@
  		struct scb *waiting_scb;

  		ahd_unpause(ahd);
+		/*
+		 * Give the sequencer some time to service
+		 * any active selections.
+		 */
+		ahd_delay(200);
+
  		ahd_intr(ahd);
  		ahd_pause(ahd);
  		ahd_clear_critical_section(ahd);
@@ -7233,10 +7219,7 @@
  		uint32_t busaddr;

  		busaddr = aic_le32toh(scb->hscb->hscb_busaddr);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-		ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+		ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);
  	} else {
  		prev_scb->hscb->next_hscb_busaddr = scb->hscb->hscb_busaddr;
  		ahd_sync_scb(ahd, prev_scb,
@@ -7343,10 +7326,7 @@
  	 */
  	ahd->qinfifonext = qinstart;
  	busaddr = aic_le32toh(ahd->next_queued_hscb->hscb_busaddr);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 0, busaddr & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 1, (busaddr >> 8) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 2, (busaddr >> 16) & 0xFF);
-	ahd_outb(ahd, NEXT_QUEUED_SCB_ADDR + 3, (busaddr >> 24) & 0xFF);
+	ahd_outl(ahd, NEXT_QUEUED_SCB_ADDR, busaddr);

  	while (qinpos != qintail) {
  		scb = ahd_lookup_scb(ahd, ahd->qinfifo[qinpos]);
@@ -8007,8 +7987,9 @@
  void
  ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
  {
-	struct hardware_scb *hscb;
-	u_int  qfreeze_cnt;
+	struct	hardware_scb *hscb;
+	u_int	qfreeze_cnt;
+	int	paused;

  	/*
  	 * The sequencer freezes its select-out queue
@@ -8018,6 +7999,13 @@
  	 */
  	hscb = scb->hscb;

+	if (ahd_is_paused(ahd)) {
+		paused = 1;
+	} else {
+		paused = 0;
+		ahd_pause(ahd);
+	}
+
  	/* Freeze the queue until the client sees the error. */
  	ahd_freeze_devq(ahd, scb);
  	aic_freeze_scb(scb);
@@ -8032,6 +8020,9 @@
  		ahd_outb(ahd, SEQ_FLAGS2,
  			 ahd_inb(ahd, SEQ_FLAGS2) & ~SELECTOUT_QFROZEN);

+	if (paused == 0)
+		ahd_unpause(ahd);
+
  	/* Don't want to clobber the original sense code */
  	if ((scb->flags & SCB_SENSE) != 0) {
  		/*
@@ -8414,8 +8405,7 @@
  	max_prog = 2048;

  	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE|LOADRAM);
-	ahd_outb(ahd, PRGMCNT, 0);
-	ahd_outb(ahd, PRGMCNT+1, 0);
+	ahd_outw(ahd, PRGMCNT, 0);
  	for (i = 0; i < max_prog; i++) {
  		uint8_t ins_bytes[4];

@@ -8530,8 +8520,7 @@
  	downloaded = 0;
  	skip_addr = 0;
  	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE|LOADRAM);
-	ahd_outb(ahd, PRGMCNT, 0);
-	ahd_outb(ahd, PRGMCNT+1, 0);
+	ahd_outw(ahd, PRGMCNT, 0);

  	for (i = 0; i < sizeof(seqprog)/4; i++) {
  		if (ahd_check_patch(ahd, &cur_patch, i, &skip_addr) == 0) {
@@ -8834,7 +8823,7 @@
  	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n"
  	       "%s: Dumping Card State at program address 0x%x Mode 0x%x\n",
  	       ahd_name(ahd),
-	       ahd_inb(ahd, CURADDR) | (ahd_inb(ahd, CURADDR+1) << 8),
+	       ahd_inw(ahd, CURADDR),
  	       ahd_build_mode_state(ahd, ahd->saved_src_mode,
  				    ahd->saved_dst_mode));
  	if (paused)
@@ -9178,6 +9167,7 @@
  			 * Do a full bus reset.
  			 */
  			aic_set_transaction_status(scb, CAM_CMD_TIMEOUT);
+bus_reset:
  			found = ahd_reset_channel(ahd, channel,
  						  /*Initiate Reset*/TRUE);
  			printf("%s: Issued Channel %c Bus Reset. "
@@ -9218,6 +9208,18 @@
  			printf("BDR message in message buffer\n");
  			aic_scb_timer_reset(scb, 2 * 1000000);
  			break;
+		} else if (last_phase != P_BUSFREE
+			&& ahd_inb(ahd, SCSIPHASE) == 0) {
+			/*
+			 * SCB is not identified, there
+			 * is no pending REQ, and the sequencer
+			 * has not seen a busfree.  Looks like
+			 * a stuck connection waiting to
+			 * go busfree.  Reset the bus.
+			 */
+			printf("%s: Connection stuck awaiting busfree or "
+			       "Identify Msg.\n", ahd_name(ahd));
+			goto bus_reset;
  		} else if (ahd_search_qinfifo(ahd, target, channel, lun,
  					      scb->hscb->tag, ROLE_INITIATOR,
  					      /*status*/0, SEARCH_COUNT) > 0) {
@@ -9792,13 +9794,9 @@
  			if ((ahd->features & AHD_MULTI_TID) != 0) {
  				u_int targid_mask;

-				targid_mask = ahd_inb(ahd, TARGID)
-					    | (ahd_inb(ahd, TARGID + 1) << 8);
-
+				targid_mask = ahd_inw(ahd, TARGID);
  				targid_mask |= target_mask;
-				ahd_outb(ahd, TARGID, targid_mask);
-				ahd_outb(ahd, TARGID+1, (targid_mask >> 8));
-				
+				ahd_outw(ahd, TARGID, targid_mask);
  				ahd_update_scsiid(ahd, targid_mask);
  			} else {
  				u_int our_id;
@@ -9912,14 +9910,9 @@
  				if (ahd->features & AHD_MULTI_TID) {
  					u_int targid_mask;

-					targid_mask = ahd_inb(ahd, TARGID)
-						    | (ahd_inb(ahd, TARGID + 1)
-						       << 8);
-
+					targid_mask = ahd_inw(ahd, TARGID);
  					targid_mask &= ~target_mask;
-					ahd_outb(ahd, TARGID, targid_mask);
-					ahd_outb(ahd, TARGID+1,
-					 	 (targid_mask >> 8));
+					ahd_outw(ahd, TARGID, targid_mask);
  					ahd_update_scsiid(ahd, targid_mask);
  				}
  			}
==== //depot/aic7xxx/aic7xxx/aic79xx_inline.h#54 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h ====
--- /tmp/tmp.26512.2	2004-09-27 13:04:45.550466192 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h	2003-10-15 16:15:18.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#54 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#55 $
   *
   * $FreeBSD$
   */
@@ -522,12 +522,21 @@
  static __inline uint16_t
  ahd_inw(struct ahd_softc *ahd, u_int port)
  {
+	/*
+	 * Read high byte first as some registers increment
+	 * or have other side effects when the low byte is
+	 * read.
+	 */
  	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
  }

  static __inline void
  ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)
  {
+	/*
+	 * Write low byte first to accomodate registers
+	 * such as PRGMCNT where the order maters.
+	 */
  	ahd_outb(ahd, port, value & 0xFF);
  	ahd_outb(ahd, port+1, (value >> 8) & 0xFF);
  }
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#146 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h ====
--- /tmp/tmp.26512.3	2004-09-27 13:04:45.666448560 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.h	2003-09-04 18:33:18.000000000 -0400
@@ -36,7 +36,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#146 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#147 $
   *
   */
  #ifndef _AIC79XX_LINUX_H_
@@ -132,7 +132,7 @@
  #define AHD_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC79XX_DRIVER_VERSION "2.0.1"
+#define AIC79XX_DRIVER_VERSION "2.0.2"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/aic7xxx/aic7xxx.seq#57 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.seq ====
--- /tmp/tmp.26512.4	2004-09-27 13:04:46.071387000 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx.seq	2003-10-15 13:25:06.000000000 -0400
@@ -40,7 +40,7 @@
   * $FreeBSD$
   */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#57 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $"
  PATCH_ARG_LIST = "struct ahc_softc *ahc"
  PREFIX = "ahc_"

@@ -1098,7 +1098,7 @@
  		test	SCB_RESIDUAL_DATACNT[3], SG_LAST_SEG jz dma_mid_sg;
  		if ((ahc->flags & AHC_TARGETROLE) != 0) {
  			test	SSTAT0, TARGET jz dma_last_sg;
-			if ((ahc->flags & AHC_TMODE_WIDEODD_BUG) != 0) {
+			if ((ahc->bugs & AHC_TMODE_WIDEODD_BUG) != 0) {
  				test	DMAPARAMS, DIRECTION jz dma_mid_sg;
  			}
  		}
==== //depot/aic7xxx/aic7xxx/aic7xxx.c#140 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c ====
--- /tmp/tmp.26512.5	2004-09-27 13:04:47.311198520 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-09-04 17:48:51.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#140 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#141 $
   *
   * $FreeBSD$
   */
@@ -6929,8 +6929,8 @@
  			 * Been down this road before.
  			 * Do a full bus reset.
  			 */
-bus_reset:
  			aic_set_transaction_status(scb, CAM_CMD_TIMEOUT);
+bus_reset:
  			found = ahc_reset_channel(ahc, channel,
  						  /*Initiate Reset*/TRUE);
  			printf("%s: Issued Channel %c Bus Reset. "
@@ -7023,6 +7023,18 @@
  			printf("BDR message in message buffer\n");
  			active_scb->flags |= SCB_DEVICE_RESET;
  			aic_scb_timer_reset(scb, 2 * 1000000);
+		} else if (last_phase != P_BUSFREE
+			&& (ahc_inb(ahc, SSTAT1) & REQINIT) == 0) {
+			/*
+			 * SCB is not identified, there
+			 * is no pending REQ, and the sequencer
+			 * has not seen a busfree.  Looks like
+			 * a stuck connection waiting to
+			 * go busfree.  Reset the bus.
+			 */
+			printf("%s: Connection stuck awaiting busfree or "
+			       "Identify Msg.\n", ahc_name(ahc));
+			goto bus_reset;
  		} else {
  			int	 disconnected;

==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#245 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c ====
--- /tmp/tmp.26512.6	2004-09-27 13:04:48.451025240 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-10-15 13:09:32.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec AIC7xxx device driver for Linux.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#245 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c#246 $
   *
   * Copyright (c) 1994 John Aycock
   *   The University of Calgary Department of Computer Science.
@@ -1506,6 +1506,7 @@

  	/* Still equal.  Sort by BIOS address, ioport, or bus/slot/func. */
  	switch (rvalue) {
+#ifdef CONFIG_PCI
  	case AHC_PCI:
  	{
  		char primary_channel;
@@ -1538,6 +1539,8 @@
  			value = 1;
  		break;
  	}
+#endif
+#ifdef CONFIG_EISA
  	case AHC_EISA:
  		if ((rahc->flags & AHC_BIOS_ENABLED) != 0) {
  			value = rahc->platform_data->bios_address
@@ -1547,6 +1550,7 @@
  			      - lahc->bsh.ioport;
  		}
  		break;
+#endif
  	default:
  		panic("ahc_softc_sort: invalid bus type");
  	}
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#158 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h ====
--- /tmp/tmp.26512.7	2004-09-27 13:04:48.554009584 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic7xxx_osm.h	2003-09-08 14:45:50.000000000 -0400
@@ -53,7 +53,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#158 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic7xxx_osm.h#159 $
   *
   */
  #ifndef _AIC7XXX_LINUX_H_
@@ -148,7 +148,7 @@
  #define AHC_SCSI_HAS_HOST_LOCK 0
  #endif

-#define AIC7XXX_DRIVER_VERSION "6.2.37"
+#define AIC7XXX_DRIVER_VERSION "6.3.0"

  /********************* Definitions Required by the Core ***********************/
  /*
==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aicasm/Makefile#14 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/Makefile ====
--- /tmp/tmp.26512.8	2004-09-27 13:04:48.558008976 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/Makefile	2003-09-17 17:49:09.000000000 -0400
@@ -49,11 +49,19 @@
  clean:
  	rm -f $(clean-files)

+# Create a dependency chain in generated files
+# to avoid concurrent invocations of the single
+# rule that builds them all.
+aicasm_gram.c: aicasm_gram.h
  aicasm_gram.c aicasm_gram.h: aicasm_gram.y
  	$(YACC) $(YFLAGS) -b $(<:.y=) $<
  	mv $(<:.y=).tab.c $(<:.y=.c)
  	mv $(<:.y=).tab.h $(<:.y=.h)

+# Create a dependency chain in generated files
+# to avoid concurrent invocations of the single
+# rule that builds them all.
+aicasm_macro_gram.c: aicasm_macro_gram.h
  aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
  	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
  	mv $(<:.y=).tab.c $(<:.y=.c)
==== //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#22 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm.c ====
--- /tmp/tmp.26512.9	2004-09-27 13:04:48.815969760 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aicasm/aicasm.c	2003-10-15 13:18:20.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#22 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#23 $
   *
   * $FreeBSD$
   */
@@ -609,10 +609,10 @@

  		while (line < cur_instr->srcline) {
  			fgets(buf, sizeof(buf), ifile);
-				fprintf(listfile, "\t\t%s", buf);
+				fprintf(listfile, "             \t%s", buf);
  				line++;
  		}
-		fprintf(listfile, "%03x %02x%02x%02x%02x", instrptr,
+		fprintf(listfile, "%04x %02x%02x%02x%02x", instrptr,
  #if BYTE_ORDER == LITTLE_ENDIAN
  			cur_instr->format.bytes[0],
  			cur_instr->format.bytes[1],
@@ -624,14 +624,23 @@
  			cur_instr->format.bytes[1],
  			cur_instr->format.bytes[0]);
  #endif
-		fgets(buf, sizeof(buf), ifile);
-		fprintf(listfile, "\t%s", buf);
-		line++;
+		/*
+		 * Macro expansions can cause several instructions
+		 * to be output for a single source line.  Only
+		 * advance the line once in these cases.
+		 */
+		if (line == cur_instr->srcline) {
+			fgets(buf, sizeof(buf), ifile);
+			fprintf(listfile, "\t%s", buf);
+			line++;
+		} else {
+			fprintf(listfile, "\n");
+		}
  		instrptr++;
  	}
  	/* Dump the remainder of the file */
  	while(fgets(buf, sizeof(buf), ifile) != NULL)
-		fprintf(listfile, "\t\t%s", buf);
+		fprintf(listfile, "             %s", buf);

  	fclose(ifile);
  }


