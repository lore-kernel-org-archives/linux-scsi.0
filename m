From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 08/14] scsi: ufs: add retries for hibern8 enter
Date: Mon,  1 Feb 2016 15:02:44 +0200
Message-ID: <1454331770-29642-9-git-send-email-ygardi@codeaurora.org>
References: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

If hibern8 enter command fails then UFS link state may be unknown which
may result into timeout of all the commands issued after failure.

This change does 2 things (for pre-defined number of retry counts) after
hibern8 enter failure:
1. Recovers the UFS link to active state
2. If link is recovered to active state, tries to put the UFS link in
   hibern8 enter again until retry count expires.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4c0827f..1581d03 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -74,6 +74,9 @@
 /* maximum number of link-startup retries */
 #define DME_LINKSTARTUP_RETRIES 3
 
+/* Maximum retries for Hibern8 enter */
+#define UIC_HIBERN8_ENTER_RETRIES 3
+
 /* maximum number of reset retries before giving up */
 #define MAX_HOST_RESET_RETRIES 5
 
@@ -2387,13 +2390,32 @@ out:
 	return ret;
 }
 
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
+	int ret;
 	struct uic_command uic_cmd = {0};
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
+	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+
+	if (ret)
+		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
+static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+{
+	int ret = 0, retries;
 
-	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
+		ret = __ufshcd_uic_hibern8_enter(hba);
+		if (!ret || ret == -ENOLINK)
+			goto out;
+	}
+out:
+	return ret;
 }
 
 static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
