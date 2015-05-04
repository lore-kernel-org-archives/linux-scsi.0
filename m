From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v6 2/4] scsi: ufs: adjust module reference for scsi host
Date: Mon,  4 May 2015 23:46:07 +0900
Message-ID: <1430750769-11405-3-git-send-email-akinobu.mita@gmail.com>
References: <1430750769-11405-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35004 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbEDOqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2015 10:46:35 -0400
Received: by pdbqd1 with SMTP id qd1so164998365pdb.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2015 07:46:34 -0700 (PDT)
In-Reply-To: <1430750769-11405-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/scsi/ufs/ufshcd-pci.c    | 1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 drivers/scsi/ufs/ufshcd.c        | 1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d15eaa4..9fe21b4 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -142,6 +142,7 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	hba->host->module = THIS_MODULE;
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index e6b29b1..d08e0bb 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -322,6 +322,7 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	hba->host->module = THIS_MODULE;
 	hba->vops = get_variant_ops(&pdev->dev);
 
 	err = ufshcd_parse_clock_info(hba);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 996030b..c499f16 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4237,7 +4237,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 }
 
 static struct scsi_host_template ufshcd_driver_template = {
-	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
-- 
1.9.1

