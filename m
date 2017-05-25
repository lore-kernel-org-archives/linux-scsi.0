From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 5/7] qla2xxx: Set bit 15 for DIAG_ECHO_TEST MBC.
Date: Wed, 24 May 2017 18:06:22 -0700
Message-ID: <20170525010624.8886-6-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0071.outbound.protection.outlook.com ([104.47.40.71]:44658
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162163AbdEYBGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:40 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Set bit (BIT_15) to send right ECHO payload information
for Diagnostic Echo Test command.

Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 9 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 16d1cd50feed..ca3420de5a01 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -730,6 +730,8 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
+	memset(&elreq, 0, sizeof(elreq));
+
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
 		bsg_job->request_payload.sg_list, bsg_job->request_payload.sg_cnt,
 		DMA_TO_DEVICE);
@@ -795,10 +797,9 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
-	    ((IS_QLA81XX(ha) || IS_QLA8031(ha) || IS_QLA8044(ha)) &&
-	    le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE
-	    && req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
-		elreq.options == EXTERNAL_LOOPBACK) {
+	    (le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE &&
+	     req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
+	    elreq.options == EXTERNAL_LOOPBACK) {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
 		ql_dbg(ql_dbg_user, vha, 0x701e,
 		    "BSG request type: %s.\n", type);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 12fea77e31c6..cba1fc5e8be9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4812,9 +4812,9 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	memset(mcp->mb, 0 , sizeof(mcp->mb));
 	mcp->mb[0] = MBC_DIAGNOSTIC_ECHO;
-	mcp->mb[1] = mreq->options | BIT_6;	/* BIT_6 specifies 64bit address */
+	/* BIT_6 specifies 64bit address */
+	mcp->mb[1] = mreq->options | BIT_15 | BIT_6;
 	if (IS_CNA_CAPABLE(ha)) {
-		mcp->mb[1] |= BIT_15;
 		mcp->mb[2] = vha->fcoe_fcf_idx;
 	}
 	mcp->mb[16] = LSW(mreq->rcv_dma);
-- 
2.12.0
