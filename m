From: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Subject: Re: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Tue, 16 Dec 2008 19:15:42 +0200
Message-ID: <1229447742-17995-1-git-send-email-Aaro.Koskinen@nokia.com>
References: <Pine.LNX.4.64.0811191436450.15796@fi-hi32-dhcp068123.emea.nsn-net.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50591 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYLPRQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 12:16:27 -0500
In-Reply-To: <Pine.LNX.4.64.0811191436450.15796@fi-hi32-dhcp068123.emea.nsn-net.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

(Resent with proper formatting.)

Change the sym53c8xx_2 driver negotiation logic so that the driver will
tolerate better device removals. Negotiation message(s) will be sent
with every INQUIRY and REQUEST SENSE command, and whenever there is a
change in goals or when the device reports check condition.

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   32 +++++++++++++-------------------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    1 +
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 98df165..2f25b89 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1413,7 +1413,7 @@ static void sym_check_goals(struct sym_hcb *np, struct scsi_target *starget,
 }
 
 /*
- *  Prepare the next negotiation message if needed.
+ *  Prepare the next negotiation message.
  *
  *  Fill in the part of message buffer that contains the 
  *  negotiation and the nego_status field of the CCB.
@@ -1433,24 +1433,14 @@ static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgp
 	 * Many devices implement PPR in a buggy way, so only use it if we
 	 * really want to.
 	 */
-	if (goal->offset &&
-	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa))) {
+	if (goal->renego == NS_PPR || (goal->offset &&
+	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa)))) {
 		nego = NS_PPR;
-	} else if (spi_width(starget) != goal->width) {
-		nego = NS_WIDE;
-	} else if (spi_period(starget) != goal->period ||
-		   spi_offset(starget) != goal->offset) {
-		nego = NS_SYNC;
 	} else {
-		goal->check_nego = 0;
-		nego = 0;
+		nego = NS_WIDE; /* SYNC will follow WIDE if needed. */
 	}
 
 	switch (nego) {
-	case NS_SYNC:
-		msglen += spi_populate_sync_msg(msgptr + msglen, goal->period,
-				goal->offset);
-		break;
 	case NS_WIDE:
 		msglen += spi_populate_width_msg(msgptr + msglen, goal->width);
 		break;
@@ -1469,7 +1459,6 @@ static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgp
 		tp->nego_cp = cp; /* Keep track a nego will be performed */
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
 			sym_print_nego_msg(np, cp->target, 
-					  nego == NS_SYNC ? "sync msgout" :
 					  nego == NS_WIDE ? "wide msgout" :
 					  "ppr msgout", msgptr);
 		}
@@ -2049,11 +2038,9 @@ static void sym_setwide(struct sym_hcb *np, int target, u_char wide)
 	struct sym_tcb *tp = &np->target[target];
 	struct scsi_target *starget = tp->starget;
 
-	if (spi_width(starget) == wide)
-		return;
-
 	sym_settrans(np, target, 0, 0, 0, wide, 0, 0);
 
+	tp->tgoal.renego = NS_WIDE;
 	tp->tgoal.width = wide;
 	spi_offset(starget) = 0;
 	spi_period(starget) = 0;
@@ -2080,6 +2067,7 @@ sym_setsync(struct sym_hcb *np, int target,
 
 	sym_settrans(np, target, 0, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_WIDE; /* SYNC will follow WIDE. */
 	spi_period(starget) = per;
 	spi_offset(starget) = ofs;
 	spi_iu(starget) = spi_dt(starget) = spi_qas(starget) = 0;
@@ -2106,6 +2094,7 @@ sym_setpprot(struct sym_hcb *np, int target, u_char opts, u_char ofs,
 
 	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_PPR;
 	spi_width(starget) = tp->tgoal.width = wide;
 	spi_period(starget) = tp->tgoal.period = per;
 	spi_offset(starget) = tp->tgoal.offset = ofs;
@@ -5135,9 +5124,14 @@ int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *
 	/*
 	 *  Build a negotiation message if needed.
 	 *  (nego_status is filled by sym_prepare_nego())
+	 *
+	 *  Always negotiate on INQUIRY and REQUEST SENSE.
+	 *
 	 */
 	cp->nego_status = 0;
-	if (tp->tgoal.check_nego && !tp->nego_cp && lp) {
+	if ((tp->tgoal.check_nego ||
+	     cmd->cmnd[0] == INQUIRY || cmd->cmnd[0] == REQUEST_SENSE) &&
+	    !tp->nego_cp && lp) {
 		msglen += sym_prepare_nego(np, cp, msgptr + msglen);
 	}
 
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
1.5.4.3

