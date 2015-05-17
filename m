From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 04/10] scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_LCC
Date: Sun, 17 May 2015 18:55:00 +0300
Message-ID: <1431878106-30579-5-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

LCC (Line Control Command) are being used for communication between
UFS host and UFS device. But UFS host controller on QUALCOMM
Technologies have an issue with issuing the LCC commands to
UFS device and hence this quirk is enabled in order to to disable
LCC from the host side.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index e8dc050..76d6e9d 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -715,6 +715,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 	}
 
 	if (host->hw_ver.major >= 0x2) {
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
+
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
 			hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
