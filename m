Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B390BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 19:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 774596024A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 19:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhCATYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 14:24:43 -0500
Received: from mga04.intel.com ([192.55.52.120]:41210 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236332AbhCATWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 14:22:33 -0500
IronPort-SDR: 7R0A/rd9L2LsHIfJEcAuf/cBCNtEpe0Db0HAeVS1q1ixvQKD/ICvrzSGma17WUkZFhQM+ReA0f
 npnAsxiyY6DQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184133972"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="184133972"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 11:19:29 -0800
IronPort-SDR: arpXN5RRLSPAWd7Ewkk+EhwhjGceiKoQQv9gwC8a/X5MwhfJoyKI9NwYxVPOue0QH+fpzyROyC
 a3AGBNWtfjMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="427031988"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga004.fm.intel.com with ESMTP; 01 Mar 2021 11:19:27 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after ufshcd_reset_and_restore()
Date:   Mon,  1 Mar 2021 21:19:40 +0200
Message-Id: <20210301191940.15247-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
however, if it is called again, as it is within a loop in
ufshcd_reset_and_restore(), and succeeds, then it will not set the state
back to UFSHCD_STATE_OPERATIONAL unless the state was
UFSHCD_STATE_RESET.

That can result in the state being UFSHCD_STATE_ERROR even though
ufshcd_reset_and_restore() is successful and returns zero.

Fix by initializing the state to UFSHCD_STATE_RESET in the start of each
loop in ufshcd_reset_and_restore().  If there is an error,
ufshcd_reset_and_restore() will change the state to UFSHCD_STATE_ERROR,
otherwise ufshcd_probe_hba() will have set the state appropriately.

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77161750c9fb..91a403afe038 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	do {
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
+
 		/* Reset the attached device */
 		ufshcd_device_reset(hba);
 
-- 
2.17.1

