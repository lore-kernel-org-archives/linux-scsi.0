From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Sun, 17 Aug 2008 15:18:40 -0500
Message-ID: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35980 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYHQUSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:18:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Aaro Koskinen <aaro.koskinen@nsn.com>, Matthew Wilcox <matthew@wil.cx>

From: Mike Christie <michaelc@cs.wisc.edu>

The patch and description is from Aaro Koskinen. He sent us the
patch against our fedora kernel, but he is short on time and did not have
time to send it upstream, so I am sending it for him so it does not sit in
just our trees.

This patch applies to scsi-fc-fixes.

>From Aaro Koskinen:

Principles for SCSI negotiation:

If the driver and a target have a different idea of the transfer
parameters, all data transfers will fail. Usually either the driver or the
target will hang during the data phase, or commands are being rejected due
to extraneous data etc.

(a) To prevent this, targets report check condition/unit attention before
any data transfer whenever there has been a device reset (only way to
invalidate all negotiations). So, this can be used to trigger
renegotiation.

(b) An exception to above, INQUIRY and REQUEST SENSE commands are always
executed immediately by targets, so with these commands the driver can
never be sure what the negotiation values are, so there must be a
renegotiation before sending the command.

Couple notes about the patch:

- It seems there is a bug in the current driver (in the beforementioned
kernels), the sym_sir_bad_scsi_status()/S_CHECK_COND branch is actually
NOT starting a new negotiation, although it definitely should. The patch
fixes that.

- The patch deletes code from sym_sir_task_recovery()/M_RESET branch. It's
unnecessary to reset negotiation status there, since any reset eventually
triggers S_CHECK_COND.

- It seems that the SPI "domain validation" consists solely of INQUIRY
commands. As a result, if (b) is followed, targets that support PPR would
never get to the point of doing PPR transfers during domain validation
(but immediately after on the next command following the dv), since each
INQUIRY re-starts the negotiation cycle. This patch solves this by making
it possible to do the negotiation cycle WIDE -> SYNC -> PPR during a
single SCSI command.

Test cases that I executed:

1. remove/add-single-device (through /proc/scsi) without physical disk
removal: OK
2. remove/add-single-device with physical disk removal & insertion: OK
3. same as (2) but add-single-device was done before the disk was ready:
this usually succeeds with "spinning disk up" msg, however, if I give the
command too early just before the hot swap led turns green I sometimes get
a selection timeout - if I then do a manual retry (another
add-single-device) it always succeeds. I'm not sure why scsi_scan.c stops
after a failure without any automatic retries but I think this behaviour
is not related to this patch.
4. rip the disk off without telling Linux, and then put it back and do
remove/add-single-device: OK

Used HW (disks & controller):

Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: FUJITSU  Model: MAW3073NP        Rev: 4701
  Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: FUJITSU  Model: MAW3073NP        Rev: 4701
  Type:   Direct-Access                    ANSI  SCSI revision: 03

03:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz
Ultra3 SCSI Adapter (rev 01)
03:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz
Ultra3 SCSI Adapter (rev 01)

sym0: <1010-66> rev 0x1 at pci 0000:03:01.0 irq 50
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: <1010-66> rev 0x1 at pci 0000:03:01.1 irq 50
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthew Wilcox <matthew@wil.cx>

