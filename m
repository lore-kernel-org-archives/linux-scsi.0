Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954F7C5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504CC21D7E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X/qHEuVo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X/qHEuVo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbfKGImc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:42:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfKGImb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 03:42:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AD4EB6019D; Thu,  7 Nov 2019 08:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116150;
        bh=+PlhFnyCyxuWX/juvEKsUZ0qfgoeJAOJyFTMh4rukdQ=;
        h=From:To:Subject:Date:From;
        b=X/qHEuVo2cp2dnz6g6BL5UpjKPlySJdYpuPLxf1+IDO+wGcnmKhCgYlU5qKOn3kNZ
         eV6f2eEpIDuXylcvD4rt0lDimqAYR5eQ6+13kDuiIvI3txJ48BQgXHuSRx/SDK/iWo
         RQGHsQtgXeCrP8AU943huTCJRIMIcuSrPJjCjq58=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2086601C4;
        Thu,  7 Nov 2019 08:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116150;
        bh=+PlhFnyCyxuWX/juvEKsUZ0qfgoeJAOJyFTMh4rukdQ=;
        h=From:To:Subject:Date:From;
        b=X/qHEuVo2cp2dnz6g6BL5UpjKPlySJdYpuPLxf1+IDO+wGcnmKhCgYlU5qKOn3kNZ
         eV6f2eEpIDuXylcvD4rt0lDimqAYR5eQ6+13kDuiIvI3txJ48BQgXHuSRx/SDK/iWo
         RQGHsQtgXeCrP8AU943huTCJRIMIcuSrPJjCjq58=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E2086601C4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/6] UFS driver general fixes bundle 4
Date:   Thu,  7 Nov 2019 00:42:07 -0800
Message-Id: <1573116140-22408-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 6 general fixes for UFS driver.

Asutosh Das (1):
  scsi: ufs: set load before setting voltage in regulators

Can Guo (4):
  scsi: ufs: Remove the check before call setup clock notify vops
  scsi: ufs-qcom: Adjust bus bandwidth voting and unvoting
  scsi: ufs: Add dev ref clock gating wait time support
  scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Sayali Lokhande (1):
  scsi: ufs: Flush exception event before suspend

 drivers/scsi/ufs/ufs-qcom.c |  58 ++++++++++++++++--------
 drivers/scsi/ufs/ufs.h      |   3 ++
 drivers/scsi/ufs/ufshcd.c   | 108 ++++++++++++++++++++++++++++++++------------
 3 files changed, 122 insertions(+), 47 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

