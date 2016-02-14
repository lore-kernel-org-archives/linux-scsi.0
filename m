From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 22/34] iscsi-target: call Rx thread function
Date: Sun, 14 Feb 2016 23:15:29 +0530
Message-ID: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:45139 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317AbcBNRqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:46:05 -0500
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

call Rx thread function if registered
by transport driver, so that transport
drivers can use iscsi-target Rx thread
for Rx processing.

update iSER target driver to use this
interface.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 10 ++++++++++
 drivers/target/iscsi/iscsi_target.c     | 10 ++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f121e61..365aa8c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3396,6 +3396,15 @@ static void isert_free_conn(struct iscsi_conn *conn)
 	isert_put_conn(isert_conn);
 }
 
+static void isert_rx_pdu(struct iscsi_conn *conn)
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
@@ -3414,6 +3423,7 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_queue_data_in	= isert_put_datain,
 	.iscsit_queue_status	= isert_put_response,
 	.iscsit_aborted_task	= isert_aborted_task,
+	.iscsit_rx_pdu		= isert_rx_pdu,
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3dd7ba2..e2ec56f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4132,14 +4132,8 @@ int iscsi_target_rx_thread(void *arg)
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
+	if (conn->conn_transport->iscsit_rx_pdu) {
+		conn->conn_transport->iscsit_rx_pdu(conn);
 		goto transport_err;
 	}
 
-- 
2.0.2

