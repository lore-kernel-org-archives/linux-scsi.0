From: Swen Schillig <swen.schillig@freenet.de>
Subject: [PATCH] zfcp: use of uninitialized variable
Date: Fri, 9 Feb 2007 10:00:14 +0100
Message-ID: <200702091000.14270.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout0.freenet.de ([194.97.50.131]:49547 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946233AbXBII7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 03:59:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

commit 988d955c3314336d716a9208f3d565b06f262e07
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Fri Feb 9 09:40:11 2007 +0100

Use of uninitialized variable.
ERP action might not be finished accordingly.
    
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index c88babc..cbe47a2 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -841,29 +841,27 @@ zfcp_erp_action_exists(struct zfcp_erp_action *erp_action)
  *
  * returns:	0
  */
-static int
+static void
 zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
 {
-	int retval = 0;
-	struct zfcp_fsf_req *fsf_req = NULL;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	if (erp_action->fsf_req) {
 		/* take lock to ensure that request is not deleted meanwhile */
 		spin_lock(&adapter->req_list_lock);
-		if ((!zfcp_reqlist_ismember(adapter,
-					    erp_action->fsf_req->req_id)) &&
-		    (fsf_req->erp_action == erp_action)) {
+		if (zfcp_reqlist_ismember(adapter,
+					    erp_action->fsf_req->req_id)) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
-			debug_event(adapter->erp_dbf, 3, &fsf_req,
+			debug_event(adapter->erp_dbf, 3, &erp_action->fsf_req,
 				    sizeof (unsigned long));
 			/* dismiss fsf_req of timed out/dismissed erp_action */
 			if (erp_action->status & (ZFCP_STATUS_ERP_DISMISSED |
 						  ZFCP_STATUS_ERP_TIMEDOUT)) {
 				debug_text_event(adapter->erp_dbf, 3,
 						 "a_ca_disreq");
-				fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+				erp_action->fsf_req->status |= 
+					ZFCP_STATUS_FSFREQ_DISMISSED;
 			}
 			if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 				ZFCP_LOG_NORMAL("error: erp step timed out "
@@ -876,11 +874,11 @@ zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
 			 * then keep it running asynchronously and don't mess
 			 * with the association of erp_action and fsf_req.
 			 */
-			if (fsf_req->status & (ZFCP_STATUS_FSFREQ_COMPLETED |
+			if (erp_action->fsf_req->status & 
+					(ZFCP_STATUS_FSFREQ_COMPLETED |
 					       ZFCP_STATUS_FSFREQ_DISMISSED)) {
 				/* forget about association between fsf_req
 				   and erp_action */
-				fsf_req->erp_action = NULL;
 				erp_action->fsf_req = NULL;
 			}
 		} else {
@@ -894,8 +892,6 @@ zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
 		spin_unlock(&adapter->req_list_lock);
 	} else
 		debug_text_event(adapter->erp_dbf, 3, "a_ca_noreq");
-
-	return retval;
 }
 
 /**
