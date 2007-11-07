From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: don't flood syslog with negotiation messages
Date: Wed, 07 Nov 2007 15:58:52 -0500
Message-ID: <4732270C.9060103@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:3231 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXKGU6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 15:58:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

sym53c8xx prints a negotiation message after every check condition.
This can add up to a lot of messages for removable-medium devices
(CD-ROM, tape drives, etc.) that are being polled, since they return
check condition when no medium is present.  This patch suppresses the
negotiation message if it would be the same as the last one printed.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
diff -urpN linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-11-07 15:47:58.000000000 -0500
+++ linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-11-07 15:49:03.000000000 -0500
@@ -2040,6 +2040,29 @@ static void sym_settrans(struct sym_hcb 
 	}
 }
 
+static void sym_announce_transfer_rate(struct sym_tcb *tp)
+{
+	struct scsi_target *starget = tp->starget;
+
+	if (tp->tprint.period != spi_period(starget) ||
+	    tp->tprint.offset != spi_offset(starget) ||
+	    tp->tprint.width != spi_width(starget) ||
+	    tp->tprint.iu != spi_iu(starget) ||
+	    tp->tprint.dt != spi_dt(starget) ||
+	    tp->tprint.qas != spi_qas(starget) ||
+	    !tp->tprint.check_nego) {
+		tp->tprint.period = spi_period(starget);
+		tp->tprint.offset = spi_offset(starget);
+		tp->tprint.width = spi_width(starget);
+		tp->tprint.iu = spi_iu(starget);
+		tp->tprint.dt = spi_dt(starget);
+		tp->tprint.qas = spi_qas(starget);
+		tp->tprint.check_nego = 1;
+
+		spi_display_xfer_agreement(starget);
+	}
+}
+
 /*
  *  We received a WDTR.
  *  Let everything be aware of the changes.
@@ -2063,7 +2086,7 @@ static void sym_setwide(struct sym_hcb *
 	spi_qas(starget) = 0;
 
 	if (sym_verbose >= 3)
-		spi_display_xfer_agreement(starget);
+		sym_announce_transfer_rate(tp);
 }
 
 /*
@@ -2090,7 +2113,7 @@ sym_setsync(struct sym_hcb *np, int targ
 		tp->tgoal.check_nego = 0;
 	}
 
-	spi_display_xfer_agreement(starget);
+	sym_announce_transfer_rate(tp);
 }
 
 /*
@@ -2114,7 +2137,7 @@ sym_setpprot(struct sym_hcb *np, int tar
 	spi_qas(starget) = tp->tgoal.qas = !!(opts & PPR_OPT_QAS);
 	tp->tgoal.check_nego = 0;
 
-	spi_display_xfer_agreement(starget);
+	sym_announce_transfer_rate(tp);
 }
 
 /*
diff -urpN linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.h linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linux-2.6.24-rc2/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-11-07 15:47:58.000000000 -0500
+++ linux-2.6.24-rc2-sym2/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-11-07 15:49:03.000000000 -0500
@@ -419,6 +419,9 @@ struct sym_tcb {
 	/* Transfer goal */
 	struct sym_trans tgoal;
 
+	/* Last printed transfer speed */
+	struct sym_trans tprint;
+
 	/*
 	 * Keep track of the CCB used for the negotiation in order
 	 * to ensure that only 1 negotiation is queued at a time.


