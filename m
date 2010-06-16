From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/11] qla4xxx: replace all dev_info, dev_warn, dev_err
	with ql4_printk
Date: Thu, 17 Jun 2010 02:27:21 +0530
Message-ID: <20100616205721.GA8196@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:34838
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751995Ab0FPU6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 16:58:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   50 +++++++++++++++---------------
 drivers/scsi/qla4xxx/ql4_isr.c  |    8 ++--
 drivers/scsi/qla4xxx/ql4_mbx.c  |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c   |   62 ++++++++++++++++++++-------------------
 4 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 4d1e108..cb3a51c 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -296,7 +296,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 	uint32_t timeout_count;
 	int ready = 0;
 
-	DEBUG2(dev_info(&ha->pdev->dev, "Waiting for Firmware Ready..\n"));
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Waiting for Firmware Ready..\n"));
 	for (timeout_count = ADAPTER_INIT_TOV; timeout_count > 0;
 	     timeout_count--) {
 		if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
@@ -369,29 +369,29 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 
 			if (!qla4xxx_wait_for_ip_config(ha) ||
 							timeout_count == 1) {
-				DEBUG2(dev_info(&ha->pdev->dev,
-						"Firmware Ready..\n"));
+				DEBUG2(ql4_printk(KERN_INFO, ha,
+				    "Firmware Ready..\n"));
 				/* The firmware is ready to process SCSI
 				   commands. */
-				DEBUG2(dev_info(&ha->pdev->dev,
+				DEBUG2(ql4_printk(KERN_INFO, ha,
 					"scsi%ld: %s: MEDIA TYPE"
 					" - %s\n", ha->host_no,
 					__func__, (ha->addl_fw_state &
 					FW_ADDSTATE_OPTICAL_MEDIA)
 					!= 0 ? "OPTICAL" : "COPPER"));
-				DEBUG2(dev_info(&ha->pdev->dev,
+				DEBUG2(ql4_printk(KERN_INFO, ha,
 					"scsi%ld: %s: DHCPv4 STATE"
 					" Enabled %s\n", ha->host_no,
 					 __func__, (ha->addl_fw_state &
 					 FW_ADDSTATE_DHCPv4_ENABLED) != 0 ?
 					"YES" : "NO"));
-				DEBUG2(dev_info(&ha->pdev->dev,
+				DEBUG2(ql4_printk(KERN_INFO, ha,
 					"scsi%ld: %s: LINK %s\n",
 					ha->host_no, __func__,
 					(ha->addl_fw_state &
 					 FW_ADDSTATE_LINK_UP) != 0 ?
 					"UP" : "DOWN"));
-				DEBUG2(dev_info(&ha->pdev->dev,
+				DEBUG2(ql4_printk(KERN_INFO, ha,
 					"scsi%ld: %s: iSNS Service "
 					"Started %s\n",
 					ha->host_no, __func__,
@@ -444,7 +444,7 @@ static int qla4xxx_init_firmware(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
 
-	dev_info(&ha->pdev->dev, "Initializing firmware..\n");
+	ql4_printk(KERN_INFO, ha, "Initializing firmware..\n");
 	if (qla4xxx_initialize_fw_cb(ha) == QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: Failed to initialize firmware "
 			      "control block\n", ha->host_no, __func__));
@@ -695,18 +695,18 @@ int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
 	err_code = ((conn_err & 0x00ff0000) >> 16);
 	login_rsp_sts_class = ((conn_err & 0x0000ff00) >> 8);
 	if (err_code == 0x1c || err_code == 0x06) {
-		DEBUG2(dev_info(&ha->pdev->dev,
-				": conn_err=0x%08x, send target completed"
-				" or access denied failure\n", conn_err));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+		    ": conn_err=0x%08x, send target completed"
+		    " or access denied failure\n", conn_err));
 		relogin = 0;
 	}
 	if ((err_code == 0x08) && (login_rsp_sts_class == 0x02)) {
 		/* Login Response PDU returned an error.
 		   Login Response Status in Error Code Detail
 		   indicates login should not be retried.*/
-		DEBUG2(dev_info(&ha->pdev->dev,
-				": conn_err=0x%08x, do not retry relogin\n",
-				conn_err));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+		    ": conn_err=0x%08x, do not retry relogin\n",
+		    conn_err));
 		relogin = 0;
 	}
 
@@ -737,13 +737,13 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 			&fw_ddb_entry_dma, GFP_KERNEL);
 	if (fw_ddb_entry == NULL) {
-		DEBUG2(dev_info(&ha->pdev->dev, "%s: DMA alloc failed\n",
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: DMA alloc failed\n",
 				__func__));
 
 		goto exit_build_ddb_list_no_free;
 	}
 
-	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
+	ql4_printk(KERN_INFO, ha, "Initializing DDBs ...\n");
 	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
 	     fw_ddb_index = next_fw_ddb_index) {
 		/* First, let's see if a device exists here */
@@ -827,7 +827,7 @@ next_one:
 	}
 
 	status = QLA_SUCCESS;
-	dev_info(&ha->pdev->dev, "DDB list done..\n");
+	ql4_printk(KERN_INFO, ha, "DDB list done..\n");
 
 exit_build_ddb_list:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
@@ -1081,17 +1081,17 @@ static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 	}
 
 	/* Get EEPRom Parameters from NVRAM and validate */
-	dev_info(&ha->pdev->dev, "Configuring NVRAM ...\n");
+	ql4_printk(KERN_INFO, ha, "Configuring NVRAM ...\n");
 	if (qla4xxx_is_nvram_configuration_valid(ha) == QLA_SUCCESS) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		extHwConfig.Asuint32_t =
 			rd_nvram_word(ha, eeprom_ext_hw_conf_offset(ha));
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	} else {
-		dev_warn(&ha->pdev->dev,
-			   "scsi%ld: %s: EEProm checksum invalid.  "
-			   "Please update your EEPROM\n", ha->host_no,
-			   __func__);
+		ql4_printk(KERN_WARNING, ha,
+		    "scsi%ld: %s: EEProm checksum invalid.  "
+		    "Please update your EEPROM\n", ha->host_no,
+		    __func__);
 
 		/* Attempt to set defaults */
 		if (is_qla4010(ha))
@@ -1129,7 +1129,7 @@ void qla4xxx_pci_config(struct scsi_qla_host *ha)
 	uint16_t w;
 	int status;
 
-	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
+	ql4_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 
 	pci_set_master(ha->pdev);
 	status = pci_set_mwi(ha->pdev);
@@ -1151,7 +1151,7 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 	unsigned long flags;
 	uint32_t mbox_status;
 
-	dev_info(&ha->pdev->dev, "Starting firmware ...\n");
+	ql4_printk(KERN_INFO, ha, "Starting firmware ...\n");
 
 	/*
 	 * Start firmware from flash ROM
@@ -1568,7 +1568,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	} else {
 		/* Device went away, mark device missing */
 		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE) {
-			DEBUG2(dev_info(&ha->pdev->dev, "%s mark missing "
+			DEBUG2(ql4_printk(KERN_INFO, ha, "%s mark missing "
 					"ddb_entry 0x%p sess 0x%p conn 0x%p\n",
 					__func__, ddb_entry,
 					ddb_entry->sess, ddb_entry->conn));
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6f80c13..3bc5724 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -122,8 +122,8 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      "handle 0x%x, sp=%p. This cmd may have already "
 			      "been completed.\n", ha->host_no, __func__,
 			      le32_to_cpu(sts_entry->handle), srb));
-		dev_warn(&ha->pdev->dev, "%s invalid status entry:"
-			" handle=0x%0x\n", __func__, sts_entry->handle);
+		ql4_printk(KERN_WARNING, ha, "%s invalid status entry:"
+		    " handle=0x%0x\n", __func__, sts_entry->handle);
 		set_bit(DPC_RESET_HA, &ha->dpc_flags);
 		return;
 	}
@@ -134,8 +134,8 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      "OS pkt->handle=%d srb=%p srb->state:%d\n",
 			      ha->host_no, __func__, sts_entry->handle,
 			      srb, srb->state));
-		dev_warn(&ha->pdev->dev, "Command is NULL:"
-			" already returned to OS (srb=%p)\n", srb);
+		ql4_printk(KERN_WARNING, ha, "Command is NULL:"
+		    " already returned to OS (srb=%p)\n", srb);
 		return;
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a951914..583b9b3 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -605,7 +605,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 	if (fw_ddb_entry) {
 		options = le16_to_cpu(fw_ddb_entry->options);
 		if (options & DDB_OPT_IPV6_DEVICE) {
-			dev_info(&ha->pdev->dev, "%s: DDB[%d] MB0 %04x Tot %d "
+			ql4_printk(KERN_INFO, ha, "%s: DDB[%d] MB0 %04x Tot %d "
 				"Next %d State %04x ConnErr %08x %pI6 "
 				":%04d \"%s\"\n", __func__, fw_ddb_index,
 				mbox_sts[0], mbox_sts[2], mbox_sts[3],
@@ -614,7 +614,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 				le16_to_cpu(fw_ddb_entry->port),
 				fw_ddb_entry->iscsi_name);
 		} else {
-			dev_info(&ha->pdev->dev, "%s: DDB[%d] MB0 %04x Tot %d "
+			ql4_printk(KERN_INFO, ha, "%s: DDB[%d] MB0 %04x Tot %d "
 				"Next %d State %04x ConnErr %08x %pI4 "
 				":%04d \"%s\"\n", __func__, fw_ddb_index,
 				mbox_sts[0], mbox_sts[2], mbox_sts[3],
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1e0f917..ff707a0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -588,8 +588,8 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
 					&ha->queues_dma, GFP_KERNEL);
 	if (ha->queues == NULL) {
-		dev_warn(&ha->pdev->dev,
-			"Memory Allocation failed - queues.\n");
+		ql4_printk(KERN_WARNING, ha,
+		    "Memory Allocation failed - queues.\n");
 
 		goto mem_alloc_error_exit;
 	}
@@ -625,8 +625,8 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
 					 mempool_free_slab, srb_cachep);
 	if (ha->srb_mempool == NULL) {
-		dev_warn(&ha->pdev->dev,
-			"Memory Allocation failed - SRB Pool.\n");
+		ql4_printk(KERN_WARNING, ha,
+		    "Memory Allocation failed - SRB Pool.\n");
 
 		goto mem_alloc_error_exit;
 	}
@@ -1301,7 +1301,7 @@ dpc_post_reset_ha:
 					    DDB_DS_SESSION_ACTIVE) {
 						atomic_set(&ddb_entry->state,
 							   DDB_STATE_ONLINE);
-						dev_info(&ha->pdev->dev,
+						ql4_printk(KERN_INFO, ha,
 						    "scsi%ld: %s: ddb[%d]"
 						    " marked ONLINE\n",
 						    ha->host_no, __func__,
@@ -1465,12 +1465,12 @@ int qla4xxx_iospace_config(struct scsi_qla_host *ha)
 	pio_flags = pci_resource_flags(ha->pdev, 0);
 	if (pio_flags & IORESOURCE_IO) {
 		if (pio_len < MIN_IOBASE_LEN) {
-			dev_warn(&ha->pdev->dev,
+			ql4_printk(KERN_WARNING, ha,
 				"Invalid PCI I/O region size\n");
 			pio = 0;
 		}
 	} else {
-		dev_warn(&ha->pdev->dev, "region #0 not a PIO resource\n");
+		ql4_printk(KERN_WARNING, ha, "region #0 not a PIO resource\n");
 		pio = 0;
 	}
 
@@ -1480,20 +1480,21 @@ int qla4xxx_iospace_config(struct scsi_qla_host *ha)
 	mmio_flags = pci_resource_flags(ha->pdev, 1);
 
 	if (!(mmio_flags & IORESOURCE_MEM)) {
-		dev_err(&ha->pdev->dev,
-			"region #0 not an MMIO resource, aborting\n");
+		ql4_printk(KERN_ERR, ha,
+		    "region #0 not an MMIO resource, aborting\n");
 
 		goto iospace_error_exit;
 	}
+
 	if (mmio_len < MIN_IOBASE_LEN) {
-		dev_err(&ha->pdev->dev,
-			"Invalid PCI mem region size, aborting\n");
+		ql4_printk(KERN_ERR, ha,
+		    "Invalid PCI mem region size, aborting\n");
 		goto iospace_error_exit;
 	}
 
 	if (pci_request_regions(ha->pdev, DRIVER_NAME)) {
-		dev_warn(&ha->pdev->dev,
-			"Failed to reserve PIO/MMIO regions\n");
+		ql4_printk(KERN_WARNING, ha,
+		    "Failed to reserve PIO/MMIO regions\n");
 
 		goto iospace_error_exit;
 	}
@@ -1502,8 +1503,8 @@ int qla4xxx_iospace_config(struct scsi_qla_host *ha)
 	ha->pio_length = pio_len;
 	ha->reg = ioremap(mmio, MIN_IOBASE_LEN);
 	if (!ha->reg) {
-		dev_err(&ha->pdev->dev,
-			"cannot remap MMIO, aborting\n");
+		ql4_printk(KERN_ERR, ha,
+		    "cannot remap MMIO, aborting\n");
 
 		goto iospace_error_exit;
 	}
@@ -1629,7 +1630,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (ret)
 		goto probe_failed_ioconfig;
 
-	dev_info(&ha->pdev->dev, "Found an ISP%04x, irq %d, iobase 0x%p\n",
+	ql4_printk(KERN_INFO, ha, "Found an ISP%04x, irq %d, iobase 0x%p\n",
 		   pdev->device, pdev->irq, ha->reg);
 
 	qla4xxx_config_dma_addressing(ha);
@@ -1645,8 +1646,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 
 	/* Allocate dma buffers */
 	if (qla4xxx_mem_alloc(ha)) {
-		dev_warn(&ha->pdev->dev,
-			   "[ERROR] Failed to allocate memory for adapter\n");
+		ql4_printk(KERN_WARNING, ha,
+		    "[ERROR] Failed to allocate memory for adapter\n");
 
 		ret = -ENOMEM;
 		goto probe_failed;
@@ -1673,7 +1674,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	}
 
 	if (!test_bit(AF_ONLINE, &ha->flags)) {
-		dev_warn(&ha->pdev->dev, "Failed to initialize adapter\n");
+		ql4_printk(KERN_WARNING, ha, "Failed to initialize adapter\n");
 
 		ret = -ENODEV;
 		goto probe_failed;
@@ -1689,8 +1690,9 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 
         ret = scsi_init_shared_tag_map(host, MAX_SRBS);
         if (ret) {
-                dev_warn(&ha->pdev->dev, "scsi_init_shared_tag_map failed\n");
-                goto probe_failed;
+		ql4_printk(KERN_WARNING, ha,
+		    "scsi_init_shared_tag_map failed\n");
+		goto probe_failed;
         }
 
 	/* Startup the kernel thread for this host adapter. */
@@ -1699,7 +1701,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	sprintf(buf, "qla4xxx_%lu_dpc", ha->host_no);
 	ha->dpc_thread = create_singlethread_workqueue(buf);
 	if (!ha->dpc_thread) {
-		dev_warn(&ha->pdev->dev, "Unable to start DPC thread!\n");
+		ql4_printk(KERN_WARNING, ha, "Unable to start DPC thread!\n");
 		ret = -ENODEV;
 		goto probe_failed;
 	}
@@ -1958,7 +1960,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	int ret = SUCCESS;
 	int wait = 0;
 
-	dev_info(&ha->pdev->dev,
+	ql4_printk(KERN_INFO, ha,
 	    "scsi%ld:%d:%d: Abort command issued cmd=%p, pid=%ld\n",
 	    ha->host_no, id, lun, cmd, serial);
 
@@ -1990,7 +1992,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	dev_info(&ha->pdev->dev,
+	ql4_printk(KERN_INFO, ha,
 	    "scsi%ld:%d:%d: Abort command - %s\n",
 	    ha->host_no, id, lun, (ret == SUCCESS) ? "succeded" : "failed");
 
@@ -2013,7 +2015,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	if (!ddb_entry)
 		return ret;
 
-	dev_info(&ha->pdev->dev,
+	ql4_printk(KERN_INFO, ha,
 		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
@@ -2026,13 +2028,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	/* FIXME: wait for hba to go online */
 	stat = qla4xxx_reset_lun(ha, ddb_entry, cmd->device->lun);
 	if (stat != QLA_SUCCESS) {
-		dev_info(&ha->pdev->dev, "DEVICE RESET FAILED. %d\n", stat);
+		ql4_printk(KERN_INFO, ha, "DEVICE RESET FAILED. %d\n", stat);
 		goto eh_dev_reset_done;
 	}
 
 	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
 					 cmd->device)) {
-		dev_info(&ha->pdev->dev,
+		ql4_printk(KERN_INFO, ha,
 			   "DEVICE RESET FAILED - waiting for "
 			   "commands.\n");
 		goto eh_dev_reset_done;
@@ -2043,7 +2045,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		MM_LUN_RESET) != QLA_SUCCESS)
 		goto eh_dev_reset_done;
 
-	dev_info(&ha->pdev->dev,
+	ql4_printk(KERN_INFO, ha,
 		   "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
 		   ha->host_no, cmd->device->channel, cmd->device->id,
 		   cmd->device->lun);
@@ -2128,7 +2130,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	dev_info(&ha->pdev->dev,
+	ql4_printk(KERN_INFO, ha,
 		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
@@ -2150,7 +2152,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	if (qla4xxx_recover_adapter(ha) == QLA_SUCCESS)
 		return_status = SUCCESS;
 
-	dev_info(&ha->pdev->dev, "HOST RESET %s.\n",
+	ql4_printk(KERN_INFO, ha, "HOST RESET %s.\n",
 		   return_status == FAILED ? "FAILED" : "SUCCEDED");
 
 	return return_status;
-- 
1.7.0.5

