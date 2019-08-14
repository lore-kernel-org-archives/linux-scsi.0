Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2F2C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4971020679
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfHNNBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:01:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:51527 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbfHNNBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 09:01:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 06:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,385,1559545200"; 
   d="scan'208";a="200867409"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.122])
  by fmsmga004.fm.intel.com with ESMTP; 14 Aug 2019 06:00:58 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>
Subject: [PATCH] scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
Date:   Wed, 14 Aug 2019 15:59:50 +0300
Message-Id: <20190814125950.22850-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following BUG:

  [ 187.065689] BUG: kernel NULL pointer dereference, address: 000000000000001c
  [ 187.065790] RIP: 0010:ufshcd_vreg_set_hpm+0x3c/0x110 [ufshcd_core]
  [ 187.065938] Call Trace:
  [ 187.065959] ufshcd_resume+0x72/0x290 [ufshcd_core]
  [ 187.065980] ufshcd_system_resume+0x54/0x140 [ufshcd_core]
  [ 187.065993] ? pci_pm_restore+0xb0/0xb0
  [ 187.066005] ufshcd_pci_resume+0x15/0x20 [ufshcd_pci]
  [ 187.066017] pci_pm_thaw+0x4c/0x90
  [ 187.066030] dpm_run_callback+0x5b/0x150
  [ 187.066043] device_resume+0x11b/0x220

Voltage regulators are optional, so functions must check they exist
before dereferencing.

Note this issue is hidden if CONFIG_REGULATORS is not set, because the
offending code is optimised away.

Notes for stable:

The issue first appears in commit 57d104c153d3 ("ufs: add UFS power
management support") but is inadvertently fixed in commit 60f0187031c0
("scsi: ufs: disable vccq if it's not needed by UFS device") which in
turn was reverted by commit 730679817d83 ("Revert "scsi: ufs: disable vccq
if it's not needed by UFS device""). So fix applies v3.18 to v4.5 and
v5.1+

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Fixes: 730679817d83 ("Revert "scsi: ufs: disable vccq if it's not needed by UFS device"")
Cc: stable@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 507fd51e8039..219c435d69a7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7105,6 +7105,9 @@ static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
-- 
2.17.1

