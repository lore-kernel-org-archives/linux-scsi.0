From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/11] zfcp: Simplify SBAL allocation to fix sparse warnings
Date: Fri, 19 Dec 2008 16:56:54 +0100
Message-ID: <20081219155751.867385000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:56279 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYLSP5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:54 -0500
Content-Disposition: inline; filename=sparse.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When waiting for a request claim the SBAL before waiting. This way,
locking before each check of the free counter is not required and
sparse does not emit warnings for the complicated locking scheme.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:21.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:28.000000000 +0100
@@ -641,38 +641,38 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_sbal_check(struct zfcp_adapter *adapter)
+static int zfcp_fsf_sbal_available(struct zfcp_adapter *adapter)
 {
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-
-	spin_lock_bh(&adapter->req_q_lock);
-	if (atomic_read(&req_q->count))
+	if (atomic_read(&adapter->req_q.count) > 0)
 		return 1;
-	spin_unlock_bh(&adapter->req_q_lock);
+	atomic_inc(&adapter->qdio_outb_full);
 	return 0;
 }
 
-static int zfcp_fsf_sbal_available(struct zfcp_adapter *adapter)
-{
-	unsigned int count = atomic_read(&adapter->req_q.count);
-	if (!count)
-		atomic_inc(&adapter->qdio_outb_full);
-	return count > 0;
-}
-
 static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
+	__releases(&adapter->req_q_lock)
+	__acquires(&adapter->req_q_lock)
 {
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 	long ret;
 
+	if (atomic_read(&req_q->count) <= -REQUEST_LIST_SIZE)
+		return -EIO;
+	if (atomic_read(&req_q->count) > 0)
+		return 0;
+
+	atomic_dec(&req_q->count);
 	spin_unlock_bh(&adapter->req_q_lock);
 	ret = wait_event_interruptible_timeout(adapter->request_wq,
-					zfcp_fsf_sbal_check(adapter), 5 * HZ);
+					atomic_read(&req_q->count) >= 0,
+					5 * HZ);
+	spin_lock_bh(&adapter->req_q_lock);
+	atomic_inc(&req_q->count);
+
 	if (ret > 0)
 		return 0;
 	if (!ret)
 		atomic_inc(&adapter->qdio_outb_full);
-
-	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;
 }
 

-- 
