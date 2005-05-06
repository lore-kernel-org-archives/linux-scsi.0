From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] correct the sym2 period setting routines
Date: Fri, 06 May 2005 13:14:48 -0500
Message-ID: <1115403288.4989.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60383 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261257AbVEFSOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2005 14:14:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a slight bug in the routines in that if the period requires dt,
then the routine will unconditionally set it.  DT may only be set if
Wide is also set, so this turns back on the wide bit.

For domain validation to work correctly, we need to observe the wide bit
absolutely.

James

--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2038,8 +2038,9 @@ static void sym2_set_period(struct scsi_
 	struct sym_hcb *np = sym_get_hcb(shost);
 	struct sym_tcb *tp = &np->target[starget->id];
 
-	/* have to have DT for these transfers */
-	if (period <= np->minsync)
+	/* have to have DT for these transfers, but DT will also
+	 * set width, so check that this is allowed */
+	if (period <= np->minsync && spi_width(starget))
 		tp->tgoal.dt = 1;
 
 	tp->tgoal.period = period;


