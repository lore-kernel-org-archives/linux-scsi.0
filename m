Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C357C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 13:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3412F60F6F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 13:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhJ0NIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:08:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:49295 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236323AbhJ0NIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 09:08:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="217326186"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="217326186"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 06:06:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="597352729"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 27 Oct 2021 06:06:15 -0700
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
Subject: [PATCH V8 0/1] scsi: ufs: Let devices remain runtime suspended during system suspend
Date:   Wed, 27 Oct 2021 16:06:13 +0300
Message-Id: <20211027130614.406985-1-adrian.hunter@intel.com>
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


Changes in V8:

      scsi: ufs: Fix runtime PM dependencies getting broken
	Dropped because superseded by "scsi: core: pm: Only runtime resume
	if necessary"

      scsi: ufs: Let devices remain runtime suspended during system suspend
	Updated commit message
	Re-based

Changes in V7:

      scsi: ufs: Fix error handler clear ua deadlock
	Dropped because superseded by "scsi: ufs: core: Stop clearing
	UNIT ATTENTIONS"

      scsi: ufs: Let devices remain runtime suspended during system suspend
	Re-based

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


Adrian Hunter (1):
      scsi: ufs: Let devices remain runtime suspended during system suspend

 drivers/scsi/ufs/ufs-hisi.c |  8 +++++++-
 drivers/scsi/ufs/ufshcd.c   | 45 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h   | 11 +++++++++++
 3 files changed, 58 insertions(+), 6 deletions(-)


Regards
Adrian
