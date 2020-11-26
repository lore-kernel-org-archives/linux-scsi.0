Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFA4C64E75
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 02:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFEDB2075A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 02:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbgKZCD1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:03:27 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:11562 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgKZCD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 21:03:27 -0500
IronPort-SDR: CzcYvJ4NfqvTgZlGRHzk/oU0n6LZaaKwQsDbIlpRiXO07EoDQrrVTQ1SUl8icuDoiZlo5Kazw1
 Hdlaurwz7A10k1bgv7t7+tHlEex1jPSBOuTwLBS5DMepl2DNbFHo38UlvOMa+8LkYiQiNPC7j6
 OLiZsuaYoOi3n6p2LssE3kc2IqWGxb8NfEvgWsXT1IyHYBFzY/UhBZAjBdUI8dX1x2KWrgvXj3
 P5eL15ad8xRTRKqt0yvn+ZQVxfHMbyhhhbZsCwDYJwIF2HbP4Rlpa40UpUDsGeR55ahWAZINEk
 bhU=
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="47516301"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 25 Nov 2020 18:03:27 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 25 Nov 2020 18:03:25 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 9A77221858; Wed, 25 Nov 2020 18:03:25 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/2] Subject: [PATCH v3 0/2] Refactor ufshcd_setup_clocks() to remove param skip_ref_clk
Date:   Wed, 25 Nov 2020 18:00:59 -0800
Message-Id: <1606356063-38380-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow vendor drivers to decide which clock should be kept on when
clk gating or suspend disables clocks while link is active.

Change since v2:
- Fixed a typo in commit title
- Changed naming always_on_while_link_active to keep_link_active

Change since v1:
- Incorporated Stanley's idea which is to refactor func ufshcd_setup_clocks()

Can Guo (2):
  scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk
  scsi: ufs-qcom: Keep core_clk_unipro ON while link is active

 drivers/scsi/ufs/ufs-qcom.c      |  6 ++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 ++
 drivers/scsi/ufs/ufshcd.c        | 29 +++++++++--------------------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 4 files changed, 20 insertions(+), 20 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

