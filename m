From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] ncr53c8xx update
Date: Fri, 17 Feb 2006 13:18:41 -0700
Message-ID: <20060217201841.GT12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:8926 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751688AbWBQUSx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 15:18:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


Delete unused NAME53C definition
Remove use of the M_* constants; use the common SCSI constants instead
Translate some remaining German
Add a missing changelog entry

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -urpNX dontdiff linus-2.6/drivers/scsi/ncr53c8xx.c parisc-2.6/drivers/scsi/ncr53c8xx.c
--- linus-2.6/drivers/scsi/ncr53c8xx.c	2006-02-12 20:55:18.000000000 -0700
+++ parisc-2.6/drivers/scsi/ncr53c8xx.c	2006-02-12 20:33:43.000000000 -0700
@@ -69,6 +69,10 @@
 **     Low PCI traffic for command handling when on-chip RAM is present.
 **     Aggressive SCSI SCRIPTS optimizations.
 **
+**  2005 by Matthew Wilcox and James Bottomley
+**     PCI-ectomy.  This driver now supports only the 720 chip (see the
+**     NCR_Q720 and zalon drivers for the bus probe logic).
+**
 *******************************************************************************
 */
 
@@ -90,13 +94,6 @@
 
 #define SCSI_NCR_DEBUG_FLAGS	(0)
 
-/*==========================================================
-**
-**      Include files
-**
-**==========================================================
-*/
-
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -121,6 +118,7 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
@@ -128,10 +126,8 @@
 
 #include "ncr53c8xx.h"
 
-#define NAME53C			"ncr53c"
 #define NAME53C8XX		"ncr53c8xx"
 
-
 /*==========================================================
 **
 **	Debugging tags
@@ -2111,7 +2107,7 @@ static	struct script script0 __initdata 
 	*/
 
 	/*
-	**	The M_REJECT problem seems to be due to a selection 
+	**	The MESSAGE_REJECT problem seems to be due to a selection 
 	**	timing problem.
 	**	Wait immediately for the selection to complete. 
 	**	(2.5x behaves so)
@@ -2162,7 +2158,7 @@ static	struct script script0 __initdata 
 	/*
 	**	Selection complete.
 	**	Send the IDENTIFY and SIMPLE_TAG messages
-	**	(and the M_X_SYNC_REQ message)
+	**	(and the EXTENDED_SDTR message)
 	*/
 	SCR_MOVE_TBL ^ SCR_MSG_OUT,
 		offsetof (struct dsb, smsg),
@@ -2191,7 +2187,7 @@ static	struct script script0 __initdata 
 	/*
 	**	Initialize the msgout buffer with a NOOP message.
 	*/
-	SCR_LOAD_REG (scratcha, M_NOOP),
+	SCR_LOAD_REG (scratcha, NOP),
 		0,
 	SCR_COPY (1),
 		RADDR (scratcha),
@@ -2343,21 +2339,21 @@ static	struct script script0 __initdata 
 	/*
 	**	Handle this message.
 	*/
-	SCR_JUMP ^ IFTRUE (DATA (M_COMPLETE)),
+	SCR_JUMP ^ IFTRUE (DATA (COMMAND_COMPLETE)),
 		PADDR (complete),
-	SCR_JUMP ^ IFTRUE (DATA (M_DISCONNECT)),
+	SCR_JUMP ^ IFTRUE (DATA (DISCONNECT)),
 		PADDR (disconnect),
-	SCR_JUMP ^ IFTRUE (DATA (M_SAVE_DP)),
+	SCR_JUMP ^ IFTRUE (DATA (SAVE_POINTERS)),
 		PADDR (save_dp),
-	SCR_JUMP ^ IFTRUE (DATA (M_RESTORE_DP)),
+	SCR_JUMP ^ IFTRUE (DATA (RESTORE_POINTERS)),
 		PADDR (restore_dp),
-	SCR_JUMP ^ IFTRUE (DATA (M_EXTENDED)),
+	SCR_JUMP ^ IFTRUE (DATA (EXTENDED_MESSAGE)),
 		PADDRH (msg_extended),
-	SCR_JUMP ^ IFTRUE (DATA (M_NOOP)),
+	SCR_JUMP ^ IFTRUE (DATA (NOP)),
 		PADDR (clrack),
