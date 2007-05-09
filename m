From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 1/2] zfcp: avoid clutter in erp_dbf
Date: Wed, 9 May 2007 11:01:20 +0200
Message-ID: <200705091101.20870.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:55487 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbXEII6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 04:58:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, mp3@de.ibm.com

>From Martin Peschke <mp3@de.ibm.com>

avoid clutter in erp_dbf

cleanup zfcp_fsf_req_dismiss functions:
- avoid clutter in erp_dbf (reqs_active is always 0)
- fold called three-line function into calling function
- add meaningful comment
- coding style

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---
 drivers/s390/scsi/zfcp_fsf.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)


--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_fsf.c	2007-05-08 14:47:17.000000000 +0200
+++ linux_jb_patched/drivers/s390/scsi/zfcp_fsf.c	2007-05-08 14:48:08.000000000 +0200
@@ -156,44 +156,30 @@ zfcp_fsf_req_free(struct zfcp_fsf_req *f
 	kfree(fsf_req);
 }
 
-/**
- * zfcp_fsf_req_dismiss - dismiss a single fsf request
- */
-static void zfcp_fsf_req_dismiss(struct zfcp_adapter *adapter,
-				 struct zfcp_fsf_req *fsf_req,
-				 unsigned int counter)
-{
-	u64 dbg_tmp[2];
-
-	dbg_tmp[0] = (u64) atomic_read(&adapter->reqs_active);
-	dbg_tmp[1] = (u64) counter;
-	debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
-	list_del(&fsf_req->list);
-	fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-	zfcp_fsf_req_complete(fsf_req);
-}
-
-/**
- * zfcp_fsf_req_dismiss_all - dismiss all remaining fsf requests
+/*
+ * Never ever call this without shutting down the adapter first.
+ * Otherwise the adapter would continue using and corrupting s390 storage.
+ * Included BUG_ON() call to ensure this is done.
+ * ERP is supposed to be the only user of this function.
  */
 void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
-	struct zfcp_fsf_req *request, *tmp;
+	struct zfcp_fsf_req *fsf_req, *tmp;
 	unsigned long flags;
 	LIST_HEAD(remove_queue);
-	unsigned int i, counter;
+	unsigned int i;
 
+	BUG_ON(atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status));
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	atomic_set(&adapter->reqs_active, 0);
-	for (i=0; i<REQUEST_LIST_SIZE; i++)
+	for (i = 0; i < REQUEST_LIST_SIZE; i++)
 		list_splice_init(&adapter->req_list[i], &remove_queue);
-
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	counter = 0;
-	list_for_each_entry_safe(request, tmp, &remove_queue, list) {
-		zfcp_fsf_req_dismiss(adapter, request, counter);
-		counter++;
+	list_for_each_entry_safe(fsf_req, tmp, &remove_queue, list) {
+		list_del(&fsf_req->list);
+		fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+		zfcp_fsf_req_complete(fsf_req);
 	}
 }
 
