Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040D4C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D340164F86
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhCLIG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:06:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:26158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231379AbhCLIGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 03:06:15 -0500
IronPort-SDR: wGzF89r+Uk4Hqr4ixcsQHHkwoI4MAMG4r8OMb4a+BclSA5uWnuv92b/zusKQ+DBKHosrfFGwwP
 +0d1TeUJOgYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="185445881"
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="185445881"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 00:06:14 -0800
IronPort-SDR: n2vta9C5gd0SvtO6JCj1byaejDfiiDk264LGZcrd5+Nb4ahnZYa9yy9GENQ0eOTGDh37HYiRCJ
 AV5DHjpTKyuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="409779481"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2021 00:06:11 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs-pci: Add support for Intel LKF
Date:   Fri, 12 Mar 2021 10:06:20 +0200
Message-Id: <20210312080620.13311-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add PCI ID and callbacks to support Intel LKF.

This includes the ability to use an ACPI device-specific method (DSM) to
perform a UFS device reset.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 169 ++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index fadd566025b8..23ee828747e2 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -15,13 +15,89 @@
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
 #include <linux/debugfs.h>
+#include <linux/uuid.h>
+#include <linux/acpi.h>
+#include <linux/gpio/consumer.h>
+
+struct ufs_host {
+	void (*late_init)(struct ufs_hba *hba);
+};
+
+enum {
+	INTEL_DSM_FNS		=  0,
+	INTEL_DSM_RESET		=  1,
+};
 
 struct intel_host {
+	struct ufs_host ufs_host;
+	u32		dsm_fns;
 	u32		active_ltr;
 	u32		idle_ltr;
 	struct dentry	*debugfs_root;
+	struct gpio_desc *reset_gpio;
 };
 
+static const guid_t intel_dsm_guid =
+	GUID_INIT(0x1A4832A0, 0x7D03, 0x43CA,
+		  0xB0, 0x20, 0xF6, 0xDC, 0xD1, 0x2A, 0x19, 0x50);
+
+static int __intel_dsm(struct intel_host *intel_host, struct device *dev,
+		       unsigned int fn, u32 *result)
+{
+	union acpi_object *obj;
+	int err = 0;
+	size_t len;
+
+	obj = acpi_evaluate_dsm(ACPI_HANDLE(dev), &intel_dsm_guid, 0, fn, NULL);
+	if (!obj)
+		return -EOPNOTSUPP;
+
+	if (obj->type != ACPI_TYPE_BUFFER || obj->buffer.length < 1) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	len = min_t(size_t, obj->buffer.length, 4);
+
+	*result = 0;
+	memcpy(result, obj->buffer.pointer, len);
+out:
+	ACPI_FREE(obj);
+
+	return err;
+}
+
+static int intel_dsm(struct intel_host *intel_host, struct device *dev,
+		     unsigned int fn, u32 *result)
+{
+	if (fn > 31 || !(intel_host->dsm_fns & (1 << fn)))
+		return -EOPNOTSUPP;
+
+	return __intel_dsm(intel_host, dev, fn, result);
+}
+
+static void intel_dsm_init(struct intel_host *intel_host, struct device *dev)
+{
+	int err;
+
+	err = __intel_dsm(intel_host, dev, INTEL_DSM_FNS, &intel_host->dsm_fns);
+	dev_dbg(dev, "DSM fns %#x, error %d\n", intel_host->dsm_fns, err);
+}
+
+static int ufs_intel_hce_enable_notify(struct ufs_hba *hba,
+				       enum ufs_notify_change_status status)
+{
+	/* Cannot enable ICE until after HC enable */
+	if (status == POST_CHANGE && hba->caps & UFSHCD_CAP_CRYPTO) {
+		u32 hce = ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
+
+		hce |= CRYPTO_GENERAL_ENABLE;
+		ufshcd_writel(hba, hce, REG_CONTROLLER_ENABLE);
+	}
+
+	return 0;
+}
+
 static int ufs_intel_disable_lcc(struct ufs_hba *hba)
 {
 	u32 attr = UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE);
