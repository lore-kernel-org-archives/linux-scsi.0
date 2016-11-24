From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 08/11] scsi: ufs: handle errors from PHY_ADAPTER_ERROR register
Date: Wed, 23 Nov 2016 16:32:32 -0800
Message-ID: <1479947552-7216-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Dolev Raviv <draviv@codeaurora.org>

The PHY_ADAPTER_ERROR status register indicates PHY lane errors
reported by the M-PHY layer. In some occasions the controller
can recover from such errors. When the error is not recoverable,
a stuck DB error will occur. Since the stuck DB error is spotted
separately, no action other than clearing the register is necessary.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
 drivers/scsi/ufs/ufshci.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 16c5c50..ec4c99a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4215,6 +4215,17 @@ static void ufshcd_update_uic_error(struct ufs_hba *hba)
 {
 	u32 reg;
 
+	/* PHY layer lane error */
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+	/* Ignore LINERESET indication, as this is not an error */
+	if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
+			(reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK))
+		/*
+		 * To know whether this error is fatal or not, DB timeout
+		 * must be checked but this error is handled separately.
+		 */
+		dev_dbg(hba->dev, "%s: UIC Lane error reported\n", __func__);
+
 	/* PA_INIT_ERROR is fatal and needs UIC reset */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
 	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 9599741..bfabb08 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -166,6 +166,7 @@ enum {
 /* UECPA - Host UIC Error Code PHY Adapter Layer 38h */
 #define UIC_PHY_ADAPTER_LAYER_ERROR			UFS_BIT(31)
 #define UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK		0x1F
+#define UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK		0xF
 
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
