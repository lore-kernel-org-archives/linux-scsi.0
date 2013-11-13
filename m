From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] ib_isert: Avoid duplicate iscsit_increment_maxcmdsn call
Date: Wed, 13 Nov 2013 02:11:43 +0000
Message-ID: <1384308703-10034-3-git-send-email-nab@daterainc.com>
References: <1384308703-10034-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384308703-10034-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Moussa Ba <moussaba@micron.com>, Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch avoids a duplicate iscsit_increment_maxcmdsn() call for
ISER_IB_RDMA_WRITE within isert_map_rdma() + isert_reg_rdma_frwr(),
which will already be occuring once during isert_put_datain() ->
iscsit_build_rsp_pdu() operation.

It also removes the local conn->stat_sn assignment + increment,
and changes the third parameter to iscsit_build_rsp_pdu() to
signal this should be done by iscsi_target_mode code.

Tested-by: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bbd86e8..5661075 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2029,8 +2029,6 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		data_left = se_cmd->data_length;
-		iscsit_increment_maxcmdsn(cmd, conn->sess);
-		cmd->stat_sn = conn->stat_sn++;
 	} else {
 		sg_off = cmd->write_data_done / PAGE_SIZE;
 		data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2242,8 +2240,6 @@ isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		data_left = se_cmd->data_length;
-		iscsit_increment_maxcmdsn(cmd, conn->sess);
-		cmd->stat_sn = conn->stat_sn++;
 	} else {
 		sg_off = cmd->write_data_done / PAGE_SIZE;
 		data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2352,7 +2348,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	 * Build isert_conn->tx_desc for iSCSI response PDU and attach
 	 */
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
+	iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
 			     &isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 	isert_init_send_wr(isert_conn, isert_cmd,
-- 
1.7.10.4
