From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] iser-target: Disable TX completion interrupt coalescing
Date: Mon,  6 Oct 2014 02:15:11 +0000
Message-ID: <1412561711-31344-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>, Moussa Ba <moussaba@micron.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch explicitly disables TX completion interrupt coalescing logic
in isert_put_response() and isert_put_datain() that was originally added
as an efficiency optimization in commit 95b60f07.

It has been reported that this change can trigger ABORT_TASK timeouts
under certain small block workloads, where disabling coalescing was
required for stability.  According to Sagi, this doesn't impact
overall performance, so go ahead and disable it for now.

Reported-by: Moussa Ba <moussaba@micron.com>
Cc: Moussa Ba <moussaba@micron.com>
Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 40969b6..f719112 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2183,7 +2183,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
-	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -2882,7 +2882,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 				     &isert_cmd->tx_desc.iscsi_header);
 		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 		isert_init_send_wr(isert_conn, isert_cmd,
-				   &isert_cmd->tx_desc.send_wr, true);
+				   &isert_cmd->tx_desc.send_wr, false);
 		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
 		wr->send_wr_num += 1;
 	}
-- 
1.7.10.4
