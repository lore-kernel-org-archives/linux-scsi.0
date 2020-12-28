Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CABCC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 11:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C17122583
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 11:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgL1LJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 06:09:03 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:8022 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgL1LJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2020 06:09:03 -0500
IronPort-SDR: uCwLDfZudWWVS3nMfbnyt642RroYmkOMoRwdHiZX99i7shF/SyAE2Jae4IeA4B+1IRnybWAfam
 3vfqHjV75JlgJyd+z0SPR+CYAzPq8yS/zs5RMNxmRqTl6lT6F3iNk5PlEwgpdD98U1Ee+rcmO3
 muV4h+zktNHfu868Io7nMJOCSod0uyPLVOgxYqmGeMUG526b85tLhLQk/7YxogEwbiz1TsuJty
 o/gKUiunTHy0xpjJtDQk1NWYXZqnnedUdOlp2gnISa0rlNWKGmuf5hUuYm/bu108DKCfyJtjuS
 2Pc=
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="29452319"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 28 Dec 2020 03:08:22 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 28 Dec 2020 03:08:21 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id C00952188E; Mon, 28 Dec 2020 03:08:21 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v7 0/3] Three changes related with UFS clock scaling
Date:   Mon, 28 Dec 2020 03:08:15 -0800
Message-Id: <1609153700-25703-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is made based on 5.10/scsi-fixes branch.

Current devfreq framework allows sysfs nodes like governor, min_freq and max_freq to be changed even after devfreq device is suspended.
Meanwhile, devfreq_suspend_device() cannot/wouldn't synchronize ongoing execution invoked through sysfs nodes menitioned above either.
It means that UFS clock scaling can be invoked at any time (clkscale_enable is same) regardless of the state of UFS host and/or device.

The 1st change allows contexts to prevent clock scaling from being invoked through sysfs nodes like clkscale_enable.
The 2nd change is just a minor code cleanup.
The 3rd change reverts one old change which can be covered by the 1st change. For branches which do not have this change yet, it can be ignored.

Change since v6:
- Updated the 2nd change

Change since v5:
- Reomved the code change in ufshcd_shutdown() since it is not quite relevant with this fix

Change since v4:
- Updated some comment lines as requested by Stanley

Change since v3:
- Slightly updated the 1st change

Change since v2:
- Split the 1st change to two changes, which become the 1st change and the 3rd change

Change since v1:
- Updated the 2nd change


Can Guo (3):
  scsi: ufs: Protect some contexts from unexpected clock scaling
  scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
  scsi: ufs: Revert "Make sure clk scaling happens only when HBA is
    runtime ACTIVE"

 drivers/scsi/ufs/ufshcd.c | 210 ++++++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h |  10 ++-
 2 files changed, 130 insertions(+), 90 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

