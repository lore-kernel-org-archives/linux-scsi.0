Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCE8C43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92AFE2077B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jTNEu15A";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="McOewTk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfLECFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:05:36 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:34968
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728374AbfLECFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:05:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575511535;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=eV5UQc0Nv02TJNdhFWZaDHRnQ93t5irlSEirUDqpNEo=;
        b=jTNEu15A6/gouO49J5YvppTGbJARs8FLUDiJaGy7+AO8y8LKkfV0JUb3HeMPLBDw
        QMP4ZSV3E0rAGwsTqg0wvBvnQHLdUAyCQe7vtusVtWAfb+kBK5z0ZWx6XwMGCju88OA
        ZtBXJH2LfaEQ8ZWPgSxlRv4a/usCjV4mrTyJhxC4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575511535;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=eV5UQc0Nv02TJNdhFWZaDHRnQ93t5irlSEirUDqpNEo=;
        b=McOewTk7yM5EDBJ0dvAphAFv4JgZDYecZngrgqgB/zU5F8QMLz8sxCBCTWi0dQ+S
        lSZH6msWSeT8ZelmX6BSoo5QuI8jmN2mIdzALz7a+rGvZTl9ful6sVHjb5cX98tsSbb
        sbLS4D8wFa4gl0LB9/h2IuK/chlQbsHDKnFtjLdc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E7974C64313
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
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
Subject: [PATCH v5 5/5] scsi: ufs: Do not free irq in suspend
Date:   Thu, 5 Dec 2019 02:05:35 +0000
Message-ID: <0101016ed3ce2e27-04f59930-fe71-4290-a028-c71e8310ca49-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
References: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.05-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since ufshcd irq resource is allocated with the device resource management
aware IRQ request implementation, we don't really need to free up irq
during suspend, disabling it during suspend and reenabling it during resume
should be good enough.

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

