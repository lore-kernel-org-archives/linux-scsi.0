From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 21/34] iscsi-target: release transport driver resources
Date: Sun, 14 Feb 2016 23:12:15 +0530
Message-ID: <26d1bde8e55db6d2f77a354b379bec78bb7b7322.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:18604 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbcBNRmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:42:53 -0500
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

transport driver may allocate resources for an
iSCSI cmd, to free that resources iscsi target
must call release function registered by transport
driver.

ISCSI_TCP_CXGB4 frees DDP resource associated
with a WRITE cmd in the callback function.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5cab517..71240e4 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -727,6 +727,9 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool scsi_cmd,
 		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
 		iscsit_remove_cmd_from_response_queue(cmd, conn);
 	}
+
+	if (conn && conn->conn_transport->iscsit_release_cmd)
+		conn->conn_transport->iscsit_release_cmd(conn, cmd);
 }
 
 void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
-- 
2.0.2

