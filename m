Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FA6CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A4C2084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WGcbSMM/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y4OqGcIY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKBFD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:03:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:03:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B66BC614F7; Sat,  2 Nov 2019 05:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671033;
        bh=/1VaQj+FOTP1287A/sdcNI6CmNgco2YauKWSa433HZY=;
        h=From:To:Subject:Date:From;
        b=WGcbSMM/4GebpkUeaYBhEn3vAyKPioxt5h2R/1i2TlzVy/QYwAqLJ2ypOsgk78YNu
         u5loILhAbk2i3/xtoi5hTAPkg91kGpNc9PCTeTZhyHwsL3tvQZB2XDvg5oAzXqlXfi
         pTHnFrRMPTnP2ej0EijL8iD0uYvUSLMzIVZezrdU=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12303614DF;
        Sat,  2 Nov 2019 05:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671024;
        bh=/1VaQj+FOTP1287A/sdcNI6CmNgco2YauKWSa433HZY=;
        h=From:To:Subject:Date:From;
        b=Y4OqGcIYAZFwcaO7zBttQPBN+kO3xOiXIozwdt6SjcsmhrVYp+G09uyTs4Dmyu67l
         cnx3yWdDILwqzZm3nolF5I8BWsNfuMp7OGU2CmNFxbPi2dpItvYU6w29XtFFAEPeQt
         dMtKmd2CfHJNa5Vaov1yCY865RtCq0hGak73Wfds=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12303614DF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/6] UFS driver general fixes bundle 3
Date:   Fri,  1 Nov 2019 22:03:30 -0700
Message-Id: <1572671016-883-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 6 general fixes for UFS driver.

Asutosh Das (1):
  scsi: ufs: Abort gating if clock on request is pending

Can Guo (3):
  scsi: ufs: Add device reset in link recovery path
  scsi: ufs-qcom: Add reset control support for host controller
  scsi: ufs: Fix up auto hibern8 enablement

Subhash Jadavani (1):
  scsi: ufs: Fix error handing during hibern8 enter

Venkat Gopalakrishnan (1):
  scsi: ufs: Fix irq return code

 drivers/scsi/ufs/ufs-qcom.c  |  53 ++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h  |   3 +
 drivers/scsi/ufs/ufs-sysfs.c |   5 +-
 drivers/scsi/ufs/ufshcd.c    | 170 +++++++++++++++++++++++++++++++------------
 4 files changed, 183 insertions(+), 48 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

