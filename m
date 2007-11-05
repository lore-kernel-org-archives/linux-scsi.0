From: swen@vnet.ibm.com
Subject: [patch 6/6] zfcp: Reduce flood on hba trace
Date: Mon, 05 Nov 2007 12:37:48 +0100
Message-ID: <20071105114628.408904000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:2918 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbXKELrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 06:47:20 -0500
Content-Disposition: inline; filename=806-zfcp-trace.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove tracing for request with a "qualifier" field set in the
response.  The protocol status qualifier now contains measurement
data for "good" commands, so this check would trace every response
by default.

The fix is to simply remove the "qual" tracing: The responses with an
interesting status are also traced as "ferr" or "perr" and all
responses can be traced as "norm" with a higher trace level.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    6 ------
 1 file changed, 6 deletions(-)

Index: scsi-misc/drivers/s390/scsi/zfcp_dbf.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_dbf.c
+++ scsi-misc/drivers/s390/scsi/zfcp_dbf.c
@@ -161,12 +161,6 @@ void zfcp_hba_dbf_event_fsf_response(str
 		   (fsf_req->fsf_command == FSF_QTCB_OPEN_LUN)) {
 		strncpy(rec->tag2, "open", ZFCP_DBF_TAG_SIZE);
 		level = 4;
-	} else if ((prot_status_qual->doubleword[0] != 0) ||
-		   (prot_status_qual->doubleword[1] != 0) ||
-		   (fsf_status_qual->doubleword[0] != 0) ||
-		   (fsf_status_qual->doubleword[1] != 0)) {
-		strncpy(rec->tag2, "qual", ZFCP_DBF_TAG_SIZE);
-		level = 3;
 	} else {
 		strncpy(rec->tag2, "norm", ZFCP_DBF_TAG_SIZE);
 		level = 6;

-- 
