From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sym2: remove SYM_OPT_HANDLE_DEVICE_QUEUEING code
Date: Tue, 2 Jan 2007 17:38:46 +0100
Message-ID: <20070102163846.GB17602@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49292 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbXABQit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 11:38:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

All per-device queueing is handled by the scsi midlayer for quite
a while so we can remove the code to deal with it.  It has been
completly disabled at the cpp level already.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
--- linux-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.h	2007-01-02 17:12:14.000000000 +0100
+++ linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2007-01-02 17:12:18.000000000 +0100
@@ -67,7 +67,6 @@
  */
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
-#undef SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 
 /*
Index: linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-01-02 17:10:14.000000000 +0100
+++ linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-01-02 17:11:40.000000000 +0100
@@ -1529,57 +1529,6 @@
 	OUTB(np, nc_istat, SIGP|np->istat_sem);
 }
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-/*
- *  Start next ready-to-start CCBs.
- */
-void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn)
-{
-	SYM_QUEHEAD *qp;
-	struct sym_ccb *cp;
-
-	/* 
-	 *  Paranoia, as usual. :-)
-	 */
-	assert(!lp->started_tags || !lp->started_no_tag);
-
-	/*
-	 *  Try to start as many commands as asked by caller.
-	 *  Prevent from having both tagged and untagged 
-	 *  commands queued to the device at the same time.
-	 */
-	while (maxn--) {
-		qp = sym_remque_head(&lp->waiting_ccbq);
-		if (!qp)
-			break;
-		cp = sym_que_entry(qp, struct sym_ccb, link2_ccbq);
-		if (cp->tag != NO_TAG) {
-			if (lp->started_no_tag ||
-			    lp->started_tags >= lp->started_max) {
-				sym_insque_head(qp, &lp->waiting_ccbq);
-				break;
-			}
-			lp->itlq_tbl[cp->tag] = cpu_to_scr(cp->ccb_ba);
-			lp->head.resel_sa =
-				cpu_to_scr(SCRIPTA_BA(np, resel_tag));
-			++lp->started_tags;
-		} else {
-			if (lp->started_no_tag || lp->started_tags) {
-				sym_insque_head(qp, &lp->waiting_ccbq);
-				break;
-			}
-			lp->head.itl_task_sa = cpu_to_scr(cp->ccb_ba);
-			lp->head.resel_sa =
-			      cpu_to_scr(SCRIPTA_BA(np, resel_no_tag));
-			++lp->started_no_tag;
-		}
-		cp->started = 1;
-		sym_insque_tail(qp, &lp->started_ccbq);
-		sym_put_start_queue(np, cp);
-	}
-}
-#endif /* SYM_OPT_HANDLE_DEVICE_QUEUEING */
-
 /*
  *  The chip may have completed jobs. Look at the DONE QUEUE.
  *
@@ -1649,25 +1598,6 @@
 		cmd = cp->cmd;
 		if (cam_status)
 			sym_set_cam_status(cmd, cam_status);
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-		if (sym_get_cam_status(cmd) == DID_SOFT_ERROR) {
-			struct sym_tcb *tp = &np->target[cp->target];
-			struct sym_lcb *lp = sym_lp(tp, cp->lun);
-			if (lp) {
-				sym_remque(&cp->link2_ccbq);
-				sym_insque_tail(&cp->link2_ccbq,
-				                &lp->waiting_ccbq);
-				if (cp->started) {
-					if (cp->tag != NO_TAG)
-						--lp->started_tags;
-					else
-						--lp->started_no_tag;
-				}
-			}
-			cp->started = 0;
-			continue;
-		}
-#endif
 		sym_free_ccb(np, cp);
 		sym_xpt_done(np, cmd);
 	}
@@ -3327,12 +3257,7 @@
 		/*
 		 *  Make sure at least our IO to abort has been dequeued.
 		 */
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
 		assert(i && sym_get_cam_status(cp->cmd) == DID_SOFT_ERROR);
-#else
-		sym_remque(&cp->link_ccbq);
-		sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
-#endif
 		/*
 		 *  Keep track in cam status of the reason of the abort.
 		 */
@@ -4606,10 +4531,8 @@
 			/*
 			 *  Debugging purpose.
 			 */
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
 			if (lp->busy_itl != 0)
 				goto out_free;
-#endif
 			/*
 			 *  Allocate resources for tags if not yet.
 			 */
