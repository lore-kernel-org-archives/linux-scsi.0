From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] ncr53c8xx: remove integrity checking code
Date: 04 Oct 2004 12:43:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096911839.2290.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:28821 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268356AbUJDRn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 13:43:59 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i94Hhwm13056
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2004 13:43:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The comments read like it's a precursor to mid-layer domain validation. 
However, it's never been compiled into the code base, so it doesn't look
useful.  I'll switch the ncr53c8xx to transport classes later.

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/03 10:47:42-05:00 jejb@pashleys.(none) 
#   ncr53c8xx: remove integrity checking
#   
#   The comments read like it's a precursor to mid layer
#   domain validation.  Anyway, it's never been compiled.
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/ncr53c8xx.c
#   2004/10/03 10:44:22-05:00 jejb@pashleys.(none) +0 -296
#   ncr53c8xx: remove integrity checking
# 
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	2004-10-04 12:42:19 -05:00
+++ b/drivers/scsi/ncr53c8xx.c	2004-10-04 12:42:19 -05:00
@@ -126,15 +126,6 @@
 
 #include "ncr53c8xx.h"
 
-/*
-**	Donnot compile integrity checking code for Linux-2.3.0 
-**	and above since SCSI data structures are not ready yet.
-*/
-/* #if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
-#if 0
-#define	SCSI_NCR_INTEGRITY_CHECKING
-#endif
-
 #define NAME53C			"ncr53c"
 #define NAME53C8XX		"ncr53c8xx"
 
@@ -563,13 +554,6 @@
 /*3*/	u_char	wval;
 #endif
 
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-	u_char 	ic_min_sync;
-	u_char 	ic_max_width;
-	u_char 	ic_maximums_set;
-	u_char 	ic_done;
-#endif
-
 	/* User settable limits and options.  */
 	u_char	usrsync;
 	u_char	usrwide;
@@ -1088,17 +1072,6 @@
 	struct ccb	*ccb;		/* Global CCB			*/
 	struct usrcmd	user;		/* Command from user		*/
 	volatile u_char	release_stage;	/* Synchronisation stage on release  */
-
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-	/*----------------------------------------------------------------
-	**	Fields that are used for integrity check
-	**----------------------------------------------------------------
-	*/
-	unsigned char check_integrity; /* Enable midlayer integ.check on
-					* bus scan. */
-	unsigned char check_integ_par;  /* Set if par or Init. Det. error
-					 * used only during integ check */
-#endif
 };
 
 #define NCB_SCRIPT_PHYS(np,lbl)	 (np->p_script  + offsetof (struct script, lbl))
@@ -1281,9 +1254,6 @@
 static	u_long	ncr_lookup	(char* id);
 static	void	ncr_negotiate	(struct ncb* np, struct tcb* tp);
 static	int	ncr_prepare_nego(struct ncb *np, struct ccb *cp, u_char *msgptr);
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-static	int	ncr_ic_nego(struct ncb *np, struct ccb *cp, struct scsi_cmnd *cmd, u_char *msgptr);
-#endif
 
 static	void	ncr_script_copy_and_bind
 				(struct ncb *np, ncrcmd *src, ncrcmd *dst, int len);
