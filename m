Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCB3CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FB5F2190F
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kK54IjrH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fr1Kdvs8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfKBFEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:04:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:04:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BC2C36161E; Sat,  2 Nov 2019 05:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671049;
        bh=836Jc857UfXfWP4BPIMMn9j23njKiaDe8BLCZ1+/Llw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK54IjrHoEAkLnWGA3JQFKIsmnWlMnpYX5GBmQUpMV7muRhvFEiXtqdpZWhus+VmG
         b8cVGHg63b1jkpKcvbB/RqyErXW58MIBo1SkwvVxsTaARR07+DnLxHqK/IPx3KUn+l
         f5X8pyrffv8v+J7gX5IUN5RqDTULqQ3M7V2yULlE=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0AD6761514;
        Sat,  2 Nov 2019 05:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671041;
        bh=836Jc857UfXfWP4BPIMMn9j23njKiaDe8BLCZ1+/Llw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fr1Kdvs8U/KBMtCm6/iiOufAaUHB6ySE27QTNcXj/JVsZyAdqvmpp+0nzzF0Cm3xc
         ROKTl8kNrJXvPPb8W8Biypbs0gbFWd/wZFJMNMZWQqwg5hX2YrHba78lp1F3/x2MTT
         Yc2KPgB75UapS2+2knS932t44RdoKI452RINpMYo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0AD6761514
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/6] scsi: ufs: Fix up auto hibern8 enablement
Date:   Fri,  1 Nov 2019 22:03:33 -0700
Message-Id: <1572671016-883-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572671016-883-1-git-send-email-cang@codeaurora.org>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix up possible unclocked register access to auto hibern8 register in
resume path and through sysfs entry. Meanwhile, enable auto hibern8
only after device is fully initialized in probe path.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-sysfs.c |  5 ++++-
 drivers/scsi/ufs/ufshcd.c    | 12 ++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 969a36b..de124f4 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -129,8 +129,11 @@ static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	if (hba->ahit == ahit)
 		goto out_unlock;
 	hba->ahit = ahit;
-	if (!pm_runtime_suspended(hba->dev))
+	if (!pm_runtime_suspended(hba->dev)) {
+		ufshcd_hold(hba, false);
 		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
+		ufshcd_release(hba);
+	}
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 525f8e6..f12f5a7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6892,9 +6892,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
 
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
-
 	ret = ufshcd_verify_dev_init(hba);
 	if (ret)
 		goto out;
@@ -6945,6 +6942,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* set the state as operational after switching to desired gear */
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 
+	/* Enable Auto-Hibernate if configured */
+	ufshcd_auto_hibern8_enable(hba);
+
 	/*
 	 * If we are in error handling context or in power management callbacks
 	 * context, no need to scan the host
@@ -7962,12 +7962,12 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_resume_clkscaling(hba);
 
-	/* Schedule clock gating in case of no access to UFS device yet */
-	ufshcd_release(hba);
-
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	/* Schedule clock gating in case of no access to UFS device yet */
+	ufshcd_release(hba);
+
 	goto out;
 
 set_old_link_state:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

