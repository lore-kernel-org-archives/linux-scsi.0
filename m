From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix problem in sym2 auto request sense
Date: 21 Mar 2004 10:59:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079884753.2045.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:5555 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263669AbUCUP7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 10:59:18 -0500
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

sym2 currently returns DID_ERROR if its auto request sense fails for
some reason.  This is wrong because it leaves a contingent allegiance
condition on the device and it will ever after return BUSY to all
commands.

I tripped this in the somewhat artificial situation of two wide devices
connected over a narrow bus (the DATA phase of the request sense can
thus never complete successfully).

The solution is to kick the device very hard in this rare scenario.

James

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.44 vs edited =====
--- 1.44/drivers/scsi/sym53c8xx_2/sym_glue.c	Sat Mar 20 16:00:09 2004
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Mar 21 09:54:45 2004
@@ -384,6 +384,12 @@
 			}
 #endif
 		} else {
+			/* Error return from our internal request
+			 * sense.  This is bad: we must clear the
+			 * contingent allegiance condition otherwise
+			 * the device will always return BUSY.  Use a
+			 * big stick */
+			sym_reset_scsi_bus(np, 1);
 			cam_status = DID_ERROR;
 		}
 	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */



