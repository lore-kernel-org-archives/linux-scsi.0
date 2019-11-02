Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED9CC47E49
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85D3B2084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lP07OEx4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fsu+Qibc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfKBFDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:03:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:03:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 529AB6160B; Sat,  2 Nov 2019 05:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670929;
        bh=CixWUp9ZExou91cIpGatgaDEbgNsb64neNcXgLejW2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP07OEx4p+2F6QylgD0cYDuEwUuEQPv1811awYTCeaoz1ZSXfGddChmaqByAwhe8d
         CFe+YfHjfvUyv3jgOKncwdvG5/W+ysdzM1FmoYczRjnnhV8XTgWODmMHD2xNBgH6pQ
         R6tVzPVtLibGurH8XLD/zrW6TBJgjoTIGrqz/viE=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 549DF615F8;
        Sat,  2 Nov 2019 05:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670927;
        bh=CixWUp9ZExou91cIpGatgaDEbgNsb64neNcXgLejW2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsu+Qibc1Iehpdw0pRCYBZpUzgy8+XeU+vn7fsxHiVLUrevbMJWjZ0gyLlrNdv5UG
         TD0NKKKwV1urw5GZZb4CWebOfPAV9LWnEkMDRIa3ASUYaz4dFa0X1peR4mVvIHMMTd
         WwV7eFawGcJTZi8Ww1ZYEWzsf/A+kDCNy/ZqFJxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 549DF615F8
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
Subject: [PATCH v3 5/5] scsi: ufs: Do not free irq in suspend
Date:   Fri,  1 Nov 2019 22:01:38 -0700
Message-Id: <1572670898-750-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572670898-750-1-git-send-email-cang@codeaurora.org>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
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
index d6e52b3..5841aa5 100644
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
@@ -7951,9 +7943,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

