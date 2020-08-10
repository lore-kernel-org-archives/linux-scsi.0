Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38E0C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 14:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5F920748
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 14:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgHJOKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 10:10:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:26993 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgHJOKy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 10:10:54 -0400
IronPort-SDR: CPPCG61qqBDgzRpQpjBem41k0k/9sYzaMPw5VkRCD3x+NrFVnVookMO4wXBBU8Kg+HDnFAbRT6
 1bEdQWAEumOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="150972010"
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="150972010"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 07:10:52 -0700
IronPort-SDR: cOSmziu7AJHV7CDP+4ORH1JJP+n7zflvx1lxc/WXEoB1qYJamMwjpfvxMfhInwRmjB/4V+1bEF
 cPlrTvThb2zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="494804839"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.73])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2020 07:10:50 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL
Date:   Mon, 10 Aug 2020 17:10:24 +0300
Message-Id: <20200810141024.28859-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Intel EHL UFS host controller advertises auto-hibernate capability but it
does not work correctly. Add a quirk for that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 8c09d75276971 ("scsi: ufshdc-pci: Add Intel PCI IDs for EHL")
---
 drivers/scsi/ufs/ufshcd-pci.c | 16 ++++++++++++++--
 drivers/scsi/ufs/ufshcd.h     |  9 ++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f407b13883ac..5a95a7bfbab0 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -44,11 +44,23 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_ehl_init(struct ufs_hba *hba)
+{
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	return 0;
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_ehl_init,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+};
+
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
@@ -177,8 +189,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b2ef18f1b746..87eb0794e239 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -520,6 +520,12 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * auto-hibernate capability but it doesn't work.
+	 */
+	UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8		= 1 << 11,
 };
 
 enum ufshcd_caps {
@@ -803,7 +809,8 @@ return true;
 
 static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
 {
-	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
+	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) &&
+	        !(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
 }
 
 static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
-- 
2.17.1

