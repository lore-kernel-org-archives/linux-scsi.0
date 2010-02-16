From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/1] qla2xxx: Obtain proper host structure during response-queue processing.
Date: Mon, 15 Feb 2010 16:42:09 -0800
Message-ID: <1266280929-12445-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1266280929-12445-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50352 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S932384Ab0BPAmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 19:42:11 -0500
In-Reply-To: <1266280929-12445-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@kroah.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Original code incorrectly assumed only status-type-0
IOCBs would be queued to the response-queue, and thus all
entries would safely reference a VHA from the IOCB
'handle.'
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_isr.c |   29 +----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |    6 +++++-
 3 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f3d1d1a..65ef03c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -453,6 +453,5 @@ extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern struct scsi_qla_host * qla25xx_get_host(struct rsp_que *);
 
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b20a716..b79481e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2018,7 +2018,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	vha = qla25xx_get_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->mqenable) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -2357,30 +2357,3 @@ int qla25xx_request_irq(struct rsp_que *rsp)
 	msix->rsp = rsp;
 	return ret;
 }
-
-struct scsi_qla_host *
-qla25xx_get_host(struct rsp_que *rsp)
-{
-	srb_t *sp;
-	struct qla_hw_data *ha = rsp->hw;
-	struct scsi_qla_host *vha = NULL;
-	struct sts_entry_24xx *pkt;
-	struct req_que *req;
-	uint16_t que;
-	uint32_t handle;
-
-	pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
-	que = MSW(pkt->handle);
-	handle = (uint32_t) LSW(pkt->handle);
-	req = ha->req_q_map[que];
-	if (handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = req->outstanding_cmds[handle];
-		if (sp)
-			return  sp->fcport->vha;
-		else
-			goto base_que;
-	}
-base_que:
-	vha = pci_get_drvdata(ha->pdev);
-	return vha;
-}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e07b361..4a69cc8 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -638,11 +638,15 @@ failed:
 
 static void qla_do_work(struct work_struct *work)
 {
+	unsigned long flags;
 	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
 	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha = rsp->hw;
 
-	vha = qla25xx_get_host(rsp);
+	spin_lock_irqsave(&rsp->hw->hardware_lock, flags);
+	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
+	spin_unlock_irqrestore(&rsp->hw->hardware_lock, flags);
 }
 
 /* create response queue */
-- 
1.6.2.rc1.30.gd43c

