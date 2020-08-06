Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB25DC4345E
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C8822D0B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgHFFHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:07:12 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:18684 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgHFFHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 01:07:07 -0400
IronPort-SDR: 6kBnOQnmty9Khnmd4PcOh9qZQju5984LXhLpakTeOM1nDjTkKuKsZAiC4AvgE61ulqlpNgkMzx
 N6eM/6IeHKtLooEyrnhM0KVcjmp/1Thlj7yHoJ7DWPL2GyAkE9cloK7Q98UxqpyRS+VWVb88ZY
 8xwfqmNrOLoQUEMs+PY4rDjJ5QLA5+R9QIQ5Ia2z4Qk7Xz+LakF2d1gnwmej5vgyDZGbfwbo+m
 X2vbpfQpEH+rpfV58H5DSa3wOdmmFT875l/Kct3ZmXXmyEoqsz7TQFUJgpbtEomW14AwSIiLFn
 CE4=
X-IronPort-AV: E=Sophos;i="5.75,440,1589266800"; 
   d="scan'208";a="29068262"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 05 Aug 2020 22:07:06 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 05 Aug 2020 22:07:05 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 6773C21562; Wed,  5 Aug 2020 22:07:05 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v9 0/9] Fix up and simplify error recovery mechanism
Date:   Wed,  5 Aug 2020 22:06:21 -0700
Message-Id: <1596690383-16438-11-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596690383-16438-1-git-send-email-cang@codeaurora.org>
References: <1596690383-16438-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The changes have been tested with error injections of multiple error types (and
all kinds of mixture of them) during runtime, e.g. hibern8 enter/ exit error,
power mode change error and fatal/non-fatal error from IRQ context. During the
test, error injections happen randomly across all contexts, e.g. clk scaling,
clk gate/ungate, runtime suspend/resume and IRQ.

There are a few more fixes to resolve other minor problems based on the main
change, such as LINERESET handling and racing btw error handler and system
suspend/resume/shutdown, but they will be pushed after this series is taken,
due to there are already too many lines in these changes.

Change since v8:
- Added one more fix to ufshcd_abort as requested by Stanley Chu

Change since v7:
- Incorporated Asutosh's comments
- Refined patch "scsi: ufs: Recover hba runtime PM error in error handler"

Change since v6:
- Modified change "scsi: ufs-qcom: Fix schedule while atomic error in ufs_qcom_dump_dbg_regs" to "scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs"

Change since v5:
- Dropped change "scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()" as it is not quite related with this series
- Refined func ufshcd_err_handling_prepare in change "scsi: ufs: Recover hba runtime PM error in error handler"

Change since v4:
- Split the original change "ufs: ufs-qcom: Fix a few BUGs in func ufs_qcom_dump_dbg_regs()" to 2 small changes

Change since v3:
- Split the original change "scsi: ufs: Fix up and simplify error recovery mechanism" into 5 changes

Change since v2:
- Incorporate Bart's comment to change "scsi: ufs: Add checks before setting clk-gating states"
- Revised the commit msg of change "scsi: ufs: Fix up and simplify error recovery mechanism"

Change since v1:
- Fixed a compilation error in case that CONFIG_PM is N

Can Guo (9):
  scsi: ufs: Add checks before setting clk-gating states
  ufs: ufs-qcom: Fix race conditions caused by func
    ufs_qcom_testbus_config
  scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
  scsi: ufs: Add some debug infos to ufshcd_print_host_state
  scsi: ufs: Fix concurrency of error handler and other error recovery
    paths
  scsi: ufs: Recover hba runtime PM error in error handler
  scsi: ufs: Move dumps in IRQ handler to error handler
  scsi: ufs: Fix a racing problem btw error handler and runtime PM ops
  scsi: ufs: Properly release resources if a task is aborted
    successfully

 drivers/scsi/ufs/ufs-qcom.c  |  37 ----
 drivers/scsi/ufs/ufs-sysfs.c |   1 +
 drivers/scsi/ufs/ufshcd.c    | 508 +++++++++++++++++++++++++++----------------
 drivers/scsi/ufs/ufshcd.h    |  14 ++
 4 files changed, 338 insertions(+), 222 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

