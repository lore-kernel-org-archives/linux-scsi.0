From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: Updated qla functions
Date: Thu, 16 Oct 2008 18:08:27 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810161759460.903@n4012av9w19yf1.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:30976 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYJQBKR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 21:10:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Following changes have been made:
1. Outstanding commands are based on a request queue, scsi_qla_host does not 
maintain it anymore.
2. Interrupt registrations are done using response queue instead of device id.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c    | 1113 ++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_inline.h  |   27 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  258 ++++----
 drivers/scsi/qla2xxx/qla_isr.c     |  633 ++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c      | 1274 ++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 6 files changed, 1763 insertions(+), 1546 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a470f2d..24c54c5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -35,7 +35,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 
-static int qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev);
+static int qla2x00_find_new_loop_id(scsi_qla_host_t *, fc_port_t *);
 
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
@@ -55,77 +55,77 @@ static int qla84xx_init_chip(scsi_qla_host_t *);
 *      0 = success
 */
 int
-qla2x00_initialize_adapter(scsi_qla_host_t *ha)
+qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 {
 	int	rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	/* Clear adapter flags. */
-	ha->flags.online = 0;
-	ha->flags.reset_active = 0;
-	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-	atomic_set(&ha->loop_state, LOOP_DOWN);
-	ha->device_flags = DFLG_NO_CABLE;
-	ha->dpc_flags = 0;
-	ha->flags.management_server_logged_in = 0;
-	ha->marker_needed = 0;
+	vha->flags.online = 0;
+	vha->flags.reset_active = 0;
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	vha->device_flags = DFLG_NO_CABLE;
+	vha->dpc_flags = 0;
+	vha->flags.management_server_logged_in = 0;
+	vha->marker_needed = 0;
 	ha->mbx_flags = 0;
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
-	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
-	rval = ha->isp_ops->pci_config(ha);
+	rval = ha->isp_ops->pci_config(vha);
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Unable to configure PCI space.\n",
-		    ha->host_no));
+		    vha->host_no));
 		return (rval);
 	}
 
-	ha->isp_ops->reset_chip(ha);
+	ha->isp_ops->reset_chip(vha);
 
-	rval = qla2xxx_get_flash_info(ha);
+	rval = qla2xxx_get_flash_info(vha);
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Unable to validate FLASH data.\n",
-		    ha->host_no));
+		    vha->host_no));
 		return (rval);
 	}
 
-	ha->isp_ops->get_flash_version(ha, ha->request_ring);
+	ha->isp_ops->get_flash_version(vha, ha->req->ring);
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
-	ha->isp_ops->nvram_config(ha);
+	ha->isp_ops->nvram_config(vha);
 
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
 		qla_printk(KERN_INFO, ha, "Masking HBA WWPN "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x (via NVRAM).\n",
-		    ha->port_name[0], ha->port_name[1],
-		    ha->port_name[2], ha->port_name[3],
-		    ha->port_name[4], ha->port_name[5],
-		    ha->port_name[6], ha->port_name[7]);
+		    vha->port_name[0], vha->port_name[1],
+		    vha->port_name[2], vha->port_name[3],
+		    vha->port_name[4], vha->port_name[5],
+		    vha->port_name[6], vha->port_name[7]);
 		return QLA_FUNCTION_FAILED;
 	}
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
-	if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
-		rval = ha->isp_ops->chip_diag(ha);
+	if (qla2x00_isp_firmware(vha) != QLA_SUCCESS) {
+		rval = ha->isp_ops->chip_diag(vha);
 		if (rval)
 			return (rval);
-		rval = qla2x00_setup_chip(ha);
+		rval = qla2x00_setup_chip(vha);
 		if (rval)
 			return (rval);
 	}
 	if (IS_QLA84XX(ha)) {
-		ha->cs84xx = qla84xx_get_chip(ha);
+		ha->cs84xx = qla84xx_get_chip(vha);
 		if (!ha->cs84xx) {
 			qla_printk(KERN_ERR, ha,
 			    "Unable to configure ISP84XX.\n");
 			return QLA_FUNCTION_FAILED;
 		}
 	}
-	rval = qla2x00_init_rings(ha);
+	rval = qla2x00_init_rings(vha);
 
 	return (rval);
 }
@@ -137,11 +137,12 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2100_pci_config(scsi_qla_host_t *ha)
+qla2100_pci_config(scsi_qla_host_t *vha)
 {
 	uint16_t w;
 	uint32_t d;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
@@ -171,12 +172,13 @@ qla2100_pci_config(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2300_pci_config(scsi_qla_host_t *ha)
+qla2300_pci_config(scsi_qla_host_t *vha)
 {
 	uint16_t	w;
 	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
@@ -256,11 +258,12 @@ qla2300_pci_config(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla24xx_pci_config(scsi_qla_host_t *ha)
+qla24xx_pci_config(scsi_qla_host_t *vha)
 {
 	uint16_t w;
 	uint32_t d;
 	unsigned long flags = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	pci_set_master(ha->pdev);
@@ -303,10 +306,11 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla25xx_pci_config(scsi_qla_host_t *ha)
+qla25xx_pci_config(scsi_qla_host_t *vha)
 {
 	uint16_t w;
 	uint32_t d;
+	struct qla_hw_data *ha = vha->hw;
 
 	pci_set_master(ha->pdev);
 	pci_try_set_mwi(ha->pdev);
@@ -337,32 +341,33 @@ qla25xx_pci_config(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_isp_firmware(scsi_qla_host_t *ha)
+qla2x00_isp_firmware(scsi_qla_host_t *vha)
 {
 	int  rval;
 	uint16_t loop_id, topo, sw_cap;
 	uint8_t domain, area, al_pa;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Assume loading risc code */
 	rval = QLA_FUNCTION_FAILED;
 
 	if (ha->flags.disable_risc_code_load) {
 		DEBUG2(printk("scsi(%ld): RISC CODE NOT loaded\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_INFO, ha, "RISC CODE NOT loaded\n");
 
 		/* Verify checksum of loaded RISC code. */
-		rval = qla2x00_verify_checksum(ha, ha->fw_srisc_address);
+		rval = qla2x00_verify_checksum(vha, ha->fw_srisc_address);
 		if (rval == QLA_SUCCESS) {
 			/* And, verify we are not in ROM code. */
-			rval = qla2x00_get_adapter_id(ha, &loop_id, &al_pa,
+			rval = qla2x00_get_adapter_id(vha, &loop_id, &al_pa,
 			    &area, &domain, &topo, &sw_cap);
 		}
 	}
 
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): **** Load RISC code ****\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -375,9 +380,10 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 void
-qla2x00_reset_chip(scsi_qla_host_t *ha)
+qla2x00_reset_chip(scsi_qla_host_t *vha)
 {
 	unsigned long   flags = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t	cnt;
 	uint16_t	cmd;
@@ -515,10 +521,11 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static inline void
-qla24xx_reset_risc(scsi_qla_host_t *ha)
+qla24xx_reset_risc(scsi_qla_host_t *vha)
 {
 	int hw_evt = 0;
 	unsigned long flags = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t cnt, d2;
 	uint16_t wd;
@@ -557,7 +564,7 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 		barrier();
 	}
 	if (cnt == 0 || hw_evt)
-		qla2xxx_hw_event_log(ha, HW_EVENT_RESET_ERR,
+		qla2xxx_hw_event_log(vha, HW_EVENT_RESET_ERR,
 		    RD_REG_WORD(&reg->mailbox1), RD_REG_WORD(&reg->mailbox2),
 		    RD_REG_WORD(&reg->mailbox3));
 
@@ -587,12 +594,13 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 void
-qla24xx_reset_chip(scsi_qla_host_t *ha)
+qla24xx_reset_chip(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	ha->isp_ops->disable_intrs(ha);
 
 	/* Perform RISC reset. */
-	qla24xx_reset_risc(ha);
+	qla24xx_reset_risc(vha);
 }
 
 /**
@@ -602,9 +610,10 @@ qla24xx_reset_chip(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2x00_chip_diag(scsi_qla_host_t *ha)
+qla2x00_chip_diag(scsi_qla_host_t *vha)
 {
 	int		rval;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	unsigned long	flags = 0;
 	uint16_t	data;
@@ -615,7 +624,7 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 	rval = QLA_FUNCTION_FAILED;
 
 	DEBUG3(printk("scsi(%ld): Testing device at %lx.\n",
-	    ha->host_no, (u_long)&reg->flash_address));
+	    vha->host_no, (u_long)&reg->flash_address));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -678,17 +687,17 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 	ha->product_id[3] = mb[4];
 
 	/* Adjust fw RISC transfer size */
-	if (ha->request_q_length > 1024)
+	if (ha->req->length > 1024)
 		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
 	else
 		ha->fw_transfer_size = REQUEST_ENTRY_SIZE *
-		    ha->request_q_length;
+		    ha->req->length;
 
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
 		/* Limit firmware transfer size with a 2200A */
 		DEBUG3(printk("scsi(%ld): Found QLA2200A chip.\n",
-		    ha->host_no));
+		    vha->host_no));
 
 		ha->device_type |= DT_ISP2200A;
 		ha->fw_transfer_size = 128;
@@ -697,11 +706,11 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 	/* Wrap Incoming Mailboxes Test. */
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	DEBUG3(printk("scsi(%ld): Checking mailboxes.\n", ha->host_no));
-	rval = qla2x00_mbx_reg_test(ha);
+	DEBUG3(printk("scsi(%ld): Checking mailboxes.\n", vha->host_no));
+	rval = qla2x00_mbx_reg_test(vha);
 	if (rval) {
 		DEBUG(printk("scsi(%ld): Failed mailbox send register test\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha,
 		    "Failed mailbox send register test\n");
 	}
@@ -714,7 +723,7 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 chip_diag_failed:
 	if (rval)
 		DEBUG2_3(printk("scsi(%ld): Chip diagnostics **** FAILED "
-		    "****\n", ha->host_no));
+		    "****\n", vha->host_no));
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -728,19 +737,20 @@ chip_diag_failed:
  * Returns 0 on success.
  */
 int
-qla24xx_chip_diag(scsi_qla_host_t *ha)
+qla24xx_chip_diag(scsi_qla_host_t *vha)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Perform RISC reset. */
-	qla24xx_reset_risc(ha);
+	qla24xx_reset_risc(vha);
 
-	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * ha->request_q_length;
+	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * ha->req->length;
 
-	rval = qla2x00_mbx_reg_test(ha);
+	rval = qla2x00_mbx_reg_test(vha);
 	if (rval) {
 		DEBUG(printk("scsi(%ld): Failed mailbox send register test\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha,
 		    "Failed mailbox send register test\n");
 	} else {
@@ -752,13 +762,14 @@ qla24xx_chip_diag(scsi_qla_host_t *ha)
 }
 
 void
-qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
+qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint32_t dump_size, fixed_size, mem_size, req_q_size, rsp_q_size,
 	    eft_size, fce_size;
 	dma_addr_t tc_dma;
 	void *tc;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->fw_dump) {
 		qla_printk(KERN_WARNING, ha,
@@ -794,7 +805,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		}
 
 		memset(tc, 0, FCE_SIZE);
-		rval = qla2x00_enable_fce_trace(ha, tc_dma, FCE_NUM_BUFFERS,
+		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
 		    ha->fce_mb, &ha->fce_bufs);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha, "Unable to initialize "
@@ -823,7 +834,7 @@ try_eft:
 		}
 
 		memset(tc, 0, EFT_SIZE);
-		rval = qla2x00_enable_eft_trace(ha, tc_dma, EFT_NUM_BUFFERS);
+		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha, "Unable to initialize "
 			    "EFT (%d).\n", rval);
@@ -840,8 +851,8 @@ try_eft:
 		ha->eft = tc;
 	}
 cont_alloc:
-	req_q_size = ha->request_q_length * sizeof(request_t);
-	rsp_q_size = ha->response_q_length * sizeof(response_t);
+	req_q_size = ha->req->length * sizeof(request_t);
+	rsp_q_size = ha->rsp->length * sizeof(response_t);
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
@@ -891,27 +902,29 @@ cont_alloc:
  * Returns 0 on success.
  */
 static void
-qla2x00_resize_request_q(scsi_qla_host_t *ha)
+qla2x00_resize_request_q(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint16_t fw_iocb_cnt = 0;
 	uint16_t request_q_length = REQUEST_ENTRY_CNT_2XXX_EXT_MEM;
 	dma_addr_t request_dma;
 	request_t *request_ring;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	/* Valid only on recent ISPs. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
 
 	/* Retrieve IOCB counts available to the firmware. */
-	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt,
-	    &ha->max_npiv_vports);
+	rval = qla2x00_get_resource_cnts(vha, NULL, NULL, NULL, &fw_iocb_cnt,
+					&ha->max_npiv_vports);
 	if (rval)
 		return;
 	/* No point in continuing if current settings are sufficient. */
 	if (fw_iocb_cnt < 1024)
 		return;
-	if (ha->request_q_length >= request_q_length)
+	if (req->length >= request_q_length)
 		return;
 
 	/* Attempt to claim larger area for request queue. */
@@ -925,17 +938,17 @@ qla2x00_resize_request_q(scsi_qla_host_t *ha)
 	qla_printk(KERN_INFO, ha, "Extended memory detected (%d KB)...\n",
 	    (ha->fw_memory_size + 1) / 1024);
 	qla_printk(KERN_INFO, ha, "Resizing request queue depth "
-	    "(%d -> %d)...\n", ha->request_q_length, request_q_length);
+	    "(%d -> %d)...\n", req->length, request_q_length);
 
 	/* Clear old allocations. */
 	dma_free_coherent(&ha->pdev->dev,
-	    (ha->request_q_length + 1) * sizeof(request_t), ha->request_ring,
-	    ha->request_dma);
+	    (req->length + 1) * sizeof(request_t), req->ring,
+	    req->dma);
 
 	/* Begin using larger queue. */
-	ha->request_q_length = request_q_length;
-	ha->request_ring = request_ring;
-	ha->request_dma = request_dma;
+	req->length = request_q_length;
+	req->ring = request_ring;
+	req->dma = request_dma;
 }
 
 /**
@@ -945,10 +958,11 @@ qla2x00_resize_request_q(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_setup_chip(scsi_qla_host_t *ha)
+qla2x00_setup_chip(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint32_t srisc_address = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	unsigned long flags;
 
@@ -961,29 +975,28 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 	}
 
 	/* Load firmware sequences */
-	rval = ha->isp_ops->load_risc(ha, &srisc_address);
+	rval = ha->isp_ops->load_risc(vha, &srisc_address);
 	if (rval == QLA_SUCCESS) {
 		DEBUG(printk("scsi(%ld): Verifying Checksum of loaded RISC "
-		    "code.\n", ha->host_no));
+		    "code.\n", vha->host_no));
 
-		rval = qla2x00_verify_checksum(ha, srisc_address);
+		rval = qla2x00_verify_checksum(vha, srisc_address);
 		if (rval == QLA_SUCCESS) {
 			/* Start firmware execution. */
 			DEBUG(printk("scsi(%ld): Checksum OK, start "
-			    "firmware.\n", ha->host_no));
+			    "firmware.\n", vha->host_no));
 
-			rval = qla2x00_execute_fw(ha, srisc_address);
+			rval = qla2x00_execute_fw(vha, srisc_address);
 			/* Retrieve firmware information. */
 			if (rval == QLA_SUCCESS && ha->fw_major_version == 0) {
-				qla2x00_get_fw_version(ha,
+				qla2x00_get_fw_version(vha,
 				    &ha->fw_major_version,
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
-				qla2x00_resize_request_q(ha);
+				qla2x00_resize_request_q(vha);
 				ha->flags.npiv_supported = 0;
-				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
-				     IS_QLA84XX(ha)) &&
+				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
 					ha->flags.npiv_supported = 1;
 					if ((!ha->max_npiv_vports) ||
@@ -994,12 +1007,12 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				}
 
 				if (ql2xallocfwdump)
-					qla2x00_alloc_fw_dump(ha);
+					qla2x00_alloc_fw_dump(vha);
 			}
 		} else {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld): ISP Firmware failed checksum.\n",
-			    ha->host_no));
+			    vha->host_no));
 		}
 	}
 
@@ -1018,7 +1031,7 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Setup chip **** FAILED ****.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -1034,13 +1047,14 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static void
-qla2x00_init_response_q_entries(scsi_qla_host_t *ha)
+qla2x00_init_response_q_entries(scsi_qla_host_t *vha)
 {
 	uint16_t cnt;
 	response_t *pkt;
+	struct rsp_que *rsp = vha->hw->rsp;
 
-	pkt = ha->response_ring_ptr;
-	for (cnt = 0; cnt < ha->response_q_length; cnt++) {
+	pkt = rsp->ring_ptr;
+	for (cnt = 0; cnt < rsp->length; cnt++) {
 		pkt->signature = RESPONSE_PROCESSED;
 		pkt++;
 	}
@@ -1054,19 +1068,20 @@ qla2x00_init_response_q_entries(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 void
-qla2x00_update_fw_options(scsi_qla_host_t *ha)
+qla2x00_update_fw_options(scsi_qla_host_t *vha)
 {
 	uint16_t swing, emphasis, tx_sens, rx_sens;
+	struct qla_hw_data *ha = vha->hw;
 
 	memset(ha->fw_options, 0, sizeof(ha->fw_options));
-	qla2x00_get_fw_options(ha, ha->fw_options);
+	qla2x00_get_fw_options(vha, ha->fw_options);
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
 
 	/* Serial Link options. */
 	DEBUG3(printk("scsi(%ld): Serial link options:\n",
-	    ha->host_no));
+	    vha->host_no));
 	DEBUG3(qla2x00_dump_buffer((uint8_t *)&ha->fw_seriallink_options,
 	    sizeof(ha->fw_seriallink_options)));
 
@@ -1124,19 +1139,20 @@ qla2x00_update_fw_options(scsi_qla_host_t *ha)
 		ha->fw_options[2] |= BIT_13;
 
 	/* Update firmware options. */
-	qla2x00_set_fw_options(ha, ha->fw_options);
+	qla2x00_set_fw_options(vha, ha->fw_options);
 }
 
 void
-qla24xx_update_fw_options(scsi_qla_host_t *ha)
+qla24xx_update_fw_options(scsi_qla_host_t *vha)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
 
-	rval = qla2x00_set_serdes_params(ha,
+	rval = qla2x00_set_serdes_params(vha,
 	    le16_to_cpu(ha->fw_seriallink_options24[1]),
 	    le16_to_cpu(ha->fw_seriallink_options24[2]),
 	    le16_to_cpu(ha->fw_seriallink_options24[3]));
@@ -1147,19 +1163,22 @@ qla24xx_update_fw_options(scsi_qla_host_t *ha)
 }
 
 void
-qla2x00_config_rings(struct scsi_qla_host *ha)
+qla2x00_config_rings(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	struct req_que *req = ha->req;
+	struct rsp_que *rsp = ha->rsp;
 
 	/* Setup ring parameters in initialization control block. */
 	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
 	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->request_q_length = cpu_to_le16(ha->request_q_length);
-	ha->init_cb->response_q_length = cpu_to_le16(ha->response_q_length);
-	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
-	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
-	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
-	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+	ha->init_cb->request_q_length = cpu_to_le16(req->length);
+	ha->init_cb->response_q_length = cpu_to_le16(rsp->length);
+	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
+	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(req->dma));
+	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
+	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), 0);
 	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
@@ -1169,21 +1188,24 @@ qla2x00_config_rings(struct scsi_qla_host *ha)
 }
 
 void
-qla24xx_config_rings(struct scsi_qla_host *ha)
+qla24xx_config_rings(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	struct init_cb_24xx *icb;
+	struct req_que *req = ha->req;
+	struct rsp_que *rsp = ha->rsp;
 
 	/* Setup ring parameters in initialization control block. */
 	icb = (struct init_cb_24xx *)ha->init_cb;
 	icb->request_q_outpointer = __constant_cpu_to_le16(0);
 	icb->response_q_inpointer = __constant_cpu_to_le16(0);
-	icb->request_q_length = cpu_to_le16(ha->request_q_length);
-	icb->response_q_length = cpu_to_le16(ha->response_q_length);
-	icb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
-	icb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
-	icb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
-	icb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+	icb->request_q_length = cpu_to_le16(req->length);
+	icb->response_q_length = cpu_to_le16(rsp->length);
+	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
+	icb->request_q_address[1] = cpu_to_le32(MSD(req->dma));
+	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
+	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
 	WRT_REG_DWORD(&reg->req_q_in, 0);
 	WRT_REG_DWORD(&reg->req_q_out, 0);
@@ -1202,11 +1224,14 @@ qla24xx_config_rings(struct scsi_qla_host *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_init_rings(scsi_qla_host_t *ha)
+qla2x00_init_rings(scsi_qla_host_t *vha)
 {
 	int	rval;
 	unsigned long flags = 0;
 	int cnt;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
+	struct rsp_que *rsp = ha->rsp;
 	struct mid_init_cb_24xx *mid_init_cb =
 	    (struct mid_init_cb_24xx *) ha->init_cb;
 
@@ -1214,45 +1239,45 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 
 	/* Clear outstanding commands array. */
 	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
-		ha->outstanding_cmds[cnt] = NULL;
+		req->outstanding_cmds[cnt] = NULL;
 
-	ha->current_outstanding_cmd = 0;
+	req->current_outstanding_cmd = 0;
 
 	/* Clear RSCN queue. */
-	ha->rscn_in_ptr = 0;
-	ha->rscn_out_ptr = 0;
+	vha->rscn_in_ptr = 0;
+	vha->rscn_out_ptr = 0;
 
 	/* Initialize firmware. */
-	ha->request_ring_ptr  = ha->request_ring;
-	ha->req_ring_index    = 0;
-	ha->req_q_cnt         = ha->request_q_length;
-	ha->response_ring_ptr = ha->response_ring;
-	ha->rsp_ring_index    = 0;
+	req->ring_ptr  = req->ring;
+	req->ring_index    = 0;
+	req->cnt      = req->length;
+	rsp->ring_ptr = rsp->ring;
+	rsp->ring_index    = 0;
 
 	/* Initialize response queue entries */
-	qla2x00_init_response_q_entries(ha);
+	qla2x00_init_response_q_entries(vha);
 
-	ha->isp_ops->config_rings(ha);
+	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Update any ISP specific firmware options before initialization. */
-	ha->isp_ops->update_fw_options(ha);
+	ha->isp_ops->update_fw_options(vha);
 
-	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
+	DEBUG(printk("scsi(%ld): Issue init firmware.\n", vha->host_no));
 
 	if (ha->flags.npiv_supported)
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
 
 	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
-	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
+	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
-		    ha->host_no));
+		    vha->host_no));
 	} else {
 		DEBUG3(printk("scsi(%ld): Init firmware -- success.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -1265,13 +1290,14 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_fw_ready(scsi_qla_host_t *ha)
+qla2x00_fw_ready(scsi_qla_host_t *vha)
 {
 	int		rval;
 	unsigned long	wtime, mtime, cs84xx_time;
 	uint16_t	min_wait;	/* Minimum wait time if loop is down */
 	uint16_t	wait_time;	/* Wait time if loop is coming ready */
 	uint16_t	state[3];
+	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_SUCCESS;
 
@@ -1293,29 +1319,29 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 	wtime = jiffies + (wait_time * HZ);
 
 	/* Wait for ISP to finish LIP */
-	if (!ha->flags.init_done)
+	if (!vha->flags.init_done)
  		qla_printk(KERN_INFO, ha, "Waiting for LIP to complete...\n");
 
 	DEBUG3(printk("scsi(%ld): Waiting for LIP to complete...\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	do {
-		rval = qla2x00_get_firmware_state(ha, state);
+		rval = qla2x00_get_firmware_state(vha, state);
 		if (rval == QLA_SUCCESS) {
 			if (state[0] < FSTATE_LOSS_OF_SYNC) {
-				ha->device_flags &= ~DFLG_NO_CABLE;
+				vha->device_flags &= ~DFLG_NO_CABLE;
 			}
 			if (IS_QLA84XX(ha) && state[0] != FSTATE_READY) {
 				DEBUG16(printk("scsi(%ld): fw_state=%x "
-				    "84xx=%x.\n", ha->host_no, state[0],
+				    "84xx=%x.\n", vha->host_no, state[0],
 				    state[2]));
 				if ((state[2] & FSTATE_LOGGED_IN) &&
 				     (state[2] & FSTATE_WAITING_FOR_VERIFY)) {
 					DEBUG16(printk("scsi(%ld): Sending "
-					    "verify iocb.\n", ha->host_no));
+					    "verify iocb.\n", vha->host_no));
 
 					cs84xx_time = jiffies;
-					rval = qla84xx_init_chip(ha);
+					rval = qla84xx_init_chip(vha);
 					if (rval != QLA_SUCCESS)
 						break;
 
@@ -1325,13 +1351,13 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 					mtime += cs84xx_time;
 					DEBUG16(printk("scsi(%ld): Increasing "
 					    "wait time by %ld. New time %ld\n",
-					    ha->host_no, cs84xx_time, wtime));
+					    vha->host_no, cs84xx_time, wtime));
 				}
 			} else if (state[0] == FSTATE_READY) {
 				DEBUG(printk("scsi(%ld): F/W Ready - OK \n",
-				    ha->host_no));
+				    vha->host_no));
 
-				qla2x00_get_retry_cnt(ha, &ha->retry_count,
+				qla2x00_get_retry_cnt(vha, &ha->retry_count,
 				    &ha->login_timeout, &ha->r_a_tov);
 
 				rval = QLA_SUCCESS;
@@ -1340,7 +1366,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 
 			rval = QLA_FUNCTION_FAILED;
 
-			if (atomic_read(&ha->loop_down_timer) &&
+			if (atomic_read(&vha->loop_down_timer) &&
 			    state[0] != FSTATE_READY) {
 				/* Loop down. Timeout on min_wait for states
 				 * other than Wait for Login.
@@ -1349,7 +1375,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 					qla_printk(KERN_INFO, ha,
 					    "Cable is unplugged...\n");
 
-					ha->device_flags |= DFLG_NO_CABLE;
+					vha->device_flags |= DFLG_NO_CABLE;
 					break;
 				}
 			}
@@ -1366,15 +1392,15 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 		msleep(500);
 
 		DEBUG3(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
-		    ha->host_no, state[0], jiffies));
+		    vha->host_no, state[0], jiffies));
 	} while (1);
 
 	DEBUG(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
-	    ha->host_no, state[0], jiffies));
+	    vha->host_no, state[0], jiffies));
 
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Firmware ready **** FAILED ****.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -1394,7 +1420,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 *      Kernel context.
 */
 static int
-qla2x00_configure_hba(scsi_qla_host_t *ha)
+qla2x00_configure_hba(scsi_qla_host_t *vha)
 {
 	int       rval;
 	uint16_t      loop_id;
@@ -1404,19 +1430,20 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	uint8_t       area;
 	uint8_t       domain;
 	char		connect_type[22];
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Get host addresses. */
-	rval = qla2x00_get_adapter_id(ha,
+	rval = qla2x00_get_adapter_id(vha,
 	    &loop_id, &al_pa, &area, &domain, &topo, &sw_cap);
 	if (rval != QLA_SUCCESS) {
-		if (LOOP_TRANSITION(ha) || atomic_read(&ha->loop_down_timer) ||
+		if (LOOP_TRANSITION(vha) || atomic_read(&ha->loop_down_timer) ||
 		    (rval == QLA_COMMAND_ERROR && loop_id == 0x7)) {
 			DEBUG2(printk("%s(%ld) Loop is in a transition state\n",
-			    __func__, ha->host_no));
+			    __func__, vha->host_no));
 		} else {
 			qla_printk(KERN_WARNING, ha,
 			    "ERROR -- Unable to get host loop ID.\n");
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		}
 		return (rval);
 	}
@@ -1427,7 +1454,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 		return (QLA_FUNCTION_FAILED);
 	}
 
-	ha->loop_id = loop_id;
+	vha->loop_id = loop_id;
 
 	/* initialize */
 	ha->min_external_loopid = SNS_FIRST_LOOP_ID;
@@ -1437,14 +1464,14 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	switch (topo) {
 	case 0:
 		DEBUG3(printk("scsi(%ld): HBA in NL topology.\n",
-		    ha->host_no));
+		    vha->host_no));
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
 
 	case 1:
 		DEBUG3(printk("scsi(%ld): HBA in FL topology.\n",
-		    ha->host_no));
+		    vha->host_no));
 		ha->switch_cap = sw_cap;
 		ha->current_topology = ISP_CFG_FL;
 		strcpy(connect_type, "(FL_Port)");
@@ -1452,7 +1479,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 
 	case 2:
 		DEBUG3(printk("scsi(%ld): HBA in N P2P topology.\n",
-		    ha->host_no));
+		    vha->host_no));
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
@@ -1460,7 +1487,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 
 	case 3:
 		DEBUG3(printk("scsi(%ld): HBA in F P2P topology.\n",
-		    ha->host_no));
+		    vha->host_no));
 		ha->switch_cap = sw_cap;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_F;
