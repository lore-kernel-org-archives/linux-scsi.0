From: Edward Goggin <egoggin@vmware.com>
Subject: [PATCH 1/2] scsi: add DID_COND_REQUEUE SCSI ML host status
Date: Fri, 02 Feb 2007 17:05:11 -0500
Message-ID: <1170453912.14264.74.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:33062 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946114AbXBBWFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 17:05:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, eric.moore@lsi.com

From: Ed Goggin <egoggin@vmware.com>

Add new SCSI ML host status DID_COND_REQUEUE for ADD_TO_MLQUEUE
IFF not REQ_FAILFAST.

Signed-off-by: Ed Goggin <egoggin@vmware.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2dce06a..d8e884b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1222,6 +1222,16 @@ int scsi_decide_disposition(struct scsi_
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
 
+	case DID_COND_REQUEUE:
+		/*
+		 * Return immediately w/o requeue if the request 
+		 * indicates no retry.
+		 */
+		if (blk_noretry_request(scmd->request))
+			return SUCCESS;
+		else
+			return ADD_TO_MLQUEUE;
+
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c0e979..0207f81 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -309,6 +309,8 @@ struct scsi_lun {
 #define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count
*/
 #define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
 				 * without decrementing the retry count	   */
+#define DID_COND_REQUEUE 0x0e	/* Requeue cmd w/o decr of retry count
IFF
+				 * not blk_noretry_request		   */
 #define DRIVER_OK       0x00	/* Driver status
*/
 
 /*
