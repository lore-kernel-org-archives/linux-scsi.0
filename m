From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/11] zfcp: Remove unnecessary warning message
Date: Fri, 19 Dec 2008 16:57:02 +0100
Message-ID: <20081219155757.776228000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61216 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYLSP6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:58:03 -0500
Content-Disposition: inline; filename=remove-message.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove a message that was emitted for a port that could not initially
be opened. This is a rare case when the port discovery hits an
initiator port and only confuses the user with an initator port logged
in the message. Remove the whole special case: The failed "open port"
request triggers required follow-up actions anyway.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:33:56.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:34:09.000000000 +0100
@@ -519,7 +519,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[29]	= "link down",
 	[30]	= "link up status read",
 	[31]	= "open port failed",
-	[32]	= "open port failed",
+	[32]	= "",
 	[33]	= "close port",
 	[34]	= "open unit failed",
 	[35]	= "exclusive open unit failed",
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:33:56.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:34:09.000000000 +0100
@@ -1420,13 +1420,7 @@ static void zfcp_fsf_open_port_handler(s
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
-			dev_warn(&req->adapter->ccw_device->dev,
-				 "Remote port 0x%016Lx could not be opened\n",
-				 (unsigned long long)port->wwpn);
-			zfcp_erp_port_failed(port, 32, req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}

-- 
