Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1DEC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 07:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EEB024683
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 07:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="DJxKZlAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAWH00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:26:26 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:16079 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728811AbgAWH0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 02:26:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579764385; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=rBbiMubrsSJY16sYdP0KKGOi7Z2x2RztZoP0ot3NB4I=; b=DJxKZlAa9qwHI+VVQ+6TA07meVq2hzMUXcnTgRG7cIZf3i/mtDh/O5+5LQ3EmFILVmUkuIvl
 y4APSmCHkybCk/7E93BSUMrwynGHvCSeqZktQm7wCU70ivLICMudpKA8DmXt0WY9WBrMROV8
 ljg8Seb0lu4F9Q+YN2b6RQiV1fg=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e294a9f.7f7de2b91a40-smtp-out-n01;
 Thu, 23 Jan 2020 07:26:23 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AAF3CC447A1; Thu, 23 Jan 2020 07:26:23 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3BD7C447A4;
        Thu, 23 Jan 2020 07:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3BD7C447A4
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 7/8] scsi: ufs-qcom: Delay specific time before gate ref clk
Date:   Wed, 22 Jan 2020 23:25:48 -0800
Message-Id: <1579764349-15578-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After enter hibern8, as UFS JEDEC ver 3.0 requires, a specific gating wait
time is required before disable the device reference clock. If it is not
specified, use the old delay.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 85d7c17..3b5b2d9 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -833,6 +833,8 @@ static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 {
+	unsigned long gating_wait;
+
 	if (host->dev_ref_clk_ctrl_mmio &&
 	    (enable ^ host->is_dev_ref_clk_enabled)) {
 		u32 temp = readl_relaxed(host->dev_ref_clk_ctrl_mmio);
@@ -845,11 +847,16 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 		/*
 		 * If we are here to disable this clock it might be immediately
 		 * after entering into hibern8 in which case we need to make
-		 * sure that device ref_clk is active at least 1us after the
+		 * sure that device ref_clk is active for specific time after
 		 * hibern8 enter.
 		 */
-		if (!enable)
-			udelay(1);
+		if (!enable) {
+			gating_wait = host->hba->dev_info.clk_gating_wait_us;
+			if (!gating_wait)
+				udelay(1);
+			else
+				usleep_range(gating_wait, gating_wait + 10);
+		}
 
 		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
