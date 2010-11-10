From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 13/16] BNX2I: Cleaned up various error conditions in
 ep_connect/disconnect
Date: Wed, 10 Nov 2010 15:04:54 -0800
Message-ID: <1289430297-30221-14-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2035 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Various error conditions inside ep_connect and ep_disconnect were
either not being handled or not being handled correctly.  This patch
fixes all those issues.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   67 ++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 507cd25..b3925c7 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -411,7 +411,9 @@ static void bnx2i_free_ep(struct iscsi_endpoint *ep)
 	bnx2i_ep->state = EP_STATE_IDLE;
 	bnx2i_ep->hba->ofld_conns_active--;
 
-	bnx2i_free_iscsi_cid(bnx2i_ep->hba, bnx2i_ep->ep_iscsi_cid);
+	if (bnx2i_ep->ep_iscsi_cid != (u16) -1)
+		bnx2i_free_iscsi_cid(bnx2i_ep->hba, bnx2i_ep->ep_iscsi_cid);
+
 	if (bnx2i_ep->conn) {
 		bnx2i_ep->conn->ep = NULL;
 		bnx2i_ep->conn = NULL;
@@ -1763,13 +1765,17 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		 */
 		hba = bnx2i_check_route(dst_addr);
 
-	if (!hba || test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state)) {
+	if (!hba) {
 		rc = -EINVAL;
 		goto nohba;
 	}
+	mutex_lock(&hba->net_dev_lock);
 
+	if (bnx2i_adapter_ready(hba) || !hba->cid_que.cid_free_cnt) {
+		rc = -EPERM;
+		goto check_busy;
+	}
 	cnic = hba->cnic;
-	mutex_lock(&hba->net_dev_lock);
 	ep = bnx2i_alloc_ep(hba);
 	if (!ep) {
 		rc = -ENOMEM;
@@ -1777,23 +1783,21 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	}
 	bnx2i_ep = ep->dd_data;
 
-	if (bnx2i_adapter_ready(hba)) {
-		rc = -EPERM;
-		goto net_if_down;
-	}
-
 	bnx2i_ep->num_active_cmds = 0;
 	iscsi_cid = bnx2i_alloc_iscsi_cid(hba);
 	if (iscsi_cid == -1) {
-		printk(KERN_ALERT "alloc_ep: unable to allocate iscsi cid\n");
+		printk(KERN_ALERT "bnx2i (%s): alloc_ep - unable to allocate "
+			"iscsi cid\n", hba->netdev->name);
 		rc = -ENOMEM;
-		goto iscsi_cid_err;
+		bnx2i_free_ep(ep);
+		goto check_busy;
 	}
 	bnx2i_ep->hba_age = hba->age;
 
 	rc = bnx2i_alloc_qp_resc(hba, bnx2i_ep);
 	if (rc != 0) {
-		printk(KERN_ALERT "bnx2i: ep_conn, alloc QP resc error\n");
+		printk(KERN_ALERT "bnx2i (%s): ep_conn - alloc QP resc error"
+			"\n", hba->netdev->name);
 		rc = -ENOMEM;
 		goto qp_resc_err;
 	}
@@ -1832,7 +1836,12 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	bnx2i_ep_ofld_list_del(hba, bnx2i_ep);
 
 	if (bnx2i_ep->state != EP_STATE_OFLD_COMPL) {
-		rc = -ENOSPC;
+		if (bnx2i_ep->state == EP_STATE_OFLD_FAILED_CID_BUSY) {
+			printk(KERN_ALERT "bnx2i (%s): iscsi cid %d is busy\n",
+				hba->netdev->name, bnx2i_ep->ep_iscsi_cid);
+			rc = -EBUSY;
+		} else
+			rc = -ENOSPC;
 		goto conn_failed;
 	}
 
@@ -1840,7 +1849,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 			     iscsi_cid, &bnx2i_ep->cm_sk, bnx2i_ep);
 	if (rc) {
 		rc = -EINVAL;
-		goto conn_failed;
+		/* Need to terminate and cleanup the connection */
+		goto release_ep;
 	}
 
 	bnx2i_ep->cm_sk->rcv_buf = 256 * 1024;
