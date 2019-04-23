From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qedf: remove set but not used variables
Date: Tue, 23 Apr 2019 22:41:38 +0800
Message-ID: <20190423144138.20428-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warnings:

drivers/scsi/qedf/qedf_els.c: In function 'qedf_process_els_compl':
drivers/scsi/qedf/qedf_els.c:149:20: warning: variable 'sc_cmd' set but not used [-Wunused-but-set-variable]
drivers/scsi/qedf/qedf_els.c:148:28: warning: variable 'task_ctx' set but not used [-Wunused-but-set-variable]
drivers/scsi/qedf/qedf_els.c: In function 'qedf_send_srr':
drivers/scsi/qedf/qedf_els.c:612:6: warning: variable 'sid' set but not used [-Wunused-but-set-variable]

They are never used since introduction.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/qedf/qedf_els.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 1781e73..d900c89e 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -145,9 +145,6 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 void qedf_process_els_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	struct qedf_ioreq *els_req)
 {
-	struct fcoe_task_context *task_ctx;
-	struct scsi_cmnd *sc_cmd;
-	uint16_t xid;
 	struct fcoe_cqe_midpath_info *mp_info;
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered with xid = 0x%x"
@@ -158,10 +155,6 @@ void qedf_process_els_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	/* Kill the ELS timer */
 	cancel_delayed_work(&els_req->timeout_work);
 
-	xid = els_req->xid;
-	task_ctx = qedf_get_task_mem(&qedf->tasks, xid);
-	sc_cmd = els_req->sc_cmd;
-
 	/* Get ELS response length from CQE */
 	mp_info = &cqe->cqe_info.midpath_info;
 	els_req->mp_req.resp_len = mp_info->data_placement_size;
@@ -609,7 +602,7 @@ static int qedf_send_srr(struct qedf_ioreq *orig_io_req, u32 offset, u8 r_ctl)
 	struct qedf_rport *fcport;
 	struct fc_lport *lport;
 	struct qedf_els_cb_arg *cb_arg = NULL;
-	u32 sid, r_a_tov;
+	u32 r_a_tov;
 	int rc;
 
 	if (!orig_io_req) {
@@ -635,7 +628,6 @@ static int qedf_send_srr(struct qedf_ioreq *orig_io_req, u32 offset, u8 r_ctl)
 
 	qedf = fcport->qedf;
 	lport = qedf->lport;
-	sid = fcport->sid;
 	r_a_tov = lport->r_a_tov;
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending SRR orig_io=%p, "
-- 
2.7.0
