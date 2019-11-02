Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4536CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E1B2084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k7FBwhff";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TlH9S51H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfKBFE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:04:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfKBFE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:04:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2654A61626; Sat,  2 Nov 2019 05:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671064;
        bh=n1/cAoqo5w7ra/WW4EPkOJMl/a/yzKpbIRWvP/Fq3ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7FBwhffQq2iRDpngQApStobIzEUzZlE/7BhgzUE4KZ2t6RoDtL7aPTMMCZ1ZN8X2
         TjgEubVDfOcMtm+TzCnFJbcBTHeuO0RCAileKVPpZ3AHWX1xbplIB0qRjJaxkZ5FHa
         hjFSqWhJxSGfIeXlbpKSOXAJ+9idUuMs7GhoFX+E=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF42061630;
        Sat,  2 Nov 2019 05:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671052;
        bh=n1/cAoqo5w7ra/WW4EPkOJMl/a/yzKpbIRWvP/Fq3ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlH9S51HA1Yy+In+7YteQaX1YV2VHQL10CF+WcNsJmJwNvZe9BLNDaBe7UAJFxrEY
         EA5nAzu/2cW/fUQevP3V/9vYVcuc07oJlGRm6yQZUDyEbRpGJ59OO4kDAStN1IAW8B
         jZrowt0bzYkI0N6K/qTulGB+USo/mZIDWdieNtxA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF42061630
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 5/6] scsi: ufs: Abort gating if clock on request is pending
Date:   Fri,  1 Nov 2019 22:03:35 -0700
Message-Id: <1572671016-883-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572671016-883-1-git-send-email-cang@codeaurora.org>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
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
index ee591cc..c9ef2dd 100644
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

