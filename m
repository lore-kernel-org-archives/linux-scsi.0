From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [patch 26/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:07:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596220.1040909@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42699 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267792AbUI1NHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:07:53 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7qW03372
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:52 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i8SD7pm31401
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2004 06:07:51 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sync up drivers/scsi/aic7xxx/. (4030-4071)

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

==== //depot/aic7xxx/aic7xxx/aic79xx.reg#76 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.reg ====
--- /tmp/tmp.28265.0	2004-09-27 16:29:01.666253384 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.reg	2004-08-18 15:11:31.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Aic79xx register and scratch ram definitions.
   *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2001, 2004 Justin T. Gibbs.
   * Copyright (c) 2000-2002 Adaptec Inc.
   * All rights reserved.
   *
@@ -39,7 +39,7 @@
   *
   * $FreeBSD$
   */
-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#76 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $"

  /*
   * This file is processed by the aic7xxx_asm utility for use in assembling
@@ -3715,8 +3715,9 @@

  	SEQ_FLAGS2 {
  		size		1
-		field	TARGET_MSG_PENDING	  0x02
-		field	SELECTOUT_QFROZEN	  0x04
+		field	PENDING_MK_MESSAGE	0x01
+		field	TARGET_MSG_PENDING	0x02
+		field	SELECTOUT_QFROZEN	0x04
  	}

  	ALLOCFIFO_SCBPTR {
@@ -3777,6 +3778,26 @@
  	CMDSIZE_TABLE {
  		size		8
  	}
+	/*
+	 * When an SCB with the MK_MESSAGE flag is
+	 * queued to the controller, it cannot enter
+	 * the waiting for selection list until the
+	 * selections for any previously queued
+	 * commands to that target complete.  During
+	 * the wait, the MK_MESSAGE SCB is queued
+	 * here.
+	 */
+	MK_MESSAGE_SCB {
+		size		2
+	}
+	/*
+	 * Saved SCSIID of MK_MESSAGE_SCB to avoid
+	 * an extra SCBPTR operation when deciding
+	 * if the MK_MESSAGE_SCB can be run.
+	 */
+	MK_MESSAGE_SCSIID {
+		size		1
+	}
  }

  /************************* Hardware SCB Definition ****************************/
==== //depot/aic7xxx/aic7xxx/aic79xx.seq#119 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq ====
--- /tmp/tmp.28265.1	2004-09-27 16:29:02.114185288 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx.seq	2004-08-18 15:07:04.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Adaptec U320 device driver firmware for Linux and FreeBSD.
   *
- * Copyright (c) 1994-2001 Justin T. Gibbs.
+ * Copyright (c) 1994-2001, 2004 Justin T. Gibbs.
   * Copyright (c) 2000-2002 Adaptec Inc.
   * All rights reserved.
   *
@@ -40,7 +40,7 @@
   * $FreeBSD$
   */

-VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#119 $"
+VERSION = "$Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $"
  PATCH_ARG_LIST = "struct ahd_softc *ahd"
  PREFIX = "ahd_"

@@ -110,10 +110,8 @@
  	 * one last time.
  	 */
  	test	SSTAT0, SELDO jnz select_out;
-END_CRITICAL;
  	call	start_selection;
  idle_loop_checkbus:
-BEGIN_CRITICAL;
  	test	SSTAT0, SELDO jnz select_out;
  END_CRITICAL;
  	test	SSTAT0, SELDI jnz select_in;
@@ -294,7 +292,6 @@
  	test	CCSCBCTL, ARRDONE jz return;
  fetch_new_scb_done:
  	and	CCSCBCTL, ~(CCARREN|CCSCBEN);
-	bmov	REG0, SCBPTR, 2;
  	clr	A;
  	add	CMDS_PENDING, 1;
  	adc	CMDS_PENDING[1], A;
@@ -316,43 +313,117 @@
  	clr	SCB_FIFO_USE_COUNT;
  	/* Update the next SCB address to download. */
  	bmov	NEXT_QUEUED_SCB_ADDR, SCB_NEXT_SCB_BUSADDR, 4;
+	/*
+	 * NULL out the SCB links since these fields
+	 * occupy the same location as SCB_NEXT_SCB_BUSADDR.
+	 */
  	mvi	SCB_NEXT[1], SCB_LIST_NULL;
  	mvi	SCB_NEXT2[1], SCB_LIST_NULL;
  	/* Increment our position in the QINFIFO. */
  	mov	NONE, SNSCB_QOFF;
+
  	/*
-	 * SCBs that want to send messages are always
-	 * queued independently.  This ensures that they
-	 * are at the head of the SCB list to select out
-	 * to a target and we will see the MK_MESSAGE flag.
+	 * Save SCBID of this SCB in REG0 since
+	 * SCBPTR will be clobbered during target
+	 * list updates.  We also record the SCB's
+	 * flags so that we can refer to them even
+	 * after SCBPTR has been changed.
+	 */
+	bmov	REG0, SCBPTR, 2;
+	mov	A, SCB_CONTROL;
+
+	/*
+	 * Find the tail SCB of the execution queue
+	 * for this target.
  	 */