@@ -1884,8 +1894,6 @@ release_ep:
 		return ERR_PTR(rc);
 	}
 conn_failed:
-net_if_down:
-iscsi_cid_err:
 	bnx2i_free_qp_resc(hba, bnx2i_ep);
 qp_resc_err:
 	bnx2i_free_ep(ep);
@@ -2004,7 +2012,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	if (!cnic)
 		return 0;
 
-	if (bnx2i_ep->state == EP_STATE_IDLE)
+	if (bnx2i_ep->state == EP_STATE_IDLE ||
+	    bnx2i_ep->state == EP_STATE_DISCONN_TIMEDOUT)
 		return 0;
 
 	if (!bnx2i_ep_tcp_conn_active(bnx2i_ep))
@@ -2030,9 +2039,10 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 			if (session->state == ISCSI_STATE_LOGGING_OUT) {
 				if (bnx2i_ep->state == EP_STATE_LOGOUT_SENT) {
 					/* Logout sent, but no resp */
-					printk(KERN_ALERT "bnx2i - WARNING "
-						"logout response was not "
-						"received!\n");
+					printk(KERN_ALERT "bnx2i (%s): WARNING"
+						" logout response was not "
+						"received!\n",
+						bnx2i_ep->hba->netdev->name);
 				} else if (bnx2i_ep->state ==
 					   EP_STATE_LOGOUT_RESP_RCVD)
 					close = 1;
@@ -2050,9 +2060,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	else
 		close_ret = cnic->cm_abort(bnx2i_ep->cm_sk);
 
-	/* No longer allow CFC delete if cm_close/abort fails the request */
 	if (close_ret)
-		printk(KERN_ALERT "bnx2i: %s close/abort(%d) returned %d\n",
+		printk(KERN_ALERT "bnx2i (%s): close/abort(%d) returned %d\n",
 			bnx2i_ep->hba->netdev->name, close, close_ret);
 	else
 		/* wait for option-2 conn teardown */
@@ -2066,7 +2075,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 destroy_conn:
 	bnx2i_ep_active_list_del(hba, bnx2i_ep);
 	if (bnx2i_tear_down_conn(hba, bnx2i_ep))
-		ret = -EINVAL;
+		return -EINVAL;
 out:
 	bnx2i_ep->state = EP_STATE_IDLE;
 	return ret;
@@ -2105,14 +2114,17 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 
 	mutex_lock(&hba->net_dev_lock);
 
-	if (bnx2i_ep->state == EP_STATE_IDLE)
-		goto return_bnx2i_ep;
+	if (bnx2i_ep->state == EP_STATE_DISCONN_TIMEDOUT)
+		goto out;
 
-	if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state))
+	if (bnx2i_ep->state == EP_STATE_IDLE)
 		goto free_resc;
 
-	if (bnx2i_ep->hba_age != hba->age)
+	if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state) ||
+	    (bnx2i_ep->hba_age != hba->age)) {
+		bnx2i_ep_active_list_del(hba, bnx2i_ep);
 		goto free_resc;
+	}
 
 	/* Do all chip cleanup here */
 	if (bnx2i_hw_ep_disconnect(bnx2i_ep)) {
@@ -2121,11 +2133,12 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 	}
 free_resc:
 	bnx2i_free_qp_resc(hba, bnx2i_ep);
-return_bnx2i_ep:
+
 	if (bnx2i_conn)
 		bnx2i_conn->ep = NULL;
 
 	bnx2i_free_ep(ep);
+out:
 	mutex_unlock(&hba->net_dev_lock);
 	
 	wake_up_interruptible(&hba->eh_wait);
-- 
1.7.0.5


