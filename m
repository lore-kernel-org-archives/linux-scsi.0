From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/7] BNX2I: Separated the hardware's cleanup procedure
 from ep_disconnect
Date: Fri, 25 Jun 2010 18:39:26 -0700
Message-ID: <1277516372-469-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4314 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0FZBik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 21:38:40 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This patch introduces a new bnx2i_hw_ep_disconnect routine which
contains all chip related disconnect and clean up procedure of
iSCSI offload connections.  This separation is intended as a
preparation for the subsequent bnx2i_stop patch.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  122 ++++++++++++++++++++++++-------------
 1 files changed, 79 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fa68ab3..3276555 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1866,54 +1866,35 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 }
 
 
-/**
- * bnx2i_ep_disconnect - executes TCP connection teardown process
- * @ep:		TCP connection (endpoint) handle
+/*
+ * bnx2i_hw_ep_disconnect - executes TCP connection teardown process in the hw
+ * @ep:		TCP connection (bnx2i endpoint) handle
  *
  * executes  TCP connection teardown process
  */
-static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
+int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 {
-	struct bnx2i_endpoint *bnx2i_ep;
-	struct bnx2i_conn *bnx2i_conn = NULL;
-	struct iscsi_session *session = NULL;
-	struct iscsi_conn *conn;
+	struct bnx2i_hba *hba = bnx2i_ep->hba;
 	struct cnic_dev *cnic;
-	struct bnx2i_hba *hba;
+	struct iscsi_session *session = NULL;
+	struct iscsi_conn *conn = NULL;
+	int ret = 0;
 
-	bnx2i_ep = ep->dd_data;
+	if (!hba)
+		return 0;
 
-	/* driver should not attempt connection cleanup until TCP_CONNECT
-	 * completes either successfully or fails. Timeout is 9-secs, so
-	 * wait for it to complete
-	 */
-	while ((bnx2i_ep->state == EP_STATE_CONNECT_START) &&
-		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
-		msleep(250);
+	cnic = hba->cnic;
+	if (!cnic)
+		return 0;
+
+	if (!bnx2i_ep_tcp_conn_active(bnx2i_ep))
+		goto destroy_conn;
 
 	if (bnx2i_ep->conn) {
-		bnx2i_conn = bnx2i_ep->conn;
-		conn = bnx2i_conn->cls_conn->dd_data;
+		conn = bnx2i_ep->conn->cls_conn->dd_data;
 		session = conn->session;
-
-		iscsi_suspend_queue(conn);
 	}
 
-	hba = bnx2i_ep->hba;
-	if (bnx2i_ep->state == EP_STATE_IDLE)
-		goto return_bnx2i_ep;
-	cnic = hba->cnic;
-
-	mutex_lock(&hba->net_dev_lock);
-
-	if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state))
-		goto free_resc;
-	if (bnx2i_ep->hba_age != hba->age)
-		goto free_resc;
-
-	if (!bnx2i_ep_tcp_conn_active(bnx2i_ep))
-		goto destory_conn;
-
 	bnx2i_ep->state = EP_STATE_DISCONN_START;
 
 	init_timer(&bnx2i_ep->ofld_timer);
@@ -1924,6 +1905,7 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
 		int close = 0;
+		int close_ret = 0;
 
 		if (session) {
 			spin_lock_bh(&session->lock);
@@ -1932,11 +1914,13 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 			spin_unlock_bh(&session->lock);
 		}
 		if (close)
-			cnic->cm_close(bnx2i_ep->cm_sk);
+			close_ret = cnic->cm_close(bnx2i_ep->cm_sk);
 		else
-			cnic->cm_abort(bnx2i_ep->cm_sk);
+			close_ret = cnic->cm_abort(bnx2i_ep->cm_sk);
+		if (close_ret)
+			bnx2i_ep->state = EP_STATE_DISCONN_COMPL;
 	} else
-		goto free_resc;
+		goto out;
 
 	/* wait for option-2 conn teardown */
 	wait_event_interruptible(bnx2i_ep->ofld_wait,
@@ -1946,20 +1930,72 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 		flush_signals(current);
 	del_timer_sync(&bnx2i_ep->ofld_timer);
 
-destory_conn:
-	if (bnx2i_tear_down_conn(hba, bnx2i_ep)) {
+destroy_conn:
+	if (bnx2i_tear_down_conn(hba, bnx2i_ep))
+		ret = -EINVAL;
+out:
+	bnx2i_ep->state = EP_STATE_IDLE;
+	return ret;
+}
+
+
+/**
+ * bnx2i_ep_disconnect - executes TCP connection teardown process
+ * @ep:		TCP connection (iscsi endpoint) handle
+ *
+ * executes  TCP connection teardown process
+ */
+static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
+{
+	struct bnx2i_endpoint *bnx2i_ep;
+	struct bnx2i_conn *bnx2i_conn = NULL;
+	struct iscsi_conn *conn = NULL;
+	struct bnx2i_hba *hba;
+
+	bnx2i_ep = ep->dd_data;
+
+	/* driver should not attempt connection cleanup until TCP_CONNECT
+	 * completes either successfully or fails. Timeout is 9-secs, so
+	 * wait for it to complete
+	 */
+	while ((bnx2i_ep->state == EP_STATE_CONNECT_START) &&
+		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
+		msleep(250);
+
+	if (bnx2i_ep->conn) {
+		bnx2i_conn = bnx2i_ep->conn;
+		conn = bnx2i_conn->cls_conn->dd_data;
+		iscsi_suspend_queue(conn);
+	}
+	hba = bnx2i_ep->hba;
+	if (!hba)
+		goto out;
+
+	mutex_lock(&hba->net_dev_lock);
+
+	if (bnx2i_ep->state == EP_STATE_IDLE)
+		goto return_bnx2i_ep;
+
+	if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state))
+		goto free_resc;
+
+	if (bnx2i_ep->hba_age != hba->age)
+		goto free_resc;
+
+	/* Do all chip cleanup here */
+	if (bnx2i_hw_ep_disconnect(bnx2i_ep)) {
 		mutex_unlock(&hba->net_dev_lock);
 		return;
 	}
 free_resc:
-	mutex_unlock(&hba->net_dev_lock);
 	bnx2i_free_qp_resc(hba, bnx2i_ep);
 return_bnx2i_ep:
 	if (bnx2i_conn)
 		bnx2i_conn->ep = NULL;
 
 	bnx2i_free_ep(ep);
-
+	mutex_unlock(&hba->net_dev_lock);
+out:
 	if (!hba->ofld_conns_active)
 		bnx2i_unreg_dev_all();
 
-- 
1.7.0.5


