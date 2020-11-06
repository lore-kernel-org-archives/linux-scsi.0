Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C841C55178
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 15:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 331BA22203
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 15:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgKFPgc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 10:36:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:57396 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgKFPgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Nov 2020 10:36:32 -0500
IronPort-SDR: koEp/a+Km8W80Z3Sb8XSf3dTUkVj/iMu5+A/aduW+1B0N0JIn+7MG+TNBDa/jdD/bFXKZSxdoK
 f8c/ggSdDkeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169668852"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169668852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 07:36:31 -0800
IronPort-SDR: +r0cLRJLKwxqP2I0IhVXTW/KGYHtXRBj79d1s0Vhl/PMKu5eoj3FxPc5xGd0b19fGbFIKzzFoi
 W44NJbqTEMtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="364207970"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Nov 2020 07:36:29 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     linux-doc@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode
Date:   Fri,  6 Nov 2020 17:36:15 +0200
Message-Id: <20201106153615.13033-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A patch for DeepSleep is in the scsi queue, but as per mkp:

	I left out the sysfs ABI piece due to the conflicts.
	I suggest you send that piece through the doc tree.

Ergo this patch.

Link: https://lore.kernel.org/r/yq1imaksb3g.fsf@ca-mkp.ca.oracle.com/
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
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