-	test	SCB_CONTROL, MK_MESSAGE jnz first_new_target_scb;
  	shr	SINDEX, 3, SCB_SCSIID;
  	and	SINDEX, ~0x1;
  	mvi	SINDEX[1], (WAITING_SCB_TAILS >> 8);
  	bmov	DINDEX, SINDEX, 2;
  	bmov	SCBPTR, SINDIR, 2;
+
+	/*
+	 * Update the tail to point to the new SCB.
+	 */
  	bmov	DINDIR, REG0, 2;
+
+	/*
+	 * If the queue was empty, queue this SCB as
+	 * the first for this target.
+	 */
  	cmp	SCBPTR[1], SCB_LIST_NULL je first_new_target_scb;
+
+	/*
+	 * SCBs that want to send messages must always be
+	 * at the head of their per-target queue so that
+	 * ATN can be asserted even if the current
+	 * negotiation agreement is packetized.  If the
+	 * target queue is empty, the SCB can be queued
+	 * immediately.  If the queue is not empty, we must
+	 * wait for it to empty before entering this SCB
+	 * into the waiting for selection queue.  Otherwise
+	 * our batching and round-robin selection scheme
+	 * could allow commands to be queued out of order.
+	 * To simplify the implementation, we stop pulling
+	 * new commands from the host until the MK_MESSAGE
+	 * SCB can be queued to the waiting for selection
+	 * list.
+	 */
+	test	A, MK_MESSAGE jz batch_scb;
+
+	/*
+	 * If the last SCB is also a MK_MESSAGE SCB, then
+	 * order is preserved even if we batch.
+	 */
+	test	SCB_CONTROL, MK_MESSAGE jz batch_scb;
+
+	/*
+	 * Defer this SCB and stop fetching new SCBs until
+	 * it can be queued.  Since the SCB_SCSIID of the
+	 * tail SCB must be the same as that of the newly
+	 * queued SCB, there is no need to restore the SCBID
+	 * here.
+	 */
+	or	SEQ_FLAGS2, PENDING_MK_MESSAGE;
+	bmov	MK_MESSAGE_SCB, REG0, 2;
+	mov	MK_MESSAGE_SCSIID, SCB_SCSIID ret;
+
+batch_scb:
+	/*
+	 * Otherwise just update the previous tail SCB to
+	 * point to the new tail.
+	 */
  	bmov	SCB_NEXT, REG0, 2 ret;
+
  first_new_target_scb:
+	/*
+	 * Append SCB to the tail of the waiting for
+	 * selection list.
+	 */
  	cmp	WAITING_TID_HEAD[1], SCB_LIST_NULL je first_new_scb;
  	bmov	SCBPTR, WAITING_TID_TAIL, 2;
  	bmov	SCB_NEXT2, REG0, 2;
  	bmov	WAITING_TID_TAIL, REG0, 2 ret;
  first_new_scb:
+	/*
+	 * Whole list is empty, so the head of
+	 * the list must be initialized too.
+	 */
  	bmov	WAITING_TID_HEAD, REG0, 2;
  	bmov	WAITING_TID_TAIL, REG0, 2 ret;
  END_CRITICAL;

  scbdma_idle:
  	/*
-	 * Give precedence to downloading new SCBs to execute
-	 * unless select-outs are currently frozen.
+	 * Don't bother downloading new SCBs to execute
+	 * if select-outs are currently frozen or we have
+	 * a MK_MESSAGE SCB waiting to enter the queue.
  	 */
-	test	SEQ_FLAGS2, SELECTOUT_QFROZEN jnz . + 2;
+	test	SEQ_FLAGS2, SELECTOUT_QFROZEN|PENDING_MK_MESSAGE
+		jnz scbdma_no_new_scbs;
  BEGIN_CRITICAL;
  	test	QOFF_CTLSTA, NEW_SCB_AVAIL jnz fetch_new_scb;
+scbdma_no_new_scbs:
  	cmp	COMPLETE_DMA_SCB_HEAD[1], SCB_LIST_NULL jne dma_complete_scb;
  	cmp	COMPLETE_SCB_HEAD[1], SCB_LIST_NULL je return;
  	/* FALLTHROUGH */
@@ -671,27 +742,41 @@
  	}

  	/*
-	 * Requeue any SCBs not sent, to the tail of the waiting Q.
+	 * The whole list made it.  Clear our tail pointer to indicate
+	 * that the per-target selection queue is now empty.
  	 */
-	cmp	SCB_NEXT[1], SCB_LIST_NULL je select_out_list_done;
+	cmp	SCB_NEXT[1], SCB_LIST_NULL je select_out_clear_tail;

  	/*
+	 * Requeue any SCBs not sent, to the tail of the waiting Q.
  	 * We know that neither the per-TID list nor the list of
-	 * TIDs is empty.  Use this knowledge to our advantage.
+	 * TIDs is empty.  Use this knowledge to our advantage and
+	 * queue the remainder to the tail of the global execution
+	 * queue.
  	 */
  	bmov	REG0, SCB_NEXT, 2;
