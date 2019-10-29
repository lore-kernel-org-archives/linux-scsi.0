Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E594ECA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC2C521479
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W8ZBJtRk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UEpXAiBj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfJ2MYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:24:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfJ2MYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 08:24:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5DAAD60D96; Tue, 29 Oct 2019 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572351841;
        bh=PafpH8raq2BVeOW8H1HkdavjFVFw9FdEuJrOwfZe300=;
        h=From:To:Subject:Date:From;
        b=W8ZBJtRkWoXqxIzRSGtarYXF6UTlkPWD+gIb744qiJ+llY83OAK7CGX6ktZ8P3Vzh
         0Ey32asi+47vof3d/fsPg3+VvZ18zr7Vdl3/bz3RglOr+7gTbb7YoBEVI9wOOJtlx1
         0KeuElqZ93cC/B0SJU5WonexkY36Qa0xYhjM3D1A=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 07F7760D86;
        Tue, 29 Oct 2019 12:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572351840;
        bh=PafpH8raq2BVeOW8H1HkdavjFVFw9FdEuJrOwfZe300=;
        h=From:To:Subject:Date:From;
        b=UEpXAiBjbPaEuRh3zXmXFnRpsuBCLgjZ6zo4J+Qi/fzB0pbnLzoj1TmYlTQGxLjYi
         8nwL4sQ8ZZF4wwPxzSLbL/am2uVr45ZEOprxpxv5T1OhHyRtPYbOGbtssgqssb12NK
         ngqKaHT0T7zGDMjWx0YlmIMQ+fvtOXyp492gqaBc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 07F7760D86
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/2] UFS driver general fixes bundle 2
Date:   Tue, 29 Oct 2019 05:23:47 -0700
Message-Id: <1572351831-30373-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 2 general fixes for UFS driver.

Can Guo (1):
  scsi: ufs: Do not rely on prefetched data

Subhash Jadavani (1):
  scsi: ufs: Fix up clock scaling

 drivers/scsi/ufs/ufshcd.c | 104 ++++++++++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h |  13 ------
 2 files changed, 64 insertions(+), 53 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

