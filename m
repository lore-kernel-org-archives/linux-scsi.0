From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 3/9] scsi: ufs: Override auto suspend tunables for ufs
Date: Fri,  6 Jul 2018 18:00:30 +0530
Message-ID: <6981189193244970a912c8b3f390a00bc37ed14a.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Override auto suspend tunables for UFS device LUNs during
initialization so as to efficiently manage background operations
and the power consumption.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77e2b3e..b03f3ea 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -89,6 +89,9 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+/* default value of auto suspend is 3 seconds */
+#define UFSHCD_AUTO_SUSPEND_DELAY_MS 3000 /* millisecs */
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -4528,6 +4531,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
 
+	sdev->autosuspend_delay = UFSHCD_AUTO_SUSPEND_DELAY_MS;
+	sdev->use_rpm_auto = 1;
+
 	return 0;
 }
 
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
