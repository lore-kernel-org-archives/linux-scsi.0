From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 03/13] iscsi-target: add void (*iscsit_get_rx_pdu)()
Date: Wed, 20 Apr 2016 00:00:10 +0530
Message-ID: <f993801e40717417bb752ddeb20765b25b092584.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:6677 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754613AbcDSSay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2016 14:30:54 -0400
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

Add void (*iscsit_get_rx_pdu)() to
struct iscsit_transport, iscsi-target
uses this callback to receive and
process Rx iSCSI PDUs.

cxgbit.ko needs this callback to
reuse iscsi-target Rx thread.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 10 ++++++++++
 drivers/target/iscsi/iscsi_target.c     | 10 ++--------
 include/target/iscsi/iscsi_transport.h  |  1 +
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 411e446..9118d7c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3273,6 +3273,15 @@ static void isert_free_conn(struct iscsi_conn *conn)
 	isert_put_conn(isert_conn);
 }
 
+static void isert_get_rx_pdu(struct iscsi_conn *conn)
+{
+	struct completion comp;
+
+	init_completion(&comp);
+
+	wait_for_completion_interruptible(&comp);
+}
+
 static struct iscsit_transport iser_target_transport = {
 	.name			= "IB/iSER",
 	.transport_type		= ISCSI_INFINIBAND,
@@ -3291,6 +3300,7 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_queue_data_in	= isert_put_datain,
 	.iscsit_queue_status	= isert_put_response,
 	.iscsit_aborted_task	= isert_aborted_task,
+	.iscsit_get_rx_pdu	= isert_get_rx_pdu,
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0724c83..9fa9f0b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3951,14 +3951,8 @@ int iscsi_target_rx_thread(void *arg)
 	if (rc < 0 || iscsi_target_check_conn_state(conn))
 		return 0;
 
-	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
-		struct completion comp;
-
-		init_completion(&comp);
-		rc = wait_for_completion_interruptible(&comp);
-		if (rc < 0)
-			goto transport_err;
-
+	if (conn->conn_transport->iscsit_get_rx_pdu) {
+		conn->conn_transport->iscsit_get_rx_pdu(conn);
 		goto transport_err;
 	}
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 3b0053e..ccc68a0 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -25,6 +25,7 @@ struct iscsit_transport {
 	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
 			       struct iscsi_datain_req *, const void *, u32);
 	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
+	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2

