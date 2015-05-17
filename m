From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 05/10] scsi: ufs: introduce a broken PA_RXHSUNTERMCAP quirk
Date: Sun, 17 May 2015 18:55:01 +0300
Message-ID: <1431878106-30579-6-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

The attribute PA_RXHSUNTERMCAP specifies whether or not the
inbound Link supports unterminated line in HS mode. enabling this
attribute to 1 fixes moving to HS gear.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
 drivers/scsi/ufs/ufshcd.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3e57cca..a274df9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2258,6 +2258,16 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	struct uic_command uic_cmd = {0};
 	int ret;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP) {
+		ret = ufshcd_dme_set(hba,
+				UIC_ARG_MIB_SEL(PA_RXHSUNTERMCAP, 0), 1);
+		if (ret) {
+			dev_err(hba->dev, "%s: failed to enable PA_RXHSUNTERMCAP ret %d\n",
+						__func__, ret);
+			goto out;
+		}
+	}
+
 	uic_cmd.command = UIC_CMD_DME_SET;
 	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
 	uic_cmd.argument3 = mode;
@@ -2265,6 +2275,7 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	ufshcd_release(hba);
 
+out:
 	return ret;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b845f15..8636ec9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -435,6 +435,13 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_LCC				UFS_BIT(2)
 
+	/*
+	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
+	 * inbound Link supports unterminated line in HS mode. Setting this
+	 * attribute to 1 fixes moving to HS gear.
+	 */
+	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		UFS_BIT(3)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
