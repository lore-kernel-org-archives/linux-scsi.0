Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1C8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B98420773
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGNC2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 22:28:16 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:26314 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNC2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 22:28:15 -0400
IronPort-SDR: aFOISGBQp31nI2r3qozUCyaG6HwDfqJzozNNFFC2qyz43z/M9wYQdCCB0tuDXB+MObVvezPDWp
 Y+EHgwtCEFP4vKnDkgR4wqghB45iHpf705khcO9uU+ZKiDKQuY8wHjb+Pp3Rqxarn1Ca3jOfl0
 OhwtpZn28RvWKMpxqDIS0GQsQNV46t1diZpcb91s8YhXoMqI9Tqj5UTT5+kvajpDZOyAh7U0Xt
 wKswmmvd/1WB7eRTwOqv2+0ootRtfgZ5XUUhTqsLLDkf8gDToYYfnM2BVmmrJE47zMhF/MJSxT
 l7I=
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="47216742"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 13 Jul 2020 19:28:14 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg01-sd.qualcomm.com with ESMTP; 13 Jul 2020 19:28:14 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 3107C22DC2; Mon, 13 Jul 2020 19:28:14 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v2 0/4] Fix up and simplify error recovery mechanism
Date:   Mon, 13 Jul 2020 19:28:08 -0700
Message-Id: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
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

Change since v1:
- Fixed a compilation error in case that CONFIG_PM is N

Can Guo (4):
  scsi: ufs: Add checks before setting clk-gating states
  scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
  ufs: ufs-qcom: Fix a few BUGs in func ufs_qcom_dump_dbg_regs()
  scsi: ufs: Fix up and simplify error recovery mechanism

 drivers/scsi/ufs/ufs-qcom.c  |  17 +-
 drivers/scsi/ufs/ufs-sysfs.c |   1 +
 drivers/scsi/ufs/ufshcd.c    | 465 ++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h    |  15 ++
 4 files changed, 309 insertions(+), 189 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