@@ -1470,7 +1497,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	default:
 		DEBUG3(printk("scsi(%ld): HBA in unknown topology %x. "
 		    "Using NL.\n",
-		    ha->host_no, topo));
+		    vha->host_no, topo));
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
@@ -1478,29 +1505,31 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 
 	/* Save Host port and loop ID. */
 	/* byte order - Big Endian */
-	ha->d_id.b.domain = domain;
-	ha->d_id.b.area = area;
-	ha->d_id.b.al_pa = al_pa;
+	vha->d_id.b.domain = domain;
+	vha->d_id.b.area = area;
+	vha->d_id.b.al_pa = al_pa;
 
-	if (!ha->flags.init_done)
+	if (!vha->flags.init_done)
  		qla_printk(KERN_INFO, ha,
 		    "Topology - %s, Host Loop address 0x%x\n",
- 		    connect_type, ha->loop_id);
+		    connect_type, vha->loop_id);
 
 	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): FAILED.\n", ha->host_no));
+		DEBUG2_3(printk("scsi(%ld): FAILED.\n", vha->host_no));
 	} else {
-		DEBUG3(printk("scsi(%ld): exiting normally.\n", ha->host_no));
+		DEBUG3(printk("scsi(%ld): exiting normally.\n", vha->host_no));
 	}
 
 	return(rval);
 }
 
 static inline void
-qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *def)
+qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
+	char *def)
 {
 	char *st, *en;
 	uint16_t index;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (memcmp(model, BINZERO, len) != 0) {
 		strncpy(ha->model_number, model, len);
@@ -1532,16 +1561,17 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 		}
 	}
 	if (IS_FWI2_CAPABLE(ha))
-		qla2xxx_get_vpd_field(ha, "\x82", ha->model_desc,
+		qla2xxx_get_vpd_field(vha, "\x82", ha->model_desc,
 		    sizeof(ha->model_desc));
 }
 
 /* On sparc systems, obtain port and node WWN from firmware
  * properties.
  */
-static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, nvram_t *nv)
+static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 {
 #ifdef CONFIG_SPARC
+	struct qla_hw_data *ha = vha->hw;
 	struct pci_dev *pdev = ha->pdev;
 	struct device_node *dp = pci_device_to_OF_node(pdev);
 	const u8 *val;
@@ -1571,12 +1601,13 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, nvram_t *nv)
 *      0 = success.
 */
 int
-qla2x00_nvram_config(scsi_qla_host_t *ha)
+qla2x00_nvram_config(scsi_qla_host_t *vha)
 {
 	int             rval;
 	uint8_t         chksum = 0;
 	uint16_t        cnt;
 	uint8_t         *dptr1, *dptr2;
+	struct qla_hw_data *ha = vha->hw;
 	init_cb_t       *icb = ha->init_cb;
 	nvram_t         *nv = ha->nvram;
 	uint8_t         *ptr = ha->nvram;
@@ -1592,11 +1623,11 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 			ha->nvram_base = 0x80;
 
 	/* Get NVRAM data and calculate checksum. */
-	ha->isp_ops->read_nvram(ha, ptr, ha->nvram_base, ha->nvram_size);
+	ha->isp_ops->read_nvram(vha, ptr, ha->nvram_base, ha->nvram_size);
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size; cnt++)
 		chksum += *ptr++;
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
+	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
@@ -1610,7 +1641,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		    "invalid -- WWPN) defaults.\n");
 
 		if (chksum)
-			qla2xxx_hw_event_log(ha, HW_EVENT_NVRAM_CHKSUM_ERR, 0,
+			qla2xxx_hw_event_log(vha, HW_EVENT_NVRAM_CHKSUM_ERR, 0,
 			    MSW(chksum), LSW(chksum));
 
 		/*
@@ -1647,7 +1678,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		nv->port_name[3] = 224;
 		nv->port_name[4] = 139;
 
-		qla2xxx_nvram_wwn_from_ofw(ha, nv);
+		qla2xxx_nvram_wwn_from_ofw(vha, nv);
 
 		nv->login_timeout = 4;
 
@@ -1700,7 +1731,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 				strcpy(ha->model_number, "QLA2300");
 			}
 		} else {
-			qla2x00_set_model_info(ha, nv->model_number,
+			qla2x00_set_model_info(vha, nv->model_number,
 			    sizeof(nv->model_number), "QLA23xx");
 		}
 	} else if (IS_QLA2200(ha)) {
@@ -1776,8 +1807,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	ha->serial0 = icb->port_name[5];
 	ha->serial1 = icb->port_name[6];
 	ha->serial2 = icb->port_name[7];
-	ha->node_name = icb->node_name;
-	ha->port_name = icb->port_name;
+	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
+	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
 	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 
@@ -1845,10 +1876,10 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		icb->response_accumulation_timer = 3;
 		icb->interrupt_delay_timer = 5;
 
-		ha->flags.process_response_queue = 1;
+		vha->flags.process_response_queue = 1;
 	} else {
 		/* Enable ZIO. */
-		if (!ha->flags.init_done) {
+		if (!vha->flags.init_done) {
 			ha->zio_mode = icb->add_firmware_options[0] &
 			    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
 			ha->zio_timer = icb->interrupt_delay_timer ?
@@ -1856,12 +1887,12 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		}
 		icb->add_firmware_options[0] &=
 		    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
-		ha->flags.process_response_queue = 0;
+		vha->flags.process_response_queue = 0;
 		if (ha->zio_mode != QLA_ZIO_DISABLED) {
 			ha->zio_mode = QLA_ZIO_MODE_6;
 
 			DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer "
-			    "delay (%d us).\n", ha->host_no, ha->zio_mode,
+			    "delay (%d us).\n", vha->host_no, ha->zio_mode,
 			    ha->zio_timer * 100));
 			qla_printk(KERN_INFO, ha,
 			    "ZIO mode %d enabled; timer delay (%d us).\n",
@@ -1869,13 +1900,13 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 
 			icb->add_firmware_options[0] |= (uint8_t)ha->zio_mode;
 			icb->interrupt_delay_timer = (uint8_t)ha->zio_timer;
-			ha->flags.process_response_queue = 1;
+			vha->flags.process_response_queue = 1;
 		}
 	}
 
 	if (rval) {
 		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
+		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
 	}
 	return (rval);
 }
@@ -1886,10 +1917,10 @@ qla2x00_rport_del(void *data)
 	fc_port_t *fcport = data;
 	struct fc_rport *rport;
 
-	spin_lock_irq(fcport->ha->host->host_lock);
+	spin_lock_irq(fcport->vha->host->host_lock);
 	rport = fcport->drport;
 	fcport->drport = NULL;
-	spin_unlock_irq(fcport->ha->host->host_lock);
+	spin_unlock_irq(fcport->vha->host->host_lock);
 	if (rport)
 		fc_remote_port_delete(rport);
 }
@@ -1902,7 +1933,7 @@ qla2x00_rport_del(void *data)
  * Returns a pointer to the allocated fcport, or NULL, if none available.
  */
 static fc_port_t *
-qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t flags)
+qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 {
 	fc_port_t *fcport;
 
@@ -1911,8 +1942,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t flags)
 		return NULL;
 
 	/* Setup fcport template structure. */
-	fcport->ha = ha;
-	fcport->vp_idx = ha->vp_idx;
+	fcport->vha = vha;
+	fcport->vp_idx = vha->vp_idx;
 	fcport->port_type = FCT_UNKNOWN;
 	fcport->loop_id = FC_NO_LOOP_ID;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
@@ -1935,100 +1966,98 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t flags)
  *      2 = database was full and device was not configured.
  */
 static int
-qla2x00_configure_loop(scsi_qla_host_t *ha)
+qla2x00_configure_loop(scsi_qla_host_t *vha)
 {
 	int  rval;
 	unsigned long flags, save_flags;
-
+	struct qla_hw_data *ha = vha->hw;
 	rval = QLA_SUCCESS;
 
 	/* Get Initiator ID */
-	if (test_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags)) {
-		rval = qla2x00_configure_hba(ha);
+	if (test_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags)) {
+		rval = qla2x00_configure_hba(vha);
 		if (rval != QLA_SUCCESS) {
 			DEBUG(printk("scsi(%ld): Unable to configure HBA.\n",
-			    ha->host_no));
+			    vha->host_no));
 			return (rval);
 		}
 	}
 
-	save_flags = flags = ha->dpc_flags;
+	save_flags = flags = vha->dpc_flags;
 	DEBUG(printk("scsi(%ld): Configure loop -- dpc flags =0x%lx\n",
-	    ha->host_no, flags));
+	    vha->host_no, flags));
 
 	/*
 	 * If we have both an RSCN and PORT UPDATE pending then handle them
 	 * both at the same time.
 	 */
-	clear_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	clear_bit(RSCN_UPDATE, &ha->dpc_flags);
+	clear_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+	clear_bit(RSCN_UPDATE, &vha->dpc_flags);
 
 	/* Determine what we need to do */
 	if (ha->current_topology == ISP_CFG_FL &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = 1;
+		vha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 
 	} else if (ha->current_topology == ISP_CFG_F &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = 1;
+		vha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
 	} else if (ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 
-	} else if (!ha->flags.online ||
+	} else if (!vha->flags.online ||
 	    (test_bit(ABORT_ISP_ACTIVE, &flags))) {
 
-		ha->flags.rscn_queue_overflow = 1;
+		vha->flags.rscn_queue_overflow = 1;
 		set_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	}
 
 	if (test_bit(LOCAL_LOOP_UPDATE, &flags)) {
-		if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			rval = QLA_FUNCTION_FAILED;
-		} else {
-			rval = qla2x00_configure_local_loop(ha);
-		}
+		else
+			rval = qla2x00_configure_local_loop(vha);
 	}
 
 	if (rval == QLA_SUCCESS && test_bit(RSCN_UPDATE, &flags)) {
-		if (LOOP_TRANSITION(ha)) {
+		if (LOOP_TRANSITION(vha))
 			rval = QLA_FUNCTION_FAILED;
-		} else {
-			rval = qla2x00_configure_fabric(ha);
-		}
+		else
+			rval = qla2x00_configure_fabric(vha);
 	}
 
 	if (rval == QLA_SUCCESS) {
-		if (atomic_read(&ha->loop_down_timer) ||
-		    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (atomic_read(&vha->loop_down_timer) ||
+		    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
-			atomic_set(&ha->loop_state, LOOP_READY);
+			atomic_set(&vha->loop_state, LOOP_READY);
 
-			DEBUG(printk("scsi(%ld): LOOP READY\n", ha->host_no));
+			DEBUG(printk("scsi(%ld): LOOP READY\n", vha->host_no));
 		}
 	}
 
 	if (rval) {
 		DEBUG2_3(printk("%s(%ld): *** FAILED ***\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 	} else {
 		DEBUG3(printk("%s: exiting normally\n", __func__));
 	}
 
 	/* Restore state if a resync event occurred during processing */
-	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+	if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
-			set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		if (test_bit(RSCN_UPDATE, &save_flags)) {
-			ha->flags.rscn_queue_overflow = 1;
-			set_bit(RSCN_UPDATE, &ha->dpc_flags);
+			set_bit(RSCN_UPDATE, &vha->dpc_flags);
+			vha->flags.rscn_queue_overflow = 1;
 		}
 	}
 
@@ -2048,7 +2077,7 @@ qla2x00_configure_loop(scsi_qla_host_t *ha)
  *	0 = success.
  */
 static int
-qla2x00_configure_local_loop(scsi_qla_host_t *ha)
+qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 {
 	int		rval, rval2;
 	int		found_devs;
@@ -2060,18 +2089,18 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 	char		*id_iter;
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
 	found_devs = 0;
 	new_fcport = NULL;
 	entries = MAX_FIBRE_DEVICES;
 
-	DEBUG3(printk("scsi(%ld): Getting FCAL position map\n", ha->host_no));
-	DEBUG3(qla2x00_get_fcal_position_map(ha, NULL));
+	DEBUG3(printk("scsi(%ld): Getting FCAL position map\n", vha->host_no));
+	DEBUG3(qla2x00_get_fcal_position_map(vha, NULL));
 
 	/* Get list of logged in devices. */
 	memset(ha->gid_list, 0, GID_LIST_SIZE);
-	rval = qla2x00_get_id_list(ha, ha->gid_list, ha->gid_list_dma,
+	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
 	    &entries);
 	if (rval != QLA_SUCCESS)
 		goto cleanup_allocation;
@@ -2082,7 +2111,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 	    entries * sizeof(struct gid_list_info)));
 
 	/* Allocate temporary fcport for any new fcports discovered. */
-	new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+	new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (new_fcport == NULL) {
 		rval = QLA_MEMORY_ALLOC_FAILED;
 		goto cleanup_allocation;
@@ -2092,17 +2121,14 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 	/*
 	 * Mark local devices that were present with FCF_DEVICE_LOST for now.
 	 */
-	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (fcport->vp_idx != ha->vp_idx)
-			continue;
-
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (atomic_read(&fcport->state) == FCS_ONLINE &&
 		    fcport->port_type != FCT_BROADCAST &&
 		    (fcport->flags & FCF_FABRIC_DEVICE) == 0) {
 
 			DEBUG(printk("scsi(%ld): Marking port lost, "
 			    "loop_id=0x%04x\n",
-			    ha->host_no, fcport->loop_id));
+			    vha->host_no, fcport->loop_id));
 
 			atomic_set(&fcport->state, FCS_DEVICE_LOST);
 			fcport->flags &= ~FCF_FARP_DONE;
@@ -2129,7 +2155,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 
 		/* Bypass if not same domain and area of adapter. */
 		if (area && domain &&
-		    (area != ha->d_id.b.area || domain != ha->d_id.b.domain))
+		    (area != vha->d_id.b.area || domain != vha->d_id.b.domain))
 			continue;
 
 		/* Bypass invalid local loop ID. */
@@ -2141,26 +2167,23 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		new_fcport->d_id.b.area = area;
 		new_fcport->d_id.b.al_pa = al_pa;
 		new_fcport->loop_id = loop_id;
-		new_fcport->vp_idx = ha->vp_idx;
-		rval2 = qla2x00_get_port_database(ha, new_fcport, 0);
+		new_fcport->vp_idx = vha->vp_idx;
+		rval2 = qla2x00_get_port_database(vha, new_fcport, 0);
 		if (rval2 != QLA_SUCCESS) {
 			DEBUG2(printk("scsi(%ld): Failed to retrieve fcport "
 			    "information -- get_port_database=%x, "
 			    "loop_id=0x%04x\n",
-			    ha->host_no, rval2, new_fcport->loop_id));
+			    vha->host_no, rval2, new_fcport->loop_id));
 			DEBUG2(printk("scsi(%ld): Scheduling resync...\n",
-			    ha->host_no));
-			set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+			    vha->host_no));
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			continue;
 		}
 
 		/* Check for matching device in port list. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (fcport->vp_idx != ha->vp_idx)
-				continue;
-
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (memcmp(new_fcport->port_name, fcport->port_name,
 			    WWN_SIZE))
 				continue;
@@ -2180,17 +2203,15 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		if (!found) {
 			/* New device, add to fcports list. */
 			new_fcport->flags &= ~FCF_PERSISTENT_BOUND;
-			if (ha->parent) {
-				new_fcport->ha = ha;
-				new_fcport->vp_idx = ha->vp_idx;
-				list_add_tail(&new_fcport->vp_fcport,
-				    &ha->vp_fcports);
+			if (vha->vp_idx) {
+				new_fcport->vha = vha;
+				new_fcport->vp_idx = vha->vp_idx;
 			}
-			list_add_tail(&new_fcport->list, &pha->fcports);
+			list_add_tail(&new_fcport->list, &vha->vp_fcports);
 
 			/* Allocate a new replacement fcport. */
 			fcport = new_fcport;
-			new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+			new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 			if (new_fcport == NULL) {
 				rval = QLA_MEMORY_ALLOC_FAILED;
 				goto cleanup_allocation;
@@ -2201,7 +2222,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		/* Base iIDMA settings on HBA port speed. */
 		fcport->fp_speed = ha->link_data_rate;
 
-		qla2x00_update_fcport(ha, fcport);
+		qla2x00_update_fcport(vha, fcport);
 
 		found_devs++;
 	}
@@ -2211,24 +2232,25 @@ cleanup_allocation:
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): Configure local loop error exit: "
-		    "rval=%x\n", ha->host_no, rval));
+		    "rval=%x\n", vha->host_no, rval));
 	}
 
 	if (found_devs) {
-		ha->device_flags |= DFLG_LOCAL_DEVICES;
-		ha->device_flags &= ~DFLG_RETRY_LOCAL_DEVICES;
+		vha->device_flags |= DFLG_LOCAL_DEVICES;
+		vha->device_flags &= ~DFLG_RETRY_LOCAL_DEVICES;
 	}
 
 	return (rval);
 }
 
 static void
-qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 #define LS_UNKNOWN      2
 	static char *link_speeds[5] = { "1", "2", "?", "4", "8" };
 	int rval;
 	uint16_t mb[6];
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_IIDMA_CAPABLE(ha))
 		return;
@@ -2237,12 +2259,12 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 	    fcport->fp_speed > ha->link_data_rate)
 		return;
 
-	rval = qla2x00_set_idma_speed(ha, fcport->loop_id, fcport->fp_speed,
+	rval = qla2x00_set_idma_speed(vha, fcport->loop_id, fcport->fp_speed,
 	    mb);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): Unable to adjust iIDMA "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
-		    ha->host_no, fcport->port_name[0], fcport->port_name[1],
+		    vha->host_no, fcport->port_name[0], fcport->port_name[1],
 		    fcport->port_name[2], fcport->port_name[3],
 		    fcport->port_name[4], fcport->port_name[5],
 		    fcport->port_name[6], fcport->port_name[7], rval,
@@ -2260,10 +2282,11 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 }
 
 static void
-qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (fcport->drport)
 		qla2x00_rport_del(fcport);
@@ -2273,15 +2296,15 @@ qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
 	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
-	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	fcport->rport = rport = fc_remote_port_add(vha->host, 0, &rport_ids);
 	if (!rport) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
-	spin_lock_irq(fcport->ha->host->host_lock);
+	spin_lock_irq(fcport->vha->host->host_lock);
 	*((fc_port_t **)rport->dd_data) = fcport;
-	spin_unlock_irq(fcport->ha->host->host_lock);
+	spin_unlock_irq(fcport->vha->host->host_lock);
 
 	rport->supported_classes = fcport->supported_classes;
 
@@ -2309,23 +2332,23 @@ qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
  *	Kernel context.
  */
 void
-qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
-	fcport->ha = ha;
+	fcport->vha = vha;
 	fcport->login_retry = 0;
-	fcport->port_login_retry_count = pha->port_down_retry_count *
+	fcport->port_login_retry_count = ha->port_down_retry_count *
 	    PORT_RETRY_TIME;
-	atomic_set(&fcport->port_down_timer, pha->port_down_retry_count *
+	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
 	    PORT_RETRY_TIME);
 	fcport->flags &= ~FCF_LOGIN_NEEDED;
 
-	qla2x00_iidma_fcport(ha, fcport);
+	qla2x00_iidma_fcport(vha, fcport);
 
 	atomic_set(&fcport->state, FCS_ONLINE);
 
-	qla2x00_reg_remote_port(ha, fcport);
+	qla2x00_reg_remote_port(vha, fcport);
 }
 
 /*
@@ -2340,7 +2363,7 @@ qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
  *      BIT_0 = error
  */
 static int
-qla2x00_configure_fabric(scsi_qla_host_t *ha)
+qla2x00_configure_fabric(scsi_qla_host_t *vha)
 {
 	int	rval, rval2;
 	fc_port_t	*fcport, *fcptemp;
@@ -2348,25 +2371,26 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
 	LIST_HEAD(new_fcports);
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* If FL port exists, then SNS is present */
 	if (IS_FWI2_CAPABLE(ha))
 		loop_id = NPH_F_PORT;
 	else
 		loop_id = SNS_FL_PORT;
-	rval = qla2x00_get_port_name(ha, loop_id, ha->fabric_node_name, 1);
+	rval = qla2x00_get_port_name(vha, loop_id, vha->fabric_node_name, 1);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): MBC_GET_PORT_NAME Failed, No FL "
-		    "Port\n", ha->host_no));
+		    "Port\n", vha->host_no));
 
-		ha->device_flags &= ~SWITCH_FOUND;
+		vha->device_flags &= ~SWITCH_FOUND;
 		return (QLA_SUCCESS);
 	}
-	ha->device_flags |= SWITCH_FOUND;
+	vha->device_flags |= SWITCH_FOUND;
 
 	/* Mark devices that need re-synchronization. */
-	rval2 = qla2x00_device_resync(ha);
+	rval2 = qla2x00_device_resync(vha);
 	if (rval2 == QLA_RSCNS_HANDLED) {
 		/* No point doing the scan, just continue. */
 		return (QLA_SUCCESS);
@@ -2374,15 +2398,15 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 	do {
 		/* FDMI support. */
 		if (ql2xfdmienable &&
-		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags))
-			qla2x00_fdmi_register(ha);
+		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags))
+			qla2x00_fdmi_register(vha);
 
 		/* Ensure we are logged into the SNS. */
 		if (IS_FWI2_CAPABLE(ha))
 			loop_id = NPH_SNS;
 		else
 			loop_id = SIMPLE_NAME_SERVER;
-		ha->isp_ops->fabric_login(ha, loop_id, 0xff, 0xff,
+		ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
 		    0xfc, mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
@@ -2392,29 +2416,29 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 			return (QLA_SUCCESS);
 		}
 
-		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags)) {
-			if (qla2x00_rft_id(ha)) {
+		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags)) {
+			if (qla2x00_rft_id(vha)) {
 				/* EMPTY */
 				DEBUG2(printk("scsi(%ld): Register FC-4 "
-				    "TYPE failed.\n", ha->host_no));
+				    "TYPE failed.\n", vha->host_no));
 			}
-			if (qla2x00_rff_id(ha)) {
+			if (qla2x00_rff_id(vha)) {
 				/* EMPTY */
 				DEBUG2(printk("scsi(%ld): Register FC-4 "
-				    "Features failed.\n", ha->host_no));
+				    "Features failed.\n", vha->host_no));
 			}
-			if (qla2x00_rnn_id(ha)) {
+			if (qla2x00_rnn_id(vha)) {
 				/* EMPTY */
 				DEBUG2(printk("scsi(%ld): Register Node Name "
-				    "failed.\n", ha->host_no));
-			} else if (qla2x00_rsnn_nn(ha)) {
+				    "failed.\n", vha->host_no));
+			} else if (qla2x00_rsnn_nn(vha)) {
 				/* EMPTY */
 				DEBUG2(printk("scsi(%ld): Register Symbolic "
-				    "Node Name failed.\n", ha->host_no));
+				    "Node Name failed.\n", vha->host_no));
 			}
 		}
 
-		rval = qla2x00_find_all_fabric_devs(ha, &new_fcports);
+		rval = qla2x00_find_all_fabric_devs(vha, &new_fcports);
 		if (rval != QLA_SUCCESS)
 			break;
 
@@ -2422,24 +2446,21 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 		 * Logout all previous fabric devices marked lost, except
 		 * tape devices.
 		 */
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (fcport->vp_idx !=ha->vp_idx)
-				continue;
-
-			if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 				break;
 
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 				continue;
 
 			if (atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
-				qla2x00_mark_device_lost(ha, fcport,
+				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
 				    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
-					ha->isp_ops->fabric_logout(ha,
+					ha->isp_ops->fabric_logout(vha,
 					    fcport->loop_id,
 					    fcport->d_id.b.domain,
 					    fcport->d_id.b.area,
@@ -2450,18 +2471,15 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 		}
 
 		/* Starting free loop ID. */
-		next_loopid = pha->min_external_loopid;
+		next_loopid = ha->min_external_loopid;
 
 		/*
 		 * Scan through our port list and login entries that need to be
 		 * logged in.
 		 */
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (fcport->vp_idx != ha->vp_idx)
-				continue;
-
-			if (atomic_read(&ha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (atomic_read(&vha->loop_down_timer) ||
+			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 				break;
 
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
@@ -2471,14 +2489,14 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 			if (fcport->loop_id == FC_NO_LOOP_ID) {
 				fcport->loop_id = next_loopid;
 				rval = qla2x00_find_new_loop_id(
-				    to_qla_parent(ha), fcport);
+				    base_vha, fcport);
 				if (rval != QLA_SUCCESS) {
 					/* Ran out of IDs to use */
 					break;
 				}
 			}
 			/* Login and update database */
-			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
+			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
 		}
 
 		/* Exit if out of loop IDs. */
@@ -2490,31 +2508,26 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 		 * Login and add the new devices to our port list.
 		 */
 		list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
-			if (atomic_read(&ha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
+			if (atomic_read(&vha->loop_down_timer) ||
+			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 				break;
 
 			/* Find a new loop ID to use. */
 			fcport->loop_id = next_loopid;
-			rval = qla2x00_find_new_loop_id(to_qla_parent(ha),
-			    fcport);
+			rval = qla2x00_find_new_loop_id(base_vha, fcport);
 			if (rval != QLA_SUCCESS) {
 				/* Ran out of IDs to use */
 				break;
 			}
 
 			/* Login and update database */
-			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
-
-			if (ha->parent) {
-				fcport->ha = ha;
-				fcport->vp_idx = ha->vp_idx;
-				list_add_tail(&fcport->vp_fcport,
-				    &ha->vp_fcports);
-				list_move_tail(&fcport->list,
-				    &ha->parent->fcports);
-			} else
-				list_move_tail(&fcport->list, &ha->fcports);
+			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
+
+			if (vha->vp_idx) {
+				fcport->vha = vha;
+				fcport->vp_idx = vha->vp_idx;
+			}
+			list_move_tail(&fcport->list, &vha->vp_fcports);
 		}
 	} while (0);
 
@@ -2526,7 +2539,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 
 	if (rval) {
 		DEBUG2(printk("scsi(%ld): Configure fabric error exit: "
-		    "rval=%d\n", ha->host_no, rval));
+		    "rval=%d\n", vha->host_no, rval));
 	}
 
 	return (rval);
@@ -2547,7 +2560,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 static int
-qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
+qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
+	struct list_head *new_fcports)
 {
 	int		rval;
 	uint16_t	loop_id;
@@ -2558,11 +2572,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 	int		swl_idx;
 	int		first_dev, last_dev;
 	port_id_t	wrap, nxt_d_id;
-	int 		vp_index;
-	int		empty_vp_index;
-	int		found_vp;
-	scsi_qla_host_t *vha;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
 
 	rval = QLA_SUCCESS;
 
@@ -2571,43 +2582,42 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 	if (!swl) {
 		/*EMPTY*/
 		DEBUG2(printk("scsi(%ld): GID_PT allocations failed, fallback "
-		    "on GA_NXT\n", ha->host_no));
+		    "on GA_NXT\n", vha->host_no));
 	} else {
-		if (qla2x00_gid_pt(ha, swl) != QLA_SUCCESS) {
+		if (qla2x00_gid_pt(vha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
-		} else if (qla2x00_gpn_id(ha, swl) != QLA_SUCCESS) {
+		} else if (qla2x00_gpn_id(vha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
-		} else if (qla2x00_gnn_id(ha, swl) != QLA_SUCCESS) {
+		} else if (qla2x00_gnn_id(vha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
 		} else if (ql2xiidmaenable &&
-		    qla2x00_gfpn_id(ha, swl) == QLA_SUCCESS) {
-			qla2x00_gpsc(ha, swl);
+		    qla2x00_gfpn_id(vha, swl) == QLA_SUCCESS) {
+			qla2x00_gpsc(vha, swl);
 		}
 	}
 	swl_idx = 0;
 
 	/* Allocate temporary fcport for any new fcports discovered. */
-	new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+	new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (new_fcport == NULL) {
 		kfree(swl);
 		return (QLA_MEMORY_ALLOC_FAILED);
 	}
 	new_fcport->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
-	new_fcport->vp_idx = ha->vp_idx;
 	/* Set start port ID scan at adapter ID. */
 	first_dev = 1;
 	last_dev = 0;
 
 	/* Starting free loop ID. */
-	loop_id = pha->min_external_loopid;
-	for (; loop_id <= ha->last_loop_id; loop_id++) {
-		if (qla2x00_is_reserved_id(ha, loop_id))
+	loop_id = ha->min_external_loopid;
+	for (; loop_id <= ha->max_loop_id; loop_id++) {
+		if (qla2x00_is_reserved_id(vha, loop_id))
 			continue;
 
-		if (atomic_read(&ha->loop_down_timer) || LOOP_TRANSITION(ha))
+		if (atomic_read(&vha->loop_down_timer) || LOOP_TRANSITION(vha))
 			break;
 
 		if (swl != NULL) {
@@ -2630,7 +2640,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 			}
 		} else {
 			/* Send GA_NXT to the switch */
-			rval = qla2x00_ga_nxt(ha, new_fcport);
+			rval = qla2x00_ga_nxt(vha, new_fcport);
 			if (rval != QLA_SUCCESS) {
 				qla_printk(KERN_WARNING, ha,
 				    "SNS scan failed -- assuming zero-entry "
@@ -2651,44 +2661,31 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 			first_dev = 0;
 		} else if (new_fcport->d_id.b24 == wrap.b24) {
 			DEBUG2(printk("scsi(%ld): device wrap (%02x%02x%02x)\n",
-			    ha->host_no, new_fcport->d_id.b.domain,
+			    vha->host_no, new_fcport->d_id.b.domain,
 			    new_fcport->d_id.b.area, new_fcport->d_id.b.al_pa));
 			break;
 		}
 
 		/* Bypass if same physical adapter. */
-		if (new_fcport->d_id.b24 == pha->d_id.b24)
+		if (new_fcport->d_id.b24 == base_vha->d_id.b24)
 			continue;
 
 		/* Bypass virtual ports of the same host. */
-		if (pha->num_vhosts) {
-			for_each_mapped_vp_idx(pha, vp_index) {
-				empty_vp_index = 1;
-				found_vp = 0;
-				list_for_each_entry(vha, &pha->vp_list,
-				    vp_list) {
-					if (vp_index == vha->vp_idx) {
-						empty_vp_index = 0;
-						found_vp = 1;
-						break;
-					}
-				}
-
-				if (empty_vp_index)
-					continue;
-
-				if (found_vp &&
-				    new_fcport->d_id.b24 == vha->d_id.b24)
+		found = 0;
+		if (ha->num_vhosts) {
+			list_for_each_entry(vp, &ha->vp_list, list) {
+				if (new_fcport->d_id.b24 == vp->d_id.b24) {
+					found = 1;
 					break;
+				}
 			}
-
-			if (vp_index <= pha->max_npiv_vports)
+			if (found)
 				continue;
 		}
 
 		/* Bypass if same domain and area of adapter. */
 		if (((new_fcport->d_id.b24 & 0xffff00) ==
-		    (ha->d_id.b24 & 0xffff00)) && ha->current_topology ==
+		    (vha->d_id.b24 & 0xffff00)) && ha->current_topology ==
 			ISP_CFG_FL)
 			    continue;
 
@@ -2698,9 +2695,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 
 		/* Locate matching device in database. */
 		found = 0;
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (new_fcport->vp_idx != fcport->vp_idx)
-				continue;
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (memcmp(new_fcport->port_name, fcport->port_name,
 			    WWN_SIZE))
 				continue;
@@ -2744,7 +2739,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
-				ha->isp_ops->fabric_logout(ha, fcport->loop_id,
+				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 				    fcport->d_id.b.domain, fcport->d_id.b.area,
 				    fcport->d_id.b.al_pa);
 				fcport->loop_id = FC_NO_LOOP_ID;
@@ -2755,27 +2750,25 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 
 		if (found)
 			continue;
-
 		/* If device was not in our fcports list, then add it. */
 		list_add_tail(&new_fcport->list, new_fcports);
 
 		/* Allocate a new replacement fcport. */
 		nxt_d_id.b24 = new_fcport->d_id.b24;
-		new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+		new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 		if (new_fcport == NULL) {
 			kfree(swl);
 			return (QLA_MEMORY_ALLOC_FAILED);
 		}
 		new_fcport->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
 		new_fcport->d_id.b24 = nxt_d_id.b24;
-		new_fcport->vp_idx = ha->vp_idx;
 	}
 
 	kfree(swl);
 	kfree(new_fcport);
 
 	if (!list_empty(new_fcports))
-		ha->device_flags |= DFLG_FABRIC_DEVICES;
+		vha->device_flags |= DFLG_FABRIC_DEVICES;
 
 	return (rval);
 }
@@ -2795,13 +2788,14 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
  *	Kernel context.
  */
 static int
-qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
+qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 {
 	int	rval;
 	int	found;
 	fc_port_t *fcport;
 	uint16_t first_loop_id;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vp;
 
 	rval = QLA_SUCCESS;
 
@@ -2810,17 +2804,15 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
 
 	for (;;) {
 		/* Skip loop ID if already used by adapter. */
-		if (dev->loop_id == ha->loop_id) {
+		if (dev->loop_id == vha->loop_id)
 			dev->loop_id++;
-		}
 
 		/* Skip reserved loop IDs. */
-		while (qla2x00_is_reserved_id(ha, dev->loop_id)) {
+		while (qla2x00_is_reserved_id(vha, dev->loop_id))
 			dev->loop_id++;
-		}
 
 		/* Reset loop ID if passed the end. */
-		if (dev->loop_id > ha->last_loop_id) {
+		if (dev->loop_id > ha->max_loop_id) {
 			/* first loop ID. */
 			dev->loop_id = ha->min_external_loopid;
 		}
@@ -2828,12 +2820,17 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (fcport->loop_id == dev->loop_id && fcport != dev) {
-				/* ID possibly in use */
-				found++;
-				break;
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			list_for_each_entry(fcport, &vp->vp_fcports, list) {
+				if (fcport->loop_id == dev->loop_id &&
+								fcport != dev) {
+					/* ID possibly in use */
+					found++;
+					break;
+				}
 			}
+			if (found)
+				break;
 		}
 
 		/* If not in use then it is free to use. */
@@ -2866,7 +2863,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *ha, fc_port_t *dev)
  *	Kernel context.
  */
 static int
-qla2x00_device_resync(scsi_qla_host_t *ha)
+qla2x00_device_resync(scsi_qla_host_t *vha)
 {
 	int	rval;
 	uint32_t mask;
@@ -2875,14 +2872,13 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
 	uint8_t rscn_out_iter;
 	uint8_t format;
 	port_id_t d_id;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	rval = QLA_RSCNS_HANDLED;
 
-	while (ha->rscn_out_ptr != ha->rscn_in_ptr ||
-	    ha->flags.rscn_queue_overflow) {
+	while (vha->rscn_out_ptr != vha->rscn_in_ptr ||
+	    vha->flags.rscn_queue_overflow) {
 
-		rscn_entry = ha->rscn_queue[ha->rscn_out_ptr];
+		rscn_entry = vha->rscn_queue[vha->rscn_out_ptr];
 		format = MSB(MSW(rscn_entry));
 		d_id.b.domain = LSB(MSW(rscn_entry));
 		d_id.b.area = MSB(LSW(rscn_entry));
@@ -2890,37 +2886,37 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
 
 		DEBUG(printk("scsi(%ld): RSCN queue entry[%d] = "
 		    "[%02x/%02x%02x%02x].\n",
-		    ha->host_no, ha->rscn_out_ptr, format, d_id.b.domain,
+		    vha->host_no, vha->rscn_out_ptr, format, d_id.b.domain,
 		    d_id.b.area, d_id.b.al_pa));
 
-		ha->rscn_out_ptr++;
-		if (ha->rscn_out_ptr == MAX_RSCN_COUNT)
-			ha->rscn_out_ptr = 0;
+		vha->rscn_out_ptr++;
+		if (vha->rscn_out_ptr == MAX_RSCN_COUNT)
+			vha->rscn_out_ptr = 0;
 
 		/* Skip duplicate entries. */
-		for (rscn_out_iter = ha->rscn_out_ptr;
-		    !ha->flags.rscn_queue_overflow &&
-		    rscn_out_iter != ha->rscn_in_ptr;
+		for (rscn_out_iter = vha->rscn_out_ptr;
+		    !vha->flags.rscn_queue_overflow &&
+		    rscn_out_iter != vha->rscn_in_ptr;
 		    rscn_out_iter = (rscn_out_iter ==
 			(MAX_RSCN_COUNT - 1)) ? 0: rscn_out_iter + 1) {
 
-			if (rscn_entry != ha->rscn_queue[rscn_out_iter])
+			if (rscn_entry != vha->rscn_queue[rscn_out_iter])
 				break;
 
 			DEBUG(printk("scsi(%ld): Skipping duplicate RSCN queue "
-			    "entry found at [%d].\n", ha->host_no,
+			    "entry found at [%d].\n", vha->host_no,
 			    rscn_out_iter));
 
-			ha->rscn_out_ptr = rscn_out_iter;
+			vha->rscn_out_ptr = rscn_out_iter;
 		}
 
 		/* Queue overflow, set switch default case. */
-		if (ha->flags.rscn_queue_overflow) {
+		if (vha->flags.rscn_queue_overflow) {
 			DEBUG(printk("scsi(%ld): device_resync: rscn "
-			    "overflow.\n", ha->host_no));
+			    "overflow.\n", vha->host_no));
 
 			format = 3;
-			ha->flags.rscn_queue_overflow = 0;
+			vha->flags.rscn_queue_overflow = 0;
 		}
 
 		switch (format) {
@@ -2936,16 +2932,13 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
 		default:
 			mask = 0x0;
 			d_id.b24 = 0;
-			ha->rscn_out_ptr = ha->rscn_in_ptr;
+			vha->rscn_out_ptr = vha->rscn_in_ptr;
 			break;
 		}
 
 		rval = QLA_SUCCESS;
 
-		list_for_each_entry(fcport, &pha->fcports, list) {
-			if (fcport->vp_idx != ha->vp_idx)
-				continue;
-
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
 			    (fcport->d_id.b24 & mask) != d_id.b24 ||
 			    fcport->port_type == FCT_BROADCAST)
@@ -2954,7 +2947,7 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
 			if (atomic_read(&fcport->state) == FCS_ONLINE) {
 				if (format != 3 ||
 				    fcport->port_type != FCT_INITIATOR) {
-					qla2x00_mark_device_lost(ha, fcport,
+					qla2x00_mark_device_lost(vha, fcport,
 					    0, 0);
 				}
 			}
@@ -2981,30 +2974,31 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 static int
-qla2x00_fabric_dev_login(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
     uint16_t *next_loopid)
 {
 	int	rval;
 	int	retry;
 	uint8_t opts;
+	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_SUCCESS;
 	retry = 0;
 
-	rval = qla2x00_fabric_login(ha, fcport, next_loopid);
+	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
 		/* Send an ADISC to tape devices.*/
 		opts = 0;
 		if (fcport->flags & FCF_TAPE_PRESENT)
 			opts |= BIT_1;
-		rval = qla2x00_get_port_database(ha, fcport, opts);
+		rval = qla2x00_get_port_database(vha, fcport, opts);
 		if (rval != QLA_SUCCESS) {
-			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(ha, fcport, 1, 0);
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
 		} else {
-			qla2x00_update_fcport(ha, fcport);
+			qla2x00_update_fcport(vha, fcport);
 		}
 	}
 
@@ -3026,13 +3020,14 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *ha, fc_port_t *fcport,
  *      3 - Fatal error
  */
 int
-qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
     uint16_t *next_loopid)
 {
 	int	rval;
 	int	retry;
 	uint16_t tmp_loopid;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	struct qla_hw_data *ha = vha->hw;
 
 	retry = 0;
 	tmp_loopid = 0;
@@ -3040,11 +3035,11 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 	for (;;) {
 		DEBUG(printk("scsi(%ld): Trying Fabric Login w/loop id 0x%04x "
  		    "for port %02x%02x%02x.\n",
- 		    ha->host_no, fcport->loop_id, fcport->d_id.b.domain,
+		    vha->host_no, fcport->loop_id, fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa));
 
 		/* Login fcport on switch. */
-		ha->isp_ops->fabric_login(ha, fcport->loop_id,
+		ha->isp_ops->fabric_login(vha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb, BIT_0);
 		if (mb[0] == MBS_PORT_ID_USED) {
@@ -3100,7 +3095,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			 * Loop ID already used, try next loop ID.
 			 */
 			fcport->loop_id++;
-			rval = qla2x00_find_new_loop_id(ha, fcport);
+			rval = qla2x00_find_new_loop_id(vha, fcport);
 			if (rval != QLA_SUCCESS) {
 				/* Ran out of loop IDs to use */
 				break;
@@ -3112,10 +3107,10 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			 * dead.
 			 */
 			*next_loopid = fcport->loop_id;
-			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(ha, fcport, 1, 0);
+			qla2x00_mark_device_lost(vha, fcport, 1, 0);
 
 			rval = 1;
 			break;
@@ -3125,12 +3120,12 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
 			 */
 			DEBUG2(printk("%s(%ld): failed=%x port_id=%02x%02x%02x "
  			    "loop_id=%x jiffies=%lx.\n",
- 			    __func__, ha->host_no, mb[0],
+			    __func__, vha->host_no, mb[0],
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
 
 			*next_loopid = fcport->loop_id;
-			ha->isp_ops->fabric_logout(ha, fcport->loop_id,
+			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			fcport->loop_id = FC_NO_LOOP_ID;
@@ -3158,13 +3153,13 @@ qla2x00_fabric_login(scsi_qla_host_t *ha, fc_port_t *fcport,
  *      3 - Fatal error
  */
 int
-qla2x00_local_device_login(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_local_device_login(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int		rval;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 
 	memset(mb, 0, sizeof(mb));
-	rval = qla2x00_login_local_device(ha, fcport, mb, BIT_0);
+	rval = qla2x00_login_local_device(vha, fcport, mb, BIT_0);
 	if (rval == QLA_SUCCESS) {
 		/* Interrogate mailbox registers for any errors */
 		if (mb[0] == MBS_COMMAND_ERROR)
@@ -3188,57 +3183,55 @@ qla2x00_local_device_login(scsi_qla_host_t *ha, fc_port_t *fcport)
  *      0 = success
  */
 int
-qla2x00_loop_resync(scsi_qla_host_t *ha)
+qla2x00_loop_resync(scsi_qla_host_t *vha)
 {
 	int   rval;
 	uint32_t wait_time;
 
 	rval = QLA_SUCCESS;
 
-	atomic_set(&ha->loop_state, LOOP_UPDATE);
-	clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
-	if (ha->flags.online) {
-		if (!(rval = qla2x00_fw_ready(ha))) {
+	atomic_set(&vha->loop_state, LOOP_UPDATE);
+	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+	if (vha->flags.online) {
+		if (!(rval = qla2x00_fw_ready(vha))) {
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				atomic_set(&ha->loop_state, LOOP_UPDATE);
+				atomic_set(&vha->loop_state, LOOP_UPDATE);
 
 				/* Issue a marker after FW becomes ready. */
-				qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
-				ha->marker_needed = 0;
+				qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
+				vha->marker_needed = 0;
 
 				/* Remap devices on Loop. */
-				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+				clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 
-				qla2x00_configure_loop(ha);
+				qla2x00_configure_loop(vha);
 				wait_time--;
-			} while (!atomic_read(&ha->loop_down_timer) &&
-				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
-				wait_time &&
-				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
+			} while (!atomic_read(&vha->loop_down_timer) &&
+				!(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+				&& wait_time && (test_bit(LOOP_RESYNC_NEEDED,
+				&vha->dpc_flags)));
 		}
 	}
 
-	if (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
 		return (QLA_FUNCTION_FAILED);
-	}
 
-	if (rval) {
+	if (rval)
 		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
-	}
 
 	return (rval);
 }
 
 void
-qla2x00_update_fcports(scsi_qla_host_t *ha)
+qla2x00_update_fcports(scsi_qla_host_t *vha)
 {
 	fc_port_t *fcport;
 
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry(fcport, &ha->fcports, list)
-		if (fcport->drport &&
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		if (fcport && fcport->drport &&
 		    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
 			qla2x00_rport_del(fcport);
 }
@@ -3254,63 +3247,64 @@ qla2x00_update_fcports(scsi_qla_host_t *ha)
 *      0 = success
 */
 int
-qla2x00_abort_isp(scsi_qla_host_t *ha)
+qla2x00_abort_isp(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint8_t        status = 0;
-	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vp;
 
-	if (ha->flags.online) {
-		ha->flags.online = 0;
-		clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	if (vha->flags.online) {
+		vha->flags.online = 0;
+		clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		ha->qla_stats.total_isp_aborts++;
 
 		qla_printk(KERN_INFO, ha,
 		    "Performing ISP error recovery - ha= %p.\n", ha);
-		ha->isp_ops->reset_chip(ha);
-
-		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			qla2x00_mark_all_devices_lost(ha, 0);
-			list_for_each_entry(vha, &ha->vp_list, vp_list)
-			       qla2x00_mark_all_devices_lost(vha, 0);
+		ha->isp_ops->reset_chip(vha);
+
+		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			qla2x00_mark_all_devices_lost(vha, 0);
+			list_for_each_entry(vp, &ha->vp_list, list)
+			       qla2x00_mark_all_devices_lost(vp, 0);
 		} else {
-			if (!atomic_read(&ha->loop_down_timer))
-				atomic_set(&ha->loop_down_timer,
+			if (!atomic_read(&vha->loop_down_timer))
+				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
 		}
 
 		/* Requeue all commands in outstanding command list. */
-		qla2x00_abort_all_cmds(ha, DID_RESET << 16);
+		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 
-		ha->isp_ops->get_flash_version(ha, ha->request_ring);
+		ha->isp_ops->get_flash_version(vha, ha->req->ring);
 
-		ha->isp_ops->nvram_config(ha);
+		ha->isp_ops->nvram_config(vha);
 
-		if (!qla2x00_restart_isp(ha)) {
-			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+		if (!qla2x00_restart_isp(vha)) {
+			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
-			if (!atomic_read(&ha->loop_down_timer)) {
+			if (!atomic_read(&vha->loop_down_timer)) {
 				/*
 				 * Issue marker command only when we are going
 				 * to start the I/O .
 				 */
-				ha->marker_needed = 1;
+				vha->marker_needed = 1;
 			}
 
-			ha->flags.online = 1;
+			vha->flags.online = 1;
 
 			ha->isp_ops->enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0;
-			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
+			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 
 			if (ha->fce) {
 				ha->flags.fce_enabled = 1;
 				memset(ha->fce, 0,
 				    fce_calc_size(ha->fce_bufs));
-				rval = qla2x00_enable_fce_trace(ha,
+				rval = qla2x00_enable_fce_trace(vha,
 				    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
 				    &ha->fce_bufs);
 				if (rval) {
@@ -3323,7 +3317,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 			if (ha->eft) {
 				memset(ha->eft, 0, EFT_SIZE);
-				rval = qla2x00_enable_eft_trace(ha,
+				rval = qla2x00_enable_eft_trace(vha,
 				    ha->eft_dma, EFT_NUM_BUFFERS);
 				if (rval) {
 					qla_printk(KERN_WARNING, ha,
@@ -3332,8 +3326,8 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				}
 			}
 		} else {	/* failed the ISP abort */
-			ha->flags.online = 1;
-			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
+			vha->flags.online = 1;
+			if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 				if (ha->isp_abort_cnt == 0) {
  					qla_printk(KERN_WARNING, ha,
 					    "ISP error recovery failed - "
@@ -3342,37 +3336,41 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					 * The next call disables the board
 					 * completely.
 					 */
-					ha->isp_ops->reset_adapter(ha);
-					ha->flags.online = 0;
+					ha->isp_ops->reset_adapter(vha);
+					vha->flags.online = 0;
 					clear_bit(ISP_ABORT_RETRY,
-					    &ha->dpc_flags);
+					    &vha->dpc_flags);
 					status = 0;
 				} else { /* schedule another ISP abort */
 					ha->isp_abort_cnt--;
 					DEBUG(printk("qla%ld: ISP abort - "
 					    "retry remaining %d\n",
-					    ha->host_no, ha->isp_abort_cnt));
+					    vha->host_no, ha->isp_abort_cnt));
 					status = 1;
 				}
 			} else {
 				ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
 				DEBUG(printk("qla2x00(%ld): ISP error recovery "
 				    "- retrying (%d) more times\n",
-				    ha->host_no, ha->isp_abort_cnt));
-				set_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
+				    vha->host_no, ha->isp_abort_cnt));
+				set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 				status = 1;
 			}
 		}
 
 	}
 
-	if (status) {
+	if (!status) {
+		DEBUG(printk(KERN_INFO
+				"qla2x00_abort_isp(%ld): succeeded.\n",
+				vha->host_no));
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp->vp_idx)
+				qla2x00_vp_abort_isp(vp);
+		}
+	} else {
 		qla_printk(KERN_INFO, ha,
 			"qla2x00_abort_isp: **** FAILED ****\n");
-	} else {
-		DEBUG(printk(KERN_INFO
-				"qla2x00_abort_isp(%ld): exiting.\n",
-				ha->host_no));
 	}
 
 	return(status);
@@ -3389,42 +3387,45 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 *      0 = success
 */
 static int
-qla2x00_restart_isp(scsi_qla_host_t *ha)
+qla2x00_restart_isp(scsi_qla_host_t *vha)
 {
 	uint8_t		status = 0;
 	uint32_t wait_time;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* If firmware needs to be loaded */
-	if (qla2x00_isp_firmware(ha)) {
-		ha->flags.online = 0;
-		if (!(status = ha->isp_ops->chip_diag(ha)))
-			status = qla2x00_setup_chip(ha);
+	if (qla2x00_isp_firmware(vha)) {
+		vha->flags.online = 0;
+		status = ha->isp_ops->chip_diag(vha);
+		if (!status)
+			status = qla2x00_setup_chip(vha);
 	}
 
-	if (!status && !(status = qla2x00_init_rings(ha))) {
-		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		if (!(status = qla2x00_fw_ready(ha))) {
+	if (!status && !(status = qla2x00_init_rings(vha))) {
+		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+		status = qla2x00_fw_ready(vha);
+		if (!status) {
 			DEBUG(printk("%s(): Start configure loop, "
 			    "status = %d\n", __func__, status));
 
 			/* Issue a marker after FW becomes ready. */
-			qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+			qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
 
-			ha->flags.online = 1;
+			vha->flags.online = 1;
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-				qla2x00_configure_loop(ha);
+				clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+				qla2x00_configure_loop(vha);
 				wait_time--;
-			} while (!atomic_read(&ha->loop_down_timer) &&
-				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
-				wait_time &&
-				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
+			} while (!atomic_read(&vha->loop_down_timer) &&
+				!(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+				&& wait_time && (test_bit(LOOP_RESYNC_NEEDED,
+				&vha->dpc_flags)));
 		}
 
 		/* if no cable then assume it's good */
-		if ((ha->device_flags & DFLG_NO_CABLE))
+		if ((vha->device_flags & DFLG_NO_CABLE))
 			status = 0;
 
 		DEBUG(printk("%s(): Configure loop done, status = 0x%x\n",
@@ -3442,12 +3443,13 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 *      ha = adapter block pointer.
 */
 void
-qla2x00_reset_adapter(scsi_qla_host_t *ha)
+qla2x00_reset_adapter(scsi_qla_host_t *vha)
 {
 	unsigned long flags = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	ha->flags.online = 0;
+	vha->flags.online = 0;
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -3459,12 +3461,13 @@ qla2x00_reset_adapter(scsi_qla_host_t *ha)
 }
 
 void
-qla24xx_reset_adapter(scsi_qla_host_t *ha)
+qla24xx_reset_adapter(scsi_qla_host_t *vha)
 {
 	unsigned long flags = 0;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
-	ha->flags.online = 0;
+	vha->flags.online = 0;
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -3478,9 +3481,11 @@ qla24xx_reset_adapter(scsi_qla_host_t *ha)
 /* On sparc systems, obtain port and node WWN from firmware
  * properties.
  */
-static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, struct nvram_24xx *nv)
+static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *vha,
+	struct nvram_24xx *nv)
 {
 #ifdef CONFIG_SPARC
+	struct qla_hw_data *ha = vha->hw;
 	struct pci_dev *pdev = ha->pdev;
 	struct device_node *dp = pci_device_to_OF_node(pdev);
 	const u8 *val;
@@ -3497,7 +3502,7 @@ static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, struct nvram_24xx *n
 }
 
 int
-qla24xx_nvram_config(scsi_qla_host_t *ha)
+qla24xx_nvram_config(scsi_qla_host_t *vha)
 {
 	int   rval;
 	struct init_cb_24xx *icb;
@@ -3506,6 +3511,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	uint8_t  *dptr1, *dptr2;
 	uint32_t chksum;
 	uint16_t cnt;
+	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_SUCCESS;
 	icb = (struct init_cb_24xx *)ha->init_cb;
@@ -3523,12 +3529,12 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 
 	/* Get VPD data into cache */
 	ha->vpd = ha->nvram + VPD_OFFSET;
-	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->vpd,
+	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd,
 	    ha->nvram_base - FA_NVRAM_FUNC0_ADDR, FA_NVRAM_VPD_SIZE * 4);
 
 	/* Get NVRAM data into cache and calculate checksum. */
 	dptr = (uint32_t *)nv;
-	ha->isp_ops->read_nvram(ha, (uint8_t *)dptr, ha->nvram_base,
+	ha->isp_ops->read_nvram(vha, (uint8_t *)dptr, ha->nvram_base,
 	    ha->nvram_size);
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
@@ -3573,7 +3579,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		nv->node_name[5] = 0x1c;
 		nv->node_name[6] = 0x55;
 		nv->node_name[7] = 0x86;
-		qla24xx_nvram_wwn_from_ofw(ha, nv);
+		qla24xx_nvram_wwn_from_ofw(vha, nv);
 		nv->login_retry_count = __constant_cpu_to_le16(8);
 		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
 		nv->login_timeout = __constant_cpu_to_le16(0);
@@ -3593,7 +3599,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	}
 
 	/* Reset Initialization control block */
-	memset(icb, 0, sizeof(struct init_cb_24xx));
+	memset(icb, 0, ha->init_cb_size);
 
 	/* Copy 1st segment. */
 	dptr1 = (uint8_t *)icb;
@@ -3616,7 +3622,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	/*
 	 * Setup driver NVRAM options.
 	 */
-	qla2x00_set_model_info(ha, nv->model_name, sizeof(nv->model_name),
+	qla2x00_set_model_info(vha, nv->model_name, sizeof(nv->model_name),
 	    "QLA2462");
 
 	/* Use alternate WWN? */
@@ -3655,8 +3661,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	ha->serial0 = icb->port_name[5];
 	ha->serial1 = icb->port_name[6];
 	ha->serial2 = icb->port_name[7];
-	ha->node_name = icb->node_name;
-	ha->port_name = icb->port_name;
+	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
+	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
 	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 
@@ -3711,7 +3717,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		ha->login_retry_count = ql2xloginretrycount;
 
 	/* Enable ZIO. */
-	if (!ha->flags.init_done) {
+	if (!vha->flags.init_done) {
 		ha->zio_mode = le32_to_cpu(icb->firmware_options_2) &
 		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
 		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
@@ -3719,12 +3725,12 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	}
 	icb->firmware_options_2 &= __constant_cpu_to_le32(
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
-	ha->flags.process_response_queue = 0;
+	vha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
 		ha->zio_mode = QLA_ZIO_MODE_6;
 
 		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
-		    "(%d us).\n", ha->host_no, ha->zio_mode,
+		    "(%d us).\n", vha->host_no, ha->zio_mode,
 		    ha->zio_timer * 100));
 		qla_printk(KERN_INFO, ha,
 		    "ZIO mode %d enabled; timer delay (%d us).\n",
@@ -3733,18 +3739,18 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		icb->firmware_options_2 |= cpu_to_le32(
 		    (uint32_t)ha->zio_mode);
 		icb->interrupt_delay_timer = cpu_to_le16(ha->zio_timer);
-		ha->flags.process_response_queue = 1;
+		vha->flags.process_response_queue = 1;
 	}
 
 	if (rval) {
 		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
+		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
 	}
 	return (rval);
 }
 
 static int
-qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	segments, fragment;
@@ -3753,16 +3759,16 @@ qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 	uint32_t risc_addr;
 	uint32_t risc_size;
 	uint32_t i;
-
+	struct qla_hw_data *ha = vha->hw;
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
 	faddr = ha->flt_region_fw;
-	dcode = (uint32_t *)ha->request_ring;
+	dcode = (uint32_t *)ha->req->ring;
 	*srisc_addr = 0;
 
 	/* Validate firmware image by checking version. */
-	qla24xx_read_flash_data(ha, dcode, faddr + 4, 4);
+	qla24xx_read_flash_data(vha, dcode, faddr + 4, 4);
 	for (i = 0; i < 4; i++)
 		dcode[i] = be32_to_cpu(dcode[i]);
 	if ((dcode[0] == 0xffffffff && dcode[1] == 0xffffffff &&
@@ -3780,7 +3786,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 
 	while (segments && rval == QLA_SUCCESS) {
 		/* Read segment's load information. */
-		qla24xx_read_flash_data(ha, dcode, faddr, 4);
+		qla24xx_read_flash_data(vha, dcode, faddr, 4);
 
 		risc_addr = be32_to_cpu(dcode[2]);
 		*srisc_addr = *srisc_addr == 0 ? risc_addr : *srisc_addr;
@@ -3794,17 +3800,17 @@ qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 
 			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
 			    "addr %x, number of dwords 0x%x, offset 0x%x.\n",
-			    ha->host_no, risc_addr, dlen, faddr));
+			    vha->host_no, risc_addr, dlen, faddr));
 
-			qla24xx_read_flash_data(ha, dcode, faddr, dlen);
+			qla24xx_read_flash_data(vha, dcode, faddr, dlen);
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
-			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
 			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", ha->host_no,
+				    "segment %d of firmware\n", vha->host_no,
 				    fragment));
 				qla_printk(KERN_WARNING, ha,
 				    "[ERROR] Failed to load segment %d of "
@@ -3828,16 +3834,17 @@ qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 #define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"
 
 int
-qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	i, fragment;
 	uint16_t *wcode, *fwcode;
 	uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
 	struct fw_blob *blob;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Load firmware blob. */
-	blob = qla2x00_request_firmware(ha);
+	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
 		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
 		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
@@ -3847,7 +3854,7 @@ qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 
 	rval = QLA_SUCCESS;
 
-	wcode = (uint16_t *)ha->request_ring;
+	wcode = (uint16_t *)ha->req->ring;
 	*srisc_addr = 0;
 	fwcode = (uint16_t *)blob->fw->data;
 	fwclen = 0;
@@ -3894,17 +3901,17 @@ qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 				wlen = risc_size;
 
 			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
-			    "addr %x, number of words 0x%x.\n", ha->host_no,
+			    "addr %x, number of words 0x%x.\n", vha->host_no,
 			    risc_addr, wlen));
 
 			for (i = 0; i < wlen; i++)
 				wcode[i] = swab16(fwcode[i]);
 
-			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
 			    wlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", ha->host_no,
+				    "segment %d of firmware\n", vha->host_no,
 				    fragment));
 				qla_printk(KERN_WARNING, ha,
 				    "[ERROR] Failed to load segment %d of "
@@ -3928,7 +3935,7 @@ fail_fw_integrity:
 }
 
 int
-qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	segments, fragment;
@@ -3938,9 +3945,10 @@ qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 	uint32_t i;
 	struct fw_blob *blob;
 	uint32_t *fwcode, fwclen;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Load firmware blob. */
-	blob = qla2x00_request_firmware(ha);
+	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
 		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
 		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
@@ -3949,13 +3957,13 @@ qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 		/* Try to load RISC code from flash. */
 		qla_printk(KERN_ERR, ha, "Attempting to load (potentially "
 		    "outdated) firmware from flash.\n");
-		return qla24xx_load_risc_flash(ha, srisc_addr);
+		return qla24xx_load_risc_flash(vha, srisc_addr);
 	}
 
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
-	dcode = (uint32_t *)ha->request_ring;
+	dcode = (uint32_t *)ha->req->ring;
 	*srisc_addr = 0;
 	fwcode = (uint32_t *)blob->fw->data;
 	fwclen = 0;
@@ -4003,17 +4011,17 @@ qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 				dlen = risc_size;
 
 			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
-			    "addr %x, number of dwords 0x%x.\n", ha->host_no,
+			    "addr %x, number of dwords 0x%x.\n", vha->host_no,
 			    risc_addr, dlen));
 
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(fwcode[i]);
 
-			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			rval = qla2x00_load_ram(vha, ha->req->dma, risc_addr,
 			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", ha->host_no,
+				    "segment %d of firmware\n", vha->host_no,
 				    fragment));
 				qla_printk(KERN_WARNING, ha,
 				    "[ERROR] Failed to load segment %d of "
@@ -4037,49 +4045,51 @@ fail_fw_integrity:
 }
 
 void
-qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
+qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 {
 	int ret, retries;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_FWI2_CAPABLE(ha))
 		return;
 	if (!ha->fw_major_version)
 		return;
 
-	ret = qla2x00_stop_firmware(ha);
+	ret = qla2x00_stop_firmware(vha);
 	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
 	    retries ; retries--) {
-		ha->isp_ops->reset_chip(ha);
-		if (ha->isp_ops->chip_diag(ha) != QLA_SUCCESS)
+		ha->isp_ops->reset_chip(vha);
+		if (ha->isp_ops->chip_diag(vha) != QLA_SUCCESS)
 			continue;
-		if (qla2x00_setup_chip(ha) != QLA_SUCCESS)
+		if (qla2x00_setup_chip(vha) != QLA_SUCCESS)
 			continue;
 		qla_printk(KERN_INFO, ha,
 		    "Attempting retry of stop-firmware command...\n");
-		ret = qla2x00_stop_firmware(ha);
+		ret = qla2x00_stop_firmware(vha);
 	}
 }
 
 int
-qla24xx_configure_vhba(scsi_qla_host_t *ha)
+qla24xx_configure_vhba(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	if (!ha->parent)
+	if (!vha->vp_idx)
 		return -EINVAL;
 
-	rval = qla2x00_fw_ready(ha->parent);
+	rval = qla2x00_fw_ready(base_vha);
 	if (rval == QLA_SUCCESS) {
-		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+		qla2x00_marker(vha, 0, 0, MK_SYNC_ALL);
 	}
 
-	ha->flags.management_server_logged_in = 0;
+	vha->flags.management_server_logged_in = 0;
 
 	/* Login to SNS first */
-	qla24xx_login_fabric(ha->parent, NPH_SNS, 0xff, 0xff, 0xfc,
-	    mb, BIT_1);
+	ha->isp_ops->fabric_login(vha, NPH_SNS, 0xff, 0xff, 0xfc, mb, BIT_1);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
 		DEBUG15(qla_printk(KERN_INFO, ha,
 		    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
@@ -4088,11 +4098,11 @@ qla24xx_configure_vhba(scsi_qla_host_t *ha)
 		return (QLA_FUNCTION_FAILED);
 	}
 
-	atomic_set(&ha->loop_down_timer, 0);
-	atomic_set(&ha->loop_state, LOOP_UP);
-	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	rval = qla2x00_loop_resync(ha->parent);
+	atomic_set(&vha->loop_down_timer, 0);
+	atomic_set(&vha->loop_state, LOOP_UP);
+	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+	rval = qla2x00_loop_resync(base_vha);
 
 	return rval;
 }
@@ -4103,9 +4113,10 @@ static LIST_HEAD(qla_cs84xx_list);
 static DEFINE_MUTEX(qla_cs84xx_mutex);
 
 static struct qla_chip_state_84xx *
-qla84xx_get_chip(struct scsi_qla_host *ha)
+qla84xx_get_chip(struct scsi_qla_host *vha)
 {
 	struct qla_chip_state_84xx *cs84xx;
+	struct qla_hw_data *ha = vha->hw;
 
 	mutex_lock(&qla_cs84xx_mutex);
 
@@ -4145,21 +4156,23 @@ __qla84xx_chip_release(struct kref *kref)
 }
 
 void
-qla84xx_put_chip(struct scsi_qla_host *ha)
+qla84xx_put_chip(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	if (ha->cs84xx)
 		kref_put(&ha->cs84xx->kref, __qla84xx_chip_release);
 }
 
 static int
-qla84xx_init_chip(scsi_qla_host_t *ha)
+qla84xx_init_chip(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint16_t status[2];
+	struct qla_hw_data *ha = vha->hw;
 
 	mutex_lock(&ha->cs84xx->fw_update_mutex);
 
-	rval = qla84xx_verify_chip(ha, status);
+	rval = qla84xx_verify_chip(vha, status);
 
 	mutex_unlock(&ha->cs84xx->fw_update_mutex);
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e90afad..8ce3547 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -32,21 +32,15 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 }
 
 static inline void
-qla2x00_poll(scsi_qla_host_t *ha)
+qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
-
+	struct qla_hw_data *ha = rsp->hw;
 	local_irq_save(flags);
-	ha->isp_ops->intr_handler(0, ha);
+	ha->isp_ops->intr_handler(0, rsp);
 	local_irq_restore(flags);
 }
 
-static __inline__ scsi_qla_host_t *
-to_qla_parent(scsi_qla_host_t *ha)
-{
-	return ha->parent ? ha->parent : ha;
-}
-
 /**
  * qla2x00_issue_marker() - Issue a Marker IOCB if necessary.
  * @ha: HA context
@@ -55,20 +49,20 @@ to_qla_parent(scsi_qla_host_t *ha)
  * Returns non-zero if a failure occurred, else zero.
  */
 static inline int
-qla2x00_issue_marker(scsi_qla_host_t *ha, int ha_locked)
+qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 {
 	/* Send marker if required */
-	if (ha->marker_needed != 0) {
+	if (vha->marker_needed != 0) {
 		if (ha_locked) {
-			if (__qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) !=
+			if (__qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
 			    QLA_SUCCESS)
 				return (QLA_FUNCTION_FAILED);
 		} else {
-			if (qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) !=
+			if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
 			    QLA_SUCCESS)
 				return (QLA_FUNCTION_FAILED);
 		}
-		ha->marker_needed = 0;
+		vha->marker_needed = 0;
 	}
 	return (QLA_SUCCESS);
 }
@@ -87,11 +81,12 @@ host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
 }
 
 static inline int
-qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
+qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 {
+	struct qla_hw_data *ha = vha->hw;
 	if (IS_FWI2_CAPABLE(ha))
 		return (loop_id > NPH_LAST_HANDLE);
 
-	return ((loop_id > ha->last_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
+	return ((loop_id > ha->max_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
 	    loop_id == MANAGEMENT_SERVER || loop_id == BROADCAST);
 };
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 85bc0a4..0c145c9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,8 +11,8 @@
 
 #include <scsi/scsi_tcq.h>
 
-static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
-static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
+static request_t *qla2x00_req_pkt(scsi_qla_host_t *);
+static void qla2x00_isp_cmd(scsi_qla_host_t *);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -30,11 +30,11 @@ qla2x00_get_cmd_direction(srb_t *sp)
 	/* Set transfer direction */
 	if (sp->cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cflags = CF_WRITE;
-		sp->fcport->ha->qla_stats.output_bytes +=
+		sp->fcport->vha->hw->qla_stats.output_bytes +=
 		    scsi_bufflen(sp->cmd);
 	} else if (sp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cflags = CF_READ;
-		sp->fcport->ha->qla_stats.input_bytes +=
+		sp->fcport->vha->hw->qla_stats.input_bytes +=
 		    scsi_bufflen(sp->cmd);
 	}
 	return (cflags);
@@ -91,20 +91,20 @@ qla2x00_calc_iocbs_64(uint16_t dsds)
  * Returns a pointer to the Continuation Type 0 IOCB packet.
  */
 static inline cont_entry_t *
-qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *ha)
+qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *vha)
 {
 	cont_entry_t *cont_pkt;
-
+	struct req_que *req = vha->hw->req;
 	/* Adjust ring index. */
-	ha->req_ring_index++;
-	if (ha->req_ring_index == ha->request_q_length) {
-		ha->req_ring_index = 0;
-		ha->request_ring_ptr = ha->request_ring;
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
 	} else {
-		ha->request_ring_ptr++;
+		req->ring_ptr++;
 	}
 
-	cont_pkt = (cont_entry_t *)ha->request_ring_ptr;
+	cont_pkt = (cont_entry_t *)req->ring_ptr;
 
 	/* Load packet defaults. */
 	*((uint32_t *)(&cont_pkt->entry_type)) =
@@ -120,20 +120,21 @@ qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *ha)
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
 static inline cont_a64_entry_t *
-qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *ha)
+qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
 {
 	cont_a64_entry_t *cont_pkt;
+	struct req_que *req = vha->hw->req;
 
 	/* Adjust ring index. */
-	ha->req_ring_index++;
-	if (ha->req_ring_index == ha->request_q_length) {
-		ha->req_ring_index = 0;
-		ha->request_ring_ptr = ha->request_ring;
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
 	} else {
-		ha->request_ring_ptr++;
+		req->ring_ptr++;
 	}
 
-	cont_pkt = (cont_a64_entry_t *)ha->request_ring_ptr;
+	cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
 
 	/* Load packet defaults. */
 	*((uint32_t *)(&cont_pkt->entry_type)) =
@@ -155,7 +156,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 {
 	uint16_t	avail_dsds;
 	uint32_t	*cur_dsd;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
@@ -172,7 +173,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	ha = sp->ha;
+	vha = sp->vha;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -190,7 +191,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Seven DSDs are available in the Continuation
 			 * Type 0 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type0_iocb(ha);
+			cont_pkt = qla2x00_prep_cont_type0_iocb(vha);
 			cur_dsd = (uint32_t *)&cont_pkt->dseg_0_address;
 			avail_dsds = 7;
 		}
@@ -214,7 +215,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 {
 	uint16_t	avail_dsds;
 	uint32_t	*cur_dsd;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
@@ -231,7 +232,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	ha = sp->ha;
+	vha = sp->vha;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -250,7 +251,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -274,7 +275,7 @@ qla2x00_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -284,33 +285,36 @@ qla2x00_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_2xxx __iomem *reg;
+	struct qla_hw_data *ha;
+	struct req_que *req;
 
 	/* Setup device pointers. */
 	ret = 0;
-	ha = sp->ha;
+	vha = sp->vha;
+	ha = vha->hw;
 	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
+	req = ha->req;
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
 	/* Send marker if required */
-	if (ha->marker_needed != 0) {
-		if (qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
 			return (QLA_FUNCTION_FAILED);
-		}
-		ha->marker_needed = 0;
+		vha->marker_needed = 0;
 	}
 
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Check for room in outstanding command list. */
-	handle = ha->current_outstanding_cmd;
+	handle = req->current_outstanding_cmd;
 	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
 		handle++;
 		if (handle == MAX_OUTSTANDING_COMMANDS)
 			handle = 1;
-		if (!ha->outstanding_cmds[handle])
+		if (!req->outstanding_cmds[handle])
 			break;
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS)
@@ -329,25 +333,25 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Calculate the number of request entries needed. */
 	req_cnt = ha->isp_ops->calc_req_entries(tot_dsds);
-	if (ha->req_q_cnt < (req_cnt + 2)) {
+	if (req->cnt < (req_cnt + 2)) {
 		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
-		if (ha->req_ring_index < cnt)
-			ha->req_q_cnt = cnt - ha->req_ring_index;
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
 		else
-			ha->req_q_cnt = ha->request_q_length -
-			    (ha->req_ring_index - cnt);
+			req->cnt = req->length -
+			    (req->ring_index - cnt);
 	}
-	if (ha->req_q_cnt < (req_cnt + 2))
+	if (req->cnt < (req_cnt + 2))
 		goto queuing_error;
 
 	/* Build command packet */
-	ha->current_outstanding_cmd = handle;
-	ha->outstanding_cmds[handle] = sp;
-	sp->ha = ha;
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->vha = vha;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
-	ha->req_q_cnt -= req_cnt;
+	req->cnt -= req_cnt;
 
-	cmd_pkt = (cmd_entry_t *)ha->request_ring_ptr;
+	cmd_pkt = (cmd_entry_t *)req->ring_ptr;
 	cmd_pkt->handle = handle;
 	/* Zero out remaining portion of packet. */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
@@ -373,23 +377,23 @@ qla2x00_start_scsi(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	ha->req_ring_index++;
-	if (ha->req_ring_index == ha->request_q_length) {
-		ha->req_ring_index = 0;
-		ha->request_ring_ptr = ha->request_ring;
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
 	} else
-		ha->request_ring_ptr++;
+		req->ring_ptr++;
 
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
+	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), req->ring_index);
 	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (ha->flags.process_response_queue &&
-	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
-		qla2x00_process_response_queue(ha);
+	if (vha->flags.process_response_queue &&
+	    ha->rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla2x00_process_response_queue(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -415,18 +419,19 @@ queuing_error:
  * Returns non-zero if a failure occurred, else zero.
  */
 int
-__qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
+__qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
     uint8_t type)
 {
 	mrk_entry_t *mrk;
 	struct mrk_entry_24xx *mrk24;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	mrk24 = NULL;
-	mrk = (mrk_entry_t *)qla2x00_req_pkt(pha);
+	mrk = (mrk_entry_t *)qla2x00_req_pkt(base_vha);
 	if (mrk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Marker IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, base_vha->host_no));
 
 		return (QLA_FUNCTION_FAILED);
 	}
@@ -440,7 +445,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
 			mrk24->lun[1] = LSB(lun);
 			mrk24->lun[2] = MSB(lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
-			mrk24->vp_index = ha->vp_idx;
+			mrk24->vp_index = vha->vp_idx;
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16(lun);
@@ -448,22 +453,22 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
 	}
 	wmb();
 
-	qla2x00_isp_cmd(pha);
+	qla2x00_isp_cmd(base_vha);
 
 	return (QLA_SUCCESS);
 }
 
 int
-qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
+qla2x00_marker(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t lun,
     uint8_t type)
 {
 	int ret;
 	unsigned long flags = 0;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
-	ret = __qla2x00_marker(ha, loop_id, lun, type);
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ret = __qla2x00_marker(vha, loop_id, lun, type);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (ret);
 }
@@ -477,18 +482,20 @@ qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
  * Returns NULL if function failed, else, a pointer to the request packet.
  */
 static request_t *
-qla2x00_req_pkt(scsi_qla_host_t *ha)
+qla2x00_req_pkt(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	device_reg_t __iomem *reg = ha->iobase;
 	request_t	*pkt = NULL;
 	uint16_t	cnt;
 	uint32_t	*dword_ptr;
 	uint32_t	timer;
 	uint16_t	req_cnt = 1;
+	struct req_que *req = ha->req;
 
 	/* Wait 1 second for slot. */
 	for (timer = HZ; timer; timer--) {
-		if ((req_cnt + 2) >= ha->req_q_cnt) {
+		if ((req_cnt + 2) >= req->cnt) {
 			/* Calculate number of free request entries. */
 			if (IS_FWI2_CAPABLE(ha))
 				cnt = (uint16_t)RD_REG_DWORD(
@@ -496,16 +503,16 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 			else
 				cnt = qla2x00_debounce_register(
 				    ISP_REQ_Q_OUT(ha, &reg->isp));
-			if  (ha->req_ring_index < cnt)
-				ha->req_q_cnt = cnt - ha->req_ring_index;
+			if  (req->ring_index < cnt)
+				req->cnt = cnt - req->ring_index;
 			else
-				ha->req_q_cnt = ha->request_q_length -
-				    (ha->req_ring_index - cnt);
+				req->cnt = req->length -
+				    (req->ring_index - cnt);
 		}
 		/* If room for request in request ring. */
-		if ((req_cnt + 2) < ha->req_q_cnt) {
-			ha->req_q_cnt--;
-			pkt = ha->request_ring_ptr;
+		if ((req_cnt + 2) < req->cnt) {
+			req->cnt--;
+			pkt = req->ring_ptr;
 
 			/* Zero out packet. */
 			dword_ptr = (uint32_t *)pkt;
@@ -513,7 +520,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 				*dword_ptr++ = 0;
 
 			/* Set system defined field. */
-			pkt->sys_define = (uint8_t)ha->req_ring_index;
+			pkt->sys_define = (uint8_t)req->ring_index;
 
 			/* Set entry count. */
 			pkt->entry_count = 1;
@@ -522,15 +529,14 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 		}
 
 		/* Release ring specific lock */
-		spin_unlock(&ha->hardware_lock);
+		spin_unlock_irq(&ha->hardware_lock);
 
 		udelay(2);   /* 2 us */
 
 		/* Check for pending interrupts. */
 		/* During init we issue marker directly */
-		if (!ha->marker_needed && !ha->flags.init_done)
-			qla2x00_poll(ha);
-
+		if (!vha->marker_needed && !vha->flags.init_done)
+			qla2x00_poll(ha->rsp);
 		spin_lock_irq(&ha->hardware_lock);
 	}
 	if (!pkt) {
@@ -547,28 +553,30 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
  * Note: The caller must hold the hardware lock before calling this routine.
  */
 static void
-qla2x00_isp_cmd(scsi_qla_host_t *ha)
+qla2x00_isp_cmd(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	device_reg_t __iomem *reg = ha->iobase;
+	struct req_que *req = ha->req;
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
-	    (uint8_t *)ha->request_ring_ptr, REQUEST_ENTRY_SIZE));
+	    (uint8_t *)req->ring_ptr, REQUEST_ENTRY_SIZE));
 
 	/* Adjust ring index. */
-	ha->req_ring_index++;
-	if (ha->req_ring_index == ha->request_q_length) {
-		ha->req_ring_index = 0;
-		ha->request_ring_ptr = ha->request_ring;
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
 	} else
-		ha->request_ring_ptr++;
+		req->ring_ptr++;
 
 	/* Set chip new ring index. */
 	if (IS_FWI2_CAPABLE(ha)) {
-		WRT_REG_DWORD(&reg->isp24.req_q_in, ha->req_ring_index);
+		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
 		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
 	} else {
-		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), ha->req_ring_index);
+		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), req->ring_index);
 		RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
 	}
 
@@ -610,7 +618,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 {
 	uint16_t	avail_dsds;
 	uint32_t	*cur_dsd;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
@@ -627,18 +635,18 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 		return;
 	}
 
-	ha = sp->ha;
+	vha = sp->vha;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
 		    __constant_cpu_to_le16(TMF_WRITE_DATA);
-		sp->fcport->ha->qla_stats.output_bytes +=
+		sp->fcport->vha->hw->qla_stats.output_bytes +=
 		    scsi_bufflen(sp->cmd);
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
 		    __constant_cpu_to_le16(TMF_READ_DATA);
-		sp->fcport->ha->qla_stats.input_bytes +=
+		sp->fcport->vha->hw->qla_stats.input_bytes +=
 		    scsi_bufflen(sp->cmd);
 	}
 
@@ -658,7 +666,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -683,7 +691,7 @@ qla24xx_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*ha, *pha;
+	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -693,34 +701,36 @@ qla24xx_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_24xx __iomem *reg;
+	struct qla_hw_data *ha;
+	struct req_que *req;
 
 	/* Setup device pointers. */
 	ret = 0;
-	ha = sp->ha;
-	pha = to_qla_parent(ha);
+	vha = sp->vha;
+	ha = vha->hw;
 	reg = &ha->iobase->isp24;
 	cmd = sp->cmd;
+	req = ha->req;
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
 	/* Send marker if required */
-	if (ha->marker_needed != 0) {
-		if (qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
-		}
-		ha->marker_needed = 0;
+		vha->marker_needed = 0;
 	}
 
 	/* Acquire ring specific lock */
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Check for room in outstanding command list. */
-	handle = ha->current_outstanding_cmd;
+	handle = req->current_outstanding_cmd;
 	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
 		handle++;
 		if (handle == MAX_OUTSTANDING_COMMANDS)
 			handle = 1;
-		if (!ha->outstanding_cmds[handle])
+		if (!req->outstanding_cmds[handle])
 			break;
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS)
@@ -738,25 +748,25 @@ qla24xx_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 
 	req_cnt = qla24xx_calc_iocbs(tot_dsds);
-	if (ha->req_q_cnt < (req_cnt + 2)) {
+	if (req->cnt < (req_cnt + 2)) {
 		cnt = (uint16_t)RD_REG_DWORD_RELAXED(&reg->req_q_out);
-		if (ha->req_ring_index < cnt)
-			ha->req_q_cnt = cnt - ha->req_ring_index;
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
 		else
-			ha->req_q_cnt = ha->request_q_length -
-				(ha->req_ring_index - cnt);
+			req->cnt = req->length -
+				(req->ring_index - cnt);
 	}
-	if (ha->req_q_cnt < (req_cnt + 2))
+	if (req->cnt < (req_cnt + 2))
 		goto queuing_error;
 
 	/* Build command packet. */
-	ha->current_outstanding_cmd = handle;
-	ha->outstanding_cmds[handle] = sp;
-	sp->ha = ha;
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->vha = vha;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
-	ha->req_q_cnt -= req_cnt;
+	req->cnt -= req_cnt;
 
-	cmd_pkt = (struct cmd_type_7 *)ha->request_ring_ptr;
+	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
 	cmd_pkt->handle = handle;
 
 	/* Zero out remaining portion of packet. */
@@ -789,32 +799,32 @@ qla24xx_start_scsi(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	ha->req_ring_index++;
-	if (ha->req_ring_index == ha->request_q_length) {
-		ha->req_ring_index = 0;
-		ha->request_ring_ptr = ha->request_ring;
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
 	} else
-		ha->request_ring_ptr++;
+		req->ring_ptr++;
 
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	WRT_REG_DWORD(&reg->req_q_in, ha->req_ring_index);
+	WRT_REG_DWORD(&reg->req_q_in, req->ring_index);
 	RD_REG_DWORD_RELAXED(&reg->req_q_in);		/* PCI Posting. */
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (ha->flags.process_response_queue &&
-	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(ha);
+	if (vha->flags.process_response_queue &&
+	    ha->rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha);
 
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
 
 queuing_error:
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fc4bfa7..831a872 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -14,6 +14,7 @@ static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
+static struct scsi_qla_host *qla2x00_get_rsp_host(struct rsp_que *);
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
@@ -27,24 +28,28 @@ static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
 irqreturn_t
 qla2100_intr_handler(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
 	struct device_reg_2xxx __iomem *reg;
 	int		status;
 	unsigned long	iter;
 	uint16_t	hccr;
 	uint16_t	mb[4];
+	struct rsp_que *rsp;
 
-	ha = (scsi_qla_host_t *) dev_id;
-	if (!ha) {
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL host pointer\n", __func__);
+		    "%s(): NULL response queue pointer\n", __func__);
 		return (IRQ_NONE);
 	}
 
+	ha = rsp->hw;
 	reg = &ha->iobase->isp;
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
+	vha = qla2x00_get_rsp_host(rsp);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -59,8 +64,8 @@ qla2100_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
 
-			ha->isp_ops->fw_dump(ha, 1);
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			ha->isp_ops->fw_dump(vha, 1);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
 			break;
@@ -72,24 +77,24 @@ qla2100_intr_handler(int irq, void *dev_id)
 			/* Get mailbox data. */
 			mb[0] = RD_MAILBOX_REG(ha, reg, 0);
 			if (mb[0] > 0x3fff && mb[0] < 0x8000) {
-				qla2x00_mbx_completion(ha, mb[0]);
+				qla2x00_mbx_completion(vha, mb[0]);
 				status |= MBX_INTERRUPT;
 			} else if (mb[0] > 0x7fff && mb[0] < 0xc000) {
 				mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 				mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 				mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-				qla2x00_async_event(ha, mb);
+				qla2x00_async_event(vha, mb);
 			} else {
 				/*EMPTY*/
 				DEBUG2(printk("scsi(%ld): Unrecognized "
 				    "interrupt type (%d).\n",
-				    ha->host_no, mb[0]));
+				    vha->host_no, mb[0]));
 			}
 			/* Release mailbox registers. */
 			WRT_REG_WORD(&reg->semaphore, 0);
 			RD_REG_WORD(&reg->semaphore);
 		} else {
-			qla2x00_process_response_queue(ha);
+			qla2x00_process_response_queue(vha);
 
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 			RD_REG_WORD(&reg->hccr);
@@ -118,25 +123,29 @@ qla2100_intr_handler(int irq, void *dev_id)
 irqreturn_t
 qla2300_intr_handler(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
 	struct device_reg_2xxx __iomem *reg;
 	int		status;
 	unsigned long	iter;
 	uint32_t	stat;
 	uint16_t	hccr;
 	uint16_t	mb[4];
+	struct rsp_que *rsp;
+	struct qla_hw_data *ha;
 
-	ha = (scsi_qla_host_t *) dev_id;
-	if (!ha) {
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL host pointer\n", __func__);
+		    "%s(): NULL response queue pointer\n", __func__);
 		return (IRQ_NONE);
 	}
 
+	ha = rsp->hw;
 	reg = &ha->iobase->isp;
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
+	vha = qla2x00_get_rsp_host(rsp);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
@@ -159,8 +168,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
 
-			ha->isp_ops->fw_dump(ha, 1);
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			ha->isp_ops->fw_dump(vha, 1);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSR_RISC_INT) == 0)
 			break;
@@ -170,7 +179,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 		case 0x2:
 		case 0x10:
 		case 0x11:
-			qla2x00_mbx_completion(ha, MSW(stat));
+			qla2x00_mbx_completion(vha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			/* Release mailbox registers. */
@@ -181,26 +190,26 @@ qla2300_intr_handler(int irq, void *dev_id)
 			mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 			mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-			qla2x00_async_event(ha, mb);
+			qla2x00_async_event(vha, mb);
 			break;
 		case 0x13:
-			qla2x00_process_response_queue(ha);
+			qla2x00_process_response_queue(vha);
 			break;
 		case 0x15:
 			mb[0] = MBA_CMPLT_1_16BIT;
 			mb[1] = MSW(stat);
-			qla2x00_async_event(ha, mb);
+			qla2x00_async_event(vha, mb);
 			break;
 		case 0x16:
 			mb[0] = MBA_SCSI_COMPLETION;
 			mb[1] = MSW(stat);
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-			qla2x00_async_event(ha, mb);
+			qla2x00_async_event(vha, mb);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
-			    ha->host_no, stat & 0xff));
+			    vha->host_no, stat & 0xff));
 			break;
 		}
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
@@ -223,10 +232,11 @@ qla2300_intr_handler(int irq, void *dev_id)
  * @mb0: Mailbox0 register
  */
 static void
-qla2x00_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
+qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
 	uint16_t __iomem *wptr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Load return mailbox registers. */
@@ -247,10 +257,10 @@ qla2x00_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
 
 	if (ha->mcp) {
 		DEBUG3(printk("%s(%ld): Got mailbox completion. cmd=%x.\n",
-		    __func__, ha->host_no, ha->mcp->mb[0]));
+		    __func__, vha->host_no, ha->mcp->mb[0]));
 	} else {
 		DEBUG2_3(printk("%s(%ld): MBX pointer ERROR!\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 	}
 }
 
@@ -260,7 +270,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
  * @mb: Mailbox registers (0 - 3)
  */
 void
-qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
+qla2x00_async_event(scsi_qla_host_t *vha, uint16_t *mb)
 {
 #define LS_UNKNOWN	2
 	static char	*link_speeds[5] = { "1", "2", "?", "4", "8" };
@@ -268,6 +278,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
 	uint32_t	handles[5];
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
@@ -329,17 +340,18 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:	/* Fast Post */
-		if (!ha->flags.online)
+		if (!vha->flags.online)
 			break;
 
 		for (cnt = 0; cnt < handle_cnt; cnt++)
-			qla2x00_process_completed_request(ha, handles[cnt]);
+			qla2x00_process_completed_request(vha, handles[cnt]);
 		break;
 
 	case MBA_RESET:			/* Reset */
-		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n", ha->host_no));
+		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n",
+			vha->host_no));
 
-		set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+		set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
@@ -347,70 +359,70 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
 
-		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
-		ha->isp_ops->fw_dump(ha, 1);
+		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
+		ha->isp_ops->fw_dump(vha, 1);
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
 				qla_printk(KERN_ERR, ha,
 				    "Unrecoverable Hardware Error: adapter "
 				    "marked OFFLINE!\n");
-				ha->flags.online = 0;
+				vha->flags.online = 0;
 			} else
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		} else if (mb[1] == 0) {
 			qla_printk(KERN_INFO, ha,
 			    "Unrecoverable Hardware Error: adapter marked "
 			    "OFFLINE!\n");
-			ha->flags.online = 0;
+			vha->flags.online = 0;
 		} else
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
 		DEBUG2(printk("scsi(%ld): ISP Request Transfer Error.\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Request Transfer Error.\n");
 
-		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
 		DEBUG2(printk("scsi(%ld): ISP Response Transfer Error.\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha, "ISP Response Transfer Error.\n");
 
-		qla2x00_post_hwe_work(ha, mb[0], mb[1], mb[2], mb[3]);
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		qla2x00_post_hwe_work(vha, mb[0], mb[1], mb[2], mb[3]);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
 		DEBUG2(printk("scsi(%ld): Asynchronous WAKEUP_THRES.\n",
-		    ha->host_no));
+		    vha->host_no));
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
-		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", ha->host_no,
+		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", vha->host_no,
 		    mb[1]));
 		qla_printk(KERN_INFO, ha, "LIP occurred (%x).\n", mb[1]);
 
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha, 1);
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+			qla2x00_mark_all_devices_lost(vha, 1);
 		}
 
-		if (ha->parent) {
-			atomic_set(&ha->vp_state, VP_FAILED);
-			fc_vport_set_state(ha->fc_vport, FC_VPORT_FAILED);
+		if (vha->vp_idx) {
+			atomic_set(&vha->vp_state, VP_FAILED);
+			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
 		}
 
-		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
-		set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+		set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
+		set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
-		ha->flags.management_server_logged_in = 0;
-		qla2x00_post_aen_work(ha, FCH_EVT_LIP, mb[1]);
+		vha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(vha, FCH_EVT_LIP, mb[1]);
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
@@ -425,59 +437,59 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		}
 
 		DEBUG2(printk("scsi(%ld): Asynchronous LOOP UP (%s Gbps).\n",
-		    ha->host_no, link_speed));
+		    vha->host_no, link_speed));
 		qla_printk(KERN_INFO, ha, "LOOP UP detected (%s Gbps).\n",
 		    link_speed);
 
-		ha->flags.management_server_logged_in = 0;
-		qla2x00_post_aen_work(ha, FCH_EVT_LINKUP, ha->link_data_rate);
+		vha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
 		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN "
-		    "(%x %x %x).\n", ha->host_no, mb[1], mb[2], mb[3]));
+		    "(%x %x %x).\n", vha->host_no, mb[1], mb[2], mb[3]));
 		qla_printk(KERN_INFO, ha, "LOOP DOWN detected (%x %x %x).\n",
 		    mb[1], mb[2], mb[3]);
 
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-			ha->device_flags |= DFLG_NO_CABLE;
-			qla2x00_mark_all_devices_lost(ha, 1);
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+			vha->device_flags |= DFLG_NO_CABLE;
+			qla2x00_mark_all_devices_lost(vha, 1);
 		}
 
-		if (ha->parent) {
-			atomic_set(&ha->vp_state, VP_FAILED);
-			fc_vport_set_state(ha->fc_vport, FC_VPORT_FAILED);
+		if (vha->vp_idx) {
+			atomic_set(&vha->vp_state, VP_FAILED);
+			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
 		}
 
-		ha->flags.management_server_logged_in = 0;
+		vha->flags.management_server_logged_in = 0;
 		ha->link_data_rate = PORT_SPEED_UNKNOWN;
-		qla2x00_post_aen_work(ha, FCH_EVT_LINKDOWN, 0);
+		qla2x00_post_aen_work(vha, FCH_EVT_LINKDOWN, 0);
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
 		DEBUG2(printk("scsi(%ld): Asynchronous LIP RESET (%x).\n",
-		    ha->host_no, mb[1]));
+		    vha->host_no, mb[1]));
 		qla_printk(KERN_INFO, ha,
 		    "LIP reset occurred (%x).\n", mb[1]);
 
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha, 1);
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+			qla2x00_mark_all_devices_lost(vha, 1);
 		}
 
