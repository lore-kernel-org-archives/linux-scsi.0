Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E4DC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 13:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CF22339D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 13:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbhAMN5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 08:57:53 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:13072 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbhAMN5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 08:57:53 -0500
IronPort-SDR: SaGdJFBWyrpMYZFUQ7olaYNqsiiAPPI0iWGj6wSOL26UH1Yrwg1tTO5d8u8LkhDIPzxkr0N7pW
 aiUffRV01MYU5djSIRY9SlKOn2G2Vn4hPNHg8vU9p5fOY+Xmifaemr/4ibUQBuol7U9tgRIpqV
 BzylnhRsE48Yg4ULNRiTJOlJ6thTPgceUjwfHE+AHFerNyhH4ytufHpXhj/M1Nypl6Fw62N9Wv
 kV+V8Erbhwxl45h40NmLVPgspPfMfReJNpkcKSKMnqGP9apSsVEobqquTM9RLBNrsK8t79mJsH
 E6M=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="29536977"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 13 Jan 2021 05:57:13 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 13 Jan 2021 05:57:12 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id D570B2191C; Wed, 13 Jan 2021 05:57:12 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v4 0/2] Synchronize user layer access with system PM ops and error handling
Date:   Wed, 13 Jan 2021 05:57:07 -0800
Message-Id: <1610546230-14732-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains two changes and it is based on 5.11/scsi-queue
The 1st change is just a minor fix.
The 2nd change is to synchronize user layer access through UFS sysfs nodes, so that system PM ops (suspend, resume and shutdown), error handling and async probe won't be disturbed by user layer access. The protection is only added to some sysfs nodes, not all of them.

Change since v3:
- Rebased to 5.12/scsi-queue

Change since v2:
- Updated the 1st change, added a global boolean flag to tell if system suspend is invoked when hba is NULL, it is used during resume in case of hba becomes not NULL.

Change since v1:
- Slightly updated the 2nd change, added a dedicated inline func to check hba->shutting_down in ufshcd.h. This inline func can be updated to add more rules for sysfs passage in future.


Can Guo (2):
  scsi: ufs: Fix a possible NULL pointer issue
  scsi: ufs: Protect PM ops and err_handler from user access through
    sysfs

 drivers/scsi/ufs/ufs-sysfs.c | 106 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.c    |  57 +++++++++++++++--------
 drivers/scsi/ufs/ufshcd.h    |  10 +++-
 3 files changed, 138 insertions(+), 35 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

