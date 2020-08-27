Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD059C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91B8622BEA
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgH0HVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:21:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:9957 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgH0HVH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 03:21:07 -0400
IronPort-SDR: ZU+kEIkeQHThxgfYg4ZD1gxZW56GCsI/Ywy04dUg5CExByd9fOZF2APhI273jMdTVQlunez6aK
 81sfO2FCvLzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217983852"
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="217983852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 00:21:06 -0700
IronPort-SDR: 14hahzv+OKGNrnBo8GyTvqPQNzyAjiVb5Sx7ullWZnJrlmnWZV23RaHPAOAHg6I2pfrEvi6Zhy
 S1C4jSqZznpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="295632011"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.73])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2020 00:21:04 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
Date:   Thu, 27 Aug 2020 10:20:30 +0300
Message-Id: <20200827072030.24655-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Intel host controllers support the setting of latency tolerance.
Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
raw register values are also exposed via debugfs.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	Put debugfs code altogether


 drivers/scsi/ufs/ufshcd-pci.c | 127 +++++++++++++++++++++++++++++++++-
 1 file changed, 125 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5a95a7bfbab0..df3a564c3e33 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -13,6 +13,14 @@
 #include "ufshcd.h"
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_qos.h>
+#include <linux/debugfs.h>
+
+struct intel_host {
+	u32		active_ltr;
+	u32		idle_ltr;
+	struct dentry	*debugfs_root;
+};
 
 static int ufs_intel_disable_lcc(struct ufs_hba *hba)
 {
@@ -44,20 +52,134 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+#define INTEL_ACTIVELTR		0x804
+#define INTEL_IDLELTR		0x808
+
+#define INTEL_LTR_REQ		BIT(15)
+#define INTEL_LTR_SCALE_MASK	GENMASK(11, 10)
+#define INTEL_LTR_SCALE_1US	(2 << 10)
+#define INTEL_LTR_SCALE_32US	(3 << 10)
+#define INTEL_LTR_VALUE_MASK	GENMASK(9, 0)
+
+static void intel_cache_ltr(struct ufs_hba *hba)
+{
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	host->active_ltr = readl(hba->mmio_base + INTEL_ACTIVELTR);
+	host->idle_ltr = readl(hba->mmio_base + INTEL_IDLELTR);
+}
+
+static void intel_ltr_set(struct device *dev, s32 val)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct intel_host *host = ufshcd_get_variant(hba);
+	u32 ltr;
+
+	pm_runtime_get_sync(dev);
+
+	/*
+	 * Program latency tolerance (LTR) accordingly what has been asked
+	 * by the PM QoS layer or disable it in case we were passed
+	 * negative value or PM_QOS_LATENCY_ANY.
+	 */
+	ltr = readl(hba->mmio_base + INTEL_ACTIVELTR);
+
+	if (val == PM_QOS_LATENCY_ANY || val < 0) {
+		ltr &= ~INTEL_LTR_REQ;
+	} else {
+		ltr |= INTEL_LTR_REQ;
+		ltr &= ~INTEL_LTR_SCALE_MASK;
+		ltr &= ~INTEL_LTR_VALUE_MASK;
+
+		if (val > INTEL_LTR_VALUE_MASK) {
+			val >>= 5;
+			if (val > INTEL_LTR_VALUE_MASK)
+				val = INTEL_LTR_VALUE_MASK;
+			ltr |= INTEL_LTR_SCALE_32US | val;
+		} else {
+			ltr |= INTEL_LTR_SCALE_1US | val;
+		}
+	}
+
+	if (ltr == host->active_ltr)
+		goto out;
+
+	writel(ltr, hba->mmio_base + INTEL_ACTIVELTR);
+	writel(ltr, hba->mmio_base + INTEL_IDLELTR);
+
+	/* Cache the values into intel_host structure */
+	intel_cache_ltr(hba);
+out:
+	pm_runtime_put(dev);
+}
+
+static void intel_ltr_expose(struct device *dev)
+{
+	dev->power.set_latency_tolerance = intel_ltr_set;
+	dev_pm_qos_expose_latency_tolerance(dev);
+}
+
+static void intel_ltr_hide(struct device *dev)
+{
+	dev_pm_qos_hide_latency_tolerance(dev);
+	dev->power.set_latency_tolerance = NULL;
+}
+
+static void intel_add_debugfs(struct ufs_hba *hba)
+{
+	struct dentry *dir = debugfs_create_dir(dev_name(hba->dev), NULL);
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	intel_cache_ltr(hba);
+
+	host->debugfs_root = dir;
+	debugfs_create_x32("active_ltr", 0444, dir, &host->active_ltr);
+	debugfs_create_x32("idle_ltr", 0444, dir, &host->idle_ltr);
+}
+
+static void intel_remove_debugfs(struct ufs_hba *hba)
+{
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	debugfs_remove_recursive(host->debugfs_root);
+}
+
+static int ufs_intel_common_init(struct ufs_hba *hba)
+{
+	struct intel_host *host;
+
+	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+	ufshcd_set_variant(hba, host);
+	intel_ltr_expose(hba->dev);
+	intel_add_debugfs(hba);
+	return 0;
+}
+
+static void ufs_intel_common_exit(struct ufs_hba *hba)
+{
+	intel_remove_debugfs(hba);
+	intel_ltr_hide(hba->dev);
+}
+
 static int ufs_intel_ehl_init(struct ufs_hba *hba)
 {
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
-	return 0;
+	return ufs_intel_common_init(hba);
 }
 
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
+	.init			= ufs_intel_common_init,
+	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 };
 
 static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_ehl_init,
+	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 };
 
@@ -162,6 +284,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	pci_set_drvdata(pdev, hba);
+
 	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
@@ -171,7 +295,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
-- 
2.17.1

