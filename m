From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix a regression due to refactoring in interrupt
 handler code
Date: Tue, 28 Apr 2009 09:28:28 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0904280916550.25672@ac-mac.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:50335 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674AbZD1Qnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 12:43:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: douglas.w.styner@intel.com, andi@firstfloor.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Remove unnecessary search for a response completion host when driver is running
in single queue mode. This should fix the increased cycles seen in 
qla24xx_intr_handler code.

Please apply.
Thanks,
Anirban

Reported-by: Styner, Douglas W <douglas.w.styner@intel.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ++++--
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c  |   38 ++++++++++++++++++--------------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 528913f..088d595 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -294,8 +294,10 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *, uint32_t, uint32_t);
 extern irqreturn_t qla2100_intr_handler(int, void *);
 extern irqreturn_t qla2300_intr_handler(int, void *);
 extern irqreturn_t qla24xx_intr_handler(int, void *);
-extern void qla2x00_process_response_queue(struct rsp_que *);
-extern void qla24xx_process_response_queue(struct rsp_que *);
+extern void qla2x00_process_response_queue(struct scsi_qla_host *,
+	struct rsp_que *);
+extern void qla24xx_process_response_queue(struct scsi_qla_host *,
+	struct rsp_que *);
 
 extern int qla2x00_request_irqs(struct qla_hw_data *, struct rsp_que *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a8abbb9..3d15565 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -399,7 +399,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla2x00_process_response_queue(rsp);
+		qla2x00_process_response_queue(vha, rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -842,7 +842,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
 		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(rsp);
+		qla24xx_process_response_queue(vha, rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d049818..6f1c5ab 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -51,7 +51,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -96,7 +96,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->semaphore, 0);
 			RD_REG_WORD(&reg->semaphore);
 		} else {
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 			RD_REG_WORD(&reg->hccr);
@@ -147,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
@@ -195,7 +195,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 			break;
 		case 0x15:
 			mb[0] = MBA_CMPLT_1_16BIT;
@@ -685,9 +685,9 @@ skip_rio:
 		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 		else
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
@@ -872,17 +872,14 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
  * @ha: SCSI driver HA context
  */
 void
-qla2x00_process_response_queue(struct rsp_que *rsp)
+qla2x00_process_response_queue(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
-	struct scsi_qla_host *vha;
 	struct qla_hw_data *ha = rsp->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
 
-	vha = qla2x00_get_rsp_host(rsp);
-
 	if (!vha->flags.online)
 		return;
 
@@ -1487,12 +1484,9 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
  * @ha: SCSI driver HA context
  */
 void
-qla24xx_process_response_queue(struct rsp_que *rsp)
+qla24xx_process_response_queue(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct sts_entry_24xx *pkt;
-	struct scsi_qla_host *vha;
-
-	vha = qla2x00_get_rsp_host(rsp);
 
 	if (!vha->flags.online)
 		return;
@@ -1626,7 +1620,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1664,7 +1658,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1692,6 +1686,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	struct scsi_qla_host *vha;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1701,10 +1696,11 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
+	vha = pci_get_drvdata(ha->pdev);
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(rsp);
+	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
@@ -1718,6 +1714,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	struct scsi_qla_host *vha;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1730,7 +1727,8 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(rsp);
+	vha = qla2x00_get_rsp_host(rsp);
+	qla24xx_process_response_queue(vha, rsp);
 
 	spin_unlock_irq(&ha->hardware_lock);
 
@@ -1760,7 +1758,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock_irq(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1798,7 +1796,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-- 
1.5.5

