Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28A8C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA0460FE4
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhEXIs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:48:56 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1164 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXIs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:48:56 -0400
IronPort-SDR: 5CTBlIr3CKJKxuu9u1L0O4FZcARGgwSWUGNOIBwpTElYbn5RMIJkYaMmOvqRSW2hzdccGwMJu0
 DZ5qTnbnnssxWt1sa4uO/zNTfghh0AuztGH9Vi0hUR2AtM6hTe20PdcAIQ2lLJJbqn8vLoyLi3
 bCQeRDldBByj0V/vYcjmkZctIvXE5A/6EFHVSrPaYPIF3O/M1Y4TFJjnxhZ7ODP91hQx9tQ7S5
 yT86ga1IutZiUu9NyW6UJjAwwlGzZ4z5zRY+ya8IAr11AbWqRgROwfAmEjLow8uFroRUxtC1Uf
 JuA=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772333"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:47:28 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 24 May 2021 01:47:28 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1F4C921AD7; Mon, 24 May 2021 01:47:28 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v2 0/6] Complementary changes for error handling
Date:   Mon, 24 May 2021 01:47:19 -0700
Message-Id: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
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

Changes from v1:
- Rebased on series "Optimize host lock on TR send/compl paths and utilize UTRLCNR".
- Minor update to the 6th change.

Can Guo (6):
  scsi: ufs: Differentiate status between hba pm ops and wl pm ops
  scsi: ufs: Update the return value of supplier pm ops
  scsi: ufs: Simplify error handling preparation
  scsi: ufs: Update ufshcd_recover_pm_error()
  scsi: ufs: Let host_sem cover the entire system suspend/resume
  scsi: ufs: Update the fast abort path in ufshcd_abort() for PM
    requests

 drivers/scsi/ufs/ufshcd.c | 196 ++++++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h |   4 +-
 2 files changed, 113 insertions(+), 87 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

