From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sym2: remove dead SYM_OPT_HANDLE_IO_TIMEOUT code
Date: Tue, 2 Nov 2004 12:05:36 +0100
Message-ID: <20041102110536.GA28902@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:2243 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261182AbUKBLFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 06:05:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

this was used only by ancient BSDs that didn't have timeout handling
in the midlayer.


--- 1.22/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-10-24 18:08:18 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-10-26 14:32:09 +02:00
@@ -1630,13 +1630,6 @@
 #endif
 
 	/*
-	 *  Optionnaly, set the IO timeout condition.
-	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_timeout_ccb(np, cp, sym_cam_timeout(cp->cam_ccb));
-#endif
-
-	/*
 	 *  Insert first the idle task and then our job.
 	 *  The MBs should ensure proper ordering.
 	 */
@@ -4960,13 +4953,6 @@
 	sym_remque(&cp->link_ccbq);
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
 
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	/*
-	 *  Cancel any pending timeout condition.
-	 */
-	sym_untimeout_ccb(np, cp);
-#endif
-
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	if (lp) {
 		sym_remque(&cp->link2_ccbq);
@@ -5053,9 +5039,6 @@
 	/*
 	 *  Chain into optionnal lists.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-#endif
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	sym_insque_head(&cp->link2_ccbq, &np->dummy_ccbq);
 #endif
@@ -5818,14 +5801,6 @@
 	 *  Initializations for optional handling 
 	 *  of IO timeouts and device queueing.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	sym_que_init(&np->tmo0_ccbq);
-	np->tmo_ccbq =
-		sym_calloc(2*SYM_CONF_TIMEOUT_ORDER_MAX*sizeof(SYM_QUEHEAD),
-			   "TMO_CCBQ");
-	for (i = 0 ; i < 2*SYM_CONF_TIMEOUT_ORDER_MAX ; i++)
-		sym_que_init(&np->tmo_ccbq[i]);
-#endif
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	sym_que_init(&np->dummy_ccbq);
 #endif
@@ -5971,12 +5946,6 @@
 		sym_mfree_dma(np->scriptb0, np->scriptb_sz, "SCRIPTB0");
 	if (np->scripta0)
 		sym_mfree_dma(np->scripta0, np->scripta_sz, "SCRIPTA0");
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	if (np->tmo_ccbq)
-		sym_mfree(np->tmo_ccbq,
-			  2*SYM_CONF_TIMEOUT_ORDER_MAX*sizeof(SYM_QUEHEAD),
-			  "TMO_CCBQ");
-#endif
 	if (np->squeue)
 		sym_mfree_dma(np->squeue, sizeof(u32)*(MAX_QUEUE*2), "SQUEUE");
 	if (np->dqueue)
===== drivers/scsi/sym53c8xx_2/sym_hipd.h 1.8 vs edited =====
--- 1.8/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-09-13 11:10:32 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-10-26 14:38:30 +02:00
@@ -796,10 +796,6 @@
 	/*
 	 *  Other fields.
 	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	SYM_QUEHEAD tmo_linkq;	/* Optional timeout handling	*/
-	u_int	tmo_clock;	/* (link and dealine value)	*/
-#endif
 	u32	ccb_ba;		/* BUS address of this CCB	*/
 	u_short	tag;		/* Tag for this transfer	*/
 				/*  NO_TAG means no tag		*/
@@ -1025,15 +1004,6 @@
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	SYM_QUEHEAD	dummy_ccbq;
 #endif
-	/*
-	 *  Optional handling of IO timeouts.
-	 */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-	SYM_QUEHEAD tmo0_ccbq;
-	SYM_QUEHEAD *tmo_ccbq;	/* [2*SYM_TIMEOUT_ORDER_MAX] */
-	u_int	tmo_clock;
-	u_int	tmo_actq;
-#endif
 
 	/*
 	 *  IMMEDIATE ARBITRATION (IARB) control.
@@ -1111,20 +1081,6 @@
 int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram);
 
 /*
- *  Optionnaly, the driver may handle IO timeouts.
- */
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out);
-void sym_timeout_ccb(hcb_p np, ccb_p cp, u_int ticks);
-static void __inline sym_untimeout_ccb(hcb_p np, ccb_p cp)
-{
-	sym_remque(&cp->tmo_linkq);
-	sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-}
-void sym_clock(hcb_p np);
-#endif	/* SYM_OPT_HANDLE_IO_TIMEOUT */
-
-/*
  *  Optionnaly, the driver may provide a function
  *  to announce transfer rate changes.
  */
