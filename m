From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/15] qla2xxx: Use port number to compute nvram/vpd parameter offsets.
Date: Mon,  6 Apr 2009 22:33:50 -0700
Message-ID: <1239082431-19496-15-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZDGFeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:12 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Read adapter's physical port number from interrupt pin register
and use it instead of pci function number to offset into the
nvram to obtain the port's configuration parameters.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_init.c |   19 ++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++++++
 drivers/scsi/qla2xxx/qla_sup.c  |   18 +++++++++---------
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6911b9b..721bae9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2222,6 +2222,7 @@ struct qla_hw_data {
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
 		uint32_t	chip_reset_done		:1;
+		uint32_t	port0			:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2256,6 +2257,9 @@ struct qla_hw_data {
 #define FLOGI_MID_SUPPORT       BIT_10
 #define FLOGI_VSAN_SUPPORT      BIT_12
 #define FLOGI_SP_SUPPORT        BIT_13
+
+	uint8_t		port_no;		/* Physical port of adapter */
+
 	/* Timeout timers. */
 	uint8_t 	loop_down_abort_time;    /* port down timer */
 	atomic_t	loop_down_timer;         /* loop down timer */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4952fc1..33e9248 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3573,14 +3573,15 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	nv = ha->nvram;
 
 	/* Determine NVRAM starting address. */
-	ha->nvram_size = sizeof(struct nvram_24xx);
-	ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
-	ha->vpd_size = FA_NVRAM_VPD_SIZE;
-	ha->vpd_base = FA_NVRAM_VPD0_ADDR;
-	if (PCI_FUNC(ha->pdev->devfn)) {
+	if (ha->flags.port0) {
+		ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
+		ha->vpd_base = FA_NVRAM_VPD0_ADDR;
+	} else {
 		ha->nvram_base = FA_NVRAM_FUNC1_ADDR;
 		ha->vpd_base = FA_NVRAM_VPD1_ADDR;
 	}
+	ha->nvram_size = sizeof(struct nvram_24xx);
+	ha->vpd_size = FA_NVRAM_VPD_SIZE;
 
 	/* Get VPD data into cache */
 	ha->vpd = ha->nvram + VPD_OFFSET;
@@ -3619,7 +3620,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->hard_address = __constant_cpu_to_le16(124);
 		nv->port_name[0] = 0x21;
-		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[1] = 0x00 + ha->port_no;
 		nv->port_name[2] = 0x00;
 		nv->port_name[3] = 0xe0;
 		nv->port_name[4] = 0x8b;
@@ -4348,7 +4349,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->port_name[0] = 0x21;
-		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[1] = 0x00 + ha->port_no;
 		nv->port_name[2] = 0x00;
 		nv->port_name[3] = 0xe0;
 		nv->port_name[4] = 0x8b;
@@ -4382,7 +4383,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		nv->enode_mac[2] = 0x03;
 		nv->enode_mac[3] = 0x04;
 		nv->enode_mac[4] = 0x05;
-		nv->enode_mac[5] = 0x06 + PCI_FUNC(ha->pdev->devfn);
+		nv->enode_mac[5] = 0x06 + ha->port_no;
 
 		rval = 1;
 	}
@@ -4415,7 +4416,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		icb->enode_mac[2] = 0x03;
 		icb->enode_mac[3] = 0x04;
 		icb->enode_mac[4] = 0x05;
-		icb->enode_mac[5] = 0x06 + PCI_FUNC(ha->pdev->devfn);
+		icb->enode_mac[5] = 0x06 + ha->port_no;
 	}
 
 	/* Use extended-initialization control block. */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index eecb76e..0733cb2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1581,6 +1581,13 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	}
+
+	/* Get adapter physical port no from interrupt pin register. */
+	pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
+	if (ha->port_no & 1)
+		ha->flags.port0 = 1;
+	else
+		ha->flags.port0 = 0;
 }
 
 static int
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 2a9b3f8..22f97eb 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -702,30 +702,30 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			break;
 		case FLT_REG_VPD_0:
 			ha->flt_region_vpd_nvram = start;
-			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+			if (ha->flags.port0)
 				ha->flt_region_vpd = start;
 			break;
 		case FLT_REG_VPD_1:
-			if (PCI_FUNC(ha->pdev->devfn) & 1)
+			if (!ha->flags.port0)
 				ha->flt_region_vpd = start;
 			break;
 		case FLT_REG_NVRAM_0:
-			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+			if (ha->flags.port0)
 				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_NVRAM_1:
-			if (PCI_FUNC(ha->pdev->devfn) & 1)
+			if (!ha->flags.port0)
 				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_FDT:
 			ha->flt_region_fdt = start;
 			break;
 		case FLT_REG_NPIV_CONF_0:
-			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+			if (ha->flags.port0)
 				ha->flt_region_npiv_conf = start;
 			break;
 		case FLT_REG_NPIV_CONF_1:
-			if (PCI_FUNC(ha->pdev->devfn) & 1)
+			if (!ha->flags.port0)
 				ha->flt_region_npiv_conf = start;
 			break;
 		}
@@ -745,12 +745,12 @@ no_flash_data:
 	ha->flt_region_fw = def_fw[def];
 	ha->flt_region_boot = def_boot[def];
 	ha->flt_region_vpd_nvram = def_vpd_nvram[def];
-	ha->flt_region_vpd = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	ha->flt_region_vpd = ha->flags.port0 ?
 	    def_vpd0[def]: def_vpd1[def];
-	ha->flt_region_nvram = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	ha->flt_region_nvram = ha->flags.port0 ?
 	    def_nvram0[def]: def_nvram1[def];
 	ha->flt_region_fdt = def_fdt[def];
-	ha->flt_region_npiv_conf = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	ha->flt_region_npiv_conf = ha->flags.port0 ?
 	    def_npiv_conf0[def]: def_npiv_conf1[def];
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
-- 
1.6.2.2.404.ge96f3

