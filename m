Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFC1C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F91D611AC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFWHjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:19 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1666 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFWHiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:38:54 -0400
IronPort-SDR: PlpHPaV9G+9LPrjqzmJmTpxGlFQcvHyvVTCXoiOcZZKlSN6UI5h6yhhvHk2ZwdXfwUYgAIKElC
 kER9fK+WPngqcDx/BT6vN5k77fsts5KLVRt8PYh23JK6UKCmjSkOCpKMdTlyNj8uno7/qB1ybF
 RczCTkrnoptCLDrhDcw9XxhcoPO/sg5VqmY9sYLRSSm0J4PRR7Q/iSTZiDprxaNWHDQmEIWnyT
 dlxA0Jr3I1IXHndoaC/8+KZTknowdhhtVJZEIqMkRsQo+19J8Cbie2Jrsspv04cNxko4ZAIBSB
 3iw=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="29780817"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:36:36 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:36:35 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E013121BC1; Wed, 23 Jun 2021 00:36:35 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v4 00/10] Complementary changes for error handling
Date:   Wed, 23 Jun 2021 00:34:59 -0700
Message-Id: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit cb7e6f05fce67c965194ac04467e1ba7bc70b069 ("scsi: ufs: core: Enable
power management for wlun") makes the UFS device W-LU the supplier, based
on which we need to make some changes to accomodate error handling.

This series is tested by fault injections (to IRQ handler, UIC cmds and
task abort where error handler can possibley be invoked) in all possible
contexts, e.g., scaling, gating, runtime and system suspend/resume.

Below changes are tested as a whole and based on 5.14/scsi-staging.

Changes from v3:
- Split the first change in v2 into 2 changes (to address comments from Adrian)
- Removed the host_sem used in suspend/resume and use lock/unlock_system_sleep() in error handler (suggested by Bart).

Changes from v2:
- Added 3 more changes to this series.

Changes from v1:
- Rebased on series "Optimize host lock on TR send/compl paths and utilize UTRLCNR".
- Minor update to the 6th change.

Can Guo (10):
  scsi: ufs: Rename flags pm_op_in_progress and is_sys_suspended
  scsi: ufs: Add flags pm_op_in_progress and is_sys_suspended
  scsi: ufs: Update the return value of supplier pm ops
  scsi: ufs: Enable IRQ after enabling clocks in error handling
    preparation
  scsi: ufs: Remove a redundant tag check in ufshcd_queuecommand()
  scsi: ufs: Remove host_sem used in suspend/resume
  scsi: ufs: Simplify error handling preparation
  scsi: ufs: Update ufshcd_recover_pm_error()
  scsi: ufs: Update the fast abort path in ufshcd_abort() for PM
    requests
  scsi: ufs: Apply more limitations to user access

 drivers/scsi/ufs/ufs-debugfs.c |  27 +----
 drivers/scsi/ufs/ufs-qcom.c    |   2 +-
 drivers/scsi/ufs/ufs-sysfs.c   | 105 ++++++-----------
 drivers/scsi/ufs/ufs_bsg.c     |  16 +--
 drivers/scsi/ufs/ufshcd.c      | 262 ++++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h      |  25 +++-
 6 files changed, 212 insertions(+), 225 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

