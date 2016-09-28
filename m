From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: ufs: fix error return code in ufshcd_init()
Date: Wed, 28 Sep 2016 14:49:42 +0000
Message-ID: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33404 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933087AbcI1Ots (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 10:49:48 -0400
Received: by mail-pf0-f195.google.com with SMTP id q2so2251184pfj.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2016 07:49:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 37f3c51..6aebb7e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6500,6 +6500,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		if (IS_ERR(hba->devfreq)) {
 			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
 					PTR_ERR(hba->devfreq));
+			err = PTR_ERR(hba->devfreq);
 			goto out_remove_scsi_host;
 		}
 		/* Suspend devfreq until the UFS device is detected */



