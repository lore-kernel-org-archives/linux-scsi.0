From: David Miller <davem@davemloft.net>
Subject: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 01:02:18 -0700 (PDT)
Message-ID: <20070416.010218.130850966.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56311
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S964834AbXDPICT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2007 04:02:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, James.Bottomley@SteelEye.com, ema@debian.org


Sparc64 systems which have an on-board qla2xxx chip (such as
SunBlade-1000 and SunBlade-2000, there are probably some other systems
like this too) do not have any NVRAM information present, in fact the
NVRAM is basically all 0's from what I can tell.

This always worked just fine since the code would previously just use
a bunch of defaults when an inconsistent NVRAM was detected.

But the changeset below at the end of this email broke this and now
I'm seeing bug reports from sparc64 users and I was just able to
reproduce the problem myself just today as well.  I verified that
reverting the patch below gets things working again.

Emanuele, you can feed the patch below to "patch -p1 -R" to get that
working again so we can move on to the other sparc64 bug we're looking
into :-)

The failure mode isn't nice, it actually ends up crashing with an OOPS
in qla2xxx_init_host_attr() because ha->node_name is NULL, it's
supposed to be initialized by functions like qla2x00_nvram_config()

Can we revert the patch below or do something similar to get things
working again on sparc64?

The most important thing which qla2x00_nvram_config() seems to want to
get is the WWN port_name and node_name.  These are provided in the OFW
device tree so we could pluck them out of there with something like:

#ifdef CONFIG_SPARC
#include <asm/prom.h>
#include <asm/pbm.h>
#endif

...

#ifdef CONFIG_SPARC
	struct pcidev_cookie *pcp = pdev->sysdata;
	u8 *port_name, *node_name;

	port_name = of_get_property(pcp->prom_node, "port-wwn", NULL);
	node_name = of_get_property(pcp->prom_node, "node-wwn", NULL);
#endif

Those will hold a pointer to the property values or NULL if the
property does not exist.  This is private data, so you should make
copies of them into your local data structure and not use references
to them.

I don't see any OFW properties present that could be used to fill in
the rest of the NVRAM parameters, so we'd need to use the defaults
that the code before the change was using.

But even if that fails, I think the fallback code should be put back,
since it obviously was used by at least one system and it's probable
that there are some other applications of using this qla2xxx chip that
will have an empty NVRAM too.

I can understand the apprehension in using a fixed port_name[] value,
since it could conflict with other FC controllers on the mesh, but if
that is so important just choose some random value that is a valid FC
ID or use some characteristic ID that can be used to compose part of
the port WWN in order to give it at least some uniqueness.

I'm happy to test out any patches you come up with, thanks.

commit 7aef45ac92f49e76d990b51b7ecd714b9a608be1
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Mon Jan 29 10:22:26 2007 -0800

    [SCSI] qla2xxx: Fail initialization when inconsistent NVRAM detected.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ee4b79e..b247bc2 100644
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
@@ -3570,11 +3477,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
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
