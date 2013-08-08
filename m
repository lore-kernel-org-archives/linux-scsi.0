From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 07/16] mpt3sas: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:08:37 +0800
Message-ID: <1375967317-33424-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:8936 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261Ab3HHNJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 09:09:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com, Yijing Wang <wangyijing@huawei.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5dc280c..e756191 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1520,11 +1520,9 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 static int
 _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
-	int base;
 	u16 message_control;
 
-	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
-	if (!base) {
+	if (!ioc->pdev->msix_cap) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT "msix not supported\n",
 			ioc->name));
 		return -EINVAL;
@@ -1532,7 +1530,8 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 
 	/* get msix vector count */
 
-	pci_read_config_word(ioc->pdev, base + 2, &message_control);
+	pci_read_config_word(ioc->pdev, ioc->pdev->msix_cap + 2,
+			&message_control);
 	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
 	if (ioc->msix_vector_count > 8)
 		ioc->msix_vector_count = 8;
-- 
1.7.1


