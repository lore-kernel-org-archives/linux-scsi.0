From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 2/4] scsi: ufs: adjust module reference for scsi host
Date: Sat, 28 Feb 2015 23:16:55 +0900
Message-ID: <1425133017-7216-3-git-send-email-akinobu.mita@gmail.com>
References: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41882 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbbB1ORc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 09:17:32 -0500
Received: by padfb1 with SMTP id fb1so30349576pad.8
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 06:17:32 -0800 (PST)
In-Reply-To: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

While accessing a UFS device, the module reference count for core driver
(ufshcd) is incremented but not incremented for the actual glue driver
(ufshcd-pci or ufshcd-pltfrm).  Because these drivers allocate scsi hosts
with scsi_host_template defined in ufshcd module.  So these drivers always
can be unloaded.

This fixes it by adjusting module reference after scsi host allocation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
No change from v3

 drivers/scsi/ufs/ufshcd-pci.c    | 1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 drivers/scsi/ufs/ufshcd.c        | 1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 7062cc5..d98f072 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -142,6 +142,7 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	hba->host->module = THIS_MODULE;
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index f9d0644..bd76a0c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -322,6 +322,7 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	hba->host->module = THIS_MODULE;
 	hba->vops = get_variant_ops(&pdev->dev);
 
 	err = ufshcd_parse_clock_info(hba);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8830aeb..87c4847 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4200,7 +4200,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 }
 
 static struct scsi_host_template ufshcd_driver_template = {
-	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
-- 
1.9.1