-	SCR_JUMP ^ IFTRUE (DATA (M_REJECT)),
+	SCR_JUMP ^ IFTRUE (DATA (MESSAGE_REJECT)),
 		PADDRH (msg_reject),
-	SCR_JUMP ^ IFTRUE (DATA (M_IGN_RESIDUE)),
+	SCR_JUMP ^ IFTRUE (DATA (IGNORE_WIDE_RESIDUE)),
 		PADDRH (msg_ign_residue),
 	/*
 	**	Rest of the messages left as
@@ -2372,7 +2368,7 @@ static	struct script script0 __initdata 
 	*/
 	SCR_INT,
 		SIR_REJECT_SENT,
-	SCR_LOAD_REG (scratcha, M_REJECT),
+	SCR_LOAD_REG (scratcha, MESSAGE_REJECT),
 		0,
 }/*-------------------------< SETMSG >----------------------*/,{
 	SCR_COPY (1),
@@ -2564,7 +2560,7 @@ static	struct script script0 __initdata 
 	/*
 	**	If it was no ABORT message ...
 	*/
-	SCR_JUMP ^ IFTRUE (DATA (M_ABORT)),
+	SCR_JUMP ^ IFTRUE (DATA (ABORT_TASK_SET)),
 		PADDRH (msg_out_abort),
 	/*
 	**	... wait for the next phase
@@ -2576,7 +2572,7 @@ static	struct script script0 __initdata 
 	/*
 	**	... else clear the message ...
 	*/
-	SCR_LOAD_REG (scratcha, M_NOOP),
+	SCR_LOAD_REG (scratcha, NOP),
 		0,
 	SCR_COPY (4),
 		RADDR (scratcha),
@@ -3035,7 +3031,7 @@ static	struct scripth scripth0 __initdat
 	*/
 	SCR_MOVE_ABS (1) ^ SCR_MSG_IN,
 		NADDR (msgin[2]),
-	SCR_JUMP ^ IFTRUE (DATA (M_X_WIDE_REQ)),
+	SCR_JUMP ^ IFTRUE (DATA (EXTENDED_WDTR)),
 		PADDRH (msg_wdtr),
 	/*
 	**	unknown extended message
@@ -3069,7 +3065,7 @@ static	struct scripth scripth0 __initdat
 
 }/*-------------------------< SEND_WDTR >----------------*/,{
 	/*
-	**	Send the M_X_WIDE_REQ
+	**	Send the EXTENDED_WDTR
 	*/
 	SCR_MOVE_ABS (4) ^ SCR_MSG_OUT,
 		NADDR (msgout),
@@ -3089,7 +3085,7 @@ static	struct scripth scripth0 __initdat
 	*/
 	SCR_MOVE_ABS (1) ^ SCR_MSG_IN,
 		NADDR (msgin[2]),
-	SCR_JUMP ^ IFTRUE (DATA (M_X_SYNC_REQ)),
+	SCR_JUMP ^ IFTRUE (DATA (EXTENDED_SDTR)),
 		PADDRH (msg_sdtr),
 	/*
 	**	unknown extended message
@@ -3124,7 +3120,7 @@ static	struct scripth scripth0 __initdat
 
 }/*-------------------------< SEND_SDTR >-------------*/,{
 	/*
-	**	Send the M_X_SYNC_REQ
+	**	Send the EXTENDED_SDTR
 	*/
 	SCR_MOVE_ABS (5) ^ SCR_MSG_OUT,
 		NADDR (msgout),
@@ -3202,10 +3198,10 @@ static	struct scripth scripth0 __initdat
 
 }/*-------------------------< RESET >----------------------*/,{
 	/*
-	**      Send a M_RESET message if bad IDENTIFY 
+	**      Send a TARGET_RESET message if bad IDENTIFY 
 	**	received on reselection.
 	*/
-	SCR_LOAD_REG (scratcha, M_ABORT_TAG),
+	SCR_LOAD_REG (scratcha, ABORT_TASK),
 		0,
 	SCR_JUMP,
 		PADDRH (abort_resel),
@@ -3213,7 +3209,7 @@ static	struct scripth scripth0 __initdat
 	/*
 	**      Abort a wrong tag received on reselection.
 	*/
-	SCR_LOAD_REG (scratcha, M_ABORT_TAG),
+	SCR_LOAD_REG (scratcha, ABORT_TASK),
 		0,
 	SCR_JUMP,
 		PADDRH (abort_resel),
@@ -3221,7 +3217,7 @@ static	struct scripth scripth0 __initdat
 	/*
 	**      Abort a reselection when no active CCB.
 	*/
-	SCR_LOAD_REG (scratcha, M_ABORT),
+	SCR_LOAD_REG (scratcha, ABORT_TASK_SET),
 		0,
 }/*-------------------------< ABORT_RESEL >----------------*/,{
 	SCR_COPY (1),
@@ -3333,7 +3329,7 @@ static	struct scripth scripth0 __initdat
 	**	Read the message, since we got it directly 
 	**	from the SCSI BUS data lines.
 	**	Signal problem to C code for logging the event.
-	**	Send a M_ABORT to clear all pending tasks.
+	**	Send an ABORT_TASK_SET to clear all pending tasks.
 	*/
 	SCR_INT,
 		SIR_RESEL_BAD_LUN,
@@ -3345,7 +3341,7 @@ static	struct scripth scripth0 __initdat
 	/*
 	**	We donnot have a task for that I_T_L.
 	**	Signal problem to C code for logging the event.
-	**	Send a M_ABORT message.
+	**	Send an ABORT_TASK_SET message.
 	*/
 	SCR_INT,
 		SIR_RESEL_BAD_I_T_L,
@@ -3355,7 +3351,7 @@ static	struct scripth scripth0 __initdat
 	/*
 	**	We donnot have a task that matches the tag.
 	**	Signal problem to C code for logging the event.
-	**	Send a M_ABORTTAG message.
+	**	Send an ABORT_TASK message.
 	*/
 	SCR_INT,
 		SIR_RESEL_BAD_I_T_L_Q,
@@ -3366,7 +3362,7 @@ static	struct scripth scripth0 __initdat
 	**	We donnot know the target that reselected us.
 	**	Grab the first message if any (IDENTIFY).
 	**	Signal problem to C code for logging the event.
-	**	M_RESET message.
+	**	TARGET_RESET message.
 	*/
 	SCR_INT,
 		SIR_RESEL_BAD_TARGET,
@@ -4109,16 +4105,16 @@ static int ncr_prepare_nego(struct ncb *
 
 	switch (nego) {
 	case NS_SYNC:
-		msgptr[msglen++] = M_EXTENDED;
+		msgptr[msglen++] = EXTENDED_MESSAGE;
 		msgptr[msglen++] = 3;
-		msgptr[msglen++] = M_X_SYNC_REQ;
+		msgptr[msglen++] = EXTENDED_SDTR;
 		msgptr[msglen++] = tp->maxoffs ? tp->minsync : 0;
 		msgptr[msglen++] = tp->maxoffs;
 		break;
 	case NS_WIDE:
-		msgptr[msglen++] = M_EXTENDED;
+		msgptr[msglen++] = EXTENDED_MESSAGE;
 		msgptr[msglen++] = 2;
-		msgptr[msglen++] = M_X_WIDE_REQ;
+		msgptr[msglen++] = EXTENDED_WDTR;
 		msgptr[msglen++] = tp->usrwide;
 		break;
 	}
@@ -4220,7 +4216,7 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 
-	idmsg = M_IDENTIFY | sdev->lun;
+	idmsg = IDENTIFY(0, sdev->lun);
 
 	if (cp ->tag != NO_TAG ||
 		(cp != np->ccb && np->disc && !(tp->usrflag & UF_NODISC)))
@@ -4239,7 +4235,7 @@ static int ncr_queue_command (struct ncb
 		*/
 		if (lp && time_after(jiffies, lp->tags_stime)) {
 			if (lp->tags_smap) {
-				order = M_ORDERED_TAG;
+				order = ORDERED_QUEUE_TAG;
 				if ((DEBUG_FLAGS & DEBUG_TAGS)||bootverbose>2){ 
 					PRINT_ADDR(cmd,
 						"ordered tag forced.\n");
@@ -4257,10 +4253,10 @@ static int ncr_queue_command (struct ncb
 			case 0x08:  /* READ_SMALL (6) */
 			case 0x28:  /* READ_BIG  (10) */
 			case 0xa8:  /* READ_HUGE (12) */
-				order = M_SIMPLE_TAG;
+				order = SIMPLE_QUEUE_TAG;
 				break;
 			default:
-				order = M_ORDERED_TAG;
+				order = ORDERED_QUEUE_TAG;
 			}
 		}
 		msgptr[msglen++] = order;
@@ -6229,9 +6225,9 @@ static int ncr_int_par (struct ncb *np)
 	if (!(dbc & 0xc0000000))
 		phase = (dbc >> 24) & 7;
 	if (phase == 7)
-		msg = M_PARITY;
+		msg = MSG_PARITY_ERROR;
 	else
-		msg = M_ID_ERROR;
+		msg = INITIATOR_ERROR;
 
 
 	/*
@@ -6795,6 +6791,8 @@ void ncr_int_sir (struct ncb *np)
 /*-----------------------------------------------------------------------------
 **
 **	Was Sie schon immer ueber transfermode negotiation wissen wollten ...
+**	("Everything you've always wanted to know about transfer mode
+**	  negotiation")
 **
 **	We try to negotiate sync and wide transfer only after
 **	a successful inquire command. We look at byte 7 of the
@@ -6896,8 +6894,8 @@ void ncr_int_sir (struct ncb *np)
 			break;
 
 		}
-		np->msgin [0] = M_NOOP;
-		np->msgout[0] = M_NOOP;
+		np->msgin [0] = NOP;
+		np->msgout[0] = NOP;
 		cp->nego_status = 0;
 		break;
 
@@ -6991,9 +6989,9 @@ void ncr_int_sir (struct ncb *np)
 		spi_offset(starget) = ofs;
 		ncr_setsync(np, cp, scntl3, (fak<<5)|ofs);
 
-		np->msgout[0] = M_EXTENDED;
+		np->msgout[0] = EXTENDED_MESSAGE;
 		np->msgout[1] = 3;
-		np->msgout[2] = M_X_SYNC_REQ;
+		np->msgout[2] = EXTENDED_SDTR;
 		np->msgout[3] = per;
 		np->msgout[4] = ofs;
 
@@ -7007,7 +7005,7 @@ void ncr_int_sir (struct ncb *np)
 			OUTL_DSP (NCB_SCRIPT_PHYS (np, msg_bad));
 			return;
 		}
-		np->msgin [0] = M_NOOP;
+		np->msgin [0] = NOP;
 
 		break;
 
@@ -7083,12 +7081,12 @@ void ncr_int_sir (struct ncb *np)
 		spi_width(starget) = wide;
 		ncr_setwide(np, cp, wide, 1);
 
-		np->msgout[0] = M_EXTENDED;
+		np->msgout[0] = EXTENDED_MESSAGE;
 		np->msgout[1] = 2;
-		np->msgout[2] = M_X_WIDE_REQ;
+		np->msgout[2] = EXTENDED_WDTR;
 		np->msgout[3] = wide;
 
-		np->msgin [0] = M_NOOP;
+		np->msgin [0] = NOP;
 
 		cp->nego_status = NS_WIDE;
 
@@ -7107,12 +7105,12 @@ void ncr_int_sir (struct ncb *np)
 	case SIR_REJECT_RECEIVED:
 		/*-----------------------------------------------
 		**
-		**	We received a M_REJECT message.
+		**	We received a MESSAGE_REJECT.
 		**
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd, "M_REJECT received (%x:%x).\n",
+		PRINT_ADDR(cp->cmd, "MESSAGE_REJECT received (%x:%x).\n",
 			(unsigned)scr_to_cpu(np->lastmsg), np->msgout[0]);
 		break;
 
@@ -7124,7 +7122,7 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		ncr_print_msg(cp, "M_REJECT sent for", np->msgin);
+		ncr_print_msg(cp, "MESSAGE_REJECT sent for", np->msgin);
 		break;
 
 /*--------------------------------------------------------------------
@@ -7143,7 +7141,7 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd, "M_IGN_RESIDUE received, but not yet "
+		PRINT_ADDR(cp->cmd, "IGNORE_WIDE_RESIDUE received, but not yet "
 				"implemented.\n");
 		break;
 #if 0
@@ -7156,7 +7154,7 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd, "M_DISCONNECT received, but datapointer "
+		PRINT_ADDR(cp->cmd, "DISCONNECT received, but datapointer "
 				"not saved: data=%x save=%x goal=%x.\n",
 			(unsigned) INL (nc_temp),
 			(unsigned) scr_to_cpu(np->header.savep),
@@ -7862,7 +7860,7 @@ static int __init ncr_snooptest (struct 
 **==========================================================
 **
 **	Note: we have to return the correct value.
-**	THERE IS NO SAVE DEFAULT VALUE.
+**	THERE IS NO SAFE DEFAULT VALUE.
 **
 **	Most NCR/SYMBIOS boards are delivered with a 40 Mhz clock.
 **	53C860 and 53C875 rev. 1 support fast20 transfers but 
@@ -8562,7 +8560,7 @@ struct Scsi_Host * __init ncr_attach(str
 
 	/* use SIMPLE TAG messages by default */
 #ifdef SCSI_NCR_ALWAYS_SIMPLE_TAG
-	np->order = M_SIMPLE_TAG;
+	np->order = SIMPLE_QUEUE_TAG;
 #endif
 
 	spin_unlock_irqrestore(&np->smp_lock, flags);
diff -urpNX dontdiff linus-2.6/drivers/scsi/ncr53c8xx.h parisc-2.6/drivers/scsi/ncr53c8xx.h
--- linus-2.6/drivers/scsi/ncr53c8xx.h	2006-02-12 20:55:18.000000000 -0700
+++ parisc-2.6/drivers/scsi/ncr53c8xx.h	2006-02-12 20:33:44.000000000 -0700
@@ -56,8 +56,10 @@
 #include <linux/config.h>
 #include <scsi/scsi_host.h>
 
+#include <linux/config.h>
+
 /*
-**	If you want a driver as small as possible, do not define the 
+**	If you want a driver as small as possible, donnot define the 
 **	following options.
 */
 #define SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT
@@ -1255,39 +1257,6 @@ struct scr_tblsel {
 */
 
 /*
-**	Messages
-*/
-
-#define	M_COMPLETE	COMMAND_COMPLETE
-#define	M_EXTENDED	EXTENDED_MESSAGE
-#define	M_SAVE_DP	SAVE_POINTERS
-#define	M_RESTORE_DP	RESTORE_POINTERS
-#define	M_DISCONNECT	DISCONNECT
-#define	M_ID_ERROR	INITIATOR_ERROR
-#define	M_ABORT		ABORT_TASK_SET
-#define	M_REJECT	MESSAGE_REJECT
-#define	M_NOOP		NOP
-#define	M_PARITY	MSG_PARITY_ERROR
-#define	M_LCOMPLETE	LINKED_CMD_COMPLETE
-#define	M_FCOMPLETE	LINKED_FLG_CMD_COMPLETE
-#define	M_RESET		TARGET_RESET
-#define	M_ABORT_TAG	ABORT_TASK
-#define	M_CLEAR_QUEUE	CLEAR_TASK_SET
-#define	M_INIT_REC	INITIATE_RECOVERY
-#define	M_REL_REC	RELEASE_RECOVERY
-#define	M_TERMINATE	(0x11)
-#define	M_SIMPLE_TAG	SIMPLE_QUEUE_TAG
-#define	M_HEAD_TAG	HEAD_OF_QUEUE_TAG
-#define	M_ORDERED_TAG	ORDERED_QUEUE_TAG
-#define	M_IGN_RESIDUE	IGNORE_WIDE_RESIDUE
-#define	M_IDENTIFY   	(0x80)
-
-#define	M_X_MODIFY_DP	EXTENDED_MODIFY_DATA_POINTER
-#define	M_X_SYNC_REQ	EXTENDED_SDTR
-#define	M_X_WIDE_REQ	EXTENDED_WDTR
-#define	M_X_PPR_REQ	EXTENDED_PPR
-
-/*
 **	Status
 */
 
