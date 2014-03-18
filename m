From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2] Target/iser: Fail SCSI WRITE command if device detected integrity error
Date: Tue, 18 Mar 2014 14:58:27 +0200
Message-ID: <1395147507-19035-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:48728 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753857AbaCRM6x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2014 08:58:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, ogerlitz@mellanox.com, linux-scsi@vger.kernel.org

If during data-transfer a data-integrity error was detected we
must fail the command with CHECK_CONDITION and not execute
the command.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reported-by: Or Gerlitz <ogerlitz@mellanox.com>
---
Changes from v1:
- Fixed typo

Changes from v0:
- Added reported-by Or gerlitz

 drivers/infiniband/ulp/isert/ib_isert.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e2d48a9..09bde9f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1736,7 +1736,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
-	int ret;
+	int ret = 0;
 
 	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
 		ret = isert_check_pi_status(se_cmd,
@@ -1755,7 +1755,11 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
 	spin_unlock_bh(&cmd->istate_lock);
 
-	target_execute_cmd(se_cmd);
+	if (ret)
+		transport_send_check_condition_and_sense(se_cmd,
+							 se_cmd->pi_err, 0);
+	else
+		target_execute_cmd(se_cmd);
 }
 
 static void
-- 
1.7.1

