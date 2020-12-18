Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8E1C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046A923A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLRHKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:10:31 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:12527 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgLRHKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 02:10:30 -0500
IronPort-SDR: Earx5eCaCI8P7WQI0twEJRuKg6MjhX3V+Wyx+Kcs7w6FHYm33OJFJAtvpRsnfv0xBJronvB7Lc
 usVSuSBj4EO5Sa8ktAknoapZ3mVuYB6GKlP6fFedmLIz9FNdmRML69HaMfck/tAZDw5LaeCnyh
 FcUtB3rI2p0ePkLd/JCUU7h22dZR6Ud42+JN3EIfAN2swjg2e4cnN09hnIYm7+BuHkSItJ+Uwq
 QuOpSINneKt8nIX3KUYkbGjjGVfYC2IcWWe/KOCL9ei0lMMLpuZfv2w42WfQQ2BWOga30WaLt/
 ymY=
X-IronPort-AV: E=Sophos;i="5.78,429,1599548400"; 
   d="scan'208";a="29385184"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 17 Dec 2020 23:09:50 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 17 Dec 2020 23:09:49 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id ABAA0211C2; Thu, 17 Dec 2020 23:09:49 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v5 0/3] Three changes related with UFS clock scaling
Date:   Thu, 17 Dec 2020 23:09:42 -0800
Message-Id: <1608275387-26183-1-git-send-email-cang@codeaurora.org>
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
  scsi: ufs: Clean up ufshcd_exit_clk_scaling/gating()
  scsi: ufs: Revert "Make sure clk scaling happens only when HBA is
    runtime ACTIVE"

 drivers/scsi/ufs/ufshcd.c | 120 ++++++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h |  10 +++-
 2 files changed, 78 insertions(+), 52 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

