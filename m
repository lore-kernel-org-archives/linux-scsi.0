Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D33C43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 13:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08E824658
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 13:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="AoT9OYSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfLNNDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 08:03:48 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:31466 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbfLNNDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 08:03:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576328627; h=Message-Id: Date: Subject: To: From: Sender;
 bh=0nMjZqP1RVMs/cLN5lWIWPWRavc01SWpcuT2GLWUXq0=; b=AoT9OYSgyg5uMxBav6ctBNEOhF+Ndt1E/sdKdJBiBKNN0xVFnU03aba2K8HBhSA3oO6hbPmf
 RBs1slJh+3mohYosNEKQyrxtGokkMCEY6rvnqiAJihpDC6cne6N6N7xI0gVxMzhSteYOwtnZ
 9g0pxEamQdKqKdQTFRSM3ak4yDo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df4ddb1.7fcd698a5538-smtp-out-n01;
 Sat, 14 Dec 2019 13:03:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 40636C43383; Sat, 14 Dec 2019 13:03:45 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D1A4C433CB;
        Sat, 14 Dec 2019 13:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D1A4C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v3 0/2] Modularize ufs-bsg
Date:   Sat, 14 Dec 2019 05:03:33 -0800
Message-Id: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to improve the flexibility of ufs-bsg, modularizing it is a good
choice. Introduce tri-state to ufs-bsg to allow users compile it as an
external module.

Changes since v2:
- Incoperate comments from Avri Altman, Bjorn Andersson and Bart Van Assche.
- Updated the main change to use platform_device_register_data() to create
  a platform device ufs-bsg in ufshcd_platform_init(). Also added the ufs-bsg
  platform driver. In the driver probe routine, create the ufs-bsg char dev
  under /dev/bsg/, the ufs-bsg platform device is the parent of the created
  ufs-bsg char dev.
- Modified commit message.
- Removed defconfig change.

Changes since v1:
- Included one more defconfig change.

Can Guo (2):
  scsi: ufs: Put SCSI host after remove it
  scsi: ufs: Modularize ufs-bsg

 drivers/scsi/ufs/Kconfig         |  2 +-
 drivers/scsi/ufs/Makefile        |  2 +-
 drivers/scsi/ufs/ufs_bsg.c       | 67 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufs_bsg.h       |  8 -----
 drivers/scsi/ufs/ufshcd-pltfrm.c | 12 +++++++
 drivers/scsi/ufs/ufshcd.c        |  8 ++---
 drivers/scsi/ufs/ufshcd.h        |  2 +-
 7 files changed, 55 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
