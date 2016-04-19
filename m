From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 10/13] iscsi-target: clear tx_thread_active
Date: Wed, 20 Apr 2016 00:00:17 +0530
Message-ID: <72fbf94b3b5bebf9a7688629bfa334836d003935.1461088673.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

clear tx_thread_active for ISCSI_HW_OFFLOAD
transport in logout_post_handler functions.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 348337c..29df956 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4379,7 +4379,8 @@ static void iscsit_logout_post_handler_closesession(
 	 * always sleep waiting for RX/TX thread shutdown to complete
 	 * within iscsit_close_connection().
 	 */
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_HW_OFFLOAD))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
@@ -4396,7 +4397,8 @@ static void iscsit_logout_post_handler_samecid(
 {
 	int sleep = 1;
 
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_HW_OFFLOAD))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
-- 
2.0.2
