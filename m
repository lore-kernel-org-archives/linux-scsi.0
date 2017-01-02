From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] scsi: ufs-qcom: Fix module autoload
Date: Mon,  2 Jan 2017 11:04:58 -0300
Message-ID: <1483365898-30166-1-git-send-email-javier@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/scsi/ufs/ufs-qcom.ko | grep alias
$

After this patch:

$ modinfo drivers/scsi/ufs/ufs-qcom.ko | grep alias
alias:          of:N*T*Cqcom,ufshcC*
alias:          of:N*T*Cqcom,ufshc

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/scsi/ufs/ufs-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index abe617372661..5ff8a6bf6fd3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1692,6 +1692,7 @@ static const struct of_device_id ufs_qcom_of_match[] = {
 	{ .compatible = "qcom,ufshc"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
 
 static const struct dev_pm_ops ufs_qcom_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
-- 
2.7.4
