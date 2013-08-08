From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 11/16] pm8001: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:10:21 +0800
Message-ID: <1375967421-26540-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:28657 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934237Ab3HHNKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 09:10:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com, Yijing Wang <wangyijing@huawei.com>, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: xjtuwjp@gmail.com
Cc: lindar_liu@usish.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3861aa1..1ee61e8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -734,7 +734,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 	pdev = pm8001_ha->pdev;
 
 #ifdef PM8001_USE_MSIX
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
+	if (pdev->msix_cap)
 		return pm8001_setup_msix(pm8001_ha);
 	else {
 		PM8001_INIT_DBG(pm8001_ha,
-- 
1.7.1


