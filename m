From: giridhar.malavali@qlogic.com
Subject: [PATCH 09/12] qla2xxx: Fix to ensure driver works in sinlge queue mode if multiqueue fails.
Date: Fri, 31 Jul 2009 15:09:31 -0700
Message-ID: <1249078174-1957-10-git-send-email-giridhar.malavali@qlogic.com>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36802 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753217AbZGaWJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 18:09:41 -0400
In-Reply-To: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

When the multiqueue mode fails to work, the driver falls back on single
queue mode. This ensures that the firmware is reinitialized with single
queue options and all the resources are readjusted accordingly.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    5 ++---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |   21 +++++++++++++++++----
 6 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0f87962..5b0a222 100644
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
index 00aa48d..61c1ae8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2224,6 +2224,7 @@ struct qla_hw_data {
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
+		uint32_t	cpu_affinity_enabled	:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f2ce8e3..0cbe39e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -987,7 +987,6 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				    ha->phy_version);
 				if (rval != QLA_SUCCESS)
 					goto failed;
-
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
@@ -3244,7 +3243,7 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	if (ql2xmultique_tag)
+	if (vha->hw->flags.cpu_affinity_enabled)
 		req = vha->hw->req_q_map[0];
 	else
 		req = vha->req;
@@ -4264,7 +4263,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 		return -EINVAL;
 
 	rval = qla2x00_fw_ready(base_vha);
-	if (ql2xmultique_tag)
+	if (ha->flags.cpu_affinity_enabled)
 		req = ha->req_q_map[0];
 	else
 		req = vha->req;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 13396be..c0ba370 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -852,7 +852,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	struct qla_hw_data *ha = sp->fcport->vha->hw;
 	int affinity = cmd->request->cpu;
 
-	if (ql2xmultique_tag && affinity >= 0 &&
+	if (ha->flags.cpu_affinity_enabled && affinity >= 0 &&
 		affinity < ha->max_rsp_queues - 1)
 		*rsp = ha->rsp_q_map[affinity + 1];
 	 else
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 8fcd99e..b6202fe 100644
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
index f0396e7..1007508 100644
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
@@ -309,6 +312,9 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 				goto fail2;
 			}
 		}
+		ha->flags.cpu_affinity_enabled = 1;
+		ha->wq = create_workqueue("qla2xxx_wq");
+
 		DEBUG2(qla_printk(KERN_INFO, ha,
 			"CPU affinity mode enabled, no. of response"
 			" queues:%d, no. of request queues:%d\n",
@@ -319,6 +325,9 @@ fail2:
 	qla25xx_delete_queues(vha);
 fail:
 	ha->mqenable = 0;
+	kfree(ha->req_q_map);
+	kfree(ha->rsp_q_map);
+	ha->max_req_queues = ha->max_rsp_queues = 1;
 	return 1;
 }
 
@@ -1923,6 +1932,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_init_failed;
 	/* Alloc arrays of request and response ring ptrs */
+que_init:
 	if (!qla2x00_alloc_queues(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		"[ERROR] Failed to allocate memory for queue"
@@ -1959,11 +1969,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
1.6.2.rc1.30.gd43c

