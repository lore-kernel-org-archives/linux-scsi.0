From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 11/13] iscsi-target: call complete on conn_logout_comp
Date: Wed, 20 Apr 2016 00:00:18 +0530
Message-ID: <0dbf515fb0ef72e5ffb350a85e1e8f35ac73b19b.1461088673.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

ISCSI_HW_OFFLOAD transport drivers waits
on conn_logout_comp as ISCSI_TCP driver
so call complete if transport type
is ISCSI_HW_OFFLOAD.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 29df956..8021223 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4063,16 +4063,18 @@ int iscsit_close_connection(
 	pr_debug("Closing iSCSI connection CID %hu on SID:"
 		" %u\n", conn->cid, sess->sid);
 	/*
-	 * Always up conn_logout_comp for the traditional TCP case just in case
-	 * the RX Thread in iscsi_target_rx_opcode() is sleeping and the logout
-	 * response never got sent because the connection failed.
+	 * Always up conn_logout_comp for the traditional TCP and HW_OFFLOAD
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
+	    (conn->conn_transport->transport_type == ISCSI_HW_OFFLOAD))
 		complete(&conn->conn_logout_comp);
 
 	if (!strcmp(current->comm, ISCSI_RX_THREAD_NAME)) {
-- 
2.0.2
