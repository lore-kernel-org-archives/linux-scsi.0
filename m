Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB99AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C471D61528
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350978AbhI3MoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:44:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:37546 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350675AbhI3MoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 08:44:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="205327576"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="205327576"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 05:42:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="479879755"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 30 Sep 2021 05:42:37 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V6 0/3] scsi: ufs: Let devices remain runtime suspended during system suspend
Date:   Thu, 30 Sep 2021 15:42:21 +0300
Message-Id: <20210930124224.114031-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

UFS devices can remain runtime suspended at system suspend time,
if the conditions are right.  Add support for that, first fixing
the impediments.

Changes in V6:

      scsi: ufs: Fix error handler clear ua deadlock
	Ensure data byte count bits 1:0 are 11b
	Use ufshcd_compose_dev_cmd() to set up command

Changes in V5:

      scsi: ufs: Fix error handler clear ua deadlock
	Update commit message
	Try to abort REQUEST SENSE if it times out

Changes in V4:

      scsi: ufs: Fix error handler clear ua deadlock

	Do request-sense directly

Changes in V3:

      scsi: ufs: Fix error handler clear ua deadlock

	Correct commit message.
	Amend stable tags to add dependent cherry picks

Changes in V2:

    scsi: ufs: Let devices remain runtime suspended during system suspend

	The ufs-hisi driver uses different RPM and SPM, but it is made
	explicit by a new parameter to suspend prepare.


Adrian Hunter (3):
      scsi: ufs: Fix error handler clear ua deadlock
      scsi: ufs: Fix runtime PM dependencies getting broken
      scsi: ufs: Let devices remain runtime suspended during system suspend

 drivers/scsi/scsi_pm.c      |  16 ++-
 drivers/scsi/ufs/ufs-hisi.c |   8 +-
 drivers/scsi/ufs/ufs.h      |   3 +-
 drivers/scsi/ufs/ufshcd.c   | 296 ++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h   |  24 +++-
 include/scsi/scsi_device.h  |   1 +
 include/trace/events/ufs.h  |   5 +-
 7 files changed, 251 insertions(+), 102 deletions(-)


Regards
Adrian
