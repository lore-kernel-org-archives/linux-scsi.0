From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/19] qla2xxx: Allow region-based flash-part accesses.
Date: Thu, 20 Sep 2007 14:07:35 -0700
Message-ID: <1190322470-15543-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXITVHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:47 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  108 ++++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h  |    2 +
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +
 drivers/scsi/qla2xxx/qla_sup.c  |    4 +-
 4 files changed, 96 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0f2a9f5..8e7e00c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -175,10 +175,10 @@ qla2x00_sysfs_read_optrom(struct kobject *kobj,
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
-	if (off > ha->optrom_size)
+	if (off > ha->optrom_region_size)
 		return 0;
-	if (off + count > ha->optrom_size)
-		count = ha->optrom_size - off;
+	if (off + count > ha->optrom_region_size)
+		count = ha->optrom_region_size - off;
 
 	memcpy(buf, &ha->optrom_buffer[off], count);
 
@@ -195,10 +195,10 @@ qla2x00_sysfs_write_optrom(struct kobject *kobj,
 
 	if (ha->optrom_state != QLA_SWRITING)
 		return -EINVAL;
-	if (off > ha->optrom_size)
+	if (off > ha->optrom_region_size)
 		return -ERANGE;
-	if (off + count > ha->optrom_size)
-		count = ha->optrom_size - off;
+	if (off + count > ha->optrom_region_size)
+		count = ha->optrom_region_size - off;
 
 	memcpy(&ha->optrom_buffer[off], buf, count);
 
@@ -222,12 +222,16 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int val;
+	uint32_t start = 0;
+	uint32_t size = ha->optrom_size;
+	int val, valid;
 
 	if (off)
 		return 0;
 
-	if (sscanf(buf, "%d", &val) != 1)
+	if (sscanf(buf, "%d:%x:%x", &val, &start, &size) < 1)
+		return -EINVAL;
+	if (start > ha->optrom_size)
 		return -EINVAL;
 
 	switch (val) {
@@ -237,6 +241,11 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 			break;
 
 		ha->optrom_state = QLA_SWAITING;
+
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Freeing flash region allocation -- 0x%x bytes.\n",
+		    ha->optrom_region_size));
+
 		vfree(ha->optrom_buffer);
 		ha->optrom_buffer = NULL;
 		break;
@@ -244,44 +253,107 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		if (ha->optrom_state != QLA_SWAITING)
 			break;
 
+		if (start & 0xfff) {
+			qla_printk(KERN_WARNING, ha,
+			    "Invalid start region 0x%x/0x%x.\n", start, size);
+			return -EINVAL;
+		}
+
+		ha->optrom_region_start = start;
+		ha->optrom_region_size = start + size > ha->optrom_size ?
+		    ha->optrom_size - start : size;
+
 		ha->optrom_state = QLA_SREADING;
-		ha->optrom_buffer = (uint8_t *)vmalloc(ha->optrom_size);
+		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to allocate memory for optrom retrieval "
-			    "(%x).\n", ha->optrom_size);
+			    "(%x).\n", ha->optrom_region_size);
 
 			ha->optrom_state = QLA_SWAITING;
 			return count;
 		}
 
