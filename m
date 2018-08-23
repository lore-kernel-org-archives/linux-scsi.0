From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH 2/2] scsi: lpfc: use GFP_ATOMIC inside spin lock
Date: Thu, 23 Aug 2018 05:14:58 -0400
Message-ID: <1535015698-17948-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

GFP_KERNEL may sleep,so can not use it in spin lock,use GFP_ATOMIC instead.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5c7858e..3813f84 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5928,7 +5928,7 @@ struct lpfc_device_data*
 
 	/* Create an lun info structure and add to list of luns */
 	lun_info = lpfc_create_device_data(phba, vport_wwpn, target_wwpn, lun,
-					   pri, false);
+					   pri, true);
 	if (lun_info) {
 		lun_info->oas_enabled = true;
 		lun_info->priority = pri;
-- 
1.8.3.1
