From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] buggy comment in scsi_decide_disposition
Date: Fri, 14 May 2004 01:44:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A45CCD.5040902@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020908050401000507000306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:485 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264300AbUENFo7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 01:44:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020908050401000507000306
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


AFAICS this comment is incorrect.  The switch target in question, 
DID_SOFT_ERROR, jumps to the maybe_retry label, which increments a retry 
counter.

This retry counter appears to avoid the endless loops that the comment 
refers to.

Although this patch only deletes a comment, please do review it with a 
careful eye.



--------------020908050401000507000306
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== drivers/scsi/scsi_error.c 1.74 vs edited =====
--- 1.74/drivers/scsi/scsi_error.c	Mon Apr 19 04:12:13 2004
+++ edited/drivers/scsi/scsi_error.c	Fri May 14 01:41:37 2004
@@ -1289,15 +1289,6 @@
 		 * that it indicates SUCCESS.
 		 */
 		return SUCCESS;
-		/*
-		 * when the low level driver returns did_soft_error,
-		 * it is responsible for keeping an internal retry counter 
-		 * in order to avoid endless loops (db)
-		 *
-		 * actually this is a bug in this function here.  we should
-		 * be mindful of the maximum number of retries specified
-		 * and not get stuck in a loop.
-		 */
 	case DID_SOFT_ERROR:
 		goto maybe_retry;
 	case DID_IMM_RETRY:

--------------020908050401000507000306--

