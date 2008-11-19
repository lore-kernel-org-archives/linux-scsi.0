From: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Subject: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Wed, 19 Nov 2008 15:23:45 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811191436450.15796@fi-hi32-dhcp068123.emea.nsn-net.net>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
 <1219030321.3917.44.camel@localhost.localdomain>  <48A8F0D8.3030000@cs.wisc.edu>
 <1219068634.3261.6.camel@localhost.localdomain> <48A9BD74.7050706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48091 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYKSNYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Nov 2008 08:24:13 -0500
In-Reply-To: <48A9BD74.7050706@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, michaelc@cs.wisc.edu

I have reworked (simplified) the patch that was discussed couple months
back (http://marc.info/?l=linux-scsi&m=121900434020133&w=2). Again the
goal is to ensure that host/target transfer parameters do not go out of
sync (in the case the target is removed and added back either forcibly
or by using remove/add-single-device through /proc/scsi/scsi):

	- sym_prepare_nego() now always fills a message which is either
	  wide or ppr (the driver will do sync after wide when needed
	  as before).

	- it is called when the host changes parameters, or if the
	command is INQUIRY or REQUEST SENSE (including check cond case).

---

Change the sym53c8xx_2 driver negotiation logic so that the driver will
tolerate better device removals. Negotiation message(s) will be sent
with every INQUIRY and REQUEST SENSE command, and whenever there is a
change in goals or when the device reports check condition.

Signed-off-by: aaro.koskinen@nsn.com

---

diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-07 19:55:34.000000000 +0200
+++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-11-19 12:15:05.000000000 +0200
@@ -1413,7 +1413,7 @@ static void sym_check_goals(struct sym_h
 }
 
 /*
- *  Prepare the next negotiation message if needed.
+ *  Prepare the next negotiation message.
  *
  *  Fill in the part of message buffer that contains the 
  *  negotiation and the nego_status field of the CCB.
@@ -1433,24 +1433,14 @@ static int sym_prepare_nego(struct sym_h
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
@@ -1469,7 +1459,6 @@ static int sym_prepare_nego(struct sym_h
 		tp->nego_cp = cp; /* Keep track a nego will be performed */
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
 			sym_print_nego_msg(np, cp->target, 
-					  nego == NS_SYNC ? "sync msgout" :
 					  nego == NS_WIDE ? "wide msgout" :
 					  "ppr msgout", msgptr);
 		}
@@ -2049,11 +2038,9 @@ static void sym_setwide(struct sym_hcb *
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
@@ -2080,6 +2067,7 @@ sym_setsync(struct sym_hcb *np, int targ
 
 	sym_settrans(np, target, 0, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_WIDE; /* SYNC will follow WIDE. */
 	spi_period(starget) = per;
 	spi_offset(starget) = ofs;
 	spi_iu(starget) = spi_dt(starget) = spi_qas(starget) = 0;
@@ -2106,6 +2094,7 @@ sym_setpprot(struct sym_hcb *np, int tar
 
 	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
+	tp->tgoal.renego = NS_PPR;
 	spi_width(starget) = tp->tgoal.width = wide;
 	spi_period(starget) = tp->tgoal.period = per;
 	spi_offset(starget) = tp->tgoal.offset = ofs;
@@ -5135,9 +5124,14 @@ int sym_queue_scsiio(struct sym_hcb *np,
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
 
diff -uprN -X linux-2.6.27.5-orig/Documentation/dontdiff linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.h linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linux-2.6.27.5-orig/drivers/scsi/sym53c8xx_2/sym_hipd.h	2008-11-07 19:55:34.000000000 +0200
+++ linux-2.6.27.5/drivers/scsi/sym53c8xx_2/sym_hipd.h	2008-11-19 12:14:46.000000000 +0200
@@ -354,6 +354,7 @@ struct sym_trans {
 	unsigned int dt:1;
 	unsigned int qas:1;
 	unsigned int check_nego:1;
+	unsigned int renego:2;
 };
 
 /*
