Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1F1C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F8B9222CD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kJU5hLig";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kJU5hLig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKMGAd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:00:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:00:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7449F6088D; Wed, 13 Nov 2019 06:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624832;
        bh=x+bXgAw/KLbJH+pZh7S3UedB0pDlLExTXSxpwU94q60=;
        h=From:To:Subject:Date:From;
        b=kJU5hLig/VwFpro67yA17BpJdIUyDXn00AxL0foDPsU/a8WFH913vq71sfZ0mfJfL
         GeAVZQmDkLTp9uqtHQ7YvENpD5CKw/aKebvtBLRZbNeni6M24OUHnZQ2AwIO2wxKBT
         bECl//yfC6lXDDOncWXtXxwzs8yK0foKZ9g8Q6fs=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A9516085C;
        Wed, 13 Nov 2019 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624832;
        bh=x+bXgAw/KLbJH+pZh7S3UedB0pDlLExTXSxpwU94q60=;
        h=From:To:Subject:Date:From;
        b=kJU5hLig/VwFpro67yA17BpJdIUyDXn00AxL0foDPsU/a8WFH913vq71sfZ0mfJfL
         GeAVZQmDkLTp9uqtHQ7YvENpD5CKw/aKebvtBLRZbNeni6M24OUHnZQ2AwIO2wxKBT
         bECl//yfC6lXDDOncWXtXxwzs8yK0foKZ9g8Q6fs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9A9516085C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v4 0/5] UFS driver general fixes bundle 1
Date:   Tue, 12 Nov 2019 22:00:18 -0800
Message-Id: <1573624824-671-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Changes since v3:
- Incorporated review comments from Martin K. Petersen.

Changes since v2:
- Incorporated review comments from Mark Salyzyn

Changes since v1:
- Incorporated review comments from Bart Van Assche.

Can Guo (5):
  scsi: Adjust DBD setting in mode sense for caching mode page per LLD
  scsi: ufs: Use DBD setting in mode sense
  scsi: ufs: Release clock if DMA map fails
  scsi: ufs: Do not clear the DL layer timers
  scsi: ufs: Do not free irq in suspend

 drivers/scsi/scsi_lib.c    |  2 ++
 drivers/scsi/ufs/ufshcd.c  | 42 ++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/unipro.h  | 11 +++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 42 insertions(+), 14 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

