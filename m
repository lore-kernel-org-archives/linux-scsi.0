From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 11/15] pm80xx: Firmware flash memory free fix, with addition
 of new memory, region for it
Date: Tue, 12 Feb 2013 04:39:29 -0800
Message-ID: <511A3801.2060201@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51051 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933128Ab3BLMir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:38:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From d3f1b3ea4b638f154a7979773f6a839fa455564b Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 11:06:51 +0530
Subject: [PATCH 11/15] pm80xx: Firmware flash memory free fix, with addition of new memory
 region for it

Performing pci_free_consistent in tasklet had result in a core dump. So
allocated a new memory region for it. Fix for passing proper address
and operation in firmware flash update.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |    5 +++--
 drivers/scsi/pm8001/pm8001_defs.h |    3 ++-
 drivers/scsi/pm8001/pm8001_hwi.c  |   30 ++++++------------------------
 drivers/scsi/pm8001/pm8001_init.c |    3 +++
 4 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index ae2b124..d99f41c 100755
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -400,10 +400,11 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 		goto out;
 	}
 	payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
-	memcpy((u8 *)payload->func_specific, (u8 *)pm8001_ha->fw_image->data,
+	memcpy((u8 *)&payload->func_specific, (u8 *)pm8001_ha->fw_image->data,
 				pm8001_ha->fw_image->size);
 	payload->length = pm8001_ha->fw_image->size;
 	payload->id = 0;
+	payload->minor_function = 0x1;
 	pm8001_ha->nvmd_completion = &completion;
 	ret = PM8001_CHIP_DISP->set_nvmd_req(pm8001_ha, payload);
 	wait_for_completion(&completion);
@@ -450,7 +451,7 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
 			payload->length = 1024*16;
 			payload->id = 0;
 			fwControl =
-			      (struct fw_control_info *)payload->func_specific;
+			      (struct fw_control_info *)&payload->func_specific;
 			fwControl->len = IOCTL_BUF_SIZE;   /* IN */
 			fwControl->size = partitionSize + HEADER_LEN;/* IN */
 			fwControl->retcode = 0;/* OUT */
diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 26a2ee6..479c5a7 100755
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -86,7 +86,7 @@ enum port_type {
 #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
 
-#define USI_MAX_MEMCNT_BASE	4
+#define USI_MAX_MEMCNT_BASE	5
 #define IB			(USI_MAX_MEMCNT_BASE + 1)
 #define CI			(IB + PM8001_MAX_SPCV_INB_NUM)
 #define OB			(CI + PM8001_MAX_SPCV_INB_NUM)
@@ -99,6 +99,7 @@ enum memory_region_num {
 	NVMD,	    /* NVM device */
 	DEV_MEM,    /* memory for devices */
 	CCB_MEM,    /* memory for command control block */
+	FW_FLASH    /* memory for fw flash update */
 };
 #define	PM8001_EVENT_LOG_SIZE	 (128 * 1024)
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 3adf499..c124fc6 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3481,10 +3481,6 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 		break;
 	}
 	ccb->fw_control_context->fw_control->retcode = status;
-	pci_free_consistent(pm8001_ha->pdev,
-			fw_control_context.len,
-			fw_control_context.virtAddr,
-			fw_control_context.phys_addr);
 	complete(pm8001_ha->nvmd_completion);
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
@@ -4474,7 +4470,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
 	if (!fw_control_context)
 		return -ENOMEM;
-	fw_control_context->usrAddr = (u8 *)&ioctl_payload->func_specific[0];
+	fw_control_context->usrAddr = (u8 *)ioctl_payload->func_specific;
 	fw_control_context->len = ioctl_payload->length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
@@ -4556,7 +4552,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		return -ENOMEM;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
-		ioctl_payload->func_specific,
+		&ioctl_payload->func_specific,
 		ioctl_payload->length);
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
@@ -4658,29 +4654,14 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	int rc;
 	u32 tag;
 	struct pm8001_ccb_info *ccb;
-	void *buffer = NULL;
-	dma_addr_t phys_addr;
-	u32 phys_addr_hi;
-	u32 phys_addr_lo;
+	void *buffer = pm8001_ha->memoryMap.region[FW_FLASH].virt_ptr;
+	dma_addr_t phys_addr = pm8001_ha->memoryMap.region[FW_FLASH].phys_addr;
 	struct pm8001_ioctl_payload *ioctl_payload = payload;
 
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
 	if (!fw_control_context)
 		return -ENOMEM;
-	fw_control = (struct fw_control_info *)&ioctl_payload->func_specific[0];
-	if (fw_control->len != 0) {
-		if (pm8001_mem_alloc(pm8001_ha->pdev,
-			(void **)&buffer,
-			&phys_addr,
-			&phys_addr_hi,
-			&phys_addr_lo,
-			fw_control->len, 0) != 0) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("Mem alloc failure\n"));
-				kfree(fw_control_context);
-				return -ENOMEM;
-		}
-	}
+	fw_control = (struct fw_control_info *)&ioctl_payload->func_specific;
 	memcpy(buffer, fw_control->buffer, fw_control->len);
 	flash_update_info.sgl.addr = cpu_to_le64(phys_addr);
 	flash_update_info.sgl.im_len.len = cpu_to_le32(fw_control->len);
@@ -4690,6 +4671,7 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	flash_update_info.total_image_len = fw_control->size;
 	fw_control_context->fw_control = fw_control;
 	fw_control_context->virtAddr = buffer;
+	fw_control_context->phys_addr = phys_addr;
 	fw_control_context->len = fw_control->len;
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc) {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9dcd72c..cb17cb9 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1173,6 +1173,9 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_ha->memoryMap.region[CCB_MEM].total_len = PM8001_MAX_CCB *
 		sizeof(struct pm8001_ccb_info);
 
+	/* Memory region for fw flash */
+	pm8001_ha->memoryMap.region[FW_FLASH].total_len = 4096;
+
 	for (i = 0; i < USI_MAX_MEMCNT; i++) {
 		if (pm8001_mem_alloc(pm8001_ha->pdev,
 			&pm8001_ha->memoryMap.region[i].virt_ptr,
-- 
1.7.1

