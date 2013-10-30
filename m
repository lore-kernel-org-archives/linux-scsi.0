From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/22] qla2xxx: Disable adapter when we encounter a PCI disconnect.
Date: Wed, 30 Oct 2013 03:38:16 -0400
Message-ID: <1383118709-5569-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:51699 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632Ab3J3ILW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:22 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If we become disconnected from the PCI bus/PCIe fabric, there can be long delays
in register reads which can cause erroneous decisions to be made and cause a
soft lockup if a lock is held too long. As a preventative measure, check for a
disconnection (register reads that return -1) and then disable the board if we
find ourselves in this condition. For now, check in our interrupt handlers and
the per adapter one second timer.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h |    4 ++
 drivers/scsi/qla2xxx/qla_isr.c |   50 +++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mr.c  |    2 +
 drivers/scsi/qla2xxx/qla_nx.c  |   18 ++++++++-
 drivers/scsi/qla2xxx/qla_os.c  |   77 ++++++++++++++++++++++++++++++++++++++-
 7 files changed, 148 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index acc1ea4..149a1b5 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x015a       | 0x4b,0xba,0xfa |
+ * | Module Init and Probe        |       0x015b       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * |                              |                    | 0x1018-0x1019  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 82b18c0..0fb01e1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3301,6 +3301,7 @@ struct qla_hw_data {
 	struct work_struct nic_core_reset;
 	struct work_struct idc_state_handler;
 	struct work_struct nic_core_unrecoverable;
+	struct work_struct board_disable;
 
 	struct mr_data_fx00 mr;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index df52f73..359d0d9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -159,6 +159,9 @@ extern int qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
 extern int __qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
+extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
+extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
+
 /*
  * Global Functions in qla_mid.c source file.
  */
@@ -454,6 +457,7 @@ extern uint8_t *qla25xx_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
 extern int qla25xx_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
 				    uint32_t);
 extern int qla2x00_is_a_vp_did(scsi_qla_host_t *, uint32_t);
