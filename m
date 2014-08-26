From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH RESEND 3/6] qla2xxx: Collect PCI register checks and board_disable scheduling
Date: Tue, 26 Aug 2014 17:11:41 -0400
Message-ID: <1409087501-18788-1-git-send-email-joe.lawrence@stratus.com>
References: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:47899 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaHZVNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 17:13:24 -0400
In-Reply-To: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Add an uint16_t variant of qla2x00_check_reg_for_disconnect and use
these routines to check and schedule a PCI-disconnected board from a
centralized place.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    3 ++-
 drivers/scsi/qla2xxx/qla_isr.c |   28 +++++++++++++---------------
 drivers/scsi/qla2xxx/qla_mr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |    6 +++---
 drivers/scsi/qla2xxx/qla_os.c  |    8 +-------
 5 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d646540..43ef0db 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -475,7 +475,8 @@ extern uint8_t *qla25xx_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
 extern int qla25xx_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
 				    uint32_t);
 extern int qla2x00_is_a_vp_did(scsi_qla_host_t *, uint32_t);
-bool qla2x00_check_reg_for_disconnect(scsi_qla_host_t *, uint32_t);
+bool qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *, uint32_t);
+bool qla2x00_check_reg16_for_disconnect(scsi_qla_host_t *, uint16_t);
 
 extern int qla2x00_beacon_on(struct scsi_qla_host *);
 extern int qla2x00_beacon_off(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bea0e74..016ebed 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -56,16 +56,8 @@ qla2100_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
-		/* Check for PCI disconnection */
-		if (hccr == 0xffff) {
-			/*
-			 * Schedule this on the default system workqueue so that
-			 * all the adapter workqueues and the DPC thread can be
-			 * shutdown cleanly.
-			 */
-			schedule_work(&ha->board_disable);
+		if (qla2x00_check_reg16_for_disconnect(vha, hccr))
 			break;
-		}
 		if (hccr & HCCR_RISC_PAUSE) {
 			if (pci_channel_offline(ha->pdev))
 				break;
@@ -121,7 +113,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 }
 
 bool
-qla2x00_check_reg_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
+qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 {
 	/* Check for PCI disconnection */
 	if (reg == 0xffffffff) {
@@ -136,6 +128,12 @@ qla2x00_check_reg_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 		return false;
 }
 
+bool
+qla2x00_check_reg16_for_disconnect(scsi_qla_host_t *vha, uint16_t reg)
+{
+	return qla2x00_check_reg32_for_disconnect(vha, 0xffff0000 | reg);
+}
+
 /**
  * qla2300_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
  * @irq:
@@ -174,7 +172,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-		if (qla2x00_check_reg_for_disconnect(vha, stat))
+		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSR_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
@@ -2631,7 +2629,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
-		if (qla2x00_check_reg_for_disconnect(vha, stat))
+		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
@@ -2721,7 +2719,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	 * we process the response queue.
 	 */
 	stat = RD_REG_DWORD(&reg->host_status);
-	if (qla2x00_check_reg_for_disconnect(vha, stat))
+	if (qla2x00_check_reg32_for_disconnect(vha, stat))
 		goto out;
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->flags.disable_msix_handshake) {
@@ -2761,7 +2759,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 		hccr = RD_REG_DWORD_RELAXED(&reg->hccr);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
-	if (qla2x00_check_reg_for_disconnect(vha, hccr))
+	if (qla2x00_check_reg32_for_disconnect(vha, hccr))
 		goto out;
 	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
 
@@ -2796,7 +2794,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
-		if (qla2x00_check_reg_for_disconnect(vha, stat))
+		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4775baa..8ecf6de 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2924,7 +2924,7 @@ qlafx00_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; clr_intr = 0) {
 		stat = QLAFX00_RD_INTR_REG(ha);
-		if (qla2x00_check_reg_for_disconnect(vha, stat))
+		if (qla2x00_check_reg32_for_disconnect(vha, stat))
 			break;
 		intr_stat = stat & QLAFX00_HST_INT_STS_BITS;
 		if (!intr_stat)
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 58f3c91..2562600 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2123,7 +2123,7 @@ qla82xx_msix_default(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	do {
 		host_int = RD_REG_DWORD(&reg->host_int);
-		if (qla2x00_check_reg_for_disconnect(vha, host_int))
+		if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 			break;
 		if (host_int) {
 			stat = RD_REG_DWORD(&reg->host_status);
@@ -2184,7 +2184,7 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	host_int = RD_REG_DWORD(&reg->host_int);
-	if (qla2x00_check_reg_for_disconnect(vha, host_int))
+	if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 		goto out;
 	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->host_int, 0);
@@ -2219,7 +2219,7 @@ qla82xx_poll(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 
 	host_int = RD_REG_DWORD(&reg->host_int);
-	if (qla2x00_check_reg_for_disconnect(vha, host_int))
+	if (qla2x00_check_reg32_for_disconnect(vha, host_int))
 		goto out;
 	if (host_int) {
 		stat = RD_REG_DWORD(&reg->host_status);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 53449d7..3bfa89d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5183,13 +5183,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	 */
 	if (!pci_channel_offline(ha->pdev)) {
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
-		if (w == 0xffff)
-			/*
-			 * Schedule this on the default system workqueue so that
-			 * all the adapter workqueues and the DPC thread can be
-			 * shutdown cleanly.
-			 */
-			schedule_work(&ha->board_disable);
+		qla2x00_check_reg16_for_disconnect(vha, w);
 	}
 
 	/* Make sure qla82xx_watchdog is run only for physical port */
-- 
1.7.10.4

