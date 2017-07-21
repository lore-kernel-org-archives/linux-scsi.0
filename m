From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 4/6] qla2xxx: Simpify unregistration of FC-NVMe local/remote ports
Date: Fri, 21 Jul 2017 09:32:26 -0700
Message-ID: <20170721163228.32339-5-himanshu.madhani@cavium.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0069.outbound.protection.outlook.com ([104.47.33.69]:25872
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754487AbdGUQck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 12:32:40 -0400
In-Reply-To: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Simplified waiting for unregister local/remote FC-NVMe ports
to complete cleanup.

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  6 ++---
 drivers/scsi/qla2xxx/qla_nvme.c | 59 +++++++----------------------------------
 2 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5ceb50161d89..b3e3982a9db0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2302,8 +2302,7 @@ typedef struct fc_port {
 	unsigned int login_succ:1;
 
 	struct work_struct nvme_del_work;
-	atomic_t nvme_ref_count;
-	wait_queue_head_t nvme_waitq;
+	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
 #define NVME_PRLI_SP_CONF       BIT_7
 #define NVME_PRLI_SP_INITIATOR  BIT_5
@@ -4134,8 +4133,7 @@ typedef struct scsi_qla_host {
 	uint8_t		fabric_node_name[WWN_SIZE];
 
 	struct		nvme_fc_local_port *nvme_local_port;
-	atomic_t	nvme_ref_count;
-	wait_queue_head_t nvme_waitq;
+	struct completion nvme_del_done;
 	struct list_head nvme_rport_list;
 	atomic_t 	nvme_active_aen_cnt;
 	uint16_t	nvme_last_rptd_aen;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index eecbe8bc4890..6c5eebbbda4c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -75,8 +75,6 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 
 	fcport->nvme_remote_port->private = fcport;
 	fcport->nvme_flag |= NVME_FLAG_REGISTERED;
-	atomic_set(&fcport->nvme_ref_count, 1);
-	init_waitqueue_head(&fcport->nvme_waitq);
 	rport->fcport = fcport;
 	list_add_tail(&rport->list, &vha->nvme_rport_list);
 	return 0;
@@ -233,7 +231,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	sp->name = "nvme_ls";
 	sp->done = qla_nvme_sp_ls_done;
 	atomic_set(&sp->ref_count, 1);
-	init_waitqueue_head(&sp->nvme_ls_waitq);
 	nvme = &sp->u.iocb_cmd;
 	priv->sp = sp;
 	priv->fd = fd;
@@ -540,12 +537,10 @@ static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
 {
 	struct scsi_qla_host *vha = lport->private;
 
-	atomic_dec(&vha->nvme_ref_count);
-	wake_up_all(&vha->nvme_waitq);
-
 	ql_log(ql_log_info, vha, 0x210f,
 	    "localport delete of %p completed.\n", vha->nvme_local_port);
 	vha->nvme_local_port = NULL;
+	complete(&vha->nvme_del_done);
 }
 
 static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
@@ -556,8 +551,6 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 	fcport = rport->private;
 	fcport->nvme_remote_port = NULL;
 	fcport->nvme_flag &= ~NVME_FLAG_REGISTERED;
-	atomic_dec(&fcport->nvme_ref_count);
-	wake_up_all(&fcport->nvme_waitq);
 
 	list_for_each_entry_safe(r_port, trport,
 	    &fcport->vha->nvme_rport_list, list) {
@@ -567,6 +560,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 		}
 	}
 	kfree(r_port);
+	complete(&fcport->nvme_del_done);
 
 	ql_log(ql_log_info, fcport->vha, 0x2110,
 	    "remoteport_delete of %p completed.\n", fcport);
@@ -609,12 +603,11 @@ static int qla_nvme_wait_on_command(srb_t *sp)
 static int qla_nvme_wait_on_rport_del(fc_port_t *fcport)
 {
 	int ret = QLA_SUCCESS;
+	int timeout;
 
-	wait_event_timeout(fcport->nvme_waitq,
-	    atomic_read(&fcport->nvme_ref_count),
-	    NVME_ABORT_POLLING_PERIOD*HZ);
-
-	if (atomic_read(&fcport->nvme_ref_count)) {
+	timeout = wait_for_completion_timeout(&fcport->nvme_del_done,
+	    msecs_to_jiffies(2000));
+	if (!timeout) {
 		ret = QLA_FUNCTION_FAILED;
 		ql_log(ql_log_info, fcport->vha, 0x2111,
 		    "timed out waiting for fcport=%p to delete\n", fcport);
@@ -633,39 +626,6 @@ void qla_nvme_abort(struct qla_hw_data *ha, struct srb *sp)
 		    "nvme_wait_on_comand timed out waiting on sp=%p\n", sp);
 }
 
-static void qla_nvme_abort_all(fc_port_t *fcport)
-{
-	int que, cnt;
-	unsigned long flags;
-	srb_t *sp;
-	struct qla_hw_data *ha = fcport->vha->hw;
-	struct req_que *req;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_req_queues; que++) {
-		req = ha->req_q_map[que];
-		if (!req)
-			continue;
-		if (!req->outstanding_cmds)
-			continue;
-		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if ((sp) && ((sp->type == SRB_NVME_CMD) ||
-			    (sp->type == SRB_NVME_LS)) &&
-				(sp->fcport == fcport)) {
-				atomic_inc(&sp->ref_count);
-				spin_unlock_irqrestore(&ha->hardware_lock,
-				    flags);
-				qla_nvme_abort(ha, sp);
-				spin_lock_irqsave(&ha->hardware_lock, flags);
-				req->outstanding_cmds[cnt] = NULL;
-				sp->done(sp, 1);
-			}
-		}
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
 static void qla_nvme_unregister_remote_port(struct work_struct *work)
 {
 	struct fc_port *fcport = container_of(work, struct fc_port,
@@ -701,12 +661,13 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
 		ql_log(ql_log_info, fcport->vha, 0x2114, "%s: fcport=%p\n",
 		    __func__, fcport);
 
+		init_completion(&fcport->nvme_del_done);
 		nvme_fc_unregister_remoteport(fcport->nvme_remote_port);
 		qla_nvme_wait_on_rport_del(fcport);
-		qla_nvme_abort_all(fcport);
 	}
 
 	if (vha->nvme_local_port) {
+		init_completion(&vha->nvme_del_done);
 		nv_ret = nvme_fc_unregister_localport(vha->nvme_local_port);
 		if (nv_ret == 0)
 			ql_log(ql_log_info, vha, 0x2116,
@@ -715,6 +676,8 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
 		else
 			ql_log(ql_log_info, vha, 0x2115,
 			    "Unregister of localport failed\n");
+		wait_for_completion_timeout(&vha->nvme_del_done,
+		    msecs_to_jiffies(5000));
 	}
 }
 
@@ -755,7 +718,5 @@ void qla_nvme_register_hba(struct scsi_qla_host *vha)
 		    "register_localport failed: ret=%x\n", ret);
 		return;
 	}
-	atomic_set(&vha->nvme_ref_count, 1);
 	vha->nvme_local_port->private = vha;
-	init_waitqueue_head(&vha->nvme_waitq);
 }
-- 
2.12.0
