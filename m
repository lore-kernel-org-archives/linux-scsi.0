Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3006C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53E082222C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgLBI1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:27:33 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:5831 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLBI1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 03:27:33 -0500
IronPort-SDR: SuYlkmAkQYhXYVtgtRyAF9LZxPt8F0N2cPk8Zgqqx4BU4hxFV61MpuniL2mtrs91VGSd0iJiiI
 IOtSnTZF4rTtycHr8D6xDbCLNhlr7oN+NLavtHa6a5EwhwPLHFGeOSroo5eNnKGoyOhcHrdBwX
 KzHuwyZ1ce1JungFXxA4fERgMMzeOtIEH7PBjcRjP2c2UkD5WnHTYXGMtQuth+xJjf7L+iM7Yx
 c01B9XULlnMCZBP05iBFJbbeQ/u96Ro1eDRNwQis5xYAw4rnoBKtVO5QuRW33VMTCwr+BesnwX
 QnQ=
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="29321976"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 02 Dec 2020 00:26:54 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 02 Dec 2020 00:26:53 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1E6792107E; Wed,  2 Dec 2020 00:26:53 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH V5 0/3] Minor fixes to UFS error handling
Date:   Wed,  2 Dec 2020 00:24:31 -0800
Message-Id: <1606897475-16907-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series mainly fixes below two things which come along with UFS error
handling in some corner cases.
[1] Concurrency problems btw err_handler and paths like system suspend/resume/shutdown and async scan.
[2] Race condition btw UFS error recovery and task abort which happens to W-LU during suspend/resume/shutdown.

The 1st change is tested with error/fault injections to power mode change
operations during system PM operations and async scan. The 2nd change is
tested by mimicing SSU cmd timeout during suspend/resume/shutdown. The 3rd
one is just a minor change to a check condition in IRQ handler such that
the driver can dump host regs when AH8 error happens.

Change since v4:
- Fixed a typo found by Stanley.

Change since v3:
- Slightly updated some commit msg lines, no code changes.

Change since v2:
- Added one more minor change into this series.

Change since v1:
- Removed Change-Id from commit msg


Can Guo (3):
  scsi: ufs: Serialize eh_work with system PM events and async scan
  scsi: ufs: Fix a race condition between ufshcd_abort and eh_work
  scsi: ufs: Print host regs in IRQ handler when AH8 error happens

 drivers/scsi/ufs/ufshcd.c | 122 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   3 ++
 2 files changed, 88 insertions(+), 37 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

