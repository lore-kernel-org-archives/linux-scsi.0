From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/6] zfcp: fix use after free bug.
Date: Thu, 20 Dec 2007 12:30:22 +0100
Message-ID: <20071220113231.840700000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58181 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbXLTLce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:34 -0500
Content-Disposition: inline; filename=807-zfcp-kfree.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

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
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |   14 ++++++++++++++
 drivers/s390/scsi/zfcp_erp.c |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_def.h	2007-12-20 11:15:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2007-12-20 11:17:46.000000000 +0100
@@ -1123,6 +1123,20 @@ zfcp_reqlist_find(struct zfcp_adapter *a
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
--- a/drivers/s390/scsi/zfcp_erp.c	2007-12-20 11:15:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2007-12-20 11:17:46.000000000 +0100
@@ -846,7 +846,8 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 	if (erp_action->fsf_req) {
 		/* take lock to ensure that request is not deleted meanwhile */
 		spin_lock(&adapter->req_list_lock);
-		if (zfcp_reqlist_find(adapter, erp_action->fsf_req->req_id)) {
+		if (zfcp_reqlist_find_safe(adapter, erp_action->fsf_req) &&
+		    erp_action->fsf_req->erp_action == erp_action) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
 			debug_event(adapter->erp_dbf, 3, &erp_action->fsf_req,

-- 
