From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 20/26] qla2xxx: Always use an FLT's NVRAM/VPD region information.
Date: Tue, 24 Mar 2009 09:08:14 -0700
Message-ID: <1237910900-30817-21-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762352AbZCXQIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:44 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Rather than assuming a particular layout of the data.  Applies to
recent ISPs only.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 ++++--
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h   |    4 ++++
 drivers/scsi/qla2xxx/qla_init.c |   14 ++++----------
 drivers/scsi/qla2xxx/qla_os.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_sup.c  |   31 +++++++++++++++++++++++++++++--
 6 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a59edb5..18566ed 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -111,7 +111,8 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t	cnt;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
+	    !ha->isp_ops->write_nvram)
 		return 0;
 
 	/* Checksum NVRAM. */
@@ -393,7 +394,8 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t *tmp_data;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size ||
+	    !ha->isp_ops->write_nvram)
 		return 0;
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5a55a20..01b7fc6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2506,6 +2506,8 @@ struct qla_hw_data {
 	uint32_t        flt_region_boot;
 	uint32_t        flt_region_fw;
 	uint32_t        flt_region_vpd_nvram;
+	uint32_t        flt_region_vpd;
+	uint32_t        flt_region_nvram;
 	uint32_t        flt_region_npiv_conf;
 
 	/* Needed for BEACON */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index e47c4c3..96ccb96 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1708,6 +1708,10 @@ struct ex_init_cb_81xx {
 #define FA_RISC_CODE_ADDR_81	0xA0000
 #define FA_FW_AREA_ADDR_81	0xC0000
 #define FA_VPD_NVRAM_ADDR_81	0xD0000
+#define FA_VPD0_ADDR_81		0xD0000
+#define FA_VPD1_ADDR_81		0xD0400
+#define FA_NVRAM0_ADDR_81	0xD0080
+#define FA_NVRAM1_ADDR_81	0xD0480
 #define FA_FEATURE_ADDR_81	0xD4000
 #define FA_FLASH_DESCR_ADDR_81	0xD8000
 #define FA_FLASH_LAYOUT_ADDR_81	0xD8400
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d525808..997c83b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4344,23 +4344,17 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(struct nvram_81xx);
-	ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
 	ha->vpd_size = FA_NVRAM_VPD_SIZE;
-	ha->vpd_base = FA_NVRAM_VPD0_ADDR;
-	if (PCI_FUNC(ha->pdev->devfn) & 1) {
-		ha->nvram_base = FA_NVRAM_FUNC1_ADDR;
-		ha->vpd_base = FA_NVRAM_VPD1_ADDR;
-	}
 
 	/* Get VPD data into cache */
 	ha->vpd = ha->nvram + VPD_OFFSET;
-	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd,
-	    ha->nvram_base - FA_NVRAM_FUNC0_ADDR, FA_NVRAM_VPD_SIZE * 4);
+	ha->isp_ops->read_optrom(vha, ha->vpd, ha->flt_region_vpd << 2,
+	    ha->vpd_size);
 
 	/* Get NVRAM data into cache and calculate checksum. */
-	dptr = (uint32_t *)nv;
-	ha->isp_ops->read_nvram(vha, (uint8_t *)dptr, ha->nvram_base,
+	ha->isp_ops->read_optrom(vha, ha->nvram, ha->flt_region_nvram << 2,
 	    ha->nvram_size);
+	dptr = (uint32_t *)nv;
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9bb4b2e..7e038e4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1409,8 +1409,8 @@ static struct isp_operations qla81xx_isp_ops = {
 	.build_iocbs		= NULL,
 	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
 	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
-	.read_nvram		= qla25xx_read_nvram_data,
-	.write_nvram		= qla25xx_write_nvram_data,
+	.read_nvram		= NULL,
+	.write_nvram		= NULL,
 	.fw_dump		= qla81xx_fw_dump,
 	.beacon_on		= qla24xx_beacon_on,
 	.beacon_off		= qla24xx_beacon_off,
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 468c114..0664667 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -629,6 +629,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		{ FA_BOOT_CODE_ADDR, FA_BOOT_CODE_ADDR, FA_BOOT_CODE_ADDR_81 };
 	const uint32_t def_vpd_nvram[] =
 		{ FA_VPD_NVRAM_ADDR, FA_VPD_NVRAM_ADDR, FA_VPD_NVRAM_ADDR_81 };
+	const uint32_t def_vpd0[] =
+		{ 0, 0, FA_VPD0_ADDR_81 };
+	const uint32_t def_vpd1[] =
+		{ 0, 0, FA_VPD1_ADDR_81 };
+	const uint32_t def_nvram0[] =
+		{ 0, 0, FA_NVRAM0_ADDR_81 };
+	const uint32_t def_nvram1[] =
+		{ 0, 0, FA_NVRAM1_ADDR_81 };
 	const uint32_t def_fdt[] =
 		{ FA_FLASH_DESCR_ADDR_24, FA_FLASH_DESCR_ADDR,
 			FA_FLASH_DESCR_ADDR_81 };
@@ -693,6 +701,20 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			break;
 		case FLT_REG_VPD_0:
 			ha->flt_region_vpd_nvram = start;
+			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+				ha->flt_region_vpd = start;
+			break;
+		case FLT_REG_VPD_1:
+			if (PCI_FUNC(ha->pdev->devfn) & 1)
+				ha->flt_region_vpd = start;
+			break;
+		case FLT_REG_NVRAM_0:
+			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+				ha->flt_region_nvram = start;
+			break;
+		case FLT_REG_NVRAM_1:
+			if (PCI_FUNC(ha->pdev->devfn) & 1)
+				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_FDT:
 			ha->flt_region_fdt = start;
@@ -722,13 +744,18 @@ no_flash_data:
 	ha->flt_region_fw = def_fw[def];
 	ha->flt_region_boot = def_boot[def];
 	ha->flt_region_vpd_nvram = def_vpd_nvram[def];
+	ha->flt_region_vpd = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	    def_vpd0[def]: def_vpd1[def];
+	ha->flt_region_nvram = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	    def_nvram0[def]: def_nvram1[def];
 	ha->flt_region_fdt = def_fdt[def];
 	ha->flt_region_npiv_conf = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
 	    def_npiv_conf0[def]: def_npiv_conf1[def];
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
-	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x npiv=0x%x.\n", loc,
-	    ha->flt_region_boot, ha->flt_region_fw, ha->flt_region_vpd_nvram,
+	    "vpd_nvram=0x%x vpd=0x%x nvram=0x%x fdt=0x%x flt=0x%x "
+	    "npiv=0x%x.\n", loc, ha->flt_region_boot, ha->flt_region_fw,
+	    ha->flt_region_vpd_nvram, ha->flt_region_vpd, ha->flt_region_nvram,
 	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_npiv_conf));
 }
 
-- 
1.6.2.rc0.55.g30aa4f