+select_out_queue_remainder:
  	bmov	SCBPTR, WAITING_TID_TAIL, 2;
  	bmov	SCB_NEXT2, REG0, 2;
  	bmov	WAITING_TID_TAIL, REG0, 2;
  	jmp	select_out_inc_tid_q;

-select_out_list_done:
+select_out_clear_tail:
  	/*
-	 * The whole list made it.  Just clear our TID's tail pointer
-	 * unless we were queued independently due to our need to
-	 * send a message.
+	 * Queue any pending MK_MESSAGE SCB for this target now
+	 * that the queue is empty.
+	 */
+	test	SEQ_FLAGS2, PENDING_MK_MESSAGE jz select_out_no_mk_message_scb;
+	mov	A, MK_MESSAGE_SCSIID;
+	cmp	SCB_SCSIID, A jne select_out_no_mk_message_scb;
+	and	SEQ_FLAGS2, ~PENDING_MK_MESSAGE;
+	bmov	REG0, MK_MESSAGE_SCB, 2;
+	jmp select_out_queue_remainder;
+
+select_out_no_mk_message_scb:
+	/*
+	 * Clear this target's execution tail and increment the queue.
  	 */
-	test	SCB_CONTROL, MK_MESSAGE jnz select_out_inc_tid_q;
  	shr	DINDEX, 3, SCB_SCSIID;
  	or	DINDEX, 1;	/* Want only the second byte */
  	mvi	DINDEX[1], ((WAITING_SCB_TAILS) >> 8);
@@ -703,8 +788,8 @@
  	mvi	WAITING_TID_TAIL[1], SCB_LIST_NULL;
  	bmov	SCBPTR, CURRSCB, 2;
  	mvi	CLRSINT0, CLRSELDO;
-	test	LQOSTAT2, LQOPHACHGOUTPKT jnz unexpected_nonpkt_phase;
-	test	LQOSTAT1, LQOPHACHGINPKT jnz unexpected_nonpkt_phase;
+	test	LQOSTAT2, LQOPHACHGOUTPKT jnz unexpected_nonpkt_mode_cleared;
+	test	LQOSTAT1, LQOPHACHGINPKT jnz unexpected_nonpkt_mode_cleared;

  	/*
  	 * If this is a packetized connection, return to our
@@ -2127,6 +2212,18 @@
  	mvi	DFFSXFRCTL, CLRCHN;
  unexpected_nonpkt_mode_cleared:
  	mvi	CLRSINT2, CLRNONPACKREQ;
+	if ((ahd->bugs & AHD_BUSFREEREV_BUG) != 0) {
+		/*
+		 * Test to ensure that the bus has not
+		 * already gone free prior to clearing
+		 * any stale busfree status.  This avoids
+		 * a window whereby a busfree just after
+		 * a selection could be missed.
+		 */
+		test	SCSISIGI, BSYI jz . + 2;
+		mvi	CLRSINT1,CLRBUSFREE;
+		or	SIMODE1, ENBUSFREE;
+	}
  	test	SCSIPHASE, ~(MSG_IN_PHASE|MSG_OUT_PHASE) jnz illegal_phase;
  	SET_SEQINTCODE(ENTERING_NONPACK)
  	jmp	ITloop;
==== //depot/aic7xxx/aic7xxx/aic79xx.c#247 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c ====
--- /tmp/tmp.28265.2	2004-09-27 16:29:03.513972488 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_core.c	2004-08-18 15:24:24.000000000 -0400
@@ -1,7 +1,7 @@
  /*
   * Core routines and tables shareable across OS platforms.
   *
- * Copyright (c) 1994-2002 Justin T. Gibbs.
+ * Copyright (c) 1994-2002, 2004 Justin T. Gibbs.
   * Copyright (c) 2000-2003 Adaptec Inc.
   * All rights reserved.
   *
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#247 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#248 $
   */

  #ifdef __linux__
@@ -202,7 +202,8 @@
  					    char channel, int lun, u_int tag,
  					    role_t role, uint32_t status,
  					    ahd_search_action action,
-					    u_int *list_head, u_int tid);
+					    u_int *list_head, u_int *list_tail,
+					    u_int tid);
  static void		ahd_stitch_tid_list(struct ahd_softc *ahd,
  					    u_int tid_prev, u_int tid_cur,
  					    u_int tid_next);
@@ -1668,7 +1669,8 @@
  		 * so just clear the error.
  		 */
  		ahd_outb(ahd, CLRLQIINT1, CLRLQICRCI_NLQ);
