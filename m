Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A2BC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6C12082D
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgLBDrv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 22:47:51 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:35360 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgLBDrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 22:47:51 -0500
IronPort-SDR: ERvDKQVcTXGrEmpiz45XSg9L5yaJUi47E48nDfaMR/RalJA4umzblwhJoluicw94ZpijOyQZwl
 U97Ld44L1xoECPoVo9zoQ0ICGxFTU8yGsBCXJsHh+XHfRYnkf6pqwtkz8cFU76higEzgrzqbgY
 8a6/07m3QWO3XHcDgC4AMfTpdEmBy+hRyqj3rKyGVR2yTiMnynmPAbc9qirPSyip2RLHUMYm64
 PkJBYrysN8FWvEWQrd3Ba9pmYJ3ILiMTGLiRlnIv/785sA4rPbDzzFS3FRo0PXwfqvUoJRDLB7
 daI=
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="47538808"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 01 Dec 2020 19:47:12 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 01 Dec 2020 19:47:10 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 953A22106B; Tue,  1 Dec 2020 19:47:10 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v4 0/3] Minor fixes to UFS error handling
Date:   Tue,  1 Dec 2020 19:47:05 -0800
Message-Id: <1606880829-27500-1-git-send-email-cang@codeaurora.org>
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

 drivers/scsi/ufs/ufshcd.c | 122 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   3 ++
 2 files changed, 88 insertions(+), 37 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

