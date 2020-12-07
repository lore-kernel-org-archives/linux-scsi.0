Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE83C0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3413E22ADF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgLGIcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 03:32:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:13254 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgLGIcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 03:32:32 -0500
IronPort-SDR: SDmEUkXlomrCCxfL8QxFAidXOWypC3FlcrpcSYy7gChyeV87ymo8FGTpop2letfLSSPLcgzGYj
 cOly/OgOe0ag==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="161432211"
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="161432211"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 00:31:52 -0800
IronPort-SDR: y6wbGilWuAaNA3Jo0anaRb+6xJ35613dCBEan3DV/OcUQftTccLnxHow7BYRwJ4pFo73sQf/rD
 LEY2R0qB/HUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="332024915"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2020 00:31:49 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 1/4] scsi: ufs-pci: Fix restore from S4 for Intel controllers
Date:   Mon,  7 Dec 2020 10:31:17 +0200
Message-Id: <20201207083120.26732-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207083120.26732-1-adrian.hunter@intel.com>
References: <20201207083120.26732-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, ufshcd-pci is the only UFS driver with support for
suspend-to-disk PM callbacks (i.e. freeze/thaw/restore/poweroff). These
callbacks are set by the macro SET_SYSTEM_SLEEP_PM_OPS to the same
functions as system suspend/resume. That will work with spm_lvl 5 because
spm_lvl 5 will result in a full restore for the ->restore() callback.
In the absence of a full restore, the host controller registers will
have values set up by the restore kernel (the kernel that boots and
loads the restore image) which are not necessarily the same. However it
turns out, the only registers that sometimes need restore are the base
address registers. This has gone un-noticed because, depending on IOMMU
settings, the kernel can end up allocating the same addresses every
time.

For Intel controllers, an spm_lvl other than 5 can be used, so to support
S4 (suspend-to-disk) with spm_lvl other than 5, restore the base address
registers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index df3a564c3e33..360c25f1f061 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -163,6 +163,24 @@ static void ufs_intel_common_exit(struct ufs_hba *hba)
 	intel_ltr_hide(hba->dev);
 }
 
+static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
+{
+	/*
+	 * To support S4 (suspend-to-disk) with spm_lvl other than 5, the base
+	 * address registers must be restored because the restore kernel can
+	 * have used different addresses.
+	 */
+	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_H);
+	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_H);
+	return 0;
+}
+
 static int ufs_intel_ehl_init(struct ufs_hba *hba)
 {
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
@@ -174,6 +192,7 @@ static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.init			= ufs_intel_common_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
@@ -181,6 +200,7 @@ static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.init			= ufs_intel_ehl_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.17.1

