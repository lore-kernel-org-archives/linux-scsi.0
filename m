Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EE9C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD828206F9
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgKXH23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 02:28:29 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:3658 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgKXH23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 02:28:29 -0500
IronPort-SDR: uV/90IlHckisfruJNBmueoYvgMeBztnfpAnEUIp6qItUB3lheIVKdoUPjbrAdbEEamWA7yvSyV
 ilDTgSqg/bNSza0MfJT4cfKI3MNHB6G8dki2Et4zdUlS84eQmqcgs0X5kpBa2HphhFS4DsK0q/
 kp9UoXfAySWxLJJPw8kNqi/R4I3t0NVfx7gol8cQ02AkSacAZ6pi9cA/9rI1WJTW7PqH2VxsAD
 wSrA/pVrKqTIPMPs+rCPKLzx8r5PLsTuCXRl0E0xJNIdFzc0y6yP7j8vq34aTfEHbIDGSo8OEw
 nWE=
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="47507388"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 23 Nov 2020 23:28:29 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 23 Nov 2020 23:28:28 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 7E5032185E; Mon, 23 Nov 2020 23:28:28 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v2 0/2] Refector ufshcd_setup_clocks() to remove param skip_ref_clk
Date:   Mon, 23 Nov 2020 23:28:24 -0800
Message-Id: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow vendor drivers to decide which clock should be kept on when
clk gating or suspend disables clocks while link is active.

Can Guo (2):
  scsi: ufs: Refector ufshcd_setup_clocks() to remove skip_ref_clk
  scsi: ufs-qcom: Keep core_clk_unipro ON while link is active

 drivers/scsi/ufs/ufs-qcom.c      |  6 ++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 ++
 drivers/scsi/ufs/ufshcd.c        | 25 +++++--------------------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 4 files changed, 16 insertions(+), 20 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