-		memset(ha->optrom_buffer, 0, ha->optrom_size);
-		ha->isp_ops->read_optrom(ha, ha->optrom_buffer, 0,
-		    ha->optrom_size);
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Reading flash region -- 0x%x/0x%x.\n",
+		    ha->optrom_region_start, ha->optrom_region_size));
+
+		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
+		ha->isp_ops->read_optrom(ha, ha->optrom_buffer,
+		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
 	case 2:
 		if (ha->optrom_state != QLA_SWAITING)
 			break;
 
+		/*
+		 * We need to be more restrictive on which FLASH regions are
+		 * allowed to be updated via user-space.  Regions accessible
+		 * via this method include:
+		 *
+		 * ISP21xx/ISP22xx/ISP23xx type boards:
+		 *
+		 * 	0x000000 -> 0x020000 -- Boot code.
+		 *
+		 * ISP2322/ISP24xx type boards:
+		 *
+		 * 	0x000000 -> 0x07ffff -- Boot code.
+		 * 	0x080000 -> 0x0fffff -- Firmware.
+		 *
+		 * ISP25xx type boards:
+		 *
+		 * 	0x000000 -> 0x07ffff -- Boot code.
+		 * 	0x080000 -> 0x0fffff -- Firmware.
+		 * 	0x120000 -> 0x12ffff -- VPD and HBA parameters.
+		 */
+		valid = 0;
+		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
+			valid = 1;
+		else if (start == (FA_BOOT_CODE_ADDR*4) ||
+		    start == (FA_RISC_CODE_ADDR*4))
+			valid = 1;
+		else if (IS_QLA25XX(ha) && start == (FA_VPD_NVRAM_ADDR*4))
+		    valid = 1;
+		if (!valid) {
+			qla_printk(KERN_WARNING, ha,
+			    "Invalid start region 0x%x/0x%x.\n", start, size);
+			return -EINVAL;
+		}
+
+		ha->optrom_region_start = start;
+		ha->optrom_region_size = start + size > ha->optrom_size ?
+		    ha->optrom_size - start : size;
+
 		ha->optrom_state = QLA_SWRITING;
-		ha->optrom_buffer = (uint8_t *)vmalloc(ha->optrom_size);
+		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to allocate memory for optrom update "
-			    "(%x).\n", ha->optrom_size);
+			    "(%x).\n", ha->optrom_region_size);
 
 			ha->optrom_state = QLA_SWAITING;
 			return count;
 		}
-		memset(ha->optrom_buffer, 0, ha->optrom_size);
+
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Staging flash region write -- 0x%x/0x%x.\n",
+		    ha->optrom_region_start, ha->optrom_region_size));
+
+		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		break;
 	case 3:
 		if (ha->optrom_state != QLA_SWRITING)
 			break;
 
-		ha->isp_ops->write_optrom(ha, ha->optrom_buffer, 0,
-		    ha->optrom_size);
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Writing flash region -- 0x%x/0x%x.\n",
+		    ha->optrom_region_start, ha->optrom_region_size));
+
+		ha->isp_ops->write_optrom(ha, ha->optrom_buffer,
+		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
+	default:
+		count = -EINVAL;
 	}
 	return count;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4af0856..e1e3428 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2478,6 +2478,8 @@ typedef struct scsi_qla_host {
 #define QLA_SWAITING	0
 #define QLA_SREADING	1
 #define QLA_SWRITING	2
+	uint32_t	optrom_region_start;
+	uint32_t	optrom_region_size;
 
         /* PCI expansion ROM image information. */
 #define ROM_CODE_TYPE_BIOS	0
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 99fe496..d5344d7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -779,6 +779,8 @@ struct device_reg_24xx {
 #define FA_NVRAM_VPD_SIZE	0x200
 #define FA_NVRAM_VPD0_ADDR	0x00
 #define FA_NVRAM_VPD1_ADDR	0x100
+
+#define FA_BOOT_CODE_ADDR	0x00000
 					/*
 					 * RISC code begins at offset 512KB
 					 * within flash. Consisting of two
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ad3d1de..40b059f 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -559,7 +559,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	ret = QLA_SUCCESS;
 
 	/* Prepare burst-capable write on supported ISPs. */
-	if (IS_QLA25XX(ha) && !(faddr & ~OPTROM_BURST_SIZE) &&
+	if (IS_QLA25XX(ha) && !(faddr & 0xfff) &&
 	    dwords > OPTROM_BURST_DWORDS) {
 		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 		    &optrom_dma, GFP_KERNEL);
@@ -1824,7 +1824,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	uint8_t *pbuf;
 	uint32_t faddr, left, burst;
 
-	if (offset & ~OPTROM_BURST_SIZE)
+	if (offset & 0xfff)
 		goto slow_read;
 	if (length < OPTROM_BURST_SIZE)
 		goto slow_read;
-- 
1.5.3.2.80.g077d6f