-		if (ha->parent) {
-			atomic_set(&ha->vp_state, VP_FAILED);
-			fc_vport_set_state(ha->fc_vport, FC_VPORT_FAILED);
+		if (vha->vp_idx) {
+			atomic_set(&vha->vp_state, VP_FAILED);
+			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
 		}
 
-		set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+		set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
 		ha->operating_mode = LOOP;
-		ha->flags.management_server_logged_in = 0;
-		qla2x00_post_aen_work(ha, FCH_EVT_LIPRESET, mb[1]);
+		vha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(vha, FCH_EVT_LIPRESET, mb[1]);
 		break;
 
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
@@ -485,33 +497,33 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 			break;
 
 		DEBUG2(printk("scsi(%ld): Asynchronous P2P MODE received.\n",
-		    ha->host_no));
+		    vha->host_no));
 
 		/*
 		 * Until there's a transition from loop down to loop up, treat
 		 * this as loop down only.
 		 */
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			if (!atomic_read(&ha->loop_down_timer))
-				atomic_set(&ha->loop_down_timer,
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			if (!atomic_read(&vha->loop_down_timer))
+				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha, 1);
+			qla2x00_mark_all_devices_lost(vha, 1);
 		}
 
-		if (ha->parent) {
-			atomic_set(&ha->vp_state, VP_FAILED);
-			fc_vport_set_state(ha->fc_vport, FC_VPORT_FAILED);
+		if (vha->vp_idx) {
+			atomic_set(&vha->vp_state, VP_FAILED);
+			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
 		}
 
-		if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
-			set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		}
-		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
-		set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+		if (!(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)))
+			set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+
+		set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
+		set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
 		ha->flags.gpsc_supported = 1;
