Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51638C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 11:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223062220B
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 11:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL3LaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 06:30:21 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:17508 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3LaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 06:30:20 -0500
IronPort-SDR: fsiP2vwj5c3h8n/o9T3WGadtMmdXYhe9pZLqpH7YzSEMRa7DT0CbEET2kzCqKBlZhf3l/nd+gZ
 xpAMeeHBRRvtmsezamMSahmk1eUv88CBjiePpC0+QNx1C7MGxMdQ0DvBCAIKEHWES91FkAVV0W
 5YGv7IP+4XzhTL8SBIcOtV1kfEIWU4vRkgUI8hvAf0zfg4tJGHfu+ThoUw8asMsajx5ZffcGsI
 o3Nq/43pom8WVnSBeDpGY6EL/E7Yhj0xA8za2AiY8cD/p7/N8gDQuSC+PBkQPDUoKK9YR02+Q8
 AGE=
X-IronPort-AV: E=Sophos;i="5.78,461,1599548400"; 
   d="scan'208";a="29463360"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 30 Dec 2020 03:29:40 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 30 Dec 2020 03:29:39 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 9264E21868; Wed, 30 Dec 2020 03:29:39 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v8 0/3] Three changes related with UFS clock scaling
Date:   Wed, 30 Dec 2020 03:29:33 -0800
Message-Id: <1609327777-20520-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is made based on 5.10/scsi-fixes branch.

Current devfreq framework allows sysfs nodes like governor, min_freq and max_freq to be changed even after devfreq device is suspended.
Meanwhile, devfreq_suspend_device() cannot/wouldn't synchronize clock scaling which has already been invoked through devfreq sysfs nodes menitioned above.
It means that clock scaling invoked through these devfreq sysfs nodes can happen at any time regardless of the state of UFS host and/or device.
We need to control and synchronize clock scaling in this scenario.

The 1st change allows contexts to prevent clock scaling from being invoked through devfreq sysfs nodes.
The 2nd change is just a code cleanup for clk_scaling/gating initialization routine.
The 3rd change reverts one old change which can be covered by the 1st change. For branches which do not have this change yet, it can be ignored.

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

 drivers/scsi/ufs/ufshcd.c | 216 ++++++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h |  10 ++-
 2 files changed, 132 insertions(+), 94 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

