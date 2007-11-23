From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH] zfcp: fix use after free bug
Date: Fri, 23 Nov 2007 15:04:02 +0100
Message-ID: <200711231504.03315.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:2467 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXKWOEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Nov 2007 09:04:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

zfcp_erp_strategy_check_fsfreq() checks if it is safe to access the
fsf_req associated with the erp_action that gets passed. To test if
it is safe it accesses the fsf_req in order to get its index into
the hash list. This is broken since the fsf_req might be freed already
and the read index has no meaning. It could lead to memory corruption.
Fix this by introducing a new zfcp_reqlist_find_safe() method which
just checks if addresses are equal. This is slower, but only gets
called in case of error recovery.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |   14 ++++++++++++++
 drivers/s390/scsi/zfcp_erp.c |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

Index: SHIP_OCT2005/drivers/s390/scsi/zfcp_def.h
===================================================================
--- SHIP_OCT2005.orig/drivers/s390/scsi/zfcp_def.h
+++ SHIP_OCT2005/drivers/s390/scsi/zfcp_def.h
@@ -1210,6 +1210,20 @@ zfcp_reqlist_find(struct zfcp_adapter *a
 	return NULL;
 }
 
+static inline struct zfcp_fsf_req *
+zfcp_reqlist_find_safe(struct zfcp_adapter *adapter, struct zfcp_fsf_req *req)
+{
+	struct zfcp_fsf_req *request;
+	unsigned int idx;
+
+	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++) {
+		list_for_each_entry(request, &adapter->req_list[idx], list)
+			if (request == req)
+				return request;
+	}
+	return NULL;
+}
+
 /*
  *  functions needed for reference/usage counting
  */
Index: SHIP_OCT2005/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- SHIP_OCT2005.orig/drivers/s390/scsi/zfcp_erp.c
+++ SHIP_OCT2005/drivers/s390/scsi/zfcp_erp.c
@@ -837,7 +837,8 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 	if (erp_action->fsf_req) {
 		/* take lock to ensure that request is not deleted meanwhile */
 		spin_lock(&adapter->req_list_lock);
-		if (zfcp_reqlist_find(adapter, erp_action->fsf_req->req_id)) {
+		if (zfcp_reqlist_find_safe(adapter, erp_action->fsf_req) &&
+		    erp_action->fsf_req->erp_action == erp_action) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
  			debug_event(adapter->erp_dbf, 3, &erp_action->fsf_req,
