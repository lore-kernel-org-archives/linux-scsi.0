From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/15] qla2xxx: Add CPU affinity support.
Date: Mon,  6 Apr 2009 22:33:41 -0700
Message-ID: <1239082431-19496-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZDGFeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:04 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Set the module parameter ql2xmultique_tag to 1 to enable this
feature. In this mode, the total number of response queues
created is equal to the number of online cpus. Turning the block
layer's rq_affinity mode on enables requests to be routed to the
proper cpu and at the same time it enables completion of the IO
in a response queue that is affined to the cpu in the request
path.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 +-
 drivers/scsi/qla2xxx/qla_def.h  |    2 +
 drivers/scsi/qla2xxx/qla_iocb.c |   22 ++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   22 ++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 ++++-
 drivers/scsi/qla2xxx/qla_mid.c  |   11 +++++
 drivers/scsi/qla2xxx/qla_os.c   |   78 ++++++++++++++++++++++++++++++++++++++-
 7 files changed, 140 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bda6658..f3536e5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1531,7 +1531,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	qla24xx_vport_disable(fc_vport, disable);
 
 	ret = 0;
-	if (ha->cur_vport_count <= ha->flex_port_count
+	if (ha->cur_vport_count <= ha->flex_port_count || ql2xmultique_tag
 		|| ha->max_req_queues == 1 || !ha->npiv_info)
 		goto vport_queue;
 	/* Create a request queue in QoS mode for the vport */
@@ -1599,7 +1599,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
-	if (vha->req->id) {
+	if (vha->req->id && !ql2xmultique_tag) {
 		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
 			qla_printk(KERN_WARNING, ha,
 				"Queue delete failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 57d659c..09190ba 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2171,6 +2171,7 @@ struct rsp_que {
 	struct qla_msix_entry *msix;
 	struct req_que *req;
 	srb_t *status_srb; /* status continuation entry */
+	struct work_struct q_work;
 };
 
 /* Request queue data structure */
@@ -2539,6 +2540,7 @@ struct qla_hw_data {
 	struct qla_chip_state_84xx *cs84xx;
 	struct qla_statistics qla_stats;
 	struct isp_operations *isp_ops;
+	struct workqueue_struct *wq;
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 94b69d8..7b15ded 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -15,6 +15,7 @@ static request_t *qla2x00_req_pkt(struct scsi_qla_host *, struct req_que *,
 							struct rsp_que *rsp);
 static void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
 
+static void qla25xx_set_que(srb_t *, struct req_que **, struct rsp_que **);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
  * @cmd: SCSI command
@@ -726,8 +727,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Setup device pointers. */
 	ret = 0;
 
-	req = vha->req;
-	rsp = ha->rsp_q_map[0];
+	qla25xx_set_que(sp, &req, &rsp);
 	sp->que = req;
 
 	/* So we know we haven't pci_map'ed anything yet */
@@ -850,3 +850,21 @@ queuing_error:
 
 	return QLA_FUNCTION_FAILED;
 }
+
+static void qla25xx_set_que(srb_t *sp, struct req_que **req,
+	struct rsp_que **rsp)
+{
+	struct scsi_cmnd *cmd = sp->cmd;
+	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	int affinity = cmd->request->cpu;
+
+	if (ql2xmultique_tag && affinity >= 0 &&
+		affinity < ha->max_rsp_queues - 1) {
+		*rsp = ha->rsp_q_map[affinity + 1];
+		*req = ha->req_q_map[1];
+	} else {
+		*req = vha->req;
+		*rsp = ha->rsp_q_map[0];
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c8e906c..41e50c2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1718,6 +1718,25 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 }
 
 static irqreturn_t
+qla25xx_msix_rsp_q(int irq, void *dev_id)
+{
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
+
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
+
+	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
 qla24xx_msix_default(int irq, void *dev_id)
 {
 	scsi_qla_host_t	*vha;
@@ -1806,9 +1825,10 @@ struct qla_init_msix_entry {
 	irq_handler_t handler;
 };
 
-static struct qla_init_msix_entry msix_entries[2] = {
+static struct qla_init_msix_entry msix_entries[3] = {
 	{ "qla2xxx (default)", qla24xx_msix_default },
 	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
+	{ "qla2xxx (multiq)", qla25xx_msix_rsp_q },
 };
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bfdc89f..366522e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1497,7 +1497,10 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	req = vha->req;
+	if (ql2xmultique_tag)
+		req = ha->req_q_map[0];
+	else
+		req = vha->req;
 	rsp = req->rsp;
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
@@ -2311,7 +2314,10 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	vha = fcport->vha;
 	ha = vha->hw;
 	req = vha->req;
-	rsp = req->rsp;
+	if (ql2xmultique_tag)
+		rsp = ha->rsp_q_map[tag + 1];
+	else
+		rsp = req->rsp;
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 9c08479..650bcef 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -633,6 +633,15 @@ que_failed:
 	return 0;
 }
 
+static void qla_do_work(struct work_struct *work)
+{
+	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
+	struct scsi_qla_host *vha;
+
+	vha = qla25xx_get_host(rsp);
+	qla24xx_process_response_queue(vha, rsp);
+}
+
 /* create response queue */
 int
 qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
@@ -711,6 +720,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		rsp->req = NULL;
 
 	qla2x00_init_response_q_entries(rsp);
+	if (rsp->hw->wq)
+		INIT_WORK(&rsp->q_work, qla_do_work);
 	return rsp->id;
 
 que_failed:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a64a094..0ca92f2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -96,6 +96,13 @@ MODULE_PARM_DESC(ql2xmaxqueues,
 		"Enables MQ settings "
 		"Default is 1 for single queue. Set it to number \
 			of queues in MQ mode.");
+
+int ql2xmultique_tag;
+module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xmultique_tag,
+		"Enables CPU affinity settings for the driver "
+		"Default is 0 for no affinity of request and response IO. "
+		"Set it to 1 to turn on the cpu affinity.");
 /*
  * SCSI host template entry points
  */
@@ -256,6 +263,47 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	ha->rsp_q_map = NULL;
 }
 
+static int qla25xx_setup_mode(struct scsi_qla_host *vha)
+{
+	uint16_t options = 0;
+	int ques, req, ret;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (ql2xmultique_tag) {
+		/* CPU affinity mode */
+		ha->wq = create_workqueue("qla2xxx_wq");
+		/* create a request queue for IO */
+		options |= BIT_7;
+		req = qla25xx_create_req_que(ha, options, 0, 0, -1,
+			QLA_DEFAULT_QUE_QOS);
+		if (!req) {
+			qla_printk(KERN_WARNING, ha,
+				"Can't create request queue\n");
+			goto fail;
+		}
+		vha->req = ha->req_q_map[req];
+		options |= BIT_1;
+		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
+			ret = qla25xx_create_rsp_que(ha, options, 0, 0, req);
+			if (!ret) {
+				qla_printk(KERN_WARNING, ha,
+					"Response Queue create failed\n");
+				goto fail2;
+			}
+		}
+		DEBUG2(qla_printk(KERN_INFO, ha,
+			"CPU affinity mode enabled, no. of response"
+			" queues:%d, no. of request queues:%d\n",
+			ha->max_rsp_queues, ha->max_req_queues));
+	}
+	return 0;
+fail2:
+	qla25xx_delete_queues(vha);
+fail:
+	ha->mqenable = 0;
+	return 1;
+}
+
 static char *
 qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
@@ -998,6 +1046,9 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		if (qla2x00_vp_abort_isp(vha))
 			goto eh_host_reset_lock;
 	} else {
+		if (ha->wq)
+			flush_workqueue(ha->wq);
+
 		set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 		if (qla2x00_abort_isp(base_vha)) {
 			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
@@ -1521,6 +1572,7 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 {
 	resource_size_t pio;
 	uint16_t msix;
+	int cpus;
 
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
@@ -1575,7 +1627,7 @@ skip_pio:
 
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
-	if (ql2xmaxqueues <= 1  &&
+	if ((ql2xmaxqueues <= 1 || ql2xmultique_tag < 1) &&
 		(!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
@@ -1584,12 +1636,21 @@ skip_pio:
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
 		ha->msix_count = msix;
-		if (ql2xmaxqueues > 1) {
+		/* Max queues are bounded by available msix vectors */
+		/* queue 0 uses two msix vectors */
+		if (ql2xmultique_tag) {
+			cpus = num_online_cpus();
+			ha->max_rsp_queues = (ha->msix_count - 1 - cpus) ?
+				(cpus + 1) : (ha->msix_count - 1);
+			ha->max_req_queues = 2;
+		} else if (ql2xmaxqueues > 1) {
 			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
 						QLA_MQ_SIZE : ql2xmaxqueues;
 			DEBUG2(qla_printk(KERN_INFO, ha, "QoS mode set, max no"
 			" of request queues:%d\n", ha->max_req_queues));
 		}
+		qla_printk(KERN_INFO, ha,
+			"MSI-X vector count: %d\n", msix);
 	} else
 		qla_printk(KERN_INFO, ha, "BAR 3 not enabled\n");
 
@@ -1871,6 +1932,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
+	if (ha->mqenable)
+		if (qla25xx_setup_mode(base_vha))
+			qla_printk(KERN_WARNING, ha,
+				"Can't create queues, falling back to single"
+				" queue mode\n");
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1982,6 +2049,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	base_vha->flags.online = 0;
 
+	/* Flush the work queue and remove it */
+	if (ha->wq) {
+		flush_workqueue(ha->wq);
+		destroy_workqueue(ha->wq);
+		ha->wq = NULL;
+	}
+
 	/* Kill the kernel thread for this host */
 	if (ha->dpc_thread) {
 		struct task_struct *t = ha->dpc_thread;
-- 
1.6.2.2.404.ge96f3