-	} else if ((status & BUSFREE) != 0) {
+	} else if ((status & BUSFREE) != 0
+		|| (lqistat1 & LQOBUSFREE) != 0) {
  		u_int lqostat1;
  		int   restart;
  		int   clear_fifo;
@@ -2033,10 +2035,6 @@
  		u_int waiting_t;
  		u_int next;

-		if ((busfreetime & BUSFREE_LQO) == 0)
-			printf("%s: Warning, BUSFREE time is 0x%x.  "
-			       "Expected BUSFREE_LQO.\n",
-			       ahd_name(ahd), busfreetime);
  		/*
  		 * The LQO manager detected an unexpected busfree
  		 * either:
@@ -2259,8 +2257,14 @@
  			struct ahd_tmode_tstate *tstate;

  			/*
-			 * PPR Rejected.  Try non-ppr negotiation
-			 * and retry command.
+			 * PPR Rejected.
+			 *
+			 * If the previous negotiation was packetized,
+			 * this could be because the device has been
+			 * reset without our knowledge.  Force our
+			 * current negotiation to async and retry the
+			 * negotiation.  Otherwise retry the command
+			 * with non-ppr negotiation.
  			 */
  #ifdef AHD_DEBUG
  			if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
@@ -2269,11 +2273,34 @@
  			tinfo = ahd_fetch_transinfo(ahd, devinfo.channel,
  						    devinfo.our_scsiid,
  						    devinfo.target, &tstate);
-			tinfo->curr.transport_version = 2;
-			tinfo->goal.transport_version = 2;
-			tinfo->goal.ppr_options = 0;
-			ahd_qinfifo_requeue_tail(ahd, scb);
-			printerror = 0;
+			if ((tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ)!=0) {
+				ahd_set_width(ahd, &devinfo,
+					      MSG_EXT_WDTR_BUS_8_BIT,
+					      AHD_TRANS_CUR,
+					      /*paused*/TRUE);
+				ahd_set_syncrate(ahd, &devinfo,
+						/*period*/0, /*offset*/0,
+						/*ppr_options*/0,
+						AHD_TRANS_CUR,
+						/*paused*/TRUE);
+				/*
+				 * The expect PPR busfree handler below
+				 * will effect the retry and necessary
+				 * abort.
+				 */
+			} else {
+				tinfo->curr.transport_version = 2;
+				tinfo->goal.transport_version = 2;
+				tinfo->goal.ppr_options = 0;
+				/*
+				 * Remove any SCBs in the waiting for selection
+				 * queue that may also be for this target so
+				 * that command ordering is preserved.
+				 */
+				ahd_freeze_devq(ahd, scb);
+				ahd_qinfifo_requeue_tail(ahd, scb);
+				printerror = 0;
+			}
  		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_WDTR, FALSE)
  			&& ppr_busfree == 0) {
  			/*
@@ -2288,6 +2315,12 @@
  				      MSG_EXT_WDTR_BUS_8_BIT,
  				      AHD_TRANS_CUR|AHD_TRANS_GOAL,
  				      /*paused*/TRUE);
+			/*
+			 * Remove any SCBs in the waiting for selection
+			 * queue that may also be for this target so that
+			 * command ordering is preserved.
+			 */
+			ahd_freeze_devq(ahd, scb);
  			ahd_qinfifo_requeue_tail(ahd, scb);
  			printerror = 0;
  		} else if (ahd_sent_msg(ahd, AHDMSG_EXT, MSG_EXT_SDTR, FALSE)
@@ -2305,6 +2338,12 @@
  					/*ppr_options*/0,
  					AHD_TRANS_CUR|AHD_TRANS_GOAL,
  					/*paused*/TRUE);
+			/*
+			 * Remove any SCBs in the waiting for selection
+			 * queue that may also be for this target so that
+			 * command ordering is preserved.
+			 */
+			ahd_freeze_devq(ahd, scb);
  			ahd_qinfifo_requeue_tail(ahd, scb);
  			printerror = 0;
  		} else if ((ahd->msg_flags & MSG_FLAG_EXPECT_IDE_BUSFREE) != 0
@@ -2377,14 +2416,14 @@
  			 */
  			printf("%s: ", ahd_name(ahd));
  		}
-		if (lastphase != P_BUSFREE)
-			ahd_force_renegotiation(ahd, &devinfo);
  		printf("Unexpected busfree %s, %d SCBs aborted, "
  		       "PRGMCNT == 0x%x\n",
  		       ahd_lookup_phase_entry(lastphase)->phasemsg,
  		       aborted,
  		       ahd_inw(ahd, PRGMCNT));
  		ahd_dump_card_state(ahd);
+		if (lastphase != P_BUSFREE)
+			ahd_force_renegotiation(ahd, &devinfo);
  	}
  	/* Always restart the sequencer. */
  	return (1);
