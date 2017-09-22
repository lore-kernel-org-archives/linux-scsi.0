From: Huanlin Ke <chgokhl@gmail.com>
Subject: [PATCH] scsi: ufs: continue to boot even with Boot LUN is disabled
Date: Fri, 22 Sep 2017 18:31:47 +0800
Message-ID: <1506076307-8462-1-git-send-email-kehuanlin@pinecone.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kehuanlin@pinecone.net
List-Id: linux-scsi@vger.kernel.org

Several configurable fields of the Device Descriptor and the Unit
Descriptors determine the Boot LUN status. The bBootEnable field and
the bBootLunEn attribute is set to zero by default, so the Boot LUN is
disabled by default.

At which point the scsi device add for Boot LUN will fail, but we can
continue to use the ufs device in fact. This failure shouldn't abort the
device boot.

Signed-off-by: Huanlin Ke <kehuanlin@pinecone.net>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 794a460..bff84be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5998,25 +5998,22 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	}
 	scsi_device_put(hba->sdev_ufs_device);
 
-	sdev_boot = __scsi_add_device(hba->host, 0, 0,
-		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
-	if (IS_ERR(sdev_boot)) {
-		ret = PTR_ERR(sdev_boot);
-		goto remove_sdev_ufs_device;
-	}
-	scsi_device_put(sdev_boot);
-
 	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
 	if (IS_ERR(sdev_rpmb)) {
 		ret = PTR_ERR(sdev_rpmb);
-		goto remove_sdev_boot;
+		goto remove_sdev_ufs_device;
 	}
 	scsi_device_put(sdev_rpmb);
+
+	sdev_boot = __scsi_add_device(hba->host, 0, 0,
+		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
+	if (IS_ERR(sdev_boot))
+		dev_err(hba->dev, "%s: BOOT WLUN not found\n", __func__);
+	else
+		scsi_device_put(sdev_boot);
 	goto out;
 
-remove_sdev_boot:
-	scsi_remove_device(sdev_boot);
 remove_sdev_ufs_device:
 	scsi_remove_device(hba->sdev_ufs_device);
 out:
-- 
2.7.4