--- 1.7/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-10-24 18:08:18 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-10-26 14:32:01 +02:00
@@ -43,98 +43,6 @@
 #include "sym_glue.h"
 #endif
 
-#ifdef	SYM_OPT_HANDLE_IO_TIMEOUT
-/*
- *  Optional CCB timeout handling.
- *
- *  This code is useful for O/Ses that allow or expect 
- *  SIMs (low-level drivers) to handle SCSI IO timeouts.
- *  It uses a power-of-two based algorithm of my own:) 
- *  that avoids scanning of lists, provided that:
- *
- *  - The IO does complete in less than half the associated
- *    timeout value.
- *  - The greatest delay between the queuing of the IO and 
- *    its completion is less than 
- *          (1<<(SYM_CONF_TIMEOUT_ORDER_MAX-1))/2 ticks.
- *
- *  For example, if tick is 1 second and the max order is 8,
- *  any IO that is completed within less than 64 seconds will 
- *  just be put into some list at queuing and be removed 
- *  at completion without any additionnal overhead.
- */
-
-/*
- *  Set a timeout condition on a CCB.
- */ 
-void sym_timeout_ccb(hcb_p np, ccb_p cp, u_int ticks)
-{
-	sym_remque(&cp->tmo_linkq);
-	cp->tmo_clock = np->tmo_clock + ticks;
-	if (!ticks) {
-		sym_insque_head(&cp->tmo_linkq, &np->tmo0_ccbq);
-	}
-	else {
-		int i = SYM_CONF_TIMEOUT_ORDER_MAX - 1;
-		while (i > 0) {
-			if (ticks >= (1<<(i+1)))
-				break;
-			--i;
-		}
-		if (!(np->tmo_actq & (1<<i)))
-			i += SYM_CONF_TIMEOUT_ORDER_MAX;
-		sym_insque_head(&cp->tmo_linkq, &np->tmo_ccbq[i]);
-	}
-}
-
-/*
- *  Walk a list of CCB and handle timeout conditions.
- *  Should never be called in normal situations.
- */
-static void sym_walk_ccb_tmo_list(hcb_p np, SYM_QUEHEAD *tmoq)
-{
-	SYM_QUEHEAD qtmp, *qp;
-	ccb_p cp;
-
-	sym_que_move(tmoq, &qtmp);
-	while ((qp = sym_remque_head(&qtmp)) != 0) {
-		sym_insque_head(qp, &np->tmo0_ccbq);
-		cp = sym_que_entry(qp, struct sym_ccb, tmo_linkq);
-		if (cp->tmo_clock     != np->tmo_clock &&
-		    cp->tmo_clock + 1 != np->tmo_clock)
-			sym_timeout_ccb(np, cp, cp->tmo_clock - np->tmo_clock);
-		else
-			sym_abort_ccb(np, cp, 1);
-	}
-}
-
-/*
- * Our clock handler called from the O/S specific side.
- */
-void sym_clock(hcb_p np)
-{
-	int i, j;
-	u_int tmp;
-
-	tmp = np->tmo_clock;
-	tmp ^= (++np->tmo_clock);
-
-	for (i = 0; i < SYM_CONF_TIMEOUT_ORDER_MAX; i++, tmp >>= 1) {
-		if (!(tmp & 1))
-			continue;
-		j = i;
-		if (np->tmo_actq & (1<<i))
-			j += SYM_CONF_TIMEOUT_ORDER_MAX;
-
-		if (!sym_que_empty(&np->tmo_ccbq[j])) {
-			sym_walk_ccb_tmo_list(np, &np->tmo_ccbq[j]);
-		}
-		np->tmo_actq ^= (1<<i);
-	}
-}
-#endif	/* SYM_OPT_HANDLE_IO_TIMEOUT */
-
-
 #ifdef	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 /*
  *  Announce transfer rate if anything changed since last announcement.
