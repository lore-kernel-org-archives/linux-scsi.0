Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEE3EB64D0
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 17:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbjFMRDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 13:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbjFMRDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 13:03:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC4183
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686675822; x=1718211822;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O3CQWZszT99rUkqHIh4iMrBofBOBQdyi+z2V+wOzVeo=;
  b=DQusQDwpTtaMGnnFmzqNoefv25W+hb4ZPRa9JFSjEMGI6hV0+2Yzof5V
   hTqLapk9PtLpmXYUvYLc35iobJQq0bpqXAY69uwaJs0oZ5SVnWdt1tDJ8
   +wA/r7tCNJzvybZVVjXvDefa/dFrnXCBDVjpHLjlWKBrXuGKeNRI/Wcgv
   pk0nfDZLoJdLTThOR/3rdV132Q/hnpoJELffikgU1T1eSxcVjJVeICr6E
   QSNPveq4IM7JdG1KQjOpXDJSF7/F+kwrGRlzPnHI9ipam5iWlAOiWib+Z
   PBVJe3lHjHR7RPG1d4TxnNSQiyBzvnp5j+/CL8o0uZfIuay7zg6RyqvLY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="424281753"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="424281753"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:03:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="824491436"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="824491436"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.251.212.213])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:03:39 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
Date:   Tue, 13 Jun 2023 20:03:27 +0300
Message-Id: <20230613170327.61186-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add PCI ID to support Intel Arrow Lake, same as MTL.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 38276dac8e52..cf3987773051 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -599,6 +599,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.34.1

