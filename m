Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A3FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Dec 2020 04:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 745D2207C7
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Dec 2020 04:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgLaE0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 23:26:19 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:1270 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLaE0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 23:26:19 -0500
IronPort-SDR: URjmULy4UWVc/rUyMZIXhPmP6KocrpAE6yERqXJ/6zQ/ZyasqZCPu7sNjMecbc8livX1AKxdx3
 Nq2//DOCLwoGhxvlC0NoggZtGoMkBWyL5kMsxS9pIMLrRb8s/RZmvi6vphi/MX8Cf+Emop8R27
 3Oh/VIf5Ywyz0K0xS4lVCMubokzsBQJvOSY27cT+duix7FrTCQtaAT+GMzSiWDtSHj4c+OCFVJ
 gnpftTh6tDMDQQFndzFi2f2ZT58sVdBKJBwUHoU8y7vNJSmZYcl12GkAwRcTz3W3wBEIIhl41o
 oGw=
X-IronPort-AV: E=Sophos;i="5.78,463,1599548400"; 
   d="scan'208";a="29466383"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 30 Dec 2020 20:25:39 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 30 Dec 2020 20:25:38 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E512A212C1; Wed, 30 Dec 2020 20:25:37 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/2] Synchronize user layer access with system PM ops and error handling
Date:   Wed, 30 Dec 2020 20:25:33 -0800
Message-Id: <1609388736-22525-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains two changes and it is based on 5.11/scsi-queue
The 1st change is just a minor fix.
The 2nd change is to synchronize user layer access through UFS sysfs nodes, so that system PM ops (suspend, resume and shutdown), error handling and async probe won't be disturbed by user layer access.

Can Guo (2):
  scsi: ufs: Fix a possible NULL pointer issue
  scsi: ufs: Protect PM ops and err_handler from user access through
    sysfs

 drivers/scsi/ufs/ufs-sysfs.c | 104 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.c    |  49 ++++++++++++--------
 drivers/scsi/ufs/ufshcd.h    |   5 ++-
 3 files changed, 123 insertions(+), 35 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

