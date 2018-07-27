From: Anton Vasilyev <vasilyev@ispras.ru>
Subject: [PATCH] scsi: 3ware: fix return 0 on the error path of probe
Date: Fri, 27 Jul 2018 16:51:57 +0300
Message-ID: <20180727135157.13051-1-vasilyev@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Anton Vasilyev <vasilyev@ispras.ru>, Adam Radford <aradford@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

tw_probe() returns 0 in case of fail of tw_initialize_device_extension(),
pci_resource_start() or tw_reset_sequence() and releases resources.
twl_probe() returns 0 in case of fail of twl_initialize_device_extension(),
pci_iomap() and twl_reset_sequence().
twa_probe() returns 0 in case of fail of tw_initialize_device_extension(),
ioremap() and twa_reset_sequence().


The patch adds retval initialization for these cases.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
 drivers/scsi/3w-9xxx.c | 6 +++++-
 drivers/scsi/3w-sas.c  | 3 +++
 drivers/scsi/3w-xxxx.c | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 99ba4a770406..27521fc3ef5a 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2038,6 +2038,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	if (twa_initialize_device_extension(tw_dev)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to initialize device extension");
+		retval = -ENOMEM;
 		goto out_free_device_extension;
 	}
 
@@ -2060,6 +2061,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = ioremap(mem_addr, mem_len);
 	if (!tw_dev->base_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
+		retval = -ENOMEM;
 		goto out_release_mem_region;
 	}
 
@@ -2067,8 +2069,10 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (twa_reset_sequence(tw_dev, 0))
+	if (twa_reset_sequence(tw_dev, 0)) {
+		retval = -ENOMEM;
 		goto out_iounmap;
+	}
 
 	/* Set host specific parameters */
 	if ((pdev->device == PCI_DEVICE_ID_3WARE_9650SE) ||
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index cf9f2a09b47d..40c1e6e64f58 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1594,6 +1594,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	if (twl_initialize_device_extension(tw_dev)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize device extension");
+		retval = -ENOMEM;
 		goto out_free_device_extension;
 	}
 
@@ -1608,6 +1609,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = pci_iomap(pdev, 1, 0);
 	if (!tw_dev->base_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
+		retval = -ENOMEM;
 		goto out_release_mem_region;
 	}
 
@@ -1617,6 +1619,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	/* Initialize the card */
 	if (twl_reset_sequence(tw_dev, 0)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed during probe");
+		retval = -ENOMEM;
 		goto out_iounmap;
 	}
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index f6179e3d6953..961ea6f7def8 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2280,6 +2280,7 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	if (tw_initialize_device_extension(tw_dev)) {
 		printk(KERN_WARNING "3w-xxxx: Failed to initialize device extension.");
+		retval = -ENOMEM;
 		goto out_free_device_extension;
 	}
 
@@ -2294,6 +2295,7 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = pci_resource_start(pdev, 0);
 	if (!tw_dev->base_addr) {
 		printk(KERN_WARNING "3w-xxxx: Failed to get io address.");
+		retval = -ENOMEM;
 		goto out_release_mem_region;
 	}
 
-- 
2.18.0
