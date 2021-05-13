Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B00C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A79B613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhEMF4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 01:56:39 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:12216 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhEMF4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 01:56:38 -0400
IronPort-SDR: 840J3Z5ww+WPPqZBM7kYpcHaW539/9uXFpaRsRFbys8RGxn9Hbnwv8W3TFJfzt+csU8UQ+d+xz
 IoIuTy4DcDmkNpasKHRJM7xJy4clVud3IyxKgjTNRRfD7kTi2WB4vWOGmbpGq0nrzAlwx7HO0B
 thWaS5N/qv1yuO2JwmvOEON8gJ3xbn6nP2u+Je9xd1+IhSnyzU7/AtetO/wKfTB5CDkrbWxmd4
 5gZUt3JThrLLOkRWj1oNbnt1ZyiSduT1XWrhckqclWksAmDbwKjboa6vnpS4NCTo5kO2pvcteq
 0nk=
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="47866512"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 12 May 2021 22:55:30 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 12 May 2021 22:55:28 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 966D721A85; Wed, 12 May 2021 22:55:29 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/6] Complementary changes for error handling
Date:   Wed, 12 May 2021 22:55:12 -0700
Message-Id: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit cb7e6f05fce67c965194ac04467e1ba7bc70b069 ("scsi: ufs: core: Enable
power management for wlun") makes the UFS device W-LU the supplier, based
on which we need to make some changes to accomodate error handling.

This series is tested by fault injections (to IRQ handler, UIC cmds and
task abort where error handler can possibley be invoked) in all possible
contexts, e.g., scaling, gating, runtime and system suspend/resume.

Below changes are tested as a whole and based on 5.14/scsi-queue.

Can Guo (6):
  scsi: ufs: Differentiate status between hba pm ops and wl pm ops
  scsi: ufs: Update the return value of supplier pm ops
  scsi: ufs: Simplify error handling preparation
  scsi: ufs: Update ufshcd_recover_pm_error()
  scsi: ufs: Let host_sem cover the entire system suspend/resume
  scsi: ufs: Update the fast abort path in ufshcd_abort() for PM
    requests

 drivers/scsi/ufs/ufshcd.c | 180 +++++++++++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |   4 +-
 2 files changed, 103 insertions(+), 81 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