@@ -3323,7 +3362,6 @@
  {
  	struct		scb *pending_scb;
  	int		pending_scb_count;
-	u_int		scb_tag;
  	int		paused;
  	u_int		saved_scbptr;
  	ahd_mode_state	saved_modes;
@@ -3341,7 +3379,6 @@
  	pending_scb_count = 0;
  	LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
  		struct ahd_devinfo devinfo;
-		struct hardware_scb *pending_hscb;
  		struct ahd_initiator_tinfo *tinfo;
  		struct ahd_tmode_tstate *tstate;

@@ -3349,11 +3386,10 @@
  		tinfo = ahd_fetch_transinfo(ahd, devinfo.channel,
  					    devinfo.our_scsiid,
  					    devinfo.target, &tstate);
-		pending_hscb = pending_scb->hscb;
  		if ((tstate->auto_negotiate & devinfo.target_mask) == 0
  		 && (pending_scb->flags & SCB_AUTO_NEGOTIATE) != 0) {
  			pending_scb->flags &= ~SCB_AUTO_NEGOTIATE;
-			pending_hscb->control &= ~MK_MESSAGE;
+			pending_scb->hscb->control &= ~MK_MESSAGE;
  		}
  		ahd_sync_scb(ahd, pending_scb,
  			     BUS_DMASYNC_PREREAD|BUS_DMASYNC_PREWRITE);
@@ -3385,18 +3421,15 @@
  		ahd_outb(ahd, SCSISEQ0, ahd_inb(ahd, SCSISEQ0) & ~ENSELO);
  	saved_scbptr = ahd_get_scbptr(ahd);
  	/* Ensure that the hscbs down on the card match the new information */
-	for (scb_tag = 0; scb_tag < ahd->scb_data.maxhscbs; scb_tag++) {
-		struct	hardware_scb *pending_hscb;
+	LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
+		u_int	scb_tag;
  		u_int	control;

-		pending_scb = ahd_lookup_scb(ahd, scb_tag);
-		if (pending_scb == NULL)
-			continue;
+		scb_tag = SCB_GET_TAG(pending_scb);
  		ahd_set_scbptr(ahd, scb_tag);
-		pending_hscb = pending_scb->hscb;
  		control = ahd_inb_scbram(ahd, SCB_CONTROL);
  		control &= ~MK_MESSAGE;
-		control |= pending_hscb->control & MK_MESSAGE;
+		control |= pending_scb->hscb->control & MK_MESSAGE;
  		ahd_outb(ahd, SCB_CONTROL, control);
  	}
  	ahd_set_scbptr(ahd, saved_scbptr);
@@ -6578,13 +6611,14 @@
  			      | ENLQIOVERI_LQ|ENLQIOVERI_NLQ);
  	ahd_outb(ahd, LQOMODE0, ENLQOATNLQ|ENLQOATNPKT|ENLQOTCRC);
  	/*
-	 * An interrupt from LQOBUSFREE is made redundant by the
-	 * BUSFREE interrupt.  We choose to have the sequencer catch
-	 * LQOPHCHGINPKT errors manually for the command phase at the
-	 * start of a packetized selection case.
-	ahd_outb(ahd, LQOMODE1, ENLQOBUSFREE|ENLQOPHACHGINPKT);
+	 * We choose to have the sequencer catch LQOPHCHGINPKT errors
+	 * manually for the command phase at the start of a packetized
+	 * selection case.  ENLQOBUSFREE should be made redundant by
+	 * the BUSFREE interrupt, but it seems that some LQOBUSFREE
+	 * events fail to assert the BUSFREE interrupt so we must
+	 * also enable LQOBUSFREE interrupts.
  	 */
-	ahd_outb(ahd, LQOMODE1, 0);
+	ahd_outb(ahd, LQOMODE1, ENLQOBUSFREE);

  	/*
  	 * Setup sequencer interrupt handlers.
@@ -6695,6 +6729,8 @@
  	/* We don't have any waiting selections */
  	ahd_outw(ahd, WAITING_TID_HEAD, SCB_LIST_NULL);
  	ahd_outw(ahd, WAITING_TID_TAIL, SCB_LIST_NULL);
+	ahd_outw(ahd, MK_MESSAGE_SCB, SCB_LIST_NULL);
+	ahd_outw(ahd, MK_MESSAGE_SCSIID, 0xFF);
  	for (i = 0; i < AHD_NUM_TARGETS; i++)
  		ahd_outw(ahd, WAITING_SCB_TAILS + (2 * i), SCB_LIST_NULL);

@@ -7338,12 +7374,28 @@
  	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
  }

