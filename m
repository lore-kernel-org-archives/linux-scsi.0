Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447F1C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB95E22202
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgLBKRQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:17:16 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:7317 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgLBKRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 05:17:16 -0500
IronPort-SDR: NYm/YgEazIGzCeDBsy1iJmstAnJ+m8xWBgS+NYiO/hwGOBiuBD3QS0Df7EPoX9PurQxSHDgKDn
 +pI7UaiQUnylS3JeVgyDqZuX7IJYbIYeiGlvXjQjb3hOPWG9k6NZTGQR1UhRHX1i+vcV7eEb2G
 jUaz/cUK/zqB9NPb9kLrOFk2wdq8kCQKNhXJz07xrE5iTTkcQMzft+inqwxxYlVjHqhLUiA2Tf
 Bdzx4QVeOm7Kdw6r96HncjDlzQvpwfDjAkwoMF/w9G95xbahb6j67lTwEvsa8ayGwAveOAY/uO
 6H0=
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="47540139"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 02 Dec 2020 02:16:36 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 02 Dec 2020 02:16:35 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id A431A2108B; Wed,  2 Dec 2020 02:16:35 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH V6 0/3] Minor fixes to UFS error handling
Date:   Wed,  2 Dec 2020 02:16:30 -0800
Message-Id: <1606904194-20806-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series mainly fixes below two things which come along with UFS error
handling in some corner cases.
[1] Concurrency problems btw err_handler and paths like system suspend/resume/shutdown and async scan.
[2] Race condition btw UFS error recovery and task abort which happens to W-LU during suspend/resume/shutdown.

The 1st change is tested with error/fault injections to power mode change
operations during system PM operations and async scan. The 2nd change is
tested by mimicing SSU cmd timeout during suspend/resume/shutdown. The 3rd
one is just a minor change to a check condition in IRQ handler such that
the driver can dump host regs when AH8 error happens.

Change since v5:
- Incorporated Stanley's comment

Change since v4:
- Fixed a typo found by Stanley.

Change since v3:
- Slightly updated some commit msg lines, no code changes.

Change since v2:
- Added one more minor change into this series.

Change since v1:
- Removed Change-Id from commit msg

Can Guo (3):
  scsi: ufs: Serialize eh_work with system PM events and async scan
  scsi: ufs: Fix a race condition between ufshcd_abort and eh_work
  scsi: ufs: Print host regs in IRQ handler when AH8 error happens

 drivers/scsi/ufs/ufshcd.c | 125 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   3 ++
 2 files changed, 90 insertions(+), 38 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

