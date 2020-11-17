Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85132C5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 07:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3415C24248
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 07:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgKQHE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:04:26 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:50152 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 02:04:25 -0500
IronPort-SDR: /0Xq/GfFgzxMxAFOUbV/3kMp2dN8VXIVHPNj1JZXiqvoqHwk8Bk1x4LrAaepqru2L7wh7HaE19
 atCsNnL8Vdx2h8bhrYuVVe7DstUevIL78mL5edn3uyy7CNzX8WV1+KZmtpFo9oyzAID4s8h3Ae
 PXpOZESnApbk9ePz7z+dZg+RpneIfWZfv8VI0t4ywl+OBhxtpb9ATcWbMNuUt4/rosmKTImeJu
 VZS8N90MzQAfiZsaJv4ZBRMs596Z8UgnKDAmza46iV9QZmosgjZMtb2AqXddoKTZncFd+b3XkO
 vEg=
X-IronPort-AV: E=Sophos;i="5.77,484,1596524400"; 
   d="scan'208";a="47474916"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 16 Nov 2020 23:04:25 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 16 Nov 2020 23:04:25 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 15EA22181A; Mon, 16 Nov 2020 23:04:25 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/3] Fix some racing problems btw err_handler and paths like system PM ops and the task abort callback
Date:   Mon, 16 Nov 2020 23:04:16 -0800
Message-Id: <1605596660-2987-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series mainly fixes racing problems btw err_handler and paths like
system PM ops, async scan and task abort callback. 

This series has been tested with error/fault injections to system PM
operations, async scan and task abort to the UFS device W-LU.

Change since v2:
- Added one more minor change into this series.

Change since v1:
- Removed Change-Id from commit msg

Can Guo (3):
  scsi: ufs: Serialize eh_work with system PM events and async scan
  scsi: ufs: Fix a racing problem between ufshcd_abort and eh_work
  scsi: ufs: Print host regs in IRQ handler when AH8 error happens

 drivers/scsi/ufs/ufshcd.c | 122 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   3 ++
 2 files changed, 88 insertions(+), 37 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

