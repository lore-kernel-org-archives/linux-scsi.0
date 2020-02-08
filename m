Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ADCC2BA83
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6288206DB
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="QxfcTmgW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgBHAup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 19:50:45 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:49099 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727131AbgBHAup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 19:50:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581123044; h=Message-Id: Date: Subject: To: From: Sender;
 bh=+Dbx71bIwvBbBz1BxdCNaPWoYBw2ZxwBk66QjBIeCzQ=; b=QxfcTmgW0qmBjjie+S1rVYY4ofhzBvbMi1CD/VHbvtFE9aoZzzIp2RA6cuX3ResKhlL2UKVN
 zrMCW4fs9n5MlpFOy1QgWMJs5ZVBILeerWhbLcdkyQ+Kfjf1uMlehr+oREOI0rTnYN5TdiZj
 bxMt30XdVo3ABbt9wls16KM/MlI=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3e05df.7f592df53928-smtp-out-n03;
 Sat, 08 Feb 2020 00:50:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F1716C447A0; Sat,  8 Feb 2020 00:50:38 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 235C3C43383;
        Sat,  8 Feb 2020 00:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 235C3C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v8 0/7] UFS driver general fixes bundle 4
Date:   Fri,  7 Feb 2020 16:50:22 -0800
Message-Id: <1581123030-12023-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 7 general fixes for UFS driver.

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
  scsi: ufs: Remove the check before call setup clock notify vops
  scsi: ufs-qcom: Adjust bus bandwidth voting and unvoting
  scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
  scsi: ufs: Add dev ref clock gating wait time support
  scsi: ufs-qcom: Delay specific time before gate ref clk

Sayali Lokhande (1):
  scsi: ufs: Flush exception event before suspend

 drivers/scsi/ufs/ufs-qcom.c | 78 ++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufs.h      |  3 ++
 drivers/scsi/ufs/ufshcd.c   | 96 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 128 insertions(+), 49 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
