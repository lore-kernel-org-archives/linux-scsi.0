From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 07/10] scsi: ufs: introduce UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
Date: Sun, 17 May 2015 18:55:03 +0300
Message-ID: <1431878106-30579-8-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Some UFS host controllers may only allow accessing the peer DME attribute
in AUTO mode (FAST AUTO or SLOW AUTO) hence we had added a quirk for
switching to AUTO power mode before accessing the peer DME attribute.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  7 +++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a274df9..014f1c0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -188,6 +188,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode);
+static int ufshcd_change_power_mode(struct ufs_hba *hba,
+			     struct ufs_pa_layer_attr *pwr_mode);
 
 static inline int ufshcd_enable_irq(struct ufs_hba *hba)
 {
@@ -2156,6 +2158,31 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	};
 	const char *get = action[!!peer];
 	int ret;
+	struct ufs_pa_layer_attr orig_pwr_info;
+	struct ufs_pa_layer_attr temp_pwr_info;
+	bool pwr_mode_change = false;
+
+	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)) {
+		orig_pwr_info = hba->pwr_info;
+		temp_pwr_info = orig_pwr_info;
+
+		if (orig_pwr_info.pwr_tx == FAST_MODE ||
+		    orig_pwr_info.pwr_rx == FAST_MODE) {
+			temp_pwr_info.pwr_tx = FASTAUTO_MODE;
+			temp_pwr_info.pwr_rx = FASTAUTO_MODE;
+			pwr_mode_change = true;
+		} else if (orig_pwr_info.pwr_tx == SLOW_MODE ||
+		    orig_pwr_info.pwr_rx == SLOW_MODE) {
+			temp_pwr_info.pwr_tx = SLOWAUTO_MODE;
+			temp_pwr_info.pwr_rx = SLOWAUTO_MODE;
+			pwr_mode_change = true;
+		}
+		if (pwr_mode_change) {
+			ret = ufshcd_change_power_mode(hba, &temp_pwr_info);
+			if (ret)
+				goto out;
+		}
+	}
 
 	uic_cmd.command = peer ?
 		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
@@ -2170,6 +2197,10 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 
 	if (mib_val)
 		*mib_val = uic_cmd.argument3;
+
+	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
+	    && pwr_mode_change)
+		ufshcd_change_power_mode(hba, &orig_pwr_info);
 out:
 	return ret;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8636ec9..eb6831d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -442,6 +442,13 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		UFS_BIT(3)
 
+	/*
+	 * This quirk needs to be enabled if the host contoller only allows
+	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
+	 * SLOW AUTO).
+	 */
+	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		UFS_BIT(4)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
