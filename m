From: Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH][RESEND] Fusion MPT: disable pci device when mpt map resoures failed
Date: Sat, 11 Aug 2012 10:58:36 +0800
Message-ID: <1344653916-7832-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:48105 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2HKDDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2012 23:03:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>


when probe a pci device, first we enable it, and disable it when
some error happened in the following process, because the power
state of the device is set to D0, and if MSI is disabled,
we will allocate irq and register gsi for this device in the enable process.

In function mpt_mapresources(MPT_ADAPTER *ioc), it forgot disable the
pci device when error happened, the irq and gsi will never be released.
this patch will fix it.

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/message/fusion/mptbase.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d99db56..fb69baa 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1666,7 +1666,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
 		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
 		    "MEM failed\n", ioc->name);
-		return r;
+		goto out_pci_disable_device;
 	}
 
 	if (sizeof(dma_addr_t) > 4) {
@@ -1690,8 +1690,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		} else {
 			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
 			    ioc->name, pci_name(pdev));
-			pci_release_selected_regions(pdev, ioc->bars);
-			return r;
+			goto out_pci_release_region;
 		}
 	} else {
 		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
@@ -1704,8 +1703,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		} else {
 			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
 			    ioc->name, pci_name(pdev));
-			pci_release_selected_regions(pdev, ioc->bars);
-			return r;
+			goto out_pci_release_region;
 		}
 	}
 
@@ -1735,8 +1733,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	if (mem == NULL) {
 		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
 			" memory!\n", ioc->name);
-		pci_release_selected_regions(pdev, ioc->bars);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_pci_release_region;
 	}
 	ioc->memmap = mem;
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
@@ -1750,6 +1748,12 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
 
 	return 0;
+
+out_pci_release_region:
+	pci_release_selected_regions(pdev, ioc->bars);
+out_pci_disable_device:
+	pci_disable_device(pdev);
+	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-- 
1.7.6.1


