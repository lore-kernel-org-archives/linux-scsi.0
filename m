Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03F8C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00DA613BD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFJEpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:45:46 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1214 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFJEpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:45:45 -0400
IronPort-SDR: GG15Mw1zJvm/ZUMB0rREMhK46GYjXwWz85pkuPIE76XecjmBr+hJ562NHjb3wr2QghPapze2ue
 UTN5uRsI//JldqUl99PizZDrdf8ekpB0bxZnYnkJAh7K6LcoTQXzlEd02SEll5YuCVZBNQn1Ik
 UQkU26vMARlBUwwy4LHWgNX/YTLviiKR0Wd0psX7GEqijDDBveWheS6hEP0lIS5tp45GsB7obY
 Y+H044Pj64cVQNZ4SYnNF+OXayutdQwsnMigeG0ntldU+igEXnO+PvS4yRrvnBiJwm5oTclJnL
 eeo=
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="47893345"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 09 Jun 2021 21:43:50 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 09 Jun 2021 21:43:49 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id DCCCE21AF7; Wed,  9 Jun 2021 21:43:49 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/9] Complementary changes for error handling
Date:   Wed,  9 Jun 2021 21:43:28 -0700
Message-Id: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
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

Changes from v2:
- Added 3 more changes to this series.

Changes from v1:
- Rebased on series "Optimize host lock on TR send/compl paths and utilize UTRLCNR".
- Minor update to the 6th change.

Can Guo (9):
  scsi: ufs: Differentiate status between hba pm ops and wl pm ops
  scsi: ufs: Update the return value of supplier pm ops
  scsi: ufs: Enable IRQ after enabling clocks in error handling
    preparation
  scsi: ufs: Complete the cmd before returning in queuecommand
  scsi: ufs: Simplify error handling preparation
  scsi: ufs: Update ufshcd_recover_pm_error()
  scsi: ufs: Let host_sem cover the entire system suspend/resume
  scsi: ufs: Update the fast abort path in ufshcd_abort() for PM
    requests
  scsi: ufs: Apply more limitations to user access

 drivers/scsi/ufs/ufs-debugfs.c |  27 +---
 drivers/scsi/ufs/ufs-sysfs.c   | 105 ++++++----------
 drivers/scsi/ufs/ufs_bsg.c     |  16 +--
 drivers/scsi/ufs/ufshcd.c      | 272 +++++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h      |  23 +++-
 5 files changed, 218 insertions(+), 225 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

