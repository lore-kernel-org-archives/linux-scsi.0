From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 07/15] scsi: ufs: set REQUEST_SENSE command size to 18 bytes
Date: Tue, 27 Oct 2015 12:44:09 +0200
Message-ID: <1445942657-6293-8-git-send-email-ygardi@codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

According to UFS device specification REQUEST_SENSE command can
only report back up to 18 bytes of data.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0e54183..8a04691 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,6 +43,8 @@
 #include "ufshcd.h"
 #include "unipro.h"
 
+#define UFSHCD_REQ_SENSE_SIZE	18
+
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK)
@@ -836,7 +838,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sr.sense_data,
-			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
+			min_t(int, len, UFSHCD_REQ_SENSE_SIZE));
 	}
 }
 
@@ -1381,7 +1383,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
-	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
+	lrbp->sense_bufflen = UFSHCD_REQ_SENSE_SIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -4817,19 +4819,19 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
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
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
