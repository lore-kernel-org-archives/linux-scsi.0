From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 9/14] qla2xxx: Fail initialization when inconsistent NVRAM detected.
Date: Mon, 29 Jan 2007 10:22:26 -0800
Message-ID: <11700949513420-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXA2SWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:44 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  125 ++++----------------------------------
 1 files changed, 14 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f4c63ad..6c790dd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -88,7 +88,12 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
-	ha->isp_ops.nvram_config(ha);
+	rval = ha->isp_ops.nvram_config(ha);
+	if (rval) {
+		DEBUG2(printk("scsi(%ld): Unable to verify NVRAM data.\n",
+		    ha->host_no));
+		return rval;
+	}
 
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
@@ -1404,7 +1409,6 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 int
 qla2x00_nvram_config(scsi_qla_host_t *ha)
 {
-	int             rval;
 	uint8_t         chksum = 0;
 	uint16_t        cnt;
 	uint8_t         *dptr1, *dptr2;
@@ -1413,8 +1417,6 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	uint8_t         *ptr = (uint8_t *)ha->request_ring;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	rval = QLA_SUCCESS;
-
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(nvram_t);
 	ha->nvram_base = 0;
@@ -1438,55 +1440,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    nv->nvram_version);
-		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
-		    "invalid -- WWPN) defaults.\n");
-
-		/*
-		 * Set default initialization control block.
-		 */
-		memset(nv, 0, ha->nvram_size);
-		nv->parameter_block_version = ICB_VERSION;
-
-		if (IS_QLA23XX(ha)) {
-			nv->firmware_options[0] = BIT_2 | BIT_1;
-			nv->firmware_options[1] = BIT_7 | BIT_5;
-			nv->add_firmware_options[0] = BIT_5;
-			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(2048);
-			nv->special_options[1] = BIT_7;
-		} else if (IS_QLA2200(ha)) {
-			nv->firmware_options[0] = BIT_2 | BIT_1;
-			nv->firmware_options[1] = BIT_7 | BIT_5;
-			nv->add_firmware_options[0] = BIT_5;
-			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
-		} else if (IS_QLA2100(ha)) {
-			nv->firmware_options[0] = BIT_3 | BIT_1;
-			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
-		}
-
-		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
-		nv->execution_throttle = __constant_cpu_to_le16(16);
-		nv->retry_count = 8;
-		nv->retry_delay = 1;
-
-		nv->port_name[0] = 33;
-		nv->port_name[3] = 224;
-		nv->port_name[4] = 139;
-
-		nv->login_timeout = 4;
-
-		/*
-		 * Set default host adapter parameters
-		 */
-		nv->host_p[1] = BIT_2;
-		nv->reset_delay = 5;
-		nv->port_down_retry_count = 8;
-		nv->max_luns_per_target = __constant_cpu_to_le16(8);
-		nv->link_down_timeout = 60;
-
-		rval = 1;
+		return QLA_FUNCTION_FAILED;
 	}
 
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
@@ -1699,11 +1653,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		}
 	}
 
-	if (rval) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
-	}
-	return (rval);
+	return QLA_SUCCESS;
 }
 
 static void
@@ -3121,7 +3071,9 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 		ha->isp_ops.get_flash_version(ha, ha->request_ring);
 
-		ha->isp_ops.nvram_config(ha);
+		rval = ha->isp_ops.nvram_config(ha);
+		if (rval)
+			goto isp_abort_retry;
 
 		if (!qla2x00_restart_isp(ha)) {
 			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
@@ -3151,6 +3103,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				}
 			}
 		} else {	/* failed the ISP abort */
+isp_abort_retry:
 			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
 				if (ha->isp_abort_cnt == 0) {
@@ -3340,7 +3293,6 @@ qla24xx_reset_adapter(scsi_qla_host_t *ha)
 int
 qla24xx_nvram_config(scsi_qla_host_t *ha)
 {
-	int   rval;
 	struct init_cb_24xx *icb;
 	struct nvram_24xx *nv;
 	uint32_t *dptr;
@@ -3348,7 +3300,6 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	uint32_t chksum;
 	uint16_t cnt;
 
-	rval = QLA_SUCCESS;
 	icb = (struct init_cb_24xx *)ha->init_cb;
 	nv = (struct nvram_24xx *)ha->request_ring;
 
@@ -3381,51 +3332,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
-		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
-		    "invalid -- WWPN) defaults.\n");
-
-		/*
-		 * Set default initialization control block.
-		 */
-		memset(nv, 0, ha->nvram_size);
-		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
-		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
-		nv->exchange_count = __constant_cpu_to_le16(0);
-		nv->hard_address = __constant_cpu_to_le16(124);
-		nv->port_name[0] = 0x21;
-		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
-		nv->port_name[2] = 0x00;
-		nv->port_name[3] = 0xe0;
-		nv->port_name[4] = 0x8b;
-		nv->port_name[5] = 0x1c;
-		nv->port_name[6] = 0x55;
-		nv->port_name[7] = 0x86;
-		nv->node_name[0] = 0x20;
-		nv->node_name[1] = 0x00;
-		nv->node_name[2] = 0x00;
-		nv->node_name[3] = 0xe0;
-		nv->node_name[4] = 0x8b;
-		nv->node_name[5] = 0x1c;
-		nv->node_name[6] = 0x55;
-		nv->node_name[7] = 0x86;
-		nv->login_retry_count = __constant_cpu_to_le16(8);
-		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
-		nv->login_timeout = __constant_cpu_to_le16(0);
-		nv->firmware_options_1 =
-		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
-		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
-		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
-		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
-		nv->efi_parameters = __constant_cpu_to_le32(0);
-		nv->reset_delay = 5;
-		nv->max_luns_per_target = __constant_cpu_to_le16(128);
-		nv->port_down_retry_count = __constant_cpu_to_le16(30);
-		nv->link_down_timeout = __constant_cpu_to_le16(30);
-
-		rval = 1;
+		return QLA_FUNCTION_FAILED;
 	}
 
 	/* Reset Initialization control block */
@@ -3572,11 +3479,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		ha->flags.process_response_queue = 1;
 	}
 
-	if (rval) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
-	}
-	return (rval);
+	return QLA_SUCCESS;
 }
 
 static int
-- 
1.5.0.rc2.gdbaa0

