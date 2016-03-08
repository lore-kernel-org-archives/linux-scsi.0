From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 16/17] scsi: ufs-qcom: enable/disable the device ref clock
Date: Tue,  8 Mar 2016 14:36:07 +0200
Message-ID: <1457440568-13084-17-git-send-email-ygardi@codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This change enables the device ref clock before changing to HS mode
and disables it if entered to PWM mode.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 12 ++++++++++++
 drivers/scsi/ufs/ufshcd.h   |  9 +++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 966bacf..849fcf3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -980,6 +980,10 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 			goto out;
 		}
 
+		/* enable the device ref clock before changing to HS mode */
+		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
+			ufshcd_is_hs_mode(dev_req_params))
+			ufs_qcom_dev_ref_clk_ctrl(host, true);
 		break;
 	case POST_CHANGE:
 		if (ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
@@ -1007,6 +1011,11 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		memcpy(&host->dev_req_params,
 				dev_req_params, sizeof(*dev_req_params));
 		ufs_qcom_update_bus_bw_vote(host);
+
+		/* disable the device ref clock if entered PWM mode */
+		if (ufshcd_is_hs_mode(&hba->pwr_info) &&
+			!ufshcd_is_hs_mode(dev_req_params))
+			ufs_qcom_dev_ref_clk_ctrl(host, false);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1108,6 +1117,9 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 			ufs_qcom_phy_disable_iface_clk(host->generic_phy);
 			goto out;
 		}
+		/* enable the device ref clock for HS mode*/
+		if (ufshcd_is_hs_mode(&hba->pwr_info))
+			ufs_qcom_dev_ref_clk_ctrl(host, true);
 		vote = host->bus_vote.saved_vote;
 		if (vote == host->bus_vote.min_bw_vote)
 			ufs_qcom_update_bus_bw_vote(host);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 41d9bfd..4bb6566 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -54,6 +54,7 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/regulator/consumer.h>
+#include "unipro.h"
 
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -689,6 +690,14 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 
 int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size);
 
+static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
+{
+	return (pwr_info->pwr_rx == FAST_MODE ||
+		pwr_info->pwr_rx == FASTAUTO_MODE) &&
+		(pwr_info->pwr_tx == FAST_MODE ||
+		pwr_info->pwr_tx == FASTAUTO_MODE);
+}
+
 #define ASCII_STD true
 
 int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
