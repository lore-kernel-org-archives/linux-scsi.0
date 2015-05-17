From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 02/10] scsi: ufs-qcom: don't enable interrupt aggregation
Date: Sun, 17 May 2015 18:54:58 +0300
Message-ID: <1431878106-30579-3-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Current versions of UFS host controllers on QUALCOMM Technologies
have interrupt aggregation logic broken.
Interrupt aggregation may not work if both threshold count and timeout
is enabled. Hence disable interrupt aggregation by enabling
UFSHCD_QUIRK_BROKEN_INTR_AGGR quirk until its fixed in the newer
UFS host controller revisions.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6652a81..e8dc050 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -307,6 +307,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba, bool status)
 static unsigned long
 ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
 {
+	struct ufs_qcom_host *host = hba->priv;
 	struct ufs_clk_info *clki;
 	u32 core_clk_period_in_ns;
 	u32 tx_clk_cycles_per_us = 0;
@@ -330,6 +331,16 @@ ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
 		{UFS_HS_G2, 0x49},
 	};
 
+	/*
+	 * The Qunipro controller does not use following registers:
+	 * SYS1CLK_1US_REG, TX_SYMBOL_CLK_1US_REG, CLK_NS_REG &
+	 * UFS_REG_PA_LINK_STARTUP_TIMER
+	 * But UTP controller uses SYS1CLK_1US_REG register for Interrupt
+	 * Aggregation logic.
+	*/
+	if (ufs_qcom_cap_qunipro(host) && !ufshcd_is_intr_aggr_allowed(hba))
+		goto out;
+
 	if (gear == 0) {
 		dev_err(hba->dev, "%s: invalid gear = %d\n", __func__, gear);
 		goto out_error;
@@ -696,9 +707,13 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = hba->priv;
 
-	if (host->hw_ver.major == 0x1)
+	if (host->hw_ver.major == 0x01) {
 		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
 
+		if (host->hw_ver.minor == 0x0001 && host->hw_ver.step == 0x0001)
+			hba->quirks |= UFSHCD_QUIRK_BROKEN_INTR_AGGR;
+	}
+
 	if (host->hw_ver.major >= 0x2) {
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
