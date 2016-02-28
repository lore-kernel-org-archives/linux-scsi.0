From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 14/15] scsi: ufs: add device quirk delay before putting UFS rails in LPM
Date: Sun, 28 Feb 2016 15:32:46 +0200
Message-ID: <1456666367-11418-15-git-send-email-ygardi@codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

We put the UFS device in sleep state & UFS link in hibern8 state during
runtime suspaned. After this we put all the UFS rails in low power
modes immediately but it seems some devices may still draw more than
sleep current from UFS rails (especially from VCCQ rail) atleast for
500us.
To avoid this situation, this change adds 2ms delay before putting
these UFS rails in LPM mode.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs_quirks.c |  4 ++++
 drivers/scsi/ufs/ufs_quirks.h | 11 ++++++++++-
 drivers/scsi/ufs/ufshcd.c     | 10 ++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_quirks.c b/drivers/scsi/ufs/ufs_quirks.c
index 476ed01..af68007 100644
--- a/drivers/scsi/ufs/ufs_quirks.c
+++ b/drivers/scsi/ufs/ufs_quirks.c
@@ -16,11 +16,15 @@
 
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_NO_FASTAUTO),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
 		UFS_DEVICE_QUIRK_PA_TACTIVATE),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 01ab166..ffed0da 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -18,7 +18,7 @@
 /* return true if s1 is a prefix of s2 */
 #define STR_PRFX_EQUAL(s1, s2) !strncmp(s1, s2, strlen(s1))
 
-#define UFS_ANY_VENDOR -1
+#define UFS_ANY_VENDOR 0xFFFF
 #define UFS_ANY_MODEL  "ANY_MODEL"
 
 #define MAX_MODEL_LEN 16
@@ -119,6 +119,15 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_NO_FASTAUTO		(1 << 5)
 
+/*
+ * It seems some UFS devices may keep drawing more than sleep current
+ * (atleast for 500us) from UFS rails (especially from VCCQ rail).
+ * To avoid this situation, add 2ms delay before putting these UFS
+ * rails in LPM mode.
+ */
+#define UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM	(1 << 6)
+
+
 struct ufs_hba;
 void ufs_advertise_fixup_device(struct ufs_hba *hba);
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f108a0b..da882cf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5647,6 +5647,16 @@ out:
 static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 {
 	/*
+	 * It seems some UFS devices may keep drawing more than sleep current
+	 * (atleast for 500us) from UFS rails (especially from VCCQ rail).
+	 * To avoid this situation, add 2ms delay before putting these UFS
+	 * rails in LPM mode.
+	 */
+	if (!ufshcd_is_link_active(hba) &&
+	    hba->dev_quirks & UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM)
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
