Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E285ECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB6DD21929
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ih5CqTgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbfJJIeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:34:04 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43238 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387421AbfJJIeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 04:34:03 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9A8Xnfc127748;
        Thu, 10 Oct 2019 03:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570696429;
        bh=kGuezWxP+bReGMiBtuHKQ2OgxAKcjmQPRtrZdJJzMNo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Ih5CqTgx+HkVx/we4i9HiOBhc+ckvjOFbZWKaWW4t+pyD0X7zddFmcYoJHANRDTxN
         EaT/B+dxU5hi0S5SwXvEvqbLWgXwwaon4QfQkM7vEscpM2jwcsnI3MLNyvWrMNANyd
         CWUJ6IpP7cGcQiOLPSfIuYkEzyFeP0V0aFr7MGzw=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9A8Xnhx124258
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Oct 2019 03:33:49 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 10
 Oct 2019 03:33:48 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 10 Oct 2019 03:33:45 -0500
Received: from a0132425.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9A8XaSb019061;
        Thu, 10 Oct 2019 03:33:45 -0500
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, <nsekhar@ti.com>
Subject: [PATCH v2 2/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
Date:   Thu, 10 Oct 2019 14:03:57 +0530
Message-ID: <20191010083357.28982-3-vigneshr@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083357.28982-1-vigneshr@ti.com>
References: <20191010083357.28982-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TI's J721e SoC has a Cadence UFS IP with a TI specific wrapper. This is
a minimal driver to configure the wrapper. It releases the UFS slave
device out of reset and sets up registers to indicate PHY reference
clock input frequency before probing child Cadence UFS driver.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---

v2: No change

 drivers/scsi/ufs/Kconfig        | 10 ++++
 drivers/scsi/ufs/Makefile       |  1 +
 drivers/scsi/ufs/ti-j721e-ufs.c | 90 +++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 drivers/scsi/ufs/ti-j721e-ufs.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 0b845ab7c3bf..d14c2243e02a 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -132,6 +132,16 @@ config SCSI_UFS_HISI
 	  Select this if you have UFS controller on Hisilicon chipset.
 	  If unsure, say N.
 
+config SCSI_UFS_TI_J721E
+	tristate "TI glue layer for Cadence UFS Controller"
+	depends on OF && HAS_IOMEM && (ARCH_K3 || COMPILE_TEST)
+	help
+	  This selects driver for TI glue layer for Cadence UFS Host
+	  Controller IP.
+
+	  Selects this if you have TI platform with UFS controller.
+	  If unsure, say N.
+
 config SCSI_UFS_BSG
 	bool "Universal Flash Storage BSG device node"
 	depends on SCSI_UFSHCD
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 2a9097939bcb..94c6c5d7334b 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
 obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
+obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
new file mode 100644
index 000000000000..a653bf1902f3
--- /dev/null
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com/
+//
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define UFS_SS_CTRL		0x4
+#define UFS_SS_RST_N_PCS	BIT(0)
+#define UFS_SS_CLK_26MHZ	BIT(4)
+
+static int ti_j721e_ufs_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	unsigned long clk_rate;
+	void __iomem *regbase;
+	struct clk *clk;
+	u32 reg = 0;
+	int ret;
+
+	regbase = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(regbase))
+		return PTR_ERR(regbase);
+
+	/* Select MPHY refclk frequency */
+	clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Cannot claim MPHY clock.\n");
+		return PTR_ERR(clk);
+	}
+	clk_rate = clk_get_rate(clk);
+	if (clk_rate == 26000000)
+		reg |= UFS_SS_CLK_26MHZ;
+	devm_clk_put(dev, clk);
+
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
+
+	/*  Take UFS slave device out of reset */
+	reg |= UFS_SS_RST_N_PCS;
+	writel(reg, regbase + UFS_SS_CTRL);
+
+	ret = of_platform_populate(pdev->dev.of_node, NULL, NULL,
+				   dev);
+	if (ret) {
+		dev_err(dev, "failed to populate child nodes %d\n", ret);
+		pm_runtime_put_sync(dev);
+	}
+
+	return ret;
+}
+
+static int ti_j721e_ufs_remove(struct platform_device *pdev)
+{
+	of_platform_depopulate(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id ti_j721e_ufs_of_match[] = {
+	{
+		.compatible = "ti,j721e-ufs",
+	},
+	{ },
+};
+
+static struct platform_driver ti_j721e_ufs_driver = {
+	.probe	= ti_j721e_ufs_probe,
+	.remove	= ti_j721e_ufs_remove,
+	.driver	= {
+		.name   = "ti-j721e-ufs",
+		.of_match_table = ti_j721e_ufs_of_match,
+	},
+};
+module_platform_driver(ti_j721e_ufs_driver);
+
+MODULE_AUTHOR("Vignesh Raghavendra <vigneshr@ti.com>");
+MODULE_DESCRIPTION("TI UFS host controller glue driver");
+MODULE_LICENSE("GPL v2");
-- 
2.23.0