@@ -144,6 +220,41 @@ static void intel_remove_debugfs(struct ufs_hba *hba)
 	debugfs_remove_recursive(host->debugfs_root);
 }
 
+static int ufs_intel_device_reset(struct ufs_hba *hba)
+{
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	if (host->dsm_fns & INTEL_DSM_RESET) {
+		u32 result = 0;
+		int err;
+
+		err = intel_dsm(host, hba->dev, INTEL_DSM_RESET, &result);
+		if (!err && !result)
+			err = -EIO;
+		if (err)
+			dev_err(hba->dev, "%s: DSM error %d result %u\n",
+				__func__, err, result);
+		return err;
+	}
+
+	if (!host->reset_gpio)
+		return -EOPNOTSUPP;
+
+	gpiod_set_value_cansleep(host->reset_gpio, 1);
+	usleep_range(10, 15);
+
+	gpiod_set_value_cansleep(host->reset_gpio, 0);
+	usleep_range(10, 15);
+
+	return 0;
+}
+
+static struct gpio_desc *ufs_intel_get_reset_gpio(struct device *dev)
+{
+	/* GPIO in _DSD has active low setting */
+	return devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+}
+
 static int ufs_intel_common_init(struct ufs_hba *hba)
 {
 	struct intel_host *host;
@@ -154,6 +265,23 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 	if (!host)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, host);
+	intel_dsm_init(host, hba->dev);
+	if (host->dsm_fns & INTEL_DSM_RESET) {
+		if (hba->vops->device_reset)
+			hba->caps |= UFSHCD_CAP_DEEPSLEEP;
+	} else {
+		if (hba->vops->device_reset)
+			host->reset_gpio = ufs_intel_get_reset_gpio(hba->dev);
+		if (IS_ERR(host->reset_gpio)) {
+			dev_err(hba->dev, "%s: failed to get reset GPIO, error %ld\n",
+				__func__, PTR_ERR(host->reset_gpio));
+			host->reset_gpio = NULL;
+		}
+		if (host->reset_gpio) {
+			gpiod_set_value_cansleep(host->reset_gpio, 0);
+			hba->caps |= UFSHCD_CAP_DEEPSLEEP;
+		}
+	}
 	intel_ltr_expose(hba->dev);
 	intel_add_debugfs(hba);
 	return 0;
@@ -206,6 +334,31 @@ static int ufs_intel_ehl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static void ufs_intel_lkf_late_init(struct ufs_hba *hba)
+{
+	/* LKF always needs a full reset, so set PM accordingly */
+	if (hba->caps & UFSHCD_CAP_DEEPSLEEP) {
+		hba->spm_lvl = UFS_PM_LVL_6;
+		hba->rpm_lvl = UFS_PM_LVL_6;
+	} else {
+		hba->spm_lvl = UFS_PM_LVL_5;
+		hba->rpm_lvl = UFS_PM_LVL_5;
+	}
+}
+
+static int ufs_intel_lkf_init(struct ufs_hba *hba)
+{
+	struct ufs_host *ufs_host;
+	int err;
+
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->caps |= UFSHCD_CAP_CRYPTO;
+	err = ufs_intel_common_init(hba);
+	ufs_host = ufshcd_get_variant(hba);
+	ufs_host->late_init = ufs_intel_lkf_late_init;
+	return err;
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -222,6 +375,16 @@ static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.resume			= ufs_intel_resume,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_lkf_init,
+	.exit			= ufs_intel_common_exit,
+	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
@@ -321,6 +484,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 static int
 ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	struct ufs_host *ufs_host;
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
 	int err;
@@ -358,6 +522,10 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	ufs_host = ufshcd_get_variant(hba);
+	if (ufs_host && ufs_host->late_init)
+		ufs_host->late_init(hba);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
@@ -383,6 +551,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.17.1

