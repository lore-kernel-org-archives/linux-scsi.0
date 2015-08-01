From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 6/6] scsi: ufs: fix module reference for scsi host
Date: Sun,  2 Aug 2015 02:19:20 +0900
Message-ID: <1438449560-4106-7-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34699 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:20:04 -0400
Received: by pdbbh15 with SMTP id bh15so56483330pdb.1
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:20:03 -0700 (PDT)
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

While accessing a UFS device, the module reference count for core driver
(ufshcd) is incremented but not incremented for the actual glue driver
(ufshcd-pci or ufshcd-pltfrm).  Because these drivers allocate scsi hosts
with scsi_host_template defined in ufshcd module.  So these drivers always
can be unloaded.

This fixes it by preparing scsi host template which is initialized at
module_init() for each ufs glue driver.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pci.c    | 19 +++++++++++++++++--
 drivers/scsi/ufs/ufshcd-pltfrm.c | 19 +++++++++++++++++--
 drivers/scsi/ufs/ufshcd.c        | 19 +++++++++++++++----
 drivers/scsi/ufs/ufshcd.h        |  5 ++++-
 4 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d15eaa4..961c4ad 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -106,6 +106,8 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	ufshcd_remove(hba);
 }
 
+static struct scsi_host_template ufshcd_pci_host_template;
+
 /**
  * ufshcd_pci_probe - probe routine of the driver
  * @pdev: pointer to PCI device handle
@@ -136,7 +138,7 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mmio_base = pcim_iomap_table(pdev)[0];
 
-	err = ufshcd_alloc_host(&pdev->dev, &hba);
+	err = ufshcd_alloc_host(&pdev->dev, &ufshcd_pci_host_template, &hba);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
 		return err;
@@ -183,7 +185,20 @@ static struct pci_driver ufshcd_pci_driver = {
 	},
 };
 
-module_pci_driver(ufshcd_pci_driver);
+static int __init ufshcd_pci_driver_init(void)
+{
+	ufshcd_host_template_init(&ufshcd_pci_host_template, "ufshcd-pci",
+				  THIS_MODULE);
+
+	return pci_register_driver(&ufshcd_pci_driver);
+}
+module_init(ufshcd_pci_driver_init);
+
+static void __exit ufshcd_pci_driver_exit(void)
+{
+	pci_unregister_driver(&ufshcd_pci_driver);
+}
+module_exit(ufshcd_pci_driver_exit);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 12f1246..2a137c2 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -287,6 +287,8 @@ static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
 	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
 }
 
+static struct scsi_host_template ufshcd_pltfrm_host_template;
+
 /**
  * ufshcd_pltfrm_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle
@@ -315,7 +317,7 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	err = ufshcd_alloc_host(dev, &hba);
+	err = ufshcd_alloc_host(dev, &ufshcd_pltfrm_host_template, &hba);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
 		goto out;
@@ -400,7 +402,20 @@ static struct platform_driver ufshcd_pltfrm_driver = {
 	},
 };
 
-module_platform_driver(ufshcd_pltfrm_driver);
+static int __init ufshcd_pltfrm_driver_init(void)
+{
+	ufshcd_host_template_init(&ufshcd_pltfrm_host_template, "ufshcd-pltfrm",
+				  THIS_MODULE);
+
+	return platform_driver_register(&ufshcd_pltfrm_driver);
+}
+module_init(ufshcd_pltfrm_driver_init);
+
+static void __exit ufshcd_pltfrm_driver_exit(void)
+{
+	platform_driver_unregister(&ufshcd_pltfrm_driver);
+}
+module_exit(ufshcd_pltfrm_driver_exit);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d287207..6fa64bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4338,7 +4338,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	ufshcd_probe_hba(hba);
 }
 
-static struct scsi_host_template ufshcd_driver_template = {
+static const struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
@@ -4359,6 +4359,16 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.track_queue_depth	= 1,
 };
 
+void ufshcd_host_template_init(struct scsi_host_template *sht, const char *name,
+			       struct module *owner)
+{
+	*sht = ufshcd_driver_template;
+	sht->name = name;
+	sht->proc_name = name;
+	sht->module = owner;
+}
+EXPORT_SYMBOL_GPL(ufshcd_host_template_init);
+
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 				   int ua)
 {
@@ -5388,10 +5398,12 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
+ * @sht: scsi_host_template to use when registering the host
  * @hba_handle: driver private handle
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
+int ufshcd_alloc_host(struct device *dev, struct scsi_host_template *sht,
+		      struct ufs_hba **hba_handle)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
@@ -5404,8 +5416,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		goto out_error;
 	}
 
-	host = scsi_host_alloc(&ufshcd_driver_template,
-				sizeof(struct ufs_hba));
+	host = scsi_host_alloc(sht, sizeof(struct ufs_hba));
 	if (!host) {
 		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c40a0e7..cad15b0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -575,7 +575,10 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 	ufshcd_writel(hba, tmp, reg);
 }
 
-int ufshcd_alloc_host(struct device *, struct ufs_hba **);
+void ufshcd_host_template_init(struct scsi_host_template *sht, const char *name,
+			       struct module *owner);
+int ufshcd_alloc_host(struct device *, struct scsi_host_template *,
+		      struct ufs_hba **);
 int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
 
-- 
1.9.1

