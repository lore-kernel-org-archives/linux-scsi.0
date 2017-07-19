From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 3/7] qla2xxx: Add command completion wq for error path
Date: Wed, 19 Jul 2017 11:51:47 -0700
Message-ID: <20170719185151.8564-4-himanshu.madhani@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:23506
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754965AbdGSSwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 14:52:19 -0400
In-Reply-To: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Duane Grigsby <duane.grigsby@cavium.com>

When NVMe commands encounter error NVMe FC transport needs to
teardown the connection. This patch adds worker thread to process
these IO errors.

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 ++
 drivers/scsi/qla2xxx/qla_nvme.c | 20 +++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1635e98867aa..799d25564ed6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -430,6 +430,7 @@ struct srb_iocb {
 		} nvme;
 	} u;
 
+	struct work_struct rq_work;
 	struct timer_list timer;
 	void (*timeout)(void *);
 };
@@ -4132,6 +4133,7 @@ typedef struct scsi_qla_host {
 	atomic_t	nvme_ref_count;
 	wait_queue_head_t nvme_waitq;
 	struct list_head nvme_rport_list;
+	struct workqueue_struct *nvme_io_wq;
 	atomic_t 	nvme_active_aen_cnt;
 	uint16_t	nvme_last_rptd_aen;
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 11494f2f90b5..7543f533edfb 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -156,6 +156,17 @@ static void qla_nvme_sp_ls_done(void *ptr, int res)
 	qla2x00_rel_sp(sp);
 }
 
+static void qla_nvme_io_work(struct work_struct *work)
+{
+	srb_t *sp;
+	struct srb_iocb *nvme = container_of(work, struct srb_iocb, rq_work);
+	struct nvmefc_fcp_req *fd = nvme->u.nvme.desc;
+	sp = container_of(nvme, srb_t, u.iocb_cmd);
+
+	fd->done(fd);
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
+}
+
 static void qla_nvme_sp_done(void *ptr, int res)
 {
 	srb_t *sp = ptr;
@@ -177,7 +188,13 @@ static void qla_nvme_sp_done(void *ptr, int res)
 		fd->status = 0;
 
 	fd->rcv_rsplen = nvme->u.nvme.rsp_pyld_len;
-	fd->done(fd);
+	if (res == QLA_FUNCTION_FAILED) {
+		INIT_WORK(&nvme->rq_work, qla_nvme_io_work);
+		queue_work(sp->fcport->vha->nvme_io_wq, &nvme->rq_work);
+		return;
+	} else {
+		fd->done(fd);
+	}
 rel:
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
@@ -514,6 +531,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	sp->done = qla_nvme_sp_done;
 	sp->qpair = qpair;
 	nvme = &sp->u.iocb_cmd;
+	INIT_WORK(&nvme->rq_work, qla_nvme_io_work);
 	nvme->u.nvme.desc = fd;
 
 	rval = qla2x00_start_nvme_mq(sp);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 635ce75c630b..3329512b4b35 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2751,7 +2751,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ha->tgt.sess_lock);
 	spin_lock_init(&ha->tgt.atio_lock);
 
-
 	/* Clear our data area */
 	ha->bars = bars;
 	ha->mem_only = mem_only;
@@ -3286,6 +3285,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	base_vha->flags.init_done = 1;
 	base_vha->flags.online = 1;
 	ha->prev_minidump_failed = 0;
+	atomic_set(&base_vha->nvme_active_aen_cnt, 0);
+	base_vha->nvme_io_wq = alloc_workqueue("qlnvme-io-wq", 0, 0);
+	if (!base_vha->nvme_io_wq) {
+		ql_log(ql_log_fatal, base_vha, 0x000b,
+		    "Unable to allocate workqueue for nvme_io_wq\n");
+		goto disable_device;
+	}
 
 	ql_dbg(ql_dbg_init, base_vha, 0x00f2,
 	    "Init done and hba is online.\n");
@@ -3559,6 +3565,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
 	qla_nvme_delete(base_vha);
+	if (base_vha->nvme_io_wq)
+		destroy_workqueue(base_vha->nvme_io_wq);
 
 	dma_free_coherent(&ha->pdev->dev,
 		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
-- 
2.12.0
