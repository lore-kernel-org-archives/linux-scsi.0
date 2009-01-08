From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix ISP restart bug in multiq code
Date: Thu, 8 Jan 2009 15:41:08 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0901081534340.47938@n5129avbmxjp91.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:19013 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZAHXlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 18:41:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

After restarting ISP the additional queues are not being setup correctly. The 
following patch fixes the issue.
Please apply.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_init.c |   58 ++++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_mid.c  |    1 +
 drivers/scsi/qla2xxx/qla_os.c   |    7 ++---
 3 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2d4f32b..9ad4d09 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1258,35 +1258,48 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 {
 	int	rval;
 	unsigned long flags = 0;
-	int cnt;
+	int cnt, que;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[0];
-	struct rsp_que *rsp = ha->rsp_q_map[0];
+	struct req_que *req;
+	struct rsp_que *rsp;
+	struct scsi_qla_host *vp;
 	struct mid_init_cb_24xx *mid_init_cb =
 	    (struct mid_init_cb_24xx *) ha->init_cb;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Clear outstanding commands array. */
-	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
-		req->outstanding_cmds[cnt] = NULL;
+	for (que = 0; que < ha->max_queues; que++) {
+		req = ha->req_q_map[que];
+		if (!req)
+			continue;
+		for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
+			req->outstanding_cmds[cnt] = NULL;
 
-	req->current_outstanding_cmd = 0;
+		req->current_outstanding_cmd = 0;
 
-	/* Clear RSCN queue. */
-	vha->rscn_in_ptr = 0;
-	vha->rscn_out_ptr = 0;
+		/* Initialize firmware. */
+		req->ring_ptr  = req->ring;
+		req->ring_index    = 0;
+		req->cnt      = req->length;
+	}
 
-	/* Initialize firmware. */
-	req->ring_ptr  = req->ring;
-	req->ring_index    = 0;
-	req->cnt      = req->length;
-	rsp->ring_ptr = rsp->ring;
-	rsp->ring_index    = 0;
+	for (que = 0; que < ha->max_queues; que++) {
+		rsp = ha->rsp_q_map[que];
+		if (!rsp)
+			continue;
+		rsp->ring_ptr = rsp->ring;
+		rsp->ring_index    = 0;
 
-	/* Initialize response queue entries */
-	qla2x00_init_response_q_entries(rsp);
+		/* Initialize response queue entries */
+		qla2x00_init_response_q_entries(rsp);
+	}
 
+	/* Clear RSCN queue. */
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		vp->rscn_in_ptr = 0;
+		vp->rscn_out_ptr = 0;
+	}
 	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3212,8 +3225,8 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 	int rval = QLA_SUCCESS;
 	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[0];
-	struct rsp_que *rsp = ha->rsp_q_map[0];
+	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct rsp_que *rsp = req->rsp;
 
 	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
@@ -3492,6 +3505,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 		}
 		req = ha->req_q_map[i];
 		if (req) {
+		/* Clear outstanding commands array. */
 			req->options &= ~BIT_0;
 			ret = qla25xx_init_req_que(base_vha, req, req->options);
 			if (ret != QLA_SUCCESS)
@@ -3500,7 +3514,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 						req->id));
 			else
 				DEBUG2_17(printk(KERN_WARNING
-					"%s Rsp que:%d inited\n", __func__,
+					"%s Req que:%d inited\n", __func__,
 						req->id));
 		}
 	}
@@ -4151,8 +4165,8 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	struct req_que *req = ha->req_q_map[0];
-	struct rsp_que *rsp = ha->rsp_q_map[0];
+	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct rsp_que *rsp = req->rsp;
 
 	if (!vha->vp_idx)
 		return -EINVAL;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 8863231..f53179c 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -629,6 +629,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->ring_index = 0;
 	req->cnt = req->length;
 	req->id = que_id;
+	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 
 	ret = qla25xx_init_req_que(base_vha, req, options);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4a71f52..cf32653 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1158,8 +1158,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
-		req = ha->req_q_map[vha->req_ques[que]];
+	for (que = 0; que < ha->max_queues; que++) {
+		req = ha->req_q_map[que];
 		if (!req)
 			continue;
 		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
@@ -1193,7 +1193,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
-	struct req_que *req = ha->req_q_map[0];
+	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
 
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, req->max_q_depth);
@@ -1998,7 +1998,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 probe_failed:
-	qla2x00_free_que(ha, req, rsp);
 	qla2x00_free_device(base_vha);
 
 	scsi_host_put(base_vha->host);
-- 
1.5.5

