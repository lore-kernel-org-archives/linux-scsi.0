From: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Subject: Re: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Thu, 15 Jan 2009 17:13:36 +0200
Message-ID: <1232032416-21743-1-git-send-email-Aaro.Koskinen@nokia.com>
References: <4964ABFD.9000807@nokia.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41969 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZAOPOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 10:14:14 -0500
In-Reply-To: <4964ABFD.9000807@nokia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

(The patch updated based on testing and comments from Tony Battersby.)

Change the sym53c8xx_2 driver negotiation logic so that the driver will
tolerate better device removals. Negotiation message(s) will be sent
with every INQUIRY and REQUEST SENSE command, and whenever there is a
change in goals or when the device reports check condition.

The patch was made specifically to address the case where you hotswap
the disk using remove-single-device/add-single-device commands through
/proc/scsi/scsi. Without the patch the driver keeps using old transfer
parameters even though the target is reset and reports check condition,
so the data transfer of the very first INQUIRY will fail.

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   35 ++++++++++++++++++++++++++---------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    1 +
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 98df165..fe6359d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1433,13 +1433,12 @@ static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgp
 	 * Many devices implement PPR in a buggy way, so only use it if we
 	 * really want to.
 	 */
-	if (goal->offset &&
-	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa))) {
+	if (goal->renego == NS_PPR || (goal->offset &&
+	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa)))) {
 		nego = NS_PPR;
-	} else if (spi_width(starget) != goal->width) {
+	} else if (goal->renego == NS_WIDE || goal->width) {
 		nego = NS_WIDE;
-	} else if (spi_period(starget) != goal->period ||
-		   spi_offset(starget) != goal->offset) {
+	} else if (goal->renego == NS_SYNC || goal->offset) {
 		nego = NS_SYNC;
 	} else {
 		goal->check_nego = 0;
@@ -2049,11 +2048,13 @@ static void sym_setwide(struct sym_hcb *np, int target, u_char wide)
 	struct sym_tcb *tp = &np->target[target];
 	struct scsi_target *starget = tp->starget;
 
-	if (spi_width(starget) == wide)
-		return;
-
 	sym_settrans(np, target, 0, 0, 0, wide, 0, 0);
 
+	if (wide)
+		tp->tgoal.renego = NS_WIDE;
+	else
+		tp->tgoal.renego = 0;
+	tp->tgoal.check_nego = 0;
 	tp->tgoal.width = wide;
 	spi_offset(starget) = 0;
 	spi_period(starget) = 0;
@@ -2080,6 +2081,12 @@ sym_setsync(struct sym_hcb *np, int target,
 
 	sym_settrans(np, target, 0, ofs, per, wide, div, fak);
 
+	if (wide)
+		tp->tgoal.renego = NS_WIDE;
+	else if (ofs)
+		tp->tgoal.renego = NS_SYNC;
+	else
+		tp->tgoal.renego = 0;
 	spi_period(starget) = per;
 	spi_offset(starget) = ofs;
 	spi_iu(starget) = spi_dt(starget) = spi_qas(starget) = 0;
@@ -2106,6 +2113,10 @@ sym_setpprot(struct sym_hcb *np, int target, u_char opts, u_char ofs,
 
 	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
+	if (wide || ofs)
+		tp->tgoal.renego = NS_PPR;
+	else
+		tp->tgoal.renego = 0;
 	spi_width(starget) = tp->tgoal.width = wide;
 	spi_period(starget) = tp->tgoal.period = per;
 	spi_offset(starget) = tp->tgoal.offset = ofs;
@@ -3516,6 +3527,7 @@ static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 			spi_dt(starget) = 0;
 			spi_qas(starget) = 0;
 			tp->tgoal.check_nego = 1;
+			tp->tgoal.renego = 0;
 		}
 
 		/*
@@ -5135,9 +5147,14 @@ int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *
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

