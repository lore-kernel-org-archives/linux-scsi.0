Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC0CC0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA25522B3B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLGIcs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 03:32:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:13254 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLGIcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 03:32:48 -0500
IronPort-SDR: eHQJWv3IvLn9LQOr1HuNu/YUNJGmSurVufRCmSrHt3AVN3zHlNuPVg06tDZP8Y2mnue+0jLsri
 yfECtr7Qwmyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="161432228"
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="161432228"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 00:32:00 -0800
IronPort-SDR: JjxdfrRNaKQ7m6Nnlggyqm8cdDzxp8ceH3Zb8CXbU1Hp8cu119VRdfF7+Zc9BJl1eVqg1gV7MS
 9EuwPjzrzxiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="332024960"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2020 00:31:58 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 4/4] scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers
Date:   Mon,  7 Dec 2020 10:31:20 +0200
Message-Id: <20201207083120.26732-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207083120.26732-1-adrian.hunter@intel.com>
References: <20201207083120.26732-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Enable runtime PM auto-suspend by default for Intel host controllers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 888d8c9ca3a5..fadd566025b8 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -148,6 +148,8 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 {
 	struct intel_host *host;
 
+	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
-- 
2.17.1