@@ -3421,182 +3391,6 @@
 /*==========================================================
 **
 **
-**	Prepare the next negotiation message for integrity check,
-**	if needed.
-**
-**	Fill in the part of message buffer that contains the 
-**	negotiation and the nego_status field of the CCB.
-**	Returns the size of the message in bytes.
-**
-**
-**==========================================================
-*/
-
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-static int ncr_ic_nego(struct ncb *np, struct ccb *cp, struct scsi_cmnd *cmd, u_char *msgptr)
-{
-	struct tcb *tp = &np->target[cp->target];
-	int msglen = 0;
-	int nego = 0;
-	u_char no_increase;
-
-	if (tp->inq_done) {
-
-		if (!tp->ic_maximums_set) {
-			tp->ic_maximums_set = 1;
-
-			/* check target and host adapter capabilities */
-			if ( (tp->inq_byte7 & INQ7_WIDE16) && 
-					np->maxwide && tp->usrwide ) 
-				tp->ic_max_width = 1;
-			else
-				tp->ic_max_width = 0;
-
-			if ((tp->inq_byte7 & INQ7_SYNC) && tp->maxoffs) {
-				tp->ic_min_sync   = (tp->minsync < np->minsync) ?
-							np->minsync : tp->minsync;
-			}
-			else 
-				tp->ic_min_sync   = 255;
-			
-			tp->period   = 1;
-			tp->widedone = 1;
-		}
-
-		if (DEBUG_FLAGS & DEBUG_IC) {
-			printk("%s: cmd->ic_nego %d, 1st byte 0x%2X\n",
-				ncr_name(np), cmd->ic_nego, cmd->cmnd[0]);
-		}
-
-		/* First command from integrity check routine will request
-		 * a PPR message.  Disable.
-		 */
-		if ((cmd->ic_nego & NS_PPR) == NS_PPR)
-			cmd->ic_nego &= ~NS_PPR;
-		/* Previous command recorded a parity or an initiator
-		 * detected error condition. Force bus to narrow for this
-		 * target. Clear flag. Negotation on request sense.
-		 * Note: kernel forces 2 bus resets :o( but clears itself out.
-		 * Minor bug? in scsi_obsolete.c (ugly)
-		 */
-		if (np->check_integ_par) {
-			printk("%s: Parity Error. Target set to narrow.\n",
-				ncr_name(np));
-			tp->ic_max_width = 0;
-			tp->widedone = tp->period = 0;
-		}
-		
-		/* In case of a bus reset, ncr_negotiate will reset 
-		 * the flags tp->widedone and tp->period to 0, forcing
-		 * a new negotiation. 
-		 */
-		no_increase = 0;
-		if (tp->widedone == 0) {
-			cmd->ic_nego = NS_WIDE;
-			tp->widedone = 1;
-			no_increase = 1;
-		}
-		else if (tp->period == 0) {
-			cmd->ic_nego = NS_SYNC;
-			tp->period = 1;
-			no_increase = 1;
-		}
-			
-		switch (cmd->ic_nego) {
-		case NS_WIDE:
-			/*
-			**	negotiate wide transfers ?
-			**	Do NOT negotiate if device only supports
-			**	narrow.	
-			*/
-			if (tp->ic_max_width | np->check_integ_par) {
-				nego = NS_WIDE;
-
-				msgptr[msglen++] = M_EXTENDED;
-				msgptr[msglen++] = 2;
-				msgptr[msglen++] = M_X_WIDE_REQ;
-				msgptr[msglen++] = cmd->ic_nego_width & tp->ic_max_width;
-			}
-			else
-				cmd->ic_nego_width &= tp->ic_max_width;
-
-			break;
-
-		case NS_SYNC:
-			/*
-			**	negotiate synchronous transfers?
-			**	Target must support sync transfers.
-			**
-			**	If period becomes longer than max, reset to async
-			*/
-
-			if (tp->inq_byte7 & INQ7_SYNC) {
-
-				nego = NS_SYNC;
-
-				msgptr[msglen++] = M_EXTENDED;
-				msgptr[msglen++] = 3;
-				msgptr[msglen++] = M_X_SYNC_REQ;
-
-				switch (cmd->ic_nego_sync) {
-				case 2: /* increase the period */
-					if (!no_increase) {
-					  if (tp->ic_min_sync <= 0x0A)
-					      tp->ic_min_sync = 0x0C;
-					  else if (tp->ic_min_sync <= 0x0C)
-					      tp->ic_min_sync = 0x19;
-					  else if (tp->ic_min_sync <= 0x19)
-					      tp->ic_min_sync *= 2;
-					  else {
-						tp->ic_min_sync = 255;
-						cmd->ic_nego_sync = 0;
-						tp->maxoffs = 0;
-					   }
-					}
-					msgptr[msglen++] = tp->maxoffs?tp->ic_min_sync:0;
-					msgptr[msglen++] = tp->maxoffs;
-					break;
-
-				case 1: /* nego. to maximum */
-					msgptr[msglen++] = tp->maxoffs?tp->ic_min_sync:0;
-					msgptr[msglen++] = tp->maxoffs;
-					break;
-
-				case 0:	/* nego to async */
-				default:
-					msgptr[msglen++] = 0;
-					msgptr[msglen++] = 0;
-					break;
-				};
-			}
-			else
-				cmd->ic_nego_sync = 0;
-			break;
-
-		case NS_NOCHANGE:
-		default:
-			break;
-		};
-	};
-
-	cp->nego_status = nego;
-	np->check_integ_par = 0;
-
-	if (nego) {
-		tp->nego_cp = cp;
-		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			ncr_print_msg(cp, nego == NS_WIDE ?
-			  "wide/narrow msgout": "sync/async msgout", msgptr);
-		};
-	};
-
-	return msglen;
-}
-#endif /* SCSI_NCR_INTEGRITY_CHECKING */
-
-/*==========================================================
-**
-**
 **	Prepare the next negotiation message if needed.
 **
 **	Fill in the part of message buffer that contains the 
@@ -3623,10 +3417,6 @@
 		if (!tp->widedone) {
 			if (tp->inq_byte7 & INQ7_WIDE16) {
 				nego = NS_WIDE;
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-				if (tp->ic_done)
-		       			 tp->usrwide &= tp->ic_max_width;
-#endif
 			} else
 				tp->widedone=1;
 
@@ -3639,11 +3429,6 @@
 		if (!nego && !tp->period) {
 			if (tp->inq_byte7 & INQ7_SYNC) {
 				nego = NS_SYNC;
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-				if ((tp->ic_done) &&
-				 	      (tp->minsync < tp->ic_min_sync))
-		       			 tp->minsync = tp->ic_min_sync;
-#endif
 			} else {
 				tp->period  =0xffff;
 				PRINT_TARGET(np, cp->target);
@@ -3849,72 +3634,9 @@
 
 	cp->nego_status = 0;
 
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-	if ((np->check_integrity && tp->ic_done) || !np->check_integrity) {
-		 if ((!tp->widedone || !tp->period) && !tp->nego_cp && lp) {
-			msglen += ncr_prepare_nego (np, cp, msgptr + msglen);
-		 }
-	}
-	else if (np->check_integrity && (cmd->ic_in_progress)) { 
-		msglen += ncr_ic_nego (np, cp, cmd, msgptr + msglen);
-	}
-	else if (np->check_integrity && cmd->ic_complete) {
-		/*
-		 * Midlayer signal to the driver that all of the scsi commands
-		 * for the integrity check have completed. Save the negotiated
-		 * parameters (extracted from sval and wval). 
-		 */ 
-
-		{
-			u_char idiv;
-			idiv = (tp->wval>>4) & 0x07;
-			if ((tp->sval&0x1f) && idiv )
-				tp->period = (((tp->sval>>5)+4)  
-						*div_10M[idiv-1])/np->clock_khz;
-			else
-				tp->period = 0xffff;
-		}
-		/*
-		 * tp->period contains 10 times the transfer period, 
-		 * which itself is 4 * the requested negotiation rate.
-		 */
-		if	(tp->period <= 250)	tp->ic_min_sync = 10;
-		else if	(tp->period <= 303)	tp->ic_min_sync = 11;
-		else if	(tp->period <= 500)	tp->ic_min_sync = 12;
-		else				
-				tp->ic_min_sync = (tp->period + 40 - 1) / 40;
-
-
-		/*
-		 * Negotiation for this target it complete.
-		 */
-		tp->ic_max_width =  (tp->wval & EWS) ? 1: 0;
-		tp->ic_done = 1;
-		tp->widedone = 1;
-
-		printk("%s: Integrity Check Complete: \n", ncr_name(np)); 
-
-		printk("%s: %s %s SCSI", ncr_name(np), 
-				(tp->sval&0x1f)?"SYNC":"ASYNC",
-				tp->ic_max_width?"WIDE":"NARROW");
-
-		if (tp->sval&0x1f) {
-			u_long mbs = 10000 * (tp->ic_max_width + 1);
-
-			printk(" %d.%d  MB/s", (int) (mbs / tp->period),
-					(int) (mbs % tp->period));
-
-			printk(" (%d ns, %d offset)\n", 
-				  tp->period/10, tp->sval&0x1f);
-		} else {
-			printk(" %d MB/s. \n ", (tp->ic_max_width+1)*5);
-		}
-	}
-#else
 	if ((!tp->widedone || !tp->period) && !tp->nego_cp && lp) {
 		msglen += ncr_prepare_nego (np, cp, msgptr + msglen);
 	}
-#endif /* SCSI_NCR_INTEGRITY_CHECKING */
 
 	/*----------------------------------------------------
 	**
@@ -5883,13 +5605,6 @@
 	else
 		msg = M_ID_ERROR;
 
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-	/*
-	**      Save error message. For integrity check use only.
-	*/
-	if (np->check_integrity)
-		np->check_integ_par = msg;
-#endif
 
 	/*
 	 *	If the NCR stopped on a MOVE ^ DATA_IN, we jump to a 
@@ -8296,17 +8011,6 @@
 	instance->can_queue	= (MAX_START-4);
 	scsi_set_device(instance, device->dev);
 
-#ifdef SCSI_NCR_INTEGRITY_CHECKING
-	np->check_integrity	  = 0;
-	instance->check_integrity = 0;
-
-#ifdef SCSI_NCR_ENABLE_INTEGRITY_CHECK
-	if ( !(driver_setup.bus_check & 0x04) ) {
-		np->check_integrity	  = 1;
-		instance->check_integrity = 1;
-	}
-#endif
-#endif
 	/* Patch script to physical addresses */
 	ncr_script_fill(&script0, &scripth0);
 



