Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AEBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 20:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhKXUpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:45:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:56978 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238347AbhKXUpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 15:45:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235190973"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235190973"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:42:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="607329048"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 24 Nov 2021 12:42:19 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V2] scsi: ufs: ufs-pci: Add support for Intel ADL
Date:   Wed, 24 Nov 2021 22:42:18 +0200
Message-Id: <20211124204218.1784559-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add PCI ID and callbacks to support Intel Alder Lake.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # v5.15+
---


Changes in V2:

    Spell out Alder Lake in the commit message.


 drivers/scsi/ufs/ufshcd-pci.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 51424557810d..f725248ba57f 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -421,6 +421,13 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 	return err;
 }
 
+static int ufs_intel_adl_init(struct ufs_hba *hba)
+{
+	hba->nop_out_timeout = 200;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	return ufs_intel_common_init(hba);
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -449,6 +456,15 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
+	.name			= "intel-pci",
+	.init			= ufs_intel_adl_init,
+	.exit			= ufs_intel_common_exit,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
@@ -563,6 +579,8 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.25.1