@@ -4629,11 +4552,9 @@
 				if (++lp->ia_tag == SYM_CONF_MAX_TASK)
 					lp->ia_tag = 0;
 				++lp->busy_itlq;
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
 				lp->itlq_tbl[tag] = cpu_to_scr(cp->ccb_ba);
 				lp->head.resel_sa =
 					cpu_to_scr(SCRIPTA_BA(np, resel_tag));
-#endif
 #ifdef SYM_OPT_LIMIT_COMMAND_REORDERING
 				cp->tags_si = lp->tags_si;
 				++lp->tags_sum[cp->tags_si];
@@ -4652,17 +4573,14 @@
 			/*
 			 *  Debugging purpose.
 			 */
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
 			if (lp->busy_itl != 0 || lp->busy_itlq != 0)
 				goto out_free;
-#endif
 			/*
 			 *  Count this nexus for this LUN.
 			 *  Set up the CCB bus address for reselection.
 			 *  Toggle reselect path to untagged.
 			 */
 			++lp->busy_itl;
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
 			if (lp->busy_itl == 1) {
 				lp->head.itl_task_sa = cpu_to_scr(cp->ccb_ba);
 				lp->head.resel_sa =
@@ -4670,20 +4588,12 @@
 			}
 			else
 				goto out_free;
-#endif
 		}
 	}
 	/*
 	 *  Put the CCB into the busy queue.
 	 */
 	sym_insque_tail(&cp->link_ccbq, &np->busy_ccbq);
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	if (lp) {
-		sym_remque(&cp->link2_ccbq);
-		sym_insque_tail(&cp->link2_ccbq, &lp->waiting_ccbq);
-	}
-
-#endif
 	cp->to_abort = 0;
 	cp->odd_byte_adjustment = 0;
 	cp->tag	   = tag;
@@ -4778,20 +4688,6 @@
 	cp->host_status = HS_IDLE;
 	sym_remque(&cp->link_ccbq);
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
-
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	if (lp) {
-		sym_remque(&cp->link2_ccbq);
-		sym_insque_tail(&cp->link2_ccbq, &np->dummy_ccbq);
-		if (cp->started) {
-			if (cp->tag != NO_TAG)
-				--lp->started_tags;
-			else
-				--lp->started_no_tag;
-		}
-	}
-	cp->started = 0;
-#endif
 }
 
 /*
@@ -4848,13 +4744,6 @@
 	 *  Chain into free ccb queue.
 	 */
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
-
-	/*
-	 *  Chain into optionnal lists.
-	 */
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	sym_insque_head(&cp->link2_ccbq, &np->dummy_ccbq);
-#endif
 	return cp;
 out_free:
 	if (cp)
@@ -4966,17 +4855,6 @@
 	 *  Set user capabilities.
 	 */
 	lp->user_flags = tp->usrflags & (SYM_DISC_ENABLED | SYM_TAGS_ENABLED);
-
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  Initialize device queueing.
-	 */
-	sym_que_init(&lp->waiting_ccbq);
-	sym_que_init(&lp->started_ccbq);
-	lp->started_max   = SYM_CONF_MAX_TASK;
-	lp->started_limit = SYM_CONF_MAX_TASK;
-#endif
-
 fail:
 	return lp;
 }
@@ -5303,44 +5181,11 @@
 	 */
 	OUTL_DSP(np, SCRIPTA_BA(np, start));
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	if (cp->host_status == HS_COMPLETE &&
-	    cp->ssss_status == S_QUEUE_FULL) {
-		if (!lp || lp->started_tags - i < 2)
-			goto weirdness;
-		/*
-		 *  Decrease queue depth as needed.
-		 */
-		lp->started_max = lp->started_tags - i - 1;
-		lp->num_sgood = 0;
-
-		if (sym_verbose >= 2) {
-			sym_print_addr(cmd, " queue depth is now %d\n",
-					lp->started_max);
-		}
-
-		/*
-		 *  Repair the CCB.
-		 */
-		cp->host_status = HS_BUSY;
-		cp->ssss_status = S_ILLEGAL;
-
-		/*
-		 *  Let's requeue it to device.
-		 */
-		sym_set_cam_status(cmd, DID_SOFT_ERROR);
-		goto finish;
-	}
-weirdness:
-#endif
 	/*
 	 *  Build result in CAM ccb.
 	 */
 	sym_set_cam_result_error(np, cp, resid);
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-finish:
-#endif
 	/*
 	 *  Add this one to the COMP queue.
 	 */
