Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB2EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AB460F12
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbhIEJwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 05:52:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:45314 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhIEJwb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 5 Sep 2021 05:52:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10097"; a="219779261"
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="219779261"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 02:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="468519253"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.174])
  by orsmga007.jf.intel.com with ESMTP; 05 Sep 2021 02:51:25 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V3 0/3] scsi: ufs: Let devices remain runtime suspended during system suspend
Date:   Sun,  5 Sep 2021 12:51:50 +0300
Message-Id: <20210905095153.6217-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

UFS devices can remain runtime suspended at system suspend time,
if the conditions are right.  Add support for that, first fixing
the impediments.


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

 drivers/scsi/scsi_pm.c      | 16 ++++++---
 drivers/scsi/ufs/ufs-hisi.c |  8 ++++-
 drivers/scsi/ufs/ufshcd.c   | 87 +++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h   | 12 ++++++-
 include/scsi/scsi_device.h  |  1 +
 5 files changed, 90 insertions(+), 34 deletions(-)


Regards
Adrian
