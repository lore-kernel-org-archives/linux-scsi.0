Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3110AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 05:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377361AbiDDFwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 01:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbiDDFwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 01:52:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722C3326EB
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 22:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649051441; x=1680587441;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BYBwQffvi/+ysDS+ehbASNTaJcKw9nREUpAXUFqlVYU=;
  b=NiTSuX2+VqY62eoOtad8ZGsB0AFCHioX9+/M09KGwM5L+NiqYlH4Dmy4
   zUcHOQt6ZSUG0M2DUJUEzgitY5c0WZmKsDbbApSspDoPu3JOnwovXJ4Pw
   HJGcVLI1GLhWX/FtIekMMWjthrsEnsELTZz1n/QcIaH4UH4J2GGrovyox
   EpSR/QZY/EXOvdJN5EBNNkPt5OJR3zGupiLYA4l82W6QX79ZARsdN37Mc
   D/5f4VWju5t3siPfA0HcLB5Pb4VdoQabdE1IkMVuIfQ+6RORBxCoDX7UB
   jEA4oV20694Vno6gtE5nAn+L5QOm1hmlLD3vRn/JjvvLetQ2qN5QA6V/N
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="241031017"
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="241031017"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 22:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="504786171"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga003.jf.intel.com with ESMTP; 03 Apr 2022 22:50:39 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel MTL
Date:   Mon,  4 Apr 2022 08:50:38 +0300
Message-Id: <20220404055038.2208051-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add PCI ID and callbacks to support Intel Meteor Lake (MTL).

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f76692053ca1..e892b9feffb1 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -428,6 +428,12 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_intel_mtl_init(struct ufs_hba *hba)
+{
+	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
+	return ufs_intel_common_init(hba);
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -465,6 +471,16 @@ static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_mtl_init,
+	.exit			= ufs_intel_common_exit,
+	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
@@ -579,6 +595,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.25.1

