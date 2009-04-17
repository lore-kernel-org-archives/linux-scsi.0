From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/15] zfcp: revert previous patch for sbal counting
Date: Fri, 17 Apr 2009 15:08:12 +0200
Message-ID: <20090417131123.403436000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35631 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760798AbZDQNLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:55 -0400
Content-Disposition: inline; filename=712-zfcp-sbal-counting.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin.petermann@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin.petermann@de.ibm.com>

The current sbal counting can be wrong if a fsf request is
waiting for free sbals and at the same time qdio request queue
is shutdown and re-opened. Revering a previous patch fixes this
issue.

Signed-off-by: Martin Petermann <martin.petermann@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:52.000000000 +0200
@@ -645,30 +645,30 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
-	__releases(&adapter->req_q_lock)
-	__acquires(&adapter->req_q_lock)
+static int zfcp_fsf_sbal_check(struct zfcp_adapter *adapter)
 {
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-	long ret;
 
-	if (atomic_read(&req_q->count) <= -REQUEST_LIST_SIZE)
-		return -EIO;
-	if (atomic_read(&req_q->count) > 0)
-		return 0;
+	spin_lock_bh(&adapter->req_q_lock);
+	if (atomic_read(&req_q->count))
+		return 1;
+	spin_unlock_bh(&adapter->req_q_lock);
+	return 0;
+}
+
+static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
+{
+	long ret;
 
-	atomic_dec(&req_q->count);
 	spin_unlock_bh(&adapter->req_q_lock);
 	ret = wait_event_interruptible_timeout(adapter->request_wq,
-					atomic_read(&req_q->count) >= 0,
-					5 * HZ);
-	spin_lock_bh(&adapter->req_q_lock);
-	atomic_inc(&req_q->count);
-
+			       zfcp_fsf_sbal_check(adapter), 5 * HZ);
 	if (ret > 0)
 		return 0;
 	if (!ret)
 		atomic_inc(&adapter->qdio_outb_full);
+
+	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;
 }
 

