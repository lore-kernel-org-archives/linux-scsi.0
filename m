From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 08/11] scsi: ufs: adjust module reference for scsi host
Date: Mon, 19 Jan 2015 00:06:06 +0900
Message-ID: <1421593569-5089-9-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40698 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:07:01 -0500
Received: by mail-pa0-f46.google.com with SMTP id lf10so33528122pab.5
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:07:00 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

The ufs support consists with the core driver (ufshcd) and the actual
glue driver (ufshcd-pci or ufshcd-pltfrm).  The module reference of
this scsi host is initialized to the core driver's one.  Because the
glue drivers use ufshcd_alloc_host() which is defined in ufshcd module
and calls scsi_host_alloc().  So the glue drivers can be unloaded even
if the scsi device is being accessed.

This fixes it by converting ufshcd_alloc_host() into macro so that the
glue drivers can pass their correct module reference through
__scsi_host_alloc().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 13 +++++++------
 drivers/scsi/ufs/ufshcd.h |  5 ++++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2e26025..59a4855 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4202,7 +4202,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 }
 
 static struct scsi_host_template ufshcd_driver_template = {
-	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
@@ -5256,12 +5255,14 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
+ * __ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
+ * @owner: module which will be the owner of the scsi host
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
+int __ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle,
+			struct module *owner)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
@@ -5274,8 +5275,8 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		goto out_error;
 	}
 
-	host = scsi_host_alloc(&ufshcd_driver_template,
-				sizeof(struct ufs_hba));
+	host = __scsi_host_alloc(&ufshcd_driver_template,
+				sizeof(struct ufs_hba), owner);
 	if (!host) {
 		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
@@ -5289,7 +5290,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 out_error:
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_alloc_host);
+EXPORT_SYMBOL(__ufshcd_alloc_host);
 
 static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4a574aa..ac7d72f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -515,7 +515,10 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 	ufshcd_writel(hba, tmp, reg);
 }
 
-int ufshcd_alloc_host(struct device *, struct ufs_hba **);
+int __ufshcd_alloc_host(struct device *, struct ufs_hba **,
+			struct module *owner);
+#define ufshcd_alloc_host(dev, hba_handle) \
+	__ufshcd_alloc_host(dev, hba_handle, THIS_MODULE)
 int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
 
-- 
1.9.1

