Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAF5C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F35064E8C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 06:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhBIG0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:26:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:37168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhBIGZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Feb 2021 01:25:20 -0500
IronPort-SDR: ZHj4i/RB6o/zF4TvEHt2Yt1XHoAaVX4/Buq+nCcu5jAgbvFDXtAsWwI22MfFavlmvSRw835+e8
 GnCwf4Q9PLGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245904362"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="245904362"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 22:24:38 -0800
IronPort-SDR: rFhM6d2jyaZAITfd/ARuYEQ9kL1PMazbr9zTRnID6C/X0xWaZUr4EfKjR7KdJZukmHR+b8l+/Y
 bCAzsrcetgUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="398681940"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by orsmga007.jf.intel.com with ESMTP; 08 Feb 2021 22:24:35 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V2 0/4] scsi: ufs-debugfs: Add UFS Exception Event reporting
Date:   Tue,  9 Feb 2021 08:24:33 +0200
Message-Id: <20210209062437.6954-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Here are V2 patches to add a tracepoint for UFS Exception Events and to
allow users to enable specific exception events without affecting the
driver's use of exception events.


Changes in V2:

    scsi: ufs: Add exception event tracepoint
	Change status field from "exception event status" to "status"

    scsi: ufs: Add exception event definitions
	Add Reviewed-by: Bean Huo


Adrian Hunter (4):
      scsi: ufs: Add exception event tracepoint
      scsi: ufs: Add exception event definitions
      scsi: ufs-debugfs: Add user-defined exception_event_mask
      scsi: ufs-debugfs: Add user-defined exception event rate limiting

 drivers/scsi/ufs/ufs-debugfs.c | 90 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  2 +
 drivers/scsi/ufs/ufs.h         | 10 ++++-
 drivers/scsi/ufs/ufshcd.c      | 87 +++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h      | 26 +++++++++++-
 include/trace/events/ufs.h     | 21 ++++++++++
 6 files changed, 201 insertions(+), 35 deletions(-)


Regards
Adrian
