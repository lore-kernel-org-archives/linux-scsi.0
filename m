From: Pan Bian <bianpan201602@163.com>
Subject: [PATCH 1/1] scsi: 32-9xxx: fix improper return value on errors
Date: Sat,  3 Dec 2016 21:31:40 +0800
Message-ID: <1480771900-6610-1-git-send-email-bianpan201602@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

In function twa_probe(), returns the value of variable retval on error
paths. However, on some error paths, retval is not set to negative
errnos, and its value will keep 0. This patch fixes them.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/3w-9xxx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a56a7b2..1e9c7a1 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2040,6 +2040,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	if (twa_initialize_device_extension(tw_dev)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to initialize device extension");
+		retval = -ENODEV;
 		goto out_free_device_extension;
 	}
 
@@ -2062,6 +2063,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = ioremap(mem_addr, mem_len);
 	if (!tw_dev->base_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
+		retval = -ENOMEM;
 		goto out_release_mem_region;
 	}
 
@@ -2069,8 +2071,10 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (twa_reset_sequence(tw_dev, 0))
+	if (twa_reset_sequence(tw_dev, 0)) {
+		retval = -ENODEV;
 		goto out_iounmap;
+	}
 
 	/* Set host specific parameters */
 	if ((pdev->device == PCI_DEVICE_ID_3WARE_9650SE) ||
-- 
1.9.1
