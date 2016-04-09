From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 05/16] iscsi-target: add void (*iscsit_get_rx_pdu)()
Date: Sat,  9 Apr 2016 18:41:15 +0530
Message-ID: <a454b4444bda97b5d36b6ba02fa492f401096036.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add void (*iscsit_get_rx_pdu)() to
struct iscsit_transport, iscsi-target
uses this callback to receive and
process Rx iSCSI PDUs.

Signed-off-by: Varun Prakash <varun@chelsio.com>
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
index 9e65e5d..4311636 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3989,14 +3989,8 @@ int iscsi_target_rx_thread(void *arg)
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
index 19cef94..1f63d8c 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -30,6 +30,7 @@ struct iscsit_transport {
 				      struct iscsi_datain_req *,
 				      struct iscsi_datain *);
 	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
+	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2
