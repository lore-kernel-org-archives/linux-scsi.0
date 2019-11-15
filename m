Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FA6C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6771120748
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TLIx1Zdb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JnxY4L/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKOGKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:10:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKOGKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 01:10:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E25D061242; Fri, 15 Nov 2019 06:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798224;
        bh=/Hg5TMS32NczIExs9EhG1N/XaKdWM8A3C7xN+Fyop6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLIx1ZdblpcejgcJSNBYbAu8hzdwchY6/dUItxfEiT5xVXJuff3lDMuRhaBDBJ15v
         p3wxsi9Y1x3938IAReNXWIEXtWEMnmlHTvD8li0k0u+CGcCPtn8iVXhqU50Xsk0PdQ
         bTZ3P1eBXzaElYiLzD+mDhGLKPo4XzRa0cMtY18g=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 150BC611F3;
        Fri, 15 Nov 2019 06:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798220;
        bh=/Hg5TMS32NczIExs9EhG1N/XaKdWM8A3C7xN+Fyop6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnxY4L/AbWIOwf4d/6iZ/ReYIkH9SkVsNI6ilhE0i48rxaGjuiAiWqUBNc/1uSS2F
         fGT7BINv6/uIkz4OqnhYqb1z3g5H0GP5jLNPts8+6WNaw3KkunXOeOiDxqoYEaBBPt
         9qgc++i9TZtftJ9km2BonJW4P7lDo446105+D/Bc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 150BC611F3
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 6/7] scsi: ufs: Abort gating if clock on request is pending
Date:   Thu, 14 Nov 2019 22:09:29 -0800
Message-Id: <1573798172-20534-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
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
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c3527e4..d662641 100644
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

