Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22238C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E741621D6C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WUzLvXFc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IOt+xYrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHIPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:15:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:15:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 69AAB6030E; Fri,  8 Nov 2019 08:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200943;
        bh=DEsZ8uBr9lEFL8lT5IazFxgtaxPCQ+6udQpAiUH30/c=;
        h=From:To:Subject:Date:From;
        b=WUzLvXFcN5Ez98qnge0VPHwO899c9KnkkpJeq3l3TG372a3sk7dyeR0ixTazZEUce
         Oy4tM4Hr5C4kvoUmqEx1ycu8xPg/vEwigkIViOOronVgL+hx0b+m3PEAydhLiWHbDt
         p/YV8IGUvZz1llmAMgo8MPK/pbNjE7oZQwnc6lj8=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B515607EB;
        Fri,  8 Nov 2019 08:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200940;
        bh=DEsZ8uBr9lEFL8lT5IazFxgtaxPCQ+6udQpAiUH30/c=;
        h=From:To:Subject:Date:From;
        b=IOt+xYrmJU8HFxtRJaIWHRtFs4dZRJyDFbzh7HpwFslp1Oxb5ecBz8G8E5+ZsxFVB
         YyiBSDnbSeyEOzjCMx7uy7BJ9NSiKnQ1+VWtPNxF9/RlhERadR9RKiOkl5p47Iovgh
         Ps6szxOpimUvnLG4k3YLeOw+u1/P4iUvsg44EjDQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B515607EB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/5] UFS driver general fixes bundle 5
Date:   Fri,  8 Nov 2019 00:15:26 -0800
Message-Id: <1573200932-384-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 5 general fixes for UFS driver.

Asutosh Das (1):
  scsi: ufs: Recheck bkops level if bkops is disabled

Can Guo (4):
  scsi: ufs: Add new bit field PA_INIT to UECDL register
  scsi: ufs: Update VCCQ2 and VCCQ min voltage hard codes
  scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
  scsi: ufs: Complete pending requests in host reset and restore path

 drivers/scsi/ufs/ufs.h    |  4 ++--
 drivers/scsi/ufs/ufshcd.c | 27 ++++++++++++---------------
 drivers/scsi/ufs/ufshci.h |  2 +-
 3 files changed, 15 insertions(+), 18 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

