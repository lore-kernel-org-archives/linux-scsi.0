Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83526C76195
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 10:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjC1K7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 06:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjC1K7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 06:59:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C372AA
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 03:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680001162; x=1711537162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AgWi3JlZLtYHgT0occJn8x2V6aEoaNyo1HaFua2QQ5s=;
  b=GKR6ePBYmr6D98sp66G+F+MoF662FEXQAjNa5QuMMkCD/aqURN31W1oL
   JqfTLDdDEzygmlOqtst/dWxW4wcAD0BdN9tp6dh11niqg8kLbKHVpiSWk
   bSiBl/JVDYmuOSJVDEEF81yKn1pTB1OcGOP4cRee72O9V/P5PWCZRwHoP
   CxZs4WQ/LG6DrwQeaCxg+EUKgioNWf9aT/QpQZjslAta+RlRrPl/jwCNh
   uruMNFujwFm4G/um4EH7ptKpRhFTz0YmaVYbZiaVA6qwISdTp2j91PvOt
   yQkySpBx6rrvYAWEtpGOgSYfxThe3QCbd0QXdWJTEd+2pwFjGvCEUaVPV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320935153"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="320935153"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:59:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="716452645"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="716452645"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.249.32.11])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:59:19 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Lunar Lake
Date:   Tue, 28 Mar 2023 13:58:32 +0300
Message-Id: <20230328105832.3495-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add PCI ID to support Intel Lunar Lake, same as MTL.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 1c91f43e15c8..9c911787f84c 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -607,6 +607,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.34.1

