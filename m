From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 16/17] scsi: ufs: add delay before putting UFS rails in low power modes
Date: Sun, 13 Sep 2015 17:52:56 +0300
Message-ID: <1442155977-7686-17-git-send-email-ygardi@codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

We put the UFS device in sleep state & UFS link in hibern8 state during
runtime suspaned. After this we put all the UFS rails in low power
modes immediately but it seems some devices may still draw more than
sleep current from UFS rails (especially from VCCQ rail) atleast for
500us.
To avoid this situation, this change adds 2ms delay before putting
these UFS rails in LPM mode.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 20b4c0e..786df28 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5694,6 +5694,15 @@ out:
 static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 {
 	/*
+	 * It seems some UFS devices may keep drawing more than sleep current
+	 * (atleast for 500us) from UFS rails (especially from VCCQ rail).
+	 * To avoid this situation, add 2ms delay before putting these UFS
+	 * rails in LPM mode.
+	 */
+	if (!ufshcd_is_link_active(hba))
+		usleep_range(2000, 2100);
+
+	/*
 	 * If UFS device is either in UFS_Sleep turn off VCC rail to save some
 	 * power.
 	 *
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
