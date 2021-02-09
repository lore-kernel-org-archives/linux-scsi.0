Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD81C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7E864EB9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhBIG0G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:26:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:37175 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhBIGZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Feb 2021 01:25:24 -0500
IronPort-SDR: MBI6W8AgSej/AZ9ffwTCKcLo8BHMGPOrH90qRd5mHp6pJZc8aKMOAHnPgSC7G3YPeh1ZoCyi/Q
 5D8rggeRENKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245904366"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="245904366"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 22:24:44 -0800
IronPort-SDR: O4F4OmzKXgvycv2r781oHsiJhDKsT7SuUUYawavI1rK3amF72xk6JRrjpfUDSSgyDEZUL0JAb3
 e0bzgfP6qvZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="398681952"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by orsmga007.jf.intel.com with ESMTP; 08 Feb 2021 22:24:41 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V2 2/4] scsi: ufs: Add exception event definitions
Date:   Tue,  9 Feb 2021 08:24:35 +0200
Message-Id: <20210209062437.6954-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210209062437.6954-1-adrian.hunter@intel.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For readability and completeness, add exception event definitions.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index bf1897a72532..cb80b9670bfe 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -348,8 +348,14 @@ enum power_desc_param_offset {
 
 /* Exception event mask values */
 enum {
-	MASK_EE_STATUS		= 0xFFFF,
-	MASK_EE_URGENT_BKOPS	= (1 << 2),
+	MASK_EE_STATUS			= 0xFFFF,
+	MASK_EE_DYNCAP_EVENT		= BIT(0),
+	MASK_EE_SYSPOOL_EVENT		= BIT(1),
+	MASK_EE_URGENT_BKOPS		= BIT(2),
+	MASK_EE_TOO_HIGH_TEMP		= BIT(3),
+	MASK_EE_TOO_LOW_TEMP		= BIT(4),
+	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
+	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
 };
 
 /* Background operation status */
-- 
2.17.1