+bool qla2x00_check_reg_for_disconnect(scsi_qla_host_t *, uint32_t);
 
 extern int qla2x00_beacon_on(struct scsi_qla_host *);
 extern int qla2x00_beacon_off(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2e6eae3..0b1b297 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -56,6 +56,16 @@ qla2100_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
+		/* Check for PCI disconnection */
+		if (hccr == 0xffff) {
+			/*
+			 * Schedule this on the default system workqueue so that
+			 * all the adapter workqueues and the DPC thread can be
+			 * shutdown cleanly.
+			 */
+			schedule_work(&ha->board_disable);
+			break;
+		}
 		if (hccr & HCCR_RISC_PAUSE) {
 			if (pci_channel_offline(ha->pdev))
 				break;
@@ -110,6 +120,22 @@ qla2100_intr_handler(int irq, void *dev_id)
 	return (IRQ_HANDLED);
 }
 
+bool
+qla2x00_check_reg_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
+{
+	/* Check for PCI disconnection */
+	if (reg == 0xffffffff) {
+		/*
+		 * Schedule this on the default system workqueue so that all the
+		 * adapter workqueues and the DPC thread can be shutdown
+		 * cleanly.
+		 */
+		schedule_work(&vha->hw->board_disable);
+		return true;
+	} else
+		return false;
+}
+
 /**
  * qla2300_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
  * @irq:
@@ -148,11 +174,14 @@ qla2300_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+		if (qla2x00_check_reg_for_disconnect(vha, stat))
+			break;
 		if (stat & HSR_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_WORD(&reg->hccr);
+
 			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
 				ql_log(ql_log_warn, vha, 0x5026,
 				    "Parity error -- HCCR=%x, Dumping "
@@ -2571,6 +2600,8 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
+		if (qla2x00_check_reg_for_disconnect(vha, stat))
+			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
@@ -2640,6 +2671,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct device_reg_24xx __iomem *reg;
 	struct scsi_qla_host *vha;
 	unsigned long flags;
+	uint32_t stat = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -2653,11 +2685,19 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	vha = pci_get_drvdata(ha->pdev);
+	/*
+	 * Use host_status register to check to PCI disconnection before we
+	 * we process the response queue.
+	 */
+	stat = RD_REG_DWORD(&reg->host_status);
+	if (qla2x00_check_reg_for_disconnect(vha, stat))
+		goto out;
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->flags.disable_msix_handshake) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
+out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
@@ -2667,9 +2707,11 @@ static irqreturn_t
 qla25xx_msix_rsp_q(int irq, void *dev_id)
 {
 	struct qla_hw_data *ha;
+	scsi_qla_host_t *vha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
 	unsigned long flags;
+	uint32_t hccr = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -2678,17 +2720,21 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
+	vha = pci_get_drvdata(ha->pdev);
 
 	/* Clear the interrupt, if enabled, for this response queue */
 	if (!ha->flags.disable_msix_handshake) {
 		reg = &ha->iobase->isp24;
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		RD_REG_DWORD_RELAXED(&reg->hccr);
+		hccr = RD_REG_DWORD_RELAXED(&reg->hccr);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
+	if (qla2x00_check_reg_for_disconnect(vha, hccr))
+		goto out;
 	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
 
+out:
 	return IRQ_HANDLED;
 }
 
@@ -2719,6 +2765,8 @@ qla24xx_msix_default(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
+		if (qla2x00_check_reg_for_disconnect(vha, stat))
+			break;
 		if (stat & HSRX_RISC_PAUSED) {
 			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ea03f85..4e418fc 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3019,6 +3019,8 @@ qlafx00_intr_handler(int irq, void *dev_id)
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; clr_intr = 0) {
 		stat = QLAFX00_RD_INTR_REG(ha);
+		if (qla2x00_check_reg_for_disconnect(vha, stat))
+			break;
 		if ((stat & QLAFX00_HST_INT_STS_BITS) == 0)
 			break;
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 11ce53d..3da2372 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2096,6 +2096,7 @@ qla82xx_msix_default(int irq, void *dev_id)
 	int status = 0;
 	unsigned long flags;
 	uint32_t stat = 0;
+	uint32_t host_int = 0;
 	uint16_t mb[4];
 
 	rsp = (struct rsp_que *) dev_id;
@@ -2111,7 +2112,10 @@ qla82xx_msix_default(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	do {
-		if (RD_REG_DWORD(&reg->host_int)) {
+		host_int = RD_REG_DWORD(&reg->host_int);
+		if (qla2x00_check_reg_for_disconnect(vha, host_int))
+			break;
+		if (host_int) {
 			stat = RD_REG_DWORD(&reg->host_status);
 
 			switch (stat & 0xff) {
@@ -2156,6 +2160,7 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
 	unsigned long flags;
+	uint32_t host_int = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -2168,8 +2173,12 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	reg = &ha->iobase->isp82;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
+	host_int = RD_REG_DWORD(&reg->host_int);
+	if (qla2x00_check_reg_for_disconnect(vha, host_int))
+		goto out;
 	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->host_int, 0);
+out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
@@ -2183,6 +2192,7 @@ qla82xx_poll(int irq, void *dev_id)
 	struct device_reg_82xx __iomem *reg;
 	int status = 0;
 	uint32_t stat;
+	uint32_t host_int = 0;
 	uint16_t mb[4];
 	unsigned long flags;
 
@@ -2198,7 +2208,10 @@ qla82xx_poll(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 
-	if (RD_REG_DWORD(&reg->host_int)) {
+	host_int = RD_REG_DWORD(&reg->host_int);
+	if (qla2x00_check_reg_for_disconnect(vha, host_int))
+		goto out;
+	if (host_int) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		switch (stat & 0xff) {
 		case 0x1:
@@ -2226,6 +2239,7 @@ qla82xx_poll(int irq, void *dev_id)
 		}
 	}
 	WRT_REG_DWORD(&reg->host_int, 0);
+out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e683008..9c5070e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2742,6 +2742,8 @@ que_init:
 	 */
 	qla2xxx_wake_dpc(base_vha);
 
+	INIT_WORK(&ha->board_disable, qla2x00_disable_board_on_pci_error);
+
 	if (IS_QLA8031(ha) || IS_MCTP_CAPABLE(ha)) {
 		sprintf(wq_name, "qla2xxx_%lu_dpc_lp_wq", base_vha->host_no);
 		ha->dpc_lp_wq = create_singlethread_workqueue(wq_name);
@@ -4678,6 +4680,66 @@ exit:
 	return rval;
 }
 
+void
+qla2x00_disable_board_on_pci_error(struct work_struct *work)
+{
+	struct qla_hw_data *ha = container_of(work, struct qla_hw_data,
+	    board_disable);
+	struct pci_dev *pdev = ha->pdev;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+
+	ql_log(ql_log_warn, base_vha, 0x015b,
+	    "Disabling adapter.\n");
+
+	set_bit(UNLOADING, &base_vha->dpc_flags);
+
+	qla2x00_delete_all_vps(ha, base_vha);
+
+	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+
+	qla2x00_dfs_remove(base_vha);
+
+	qla84xx_put_chip(base_vha);
+
+	if (base_vha->timer_active)
+		qla2x00_stop_timer(base_vha);
+
+	base_vha->flags.online = 0;
+
+	qla2x00_destroy_deferred_work(ha);
+
+	/*
+	 * Do not try to stop beacon blink as it will issue a mailbox
+	 * command.
+	 */
+	qla2x00_free_sysfs_attr(base_vha, false);
+
+	fc_remove_host(base_vha->host);
+
+	scsi_remove_host(base_vha->host);
+
+	base_vha->flags.init_done = 0;
+	qla25xx_delete_queues(base_vha);
+	qla2x00_free_irqs(base_vha);
+	qla2x00_free_fcports(base_vha);
+	qla2x00_mem_free(ha);
+	qla82xx_md_free(base_vha);
+	qla2x00_free_queues(ha);
+
+	scsi_host_put(base_vha->host);
+
+	qla2x00_unmap_iobases(ha);
+
+	pci_release_selected_regions(ha->pdev, ha->bars);
+	kfree(ha);
+	ha = NULL;
+
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+
+}
+
 /**************************************************************************
 * qla2x00_do_dpc
 *   This kernel thread is a task that is schedule by the interrupt handler
@@ -5031,9 +5093,20 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		return;
 	}
 
-	/* Hardware read to raise pending EEH errors during mailbox waits. */
-	if (!pci_channel_offline(ha->pdev))
+	/*
+	 * Hardware read to raise pending EEH errors during mailbox waits. If
+	 * the read returns -1 then disable the board.
+	 */
+	if (!pci_channel_offline(ha->pdev)) {
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
+		if (w == 0xffff)
+			/*
+			 * Schedule this on the default system workqueue so that
+			 * all the adapter workqueues and the DPC thread can be
+			 * shutdown cleanly.
+			 */
+			schedule_work(&ha->board_disable);
+	}
 
 	/* Make sure qla82xx_watchdog is run only for physical port */
 	if (!vha->vp_idx && IS_P3P_TYPE(ha)) {
-- 
1.7.7

