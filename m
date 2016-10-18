From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 05/11] scsi: ufs: fix sense buffer size to 18 bytes
Date: Mon, 17 Oct 2016 17:09:48 -0700
Message-ID: <1476749388-11244-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

According to UFS device specification, sense data can be only 18 bytes
long, this change makes the changes accordingly.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index beb4988..f549be3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -45,6 +45,8 @@
 #include "ufs_quirks.h"
 #include "unipro.h"
 
+#define UFSHCD_REQ_SENSE_SIZE	18
+
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK)
@@ -898,7 +900,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sr.sense_data,
-			min_t(int, len_to_copy, SCSI_SENSE_BUFFERSIZE));
+			min_t(int, len_to_copy, UFSHCD_REQ_SENSE_SIZE));
 	}
 }
 
@@ -1463,7 +1465,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
-	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
+	lrbp->sense_bufflen = UFSHCD_REQ_SENSE_SIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -5594,19 +5596,19 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 				0,
 				0,
 				0,
-				SCSI_SENSE_BUFFERSIZE,
+				UFSHCD_REQ_SENSE_SIZE,
 				0};
 	char *buffer;
 	int ret;
 
-	buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	buffer = kzalloc(UFSHCD_REQ_SENSE_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	ret = scsi_execute_req_flags(sdp, cmd, DMA_FROM_DEVICE, buffer,
-				SCSI_SENSE_BUFFERSIZE, NULL,
+				UFSHCD_REQ_SENSE_SIZE, NULL,
 				msecs_to_jiffies(1000), 3, NULL, REQ_PM);
 	if (ret)
 		pr_err("%s: failed with err %d\n", __func__, ret);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
