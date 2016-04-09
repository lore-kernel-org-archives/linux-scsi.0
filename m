From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 12/16] iscsi-target: clear tx_thread_active
Date: Sat,  9 Apr 2016 18:41:22 +0530
Message-ID: <f319f474b3400635b82b0ca6aad02e343a792d8e.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:13954 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753849AbcDINNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2016 09:13:47 -0400
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

clear tx_thread_active for ISCSI_HW_OFFLOAD
transport in logout_post_handler functions.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e61249d..959644f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4417,7 +4417,8 @@ static void iscsit_logout_post_handler_closesession(
 	 * always sleep waiting for RX/TX thread shutdown to complete
 	 * within iscsit_close_connection().
 	 */
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_HW_OFFLOAD))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
@@ -4434,7 +4435,8 @@ static void iscsit_logout_post_handler_samecid(
 {
 	int sleep = 1;
 
-	if (conn->conn_transport->transport_type == ISCSI_TCP)
+	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
+	    (conn->conn_transport->transport_type == ISCSI_HW_OFFLOAD))
 		sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
-- 
2.0.2

