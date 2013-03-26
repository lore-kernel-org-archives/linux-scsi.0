From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] isci: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Tue, 26 Mar 2013 16:01:38 +0900
Message-ID: <001a01ce29ef$c3350f00$499f2d00$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32475 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3CZHBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Mar 2013 03:01:40 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MK900HVNA6HBVG0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 26 Mar 2013 16:01:39 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/scsi/isci/init.c:725:12: warning: 'isci_suspend' defined but not used [-Wunused-function]
drivers/scsi/isci/init.c:743:12: warning: 'isci_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/isci/init.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 2839baa..d25d0d8 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -721,7 +721,7 @@ static void isci_pci_remove(struct pci_dev *pdev)
 	}
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int isci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -770,18 +770,16 @@ static int isci_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(isci_pm_ops, isci_suspend, isci_resume);
-#endif
 
 static struct pci_driver isci_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= isci_id_table,
 	.probe		= isci_pci_probe,
 	.remove		= isci_pci_remove,
-#ifdef CONFIG_PM
 	.driver.pm      = &isci_pm_ops,
-#endif
 };
 
 static __init int isci_init(void)
-- 
1.7.2.5


