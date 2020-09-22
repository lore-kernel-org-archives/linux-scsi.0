Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42957C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 06:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67E523A1D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 06:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgIVGrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 02:47:33 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:46345 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgIVGrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 02:47:33 -0400
IronPort-SDR: fou8xAa2JpqvA+ba6r0I7+3j4xcF6rP+1YeeXTOVGCJYcXXvBuKQOyCnKCPdu7PcaKjJ/VfDlx
 4okrbmNiNwVVxh7DPn75Wys1D1gNaux3SDnkdgCBvtjBULDX8uPWY5u7Kj6au7mesEKqDMIVe3
 lyLEqNFBRsJoiuNYjXVl6b/gWDa0edO7OTVznmMKKikLHM9EtJLS0XE9ZgRMG9dB5InbYOkE9l
 fcH2aYbOinqCb8QUb3zucS3LWm0VDvk9IR1scSqwE4JrVj2LhG2ihqzL5N8o+y9LwzqyYlVRQB
 J/Q=
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="47332977"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 21 Sep 2020 23:47:33 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 21 Sep 2020 23:47:32 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id DF3EA21629; Mon, 21 Sep 2020 23:47:32 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v2 0/2] Fix some racing problems btw err_handler and paths like system PM ops and the task abort callback
Date:   Mon, 21 Sep 2020 23:47:29 -0700
Message-Id: <1600757252-23048-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series mainly fixes racing problems btw err_handler and paths like
system PM ops, async scan and task abort callback. 

This series has been tested with error/fault injections to system PM
operations, async scan and task abort to the UFS device W-LU.

Change since v1:
- Removed Change-Id from commit msg

Can Guo (2):
  scsi: ufs: Serialize eh_work with system PM events and async scan
  scsi: ufs: Fix a racing problem between ufshcd_abort and eh_work

 drivers/scsi/ufs/ufshcd.c | 122 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   3 ++
 2 files changed, 89 insertions(+), 36 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

