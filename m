From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 5/7] qla2xxx: Simpify unregistration of FC-NVMe local/remote ports
Date: Wed, 19 Jul 2017 11:51:49 -0700
Message-ID: <20170719185151.8564-6-himanshu.madhani@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:13820
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754034AbdGSSwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 14:52:18 -0400
In-Reply-To: <20170719185151.8564-1-himanshu.madhani@cavium.com>
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
 drivers/scsi/qla2xxx/qla_def.h  |  5 ++--
 drivers/scsi/qla2xxx/qla_nvme.c | 59 +++++++----------------------------------
 2 files changed, 12 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 015908f99e76..caee4a2b4002 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2304,7 +2304,7 @@ typedef struct fc_port {
 
 	struct work_struct nvme_del_work;
 	atomic_t nvme_ref_count;
-	wait_queue_head_t nvme_waitq;
+	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
 #define NVME_PRLI_SP_CONF       BIT_7
 #define NVME_PRLI_SP_INITIATOR  BIT_5
@@ -4135,8 +4135,7 @@ typedef struct scsi_qla_host {
 	uint8_t		fabric_node_name[WWN_SIZE];
 
 	struct		nvme_fc_local_port *nvme_local_port;
-	atomic_t	nvme_ref_count;
-	wait_queue_head_t nvme_waitq;
+	struct completion nvme_del_done;
 	struct list_head nvme_rport_list;
 	struct workqueue_struct *nvme_io_wq;
 	atomic_t 	nvme_active_aen_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 4cb5bd20065a..ccafcdb228e8 100644
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
@@ -250,7 +248,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	sp->name = "nvme_ls";
 	sp->done = qla_nvme_sp_ls_done;
 	atomic_set(&sp->ref_count, 1);
-	init_waitqueue_head(&sp->nvme_ls_waitq);
 	nvme = &sp->u.iocb_cmd;
 	priv->sp = sp;
 	priv->fd = fd;
@@ -558,12 +555,10 @@ static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
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
@@ -574,8 +569,6 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 	fcport = rport->private;
 	fcport->nvme_remote_port = NULL;
 	fcport->nvme_flag &= ~NVME_FLAG_REGISTERED;
-	atomic_dec(&fcport->nvme_ref_count);
-	wake_up_all(&fcport->nvme_waitq);
 
 	list_for_each_entry_safe(r_port, trport,
 	    &fcport->vha->nvme_rport_list, list) {
@@ -585,6 +578,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 		}
 	}
 	kfree(r_port);
+	complete(&fcport->nvme_del_done);
 
 	ql_log(ql_log_info, fcport->vha, 0x2110,
 	    "remoteport_delete of %p completed.\n", fcport);
@@ -627,12 +621,11 @@ static int qla_nvme_wait_on_command(srb_t *sp)
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
@@ -651,39 +644,6 @@ void qla_nvme_abort(struct qla_hw_data *ha, struct srb *sp)
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
@@ -719,12 +679,13 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
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
@@ -733,6 +694,8 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
 		else
 			ql_log(ql_log_info, vha, 0x2115,
 			    "Unregister of localport failed\n");
+		wait_for_completion_timeout(&vha->nvme_del_done,
+		    msecs_to_jiffies(5000));
 	}
 }
 
@@ -773,7 +736,5 @@ void qla_nvme_register_hba(struct scsi_qla_host *vha)
 		    "register_localport failed: ret=%x\n", ret);
 		return;
 	}
-	atomic_set(&vha->nvme_ref_count, 1);
 	vha->nvme_local_port->private = vha;
-	init_waitqueue_head(&vha->nvme_waitq);
 }
-- 
2.12.0
