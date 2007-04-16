From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 12:59:20 -0700 (PDT)
Message-ID: <20070416.125920.85688160.davem@davemloft.net>
References: <20070416.010218.130850966.davem@davemloft.net>
	<20070416163712.GA10822@andrew-vasquezs-computer.local>
	<20070416.123743.07452378.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030926AbXDPT7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2007 15:59:18 -0400
In-Reply-To: <20070416.123743.07452378.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: David Miller <davem@davemloft.net>
Date: Mon, 16 Apr 2007 12:37:43 -0700 (PDT)

> Now I'm happy to code up the sparc OFW property bits but your attitude
> and perspective on this absolutely has to change and the old fallback
> code still has to go back in there, possible FC ID collisions or not.

Here is the patch I think we should definitely apply to the
driver to fix this bug and restore the fallback functionality.

Tested on SunBlade-1000:

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 98c01cd..3e296ab 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -11,6 +11,11 @@
 
 #include "qla_devtbl.h"
 
+#ifdef CONFIG_SPARC
+#include <asm/prom.h>
+#include <asm/pbm.h>
+#endif
+
 /* XXX(hch): this is ugly, but we don't want to pull in exioctl.h */
 #ifndef EXT_IS_LUN_BIT_SET
 #define EXT_IS_LUN_BIT_SET(P,L) \
@@ -88,12 +93,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 
-	rval = ha->isp_ops.nvram_config(ha);
-	if (rval) {
-		DEBUG2(printk("scsi(%ld): Unable to verify NVRAM data.\n",
-		    ha->host_no));
-		return rval;
-	}
+	ha->isp_ops.nvram_config(ha);
 
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
@@ -1393,6 +1393,28 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 	}
 }
 
+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, nvram_t *nv)
+{
+#ifdef CONFIG_SPARC
+	struct pci_dev *pdev = ha->pdev;
+	struct pcidev_cookie *pcp = pdev->sysdata;
+	struct device_node *dp = pcp->prom_node;
+	u8 *val;
+	int len;
+
+	val = of_get_property(dp, "port-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->port_name, val, WWN_SIZE);
+
+	val = of_get_property(dp, "node-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
 /*
 * NVRAM configuration for ISP 2xxx
 *
@@ -1409,6 +1431,7 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 int
 qla2x00_nvram_config(scsi_qla_host_t *ha)
 {
+	int             rval;
 	uint8_t         chksum = 0;
 	uint16_t        cnt;
 	uint8_t         *dptr1, *dptr2;
@@ -1417,6 +1440,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	uint8_t         *ptr = (uint8_t *)ha->request_ring;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
+	rval = QLA_SUCCESS;
+
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(nvram_t);
 	ha->nvram_base = 0;
@@ -1440,7 +1465,57 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    nv->nvram_version);
-		return QLA_FUNCTION_FAILED;
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->parameter_block_version = ICB_VERSION;
+
+		if (IS_QLA23XX(ha)) {
+			nv->firmware_options[0] = BIT_2 | BIT_1;
+			nv->firmware_options[1] = BIT_7 | BIT_5;
+			nv->add_firmware_options[0] = BIT_5;
+			nv->add_firmware_options[1] = BIT_5 | BIT_4;
+			nv->frame_payload_size = __constant_cpu_to_le16(2048);
+			nv->special_options[1] = BIT_7;
+		} else if (IS_QLA2200(ha)) {
+			nv->firmware_options[0] = BIT_2 | BIT_1;
+			nv->firmware_options[1] = BIT_7 | BIT_5;
+			nv->add_firmware_options[0] = BIT_5;
+			nv->add_firmware_options[1] = BIT_5 | BIT_4;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+		} else if (IS_QLA2100(ha)) {
+			nv->firmware_options[0] = BIT_3 | BIT_1;
+			nv->firmware_options[1] = BIT_5;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+		}
+
+		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
+		nv->execution_throttle = __constant_cpu_to_le16(16);
+		nv->retry_count = 8;
+		nv->retry_delay = 1;
+
+		nv->port_name[0] = 33;
+		nv->port_name[3] = 224;
+		nv->port_name[4] = 139;
+
+		qla2xxx_nvram_wwn_from_ofw(ha, nv);
+
+		nv->login_timeout = 4;
+
+		/*
+		 * Set default host adapter parameters
+		 */
+		nv->host_p[1] = BIT_2;
+		nv->reset_delay = 5;
+		nv->port_down_retry_count = 8;
+		nv->max_luns_per_target = __constant_cpu_to_le16(8);
+		nv->link_down_timeout = 60;
+
+		rval = 1;
 	}
 
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
@@ -1653,7 +1728,11 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		}
 	}
 