+void
+ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
+{
+	cam_status ostat;
+	cam_status cstat;
+
+	ostat = aic_get_transaction_status(scb);
+	if (ostat == CAM_REQ_INPROG)
+		aic_set_transaction_status(scb, status);
+	cstat = aic_get_transaction_status(scb);
+	if (cstat != CAM_REQ_CMP)
+		aic_freeze_scb(scb);
+	ahd_done(ahd, scb);
+}
+
  int
  ahd_search_qinfifo(struct ahd_softc *ahd, int target, char channel,
  		   int lun, u_int tag, role_t role, uint32_t status,
  		   ahd_search_action action)
  {
  	struct scb	*scb;
+	struct scb	*mk_msg_scb;
  	struct scb	*prev_scb;
  	ahd_mode_state	 saved_modes;
  	u_int		 qinstart;
@@ -7352,6 +7404,7 @@
  	u_int		 tid_next;
  	u_int		 tid_prev;
  	u_int		 scbid;
+	u_int		 seq_flags2;
  	u_int		 savedscbptr;
  	uint32_t	 busaddr;
  	int		 found;
@@ -7407,23 +7460,10 @@
  			found++;
  			switch (action) {
  			case SEARCH_COMPLETE:
-			{
-				cam_status ostat;
-				cam_status cstat;
-
-				ostat = aic_get_transaction_status(scb);
-				if (ostat == CAM_REQ_INPROG)
-					aic_set_transaction_status(scb,
-								   status);
-				cstat = aic_get_transaction_status(scb);
-				if (cstat != CAM_REQ_CMP)
-					aic_freeze_scb(scb);
  				if ((scb->flags & SCB_ACTIVE) == 0)
  					printf("Inactive SCB in qinfifo\n");
-				ahd_done(ahd, scb);
-
+				ahd_done_with_status(ahd, scb, status);
  				/* FALLTHROUGH */
-			}
  			case SEARCH_REMOVE:
  				break;
  			case SEARCH_PRINT:
@@ -7453,21 +7493,24 @@
  	 * looking for matches.
  	 */
  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
+	seq_flags2 = ahd_inb(ahd, SEQ_FLAGS2);
+	if ((seq_flags2 & PENDING_MK_MESSAGE) != 0) {
+		scbid = ahd_inw(ahd, MK_MESSAGE_SCB);
+		mk_msg_scb = ahd_lookup_scb(ahd, scbid);
+	} else
+		mk_msg_scb = NULL;
  	savedscbptr = ahd_get_scbptr(ahd);
  	tid_next = ahd_inw(ahd, WAITING_TID_HEAD);
  	tid_prev = SCB_LIST_NULL;
  	targets = 0;
  	for (scbid = tid_next; !SCBID_IS_NULL(scbid); scbid = tid_next) {
  		u_int tid_head;
+		u_int tid_tail;

-		/*
-		 * We limit based on the number of SCBs since
-		 * MK_MESSAGE SCBs are not in the per-tid lists.
-		 */
  		targets++;
-		if (targets > AHD_SCB_MAX) {
+		if (targets > AHD_NUM_TARGETS)
  			panic("TID LIST LOOP");
-		}
+
  		if (scbid >= ahd->scb_data.numscbs) {
  			printf("%s: Waiting TID List inconsistency. "
  			       "SCB index == 0x%x, yet numscbs == 0x%x.",
@@ -7497,8 +7540,71 @@
  		tid_head = scbid;
  		found += ahd_search_scb_list(ahd, target, channel,
  					     lun, tag, role, status,
-					     action, &tid_head,
+					     action, &tid_head, &tid_tail,
  					     SCB_GET_TARGET(ahd, scb));
+		/*
+		 * Check any MK_MESSAGE SCB that is still waiting to
+		 * enter this target's waiting for selection queue.
+		 */
+		if (mk_msg_scb != NULL
+		 && ahd_match_scb(ahd, mk_msg_scb, target, channel,
+				  lun, tag, role)) {
+
+			/*
+			 * We found an scb that needs to be acted on.
+			 */
+			found++;
+			switch (action) {
+			case SEARCH_COMPLETE:
+				if ((mk_msg_scb->flags & SCB_ACTIVE) == 0)
+					printf("Inactive SCB pending MK_MSG\n");
+				ahd_done_with_status(ahd, mk_msg_scb, status);
+				/* FALLTHROUGH */
+			case SEARCH_REMOVE:
+			{
+				u_int tail_offset;
+
+				printf("Removing MK_MSG scb\n");
+
+				/*
+				 * Reset our tail to the tail of the
+				 * main per-target list.
+				 */
+				tail_offset = WAITING_SCB_TAILS
+				    + (2 * SCB_GET_TARGET(ahd, mk_msg_scb));
+				ahd_outw(ahd, tail_offset, tid_tail);
+
+				seq_flags2 &= ~PENDING_MK_MESSAGE;
+				ahd_outb(ahd, SEQ_FLAGS2, seq_flags2);
+				ahd_outw(ahd, CMDS_PENDING,
+					 ahd_inw(ahd, CMDS_PENDING)-1);
+				mk_msg_scb = NULL;
+				break;
+			}
+			case SEARCH_PRINT:
+				printf(" 0x%x", SCB_GET_TAG(scb));
+				/* FALLTHROUGH */
+			case SEARCH_COUNT:
+				break;
+			}
+		}
+
+		if (mk_msg_scb != NULL
+		 && SCBID_IS_NULL(tid_head)
+		 && ahd_match_scb(ahd, scb, target, channel, CAM_LUN_WILDCARD,
+				  SCB_LIST_NULL, ROLE_UNKNOWN)) {
+
+			/*
+			 * When removing the last SCB for a target
+			 * queue with a pending MK_MESSAGE scb, we
+			 * must queue the MK_MESSAGE scb.
+			 */
+			printf("Queueing mk_msg_scb\n");
+			tid_head = ahd_inw(ahd, MK_MESSAGE_SCB);
+			seq_flags2 &= ~PENDING_MK_MESSAGE;
+			ahd_outb(ahd, SEQ_FLAGS2, seq_flags2);
+			mk_msg_scb = NULL;
+		}
  		if (tid_head != scbid)
  			ahd_stitch_tid_list(ahd, tid_prev, tid_head, tid_next);
  		if (!SCBID_IS_NULL(tid_head))
@@ -7506,6 +7612,8 @@
  		if (action == SEARCH_PRINT)
  			printf(")\n");
  	}
+
+	/* Restore saved state. */
  	ahd_set_scbptr(ahd, savedscbptr);
  	ahd_restore_modes(ahd, saved_modes);
  	return (found);
@@ -7514,7 +7622,8 @@
  static int
  ahd_search_scb_list(struct ahd_softc *ahd, int target, char channel,
  		    int lun, u_int tag, role_t role, uint32_t status,
-		    ahd_search_action action, u_int *list_head, u_int tid)
+		    ahd_search_action action, u_int *list_head,
+		    u_int *list_tail, u_int tid)
  {
  	struct	scb *scb;
  	u_int	scbid;
@@ -7526,6 +7635,7 @@
  	found = 0;
  	prev = SCB_LIST_NULL;
  	next = *list_head;
+	*list_tail = SCB_LIST_NULL;
  	for (scbid = next; !SCBID_IS_NULL(scbid); scbid = next) {
  		if (scbid >= ahd->scb_data.numscbs) {
  			printf("%s:SCB List inconsistency. "
@@ -7541,6 +7651,7 @@
  			panic("Waiting List traversal\n");
  		}
  		ahd_set_scbptr(ahd, scbid);
+		*list_tail = scbid;
  		next = ahd_inw_scbram(ahd, SCB_NEXT);
  		if (ahd_match_scb(ahd, scb, target, channel,
  				  lun, SCB_LIST_NULL, role) == 0) {
@@ -7550,24 +7661,14 @@
  		found++;
  		switch (action) {
  		case SEARCH_COMPLETE:
-		{
-			cam_status ostat;
-			cam_status cstat;
-
-			ostat = aic_get_transaction_status(scb);
-			if (ostat == CAM_REQ_INPROG)
-				aic_set_transaction_status(scb, status);
-			cstat = aic_get_transaction_status(scb);
-			if (cstat != CAM_REQ_CMP)
-				aic_freeze_scb(scb);
  			if ((scb->flags & SCB_ACTIVE) == 0)
  				printf("Inactive SCB in Waiting List\n");
-			ahd_done(ahd, scb);
+			ahd_done_with_status(ahd, scb, status);
  			/* FALLTHROUGH */
-		}
  		case SEARCH_REMOVE:
  			ahd_rem_wscb(ahd, scbid, prev, next, tid);
-			if (prev == SCB_LIST_NULL)
+			*list_tail = prev;
+			if (SCBID_IS_NULL(prev))
  				*list_head = next;
  			break;
  		case SEARCH_PRINT:
@@ -7636,14 +7737,17 @@
  	}

  	/*
-	 * SCBs that had MK_MESSAGE set in them will not
-	 * be queued to the per-target lists, so don't
-	 * blindly clear the tail pointer.
+	 * SCBs that have MK_MESSAGE set in them may
+	 * cause the tail pointer to be updated without
+	 * setting the next pointer of the previous tail.
+	 * Only clear the tail if the removed SCB was
+	 * the tail.
  	 */
  	tail_offset = WAITING_SCB_TAILS + (2 * tid);
  	if (SCBID_IS_NULL(next)
  	 && ahd_inw(ahd, tail_offset) == scbid)
  		ahd_outw(ahd, tail_offset, prev);
+
  	ahd_add_scb_to_free_list(ahd, scbid);
  	return (next);
  }
@@ -8900,6 +9004,9 @@
  	 * Mode independent registers.
  	 */
  	cur_col = 0;
+	ahd_intstat_print(ahd_inb(ahd, INTSTAT), &cur_col, 50);
+	ahd_seloid_print(ahd_inb(ahd, SELOID), &cur_col, 50);
+	ahd_selid_print(ahd_inb(ahd, SELID), &cur_col, 50);
  	ahd_hs_mailbox_print(ahd_inb(ahd, LOCAL_HS_MAILBOX), &cur_col, 50);
  	ahd_intctl_print(ahd_inb(ahd, INTCTL), &cur_col, 50);
  	ahd_seqintstat_print(ahd_inb(ahd, SEQINTSTAT), &cur_col, 50);
@@ -8915,6 +9022,12 @@
  	ahd_seqintctl_print(ahd_inb(ahd, SEQINTCTL), &cur_col, 50);
  	ahd_seq_flags_print(ahd_inb(ahd, SEQ_FLAGS), &cur_col, 50);
  	ahd_seq_flags2_print(ahd_inb(ahd, SEQ_FLAGS2), &cur_col, 50);
+	ahd_qfreeze_count_print(ahd_inw(ahd, QFREEZE_COUNT), &cur_col, 50);
+	ahd_kernel_qfreeze_count_print(ahd_inw(ahd, KERNEL_QFREEZE_COUNT),
+				       &cur_col, 50);
+	ahd_mk_message_scb_print(ahd_inw(ahd, MK_MESSAGE_SCB), &cur_col, 50);
+	ahd_mk_message_scsiid_print(ahd_inb(ahd, MK_MESSAGE_SCSIID),
+				    &cur_col, 50);
  	ahd_sstat0_print(ahd_inb(ahd, SSTAT0), &cur_col, 50);
  	ahd_sstat1_print(ahd_inb(ahd, SSTAT1), &cur_col, 50);
  	ahd_sstat2_print(ahd_inb(ahd, SSTAT2), &cur_col, 50);
@@ -9022,7 +9135,7 @@

  		ahd_set_modes(ahd, AHD_MODE_DFF0 + i, AHD_MODE_DFF0 + i);
  		fifo_scbptr = ahd_get_scbptr(ahd);
-		printf("\n%s: FIFO%d %s, LONGJMP == 0x%x, SCB 0x%x\n",
+		printf("\n\n%s: FIFO%d %s, LONGJMP == 0x%x, SCB 0x%x\n",
  		       ahd_name(ahd), i,
  		       (dffstat & (FIFO0FREE << i)) ? "Free" : "Active",
  		       ahd_inw(ahd, LONGJMP_ADDR), fifo_scbptr);
@@ -9077,6 +9190,9 @@
  	printf("%s: OS_SPACE_CNT = 0x%x MAXCMDCNT = 0x%x\n",
  	       ahd_name(ahd), ahd_inb(ahd, OS_SPACE_CNT),
  	       ahd_inb(ahd, MAXCMDCNT));
+	printf("%s: SAVED_SCSIID = 0x%x SAVED_LUN = 0x%x\n",
+	       ahd_name(ahd), ahd_inb(ahd, SAVED_SCSIID),
+	       ahd_inb(ahd, SAVED_LUN));
  	ahd_simode0_print(ahd_inb(ahd, SIMODE0), &cur_col, 50);
  	printf("\n");
  	ahd_set_modes(ahd, AHD_MODE_CCHAN, AHD_MODE_CCHAN);
@@ -9185,6 +9301,11 @@
  	 * interrupt handler has yet to see.
  	 */
  	was_paused = ahd_is_paused(ahd);
+
+	printf("%s: Recovery Initiated - Card was %spaused\n", ahd_name(ahd),
+	       was_paused ? "" : "not ");
+	ahd_dump_card_state(ahd);
+
  	ahd_pause_and_flushwork(ahd);

  	if (LIST_EMPTY(&ahd->timedout_scbs) != 0) {
@@ -9203,10 +9324,6 @@
  		return;
  	}

-	printf("%s: Recovery Initiated - Card was %spaused\n", ahd_name(ahd),
-	       was_paused ? "" : "not ");
-	ahd_dump_card_state(ahd);
-
  	/*
  	 * Determine identity of SCB acting on the bus.
  	 * This test only catches non-packetized transactions.
@@ -9269,7 +9386,7 @@
  				 * untimed-out command is outstanding.
  				 */
  				if (ahd_other_scb_timeout(ahd, scb,
-							  active_scb) != 0)
+							  active_scb) == 0)
  					goto bus_reset;
  				continue;
  			}
@@ -9308,7 +9425,7 @@
  			 * some other command.  Reset the timer
  			 * and go on.
  			 */
-			if (ahd_other_scb_timeout(ahd, scb, NULL) != 0)
+			if (ahd_other_scb_timeout(ahd, scb, NULL) == 0)
  				goto bus_reset;
  		} else {
  			/*
==== //depot/aic7xxx/aic7xxx/aic79xx_inline.h#58 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h ====
--- /tmp/tmp.28265.3	2004-09-27 16:29:03.626955312 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_inline.h	2004-08-18 15:03:42.000000000 -0400
@@ -37,7 +37,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#58 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_inline.h#59 $
   *
   * $FreeBSD$
   */
@@ -804,9 +804,10 @@
  		uint64_t host_dataptr;

  		host_dataptr = aic_le64toh(scb->hscb->dataptr);
-		printf("%s: Queueing SCB 0x%x bus addr 0x%x - 0x%x%x/0x%x\n",
+		printf("%s: Queueing SCB %d:0x%x bus addr 0x%x - 0x%x%x/0x%x\n",
  		       ahd_name(ahd),
-		       SCB_GET_TAG(scb), aic_le32toh(scb->hscb->hscb_busaddr),
+		       SCB_GET_TAG(scb), scb->hscb->scsiid,
+		       aic_le32toh(scb->hscb->hscb_busaddr),
  		       (u_int)((host_dataptr >> 32) & 0xFFFFFFFF),
  		       (u_int)(host_dataptr & 0xFFFFFFFF),
  		       aic_le32toh(scb->hscb->datacnt));
==== //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 - /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c ====
--- /tmp/tmp.28265.4	2004-09-27 16:29:03.877917160 -0400
+++ /home/luben/projects/linux/2.6/linux-2.5/drivers/scsi/aic7xxx/aic79xx_pci.c	2004-08-18 14:59:15.000000000 -0400
@@ -38,7 +38,7 @@
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#90 $
   */

  #ifdef __linux__
@@ -996,7 +996,8 @@
  		u_int devconfig1;

  		ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
-			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY;
+			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY
+			      |  AHD_BUSFREEREV_BUG;
  		ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;

  		/*


