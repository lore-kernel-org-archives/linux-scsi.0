From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: [PATCH] scsi_error.c: DID_SOFT_ERROR comment clean up
Date: Mon, 30 Oct 2017 16:38:10 -0500
Message-ID: <1509399490.5866.3.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:58494 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdJ3ViS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Oct 2017 17:38:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Updated comment. We are keeping track of maximum number of retries per command via
retries/allowed in struct scsi_cmnd. Corrected comment positioning.

Signed-off-by: Petros Koutoupis <petros@petroskoutoupis.com>

diff -uNpr linux-4.14-rc7.orig/drivers/scsi/scsi_error.c linux-4.14-rc7/drivers/scsi/scsi_error.c
--- linux-4.14-rc7.orig/drivers/scsi/scsi_error.c	2017-10-30 10:02:11.089576057 -0500
+++ linux-4.14-rc7/drivers/scsi/scsi_error.c	2017-10-30 10:08:24.352182353 -0500
@@ -1747,16 +1747,12 @@ int scsi_decide_disposition(struct scsi_
 		 * that it indicates SUCCESS.
 		 */
 		return SUCCESS;
+	case DID_SOFT_ERROR:
 		/*
 		 * when the low level driver returns did_soft_error,
 		 * it is responsible for keeping an internal retry counter
 		 * in order to avoid endless loops (db)
-		 *
-		 * actually this is a bug in this function here.  we should
-		 * be mindful of the maximum number of retries specified
-		 * and not get stuck in a loop.
 		 */
-	case DID_SOFT_ERROR:
 		goto maybe_retry;
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
