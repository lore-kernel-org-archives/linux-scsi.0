From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix for Domain Validation hang on some devices with sym_2
	driver
Date: 19 Aug 2004 22:55:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092970559.1728.2520.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61928 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266124AbUHTCz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 22:55:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a bad hang where the driver locks the system solid trying to do
domain validation with certain devices.  The one I've managed to
reproduce it with is a Quantum Atlas.

What happens is that setting the offset to zero is an async negotiation
message.  However, the driver still seems to have DT set (which is
illegal).  Most devices just reject this as stupid, but the Quantum
seems to try to obey it and hangs the bus.

The simple fix is to reset all PPR options when the offset is set to
zero.

James

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.44 vs edited =====
--- 1.44/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-07-26 17:24:36 -04:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-19 22:30:35 -04:00
@@ -2383,6 +2383,9 @@
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
+	if (offset == 0)
+		tp->tinfo.goal.options = 0;
+
 	if (tp->tinfo.curr.options & PPR_OPT_DT) {
 		if (offset > np->maxoffs_dt)
 			offset = np->maxoffs_dt;