-		ha->flags.management_server_logged_in = 0;
+		vha->flags.management_server_logged_in = 0;
 		break;
 
 	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
@@ -520,25 +532,25 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		DEBUG2(printk("scsi(%ld): Asynchronous Change In Connection "
 		    "received.\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_INFO, ha,
 		    "Configuration change detected: value=%x.\n", mb[1]);
 
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);
-			if (!atomic_read(&ha->loop_down_timer))
-				atomic_set(&ha->loop_down_timer,
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+			atomic_set(&vha->loop_state, LOOP_DOWN);
+			if (!atomic_read(&vha->loop_down_timer))
+				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha, 1);
+			qla2x00_mark_all_devices_lost(vha, 1);
 		}
 
-		if (ha->parent) {
-			atomic_set(&ha->vp_state, VP_FAILED);
-			fc_vport_set_state(ha->fc_vport, FC_VPORT_FAILED);
+		if (vha->vp_idx) {
+			atomic_set(&vha->vp_state, VP_FAILED);
+			fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
 		}
 
-		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
@@ -547,107 +559,106 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		 * event etc. earlier indicating loop is down) then process
 		 * it.  Otherwise ignore it and Wait for RSCN to come in.
 		 */
-		atomic_set(&ha->loop_down_timer, 0);
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN &&
-		    atomic_read(&ha->loop_state) != LOOP_DEAD) {
+		atomic_set(&vha->loop_down_timer, 0);
+		if (atomic_read(&vha->loop_state) != LOOP_DOWN &&
+		    atomic_read(&vha->loop_state) != LOOP_DEAD) {
 			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
-			    "ignored %04x/%04x/%04x.\n", ha->host_no, mb[1],
+			    "ignored %04x/%04x/%04x.\n", vha->host_no, mb[1],
 			    mb[2], mb[3]));
 			break;
 		}
 
 		DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE.\n",
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG(printk(KERN_INFO
 		    "scsi(%ld): Port database changed %04x %04x %04x.\n",
-		    ha->host_no, mb[1], mb[2], mb[3]));
+		    vha->host_no, mb[1], mb[2], mb[3]));
 
 		/*
 		 * Mark all devices as missing so we will login again.
 		 */
-		atomic_set(&ha->loop_state, LOOP_UP);
+		atomic_set(&vha->loop_state, LOOP_UP);
 
-		qla2x00_mark_all_devices_lost(ha, 1);
+		qla2x00_mark_all_devices_lost(vha, 1);
 
-		ha->flags.rscn_queue_overflow = 1;
+		vha->flags.rscn_queue_overflow = 1;
 
-		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
 		/* Check if the Vport has issued a SCR */
-		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
+		if (vha->vp_idx && test_bit(VP_SCR_NEEDED, &vha->vp_flags))
 			break;
 		/* Only handle SCNs for our Vport index. */
-		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
+		if (vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
 			break;
-
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG(printk(KERN_INFO
 		    "scsi(%ld): RSCN database changed -- %04x %04x %04x.\n",
-		    ha->host_no, mb[1], mb[2], mb[3]));
+		    vha->host_no, mb[1], mb[2], mb[3]));
 
 		rscn_entry = ((mb[1] & 0xff) << 16) | mb[2];
-		host_pid = (ha->d_id.b.domain << 16) | (ha->d_id.b.area << 8) |
-		    ha->d_id.b.al_pa;
+		host_pid = (vha->d_id.b.domain << 16) | (vha->d_id.b.area << 8)
+				| vha->d_id.b.al_pa;
 		if (rscn_entry == host_pid) {
 			DEBUG(printk(KERN_INFO
 			    "scsi(%ld): Ignoring RSCN update to local host "
 			    "port ID (%06x)\n",
-			    ha->host_no, host_pid));
+			    vha->host_no, host_pid));
 			break;
 		}
 
 		/* Ignore reserved bits from RSCN-payload. */
 		rscn_entry = ((mb[1] & 0x3ff) << 16) | mb[2];
-		rscn_queue_index = ha->rscn_in_ptr + 1;
+		rscn_queue_index = vha->rscn_in_ptr + 1;
 		if (rscn_queue_index == MAX_RSCN_COUNT)
 			rscn_queue_index = 0;
-		if (rscn_queue_index != ha->rscn_out_ptr) {
-			ha->rscn_queue[ha->rscn_in_ptr] = rscn_entry;
-			ha->rscn_in_ptr = rscn_queue_index;
+		if (rscn_queue_index != vha->rscn_out_ptr) {
+			vha->rscn_queue[vha->rscn_in_ptr] = rscn_entry;
+			vha->rscn_in_ptr = rscn_queue_index;
 		} else {
-			ha->flags.rscn_queue_overflow = 1;
+			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&ha->loop_state, LOOP_UPDATE);
-		atomic_set(&ha->loop_down_timer, 0);
-		ha->flags.management_server_logged_in = 0;
+		atomic_set(&vha->loop_state, LOOP_UPDATE);
+		atomic_set(&vha->loop_down_timer, 0);
+		vha->flags.management_server_logged_in = 0;
 
-		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-		set_bit(RSCN_UPDATE, &ha->dpc_flags);
-		qla2x00_post_aen_work(ha, FCH_EVT_RSCN, rscn_entry);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		set_bit(RSCN_UPDATE, &vha->dpc_flags);
+		qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
 		break;
 
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
 		DEBUG2(printk("scsi(%ld): [R|Z]IO update completion.\n",
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG(printk(KERN_INFO
 		    "scsi(%ld): [R|Z]IO update completion.\n",
-		    ha->host_no));
+		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-			qla24xx_process_response_queue(ha);
+			qla24xx_process_response_queue(vha);
 		else
-			qla2x00_process_response_queue(ha);
+			qla2x00_process_response_queue(vha);
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
 		DEBUG2(printk("scsi(%ld): Discard RND Frame -- %04x %04x "
-		    "%04x.\n", ha->host_no, mb[1], mb[2], mb[3]));
+		    "%04x.\n", vha->host_no, mb[1], mb[2], mb[3]));
 		break;
 
 	case MBA_TRACE_NOTIFICATION:
 		DEBUG2(printk("scsi(%ld): Trace Notification -- %04x %04x.\n",
-		ha->host_no, mb[1], mb[2]));
+		vha->host_no, mb[1], mb[2]));
 		break;
 
 	case MBA_ISP84XX_ALERT:
 		DEBUG2(printk("scsi(%ld): ISP84XX Alert Notification -- "
-		    "%04x %04x %04x\n", ha->host_no, mb[1], mb[2], mb[3]));
+		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
 
 		spin_lock_irqsave(&ha->cs84xx->access_lock, flags);
 		switch (mb[1]) {
@@ -682,7 +693,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 	}
 
-	if (!ha->parent && ha->num_vhosts)
+	if (!vha->vp_idx && ha->num_vhosts)
 		qla2x00_alert_all_vps(ha, mb);
 }
 
@@ -690,8 +701,8 @@ static void
 qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 {
 	fc_port_t *fcport = data;
-
-	if (fcport->ha->max_q_depth <= sdev->queue_depth)
+	struct qla_hw_data *ha = fcport->vha->hw;
+	if (ha->req->max_q_depth <= sdev->queue_depth)
 		return;
 
 	if (sdev->ordered_tags)
@@ -703,9 +714,9 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 
 	fcport->last_ramp_up = jiffies;
 
-	DEBUG2(qla_printk(KERN_INFO, fcport->ha,
+	DEBUG2(qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-up to %d.\n",
-	    fcport->ha->host_no, sdev->channel, sdev->id, sdev->lun,
+	    fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
 	    sdev->queue_depth));
 }
 
@@ -717,20 +728,21 @@ qla2x00_adjust_sdev_qdepth_down(struct scsi_device *sdev, void *data)
 	if (!scsi_track_queue_full(sdev, sdev->queue_depth - 1))
 		return;
 
-	DEBUG2(qla_printk(KERN_INFO, fcport->ha,
+	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
 	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
-	    fcport->ha->host_no, sdev->channel, sdev->id, sdev->lun,
+	    fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
 	    sdev->queue_depth));
 }
 
 static inline void
-qla2x00_ramp_up_queue_depth(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, srb_t *sp)
 {
 	fc_port_t *fcport;
 	struct scsi_device *sdev;
+	struct qla_hw_data *ha = vha->hw;
 
 	sdev = sp->cmd->device;
-	if (sdev->queue_depth >= ha->max_q_depth)
+	if (sdev->queue_depth >= ha->req->max_q_depth)
 		return;
 
 	fcport = sp->fcport;
@@ -751,25 +763,27 @@ qla2x00_ramp_up_queue_depth(scsi_qla_host_t *ha, srb_t *sp)
  * @index: SRB index
  */
 static void
-qla2x00_process_completed_request(struct scsi_qla_host *ha, uint32_t index)
+qla2x00_process_completed_request(struct scsi_qla_host *vha, uint32_t index)
 {
 	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
 		DEBUG2(printk("scsi(%ld): Invalid SCSI completion handle %d.\n",
-		    ha->host_no, index));
+		    vha->host_no, index));
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid SCSI completion handle %d.\n", index);
 
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		return;
 	}
 
-	sp = ha->outstanding_cmds[index];
+	sp = req->outstanding_cmds[index];
 	if (sp) {
 		/* Free outstanding command slot. */
-		ha->outstanding_cmds[index] = NULL;
+		req->outstanding_cmds[index] = NULL;
 
 		CMD_COMPL_STATUS(sp->cmd) = 0L;
 		CMD_SCSI_STATUS(sp->cmd) = 0L;
@@ -777,15 +791,15 @@ qla2x00_process_completed_request(struct scsi_qla_host *ha, uint32_t index)
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
 
-		qla2x00_ramp_up_queue_depth(ha, sp);
-		qla2x00_sp_compl(ha, sp);
+		qla2x00_ramp_up_queue_depth(vha, sp);
+		qla2x00_sp_compl(vha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid ISP SCSI completion handle\n");
 
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	}
 }
 
@@ -794,32 +808,34 @@ qla2x00_process_completed_request(struct scsi_qla_host *ha, uint32_t index)
  * @ha: SCSI driver HA context
  */
 void
-qla2x00_process_response_queue(struct scsi_qla_host *ha)
+qla2x00_process_response_queue(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
+	struct rsp_que *rsp = ha->rsp;
 
-	if (!ha->flags.online)
+	if (!vha->flags.online)
 		return;
 
-	while (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
-		pkt = (sts_entry_t *)ha->response_ring_ptr;
+	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+		pkt = (sts_entry_t *)rsp->ring_ptr;
 
-		ha->rsp_ring_index++;
-		if (ha->rsp_ring_index == ha->response_q_length) {
-			ha->rsp_ring_index = 0;
-			ha->response_ring_ptr = ha->response_ring;
+		rsp->ring_index++;
+		if (rsp->ring_index == rsp->length) {
+			rsp->ring_index = 0;
+			rsp->ring_ptr = rsp->ring;
 		} else {
-			ha->response_ring_ptr++;
+			rsp->ring_ptr++;
 		}
 
 		if (pkt->entry_status != 0) {
 			DEBUG3(printk(KERN_INFO
-			    "scsi(%ld): Process error entry.\n", ha->host_no));
+			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
-			qla2x00_error_entry(ha, pkt);
+			qla2x00_error_entry(vha, pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -827,31 +843,31 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 
 		switch (pkt->entry_type) {
 		case STATUS_TYPE:
-			qla2x00_status_entry(ha, pkt);
+			qla2x00_status_entry(vha, pkt);
 			break;
 		case STATUS_TYPE_21:
 			handle_cnt = ((sts21_entry_t *)pkt)->handle_count;
 			for (cnt = 0; cnt < handle_cnt; cnt++) {
-				qla2x00_process_completed_request(ha,
+				qla2x00_process_completed_request(vha,
 				    ((sts21_entry_t *)pkt)->handle[cnt]);
 			}
 			break;
 		case STATUS_TYPE_22:
 			handle_cnt = ((sts22_entry_t *)pkt)->handle_count;
 			for (cnt = 0; cnt < handle_cnt; cnt++) {
-				qla2x00_process_completed_request(ha,
+				qla2x00_process_completed_request(vha,
 				    ((sts22_entry_t *)pkt)->handle[cnt]);
 			}
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
 			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
 			    "scsi(%ld): Received unknown response pkt type %x "
 			    "entry status=%x.\n",
-			    ha->host_no, pkt->entry_type, pkt->entry_status));
+			    vha->host_no, pkt->entry_type, pkt->entry_status));
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -859,7 +875,7 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 	}
 
 	/* Adjust ring index */
-	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), ha->rsp_ring_index);
+	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), rsp->ring_index);
 }
 
 static inline void
@@ -881,10 +897,10 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	sp->request_sense_ptr += sense_len;
 	sp->request_sense_length -= sense_len;
 	if (sp->request_sense_length != 0)
-		sp->fcport->ha->status_srb = sp;
+		sp->fcport->vha->status_srb = sp;
 
 	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
-	    "cmd=%p pid=%ld\n", __func__, sp->fcport->ha->host_no,
+	    "cmd=%p pid=%ld\n", __func__, sp->fcport->vha->host_no,
 	    cp->device->channel, cp->device->id, cp->device->lun, cp,
 	    cp->serial_number));
 	if (sense_len)
@@ -898,7 +914,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
  * @pkt: Entry pointer
  */
 static void
-qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
+qla2x00_status_entry(scsi_qla_host_t *vha, void *pkt)
 {
 	srb_t		*sp;
 	fc_port_t	*fcport;
@@ -911,6 +927,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	int32_t		resid;
 	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
 	uint8_t		*rsp_info, *sense_data;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -924,31 +942,31 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
-		qla2x00_process_completed_request(ha, sts->handle);
+		qla2x00_process_completed_request(vha, sts->handle);
 
 		return;
 	}
 
 	/* Validate handle. */
 	if (sts->handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = ha->outstanding_cmds[sts->handle];
-		ha->outstanding_cmds[sts->handle] = NULL;
+		sp = req->outstanding_cmds[sts->handle];
+		req->outstanding_cmds[sts->handle] = NULL;
 	} else
 		sp = NULL;
 
 	if (sp == NULL) {
 		DEBUG2(printk("scsi(%ld): Status Entry invalid handle.\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha, "Status Entry invalid handle.\n");
 
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		qla2xxx_wake_dpc(ha);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
 		return;
 	}
 	cp = sp->cmd;
 	if (cp == NULL) {
 		DEBUG2(printk("scsi(%ld): Command already returned back to OS "
-		    "pkt->handle=%d sp=%p.\n", ha->host_no, sts->handle, sp));
+		    "pkt->handle=%d sp=%p.\n", vha->host_no, sts->handle, sp));
 		qla_printk(KERN_WARNING, ha,
 		    "Command is NULL: already returned to OS (sp=%p)\n", sp);
 
@@ -987,14 +1005,14 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (rsp_info_len > 3 && rsp_info[3]) {
 			DEBUG2(printk("scsi(%ld:%d:%d:%d) FCP I/O protocol "
 			    "failure (%x/%02x%02x%02x%02x%02x%02x%02x%02x)..."
-			    "retrying command\n", ha->host_no,
+			    "retrying command\n", vha->host_no,
 			    cp->device->channel, cp->device->id,
 			    cp->device->lun, rsp_info_len, rsp_info[0],
 			    rsp_info[1], rsp_info[2], rsp_info[3], rsp_info[4],
 			    rsp_info[5], rsp_info[6], rsp_info[7]));
 
 			cp->result = DID_BUS_BUSY << 16;
-			qla2x00_sp_compl(ha, sp);
+			qla2x00_sp_compl(vha, sp);
 			return;
 		}
 	}
@@ -1025,7 +1043,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				qla_printk(KERN_INFO, ha,
 					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
 					   "detected (%x of %x bytes)...returning "
-					   "error status.\n", ha->host_no,
+					   "error status.\n", vha->host_no,
 					   cp->device->channel, cp->device->id,
 					   cp->device->lun, resid,
 					   scsi_bufflen(cp));
@@ -1039,7 +1057,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld): QUEUE FULL status detected "
-			    "0x%x-0x%x.\n", ha->host_no, comp_status,
+			    "0x%x-0x%x.\n", vha->host_no, comp_status,
 			    scsi_status));
 
 			/* Adjust queue depth for all luns on the port. */
@@ -1078,7 +1096,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d) UNDERRUN status detected "
 			    "0x%x-0x%x. resid=0x%x fw_resid=0x%x cdb=0x%x "
-			    "os_underflow=0x%x\n", ha->host_no,
+			    "os_underflow=0x%x\n", vha->host_no,
 			    cp->device->id, cp->device->lun, comp_status,
 			    scsi_status, resid_len, resid, cp->cmnd[0],
 			    cp->underflow));
@@ -1095,7 +1113,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
 				DEBUG2(printk(KERN_INFO
 				    "scsi(%ld): QUEUE FULL status detected "
-				    "0x%x-0x%x.\n", ha->host_no, comp_status,
+				    "0x%x-0x%x.\n", vha->host_no, comp_status,
 				    scsi_status));
 
 				/*
@@ -1125,10 +1143,10 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
 				DEBUG2(printk("scsi(%ld:%d:%d:%d) Dropped "
 					      "frame(s) detected (%x of %x bytes)..."
-					      "retrying command.\n", ha->host_no,
-					      cp->device->channel, cp->device->id,
-					      cp->device->lun, resid,
-					      scsi_bufflen(cp)));
+					      "retrying command.\n",
+					vha->host_no, cp->device->channel,
+					cp->device->id, cp->device->lun, resid,
+					scsi_bufflen(cp)));
 
 				cp->result = DID_BUS_BUSY << 16;
 				break;
@@ -1140,7 +1158,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				qla_printk(KERN_INFO, ha,
 					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
 					   "detected (%x of %x bytes)...returning "
-					   "error status.\n", ha->host_no,
+					   "error status.\n", vha->host_no,
 					   cp->device->channel, cp->device->id,
 					   cp->device->lun, resid,
 					   scsi_bufflen(cp));
@@ -1157,7 +1175,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	case CS_DATA_OVERRUN:
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld:%d:%d): OVERRUN status detected 0x%x-0x%x\n",
-		    ha->host_no, cp->device->id, cp->device->lun, comp_status,
+		    vha->host_no, cp->device->id, cp->device->lun, comp_status,
 		    scsi_status));
 		DEBUG2(printk(KERN_INFO
 		    "CDB: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
@@ -1183,19 +1201,19 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		 */
 		DEBUG2(printk("scsi(%ld:%d:%d): status_entry: Port Down "
 		    "pid=%ld, compl status=0x%x, port state=0x%x\n",
-		    ha->host_no, cp->device->id, cp->device->lun,
+		    vha->host_no, cp->device->id, cp->device->lun,
 		    cp->serial_number, comp_status,
 		    atomic_read(&fcport->state)));
 
 		cp->result = DID_BUS_BUSY << 16;
 		if (atomic_read(&fcport->state) == FCS_ONLINE)
-			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
+			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 		break;
 
 	case CS_RESET:
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld): RESET status detected 0x%x-0x%x.\n",
-		    ha->host_no, comp_status, scsi_status));
+		    vha->host_no, comp_status, scsi_status));
 
 		cp->result = DID_RESET << 16;
 		break;
@@ -1208,7 +1226,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		 */
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld): ABORT status detected 0x%x-0x%x.\n",
-		    ha->host_no, comp_status, scsi_status));
+		    vha->host_no, comp_status, scsi_status));
 
 		cp->result = DID_RESET << 16;
 		break;
@@ -1219,25 +1237,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d:%d): TIMEOUT status detected "
-			    "0x%x-0x%x\n", ha->host_no, cp->device->channel,
+			    "0x%x-0x%x\n", vha->host_no, cp->device->channel,
 			    cp->device->id, cp->device->lun, comp_status,
 			    scsi_status));
 			break;
 		}
 		DEBUG2(printk(KERN_INFO
 		    "scsi(%ld:%d:%d:%d): TIMEOUT status detected 0x%x-0x%x "
-		    "sflags=%x.\n", ha->host_no, cp->device->channel,
+		    "sflags=%x.\n", vha->host_no, cp->device->channel,
 		    cp->device->id, cp->device->lun, comp_status, scsi_status,
 		    le16_to_cpu(sts->status_flags)));
 
 		/* Check to see if logout occurred. */
 		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
-			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
+			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 		break;
 
 	default:
 		DEBUG3(printk("scsi(%ld): Error detected (unknown status) "
-		    "0x%x-0x%x.\n", ha->host_no, comp_status, scsi_status));
+		    "0x%x-0x%x.\n", vha->host_no, comp_status, scsi_status));
 		qla_printk(KERN_INFO, ha,
 		    "Unknown status detected 0x%x-0x%x.\n",
 		    comp_status, scsi_status);
@@ -1247,8 +1265,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	}
 
 	/* Place command on done queue. */
-	if (ha->status_srb == NULL)
-		qla2x00_sp_compl(ha, sp);
+	if (vha->status_srb == NULL)
+		qla2x00_sp_compl(vha, sp);
 }
 
 /**
@@ -1259,10 +1277,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
  * Extended sense data.
  */
 static void
-qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
+qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
 {
 	uint8_t		sense_sz = 0;
-	srb_t		*sp = ha->status_srb;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t		*sp = vha->status_srb;
 	struct scsi_cmnd *cp;
 
 	if (sp != NULL && sp->request_sense_length != 0) {
@@ -1274,7 +1293,7 @@ qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
 			    "cmd is NULL: already returned to OS (sp=%p)\n",
 			    sp);
 
-			ha->status_srb = NULL;
+			vha->status_srb = NULL;
 			return;
 		}
 
@@ -1295,8 +1314,8 @@ qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
 
 		/* Place command on done queue. */
 		if (sp->request_sense_length == 0) {
-			ha->status_srb = NULL;
-			qla2x00_sp_compl(ha, sp);
+			vha->status_srb = NULL;
+			qla2x00_sp_compl(vha, sp);
 		}
 	}
 }
@@ -1307,10 +1326,11 @@ qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
  * @pkt: Entry pointer
  */
 static void
-qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
+qla2x00_error_entry(scsi_qla_host_t *vha, sts_entry_t *pkt)
 {
 	srb_t *sp;
-
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 #if defined(QL_DEBUG_LEVEL_2)
 	if (pkt->entry_status & RF_INV_E_ORDER)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Order\n", __func__);
@@ -1329,13 +1349,13 @@ qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 
 	/* Validate handle. */
 	if (pkt->handle < MAX_OUTSTANDING_COMMANDS)
-		sp = ha->outstanding_cmds[pkt->handle];
+		sp = req->outstanding_cmds[pkt->handle];
 	else
 		sp = NULL;
 
 	if (sp) {
 		/* Free outstanding command slot. */
-		ha->outstanding_cmds[pkt->handle] = NULL;
+		req->outstanding_cmds[pkt->handle] = NULL;
 
 		/* Bad payload or header */
 		if (pkt->entry_status &
@@ -1347,17 +1367,17 @@ qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 		} else {
 			sp->cmd->result = DID_ERROR << 16;
 		}
-		qla2x00_sp_compl(ha, sp);
+		qla2x00_sp_compl(vha, sp);
 
 	} else if (pkt->entry_type == COMMAND_A64_TYPE || pkt->entry_type ==
 	    COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7) {
 		DEBUG2(printk("scsi(%ld): Error entry - invalid handle\n",
-		    ha->host_no));
+		    vha->host_no));
 		qla_printk(KERN_WARNING, ha,
 		    "Error entry - invalid handle\n");
 
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		qla2xxx_wake_dpc(ha);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
 	}
 }
 
@@ -1367,10 +1387,11 @@ qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
  * @mb0: Mailbox0 register
  */
 static void
-qla24xx_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
+qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
 	uint16_t __iomem *wptr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	/* Load return mailbox registers. */
@@ -1385,10 +1406,10 @@ qla24xx_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
 
 	if (ha->mcp) {
 		DEBUG3(printk("%s(%ld): Got mailbox completion. cmd=%x.\n",
-		    __func__, ha->host_no, ha->mcp->mb[0]));
+		    __func__, vha->host_no, ha->mcp->mb[0]));
 	} else {
 		DEBUG2_3(printk("%s(%ld): MBX pointer ERROR!\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 	}
 }
 
@@ -1397,30 +1418,32 @@ qla24xx_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
  * @ha: SCSI driver HA context
  */
 void
-qla24xx_process_response_queue(struct scsi_qla_host *ha)
+qla24xx_process_response_queue(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	struct sts_entry_24xx *pkt;
+	struct rsp_que *rsp = ha->rsp;
 
-	if (!ha->flags.online)
+	if (!vha->flags.online)
 		return;
 
-	while (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
-		pkt = (struct sts_entry_24xx *)ha->response_ring_ptr;
+	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
-		ha->rsp_ring_index++;
-		if (ha->rsp_ring_index == ha->response_q_length) {
-			ha->rsp_ring_index = 0;
-			ha->response_ring_ptr = ha->response_ring;
+		rsp->ring_index++;
+		if (rsp->ring_index == rsp->length) {
+			rsp->ring_index = 0;
+			rsp->ring_ptr = rsp->ring;
 		} else {
-			ha->response_ring_ptr++;
+			rsp->ring_ptr++;
 		}
 
 		if (pkt->entry_status != 0) {
 			DEBUG3(printk(KERN_INFO
-			    "scsi(%ld): Process error entry.\n", ha->host_no));
+			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
-			qla2x00_error_entry(ha, (sts_entry_t *) pkt);
+			qla2x00_error_entry(vha, (sts_entry_t *) pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -1428,13 +1451,13 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 
 		switch (pkt->entry_type) {
 		case STATUS_TYPE:
-			qla2x00_status_entry(ha, pkt);
+			qla2x00_status_entry(vha, pkt);
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
-			qla24xx_report_id_acquisition(ha,
+			qla24xx_report_id_acquisition(vha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
 			break;
 		default:
@@ -1442,7 +1465,7 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 			DEBUG4(printk(KERN_WARNING
 			    "scsi(%ld): Received unknown response pkt type %x "
 			    "entry status=%x.\n",
-			    ha->host_no, pkt->entry_type, pkt->entry_status));
+			    vha->host_no, pkt->entry_type, pkt->entry_status));
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -1450,14 +1473,15 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 	}
 
 	/* Adjust ring index */
-	WRT_REG_DWORD(&reg->rsp_q_out, ha->rsp_ring_index);
+	WRT_REG_DWORD(&reg->rsp_q_out, rsp->ring_index);
 }
 
 static void
-qla2xxx_check_risc_status(scsi_qla_host_t *ha)
+qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 {
 	int rval;
 	uint32_t cnt;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	if (!IS_QLA25XX(ha))
@@ -1511,25 +1535,29 @@ done:
 irqreturn_t
 qla24xx_intr_handler(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
 	struct device_reg_24xx __iomem *reg;
 	int		status;
 	unsigned long	iter;
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
+	struct rsp_que *rsp;
 
-	ha = (scsi_qla_host_t *) dev_id;
-	if (!ha) {
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL host pointer\n", __func__);
+		    "%s(): NULL response queue pointer\n", __func__);
 		return IRQ_NONE;
 	}
 
+	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
+	vha = qla2x00_get_rsp_host(rsp);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1537,7 +1565,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 				break;
 
 			if (ha->hw_event_pause_errors == 0)
-				qla2x00_post_hwe_work(ha, HW_EVENT_PARITY_ERR,
+				qla2x00_post_hwe_work(vha, HW_EVENT_PARITY_ERR,
 				    0, MSW(stat), LSW(stat));
 			else if (ha->hw_event_pause_errors < 0xffffffff)
 				ha->hw_event_pause_errors++;
@@ -1547,10 +1575,10 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
 
-			qla2xxx_check_risc_status(ha);
+			qla2xxx_check_risc_status(vha);
 
-			ha->isp_ops->fw_dump(ha, 1);
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			ha->isp_ops->fw_dump(vha, 1);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
 			break;
@@ -1560,7 +1588,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		case 0x2:
 		case 0x10:
 		case 0x11:
-			qla24xx_mbx_completion(ha, MSW(stat));
+			qla24xx_mbx_completion(vha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			break;
@@ -1569,15 +1597,15 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
-			qla2x00_async_event(ha, mb);
+			qla2x00_async_event(vha, mb);
 			break;
 		case 0x13:
-			qla24xx_process_response_queue(ha);
+			qla24xx_process_response_queue(vha);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
-			    ha->host_no, stat & 0xff));
+			    vha->host_no, stat & 0xff));
 			break;
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -1597,15 +1625,24 @@ qla24xx_intr_handler(int irq, void *dev_id)
 static irqreturn_t
 qla24xx_msix_rsp_q(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
 
-	ha = dev_id;
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		printk(KERN_INFO
+		"%s(): NULL response queue pointer\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(ha);
+	vha = qla2x00_get_rsp_host(rsp);
+	qla24xx_process_response_queue(vha);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
@@ -1616,18 +1653,27 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 static irqreturn_t
 qla24xx_msix_default(int irq, void *dev_id)
 {
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*vha;
+	struct qla_hw_data *ha;
+	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
 	int		status;
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
 
-	ha = dev_id;
+	rsp = (struct rsp_que *) dev_id;
+	if (!rsp) {
+		DEBUG(printk(
+		"%s(): NULL response queue pointer\n", __func__));
+		return IRQ_NONE;
+	}
+	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 	status = 0;
 
 	spin_lock_irq(&ha->hardware_lock);
+	vha = qla2x00_get_rsp_host(rsp);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1635,7 +1681,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 				break;
 
 			if (ha->hw_event_pause_errors == 0)
-				qla2x00_post_hwe_work(ha, HW_EVENT_PARITY_ERR,
+				qla2x00_post_hwe_work(vha, HW_EVENT_PARITY_ERR,
 				    0, MSW(stat), LSW(stat));
 			else if (ha->hw_event_pause_errors < 0xffffffff)
 				ha->hw_event_pause_errors++;
@@ -1645,10 +1691,10 @@ qla24xx_msix_default(int irq, void *dev_id)
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
 
-			qla2xxx_check_risc_status(ha);
+			qla2xxx_check_risc_status(vha);
 
-			ha->isp_ops->fw_dump(ha, 1);
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+			ha->isp_ops->fw_dump(vha, 1);
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
 			break;
@@ -1658,7 +1704,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		case 0x2:
 		case 0x10:
 		case 0x11:
-			qla24xx_mbx_completion(ha, MSW(stat));
+			qla24xx_mbx_completion(vha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			break;
@@ -1667,15 +1713,15 @@ qla24xx_msix_default(int irq, void *dev_id)
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
-			qla2x00_async_event(ha, mb);
+			qla2x00_async_event(vha, mb);
 			break;
 		case 0x13:
-			qla24xx_process_response_queue(ha);
+			qla24xx_process_response_queue(vha);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
-			    ha->host_no, stat & 0xff));
+			    vha->host_no, stat & 0xff));
 			break;
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -1709,23 +1755,25 @@ static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
 };
 
 static void
-qla24xx_disable_msix(scsi_qla_host_t *ha)
+qla24xx_disable_msix(struct qla_hw_data *ha)
 {
 	int i;
 	struct qla_msix_entry *qentry;
+	struct rsp_que *rsp = ha->rsp;
 
 	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
 		qentry = &ha->msix_entries[imsix_entries[i].index];
 		if (qentry->have_irq)
-			free_irq(qentry->msix_vector, ha);
+			free_irq(qentry->msix_vector, rsp);
 	}
 	pci_disable_msix(ha->pdev);
 }
 
 static int
-qla24xx_enable_msix(scsi_qla_host_t *ha)
+qla24xx_enable_msix(struct qla_hw_data *ha)
 {
 	int i, ret;
+	struct rsp_que *rsp = ha->rsp;
 	struct msix_entry entries[QLA_MSIX_ENTRIES];
 	struct qla_msix_entry *qentry;
 
@@ -1747,7 +1795,7 @@ qla24xx_enable_msix(scsi_qla_host_t *ha)
 		qentry->msix_entry = entries[i].entry;
 		qentry->have_irq = 0;
 		ret = request_irq(qentry->msix_vector,
-		    imsix_entries[i].handler, 0, imsix_entries[i].name, ha);
+		    imsix_entries[i].handler, 0, imsix_entries[i].name, rsp);
 		if (ret) {
 			qla_printk(KERN_WARNING, ha,
 			    "MSI-X: Unable to register handler -- %x/%d.\n",
@@ -1763,20 +1811,21 @@ msix_out:
 }
 
 int
-qla2x00_request_irqs(scsi_qla_host_t *ha)
+qla2x00_request_irqs(struct qla_hw_data *ha)
 {
 	int ret;
 	device_reg_t __iomem *reg = ha->iobase;
+	struct rsp_que *rsp = ha->rsp;
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha))
 		goto skip_msix;
 
-        if (IS_QLA2432(ha) && (ha->chip_revision < QLA_MSIX_CHIP_REV_24XX ||
-	    !QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
+	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
+		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
-		    ha->chip_revision, ha->fw_attributes));
+		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
+			ha->pdev->revision, ha->fw_attributes));
 
 		goto skip_msix;
 	}
@@ -1815,7 +1864,7 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
+	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
@@ -1823,10 +1872,8 @@ skip_msi:
 		goto fail;
 	}
 	ha->flags.inta_enabled = 1;
-	ha->host->irq = ha->pdev->irq;
 clear_risc_ints:
 
-	ha->isp_ops->disable_intrs(ha);
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
@@ -1843,13 +1890,35 @@ fail:
 }
 
 void
-qla2x00_free_irqs(scsi_qla_host_t *ha)
+qla2x00_free_irqs(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+	struct rsp_que *rsp = ha->rsp;
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
 	else if (ha->flags.inta_enabled) {
-		free_irq(ha->host->irq, ha);
+		free_irq(vha->host->irq, rsp);
 		pci_disable_msi(ha->pdev);
 	}
 }
+
+static struct scsi_qla_host *
+qla2x00_get_rsp_host(struct rsp_que *rsp)
+{
+	srb_t *sp;
+	struct qla_hw_data *ha = rsp->hw;
+	struct scsi_qla_host *vha = NULL;
+	struct sts_entry_24xx *pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
+
+	if (pkt && pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+		sp = ha->req->outstanding_cmds[pkt->handle];
+		if (sp)
+			vha = sp->vha;
+	}
+	if (!vha)
+	/* Invalid entry, handle it in base queue */
+		vha = pci_get_drvdata(ha->pdev);
+
+	return vha;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3433441..22c753b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -183,42 +183,122 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  */
 
 __inline__ void
-qla2x00_start_timer(scsi_qla_host_t *ha, void *func, unsigned long interval)
+qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
 {
-	init_timer(&ha->timer);
-	ha->timer.expires = jiffies + interval * HZ;
-	ha->timer.data = (unsigned long)ha;
-	ha->timer.function = (void (*)(unsigned long))func;
-	add_timer(&ha->timer);
-	ha->timer_active = 1;
+	init_timer(&vha->timer);
+	vha->timer.expires = jiffies + interval * HZ;
+	vha->timer.data = (unsigned long)vha;
+	vha->timer.function = (void (*)(unsigned long))func;
+	add_timer(&vha->timer);
+	vha->timer_active = 1;
 }
 
 static inline void
-qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned long interval)
+qla2x00_restart_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
-	mod_timer(&ha->timer, jiffies + interval * HZ);
+	mod_timer(&vha->timer, jiffies + interval * HZ);
 }
 
 static __inline__ void
-qla2x00_stop_timer(scsi_qla_host_t *ha)
+qla2x00_stop_timer(scsi_qla_host_t *vha)
 {
-	del_timer_sync(&ha->timer);
-	ha->timer_active = 0;
+	del_timer_sync(&vha->timer);
+	vha->timer_active = 0;
 }
 
 static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-static int qla2x00_mem_alloc(scsi_qla_host_t *);
-static void qla2x00_mem_free(scsi_qla_host_t *ha);
-static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
+static int qla2x00_mem_alloc(struct qla_hw_data *);
+static void qla2x00_mem_free(struct qla_hw_data *);
+static void qla2x00_sp_free_dma(srb_t *);
 
 /* -------------------------------------------------------------------------- */
+static int
+qla2x00_alloc_que(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len)
+{
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+
+	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
+	if (!req) {
+		DEBUG(printk("Unable to allocate memory for req\n"));
+		goto fail_req;
+	}
+	ha->req = req;
+	req->length = req_len;
+	req->ring = dma_alloc_coherent(&ha->pdev->dev,
+		(req->length + 1) * sizeof(request_t),
+		&req->dma, GFP_KERNEL);
+	if (!req->ring) {
+		DEBUG(printk("Unable to allocate memory for req_ring\n"));
+		goto fail_req_ring;
+	}
+
+	rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
+	if (!rsp) {
+		DEBUG(printk("Unable to allocate memory for rsp\n"));
+		goto fail_rsp;
+	}
+	ha->rsp = rsp;
+	rsp->hw = ha;
+	rsp->length = rsp_len;
+
+	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
+		(rsp->length + 1) * sizeof(response_t),
+		&rsp->dma, GFP_KERNEL);
+	if (!rsp->ring) {
+		DEBUG(printk("Unable to allocate memory for rsp_ring\n"));
+		goto fail_rsp_ring;
+	}
+	return 1;
+
+fail_rsp_ring:
+	kfree(rsp);
+	ha->rsp = NULL;
+fail_rsp:
+	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
+		sizeof(request_t), req->ring, req->dma);
+	req->ring = NULL;
+	req->dma = 0;
+fail_req_ring:
+	kfree(req);
+	ha->req = NULL;
+fail_req:
+	return 0;
+}
+
+static void
+qla2x00_free_que(struct qla_hw_data *ha)
+{
+	struct req_que *req = ha->req;
+	struct rsp_que *rsp = ha->rsp;
+	if (rsp) {
+		if (rsp->ring)
+			dma_free_coherent(&ha->pdev->dev,
+			(rsp->length + 1) * sizeof(response_t),
+			rsp->ring, rsp->dma);
+
+		kfree(rsp);
+		rsp = NULL;
+	}
+
+	if (req) {
+		if (req->ring)
+			dma_free_coherent(&ha->pdev->dev,
+			(req->length + 1) * sizeof(request_t),
+			req->ring, req->dma);
+
+		kfree(req);
+		req = NULL;
+	}
+}
 
 static char *
-qla2x00_pci_info_str(struct scsi_qla_host *ha, char *str)
+qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
+	struct qla_hw_data *ha = vha->hw;
 	static char *pci_bus_modes[] = {
 		"33", "66", "100", "133",
 	};
@@ -240,9 +320,10 @@ qla2x00_pci_info_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
+qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
 	static char *pci_bus_modes[] = { "33", "66", "100", "133", };
+	struct qla_hw_data *ha = vha->hw;
 	uint32_t pci_bus;
 	int pcie_reg;
 
@@ -290,9 +371,10 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
+qla2x00_fw_version_str(struct scsi_qla_host *vha, char *str)
 {
 	char un_str[10];
+	struct qla_hw_data *ha = vha->hw;
 
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
 	    ha->fw_minor_version,
@@ -328,8 +410,9 @@ qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
+qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 {
+	struct qla_hw_data *ha = vha->hw;
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
 	    ha->fw_minor_version,
 	    ha->fw_subminor_version);
@@ -354,16 +437,17 @@ qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
 }
 
 static inline srb_t *
