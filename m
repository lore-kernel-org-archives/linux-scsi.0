From: jsmart2021@gmail.com
Subject: [PATCH v3 05/22] Add debug messages for nvme/fcp resource allocation.
Date: Fri, 21 Apr 2017 16:04:49 -0700
Message-ID: <20170421230506.925-6-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36752 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426480AbdDUXFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:18 -0400
Received: by mail-oi0-f65.google.com with SMTP id a3so18440676oii.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:18 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

The xri resources are split into pools for NVME and FCP IO when NVME is
enabled. There was not message in the log that identified this allocation.

Added debug message to log XRI split.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6cc561b..b56da01 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3508,6 +3508,12 @@ lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
 	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"6060 Current allocated SCSI xri-sgl count:%d, "
+			"maximum  SCSI xri count:%d (split:%d)\n",
+			phba->sli4_hba.scsi_xri_cnt,
+			phba->sli4_hba.scsi_xri_max, phba->cfg_xri_split);
+
 	if (phba->sli4_hba.scsi_xri_cnt > phba->sli4_hba.scsi_xri_max) {
 		/* max scsi xri shrinked below the allocated scsi buffers */
 		scsi_xri_cnt = phba->sli4_hba.scsi_xri_cnt -
-- 
2.9.3
