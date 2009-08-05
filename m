From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix to ensure driver works in sinlge queue mode if
 multiqueue fails
Date: Wed, 5 Aug 2009 09:18:40 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0908050912520.4821@ac-mac.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:12890 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbZHEQSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 12:18:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com

This is the updated patch. Please apply.
Thanks,
Anirban

When the multiqueue mode fails to work, the driver falls back on single
queue mode. This ensures that the firmware is reinitialized with single
queue options and all the resources are readjusted accordingly.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    5 ++---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |   23 +++++++++++++++++++----
 6 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7363cfe..e03b51f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1670,7 +1670,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	qla24xx_vport_disable(fc_vport, disable);
 
-	if (ql2xmultique_tag) {
+	if (ha->flags.cpu_affinity_enabled) {
 		req = ha->req_q_map[1];
 		goto vport_queue;
 	} else if (ql2xmaxqueues == 1 || !ha->npiv_info)
@@ -1743,7 +1743,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
-	if (vha->req->id && !ql2xmultique_tag) {
+	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
 		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
 			qla_printk(KERN_WARNING, ha,
 				"Queue delete failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 55a5b43..ceb6b89 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2282,6 +2282,7 @@ struct qla_hw_data {
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
+		uint32_t	cpu_affinity_enabled	:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index afe9e9b..2214ece 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1191,7 +1191,6 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				    ha->phy_version);
 				if (rval != QLA_SUCCESS)
 					goto failed;
-
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
@@ -3453,7 +3452,7 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	if (ql2xmultique_tag)
+	if (vha->hw->flags.cpu_affinity_enabled)
 		req = vha->hw->req_q_map[0];
 	else
 		req = vha->req;
@@ -4473,7 +4472,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 		return -EINVAL;
 
 	rval = qla2x00_fw_ready(base_vha);
-	if (ql2xmultique_tag)
+	if (ha->flags.cpu_affinity_enabled)
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 127e0ce..8299a98 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -854,7 +854,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	struct qla_hw_data *ha = sp->fcport->vha->hw;
 	int affinity = cmd->request->cpu;
 
-	if (ql2xmultique_tag && affinity >= 0 &&
+	if (ha->flags.cpu_affinity_enabled && affinity >= 0 &&
 		affinity < ha->max_rsp_queues - 1)
 		*rsp = ha->rsp_q_map[affinity + 1];
 	 else
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7a36678..78bd673 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1507,7 +1507,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (ql2xmultique_tag)
+	if (ha->flags.cpu_affinity_enabled)
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
@@ -2324,7 +2324,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	vha = fcport->vha;
 	ha = vha->hw;
 	req = vha->req;
-	if (ql2xmultique_tag)
+	if (ha->flags.cpu_affinity_enabled)
 		rsp = ha->rsp_q_map[tag + 1];
 	else
 		rsp = req->rsp;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index aa49789..3331137 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -287,9 +287,12 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	int ques, req, ret;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!(ha->fw_attributes & BIT_6)) {
+		qla_printk(KERN_INFO, ha,
+			"Firmware is not multi-queue capable\n");
+		goto fail;
+	}
 	if (ql2xmultique_tag) {
-		/* CPU affinity mode */
-		ha->wq = create_workqueue("qla2xxx_wq");
 		/* create a request queue for IO */
 		options |= BIT_7;
 		req = qla25xx_create_req_que(ha, options, 0, 0, -1,
@@ -299,6 +302,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 				"Can't create request queue\n");
 			goto fail;
 		}
+		ha->wq = create_workqueue("qla2xxx_wq");
 		vha->req = ha->req_q_map[req];
 		options |= BIT_1;
 		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
@@ -309,6 +313,8 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 				goto fail2;
 			}
 		}
+		ha->flags.cpu_affinity_enabled = 1;
+
 		DEBUG2(qla_printk(KERN_INFO, ha,
 			"CPU affinity mode enabled, no. of response"
 			" queues:%d, no. of request queues:%d\n",
@@ -317,8 +323,13 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	return 0;
 fail2:
 	qla25xx_delete_queues(vha);
+	destroy_workqueue(ha->wq);
+	ha->wq = NULL;
 fail:
 	ha->mqenable = 0;
+	kfree(ha->req_q_map);
+	kfree(ha->rsp_q_map);
+	ha->max_req_queues = ha->max_rsp_queues = 1;
 	return 1;
 }
 
@@ -1936,6 +1947,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_init_failed;
 	/* Alloc arrays of request and response ring ptrs */
+que_init:
 	if (!qla2x00_alloc_queues(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		"[ERROR] Failed to allocate memory for queue"
@@ -1972,11 +1984,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	if (ha->mqenable)
-		if (qla25xx_setup_mode(base_vha))
+	if (ha->mqenable) {
+		if (qla25xx_setup_mode(base_vha)) {
 			qla_printk(KERN_WARNING, ha,
 				"Can't create queues, falling back to single"
 				" queue mode\n");
+			goto que_init;
+		}
+	}
 
 	if (ha->flags.running_gold_fw)
 		goto skip_dpc;
-- 
1.6.3.3

