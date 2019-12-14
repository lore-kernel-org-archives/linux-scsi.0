Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D0DC43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 13:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA6F7206B7
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 13:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vph04PJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLNNEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 08:04:32 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:31466 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbfLNNEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 08:04:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576328671; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=4eglewSQw9JKvQb9QmMPuYevi4dBPK/F62BRlODWg0c=; b=vph04PJW3cL7tq0KSh1+CCBjwsoYth2cwkf7l4PUeTW3QHda3oojEuiAHYAYDdp2E0VBOuir
 QXRtW9CPpPVM6y7jx1viOBkoMNjEEu56z0zNHFIZdIqAWJlZMiOUTxxPzY0ioFgPVaSH4EGz
 lpxypv6s2cwEfjiecHR1dY5KzCY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df4dddd.7f4d4af83618-smtp-out-n03;
 Sat, 14 Dec 2019 13:04:29 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B7129C447A9; Sat, 14 Dec 2019 13:04:29 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 939DBC43383;
        Sat, 14 Dec 2019 13:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 939DBC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] scsi: ufs: Modularize ufs-bsg
Date:   Sat, 14 Dec 2019 05:03:35 -0800
Message-Id: <1576328616-30404-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to improve the flexibility of ufs-bsg, modularizing it is a good
choice. This change introduces tristate to ufs-bsg to allow users compile
it as an external module.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index d14c224..d43655a 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -143,7 +143,7 @@ config SCSI_UFS_TI_J721E
 	  If unsure, say N.
 
 config SCSI_UFS_BSG
-	bool "Universal Flash Storage BSG device node"
+	tristate "Universal Flash Storage BSG device node"
 	depends on SCSI_UFSHCD
 	select BLK_DEV_BSGLIB
 	help
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d..904eff1 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
-ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+obj-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 3a2e68f..9c49b4e 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2018 Western Digital Corporation
  */
+#include <linux/platform_device.h>
 #include "ufs_bsg.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
@@ -158,53 +159,45 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 /**
  * ufs_bsg_remove - detach and remove the added ufs-bsg node
- * @hba: per adapter object
+ * @pdev: Pointer to platform device handle
  *
- * Should be called when unloading the driver.
+ * Return zero for success and non-zero for failure
  */
-void ufs_bsg_remove(struct ufs_hba *hba)
+static int ufs_bsg_remove(struct platform_device *pdev)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
+	struct ufs_hba *hba;
+
+	hba = (struct ufs_hba *)pdev->dev.platform_data;
+	if (!hba)
+		return -ENODEV;
 
 	if (!hba->bsg_queue)
-		return;
+		return 0;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
-	device_del(bsg_dev);
-	put_device(bsg_dev);
-}
-
-static inline void ufs_bsg_node_release(struct device *dev)
-{
-	put_device(dev->parent);
+	return 0;
 }
 
 /**
- * ufs_bsg_probe - Add ufs bsg device node
- * @hba: per adapter object
+ * ufs_bsg_probe - Probe routine of the driver
+ * @pdev: Pointer to platform device handle
  *
- * Called during initial loading of the driver, and before scsi_scan_host.
+ * Return zero for success and non-zero for failure
  */
-int ufs_bsg_probe(struct ufs_hba *hba)
+static int ufs_bsg_probe(struct platform_device *pdev)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
-	struct Scsi_Host *shost = hba->host;
-	struct device *parent = &shost->shost_gendev;
+	struct ufs_hba *hba;
+	struct device *bsg_dev;
 	struct request_queue *q;
 	int ret;
 
-	device_initialize(bsg_dev);
-
-	bsg_dev->parent = get_device(parent);
-	bsg_dev->release = ufs_bsg_node_release;
-
-	dev_set_name(bsg_dev, "ufs-bsg");
-
-	ret = device_add(bsg_dev);
-	if (ret)
-		goto out;
+	hba = (struct ufs_hba *)pdev->dev.platform_data;
+	if (!hba)
+		return -ENODEV;
 
+	bsg_dev = &pdev->dev;
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
@@ -216,7 +209,19 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	return 0;
 
 out:
-	dev_err(bsg_dev, "fail to initialize a bsg dev %d\n", shost->host_no);
-	put_device(bsg_dev);
+	dev_err(bsg_dev, "fail to initialize bsg node, err %d\n", ret);
 	return ret;
 }
+
+static struct platform_driver ufs_bsg_driver = {
+	.probe = ufs_bsg_probe,
+	.remove = ufs_bsg_remove,
+	.driver = {
+		.name = "ufs-bsg",
+	},
+};
+
+module_platform_driver(ufs_bsg_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:ufs-bsg");
diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/scsi/ufs/ufs_bsg.h
index d099187..9d922c0 100644
--- a/drivers/scsi/ufs/ufs_bsg.h
+++ b/drivers/scsi/ufs/ufs_bsg.h
@@ -12,12 +12,4 @@
 #include "ufshcd.h"
 #include "ufs.h"
 
-#ifdef CONFIG_SCSI_UFS_BSG
-void ufs_bsg_remove(struct ufs_hba *hba);
-int ufs_bsg_probe(struct ufs_hba *hba);
-#else
-static inline void ufs_bsg_remove(struct ufs_hba *hba) {}
-static inline int ufs_bsg_probe(struct ufs_hba *hba) {return 0; }
-#endif
-
 #endif /* UFS_BSG_H */
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 76f9be7..90dc399 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -393,6 +393,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	void __iomem *mmio_base;
 	int irq, err;
 	struct device *dev = &pdev->dev;
+	struct platform_device *bsg_pdev;
 
 	mmio_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(mmio_base)) {
@@ -440,6 +441,17 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
+	bsg_pdev = platform_device_register_data(dev, "ufs-bsg",
+						 hba->host->host_no, hba,
+						 sizeof(struct ufs_hba));
+	/* Failure here is non-fatal */
+	if (IS_ERR(bsg_pdev)) {
+		err = PTR_ERR(bsg_pdev);
+		dev_warn(dev, "Register bsg platform device failed %d\n", err);
+	} else {
+		hba->bsg_pdev = bsg_pdev;
+	}
+
 	return 0;
 
 dealloc_host:
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a86b0fd..0160cc3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -42,6 +42,7 @@
 #include <linux/nls.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/platform_device.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -2093,6 +2094,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	ufshcd_release(hba);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_send_uic_cmd);
 
 /**
  * ufshcd_map_sg - Map scatter-gather list to prdt
@@ -6024,6 +6026,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
 
 /**
  * ufshcd_eh_device_reset_handler - device reset handler registered to
@@ -7043,9 +7046,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			}
 			hba->clk_scaling.is_allowed = true;
 		}
-
-		ufs_bsg_probe(hba);
-
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
@@ -8248,7 +8248,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-	ufs_bsg_remove(hba);
+	platform_device_unregister(hba->bsg_pdev);
 	ufs_sysfs_remove_nodes(hba->dev);
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2740f69..dd86404 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -734,7 +734,7 @@ struct ufs_hba {
 	struct ufs_desc_size desc_size;
 	atomic_t scsi_block_reqs_cnt;
 
-	struct device		bsg_dev;
+	struct platform_device	*bsg_pdev;
 	struct request_queue	*bsg_queue;
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
