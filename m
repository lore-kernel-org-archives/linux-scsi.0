Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF12C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 16:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CFE22336D
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 16:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbgLMQOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Dec 2020 11:14:19 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:3392 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbgLMQOF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2020 11:14:05 -0500
IronPort-SDR: bGx20VdDlpimfn9vPSGhu9w8brfrvdEMy6Cjw5a222cJd9u8kfAIfpI94HhFy5w6DhOyyKuddY
 /84Fx7tRghQhmOFG8e8cwp5HZFdbCZf8BeQqgHVXf14V9aAw77nmYAfNgscNdCYLcVKs2Bppky
 7Ov+o/CPweTgph6AaAbRQoAe1xH2EfBAqsDIvw25HsMw4U3ogKOwUrXIIEIKK3Z7mj11MpbTzF
 OJYu98W9vwDmjY3MlRAZcxRUw0pNCAaP6IYELxI0RUmEoWNC/2oWxqSVJ/QX0RfDwCL8UL3iry
 ciw=
X-IronPort-AV: E=Sophos;i="5.78,416,1599548400"; 
   d="scan'208";a="47580259"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 13 Dec 2020 08:13:22 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 13 Dec 2020 08:13:21 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id A7A0821616; Sun, 13 Dec 2020 08:13:21 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v3 0/3] Three changes related with UFS clock scaling
Date:   Sun, 13 Dec 2020 08:13:16 -0800
Message-Id: <1607876000-3293-1-git-send-email-cang@codeaurora.org>
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
The 3rd change revert one old change which can be covered by the 1st change. For branches which do not have this change yet, it can be ignored.

Change since v2:
- Split the 1st change to two changes - the 1st change and the 3rd change

Change since v1:
- Updated the 2nd change

Can Guo (3):
  scsi: ufs: Protect some contexts from unexpected clock scaling
  scsi: ufs: Clean up ufshcd_exit_clk_scaling/gating()
  scsi: ufs: Revert "Make sure clk scaling happens only when HBA is
    runtime ACTIVE"

 drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |   6 +++
 2 files changed, 76 insertions(+), 51 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

