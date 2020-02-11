Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA796C352A4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 02:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBF32070A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 02:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jKN/nRRa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgBKCiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 21:38:03 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:32233 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727493AbgBKCiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 21:38:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581388682; h=Message-Id: Date: Subject: To: From: Sender;
 bh=tBC+m8s0rVpFYRrBuBubgvwm4Vs+KVoMsl7i2UK/6O8=; b=jKN/nRRaynvVLHH8jpDakZyPAElsGgPLOLC21eoKa5Hsxf8BQhQD1k6BD3E7vqxdwPZOd9el
 kgxpUu1zh0i502FwFBKNWIKLM8iqBE4suLkzKp9ssvSZi3L5fboA4xxFgZvzzj6jKm8FMMuf
 ffGtJ+ReuN2Bg1Iz0tJo62Cklus=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e421388.7f99b5bb1458-smtp-out-n03;
 Tue, 11 Feb 2020 02:38:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7BB15C4479D; Tue, 11 Feb 2020 02:37:59 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D884C43383;
        Tue, 11 Feb 2020 02:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D884C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v9 0/7] UFS driver general fixes bundle 4
Date:   Mon, 10 Feb 2020 18:37:42 -0800
Message-Id: <1581388671-18078-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 7 general fixes for UFS driver.

Changes since v8:
- Incoperated comments from Arvi to add "Fixes" to commit message of patch #4
- Switched the order of patch #2 and #3 to reflect the dependency.

Changes since v7:
- Incoperated comments from Bjorn and Arvi.
- Removed patch #8.

Changes since v6:
- Incoperated Avri's comment.

Changes since v5:
- Incoperated Stanley's suggestions to make the extra delay added up to bRefClkGatingWaitTime as vendor specific

Changes since v4:
- Rebased this series

Changes since v3:
- Fixed patch #8

Changes since v2:
- Move the ref clk gating wait delay to ufs-qcom.c
- Added one more change to select INITIAL adapt for HS G4

Changes since v1:
- Fixed minor typo


Asutosh Das (1):
  scsi: ufs: set load before setting voltage in regulators

Can Guo (5):
  scsi: ufs-qcom: Adjust bus bandwidth voting and unvoting
  scsi: ufs: Remove the check before call setup clock notify vops
  scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
  scsi: ufs: Add dev ref clock gating wait time support
  scsi: ufs-qcom: Delay specific time before gate ref clk

Sayali Lokhande (1):
  scsi: ufs: Flush exception event before suspend

 drivers/scsi/ufs/ufs-qcom.c | 100 +++++++++++++++++++++++++++++++-------------
 drivers/scsi/ufs/ufs.h      |   3 ++
 drivers/scsi/ufs/ufshcd.c   |  96 +++++++++++++++++++++++++++++-------------
 3 files changed, 143 insertions(+), 56 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
