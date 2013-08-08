From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 04/16] hpsa: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:07:15 +0800
Message-ID: <1375967235-19644-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:15123 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab3HHNKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 09:10:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com, Yijing Wang <wangyijing@huawei.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..05b31f1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4090,7 +4090,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
 	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
 		goto default_int_mode;
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
+	if (h->pdev->msix_cap) {
 		dev_info(&h->pdev->dev, "MSIX\n");
 		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
 						MAX_REPLY_QUEUES);
@@ -4110,7 +4110,7 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			goto default_int_mode;
 		}
 	}
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
+	if (h->pdev->msi_cap) {
 		dev_info(&h->pdev->dev, "MSI\n");
 		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
-- 
1.7.1


