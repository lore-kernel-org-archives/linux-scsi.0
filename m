From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH 05/11] IB/srp: destroy and recreate QP and CQs on each connection
Date: Sun, 25 Nov 2012 23:44:10 -0500
Message-ID: <8fa9a268ec4dc587970161efe94968f3263aad3b.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38059 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2KZEzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 23:55:14 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, roland@purestorage.com, Ishai Rabinovitz <ishai@mellanox.co.il>, "Michael S. Tsirkin" <mst@mellanox.co.il>

From: Ishai Rabinovitz <ishai@mellanox.co.il>

HW QP FATAL errors persist over a reset operation, but we can recover
from that by recreating the QP and associated CQs for each connection.
Creating a new QP/CQ also completely forecloses any possibility of
getting stale completions or packets on the new connection.

Signed-off-by: Ishai Rabinovitz <ishai@mellanox.co.il>
Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>
[ updated to current code from OFED, cleaned up commit message ]
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   66 ++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f7d7e6a..a481727 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -250,27 +250,29 @@ static int srp_new_cm_id(struct srp_target_port *target)
 static int srp_create_target_ib(struct srp_target_port *target)
 {
 	struct ib_qp_init_attr *init_attr;
+	struct ib_cq *recv_cq, *send_cq;
+	struct ib_qp *qp;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
 	if (!init_attr)
 		return -ENOMEM;
 
-	target->recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
-	if (IS_ERR(target->recv_cq)) {
-		ret = PTR_ERR(target->recv_cq);
+	recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
+			       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
+	if (IS_ERR(recv_cq)) {
+		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
-	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-				       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
-	if (IS_ERR(target->send_cq)) {
-		ret = PTR_ERR(target->send_cq);
+	send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
+			       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
+	if (IS_ERR(send_cq)) {
+		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
 	}
 
-	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
+	ib_req_notify_cq(recv_cq, IB_CQ_NEXT_COMP);
 
 	init_attr->event_handler       = srp_qp_event;
 	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
@@ -279,30 +281,41 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	init_attr->cap.max_send_sge    = 1;
 	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
 	init_attr->qp_type             = IB_QPT_RC;
-	init_attr->send_cq             = target->send_cq;
-	init_attr->recv_cq             = target->recv_cq;
+	init_attr->send_cq             = send_cq;
+	init_attr->recv_cq             = recv_cq;
 
-	target->qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
-	if (IS_ERR(target->qp)) {
-		ret = PTR_ERR(target->qp);
+	qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
 		goto err_send_cq;
 	}
 
-	ret = srp_init_qp(target, target->qp);
+	ret = srp_init_qp(target, qp);
 	if (ret)
 		goto err_qp;
 
+	if (target->qp)
+		ib_destroy_qp(target->qp);
+	if (target->recv_cq)
+		ib_destroy_cq(target->recv_cq);
+	if (target->send_cq)
+		ib_destroy_cq(target->send_cq);
+
+	target->qp = qp;
+	target->recv_cq = recv_cq;
+	target->send_cq = send_cq;
+
 	kfree(init_attr);
 	return 0;
 
 err_qp:
-	ib_destroy_qp(target->qp);
+	ib_destroy_qp(qp);
 
 err_send_cq:
-	ib_destroy_cq(target->send_cq);
+	ib_destroy_cq(send_cq);
 
 err_recv_cq:
-	ib_destroy_cq(target->recv_cq);
+	ib_destroy_cq(recv_cq);
 
 err:
 	kfree(init_attr);
@@ -317,6 +330,9 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
 
+	target->qp = NULL;
+	target->send_cq = target->recv_cq = NULL;
+
 	for (i = 0; i < SRP_RQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
@@ -673,8 +689,6 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 
 static int srp_reconnect_target(struct srp_target_port *target)
 {
-	struct ib_qp_attr qp_attr;
-	struct ib_wc wc;
 	int i, ret;
 
 	if (srp_is_removed(target))
@@ -689,20 +703,10 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	qp_attr.qp_state = IB_QPS_RESET;
-	ret = ib_modify_qp(target->qp, &qp_attr, IB_QP_STATE);
-	if (ret)
-		goto err;
-
-	ret = srp_init_qp(target, target->qp);
+	ret = srp_create_target_ib(target);
 	if (ret)
 		goto err;
 
-	while (ib_poll_cq(target->recv_cq, 1, &wc) > 0)
-		; /* nothing */
-	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
-		; /* nothing */
-
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd)
-- 
1.7.7.6

