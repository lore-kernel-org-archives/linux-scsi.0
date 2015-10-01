From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 06/13] scsi: ufs: add quirk to enable host controller
 without hce
Date: Thu, 01 Oct 2015 13:39:23 +0530
Message-ID: <1443686970-28104-7-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55220 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbbJAIWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 04:22:36 -0400
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

Some host controller doesn't support host controller enable via HCE.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   76 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |    5 +++
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e388edc..07659be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2107,6 +2107,52 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
+/**
+ * ufshcd_dme_reset - UIC command for DME_RESET
+ * @hba: per adapter instance
+ *
+ * DME_RESET command is issued in order to reset UniPro stack.
+ * This function now deal with cold reset.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_reset(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_RESET;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * ufshcd_dme_enable - UIC command for DME_ENABLE
+ * @hba: per adapter instance
+ *
+ * DME_ENABLE command is issued in order to enable UniPro stack.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_enable(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_ENABLE;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
@@ -2643,7 +2689,7 @@ out:
 }
 
 /**
- * ufshcd_hba_enable - initialize the controller
+ * ufshcd_hba_execute_hce - initialize the controller
  * @hba: per adapter instance
  *
  * The controller resets itself and controller firmware initialization
@@ -2652,7 +2698,7 @@ out:
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_hba_enable(struct ufs_hba *hba)
+static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
 	int retry;
 
@@ -2718,6 +2764,32 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 	return 0;
 }
 
+static int ufshcd_hba_enable(struct ufs_hba *hba)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
+		ufshcd_set_link_off(hba);
+		if (hba->vops && hba->vops->hce_enable_notify)
+			hba->vops->hce_enable_notify(hba, PRE_CHANGE);
+
+		/* enable UIC related interrupts */
+		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
+		ret = ufshcd_dme_reset(hba);
+		if (!ret) {
+			ret = ufshcd_dme_enable(hba);
+			if (!ret && hba->vops && hba->vops->hce_enable_notify)
+				hba->vops->hce_enable_notify(hba, POST_CHANGE);
+			if (ret)
+				dev_err(hba->dev,
+					"Host controller enable failed with non-hce\n");
+		}
+	} else {
+		ret = ufshcd_hba_execute_hce(hba);
+	}
+
+	return ret;
+}
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
 {
 	int tx_lanes, i, err = 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0b185e1..a4543c8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -477,6 +477,11 @@ struct ufs_hba {
 	 */
 	#define UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		UFS_BIT(8)
 
+	/*
+	 * This quirks needs to be enabled if host controller cannot be
+	 * enabled via HCE register.
+	 */
+	#define UFSHCI_QUIRK_BROKEN_HCE				UFS_BIT(9)
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.7.10.4

