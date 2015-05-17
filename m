From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 06/10] scsi: ufs-qcom: enable quirk to fix gear change to HS
Date: Sun, 17 May 2015 18:55:02 +0300
Message-ID: <1431878106-30579-7-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

With the G3 UFS devices, changing gear into HS is failing in UFS host
controllers of version 0x2.
The quirk solves the problem of changing gear into HS by enabling
the attribute that specifies whether or not the inbound Link supports
unterminated line in HS mode.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 76d6e9d..6e5b183 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -708,7 +708,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = hba->priv;
 
 	if (host->hw_ver.major == 0x01) {
-		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
+		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
+			    | UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP;
 
 		if (host->hw_ver.minor == 0x0001 && host->hw_ver.step == 0x0001)
 			hba->quirks |= UFSHCD_QUIRK_BROKEN_INTR_AGGR;
@@ -719,7 +720,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
-			hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
+			hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
+				| UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP);
 	}
 }
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
