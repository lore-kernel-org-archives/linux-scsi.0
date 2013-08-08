From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 06/16] mpt2sas: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:08:27 +0800
Message-ID: <1375967307-20392-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:14822 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHNIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 09:08:47 -0400
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
 drivers/scsi/mpt2sas/mpt2sas_base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ccd6d5a..35c3676 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1217,7 +1217,6 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 static int
 _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 {
-	int base;
 	u16 message_control;
 
 
@@ -1228,8 +1227,7 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 		return -EINVAL;
 	}
 
-	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
-	if (!base) {
+	if (!ioc->pdev->msix_cap) {
 		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "msix not "
 		    "supported\n", ioc->name));
 		return -EINVAL;
@@ -1246,7 +1244,8 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2116_2)
 		ioc->msix_vector_count = 1;
 	else {
-		pci_read_config_word(ioc->pdev, base + 2, &message_control);
+		pci_read_config_word(ioc->pdev, ioc->pdev->msix_cap + 2,
+				&message_control);
 		ioc->msix_vector_count = (message_control & 0x3FF) + 1;
 	}
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
-- 
1.7.1