@@ -5352,13 +5197,6 @@
 	 *  or requeue condition.
 	 */
 	sym_flush_comp_queue(np, 0);
-
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  Donnot start more than 1 command after an error.
-	 */
-	sym_start_next_ccbs(np, lp, 1);
-#endif
 }
 
 /*
@@ -5420,36 +5258,11 @@
 	 */
 	sym_set_cam_result_ok(cp, cmd, resid);
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  If max number of started ccbs had been reduced,
-	 *  increase it if 200 good status received.
-	 */
-	if (lp && lp->started_max < lp->started_limit) {
-		++lp->num_sgood;
-		if (lp->num_sgood >= 200) {
-			lp->num_sgood = 0;
-			++lp->started_max;
-			if (sym_verbose >= 2) {
-				sym_print_addr(cmd, " queue depth is now %d\n",
-				       lp->started_max);
-			}
-		}
-	}
-#endif
-
 	/*
 	 *  Free our CCB.
 	 */
 	sym_free_ccb (np, cp);
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  Requeue a couple of awaiting scsi commands.
-	 */
-	if (!sym_que_empty(&lp->waiting_ccbq))
-		sym_start_next_ccbs(np, lp, 2);
-#endif
 	/*
 	 *  Complete the command.
 	 */
@@ -5551,13 +5364,6 @@
 	sym_que_init(&np->comp_ccbq);
 
 	/*
-	 *  Initialization for optional handling 
-	 *  of device queueing.
-	 */
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	sym_que_init(&np->dummy_ccbq);
-#endif
-	/*
 	 *  Allocate some CCB. We need at least ONE.
 	 */
 	if (!sym_alloc_ccb(np))
Index: linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
===================================================================
--- linux-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-01-02 17:10:14.000000000 +0100
+++ linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-01-02 17:12:09.000000000 +0100
@@ -48,17 +48,12 @@
  *  They may be defined in platform specific headers, if they 
  *  are useful.
  *
- *    SYM_OPT_HANDLE_DEVICE_QUEUEING
- *        When this option is set, the driver will use a queue per 
- *        device and handle QUEUE FULL status requeuing internally.
- *
  *    SYM_OPT_LIMIT_COMMAND_REORDERING
  *        When this option is set, the driver tries to limit tagged 
  *        command reordering to some reasonnable value.
  *        (set for Linux)
  */
 #if 0
-#define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #endif
 
@@ -508,20 +503,6 @@
 	struct sym_slcb s;
 #endif
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  Optionnaly the driver can handle device queueing, 
-	 *  and requeues internally command to redo.
-	 */
-	SYM_QUEHEAD waiting_ccbq;
-	SYM_QUEHEAD started_ccbq;
-	int	num_sgood;
-	u_short	started_tags;
-	u_short	started_no_tag;
-	u_short	started_max;
-	u_short	started_limit;
-#endif
-
 #ifdef SYM_OPT_LIMIT_COMMAND_REORDERING
 	/*
 	 *  Optionally the driver can try to prevent SCSI 
@@ -785,10 +766,6 @@
 	u32	goalp;		/* Expected last data pointer	*/
 	int	ext_sg;		/* Extreme data pointer, used	*/
 	int	ext_ofs;	/*  to calculate the residual.	*/
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	SYM_QUEHEAD link2_ccbq;	/* Link for device queueing	*/
-	u_char	started;	/* CCB queued to the squeue	*/
-#endif
 	u_char	to_abort;	/* Want this IO to be aborted	*/
 #ifdef SYM_OPT_LIMIT_COMMAND_REORDERING
 	u_char	tags_si;	/* Lun tags sum index (0,1)	*/
@@ -987,10 +964,6 @@
 	 */
 	SYM_QUEHEAD	comp_ccbq;
 
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	SYM_QUEHEAD	dummy_ccbq;
-#endif
-
 	/*
 	 *  IMMEDIATE ARBITRATION (IARB) control.
 	 *
@@ -1047,11 +1020,7 @@
 void sym_print_xerr(struct scsi_cmnd *cmd, int x_status);
 int sym_reset_scsi_bus(struct sym_hcb *np, int enab_int);
 struct sym_chip *sym_lookup_chip_table(u_short device_id, u_char revision);
-#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn);
-#else
 void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
-#endif
 void sym_start_up(struct sym_hcb *np, int reason);
 void sym_interrupt(struct sym_hcb *np);
 int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