-	return QLA_SUCCESS;
+	if (rval) {
+		DEBUG2_3(printk(KERN_WARNING
+		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
+	}
+	return (rval);
 }
 
 static void
@@ -3071,9 +3150,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 		ha->isp_ops.get_flash_version(ha, ha->request_ring);
 
-		rval = ha->isp_ops.nvram_config(ha);
-		if (rval)
-			goto isp_abort_retry;
+		ha->isp_ops.nvram_config(ha);
 
 		if (!qla2x00_restart_isp(ha)) {
 			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
@@ -3103,7 +3180,6 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				}
 			}
 		} else {	/* failed the ISP abort */
-isp_abort_retry:
 			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
 				if (ha->isp_abort_cnt == 0) {
@@ -3290,9 +3366,32 @@ qla24xx_reset_adapter(scsi_qla_host_t *ha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, struct nvram_24xx *nv)
+{
+#ifdef CONFIG_SPARC
+	struct pci_dev *pdev = ha->pdev;
+	struct pcidev_cookie *pcp = pdev->sysdata;
+	struct device_node *dp = pcp->prom_node;
+	u8 *val;
+	int len;
+
+	val = of_get_property(dp, "port-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->port_name, val, WWN_SIZE);
+
+	val = of_get_property(dp, "node-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
 int
 qla24xx_nvram_config(scsi_qla_host_t *ha)
 {
+	int   rval;
 	struct init_cb_24xx *icb;
 	struct nvram_24xx *nv;
 	uint32_t *dptr;
@@ -3300,6 +3399,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	uint32_t chksum;
 	uint16_t cnt;
 
+	rval = QLA_SUCCESS;
 	icb = (struct init_cb_24xx *)ha->init_cb;
 	nv = (struct nvram_24xx *)ha->request_ring;
 
@@ -3332,7 +3432,52 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
-		return QLA_FUNCTION_FAILED;
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->hard_address = __constant_cpu_to_le16(124);
+		nv->port_name[0] = 0x21;
+		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[2] = 0x00;
+		nv->port_name[3] = 0xe0;
+		nv->port_name[4] = 0x8b;
+		nv->port_name[5] = 0x1c;
+		nv->port_name[6] = 0x55;
+		nv->port_name[7] = 0x86;
+		nv->node_name[0] = 0x20;
+		nv->node_name[1] = 0x00;
+		nv->node_name[2] = 0x00;
+		nv->node_name[3] = 0xe0;
+		nv->node_name[4] = 0x8b;
+		nv->node_name[5] = 0x1c;
+		nv->node_name[6] = 0x55;
+		nv->node_name[7] = 0x86;
+		qla24xx_nvram_wwn_from_ofw(ha, nv);
+		nv->login_retry_count = __constant_cpu_to_le16(8);
+		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
+		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->firmware_options_1 =
+		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
+		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = __constant_cpu_to_le32(0);
+		nv->reset_delay = 5;
+		nv->max_luns_per_target = __constant_cpu_to_le16(128);
+		nv->port_down_retry_count = __constant_cpu_to_le16(30);
+		nv->link_down_timeout = __constant_cpu_to_le16(30);
+
+		rval = 1;
 	}
 
 	/* Reset Initialization control block */
@@ -3479,7 +3624,11 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		ha->flags.process_response_queue = 1;
 	}
 
-	return QLA_SUCCESS;
+	if (rval) {
+		DEBUG2_3(printk(KERN_WARNING
+		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
+	}
+	return (rval);
 }
 
 static int
