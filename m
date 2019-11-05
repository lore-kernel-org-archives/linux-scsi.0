Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BEACA9ED5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D24F214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:00:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S6QSdTl3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SaIuIh20"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbfKEEAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 23:00:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfKEEAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 23:00:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EAE7F60D5C; Tue,  5 Nov 2019 04:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926433;
        bh=A09Hg8Gubfo22q2oteGE+XWVmGvlbeGYL8Kj6AbIyz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6QSdTl3teYRhZJCTEQCmpfSVYiAku4tQDJkzQ6FPW7InNeaCTN03OCVm/L399z6S
         3DiB6WCDXP0M0mLwMWZTaCb5lhRbMQ08sKzA9GZ4L6SyM9mLHtYomhdFAQN3ZNtNKS
         qfRPd2BUXKdTGjc+mRSpLgQtrlda+Q1Y7tMv3ofA=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35AC060F6F;
        Tue,  5 Nov 2019 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572926432;
        bh=A09Hg8Gubfo22q2oteGE+XWVmGvlbeGYL8Kj6AbIyz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaIuIh20eitXsdg6OHgSyNkmNdtqVIH2JqziAxmEWCqMX+rgZu1gsKlSw8wvppKHS
         U8IzYVE+T6afRWrljtUEQIWFPtl/1obcazsfiy03x+dTlELL79Uu82gKr+qiRDBVLq
         +QQx611YN0DIQy+UYi7z9eMRMtwUFo1Hk7RzhWcM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35AC060F6F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/7] scsi: ufs: Abort gating if clock on request is pending
Date:   Mon,  4 Nov 2019 19:57:14 -0800
Message-Id: <1572926236-720-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572926236-720-1-git-send-email-cang@codeaurora.org>
References: <1572926236-720-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

This change attempts to abort gating of clocks if a
request to turn-on clocks is pending.
This would in turn avoid turning OFF and back ON the
clocks.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8d1b04f..7a5a904 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1610,7 +1610,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * state to CLKS_ON.
 	 */
 	if (hba->clk_gating.is_suspended ||
-		(hba->clk_gating.state == REQ_CLKS_ON)) {
+		(hba->clk_gating.state != REQ_CLKS_OFF)) {
 		hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

