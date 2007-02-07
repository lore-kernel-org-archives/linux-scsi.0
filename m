From: Swen Schillig <swen.schillig@freenet.de>
Subject: [PATCH] zfcp: Invalid locking order
Date: Wed, 7 Feb 2007 13:17:57 +0100
Message-ID: <200702071317.58026.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout0.freenet.de ([194.97.50.131]:55794 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161292AbXBGM47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 07:56:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

From: Swen Schillig <swen@vnet.ibm.com>

Invalid locking order. Kernel hangs after trying to take two locks
which are dependend on each other. Introducing temporary variable
to free requests. Free lock after requests are copied.
    
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/s390/scsi/zfcp_ext.h
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_ext.h
+++ linux-2.6/drivers/s390/scsi/zfcp_ext.h
@@ -89,7 +89,7 @@ extern int  zfcp_fsf_control_file(struct
 				  u32, u32, struct zfcp_sg_list *);
 extern void zfcp_fsf_start_timer(struct zfcp_fsf_req *, unsigned long);
 extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
-extern int  zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
+extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int  zfcp_fsf_status_read(struct zfcp_adapter *, int);
 extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
 			       unsigned long *, struct zfcp_fsf_req **);
Index: linux-2.6/drivers/s390/scsi/zfcp_fsf.c
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_fsf.c
+++ linux-2.6/drivers/s390/scsi/zfcp_fsf.c
@@ -176,28 +176,25 @@ static void zfcp_fsf_req_dismiss(struct 
 /**
  * zfcp_fsf_req_dismiss_all - dismiss all remaining fsf requests
  */
-int zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
+void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_req *request, *tmp;
 	unsigned long flags;
+	LIST_HEAD(remove_queue);
 	unsigned int i, counter;
 
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	atomic_set(&adapter->reqs_active, 0);
-	for (i=0; i<REQUEST_LIST_SIZE; i++) {
-		if (list_empty(&adapter->req_list[i]))
-			continue;
-
-		counter = 0;
-		list_for_each_entry_safe(request, tmp,
-					 &adapter->req_list[i], list) {
-			zfcp_fsf_req_dismiss(adapter, request, counter);
-			counter++;
-		}
-	}
+	for (i=0; i<REQUEST_LIST_SIZE; i++)
+		list_splice_init(&adapter->req_list[i], &remove_queue);
+
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	return 0;
+	counter = 0;
+	list_for_each_entry_safe(request, tmp, &remove_queue, list) {
+		zfcp_fsf_req_dismiss(adapter, request, counter);
+		counter++;
+	}
 }
 
 /*
