From: vinholikatti@gmail.com
Subject: [PATCH V6 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Tue,  5 Feb 2013 22:17:36 +0530
Message-ID: <511137e1.0657420a.5b57.ffffa804@mx.google.com>
References: <1360082857-3317-1-git-send-email-y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:51949 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3BEQsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 11:48:35 -0500
In-Reply-To: <1360082857-3317-1-git-send-email-y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, saugata.das@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, vinholikatti@gmail.com

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch adds Platform glue driver for ufshcd.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Reviewed-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig         |   11 ++
 drivers/scsi/ufs/Makefile        |    1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c |  217 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 0371047..35faf24 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -57,3 +57,14 @@ config SCSI_UFSHCD_PCI
 	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config SCSI_UFSHCD_PLATFORM
+	tristate "Platform bus based UFS Controller support"
+	depends on SCSI_UFSHCD
+	---help---
+	This selects the UFS host controller support. Select this if
+	you have an UFS controller on Platform bus.
+
+	If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9eda0df..1e5bd48 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,3 +1,4 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
+obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
new file mode 100644
index 0000000..a661b31
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -0,0 +1,217 @@
+/*
+ * Universal Flash Storage Host controller Platform bus based glue driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
+ * Copyright (C) 2011-2013 Samsung India Software Operations
+ *
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
+ */
+
+#include "ufshcd.h"
+#include <linux/platform_device.h>
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_pltfrm_suspend - suspend power management function
+ * @pdev: pointer to Platform device handle
+ * @mesg: power state
+ *
+ * Returns 0
+ */
+static int ufshcd_pltfrm_suspend(struct platform_device *pdev,
+				 pm_message_t mesg)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_suspend
+	 * 2. Do bus specific power management
+	 */
+
+	disable_irq(hba->irq);
+
+	return 0;
+}
+
+/**
+ * ufshcd_pltfrm_resume - resume power management function
+ * @pdev: pointer to Platform device handle
+ *
+ * Returns 0
+ */
+static int ufshcd_pltfrm_resume(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_resume.
+	 * 2. Do bus specific wake up
+	 */
+
+	enable_irq(hba->irq);
+
+	return 0;
+}
+#else
+#define ufshcd_pltfrm_suspend	NULL
+#define ufshcd_pltfrm_resume	NULL
+#endif
+
+/**
+ * ufshcd_pltfrm_probe - probe routine of the driver
+ * @pdev: pointer to Platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devinit
+ufshcd_pltfrm_probe(struct platform_device *pdev)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	struct resource *mem_res;
+	struct resource *irq_res;
+	resource_size_t mem_size;
+	int err;
+	struct device *dev = &pdev->dev;
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev,
+			"Memory resource not available\n");
+		err = -ENODEV;
+		goto out_error;
+	}
+
+	mem_size = resource_size(mem_res);
+	if (!request_mem_region(mem_res->start, mem_size, "ufshcd")) {
+		dev_err(&pdev->dev,
+			"Cannot reserve the memory resource\n");
+		err = -EBUSY;
+		goto out_error;
+	}
+
+	mmio_base = ioremap_nocache(mem_res->start, mem_size);
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "memory map failed\n");
+		err = -ENOMEM;
+		goto out_release_regions;
+	}
+
+	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq_res) {
+		dev_err(&pdev->dev, "IRQ resource not available\n");
+		err = -ENODEV;
+		goto out_iounmap;
+	}
+
+	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
+	if (err) {
+		dev_err(&pdev->dev, "set dma mask failed\n");
+		goto out_iounmap;
+	}
+
+	err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
+	if (err) {
+		dev_err(&pdev->dev, "Intialization failed\n");
+		goto out_iounmap;
+	}
+
+	platform_set_drvdata(pdev, hba);
+
+	return 0;
+
+out_iounmap:
+	iounmap(mmio_base);
+out_release_regions:
+	release_mem_region(mem_res->start, mem_size);
+out_error:
+	return err;
+}
+
+/**
+ * ufshcd_pltfrm_remove - remove platform driver routine
+ * @pdev: pointer to platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devexit ufshcd_pltfrm_remove(struct platform_device *pdev)
+{
+	struct resource *mem_res;
+	resource_size_t mem_size;
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	disable_irq(hba->irq);
+
+	/* Some buggy controllers raise interrupt after
+	 * the resources are removed. So first we unregister the
+	 * irq handler and then the resources used by driver
+	 */
+
+	free_irq(hba->irq, hba);
+	ufshcd_remove(hba);
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res)
+		dev_err(&pdev->dev, "ufshcd: Memory resource not available\n");
+	else {
+		mem_size = resource_size(mem_res);
+		release_mem_region(mem_res->start, mem_size);
+	}
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static const struct of_device_id ufs_of_match[] = {
+	{ .compatible = "jedec,ufs-1.1"},
+};
+
+static const struct dev_pm_ops ufshcd_dev_pm_ops = {
+	.suspend	= ufshcd_pltfrm_suspend,
+	.resume		= ufshcd_pltfrm_resume,
+};
+
+static struct platform_driver ufshcd_pltfrm_driver = {
+	.probe	= ufshcd_pltfrm_probe,
+	.remove	= __devexit_p(ufshcd_pltfrm_remove),
+	.driver	= {
+		.name	= "ufshcd",
+		.owner	= THIS_MODULE,
+		.pm	= &ufshcd_dev_pm_ops,
+		.of_match_table = ufs_of_match,
+	},
+};
+
+module_platform_driver(ufshcd_pltfrm_driver);
+
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_DESCRIPTION("UFS host controller Pltform bus based glue driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
1.7.5.4

