From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 12/16] pmcraid: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:10:29 +0800
Message-ID: <1375967429-35912-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:28721 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab3HHNKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 09:10:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com, Yijing Wang <wangyijing@huawei.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b02..d5b3315 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4678,8 +4678,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	int rc;
 	struct pci_dev *pdev = pinstance->pdev;
 
-	if ((pmcraid_enable_msix) &&
-		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
+	if (pmcraid_enable_msix && pdev->msix_cap) {
 		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
 		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
 		int i;
-- 
1.7.1


