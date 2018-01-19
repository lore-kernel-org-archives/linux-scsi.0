From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/5] qla2xxx: Remove unneeded message and minor cleanup for FC-NVMe
Date: Fri, 19 Jan 2018 12:29:24 -0800
Message-ID: <20180119202928.13239-2-himanshu.madhani@cavium.com>
References: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0056.outbound.protection.outlook.com ([104.47.37.56]:10496
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756249AbeASU3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 15:29:40 -0500
In-Reply-To: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 6b33a1f24f56..162a523b985e 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -113,8 +113,6 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 		return 0;
 	}
 
-	ql_log(ql_log_warn, vha, 0xffff,
-	    "allocating q for idx=%x w/o cpu mask\n", qidx);
 	qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
 	if (qpair == NULL) {
 		ql_log(ql_log_warn, vha, 0x2122,
@@ -313,7 +311,6 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 	uint16_t	avail_dsds;
 	uint32_t	*cur_dsd;
 	struct req_que *req = NULL;
-	struct rsp_que *rsp = NULL;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
@@ -322,15 +319,13 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 	struct nvmefc_fcp_req *fd = nvme->u.nvme.desc;
 	uint32_t        rval = QLA_SUCCESS;
 
+	/* Setup qpair pointers */
+	req = qpair->req;
 	tot_dsds = fd->sg_cnt;
 
 	/* Acquire qpair specific lock */
 	spin_lock_irqsave(&qpair->qp_lock, flags);
 
-	/* Setup qpair pointers */
-	req = qpair->req;
-	rsp = qpair->rsp;
-
 	/* Check for room in outstanding command list. */
 	handle = req->current_outstanding_cmd;
 	for (index = 1; index < req->num_outstanding_cmds; index++) {
@@ -365,7 +360,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 		struct nvme_fc_cmd_iu *cmd = fd->cmdaddr;
 		if (cmd->sqe.common.opcode == nvme_admin_async_event) {
 			nvme->u.nvme.aen_op = 1;
-			atomic_inc(&vha->hw->nvme_active_aen_cnt);
+			atomic_inc(&ha->nvme_active_aen_cnt);
 		}
 	}
 
-- 
2.12.0
