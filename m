Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE64C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 08:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060C7205CB
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 08:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgHYITe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 04:19:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:61045 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgHYITd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 04:19:33 -0400
IronPort-SDR: z5OEt4tTDHvp9pTl2LN67ZRv3cKJoip/E3Q1Tmc4KkNzZlR1Pi/wg/OzlcE5GmVl6gOQAaRa+7
 DfdVBZ2LO4qQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="143728909"
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="143728909"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 01:19:30 -0700
IronPort-SDR: 14pHFxSM1Xk8lRdRpWgAS8Jn3WeAa4x706y7+MpfaoUG2UWvuXW9BY/7zAlkjmy0RWZ4kFjmgG
 HH45A2y+OOKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="336432480"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.73])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Aug 2020 01:19:28 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs-pci: Add LTR support for Intel controllers
Date:   Tue, 25 Aug 2020 11:18:54 +0300
Message-Id: <20200825081854.7222-1-adrian.hunter@intel.com>
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
 drivers/scsi/ufs/ufshcd-pci.c | 122 +++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5a95a7bfbab0..e10f05013ae6 100644
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
@@ -44,20 +52,129 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
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
+static void ufs_intel_ltr_expose(struct ufs_hba *hba)
+{
+	struct intel_host *host = ufshcd_get_variant(hba);
+	struct dentry *dir = host->debugfs_root;
+	struct device *dev = hba->dev;
+
+	dev->power.set_latency_tolerance = intel_ltr_set;
+	dev_pm_qos_expose_latency_tolerance(dev);
+
+	intel_cache_ltr(hba);
+
+	debugfs_create_x32("active_ltr", 0444, dir, &host->active_ltr);
+	debugfs_create_x32("idle_ltr", 0444, dir, &host->idle_ltr);
+}
+
+static void ufs_intel_ltr_hide(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+
+	dev_pm_qos_hide_latency_tolerance(dev);
+	dev->power.set_latency_tolerance = NULL;
+}
+
+static int ufs_intel_common_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct intel_host *host;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+	ufshcd_set_variant(hba, host);
+	host->debugfs_root = debugfs_create_dir(dev_name(dev), NULL);
+	ufs_intel_ltr_expose(hba);
+	return 0;
+}
+
+static void ufs_intel_common_exit(struct ufs_hba *hba)
+{
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	debugfs_remove_recursive(host->debugfs_root);
+	ufs_intel_ltr_hide(hba);
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
 
@@ -162,6 +279,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	pci_set_drvdata(pdev, hba);
+
 	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
@@ -171,7 +290,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
-- 
2.17.1

