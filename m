From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/8] zfcp: Fix request list handling in error path
Date: Tue, 04 Nov 2008 16:35:08 +0100
Message-ID: <20081104153628.245547000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62725 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYKDPgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:31 -0500
Content-Disposition: inline; filename=fsf-error.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Fix the handling of the request list in the error path:
 - Use irqsave for the lock as in the good path.
 - Before removing the request, check if it is still in the list, a
   call to dismiss_all might have changed the list in between.
 - zfcp_qdio_send does not change the queue counters on failure,
   trying revert something is wrong, so remove this.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:19.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:22.000000000 +0100
@@ -770,7 +770,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 	unsigned long flags;
 	int idx;
 
@@ -780,19 +779,15 @@ static int zfcp_fsf_req_send(struct zfcp
 	list_add_tail(&req->list, &adapter->req_list[idx]);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	req->qdio_outb_usage = atomic_read(&req_q->count);
+	req->qdio_outb_usage = atomic_read(&adapter->req_q.count);
 	req->issued = get_clock();
 	if (zfcp_qdio_send(req)) {
-		/* Queues are down..... */
 		del_timer(&req->timer);
-		spin_lock(&adapter->req_list_lock);
-		zfcp_reqlist_remove(adapter, req);
-		spin_unlock(&adapter->req_list_lock);
-		/* undo changes in request queue made for this request */
-		atomic_add(req->sbal_number, &req_q->count);
-		req_q->first -= req->sbal_number;
-		req_q->first += QDIO_MAX_BUFFERS_PER_Q;
-		req_q->first %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
+		spin_lock_irqsave(&adapter->req_list_lock, flags);
+		/* lookup request again, list might have changed */
+		if (zfcp_reqlist_find_safe(adapter, req))
+			zfcp_reqlist_remove(adapter, req);
+		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 		zfcp_erp_adapter_reopen(adapter, 0, 116, req);
 		return -EIO;
 	}

-- 
