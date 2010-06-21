From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Do not wait for SBALs on stopped queue
Date: Mon, 21 Jun 2010 10:11:32 +0200
Message-ID: <20100621081247.363742000@de.ibm.com>
References: <20100621081130.507888000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43855 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0FUIMt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2010 04:12:49 -0400
Content-Disposition: inline; filename=702-zfcp-stopped-queue.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Trying to read the FC host statistics on an offline adapter results in
a 5 seconds wait. Reading the statistics tries to issue an exchange
port data request which first waits up to 5 seconds for an entry in 
the request queue.

Change the strategy for getting a free SBAL to exit when the queue is
stopped. Reading the statistics will then fail without the wait.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |    5 -----
 drivers/s390/scsi/zfcp_qdio.c |   10 +++++++++-
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:40.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:43.000000000 +0200
@@ -719,11 +719,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id, sbtype,
 			   req->qtcb, sizeof(struct fsf_qtcb));
 
-	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)) {
-		zfcp_fsf_req_free(req);
-		return ERR_PTR(-EIO);
-	}
-
 	return req;
 }
 
--- a/drivers/s390/scsi/zfcp_qdio.c	2010-06-21 09:37:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2010-06-21 09:37:43.000000000 +0200
@@ -251,7 +251,8 @@ static int zfcp_qdio_sbal_check(struct z
 	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (atomic_read(&req_q->count))
+	if (atomic_read(&req_q->count) ||
+	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
 	spin_unlock_bh(&qdio->req_q_lock);
 	return 0;
@@ -274,8 +275,13 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio 
 	spin_unlock_bh(&qdio->req_q_lock);
 	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
 			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+
+	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
+		return -EIO;
+
 	if (ret > 0)
 		return 0;
+
 	if (!ret) {
 		atomic_inc(&qdio->req_q_full);
 		/* assume hanging outbound queue, try queue recovery */
@@ -375,6 +381,8 @@ void zfcp_qdio_close(struct zfcp_qdio *q
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 	spin_unlock_bh(&qdio->req_q_lock);
 
+	wake_up(&qdio->req_q_wq);
+
 	qdio_shutdown(qdio->adapter->ccw_device,
 		      QDIO_FLAG_CLEANUP_USING_CLEAR);
 

