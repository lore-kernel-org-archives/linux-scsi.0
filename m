From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add DID_REQUEUE to the error handling
Date: Tue, 12 Apr 2005 10:17:36 -0500
Message-ID: <1113319056.5774.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56963 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262475AbVDLPRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 11:17:38 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j3CFHbA28195
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 11:17:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

We have a DID_IMM_RETRY to require a retry at once, but we could do with
a DID_REQUEUE to instruct the mid-layer to treat this command in the
same manner as QUEUE_FULL or BUSY (i.e. halt the submission until
another command returns ... or the queue pressure builds if there are no
outstanding commands).

James

===== drivers/scsi/scsi_error.c 1.91 vs edited =====
--- 1.91/drivers/scsi/scsi_error.c	2005-03-31 03:06:21 -06:00
+++ edited/drivers/scsi/scsi_error.c	2005-04-12 10:04:51 -05:00
@@ -1306,6 +1306,9 @@
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
 
+	case DID_REQUEUE:
+		return ADD_TO_MLQUEUE;
+
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
===== include/scsi/scsi.h 1.28 vs edited =====
--- 1.28/include/scsi/scsi.h	2005-03-29 09:53:44 -06:00
+++ edited/include/scsi/scsi.h	2005-04-12 10:02:47 -05:00
@@ -295,6 +295,8 @@
 #define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
 #define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
 #define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
+#define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
+				 * without decrementing the retry count	   */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*