-qla2x00_get_new_sp(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
     struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
 	if (!sp)
 		return sp;
 
-	sp->ha = ha;
+	sp->vha = vha;
 	sp->fcport = fcport;
 	sp->cmd = cmd;
 	sp->flags = 0;
@@ -376,9 +460,10 @@ qla2x00_get_new_sp(scsi_qla_host_t *ha, fc_port_t *fcport,
 static int
 qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
+	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	int rval;
 
@@ -401,16 +486,16 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+		    atomic_read(&vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
 		goto qc_host_busy;
 	}
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(vha->host->host_lock);
 
-	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(vha, fcport, cmd, done);
 	if (!sp)
 		goto qc_host_busy_lock;
 
@@ -418,16 +503,16 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 	return 0;
 
 qc_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
 qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -442,14 +527,15 @@ qc_fail_command:
 static int
 qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	if (unlikely(pci_channel_offline(pha->pdev))) {
+	if (unlikely(pci_channel_offline(ha->pdev))) {
 		cmd->result = DID_REQUEUE << 16;
 		goto qc24_fail_command;
 	}
@@ -468,33 +554,33 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&pha->loop_state) == LOOP_DEAD) {
+		    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
 		goto qc24_host_busy;
 	}
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(vha->host->host_lock);
 
-	sp = qla2x00_get_new_sp(pha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
 		goto qc24_host_busy_lock;
 
-	rval = qla24xx_start_scsi(sp);
+	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(pha, sp);
-	mempool_free(sp, pha->srb_mempool);
+	qla2x00_sp_free_dma(sp);
+	mempool_free(sp, ha->srb_mempool);
 
 qc24_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -512,17 +598,14 @@ qc24_fail_command:
  *    max time.
  *
  * Input:
- *    ha = actual ha whose done queue will contain the command
- *	      returned by firmware.
  *    cmd = Scsi Command to wait on.
- *    flag = Abort/Reset(Bus or Device Reset)
  *
  * Return:
  *    Not Found : 0
  *    Found : 1
  */
 static int
-qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
+qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 {
 #define ABORT_POLLING_PERIOD	1000
 #define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
@@ -559,21 +642,22 @@ qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
  *    Failed  (Adapter is offline/disabled) : 1
  */
 int
-qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
+qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 {
 	int		return_status;
 	unsigned long	wait_online;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ);
-	while (((test_bit(ISP_ABORT_NEEDED, &pha->dpc_flags)) ||
-	    test_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &pha->dpc_flags) ||
-	    pha->dpc_active) && time_before(jiffies, wait_online)) {
+	while (((test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) ||
+	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
 		msleep(1000);
 	}
-	if (pha->flags.online)
+	if (base_vha->flags.online)
 		return_status = QLA_SUCCESS;
 	else
 		return_status = QLA_FUNCTION_FAILED;
@@ -598,19 +682,20 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
  *    Failed  (LOOP_NOT_READY) : 1
  */
 static inline int
-qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
+qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 {
 	int 	 return_status = QLA_SUCCESS;
 	unsigned long loop_timeout ;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* wait for 5 min at the max for loop to be ready */
 	loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ);
 
-	while ((!atomic_read(&pha->loop_down_timer) &&
-	    atomic_read(&pha->loop_state) == LOOP_DOWN) ||
-	    atomic_read(&pha->loop_state) != LOOP_READY) {
-		if (atomic_read(&pha->loop_state) == LOOP_DEAD) {
+	while ((!atomic_read(&base_vha->loop_down_timer) &&
+	    atomic_read(&base_vha->loop_state) == LOOP_DOWN) ||
+	    atomic_read(&base_vha->loop_state) != LOOP_READY) {
+		if (atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			return_status = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -629,32 +714,33 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 	int cnt;
 	unsigned long flags;
 	srb_t *sp;
-	scsi_qla_host_t *ha = fcport->ha;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = pha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
 		if (sp->fcport != fcport)
 			continue;
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(ha, sp)) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp)) {
 			DEBUG2(qla_printk(KERN_WARNING, ha,
 			    "Abort failed --  %lx\n", sp->cmd->serial_number));
 		} else {
-			if (qla2x00_eh_wait_on_command(ha, sp->cmd) !=
+			if (qla2x00_eh_wait_on_command(sp->cmd) !=
 			    QLA_SUCCESS)
 				DEBUG2(qla_printk(KERN_WARNING, ha,
 				    "Abort failed while waiting --  %lx\n",
 				    sp->cmd->serial_number));
 
 		}
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 static void
@@ -692,14 +778,15 @@ qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
 static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
 	int ret, i;
 	unsigned int id, lun;
 	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	qla2x00_block_error_handler(cmd);
 
@@ -713,9 +800,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	serial = cmd->serial_number;
 
 	/* Check active list for command command. */
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp = pha->outstanding_cmds[i];
+		sp = req->outstanding_cmds[i];
 
 		if (sp == NULL)
 			continue;
@@ -724,36 +811,36 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			continue;
 
 		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
-		    __func__, ha->host_no, sp, serial));
+		    __func__, vha->host_no, sp, serial));
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(ha, sp)) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
-			    "mbx failed.\n", __func__, ha->host_no));
+			    "mbx failed.\n", __func__, vha->host_no));
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
-			    "mbx success.\n", __func__, ha->host_no));
+			    "mbx success.\n", __func__, vha->host_no));
 			wait = 1;
 		}
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 		break;
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for the command to be returned. */
 	if (wait) {
-		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
+		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
 			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
-			    "%x.\n", ha->host_no, id, lun, serial, ret);
+			    "%x.\n", vha->host_no, id, lun, serial, ret);
 			ret = FAILED;
 		}
 	}
 
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
-	    ha->host_no, id, lun, wait, serial, ret);
+	    vha->host_no, id, lun, wait, serial, ret);
 
 	return ret;
 }
@@ -765,23 +852,24 @@ enum nexus_wait_type {
 };
 
 static int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
     unsigned int l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	srb_t *sp;
 	unsigned long flags;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	status = QLA_SUCCESS;
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; status == QLA_SUCCESS && cnt < MAX_OUTSTANDING_COMMANDS;
 	    cnt++) {
-		sp = pha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
 
-		if (ha->vp_idx != sp->fcport->ha->vp_idx)
+		if (vha->vp_idx != sp->fcport->vha->vp_idx)
 			continue;
 		match = 0;
 		switch (type) {
@@ -799,11 +887,11 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
 		if (!match)
 			continue;
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		status = qla2x00_eh_wait_on_command(ha, sp->cmd);
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		status = qla2x00_eh_wait_on_command(sp->cmd);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return status;
 }
@@ -819,7 +907,7 @@ static int
 __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
     struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
@@ -828,31 +916,31 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	if (!fcport)
 		return FAILED;
 
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name);
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
 	err = 0;
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 1;
-	if (qla2x00_wait_for_loop_ready(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 2;
 	if (do_reset(fcport, cmd->device->lun) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(ha, cmd->device->id,
+	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
 	    cmd->device->lun, type) != QLA_SUCCESS)
 		goto eh_reset_failed;
 
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name);
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
 	return SUCCESS;
 
  eh_reset_failed:
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name,
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n"
+	    , vha->host_no, cmd->device->id, cmd->device->lun, name,
 	    reset_errors[err]);
 	return FAILED;
 }
@@ -860,7 +948,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 static int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 
 	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
 	    ha->isp_ops->lun_reset);
@@ -869,7 +958,8 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 
 	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
 	    ha->isp_ops->target_reset);
@@ -893,8 +983,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
 	unsigned int id, lun;
@@ -909,28 +998,28 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	if (!fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, vha->hw,
+	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
 		goto eh_bus_reset_done;
 	}
 
-	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_loop_reset(ha) == QLA_SUCCESS)
+	if (qla2x00_wait_for_loop_ready(vha) == QLA_SUCCESS) {
+		if (qla2x00_loop_reset(vha) == QLA_SUCCESS)
 			ret = SUCCESS;
 	}
 	if (ret == FAILED)
 		goto eh_bus_reset_done;
 
 	/* Flush outstanding commands. */
-	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) !=
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) !=
 	    QLA_SUCCESS)
 		ret = FAILED;
 
 eh_bus_reset_done:
-	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
+	qla_printk(KERN_INFO, vha->hw, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
 
 	return ret;
@@ -954,12 +1043,13 @@ eh_bus_reset_done:
 static int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	qla2x00_block_error_handler(cmd);
 
@@ -971,9 +1061,9 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
+	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
 
 	/*
@@ -984,26 +1074,28 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	 * devices as lost kicking of the port_down_timer
 	 * while dpc is stuck for the mailbox to complete.
 	 */
-	qla2x00_wait_for_loop_ready(ha);
-	set_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
-	if (qla2x00_abort_isp(pha)) {
-		clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
-		/* failed. schedule dpc to try */
-		set_bit(ISP_ABORT_NEEDED, &pha->dpc_flags);
-
-		if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	qla2x00_wait_for_loop_ready(vha);
+	if (vha != base_vha) {
+		if (qla2x00_vp_abort_isp(vha))
 			goto eh_host_reset_lock;
+	} else {
+		set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+		if (qla2x00_abort_isp(base_vha)) {
+			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+			/* failed. schedule dpc to try */
+			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+
+			if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+				goto eh_host_reset_lock;
+		}
+		clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	}
-	clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
 
-	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) ==
-	    QLA_SUCCESS)
+	/* Waiting for command to be returned to OS.*/
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) ==
+		QLA_SUCCESS)
 		ret = SUCCESS;
 
-	if (ha->parent)
-		qla2x00_vp_abort_isp(ha);
-
 eh_host_reset_lock:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
@@ -1022,35 +1114,33 @@ eh_host_reset_lock:
 *      0 = success
 */
 int
-qla2x00_loop_reset(scsi_qla_host_t *ha)
+qla2x00_loop_reset(scsi_qla_host_t *vha)
 {
 	int ret;
 	struct fc_port *fcport;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->flags.enable_lip_full_login) {
-		ret = qla2x00_full_login_lip(ha);
+		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-			    "full_login_lip=%d.\n", __func__, ha->host_no,
+			    "full_login_lip=%d.\n", __func__, vha->host_no,
 			    ret));
-		}
-		atomic_set(&ha->loop_state, LOOP_DOWN);
-		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(ha, 0);
-		qla2x00_wait_for_loop_ready(ha);
+		} else
+			qla2x00_wait_for_loop_ready(vha);
 	}
 
 	if (ha->flags.enable_lip_reset) {
-		ret = qla2x00_lip_reset(ha);
+		ret = qla2x00_lip_reset(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-			    "lip_reset=%d.\n", __func__, ha->host_no, ret));
-		}
-		qla2x00_wait_for_loop_ready(ha);
+			    "lip_reset=%d.\n", __func__, vha->host_no, ret));
+		} else
+			qla2x00_wait_for_loop_ready(vha);
 	}
 
 	if (ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
@@ -1058,31 +1148,33 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
-				    ha->host_no, ret, fcport->d_id.b24));
+				    vha->host_no, ret, fcport->d_id.b24));
 			}
 		}
 	}
 
 	/* Issue marker command only when we are going to start the I/O */
-	ha->marker_needed = 1;
+	vha->marker_needed = 1;
 
 	return QLA_SUCCESS;
 }
 
 void
-qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
+qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
 	int cnt;
 	unsigned long flags;
 	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = ha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (sp) {
-			ha->outstanding_cmds[cnt] = NULL;
+			req->outstanding_cmds[cnt] = NULL;
 			sp->cmd->result = res;
-			qla2x00_sp_compl(ha, sp);
+			qla2x00_sp_compl(vha, sp);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1104,13 +1196,14 @@ qla2xxx_slave_alloc(struct scsi_device *sdev)
 static int
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
-	scsi_qla_host_t *ha = shost_priv(sdev->host);
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
+	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, ha->max_q_depth);
+		scsi_activate_tcq(sdev, ha->req->max_q_depth);
 	else
-		scsi_deactivate_tcq(sdev, ha->max_q_depth);
+		scsi_deactivate_tcq(sdev, ha->req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
 
@@ -1153,8 +1246,9 @@ qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
  * supported addressing method.
  */
 static void
-qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
+qla2x00_config_dma_addressing(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
@@ -1175,7 +1269,7 @@ qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_enable_intrs(scsi_qla_host_t *ha)
+qla2x00_enable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1190,7 +1284,7 @@ qla2x00_enable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_disable_intrs(scsi_qla_host_t *ha)
+qla2x00_disable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1204,7 +1298,7 @@ qla2x00_disable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_enable_intrs(scsi_qla_host_t *ha)
+qla24xx_enable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -1217,7 +1311,7 @@ qla24xx_enable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_disable_intrs(scsi_qla_host_t *ha)
+qla24xx_disable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -1261,6 +1355,7 @@ static struct isp_operations qla2100_isp_ops = {
 	.read_optrom		= qla2x00_read_optrom_data,
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
+	.start_scsi		= qla2x00_start_scsi,
 };
 
 static struct isp_operations qla2300_isp_ops = {
@@ -1295,6 +1390,7 @@ static struct isp_operations qla2300_isp_ops = {
 	.read_optrom		= qla2x00_read_optrom_data,
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
+	.start_scsi		= qla2x00_start_scsi,
 };
 
 static struct isp_operations qla24xx_isp_ops = {
@@ -1329,6 +1425,7 @@ static struct isp_operations qla24xx_isp_ops = {
 	.read_optrom		= qla24xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_start_scsi,
 };
 
 static struct isp_operations qla25xx_isp_ops = {
@@ -1363,10 +1460,11 @@ static struct isp_operations qla25xx_isp_ops = {
 	.read_optrom		= qla25xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_start_scsi,
 };
 
 static inline void
-qla2x00_set_isp_flags(scsi_qla_host_t *ha)
+qla2x00_set_isp_flags(struct qla_hw_data *ha)
 {
 	ha->device_type = DT_EXTENDED_IDS;
 	switch (ha->pdev->device) {
@@ -1448,7 +1546,7 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 }
 
 static int
-qla2x00_iospace_config(scsi_qla_host_t *ha)
+qla2x00_iospace_config(struct qla_hw_data *ha)
 {
 	resource_size_t pio;
 
@@ -1512,25 +1610,25 @@ iospace_error_exit:
 static void
 qla2xxx_scan_start(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	set_bit(RSCN_UPDATE, &ha->dpc_flags);
-	set_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
+	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+	set_bit(RSCN_UPDATE, &vha->dpc_flags);
+	set_bit(NPIV_CONFIG_NEEDED, &vha->dpc_flags);
 }
 
 static int
 qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	if (!ha->host)
+	if (!vha->host)
 		return 1;
-	if (time > ha->loop_reset_delay * HZ)
+	if (time > vha->hw->loop_reset_delay * HZ)
 		return 1;
 
-	return atomic_read(&ha->loop_state) == LOOP_READY;
+	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
 /*
@@ -1541,11 +1639,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
 	struct Scsi_Host *host;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *base_vha = NULL;
+	struct qla_hw_data *ha;
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
-	int bars, mem_only = 0;
+	int bars, mem_only, max_id = 0;
+	uint16_t req_length = 0, rsp_length = 0;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2x00_driver_template;
@@ -1572,33 +1672,24 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (pci_enable_pcie_error_reporting(pdev))
 			goto probe_out;
 
-	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
-	if (host == NULL) {
-		printk(KERN_WARNING
-		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
-		goto probe_disable_device;
+	ha = kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
+	if (!ha) {
+		DEBUG(printk("Unable to allocate memory for ha\n"));
+		goto probe_out;
 	}
+	ha->pdev = pdev;
 
 	/* Clear our data area */
-	ha = shost_priv(host);
-	memset(ha, 0, sizeof(scsi_qla_host_t));
-
-	ha->pdev = pdev;
-	ha->host = host;
-	ha->host_no = host->host_no;
-	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
-	ha->parent = NULL;
 	ha->bars = bars;
 	ha->mem_only = mem_only;
 	spin_lock_init(&ha->hardware_lock);
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
-
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
-		goto probe_failed;
+		goto probe_hw_failed;
 
 	qla_printk(KERN_INFO, ha,
 	    "Found an ISP%04X, irq %d, iobase 0x%p\n", pdev->device, pdev->irq,
@@ -1606,105 +1697,136 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ha->prev_topology = 0;
 	ha->init_cb_size = sizeof(init_cb_t);
-	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER + ha->vp_idx;
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
 
-	ha->max_q_depth = MAX_Q_DEPTH;
-	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
-		ha->max_q_depth = ql2xmaxqdepth;
-
 	/* Assign ISP specific operations. */
+	max_id = MAX_TARGETS_2200;
 	if (IS_QLA2100(ha)) {
-		host->max_id = MAX_TARGETS_2100;
+		max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2100;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
-		host->sg_tablesize = 32;
+		req_length = REQUEST_ENTRY_CNT_2100;
+		rsp_length = RESPONSE_ENTRY_CNT_2100;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA2200(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
+		req_length = REQUEST_ENTRY_CNT_2200;
+		rsp_length = RESPONSE_ENTRY_CNT_2100;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA23XX(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_2200;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->gid_list_info_size = 6;
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			ha->optrom_size = OPTROM_SIZE_2322;
 		ha->isp_ops = &qla2300_isp_ops;
 	} else if (IS_QLA24XX_TYPE(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_24XX;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
 		ha->isp_ops = &qla24xx_isp_ops;
 	} else if (IS_QLA25XX(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_24XX;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
 	}
-	host->can_queue = ha->request_q_length + 128;
 
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
 
-	INIT_LIST_HEAD(&ha->list);
-	INIT_LIST_HEAD(&ha->fcports);
-	INIT_LIST_HEAD(&ha->vp_list);
-	INIT_LIST_HEAD(&ha->work_list);
-
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
-	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
 
 		ret = -ENOMEM;
-		goto probe_failed;
+		goto probe_hw_failed;
+	}
+
+	/* Allocate queue specific rings */
+	if (!qla2x00_alloc_que(ha, req_length, rsp_length)) {
+		qla_printk(KERN_WARNING, ha,
+			"[ERROR] Failed to allocate memory for queues\n");
+		ret = -ENOMEM;
+		goto probe_hw_failed;
+	}
+
+	ha->req->max_q_depth = MAX_Q_DEPTH;
+	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
+		ha->req->max_q_depth = ql2xmaxqdepth;
+
+	base_vha = qla2x00_create_host(sht, ha);
+	if (!base_vha) {
+		qla_printk(KERN_WARNING, ha,
+		    "[ERROR] Failed to allocate memory for scsi_host\n");
+
+		ret = -ENOMEM;
+		goto probe_hw_failed;
+	}
+
+	pci_set_drvdata(pdev, base_vha);
+
+	qla2x00_config_dma_addressing(base_vha);
+
+	host = base_vha->host;
+	host->can_queue = ha->req->length + 128;
+	if (IS_QLA2XXX_MIDTYPE(ha)) {
+		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
+	} else {
+		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
+						base_vha->vp_idx;
 	}
+	if (IS_QLA2100(ha))
+		host->sg_tablesize = 32;
+	host->max_id = max_id;
+	host->this_id = 255;
+	host->cmd_per_lun = 3;
+	host->unique_id = host->host_no;
+	host->max_cmd_len = MAX_CMDSZ;
+	host->max_channel = MAX_BUSES - 1;
+	host->max_lun = MAX_LUNS;
+	host->transportt = qla2xxx_transport_template;
 
-	if (qla2x00_initialize_adapter(ha)) {
+	if (qla2x00_initialize_adapter(base_vha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
 
 		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
 		    "Adapter flags %x.\n",
-		    ha->host_no, ha->device_flags));
+		    base_vha->host_no, base_vha->device_flags));
 
 		ret = -ENODEV;
 		goto probe_failed;
 	}
 
+	/* Set up the irqs */
+	ret = qla2x00_request_irqs(ha);
+	if (ret)
+		goto probe_failed;
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
 	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
-			"%s_dpc", ha->host_str);
+			"%s_dpc", base_vha->host_str);
 	if (IS_ERR(ha->dpc_thread)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to start DPC thread!\n");
@@ -1712,28 +1834,19 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	host->this_id = 255;
-	host->cmd_per_lun = 3;
-	host->unique_id = host->host_no;
-	host->max_cmd_len = MAX_CMDSZ;
-	host->max_channel = MAX_BUSES - 1;
-	host->max_lun = MAX_LUNS;
-	host->transportt = qla2xxx_transport_template;
-
-	ret = qla2x00_request_irqs(ha);
-	if (ret)
-		goto probe_failed;
+	list_add_tail(&base_vha->list, &ha->vp_list);
+	/* enable interrupts */
+	base_vha->host->irq = ha->pdev->irq;
+	ha->isp_ops->enable_intrs(ha);
 
 	/* Initialized the timer */
-	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
+	qla2x00_start_timer(base_vha, qla2x00_timer, WATCH_INTERVAL);
 
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
-	    ha->host_no, ha));
+	    base_vha->host_no, ha));
 
-	pci_set_drvdata(pdev, ha);
-
-	ha->flags.init_done = 1;
-	ha->flags.online = 1;
+	base_vha->flags.init_done = 1;
+	base_vha->flags.online = 1;
 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
@@ -1743,76 +1856,94 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(host);
 
-	qla2x00_alloc_sysfs_attr(ha);
+	qla2x00_alloc_sysfs_attr(base_vha);
 
-	qla2x00_init_host_attr(ha);
+	qla2x00_init_host_attr(base_vha);
 
-	qla2x00_dfs_setup(ha);
+	qla2x00_dfs_setup(base_vha);
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
 	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
 	    qla2x00_version_str, ha->model_number,
-	    ha->model_desc ? ha->model_desc: "", pdev->device,
-	    ha->isp_ops->pci_info_str(ha, pci_info), pci_name(pdev),
-	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
-	    ha->isp_ops->fw_version_str(ha, fw_str));
+	    ha->model_desc ? ha->model_desc : "", pdev->device,
+	    ha->isp_ops->pci_info_str(base_vha, pci_info), pci_name(pdev),
+	    ha->flags.enable_64bit_addressing ? '+' : '-', base_vha->host_no,
+	    ha->isp_ops->fw_version_str(base_vha, fw_str));
 
 	return 0;
 
 probe_failed:
-	qla2x00_free_device(ha);
+	qla2x00_free_device(base_vha);
 
-	scsi_host_put(host);
+	scsi_host_put(base_vha->host);
 
-probe_disable_device:
-	pci_disable_device(pdev);
+probe_hw_failed:
+	if (ha->iobase)
+		iounmap(ha->iobase);
+
+	pci_release_selected_regions(ha->pdev, ha->bars);
+	kfree(ha);
+	ha = NULL;
 
 probe_out:
+	pci_disable_device(pdev);
 	return ret;
 }
 
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha, *vha, *temp;
+	scsi_qla_host_t *base_vha, *vha, *temp;
+	struct qla_hw_data  *ha;
+
+	base_vha = pci_get_drvdata(pdev);
+	ha = base_vha->hw;
 
-	ha = pci_get_drvdata(pdev);
+	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
+		if (vha && vha->fc_vport)
+			fc_vport_terminate(vha->fc_vport);
+	}
 
-	list_for_each_entry_safe(vha, temp, &ha->vp_list, vp_list)
-		fc_vport_terminate(vha->fc_vport);
+	set_bit(UNLOADING, &base_vha->dpc_flags);
 
-	set_bit(UNLOADING, &ha->dpc_flags);
+	qla2x00_dfs_remove(base_vha);
 
-	qla2x00_dfs_remove(ha);
+	qla84xx_put_chip(base_vha);
 
-	qla84xx_put_chip(ha);
+	qla2x00_free_sysfs_attr(base_vha);
 
-	qla2x00_free_sysfs_attr(ha);
+	fc_remove_host(base_vha->host);
 
-	fc_remove_host(ha->host);
+	scsi_remove_host(base_vha->host);
 
-	scsi_remove_host(ha->host);
+	qla2x00_free_device(base_vha);
 
-	qla2x00_free_device(ha);
+	scsi_host_put(base_vha->host);
 
-	scsi_host_put(ha->host);
+	if (ha->iobase)
+		iounmap(ha->iobase);
+
+	pci_release_selected_regions(ha->pdev, ha->bars);
+	kfree(ha);
+	ha = NULL;
 
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
 static void
-qla2x00_free_device(scsi_qla_host_t *ha)
+qla2x00_free_device(scsi_qla_host_t *vha)
 {
-	qla2x00_abort_all_cmds(ha, DID_NO_CONNECT << 16);
+	struct qla_hw_data *ha = vha->hw;
+	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
 
 	/* Disable timer */
-	if (ha->timer_active)
-		qla2x00_stop_timer(ha);
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
 
-	ha->flags.online = 0;
+	vha->flags.online = 0;
 
 	/* Kill the kernel thread for this host */
 	if (ha->dpc_thread) {
@@ -1827,45 +1958,41 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	}
 
 	if (ha->flags.fce_enabled)
-		qla2x00_disable_fce_trace(ha, NULL, NULL);
+		qla2x00_disable_fce_trace(vha, NULL, NULL);
 
 	if (ha->eft)
-		qla2x00_disable_eft_trace(ha);
+		qla2x00_disable_eft_trace(vha);
 
 	/* Stop currently executing firmware. */
-	qla2x00_try_to_stop_firmware(ha);
+	qla2x00_try_to_stop_firmware(vha);
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
 		ha->isp_ops->disable_intrs(ha);
 
-	qla2x00_mem_free(ha);
+	qla2x00_free_irqs(vha);
 
-	qla2x00_free_irqs(ha);
+	qla2x00_mem_free(ha);
 
-	/* release io space registers  */
-	if (ha->iobase)
-		iounmap(ha->iobase);
-	pci_release_selected_regions(ha->pdev, ha->bars);
+	qla2x00_free_que(ha);
 }
 
 static inline void
-qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
+qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
     int defer)
 {
 	struct fc_rport *rport;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!fcport->rport)
 		return;
 
 	rport = fcport->rport;
 	if (defer) {
-		spin_lock_irq(ha->host->host_lock);
+		spin_lock_irq(vha->host->host_lock);
 		fcport->drport = rport;
-		spin_unlock_irq(ha->host->host_lock);
-		set_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags);
-		qla2xxx_wake_dpc(pha);
+		spin_unlock_irq(vha->host->host_lock);
+		set_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
 	} else
 		fc_remote_port_delete(rport);
 }
@@ -1879,13 +2006,14 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
  *
  * Context:
  */
-void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
+void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
     int do_login, int defer)
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE &&
-	    ha->vp_idx == fcport->vp_idx)
-		qla2x00_schedule_rport_del(ha, fcport, defer);
-
+	    vha->vp_idx == fcport->vp_idx) {
+		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		qla2x00_schedule_rport_del(vha, fcport, defer);
+	}
 	/*
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -1897,13 +2025,13 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
 		return;
 
 	if (fcport->login_retry == 0) {
-		fcport->login_retry = ha->login_retry_count;
-		set_bit(RELOGIN_NEEDED, &ha->dpc_flags);
+		fcport->login_retry = vha->hw->login_retry_count;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
 		DEBUG(printk("scsi(%ld): Port login retry: "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x, "
 		    "id = 0x%04x retry cnt=%d\n",
-		    ha->host_no,
+		    vha->host_no,
 		    fcport->port_name[0],
 		    fcport->port_name[1],
 		    fcport->port_name[2],
@@ -1931,13 +2059,12 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
  * Context:
  */
 void
-qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
+qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 {
 	fc_port_t *fcport;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (ha->vp_idx != fcport->vp_idx)
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (vha->vp_idx != fcport->vp_idx)
 			continue;
 		/*
 		 * No point in marking the device as lost, if the device is
@@ -1945,9 +2072,11 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE)
-			qla2x00_schedule_rport_del(ha, fcport, defer);
-		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			atomic_set(&fcport->state, FCS_DEVICE_LOST);
+			qla2x00_schedule_rport_del(vha, fcport, defer);
+		} else
+			atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
 
@@ -1960,105 +2089,88 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *      !0  = failure.
 */
 static int
-qla2x00_mem_alloc(scsi_qla_host_t *ha)
+qla2x00_mem_alloc(struct qla_hw_data *ha)
 {
 	char	name[16];
 
-	ha->request_ring = dma_alloc_coherent(&ha->pdev->dev,
-	    (ha->request_q_length + 1) * sizeof(request_t), &ha->request_dma,
-	    GFP_KERNEL);
-	if (!ha->request_ring)
-		goto fail;
-
-	ha->response_ring = dma_alloc_coherent(&ha->pdev->dev,
-	    (ha->response_q_length + 1) * sizeof(response_t),
-	    &ha->response_dma, GFP_KERNEL);
-	if (!ha->response_ring)
-		goto fail_free_request_ring;
-
-	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
-	    &ha->gid_list_dma, GFP_KERNEL);
-	if (!ha->gid_list)
-		goto fail_free_response_ring;
+	ha->init_cb_size = sizeof(init_cb_t);
+	if (IS_QLA2XXX_MIDTYPE(ha))
+		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 
 	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
-	    &ha->init_cb_dma, GFP_KERNEL);
+		&ha->init_cb_dma, GFP_KERNEL);
 	if (!ha->init_cb)
-		goto fail_free_gid_list;
+		goto fail;
 
-	snprintf(name, sizeof(name), "%s_%ld", QLA2XXX_DRIVER_NAME,
-	    ha->host_no);
-	ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
-	    DMA_POOL_SIZE, 8, 0);
-	if (!ha->s_dma_pool)
+	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
+		&ha->gid_list_dma, GFP_KERNEL);
+	if (!ha->gid_list)
 		goto fail_free_init_cb;
 
 	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
 	if (!ha->srb_mempool)
