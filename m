From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 19/34] iscsi-target: clear tx_thread_active
Date: Sun, 14 Feb 2016 23:12:13 +0530
Message-ID: <179da911feeb6481e0e06eb45f18743be02d6e90.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:10580 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbcBNRmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:42:50 -0500
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

clear tx_thread_active for ISCSI_TCP_CXGB4
transport in logout_post_handler functions.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 858f6e4..3dd7ba2 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4579,7 +4579,8 @@ static void iscsit_logout_post_handler_closesession(
 	 * always sleep waiting for RX/TX thread shutdown to complete
 	 * within iscsit_close_connection().
 	 */
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
@@ -4596,7 +4597,8 @@ static void iscsit_logout_post_handler_samecid(
 {
 	int sleep = 1;
 
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
-- 
2.0.2

