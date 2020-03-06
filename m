Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47DFC3F2D7
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 04:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD502084E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 04:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="I8D1qrxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCFE7W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 23:59:22 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:42458 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgCFE7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 23:59:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583470760; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=MBmpXjI5RscO1PxyM0pnTjZMR2IIngyCvzYv0CDL26w=; b=I8D1qrxMReidEtm1aXp63g2G2tSgVWbUt7UKelceEhlWm3MksNqZKLvVvELVxMVI8tgC3Lpo
 9y08ma8bYguKNzhV+u2clDHyBu4rk8xKMiKp2Z5aP6kVfhRqnxacdqeAELPqtjBPQ8mF6CyV
 GgmoKnn2C+l9i4ULOGwd4wvdgjY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e61d8a8.7f8e83e6bca8-smtp-out-n02;
 Fri, 06 Mar 2020 04:59:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13BCEC4479F; Fri,  6 Mar 2020 04:59:19 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F84BC43383;
        Fri,  6 Mar 2020 04:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F84BC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=nguyenb@codeaurora.org
From:   "Bao D. Nguyen" <nguyenb@codeaurora.org>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org,
        linux-scsi@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, asutoshd@codeaurora.org,
        cang@codeaurora.org, "Bao D. Nguyen" <nguyenb@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/4] SD card bug fixes
Date:   Thu,  5 Mar 2020 20:58:14 -0800
Message-Id: <cover.1583470026.git.nguyenb@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


I tried to make some changes earlier in the patch
[<PATCH v1> 9/9] mmc: sd: Fix trivial SD card issues].
There were a lot of valid comments asking to clarify
and separate the fixes into logical patches. With this
patch series, I am trying to address those comments.

Changes since v1:
- Addressed Ulf Hansson's comment regarding unnecessary NULL pointer check in the mmc_bus_shutdown(). 

Bao D. Nguyen (1):
  mmc: core: Add check for NULL pointer access

Ritesh Harjani (1):
  mmc: core: Make host->card as NULL when card is removed

Sahitya Tummala (1):
  mmc: core: update host->card after getting RCA for SD card

Subhash Jadavani (1):
  mmc: core: Attribute the IO wait time properly in
    mmc_wait_for_req_done()

 drivers/mmc/core/bus.c  | 3 +++
 drivers/mmc/core/core.c | 5 ++++-
 drivers/mmc/core/sd.c   | 6 ++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
