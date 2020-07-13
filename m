Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2B6C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 05:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367DB20674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 05:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgGMFDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 01:03:19 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:33490 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMFDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 01:03:19 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2020 01:03:19 EDT
IronPort-SDR: yD1zKwjQbrpA7b/gGI3sv2ofmB3rJLOTrrbIskRuXUMuwlzqt8Mv0TBapTGd88uGLXKTlYSu5K
 p6gouFCSDaiw2EPm4llRt9nz9sz2eA0n4CgsCSBOr8OLzP3Htn9CNipCtXAHKBpyRa2xznNkjk
 MEtz+v7Z8exthCqdR+uE1lwPw/N+/CTqObZeFnpYHKQQNrGnhgti0QWjY7rXXIrHLcM9NQDiOI
 Zd8sHAxHfFnOZL0JUPZVPL6Qfp3yjTFaoZuZmpfVJ/8QYPsu85bs714QkQa1WVRDiuFbfxlhe4
 qN4=
X-IronPort-AV: E=Sophos;i="5.75,346,1589266800"; 
   d="scan'208";a="47215535"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 12 Jul 2020 21:57:16 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 12 Jul 2020 21:57:15 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 68C9F22DAF; Sun, 12 Jul 2020 21:57:15 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v1 0/4] Fix up and simplify error recovery mechanism
Date:   Sun, 12 Jul 2020 21:57:08 -0700
Message-Id: <1594616232-25080-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains 4 changes, the first 3 of them are minor changes to make
sure the main change "scsi: ufs: Fix up and simplify error recovery mechanism"
work properly. The main change has been tested with error injections of multiple
error types (and all kinds of mix of them) during runtime, e.g. hibern8 enter/
exit error, power mode change error and fatal/non-fatal error from IRQ context.
During the test, error injections happen randomly across all contexts, e.g. clk
scaling, clk gate/ungate, runtime suspend/resume and IRQ. There are a few more
fixes to resolve other minor problems based on the main change, but they will be
pushed after this series is taken, due to there are already too many lines in
this change.

Can Guo (4):
  scsi: ufs: Add checks before setting clk-gating states
  scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
  ufs: ufs-qcom: Fix a few BUGs in func ufs_qcom_dump_dbg_regs()
  scsi: ufs: Fix up and simplify error recovery mechanism

 drivers/scsi/ufs/ufs-qcom.c  |  17 +-
 drivers/scsi/ufs/ufs-sysfs.c |   1 +
 drivers/scsi/ufs/ufshcd.c    | 464 ++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h    |  15 ++
 4 files changed, 308 insertions(+), 189 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

