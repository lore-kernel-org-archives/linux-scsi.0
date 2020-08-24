Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D249C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 09:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585862071E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 09:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgHXJjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 05:39:16 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:10529 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgHXJjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 05:39:15 -0400
IronPort-SDR: KotqAyvt0P+u/Kj+Avo2CFawp6g/849JyacJMKBfSkZZMeqMnqzrko2aVnxN/rjEeAeb8UZS1S
 cBjakbwiuUoQlTQSsrgoP6WY8+s7GUugIu4bDgFx5D0q4EX83OpjszBRFzklpKWi2ccAarwcri
 9/qQ7wpuMFncTVo9bHR9ats2gzm+1ZrLuTY0OR1R4nnkr1bV3KUqP1ZnIdkJfQKgHhqUtVDJu2
 w/JaLaneDwW3UyaxSM2c5TrSwQakHoGORG10f5tAYBDdIO3vHB/jWmNGPMddXOFpnRm/OOfNId
 fBU=
X-IronPort-AV: E=Sophos;i="5.76,348,1592895600"; 
   d="scan'208";a="47271617"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 24 Aug 2020 02:39:14 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 24 Aug 2020 02:39:13 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 898932121E; Mon, 24 Aug 2020 02:39:13 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v1 0/2] Add UFS LINERESET handling
Date:   Mon, 24 Aug 2020 02:39:09 -0700
Message-Id: <1598261952-29209-1-git-send-email-cang@codeaurora.org>
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

Can Guo (2):
  scsi: ufs: Abort tasks before clear them from doorbell
  scsi: ufs: Handle LINERESET indication in err handler

 drivers/scsi/ufs/ufshcd.c | 254 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   2 +
 drivers/scsi/ufs/unipro.h |   3 +
 3 files changed, 183 insertions(+), 76 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

