From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 6/8] qla2xxx: Fix queue ID for async abort with Multiqueue
Date: Mon, 15 Jan 2018 20:46:51 -0800
Message-ID: <20180116044653.20696-7-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0042.outbound.protection.outlook.com ([104.47.32.42]:19172
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751356AbeAPErL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:11 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Darren Trapp <darren.trapp@cavium.com>

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f7396a2e28ba..be7d6824581a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -442,6 +442,7 @@ struct srb_iocb {
 		struct {
 			uint32_t cmd_hndl;
 			__le16 comp_status;
+			__le16 req_que_no;
 			struct completion comp;
 		} abt;
 		struct ct_arg ctarg;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e030ee38fa6f..bf1ad9161d11 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1565,6 +1565,12 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp)
 	sp->name = "abort";
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
+
+	if (vha->flags.qpairs_available && cmd_sp->qpair)
+		abt_iocb->u.abt.req_que_no = cmd_sp->qpair->req->id;
+	else
+		abt_iocb->u.abt.req_que_no = vha->req->id;
+
 	sp->done = qla24xx_abort_sp_done;
 	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
 	init_completion(&abt_iocb->u.abt.comp);
@@ -1599,6 +1605,9 @@ qla24xx_async_abort_command(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
 
+	if (vha->flags.qpairs_available && sp->qpair)
+		req = sp->qpair->req;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
 		if (req->outstanding_cmds[handle] == sp)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 2c6a236dff96..1b62e943ec49 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3275,7 +3275,9 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
 	abt_iocb->entry_type = ABORT_IOCB_TYPE;
 	abt_iocb->entry_count = 1;
-	abt_iocb->handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
+	abt_iocb->handle =
+	     cpu_to_le32(MAKE_HANDLE(aio->u.abt.req_que_no,
+		 aio->u.abt.cmd_hndl));
 	abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	abt_iocb->handle_to_abort =
 	    cpu_to_le32(MAKE_HANDLE(req->id, aio->u.abt.cmd_hndl));
@@ -3283,7 +3285,7 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 	abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
 	abt_iocb->vp_index = vha->vp_idx;
-	abt_iocb->req_que_no = cpu_to_le16(req->id);
+	abt_iocb->req_que_no = cpu_to_le16(aio->u.abt.req_que_no);
 	/* Send the command to the firmware */
 	wmb();
 }
-- 
2.12.0
