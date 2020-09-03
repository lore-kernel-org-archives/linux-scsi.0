Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0789C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884CE20773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgICCZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 22:25:34 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:3836 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgICCZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 22:25:33 -0400
IronPort-SDR: ERS7fPsQS7Fbe9ywo/26lZPobfWHqrgtZSIYuyVyjfxUNzNVXVl2xjP8ZpvbGYIrAe3Shv4oab
 5F64zoQCupXWQyfcy2C+MitW32OUHmPd+nA3wzJSOA2PdohPZGJHgQ1NcAFH/uYCTtjhBonEHe
 AJFm1lxrILXohn7v829UKV+2kcJiPP/TzFitTLUkbj6NTD78MBqRf3JXs2T0DaFuknfnM5Y5Nw
 5+jzu/FZr8XuTlY5xcwAFJ+CwSqNxWXErfoy2+Rr0ex/cXbgegM1As6frlQWM0ldItbVpbJUUP
 0Ok=
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="29130858"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 02 Sep 2020 19:24:35 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 02 Sep 2020 19:24:34 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 94A01215EA; Wed,  2 Sep 2020 19:24:34 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v2 0/2] Add UFS LINERESET handling
Date:   Wed,  2 Sep 2020 19:24:30 -0700
Message-Id: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA Layer issues a LINERESET to the PHY at the recovery step in the Power
Mode change operation. If it happens during auto or mannual hibern8 enter,
even if hibern8 enter succeeds, UFS power mode shall be set to PWM-G1 mode
and kept in that mode after exit from hibern8, leading to bad performance.
Handle the LINERESET in the eh_work by restoring power mode to HS mode
after all pending reqs and tasks are cleared from doorbell.

Change since v1:
- Made some cleanup to the 2nd change.

Can Guo (2):
  scsi: ufs: Abort tasks before clear them from doorbell
  scsi: ufs: Handle LINERESET indication in err handler

 drivers/scsi/ufs/ufshcd.c | 283 +++++++++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h |   2 +
 drivers/scsi/ufs/ufshci.h |   1 +
 drivers/scsi/ufs/unipro.h |   3 +
 4 files changed, 196 insertions(+), 93 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

