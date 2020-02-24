Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DEFC35641
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFAB520880
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="xQ06JZdh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgBXEJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 23:09:43 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:14196 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgBXEJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 23:09:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582517382; h=Message-Id: Date: Subject: To: From: Sender;
 bh=OJFWU3ArJPyU5hHNnkhWZjxJ1yRfJOu13ns3exYPwzw=; b=xQ06JZdhhBvhNiUvzQUJRkUh9yPj8MvJ8hkwRlxpNq3qRIwYNx7FjgPko0yyHjPwqKkH9lqb
 JZZqGUbZzkWFfNg6DtlTPdvD+R6s869QVSed2z7+hp3qrOXV/Z8wKCG6m7O8fz/PBTUd7gRv
 bkGJet+AQ34eFsYGcunM82cmYxw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e534c7e.7fabff198d88-smtp-out-n01;
 Mon, 24 Feb 2020 04:09:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7D896C4479F; Mon, 24 Feb 2020 04:09:33 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B0016C43383;
        Mon, 24 Feb 2020 04:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B0016C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v2 0/2] Enable HOST_PA_TACTIVATE quirk for WDC UFS devices
Date:   Sun, 23 Feb 2020 20:09:20 -0800
Message-Id: <1582517363-11536-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changes since v1:
- Instead of using this quirk for all Soc vendors, enable this quirk only for QCOM's platforms.

Western Digital UFS devices require host PA_TACTIVATE to be lower than
device PA_TACTIVATE, otherwise it may get stuck during hibern8 sequence.

Can Guo (2):
  scsi: ufs: Allow vendor apply device quirks in advance
  scsi: ufs-qcom: Apply QUIRK_HOST_TACTIVATE for WDC UFS devices

 drivers/scsi/ufs/ufs-qcom.c   | 3 +++
 drivers/scsi/ufs/ufs_quirks.h | 1 +
 drivers/scsi/ufs/ufshcd.c     | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
