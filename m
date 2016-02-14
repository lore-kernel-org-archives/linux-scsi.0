From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 18/34] iscsi-target: call complete on conn_logout_comp
Date: Sun, 14 Feb 2016 23:12:12 +0530
Message-ID: <f98923031c5958e73ce1ac13a5fc7f68ba19391f.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

ISCSI_TCP_CXGB4 driver waits on conn_logout_comp as
ISCSI_TCP driver so call complete if transport type
is ISCSI_TCP_CXGB4.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8bf3cfb..858f6e4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4265,16 +4265,18 @@ int iscsit_close_connection(
 	pr_debug("Closing iSCSI connection CID %hu on SID:"
 		" %u\n", conn->cid, sess->sid);
 	/*
-	 * Always up conn_logout_comp for the traditional TCP case just in case
-	 * the RX Thread in iscsi_target_rx_opcode() is sleeping and the logout
-	 * response never got sent because the connection failed.
+	 * Always up conn_logout_comp for the traditional TCP and TCP_CXGB4
+	 * case just in case the RX Thread in iscsi_target_rx_opcode() is
+	 * sleeping and the logout response never got sent because the
+	 * connection failed.
 	 *
 	 * However for iser-target, isert_wait4logout() is using conn_logout_comp
 	 * to signal logout response TX interrupt completion.  Go ahead and skip
 	 * this for iser since isert_rx_opcode() does not wait on logout failure,
 	 * and to avoid iscsi_conn pointer dereference in iser-target code.
 	 */
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
 		complete(&conn->conn_logout_comp);
 
 	if (!strcmp(current->comm, ISCSI_RX_THREAD_NAME)) {
-- 
2.0.2
