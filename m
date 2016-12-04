From: Pan Bian <bianpan201603@163.com>
Subject: [PATCH 1/1] scsi: 3w-sas: set errno on failures
Date: Sun,  4 Dec 2016 13:36:26 +0800
Message-ID: <1480829786-4725-1-git-send-email-bianpan201603@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:36784 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbcLDFiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Dec 2016 00:38:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

From: Pan Bian <bianpan2016@163.com>

On some error paths (e.g. pci_iomap() returns a NULL pointer), the value
of return variable retval is 0. 0 means no error. This patch fixes the
bug, set retval with negative errno on error paths.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189001

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/3w-sas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f837485..65b42b4 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1600,6 +1600,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	if (twl_initialize_device_extension(tw_dev)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize device extension");
+		retval = -ENODEV;
 		goto out_free_device_extension;
 	}
 
@@ -1614,6 +1615,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	tw_dev->base_addr = pci_iomap(pdev, 1, 0);
 	if (!tw_dev->base_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
+		retval = -ENOMEM;
 		goto out_release_mem_region;
 	}
 
@@ -1623,6 +1625,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	/* Initialize the card */
 	if (twl_reset_sequence(tw_dev, 0)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed during probe");
+		retval = -ENODEV;
 		goto out_iounmap;
 	}
 
-- 
1.9.1


