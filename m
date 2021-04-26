Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5498FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F16560FEE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhDZDtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:49:46 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:13025 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhDZDtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:49:45 -0400
IronPort-SDR: nWrvCWOFbkTsNQ5qne/4aBuAiKL0w7wIfB9HxjPRLE0ZFS6Nl7Lx7OWTorZXAEa5LFxXk5VrnJ
 ZN4RGyCl6vP7rpN38R2XHb17XbNg0ismriGdQCFho46wgu5r9lZxNiq6gL8qPMNkUZsw51s1nG
 i7BEZT/CED7Pwtf/9xvCO7kmBNpg+1eduuBYv/d5BJ2LLfDioHkJN0EQEV1bSCmFmrC4mSgDwJ
 /baXihcQGlicUykNG/K7ha+/gu808fVO+Z5njH1M1EvUhafH8rpQxa8L/0ZtEbItvDiXPxlL15
 VDs=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759515"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 20:49:05 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 25 Apr 2021 20:49:02 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 522492121E; Sun, 25 Apr 2021 20:49:02 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, ziqichen@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v2 0/3] Three minor fixes w.r.t suspend/resume
Date:   Sun, 25 Apr 2021 20:48:37 -0700
Message-Id: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

1st change can fix a possible OCP issue when AH8 error happens.
2nd and 3rd change can fix race conditions btw suspend/resume and other contexts.

Can Guo (3):
  scsi: ufs: Do not put UFS power into LPM if link is broken
  scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
  scsi: ufs: Narrow down fast pass in system suspend path

Change since V1:
- Incorporated Daejun's comment.

 drivers/scsi/ufs/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

