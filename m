Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CD8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 15:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29682250E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 15:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbhADPve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:51:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:39821 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbhADPvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 10:51:33 -0500
IronPort-SDR: FD8BL12+IT2NZgesGqsKgE9WnZiGHpL1I50sNxQ7yj+BCpu/Zlo5HTfzO8Kk9g2cCvatTTbbts
 xcg/reeWJsCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="241053131"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241053131"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 07:50:44 -0800
IronPort-SDR: mlzO7HhaOfOsx3UeYuSpgsvWRDZqZRKXSTvrbyieyA7f/VhR/gkUGdYJCgztbcpaCJ9grbY3lm
 IcCW40IYk23g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="569394156"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jan 2021 07:50:41 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V2] docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode
Date:   Mon,  4 Jan 2021 17:50:26 +0200
Message-Id: <20210104155026.16417-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update sysfs documentation for addition of DeepSleep power mode.

Fixes: fe1d4c2ebcae ("scsi: ufs: Add DeepSleep feature")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	Amended commit messages and added Fixes tag, since DeepSleep
	is now in v5.11-rc1


 Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++++---------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index adc0d0e91607..e77fa784d6d8 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -916,21 +916,24 @@ Date:		September 2014
 Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry could be used to set or show the UFS device
 		runtime power management level. The current driver
-		implementation supports 6 levels with next target states:
+		implementation supports 7 levels with next target states:
 
 		==  ====================================================
-		0   an UFS device will stay active, an UIC link will
+		0   UFS device will stay active, UIC link will
 		    stay active
-		1   an UFS device will stay active, an UIC link will
+		1   UFS device will stay active, UIC link will
 		    hibernate
-		2   an UFS device will moved to sleep, an UIC link will
+		2   UFS device will be moved to sleep, UIC link will
 		    stay active
-		3   an UFS device will moved to sleep, an UIC link will
+		3   UFS device will be moved to sleep, UIC link will
 		    hibernate
-		4   an UFS device will be powered off, an UIC link will
+		4   UFS device will be powered off, UIC link will
 		    hibernate
-		5   an UFS device will be powered off, an UIC link will
+		5   UFS device will be powered off, UIC link will
 		    be powered off
+		6   UFS device will be moved to deep sleep, UIC link
+		will be powered off. Note, deep sleep might not be
+		supported in which case this value will not be accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
@@ -954,21 +957,24 @@ Date:		September 2014
 Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry could be used to set or show the UFS device
 		system power management level. The current driver
-		implementation supports 6 levels with next target states:
+		implementation supports 7 levels with next target states:
 
 		==  ====================================================
-		0   an UFS device will stay active, an UIC link will
+		0   UFS device will stay active, UIC link will
 		    stay active
-		1   an UFS device will stay active, an UIC link will
+		1   UFS device will stay active, UIC link will
 		    hibernate
-		2   an UFS device will moved to sleep, an UIC link will
+		2   UFS device will be moved to sleep, UIC link will
 		    stay active
-		3   an UFS device will moved to sleep, an UIC link will
+		3   UFS device will be moved to sleep, UIC link will
 		    hibernate
-		4   an UFS device will be powered off, an UIC link will
+		4   UFS device will be powered off, UIC link will
 		    hibernate
-		5   an UFS device will be powered off, an UIC link will
+		5   UFS device will be powered off, UIC link will
 		    be powered off
+		6   UFS device will be moved to deep sleep, UIC link
+		will be powered off. Note, deep sleep might not be
+		supported in which case this value will not be accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
-- 
2.17.1

