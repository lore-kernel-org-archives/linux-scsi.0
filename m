Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9317BC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A2122072B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ewwA9P8G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X8/8aisJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKOGJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:09:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKOGJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 01:09:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC22060F81; Fri, 15 Nov 2019 06:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798180;
        bh=/U6fwHZBBF4+Eo/W7d5MnVd6YMmnQiYaUE0xKtN5H+o=;
        h=From:To:Subject:Date:From;
        b=ewwA9P8G6JX9kyGVbNqj6edOJYiME+ItLGD3Iz76x3UiQ4GGHgwE5W0DDPnXMJXfQ
         Fx97J5ab8OVZRd4kGbWcZ8+T/xpkIIBBk12kYMMghQ7NDdurHJBESWPPTQ7kur3YMy
         hTPT6IYGYDmRR65yHfC2ADeug1GQPB+/H8vwBKXk=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 821DB60112;
        Fri, 15 Nov 2019 06:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798179;
        bh=/U6fwHZBBF4+Eo/W7d5MnVd6YMmnQiYaUE0xKtN5H+o=;
        h=From:To:Subject:Date:From;
        b=X8/8aisJFTYAP677D8l9YpqzsoDH32hX4htt89eq5ccmyR9LOxggyjP2aeT1nwcEh
         5rwjSuCVkUsYJpsgH1lWeVlnREpMsU2aR/7SRGHWGQtbzT8X40vwOVfZSWqvxYFOwm
         7yJwFT3TNPISvceZLedxkofc4CmiJX2bDGMR3GfE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 821DB60112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v5 0/7] UFS driver general fixes bundle 3
Date:   Thu, 14 Nov 2019 22:09:23 -0800
Message-Id: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 7 general fixes for UFS driver.

Changes since v4:
- Incorporated review comments from Avri Altman.

Changes since v3:
- Updated UIC_DATA_LINK_LAYER_ERROR_CODE_MASK in change "scsi: ufs: Fix irq return code".

Changes since v2:
- Updated change "scsi: ufs: Fix up auto hibern8 enablement".

Changes since v1:
- Added one more change to fix register dump caused sleep in atomic context.

Asutosh Das (1):
  scsi: ufs: Abort gating if clock on request is pending

Can Guo (4):
  scsi: ufs: Add device reset in link recovery path
  scsi: ufs-qcom: Add reset control support for host controller
  scsi: ufs: Fix up auto hibern8 enablement
  scsi: ufs: Fix register dump caused sleep in atomic context

Subhash Jadavani (1):
  scsi: ufs: Fix error handing during hibern8 enter

Venkat Gopalakrishnan (1):
  scsi: ufs: Fix irq return code

 drivers/scsi/ufs/ufs-qcom.c  |  53 +++++++++++++
 drivers/scsi/ufs/ufs-qcom.h  |   3 +
 drivers/scsi/ufs/ufs-sysfs.c |  15 ++--
 drivers/scsi/ufs/ufshcd.c    | 174 +++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h    |   2 +
 drivers/scsi/ufs/ufshci.h    |   2 +-
 6 files changed, 193 insertions(+), 56 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

