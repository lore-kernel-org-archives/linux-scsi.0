From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] correct sym2 error handling functions
Date: 21 Mar 2004 10:53:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079884395.1757.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54450 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263668AbUCUPxT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 10:53:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The sym2 driver has a nasty thinko in its error handling that looks to
have been present from day one.

The problem is that if it decides that the command it is requested to
handle isn't in its internal queues, it simply returns FAILED.  This
means that the eh will offline the device if we get into this state.

It's very easy to trip this, because a timed out command may complete
before the eh activates, and the driver would then not find the command
on the bus.

The rules are:

If requested to abort a command that's not present on the bus, you may
return SUCCESS (*not* FAILED), but devices must obey all other error
handler requests (device, bus and host reset) regardless of whether they
find the command or not.

James

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.44 vs edited =====
--- 1.44/drivers/scsi/sym53c8xx_2/sym_glue.c	Sat Mar 20 16:00:09 2004
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Mar 21 09:47:50 2004
@@ -924,7 +924,6 @@
 	switch(to_do) {
 	default:
 	case SYM_EH_DO_IGNORE:
-		goto finish;
 		break;
 	case SYM_EH_DO_WAIT:
 		init_MUTEX_LOCKED(&ep->sem);

