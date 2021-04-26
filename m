Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD2CC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE7161158
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDZC1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:27:22 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:8422 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZC1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 22:27:22 -0400
IronPort-SDR: 5CRMzgAUFv4a6E2c9lhEBZyI4pw1gjQdKKe/m/tqAbKZRVdTUXSZSPl64mb5bGOREFUR0IenOX
 oJ1obtqkNurtc5uD1eKuaieJ9JBcCfiH/UpRCwH6qSOaZXJ0XdagiQGvnCJiR+gya/GkctsZ80
 x1ft8eL7KNMn7K1LK93B6prLvU2S62Fyo+VgLBCVQoZ68NVfaS/qyRS/BTm5UzZFY03qyP2MPM
 fV94G8Cjn7mJlIhJW/++BSMXrPon5GXyd9GxkzrKe4s4PmDF6+/zoiE1DpTRgjnoyAlyi8jKC0
 ODQ=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759454"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 19:26:42 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 25 Apr 2021 19:26:41 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E83D02113E; Sun, 25 Apr 2021 19:26:40 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, ziqichen@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/3] Three minor fixes w.r.t suspend/resume
Date:   Sun, 25 Apr 2021 19:24:34 -0700
Message-Id: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

1st change can fix a possible OCP issue.
2nd and 3rd change can fix race conditions btw suspend/resume and other contexts.

Can Guo (3):
  scsi: ufs: Do not put UFS power into LPM if link is broken
  scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
  scsi: ufs: Narrow down fast pass in system suspend path

 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

