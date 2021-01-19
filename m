Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4E5C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7E222CAD
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbhASXHs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 18:07:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:24134 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395357AbhASORN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 09:17:13 -0500
IronPort-SDR: VLBjqwI9I2oiOkaxUaZy8bSlQX2Rj1+HGsTYt9Y4F2W4LWllUu/VifteQ5nlvWamQV5ypeADgY
 IUOlXe6OqNrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="158704789"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="158704789"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 06:15:40 -0800
IronPort-SDR: Dnqod0Yp7Qpga45GQeKJSJk6Aq4E9GR4s6K0z+VhJOsxz0jy0YqtuPUjVbpgwR9q2cz/ARzqXX
 7buV+2qDLw7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="347189908"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.149])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2021 06:15:37 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 0/4] scsi: ufs-debugfs: Add UFS Exception Event reporting
Date:   Tue, 19 Jan 2021 16:15:38 +0200
Message-Id: <20210119141542.3808-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Here are patches to add a tracepoint for UFS Exception Events and to allow
users to enable specific exception events without affecting the driver's
use of exception events.


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
