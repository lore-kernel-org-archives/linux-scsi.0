From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/4] scsi: pm8001: fix a memory leak in nvmd_resp
Date: Mon,  7 Jul 2014 17:19:58 +0200
Message-ID: <1404746401-25229-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaGGPUY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

Instead of copying information to fw_control_context free it.

The task is forgotten thus also the reference to fw_control_context
and the completion thread takes the info from virt_ptr again.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index cacb429..dc70791 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3129,7 +3129,6 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 void
 pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
-	struct fw_control_ex	*fw_control_context;
 	struct get_nvm_data_resp *pPayload =
 		(struct get_nvm_data_resp *)(piomb + 4);
 	u32 tag = le32_to_cpu(pPayload->tag);
@@ -3138,7 +3137,6 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 ir_tds_bn_dps_das_nvm =
 		le32_to_cpu(pPayload->ir_tda_bn_dps_das_nvm);
 	void *virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
-	fw_control_context = ccb->fw_control_context;
 
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Get nvm data complete!\n"));
 	if ((dlen_status & NVMD_STAT) != 0) {
@@ -3179,13 +3177,11 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("Get NVMD success, IR=0, dataLen=%d\n",
 			(dlen_status & NVMD_LEN) >> 24));
 	}
-	memcpy(fw_control_context->usrAddr,
-		pm8001_ha->memoryMap.region[NVMD].virt_ptr,
-		fw_control_context->len);
-	complete(pm8001_ha->nvmd_completion);
+	kfree(ccb->fw_control_context);
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
+	complete(pm8001_ha->nvmd_completion);
 }
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
-- 
1.8.3.1

