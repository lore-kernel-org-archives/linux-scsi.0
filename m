Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D599C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA66222CD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iAcAbSuh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WxsQl55y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKMGBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:01:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:01:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 19DA460D88; Wed, 13 Nov 2019 06:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624859;
        bh=wj+AeBWg49YIiNe7g8iPRpcUQczXBC+cdiu8/3qKz5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAcAbSuh78IQ6HqNYl5XPIW9z3UW1xlFdYr5B5HWke9YexP9g0twSbQSuD9VrXl86
         OnmRbOvPAjI3Ky/v8amhPO0X0Hj05dZNlYg4FgAGS4SDRzkNgTdu4IHXrnk5LmNijb
         EOk5hgx98pi5Nr/4fbG0sp3kisofUHPKRLJN9rMs=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F7E960D7D;
        Wed, 13 Nov 2019 06:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624856;
        bh=wj+AeBWg49YIiNe7g8iPRpcUQczXBC+cdiu8/3qKz5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxsQl55y22Fo511ZW/WsyyebKmlwx7MMePxdpFUEevooVZzK0WdySjufi5XEiPF1Y
         NImbYtm5Y5DLYg+xzc9OvAU/V61mulCrDnbfIKv6fu+4j2QtX3yUGYwwXPd4PQN4QW
         LWHyVGdrG4QBs3wmTGXftt5lGlQaSJEAQoCpnQA4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F7E960D7D
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
Date:   Tue, 12 Nov 2019 22:00:23 -0800
Message-Id: <1573624824-671-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573624824-671-1-git-send-email-cang@codeaurora.org>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If PM QoS is enabled and we set request type to PM_QOS_REQ_AFFINE_IRQ then
freeing up the irq makes the free_irq() print out warning with call stack.
We don't really need to free up irq during suspend, disabling it during
suspend and reenabling it during resume should be good enough.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 086d359..c449b68 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -266,26 +266,18 @@ static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
 	return tag >= 0 && tag < hba->nutrs;
 }
 
-static inline int ufshcd_enable_irq(struct ufs_hba *hba)
+static inline void ufshcd_enable_irq(struct ufs_hba *hba)
 {
-	int ret = 0;
-
 	if (!hba->is_irq_enabled) {
-		ret = request_irq(hba->irq, ufshcd_intr, IRQF_SHARED, UFSHCD,
-				hba);
-		if (ret)
-			dev_err(hba->dev, "%s: request_irq failed, ret=%d\n",
-				__func__, ret);
+		enable_irq(hba->irq);
 		hba->is_irq_enabled = true;
 	}
-
-	return ret;
 }
 
 static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 {
 	if (hba->is_irq_enabled) {
-		free_irq(hba->irq, hba);
+		disable_irq(hba->irq);
 		hba->is_irq_enabled = false;
 	}
 }
@@ -7930,9 +7922,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		goto out;
 
 	/* enable the host irq as host controller would be active soon */
-	ret = ufshcd_enable_irq(hba);
-	if (ret)
-		goto disable_irq_and_vops_clks;
+	ufshcd_enable_irq(hba);
 
 	ret = ufshcd_vreg_set_hpm(hba);
 	if (ret)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

