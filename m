From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH 05/16] megaraid: clean up unnecessary MSI/MSI-X
 capability find
Date: Fri, 16 Aug 2013 11:40:19 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A00DC559@inbmail01.lsi.com>
References: <1375967264-25644-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5198
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab3HPGK2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 02:10:28 -0400
In-Reply-To: <1375967264-25644-1-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, "jiang.liu@huawei.com" <jiang.liu@huawei.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>-----Original Message-----
>From: Yijing Wang [mailto:wangyijing@huawei.com]
>Sent: Thursday, August 08, 2013 6:38 PM
>To: James E.J. Bottomley
>Cc: Hanjun Guo; jiang.liu@huawei.com; Yijing Wang; DL-MegaRAID Linux;
>linux-scsi@vger.kernel.org
>Subject: [PATCH 05/16] megaraid: clean up unnecessary MSI/MSI-X
>capability find
>
>PCI core will initialize device MSI/MSI-X capability in
>pci_msi_init_pci_dev(). So device driver should use pci_dev-
>>msi_cap/msix_cap to determine whether the device support MSI/MSI-X
>instead of using pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
>Access to PCIe device config space again will consume more time.
>
>Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
>Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>Cc: linux-scsi@vger.kernel.org
>---
> drivers/scsi/megaraid/megaraid_sas_base.c |    9 ++++-----
> 1 files changed, 4 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 0177295..ad8fc44 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4072,21 +4072,20 @@ fail_set_dma_mask:
> static int megasas_probe_one(struct pci_dev *pdev,
> 			     const struct pci_device_id *id)  {
>-	int rval, pos, i, j;
>+	int rval, i, j;
> 	struct Scsi_Host *host;
> 	struct megasas_instance *instance;
> 	u16 control = 0;
>
> 	/* Reset MSI-X in the kdump kernel */
> 	if (reset_devices) {
>-		pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
>-		if (pos) {
>-			pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS,
>+		if (pdev->msix_cap) {
>+			pci_read_config_word(pdev, pdev->msix_cap +
>PCI_MSIX_FLAGS,
> 					     &control);
> 			if (control & PCI_MSIX_FLAGS_ENABLE) {
> 				dev_info(&pdev->dev, "resetting MSI-X\n");
> 				pci_write_config_word(pdev,
>-						      pos + PCI_MSIX_FLAGS,
>+						      pdev->msix_cap +
>PCI_MSIX_FLAGS,
> 						      control &
> 						      ~PCI_MSIX_FLAGS_ENABLE);
> 			}
>--
>1.7.1
>
>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>


Sumit


