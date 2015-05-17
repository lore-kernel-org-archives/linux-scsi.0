From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 03/10] scsi: ufs: provide a quirk to disable the LCC
Date: Sun, 17 May 2015 18:54:59 +0300
Message-ID: <1431878106-30579-4-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

LCC (Line Control Command) are being used for communication between
UFS host and UFS device.
New commercial UFS devices don't have the issues with LCC processing
but UFS host controller might still have the issue with LCC processing,
hence, added a routine to disable TX LCC on the device.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  8 ++++++++
 drivers/scsi/ufs/ufshci.h |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9641bcb..3e57cca 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2640,6 +2640,42 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 	return 0;
 }
 
+static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
+{
+	int tx_lanes, i, err = 0;
+
+	if (!peer)
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			       &tx_lanes);
+	else
+		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+				    &tx_lanes);
+	for (i = 0; i < tx_lanes; i++) {
+		if (!peer)
+			err = ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(TX_LCC_ENABLE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+					0);
+		else
+			err = ufshcd_dme_peer_set(hba,
+				UIC_ARG_MIB_SEL(TX_LCC_ENABLE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+					0);
+		if (err) {
+			dev_err(hba->dev, "%s: TX LCC Disable failed, peer = %d, lane = %d, err = %d",
+				__func__, peer, i, err);
+			break;
+		}
+	}
+
+	return err;
+}
+
+static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
+{
+	return ufshcd_disable_tx_lcc(hba, true);
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -2677,6 +2713,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		/* failed to get the link up... retire */
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_LCC) {
+		ret = ufshcd_disable_device_tx_lcc(hba);
+		if (ret)
+			goto out;
+	}
+
 	/* Include any host controller configuration via UIC commands */
 	if (hba->vops && hba->vops->link_startup_notify) {
 		ret = hba->vops->link_startup_notify(hba, POST_CHANGE);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index fc8bec9..b845f15 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -426,6 +426,14 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(1)
 
+	/*
+	 * If UFS host controller is having issue in processing LCC (Line
+	 * Control Command) coming from device then enable this quirk.
+	 * When this quirk is enabled, host controller driver should disable
+	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
+	 * attribute of device to 0).
+	 */
+	#define UFSHCD_QUIRK_BROKEN_LCC				UFS_BIT(2)
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d572119..f8909ec 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -206,6 +206,9 @@ enum {
 #define CONFIG_RESULT_CODE_MASK		0xFF
 #define GENERIC_ERROR_CODE_MASK		0xFF
 
+/* GenSelectorIndex calculation macros for M-PHY attributes */
+#define UIC_ARG_MPHY_TX_GEN_SEL_INDEX(lane) (lane)
+
 #define UIC_ARG_MIB_SEL(attr, sel)	((((attr) & 0xFFFF) << 16) |\
 					 ((sel) & 0xFFFF))
 #define UIC_ARG_MIB(attr)		UIC_ARG_MIB_SEL(attr, 0)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
