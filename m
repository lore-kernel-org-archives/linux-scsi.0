From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/6] qla2xxx: Remove interrupt request bit check in the response processing path in multiq mode.
Date: Sun,  8 Feb 2009 20:50:11 -0800
Message-ID: <1234155016-6215-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbZBIEuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:22 -0500
In-Reply-To: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Correct response-queue-0 processing by instructing the firmware
to run with interrupt-handshaking disabled, similarly to what is
now done for all non-0 response queues.  Since all
response-queues now run in the same mode, the driver no longer
needs the hot-path 'is-disabled-HCCR' test.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ++----
 drivers/scsi/qla2xxx/qla_init.c |    7 +++----
 drivers/scsi/qla2xxx/qla_isr.c  |   10 ----------
 drivers/scsi/qla2xxx/qla_mbx.c  |   14 ++++++--------
 drivers/scsi/qla2xxx/qla_mid.c  |   10 +++++-----
 5 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index a336b4b..bce5b04 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -376,10 +376,8 @@ extern int qla2x00_dfs_remove(scsi_qla_host_t *);
 
 /* Globa function prototypes for multi-q */
 extern int qla25xx_request_irq(struct rsp_que *);
-extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *,
-	uint8_t);
-extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *,
-	uint8_t);
+extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *);
+extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
 	uint16_t, uint8_t, uint8_t);
 extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6368a1..9865017 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1226,9 +1226,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 			icb->firmware_options_2 |=
 				__constant_cpu_to_le32(BIT_18);
 
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_22);
+		icb->firmware_options_2 &= __constant_cpu_to_le32(~BIT_22);
 		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
-		ha->rsp_q_map[0]->options = icb->firmware_options_2;
 
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
 		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
@@ -3493,7 +3492,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 		rsp = ha->rsp_q_map[i];
 		if (rsp) {
 			rsp->options &= ~BIT_0;
-			ret = qla25xx_init_rsp_que(base_vha, rsp, rsp->options);
+			ret = qla25xx_init_rsp_que(base_vha, rsp);
 			if (ret != QLA_SUCCESS)
 				DEBUG2_17(printk(KERN_WARNING
 					"%s Rsp que:%d init failed\n", __func__,
@@ -3507,7 +3506,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 		if (req) {
 		/* Clear outstanding commands array. */
 			req->options &= ~BIT_0;
-			ret = qla25xx_init_req_que(base_vha, req, req->options);
+			ret = qla25xx_init_req_que(base_vha, req);
 			if (ret != QLA_SUCCESS)
 				DEBUG2_17(printk(KERN_WARNING
 					"%s Req que:%d init failed\n", __func__,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e28ad81..b5554ea 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1707,7 +1707,6 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
-	uint16_t msix_disabled_hccr = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1720,17 +1719,8 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	msix_disabled_hccr = rsp->options;
-	if (!rsp->id)
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_22);
-	else
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_6);
-
 	qla24xx_process_response_queue(rsp);
 
-	if (!msix_disabled_hccr)
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-
 	spin_unlock_irq(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f94ffbb..723cd37 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3090,8 +3090,7 @@ verify_done:
 }
 
 int
-qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
-	uint8_t options)
+qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
 	int rval;
 	unsigned long flags;
@@ -3101,7 +3100,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 	struct qla_hw_data *ha = vha->hw;
 
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
-	mcp->mb[1] = options;
+	mcp->mb[1] = req->options;
 	mcp->mb[2] = MSW(LSD(req->dma));
 	mcp->mb[3] = LSW(LSD(req->dma));
 	mcp->mb[6] = MSW(MSD(req->dma));
@@ -3128,7 +3127,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 	mcp->tov = 60;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (!(options & BIT_0)) {
+	if (!(req->options & BIT_0)) {
 		WRT_REG_DWORD(&reg->req_q_in, 0);
 		WRT_REG_DWORD(&reg->req_q_out, 0);
 	}
@@ -3142,8 +3141,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 }
 
 int
-qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
-	uint8_t options)
+qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	int rval;
 	unsigned long flags;
@@ -3153,7 +3151,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	struct qla_hw_data *ha = vha->hw;
 
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
-	mcp->mb[1] = options;
+	mcp->mb[1] = rsp->options;
 	mcp->mb[2] = MSW(LSD(rsp->dma));
 	mcp->mb[3] = LSW(LSD(rsp->dma));
 	mcp->mb[6] = MSW(MSD(rsp->dma));
@@ -3178,7 +3176,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	mcp->tov = 60;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (!(options & BIT_0)) {
+	if (!(rsp->options & BIT_0)) {
 		WRT_REG_DWORD(&reg->rsp_q_out, 0);
 		WRT_REG_DWORD(&reg->rsp_q_in, 0);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f53179c..d27ceda 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -471,7 +471,7 @@ qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 
 	if (req) {
 		req->options |= BIT_0;
-		ret = qla25xx_init_req_que(vha, req, req->options);
+		ret = qla25xx_init_req_que(vha, req);
 	}
 	if (ret == QLA_SUCCESS)
 		qla25xx_free_req_que(vha, req);
@@ -486,7 +486,7 @@ qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 
 	if (rsp) {
 		rsp->options |= BIT_0;
-		ret = qla25xx_init_rsp_que(vha, rsp, rsp->options);
+		ret = qla25xx_init_rsp_que(vha, rsp);
 	}
 	if (ret == QLA_SUCCESS)
 		qla25xx_free_rsp_que(vha, rsp);
@@ -502,7 +502,7 @@ int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
 
 	req->options |= BIT_3;
 	req->qos = qos;
-	ret = qla25xx_init_req_que(vha, req, req->options);
+	ret = qla25xx_init_req_que(vha, req);
 	if (ret != QLA_SUCCESS)
 		DEBUG2_17(printk(KERN_WARNING "%s failed\n", __func__));
 	/* restore options bit */
@@ -632,7 +632,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 
-	ret = qla25xx_init_req_que(base_vha, req, options);
+	ret = qla25xx_init_req_que(base_vha, req);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
 		mutex_lock(&ha->vport_lock);
@@ -710,7 +710,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (ret)
 		goto que_failed;
 
-	ret = qla25xx_init_rsp_que(base_vha, rsp, options);
+	ret = qla25xx_init_rsp_que(base_vha, rsp);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
 		mutex_lock(&ha->vport_lock);
-- 
1.6.1.48.ge9b8

