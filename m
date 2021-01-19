Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5275CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E172168B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389643AbhASOjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:39:01 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:49451 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390373AbhASLyM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 06:54:12 -0500
IronPort-SDR: Ux6YGD4UtoX8otGJOxUDfPgWL7JEK6akdKgKiZ4/WQDMu59F9745jG4oi9wVsZFWCyNG6XSr+e
 5a3rgGX0MVO/KOlnKhxLTLks27Ff0XKVP44eDqaAPQ3i9vwTMUZVmSdhFWyn0wxx/yee/p+a0G
 enwKjcB/2/WuvRqzF0vpuAE9LQEIZx9SvhDpZco2x0fyiKgNsOK8SoT/KMcDWiX9Qb5f86W4KK
 Qkv/Hi4ttG6ZIeHB4X3d2pVuS48M9+9tn+Lpm7cawuVfMAvofw8ecobIfDj+1Po0rDgU2qPpGo
 ndw=
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="47679370"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 19 Jan 2021 03:53:18 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 19 Jan 2021 03:53:17 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id ED71B218E7; Tue, 19 Jan 2021 03:53:17 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v10 0/3] Three changes related with UFS clock scaling
Date:   Tue, 19 Jan 2021 03:52:58 -0800
Message-Id: <1611057183-6925-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is made based on 5.12/scsi-queue branch.

Current devfreq framework allows sysfs nodes like governor, min_freq and max_freq to be changed even after devfreq device is suspended.
Meanwhile, devfreq_suspend_device() cannot/wouldn't synchronize clock scaling which has already been invoked through devfreq sysfs nodes menitioned above.
It means that clock scaling invoked through these devfreq sysfs nodes can happen at any time regardless of the state of UFS host and/or device.
We need to control and synchronize clock scaling in this scenario.

The 1st change allows contexts to prevent clock scaling from being invoked through devfreq sysfs nodes.
The 2nd change is just a code cleanup for clk_scaling/gating initialization routine.
The 3rd change reverts one old change which can be covered by the 1st change. For branches which do not have this change yet, it can be ignored.

Change since v9:
- Minor update in the 1st change.

Change since v8:
- Rebased on 5.12/scsi-queue

Change since v7:
- Slightly updated the 1st change: changed the up_write() before ufshcd_wb_ctrl() to downgrade_write() in ufshcd_devfreq_scale(),
  so that ufshcd_wb_ctrl() is called with clk_scale_lock held, this is to make sure race condition won't happen to ufshcd_wb_ctrl().

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

*** BLURB HERE ***

Can Guo (3):
  scsi: ufs: Protect some contexts from unexpected clock scaling
  scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
  scsi: ufs: Revert "Make sure clk scaling happens only when HBA is
    runtime ACTIVE"

 drivers/scsi/ufs/ufshcd.c | 214 +++++++++++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  10 ++-
 2 files changed, 127 insertions(+), 97 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

