Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A9DC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B598324655
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Gijnew4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgAWGMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 01:12:38 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:42451 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbgAWGMi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 01:12:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579759957; h=Message-Id: Date: Subject: To: From: Sender;
 bh=v7aIFXPOPwdENrtwXUqxqxmZFsi8DF3IME3e/WlMYdY=; b=Gijnew4H0woJXSrtg5ZLGGNXBPfHfnvDF5+5SH/NXFjsBj9SuGvrG8//f9ZyXoHZGvIIORG5
 iIdqHtTHEe5RZdvER4R39SrmYpzag0HFI3O2cJ48awGq8Qo9uyZXfZiaLIGOZ0OiBNhuYvvy
 NN1sJfBi5S9OFcNwfpTB5jY0zN0=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e293954.7fd23b361730-smtp-out-n01;
 Thu, 23 Jan 2020 06:12:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4697DC4479F; Thu, 23 Jan 2020 06:12:36 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A578C4479C;
        Thu, 23 Jan 2020 06:12:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A578C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v3 0/8] UFS driver general fixes bundle 4
Date:   Wed, 22 Jan 2020 22:12:17 -0800
Message-Id: <1579759946-5448-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 8 general fixes for UFS driver.

Changes since v2:
- Move the ref clk gating wait delay to ufs-qcom.c
- Added one more change to select INITIAL adapt for HS G4

Changes since v1:
- Fixed minor typo

Asutosh Das (1):
  scsi: ufs: set load before setting voltage in regulators

Can Guo (6):
  scsi: ufs: Remove the check before call setup clock notify vops
  scsi: ufs-qcom: Adjust bus bandwidth voting and unvoting
  scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
  scsi: ufs: Add dev ref clock gating wait time support
  scsi: ufs-qcom: Delay specific time before gate ref clk
  scsi: ufs: Select INITIAL adapt for HS Gear4

Sayali Lokhande (1):
  scsi: ufs: Flush exception event before suspend

 drivers/scsi/ufs/ufs-qcom.c |  70 +++++++++++++++++++---------
 drivers/scsi/ufs/ufs.h      |   3 ++
 drivers/scsi/ufs/ufshcd.c   | 111 +++++++++++++++++++++++++++++++++-----------
 drivers/scsi/ufs/unipro.h   |   1 +
 4 files changed, 136 insertions(+), 49 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
