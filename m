Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA57C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C6A22BE8
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgLGIcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 03:32:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:13251 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLGIcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 03:32:46 -0500
IronPort-SDR: Cs0tu3KhERXuoAp37vTrldmXb7r45nfWeJUgJ9Q2WcLPO4H+ma594e4qxvQZ9zwL9mmG7OuVG1
 czLg7n6kU0hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="161432223"
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="161432223"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 00:31:58 -0800
IronPort-SDR: zEB0OS12rZDdLeqnnQGsqpfyFhrVzz1eP+0fUTZDPYjokj3IJDhy9aKWux4Sm2En/HVLa75q9D
 Us4PcmqxOuVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="332024934"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2020 00:31:55 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 3/4] scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
Date:   Mon,  7 Dec 2020 10:31:19 +0200
Message-Id: <20201207083120.26732-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207083120.26732-1-adrian.hunter@intel.com>
References: <20201207083120.26732-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Intel controllers can end up in an unrecoverable state after a hibernate
exit error unless a full reset and restore is done before anything else.
Force that to happen.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5d33c39fa82f..888d8c9ca3a5 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -178,6 +178,23 @@ static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 		      REG_UTP_TASK_REQ_LIST_BASE_L);
 	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
 		      REG_UTP_TASK_REQ_LIST_BASE_H);
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		int ret = ufshcd_uic_hibern8_exit(hba);
+
+		if (!ret) {
+			ufshcd_set_link_active(hba);
+		} else {
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+				__func__, ret);
+			/*
+			 * Force reset and restore. Any other actions can lead
+			 * to an unrecoverable state.
+			 */
+			ufshcd_set_link_off(hba);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1

