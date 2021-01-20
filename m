Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD82AC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC6EB2333D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbhATLYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:24:30 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:12131 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731043AbhATKFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 05:05:31 -0500
IronPort-SDR: o5BgxapecDN/qWZHmKt/X/+v68zMe2ThXRIT/LOOdhnht5H03jOJ+kS3+DctMeXuxcMy/0NJs1
 JFQ1r3RQg3he/LJpYGyIbHjOLWZvRvaVbnHlQoypYOpu98MWfSDMuT6vGDS3prVbdqUlulEqgi
 4LMH53dng4aA6fAg3kAF0hkms8j432N1VLRnkqDz1ytz12O4MaemyQ8OvN4cS76F5m+aOp9Je5
 YmpCBAyYk3iQIIW3hU8LZLDfLjEF90CWn40Rgczx3bfKimj3cDeTCh83vUCKXTVdaCYU62CCcG
 qIc=
X-IronPort-AV: E=Sophos;i="5.79,360,1602572400"; 
   d="scan'208";a="29554589"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 20 Jan 2021 02:04:51 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 20 Jan 2021 02:04:50 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 6D50921941; Wed, 20 Jan 2021 02:04:50 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v11 0/3] Three changes related with UFS clock scaling
Date:   Wed, 20 Jan 2021 02:04:20 -0800
Message-Id: <1611137065-14266-1-git-send-email-cang@codeaurora.org>
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

Change since v10:
- Incorporated Stanley's comment.

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

Can Guo (3):
  scsi: ufs: Protect some contexts from unexpected clock scaling
  scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
  scsi: ufs: Revert "Make sure clk scaling happens only when HBA is
    runtime ACTIVE"

 drivers/scsi/ufs/ufshcd.c | 211 +++++++++++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  10 ++-
 2 files changed, 125 insertions(+), 96 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