---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   66 ++++++++++++++++++++++++----------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    1 +
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 98df165..41ae184 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1419,7 +1419,8 @@ static void sym_check_goals(struct sym_hcb *np, struct scsi_target *starget,
  *  negotiation and the nego_status field of the CCB.
  *  Returns the size of the message in bytes.
  */
-static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgptr)
+static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp,
+			    u_char *msgptr, int renego)
 {
 	struct sym_tcb *tp = &np->target[cp->target];
 	struct scsi_target *starget = tp->starget;
@@ -1433,7 +1434,9 @@ static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgp
 	 * Many devices implement PPR in a buggy way, so only use it if we
 	 * really want to.
 	 */
-	if (goal->offset &&
+	if (renego && goal->renego) {
+		nego = goal->renego;
+	} else if (goal->offset &&
 	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa))) {
 		nego = NS_PPR;
 	} else if (spi_width(starget) != goal->width) {
@@ -2054,6 +2057,7 @@ static void sym_setwide(struct sym_hcb *np, int target, u_char wide)
 
 	sym_settrans(np, target, 0, 0, 0, wide, 0, 0);
 
+	tp->tgoal.renego = NS_WIDE;
 	tp->tgoal.width = wide;
 	spi_offset(starget) = 0;
 	spi_period(starget) = 0;
@@ -2080,6 +2084,7 @@ sym_setsync(struct sym_hcb *np, int target,
 
 	sym_settrans(np, target, 0, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_WIDE; /* SYNC will follow WIDE. */
 	spi_period(starget) = per;
 	spi_offset(starget) = ofs;
 	spi_iu(starget) = spi_dt(starget) = spi_qas(starget) = 0;
@@ -2106,6 +2111,7 @@ sym_setpprot(struct sym_hcb *np, int target, u_char opts, u_char ofs,
 
 	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_PPR;
 	spi_width(starget) = tp->tgoal.width = wide;
 	spi_period(starget) = tp->tgoal.period = per;
 	spi_offset(starget) = tp->tgoal.offset = ofs;
@@ -3074,7 +3080,7 @@ static void sym_sir_bad_scsi_status(struct sym_hcb *np, int num, struct sym_ccb
 		 *  cp->nego_status is filled by sym_prepare_nego().
 		 */
 		cp->nego_status = 0;
-		msglen += sym_prepare_nego(np, cp, &cp->scsi_smsg2[msglen]);
+		msglen += sym_prepare_nego(np, cp, &cp->scsi_smsg2[msglen], 1);
 		/*
 		 *  Message table indirect structure.
 		 */
@@ -3498,24 +3504,12 @@ static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 		/*
 		 *  If we sent a M_RESET, then a hardware reset has 
 		 *  been performed by the target.
-		 *  - Reset everything to async 8 bit
-		 *  - Tell ourself to negotiate next time :-)
 		 *  - Prepare to clear all disconnected CCBs for 
 		 *    this target from our task list (lun=task=-1)
 		 */
-		lun = -1;
 		task = -1;
 		if (np->abrt_msg[0] == M_RESET) {
-			tp->head.sval = 0;
-			tp->head.wval = np->rv_scntl3;
-			tp->head.uval = 0;
-			spi_period(starget) = 0;
-			spi_offset(starget) = 0;
-			spi_width(starget) = 0;
-			spi_iu(starget) = 0;
-			spi_dt(starget) = 0;
-			spi_qas(starget) = 0;
-			tp->tgoal.check_nego = 1;
+			lun = -1;
 		}
 
 		/*
@@ -4011,9 +4005,31 @@ static void sym_sync_nego(struct sym_hcb *np, struct sym_tcb *tp, struct sym_ccb
 	if (req) {	/* Was a request, send response. */
 		cp->nego_status = NS_SYNC;
 		OUTL_DSP(np, SCRIPTB_BA(np, sdtr_resp));
+	} else {	/* Was a response. */
+		/*
+		 * Negotiate for PPR immediately after SYNC response.
+		 */
+		if (tp->tgoal.offset &&
+		    (tp->tgoal.iu || tp->tgoal.dt || tp->tgoal.qas ||
+		     (tp->tgoal.period < 0xa))) {
+			spi_populate_ppr_msg(np->msgout, tp->tgoal.period,
+					     tp->tgoal.offset, tp->tgoal.width,
+					     (tp->tgoal.iu ? PPR_OPT_IU : 0) |
+					     (tp->tgoal.dt ? PPR_OPT_DT : 0) |
+					    (tp->tgoal.qas ? PPR_OPT_QAS : 0));
+
+			if (DEBUG_FLAGS & DEBUG_NEGO) {
+				sym_print_nego_msg(np, cp->target,
+				                   "ppr msgout", np->msgout);
+			}
+
+			cp->nego_status = NS_PPR;
+			OUTB(np, HS_PRT, HS_NEGOTIATE);
+			OUTL_DSP(np, SCRIPTB_BA(np, ppr_resp));
+			return;
+		} else
+			OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 	}
-	else		/* Was a response, we are done. */
-		OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 	return;
 
 reject_it:
@@ -5137,8 +5153,18 @@ int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *
 	 *  (nego_status is filled by sym_prepare_nego())
 	 */
 	cp->nego_status = 0;
-	if (tp->tgoal.check_nego && !tp->nego_cp && lp) {
-		msglen += sym_prepare_nego(np, cp, msgptr + msglen);
+	if (!tp->nego_cp && lp) {
+		int renego;
+
+		/*
+		 * Always renegotiate on INQUIRY and REQUEST SENSE.
+		 */
+		renego = (cmd->cmnd[0] == INQUIRY ||
+			  cmd->cmnd[0] == REQUEST_SENSE);
+		if (tp->tgoal.check_nego || renego) {
+			msglen += sym_prepare_nego(np, cp, msgptr + msglen,
+						   renego);
+		}
 	}
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index ad07880..233a3d0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -354,6 +354,7 @@ struct sym_trans {
 	unsigned int dt:1;
 	unsigned int qas:1;
 	unsigned int check_nego:1;
+	unsigned int renego:2;
 };
 
 /*
-- 
1.5.4.1

