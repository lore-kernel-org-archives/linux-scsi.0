From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 2/4] scsi: ufs-qcom: fix compilation warning if compiled as a module
Date: Wed,  3 Jun 2015 12:37:33 +0300
Message-ID: <1433324255-27510-3-git-send-email-ygardi@codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, pebolle@tiscali.nl, gbroner@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

This change fixes a compilation warning that happens if SCSI_UFS_QCOM
is compiled as a module.
Also this patch fixes an error happens when insmod the module:
"ufs_qcom: module license 'unspecified' taints kernel."

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6652a81..6671a8e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -885,12 +885,15 @@ out:
 
 #define	ANDROID_BOOT_DEV_MAX	30
 static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
-static int get_android_boot_dev(char *str)
+
+#ifndef MODULE
+static int __init get_android_boot_dev(char *str)
 {
 	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
 	return 1;
 }
 __setup("androidboot.bootdevice=", get_android_boot_dev);
+#endif
 
 /**
  * ufs_qcom_init - bind phy with controller
@@ -1014,3 +1017,5 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.resume			= ufs_qcom_resume,
 };
 EXPORT_SYMBOL(ufs_hba_qcom_vops);
+
+MODULE_LICENSE("GPL v2");
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
