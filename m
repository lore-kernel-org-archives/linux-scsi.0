From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/20] qla2xxx: Correct NULL pointer bug in cpu affinity mode.
Date: Wed,  3 Jun 2009 09:55:19 -0700
Message-ID: <1244048131-56590-9-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZFCQzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:38 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

This patch fixes a NULL pointer bug that occurs when IO is being
carried out on a vport for which the cpu affinity mode is turned on.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   15 ++++++++++-----
 drivers/scsi/qla2xxx/qla_iocb.c |   16 ++++++----------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2bd017f..74e6970 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1595,6 +1595,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	struct qla_hw_data *ha = base_vha->hw;
 	uint16_t options = 0;
 	int	cnt;
+	struct req_que *req = ha->req_q_map[0];
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
@@ -1650,14 +1651,16 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	qla24xx_vport_disable(fc_vport, disable);
 
-	ret = 0;
-	if (ql2xmaxqueues == 1 || ql2xmultique_tag || !ha->npiv_info)
+	if (ql2xmultique_tag) {
+		req = ha->req_q_map[1];
+		goto vport_queue;
+	} else if (ql2xmaxqueues == 1 || !ha->npiv_info)
 		goto vport_queue;
 	/* Create a request queue in QoS mode for the vport */
 	for (cnt = 0; cnt < ha->nvram_npiv_size; cnt++) {
 		if (memcmp(ha->npiv_info[cnt].port_name, vha->port_name, 8) == 0
 			&& memcmp(ha->npiv_info[cnt].node_name, vha->node_name,
-			8) == 0) {
+					8) == 0) {
 			qos = ha->npiv_info[cnt].q_qos;
 			break;
 		}
@@ -1669,14 +1672,16 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			qla_printk(KERN_WARNING, ha,
 			"Can't create request queue for vp_idx:%d\n",
 			vha->vp_idx);
-		else
+		else {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			"Request Que:%d (QoS: %d) created for vp_idx:%d\n",
 			ret, qos, vha->vp_idx));
+			req = ha->req_q_map[ret];
+		}
 	}
 
 vport_queue:
-	vha->req = ha->req_q_map[ret];
+	vha->req = req;
 	return 0;
 
 vport_create_failed_2:
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b4c6010..13396be 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -15,7 +15,7 @@ static request_t *qla2x00_req_pkt(struct scsi_qla_host *, struct req_que *,
 							struct rsp_que *rsp);
 static void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
 
-static void qla25xx_set_que(srb_t *, struct req_que **, struct rsp_que **);
+static void qla25xx_set_que(srb_t *, struct rsp_que **);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
  * @cmd: SCSI command
@@ -722,7 +722,8 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Setup device pointers. */
 	ret = 0;
 
-	qla25xx_set_que(sp, &req, &rsp);
+	qla25xx_set_que(sp, &rsp);
+	req = vha->req;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -845,20 +846,15 @@ queuing_error:
 	return QLA_FUNCTION_FAILED;
 }
 
-static void qla25xx_set_que(srb_t *sp, struct req_que **req,
-	struct rsp_que **rsp)
+static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
-	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = sp->fcport->vha->hw;
 	int affinity = cmd->request->cpu;
 
 	if (ql2xmultique_tag && affinity >= 0 &&
-		affinity < ha->max_rsp_queues - 1) {
+		affinity < ha->max_rsp_queues - 1)
 		*rsp = ha->rsp_q_map[affinity + 1];
-		*req = ha->req_q_map[1];
-	} else {
-		*req = vha->req;
+	 else
 		*rsp = ha->rsp_q_map[0];
-	}
 }
-- 
1.6.3.1.244.gf9275