-		goto fail_free_s_dma_pool;
+		goto fail_free_gid_list;
 
 	/* Get memory for cached NVRAM */
 	ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
 	if (!ha->nvram)
 		goto fail_free_srb_mempool;
 
+	snprintf(name, sizeof(name), "%s_%d", QLA2XXX_DRIVER_NAME,
+		ha->pdev->device);
+	ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+		DMA_POOL_SIZE, 8, 0);
+	if (!ha->s_dma_pool)
+		goto fail_free_nvram;
+
 	/* Allocate memory for SNS commands */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		/* Get consistent memory allocated for SNS commands */
+	/* Get consistent memory allocated for SNS commands */
 		ha->sns_cmd = dma_alloc_coherent(&ha->pdev->dev,
-		    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
+		sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
 		if (!ha->sns_cmd)
-			goto fail_free_nvram;
+			goto fail_dma_pool;
 	} else {
-		/* Get consistent memory allocated for MS IOCB */
+	/* Get consistent memory allocated for MS IOCB */
 		ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
-		    &ha->ms_iocb_dma);
+			&ha->ms_iocb_dma);
 		if (!ha->ms_iocb)
-			goto fail_free_nvram;
-
-		/* Get consistent memory allocated for CT SNS commands */
+			goto fail_dma_pool;
+	/* Get consistent memory allocated for CT SNS commands */
 		ha->ct_sns = dma_alloc_coherent(&ha->pdev->dev,
-		    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
+			sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
 		if (!ha->ct_sns)
 			goto fail_free_ms_iocb;
 	}
 
+	INIT_LIST_HEAD(&ha->vp_list);
 	return 0;
 
 fail_free_ms_iocb:
 	dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
+fail_dma_pool:
+	dma_pool_destroy(ha->s_dma_pool);
+	ha->s_dma_pool = NULL;
 fail_free_nvram:
 	kfree(ha->nvram);
 	ha->nvram = NULL;
 fail_free_srb_mempool:
 	mempool_destroy(ha->srb_mempool);
 	ha->srb_mempool = NULL;
-fail_free_s_dma_pool:
-	dma_pool_destroy(ha->s_dma_pool);
-	ha->s_dma_pool = NULL;
-fail_free_init_cb:
-	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
-	    ha->init_cb_dma);
-	ha->init_cb = NULL;
-	ha->init_cb_dma = 0;
 fail_free_gid_list:
 	dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
-	    ha->gid_list_dma);
+	ha->gid_list_dma);
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
-fail_free_response_ring:
-	dma_free_coherent(&ha->pdev->dev, (ha->response_q_length + 1) *
-	    sizeof(response_t), ha->response_ring, ha->response_dma);
-	ha->response_ring = NULL;
-	ha->response_dma = 0;
-fail_free_request_ring:
-	dma_free_coherent(&ha->pdev->dev, (ha->request_q_length + 1) *
-	    sizeof(request_t), ha->request_ring, ha->request_dma);
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
+fail_free_init_cb:
+	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
+	ha->init_cb_dma);
+	ha->init_cb = NULL;
+	ha->init_cb_dma = 0;
 fail:
+	DEBUG(printk("%s: Memory allocation failure\n", __func__));
 	return -ENOMEM;
 }
 
@@ -2070,32 +2182,30 @@ fail:
 *      ha = adapter block pointer.
 */
 static void
-qla2x00_mem_free(scsi_qla_host_t *ha)
+qla2x00_mem_free(struct qla_hw_data *ha)
 {
-	struct list_head	*fcpl, *fcptemp;
-	fc_port_t	*fcport;
 
 	if (ha->srb_mempool)
 		mempool_destroy(ha->srb_mempool);
 
 	if (ha->fce)
 		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
-		    ha->fce_dma);
+		ha->fce_dma);
 
 	if (ha->fw_dump) {
 		if (ha->eft)
 			dma_free_coherent(&ha->pdev->dev,
-			    ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
+			ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
 		vfree(ha->fw_dump);
 	}
 
 	if (ha->sns_cmd)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
-		    ha->sns_cmd, ha->sns_cmd_dma);
+		ha->sns_cmd, ha->sns_cmd_dma);
 
 	if (ha->ct_sns)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
-		    ha->ct_sns, ha->ct_sns_dma);
+		ha->ct_sns, ha->ct_sns_dma);
 
 	if (ha->sfp_data)
 		dma_pool_free(ha->s_dma_pool, ha->sfp_data, ha->sfp_data_dma);
@@ -2106,23 +2216,17 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
 
-	if (ha->init_cb)
-		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
-		    ha->init_cb, ha->init_cb_dma);
 
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
-		    ha->gid_list_dma);
+		ha->gid_list_dma);
 
-	if (ha->response_ring)
-		dma_free_coherent(&ha->pdev->dev,
-		    (ha->response_q_length + 1) * sizeof(response_t),
-		    ha->response_ring, ha->response_dma);
 
-	if (ha->request_ring)
-		dma_free_coherent(&ha->pdev->dev,
-		    (ha->request_q_length + 1) * sizeof(request_t),
-		    ha->request_ring, ha->request_dma);
+	if (ha->init_cb)
+		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
+		ha->init_cb, ha->init_cb_dma);
+	vfree(ha->optrom_buffer);
+	kfree(ha->nvram);
 
 	ha->srb_mempool = NULL;
 	ha->eft = NULL;
@@ -2141,30 +2245,45 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
 
-	ha->response_ring = NULL;
-	ha->response_dma = 0;
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
+	ha->fw_dump = NULL;
+	ha->fw_dumped = 0;
+	ha->fw_dump_reading = 0;
+}
 
-	list_for_each_safe(fcpl, fcptemp, &ha->fcports) {
-		fcport = list_entry(fcpl, fc_port_t, list);
+struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
+						struct qla_hw_data *ha)
+{
+	struct Scsi_Host *host;
+	struct scsi_qla_host *vha = NULL;
 
-		/* fc ports */
-		list_del_init(&fcport->list);
-		kfree(fcport);
+	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
+	if (host == NULL) {
+		printk(KERN_WARNING
+		"qla2xxx: Couldn't allocate host from scsi layer!\n");
+		goto fail;
 	}
-	INIT_LIST_HEAD(&ha->fcports);
 
-	ha->fw_dump = NULL;
-	ha->fw_dumped = 0;
-	ha->fw_dump_reading = 0;
+	/* Clear our data area */
+	vha = shost_priv(host);
+	memset(vha, 0, sizeof(scsi_qla_host_t));
 
-	vfree(ha->optrom_buffer);
-	kfree(ha->nvram);
+	vha->host = host;
+	vha->host_no = host->host_no;
+	vha->hw = ha;
+
+	INIT_LIST_HEAD(&vha->vp_fcports);
+	INIT_LIST_HEAD(&vha->work_list);
+	INIT_LIST_HEAD(&vha->list);
+
+	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
+	return vha;
+
+fail:
+	return vha;
 }
 
 static struct qla_work_evt *
-qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
+qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type,
     int locked)
 {
 	struct qla_work_evt *e;
@@ -2181,42 +2300,42 @@ qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
 }
 
 static int
-qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
+qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e, int locked)
 {
 	unsigned long uninitialized_var(flags);
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!locked)
-		spin_lock_irqsave(&pha->hardware_lock, flags);
-	list_add_tail(&e->list, &ha->work_list);
-	qla2xxx_wake_dpc(ha);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+	list_add_tail(&e->list, &vha->work_list);
+	qla2xxx_wake_dpc(vha);
 	if (!locked)
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
 }
 
 int
-qla2x00_post_aen_work(struct scsi_qla_host *ha, enum fc_host_event_code code,
+qla2x00_post_aen_work(struct scsi_qla_host *vha, enum fc_host_event_code code,
     u32 data)
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(ha, QLA_EVT_AEN, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_AEN, 1);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.aen.code = code;
 	e->u.aen.data = data;
-	return qla2x00_post_work(ha, e, 1);
+	return qla2x00_post_work(vha, e, 1);
 }
 
 int
-qla2x00_post_hwe_work(struct scsi_qla_host *ha, uint16_t code, uint16_t d1,
+qla2x00_post_hwe_work(struct scsi_qla_host *vha, uint16_t code, uint16_t d1,
     uint16_t d2, uint16_t d3)
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(ha, QLA_EVT_HWE_LOG, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_HWE_LOG, 1);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
@@ -2224,36 +2343,95 @@ qla2x00_post_hwe_work(struct scsi_qla_host *ha, uint16_t code, uint16_t d1,
 	e->u.hwe.d1 = d1;
 	e->u.hwe.d2 = d2;
 	e->u.hwe.d3 = d3;
-	return qla2x00_post_work(ha, e, 1);
+	return qla2x00_post_work(vha, e, 1);
 }
 
 static void
-qla2x00_do_work(struct scsi_qla_host *ha)
+qla2x00_do_work(struct scsi_qla_host *vha)
 {
 	struct qla_work_evt *e;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
-	spin_lock_irq(&pha->hardware_lock);
-	while (!list_empty(&ha->work_list)) {
-		e = list_entry(ha->work_list.next, struct qla_work_evt, list);
+	spin_lock_irq(&ha->hardware_lock);
+	while (!list_empty(&vha->work_list)) {
+		e = list_entry(vha->work_list.next, struct qla_work_evt, list);
 		list_del_init(&e->list);
-		spin_unlock_irq(&pha->hardware_lock);
+		spin_unlock_irq(&ha->hardware_lock);
 
 		switch (e->type) {
 		case QLA_EVT_AEN:
-			fc_host_post_event(ha->host, fc_get_event_number(),
+			fc_host_post_event(vha->host, fc_get_event_number(),
 			    e->u.aen.code, e->u.aen.data);
 			break;
 		case QLA_EVT_HWE_LOG:
-			qla2xxx_hw_event_log(ha, e->u.hwe.code, e->u.hwe.d1,
+			qla2xxx_hw_event_log(vha, e->u.hwe.code, e->u.hwe.d1,
 			    e->u.hwe.d2, e->u.hwe.d3);
 			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-		spin_lock_irq(&pha->hardware_lock);
+		spin_lock_irq(&ha->hardware_lock);
+	}
+	spin_unlock_irq(&ha->hardware_lock);
+}
+/* Relogins all the fcports of a vport
+ * Context: dpc thread
+ */
+void qla2x00_relogin(struct scsi_qla_host *vha)
+{
+	fc_port_t       *fcport;
+	uint8_t         status;
+	uint16_t        next_loopid = 0;
+	struct qla_hw_data *ha = vha->hw;
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+	/*
+	 * If the port is not ONLINE then try to login
+	 * to it if we haven't run out of retries.
+	 */
+		if (atomic_read(&fcport->state) !=
+			FCS_ONLINE && fcport->login_retry) {
+
+			if (fcport->flags & FCF_FABRIC_DEVICE) {
+				if (fcport->flags & FCF_TAPE_PRESENT)
+					ha->isp_ops->fabric_logout(vha,
+							fcport->loop_id,
+							fcport->d_id.b.domain,
+							fcport->d_id.b.area,
+							fcport->d_id.b.al_pa);
+
+				status = qla2x00_fabric_login(vha, fcport,
+							&next_loopid);
+			} else
+				status = qla2x00_local_device_login(vha,
+								fcport);
+
+			fcport->login_retry--;
+			if (status == QLA_SUCCESS) {
+				fcport->old_loop_id = fcport->loop_id;
+
+				DEBUG(printk("scsi(%ld): port login OK: logged "
+				"in ID 0x%x\n", vha->host_no, fcport->loop_id));
+
+				qla2x00_update_fcport(vha, fcport);
+
+			} else if (status == 1) {
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				/* retry the login again */
+				DEBUG(printk("scsi(%ld): Retrying"
+				" %d login again loop_id 0x%x\n",
+				vha->host_no, fcport->login_retry,
+						fcport->loop_id));
+			} else {
+				fcport->login_retry = 0;
+			}
+
+			if (fcport->login_retry == 0 && status != QLA_SUCCESS)
+				fcport->loop_id = FC_NO_LOOP_ID;
+		}
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+			break;
 	}
-	spin_unlock_irq(&pha->hardware_lock);
 }
 
 /**************************************************************************
@@ -2273,15 +2451,11 @@ static int
 qla2x00_do_dpc(void *data)
 {
 	int		rval;
-	scsi_qla_host_t *ha;
-	fc_port_t	*fcport;
-	uint8_t		status;
-	uint16_t	next_loopid;
-	struct scsi_qla_host *vha;
-	int             i;
-
+	scsi_qla_host_t *base_vha;
+	struct qla_hw_data *ha;
 
-	ha = (scsi_qla_host_t *)data;
+	ha = (struct qla_hw_data *)data;
+	base_vha = pci_get_drvdata(ha->pdev);
 
 	set_user_nice(current, -20);
 
@@ -2295,10 +2469,10 @@ qla2x00_do_dpc(void *data)
 		DEBUG3(printk("qla2x00: DPC handler waking up\n"));
 
 		/* Initialization not yet finished. Don't do anything yet. */
-		if (!ha->flags.init_done)
+		if (!base_vha->flags.init_done)
 			continue;
 
-		DEBUG3(printk("scsi(%ld): DPC handler\n", ha->host_no));
+		DEBUG3(printk("scsi(%ld): DPC handler\n", base_vha->host_no));
 
 		ha->dpc_active = 1;
 
@@ -2307,149 +2481,98 @@ qla2x00_do_dpc(void *data)
 			continue;
 		}
 
-		qla2x00_do_work(ha);
+		qla2x00_do_work(base_vha);
 
-		if (test_and_clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
+		if (test_and_clear_bit(ISP_ABORT_NEEDED,
+						&base_vha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): dpc: sched "
 			    "qla2x00_abort_isp ha = %p\n",
-			    ha->host_no, ha));
+			    base_vha->host_no, ha));
 			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
-			    &ha->dpc_flags))) {
+			    &base_vha->dpc_flags))) {
 
-				if (qla2x00_abort_isp(ha)) {
+				if (qla2x00_abort_isp(base_vha)) {
 					/* failed. retry later */
 					set_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags);
-				}
-				clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-			}
-
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if (i == vha->vp_idx) {
-						set_bit(ISP_ABORT_NEEDED,
-						    &vha->dpc_flags);
-						break;
-					}
+					    &base_vha->dpc_flags);
 				}
+				clear_bit(ABORT_ISP_ACTIVE,
+						&base_vha->dpc_flags);
 			}
 
 			DEBUG(printk("scsi(%ld): dpc: qla2x00_abort_isp end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags)) {
-			qla2x00_update_fcports(ha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
+		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+			qla2x00_update_fcports(base_vha);
+			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
-		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
-		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
+		if (test_and_clear_bit(RESET_MARKER_NEEDED,
+							&base_vha->dpc_flags) &&
+		    (!(test_and_set_bit(RESET_ACTIVE, &base_vha->dpc_flags)))) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_reset_marker()\n",
-			    ha->host_no));
+			    base_vha->host_no));
 
-			qla2x00_rst_aen(ha);
-			clear_bit(RESET_ACTIVE, &ha->dpc_flags);
+			qla2x00_rst_aen(base_vha);
+			clear_bit(RESET_ACTIVE, &base_vha->dpc_flags);
 		}
 
 		/* Retry each device up to login retry count */
-		if ((test_and_clear_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
-		    !test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) &&
-		    atomic_read(&ha->loop_state) != LOOP_DOWN) {
+		if ((test_and_clear_bit(RELOGIN_NEEDED,
+						&base_vha->dpc_flags)) &&
+		    !test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags) &&
+		    atomic_read(&base_vha->loop_state) != LOOP_DOWN) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
-			    ha->host_no));
-
-			next_loopid = 0;
-			list_for_each_entry(fcport, &ha->fcports, list) {
-				/*
-				 * If the port is not ONLINE then try to login
-				 * to it if we haven't run out of retries.
-				 */
-				if (atomic_read(&fcport->state) != FCS_ONLINE &&
-				    fcport->login_retry) {
-
-					if (fcport->flags & FCF_FABRIC_DEVICE) {
-						if (fcport->flags &
-						    FCF_TAPE_PRESENT)
-							ha->isp_ops->fabric_logout(
-							    ha, fcport->loop_id,
-							    fcport->d_id.b.domain,
-							    fcport->d_id.b.area,
-							    fcport->d_id.b.al_pa);
-						status = qla2x00_fabric_login(
-						    ha, fcport, &next_loopid);
-					} else
-						status =
-						    qla2x00_local_device_login(
-							ha, fcport);
-
-					fcport->login_retry--;
-					if (status == QLA_SUCCESS) {
-						fcport->old_loop_id = fcport->loop_id;
-
-						DEBUG(printk("scsi(%ld): port login OK: logged in ID 0x%x\n",
-						    ha->host_no, fcport->loop_id));
-
-						qla2x00_update_fcport(ha,
-						    fcport);
-					} else if (status == 1) {
-						set_bit(RELOGIN_NEEDED, &ha->dpc_flags);
-						/* retry the login again */
-						DEBUG(printk("scsi(%ld): Retrying %d login again loop_id 0x%x\n",
-						    ha->host_no,
-						    fcport->login_retry, fcport->loop_id));
-					} else {
-						fcport->login_retry = 0;
-					}
-					if (fcport->login_retry == 0 && status != QLA_SUCCESS)
-						fcport->loop_id = FC_NO_LOOP_ID;
-				}
-				if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
-					break;
-			}
+					base_vha->host_no));
+			qla2x00_relogin(base_vha);
+
 			DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+							&base_vha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_loop_resync()\n",
-			    ha->host_no));
+				base_vha->host_no));
 
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
-			    &ha->dpc_flags))) {
+			    &base_vha->dpc_flags))) {
 
-				rval = qla2x00_loop_resync(ha);
+				rval = qla2x00_loop_resync(base_vha);
 
-				clear_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags);
+				clear_bit(LOOP_RESYNC_ACTIVE,
+						&base_vha->dpc_flags);
 			}
 
 			DEBUG(printk("scsi(%ld): qla2x00_loop_resync - end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags) &&
-		    atomic_read(&ha->loop_state) == LOOP_READY) {
-			clear_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
-			qla2xxx_flash_npiv_conf(ha);
+		if (test_bit(NPIV_CONFIG_NEEDED, &base_vha->dpc_flags) &&
+		    atomic_read(&base_vha->loop_state) == LOOP_READY) {
+			clear_bit(NPIV_CONFIG_NEEDED, &base_vha->dpc_flags);
+			qla2xxx_flash_npiv_conf(base_vha);
 		}
 
 		if (!ha->interrupts_on)
 			ha->isp_ops->enable_intrs(ha);
 
-		if (test_and_clear_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags))
-			ha->isp_ops->beacon_blink(ha);
+		if (test_and_clear_bit(BEACON_BLINK_NEEDED,
+					&base_vha->dpc_flags))
+			ha->isp_ops->beacon_blink(base_vha);
 
-		qla2x00_do_dpc_all_vps(ha);
+		qla2x00_do_dpc_all_vps(base_vha);
 
 		ha->dpc_active = 0;
 	} /* End of while(1) */
 
-	DEBUG(printk("scsi(%ld): DPC handler exiting\n", ha->host_no));
+	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
 
 	/*
 	 * Make sure that nobody tries to wake us up again.
@@ -2460,11 +2583,12 @@ qla2x00_do_dpc(void *data)
 }
 
 void
-qla2xxx_wake_dpc(scsi_qla_host_t *ha)
+qla2xxx_wake_dpc(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct task_struct *t = ha->dpc_thread;
 
-	if (!test_bit(UNLOADING, &ha->dpc_flags) && t)
+	if (!test_bit(UNLOADING, &vha->dpc_flags) && t)
 		wake_up_process(t);
 }
 
@@ -2476,26 +2600,26 @@ qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 *      ha  = adapter block pointer.
 */
 static void
-qla2x00_rst_aen(scsi_qla_host_t *ha)
+qla2x00_rst_aen(scsi_qla_host_t *vha)
 {
-	if (ha->flags.online && !ha->flags.reset_active &&
-	    !atomic_read(&ha->loop_down_timer) &&
-	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
+	if (vha->flags.online && !vha->flags.reset_active &&
+	    !atomic_read(&vha->loop_down_timer) &&
+	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))) {
 		do {
-			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
 			/*
 			 * Issue marker command only when we are going to start
 			 * the I/O.
 			 */
-			ha->marker_needed = 1;
-		} while (!atomic_read(&ha->loop_down_timer) &&
-		    (test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags)));
+			vha->marker_needed = 1;
+		} while (!atomic_read(&vha->loop_down_timer) &&
+		    (test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags)));
 	}
 }
 
 static void
-qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_sp_free_dma(srb_t *sp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
 
@@ -2507,11 +2631,12 @@ qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
 }
 
 void
-qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_sp_compl(scsi_qla_host_t *vha, srb_t *sp)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct scsi_cmnd *cmd = sp->cmd;
 
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 
 	mempool_free(sp, ha->srb_mempool);
 
@@ -2527,7 +2652,7 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
 * Context: Interrupt
 ***************************************************************************/
 void
-qla2x00_timer(scsi_qla_host_t *ha)
+qla2x00_timer(scsi_qla_host_t *vha)
 {
 	unsigned long	cpu_flags = 0;
 	fc_port_t	*fcport;
@@ -2535,8 +2660,8 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	int		index;
 	srb_t		*sp;
 	int		t;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
-
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 	/*
 	 * Ports - Port down timer.
 	 *
@@ -2545,7 +2670,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	 * the port it marked DEAD.
 	 */
 	t = 0;
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->port_type != FCT_TARGET)
 			continue;
 
@@ -2559,7 +2684,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 
 			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
 			    "%d remaining\n",
-			    ha->host_no,
+			    vha->host_no,
 			    t, atomic_read(&fcport->port_down_timer)));
 		}
 		t++;
@@ -2567,22 +2692,23 @@ qla2x00_timer(scsi_qla_host_t *ha)
 
 
 	/* Loop down handler. */
-	if (atomic_read(&ha->loop_down_timer) > 0 &&
-	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)) && ha->flags.online) {
+	if (atomic_read(&vha->loop_down_timer) > 0 &&
+	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		&& vha->flags.online) {
 
-		if (atomic_read(&ha->loop_down_timer) ==
-		    ha->loop_down_abort_time) {
+		if (atomic_read(&vha->loop_down_timer) ==
+		    vha->loop_down_abort_time) {
 
 			DEBUG(printk("scsi(%ld): Loop Down - aborting the "
 			    "queues before time expire\n",
-			    ha->host_no));
+			    vha->host_no));
 
-			if (!IS_QLA2100(ha) && ha->link_down_timeout)
-				atomic_set(&ha->loop_state, LOOP_DEAD);
+			if (!IS_QLA2100(ha) && vha->link_down_timeout)
+				atomic_set(&vha->loop_state, LOOP_DEAD);
 
 			/* Schedule an ISP abort to return any tape commands. */
 			/* NPIV - scan physical port only */
-			if (!ha->parent) {
+			if (!vha->vp_idx) {
 				spin_lock_irqsave(&ha->hardware_lock,
 				    cpu_flags);
 				for (index = 1;
@@ -2590,7 +2716,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				    index++) {
 					fc_port_t *sfcp;
 
-					sp = ha->outstanding_cmds[index];
+					sp = req->outstanding_cmds[index];
 					if (!sp)
 						continue;
 					sfcp = sp->fcport;
@@ -2598,63 +2724,63 @@ qla2x00_timer(scsi_qla_host_t *ha)
 						continue;
 
 					set_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags);
+							&vha->dpc_flags);
 					break;
 				}
 				spin_unlock_irqrestore(&ha->hardware_lock,
-				    cpu_flags);
+								cpu_flags);
 			}
-			set_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags);
+			set_bit(ABORT_QUEUES_NEEDED, &vha->dpc_flags);
 			start_dpc++;
 		}
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
-		if (atomic_dec_and_test(&ha->loop_down_timer) != 0) {
+		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
 			DEBUG(printk("scsi(%ld): Loop down exceed 4 mins - "
 			    "restarting queues.\n",
-			    ha->host_no));
+			    vha->host_no));
 
-			set_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags);
+			set_bit(RESTART_QUEUES_NEEDED, &vha->dpc_flags);
 			start_dpc++;
 
-			if (!(ha->device_flags & DFLG_NO_CABLE) &&
-			    !ha->parent) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) &&
+			    !vha->vp_idx) {
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
-				    ha->host_no));
+				    vha->host_no));
 				qla_printk(KERN_WARNING, ha,
 				    "Loop down - aborting ISP.\n");
 
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			}
 		}
 		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
-		    ha->host_no,
-		    atomic_read(&ha->loop_down_timer)));
+		    vha->host_no,
+		    atomic_read(&vha->loop_down_timer)));
 	}
 
 	/* Check if beacon LED needs to be blinked */
 	if (ha->beacon_blink_led == 1) {
-		set_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags);
+		set_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}
 
 	/* Process any deferred work. */
-	if (!list_empty(&ha->work_list))
+	if (!list_empty(&vha->work_list))
 		start_dpc++;
 
 	/* Schedule the DPC routine if needed */
-	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
-	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
-	    test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags) ||
+	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
+	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags) ||
 	    start_dpc ||
-	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
-	    test_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags) ||
-	    test_bit(VP_DPC_NEEDED, &ha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)))
-		qla2xxx_wake_dpc(pha);
+	    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) ||
+	    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags) ||
+	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
+	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags)))
+		qla2xxx_wake_dpc(vha);
 
-	qla2x00_restart_timer(ha, WATCH_INTERVAL);
+	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
 
 /* Firmware interface routines. */
@@ -2686,8 +2812,9 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 };
 
 struct fw_blob *
-qla2x00_request_firmware(scsi_qla_host_t *ha)
+qla2x00_request_firmware(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct fw_blob *blob;
 
 	blob = NULL;
@@ -2711,7 +2838,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 
 	if (request_firmware(&blob->fw, blob->name, &ha->pdev->dev)) {
 		DEBUG2(printk("scsi(%ld): Failed to load firmware image "
-		    "(%s).\n", ha->host_no, blob->name));
+		    "(%s).\n", vha->host_no, blob->name));
 		blob->fw = NULL;
 		blob = NULL;
 		goto out;
@@ -2756,7 +2883,8 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	int risc_paused = 0;
 	uint32_t stat;
 	unsigned long flags;
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 
@@ -2779,7 +2907,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	if (risc_paused) {
 		qla_printk(KERN_INFO, ha, "RISC paused -- mmio_enabled, "
 		    "Dumping firmware!\n");
-		ha->isp_ops->fw_dump(ha, 0);
+		ha->isp_ops->fw_dump(base_vha, 0);
 
 		return PCI_ERS_RESULT_NEED_RESET;
 	} else
@@ -2790,7 +2918,8 @@ static pci_ers_result_t
 qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 {
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	int rc;
 
 	if (ha->mem_only)
@@ -2806,13 +2935,13 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	}
 	pci_set_master(pdev);
 
-	if (ha->isp_ops->pci_config(ha))
+	if (ha->isp_ops->pci_config(base_vha))
 		return ret;
 
-	set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-	if (qla2x00_abort_isp(ha)== QLA_SUCCESS)
+	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
-	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
 	return ret;
 }
@@ -2820,10 +2949,11 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 static void
 qla2xxx_pci_resume(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
-	ret = qla2x00_wait_for_hba_online(ha);
+	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
 		    "the device failed to resume I/O "
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index be5e299..54b1100 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k8"
+#define QLA2XXX_VERSION      "8.02.02-k1"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	1
+#define QLA_DRIVER_PATCH_VER	2
 #define QLA_DRIVER_BETA_VER	0
