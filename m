Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CADC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EB502073A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hueIDgC4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L/jrEf8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfKOGKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:10:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKOGKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 01:10:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B6CDA611BD; Fri, 15 Nov 2019 06:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798207;
        bh=FwdFdOmJd9KNWRI6RrHvYALDn8KmaSzJOep2nOMopZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hueIDgC4vp6Ioq1PDSuG+Csm/Wa1PG7fcMHrGHja9kZ5W8x6uo/26AuwEQs1tTRcg
         3QUwnyjyT6iLfJEL4GYp4jYOwCLiNYnz8JGtDD0TX5wV2EPKX/9VE10EVIH1zfePxD
         c+M4w7ptpaO5mJek44AlslfYTZMFU1Sr5W31OSRg=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BD1B611A3;
        Fri, 15 Nov 2019 06:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573798199;
        bh=FwdFdOmJd9KNWRI6RrHvYALDn8KmaSzJOep2nOMopZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/jrEf8fCBPdBVAD7Ud34HdNZZ0ZJ7eEj0DO+aReG7AL8qoZ8SrirMmzSERGobjo2
         csz7zbmiYPic/8uvVRoJQirmW4x/lnW5wg6y617UFLgAQdfcLZihJPG+50EfMVgtTV
         dN3GxIJ5/ThYzUXArfJ/xZrPZGhvuCkXL3AkboBU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BD1B611A3
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
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 3/7] scsi: ufs: Fix up auto hibern8 enablement
Date:   Thu, 14 Nov 2019 22:09:26 -0800
Message-Id: <1573798172-20534-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix up possible unclocked register access to auto hibern8 register in
resume path and through sysfs entry. Meanwhile, enable auto hibern8
only after device is fully initialized in probe path.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 15 +++++++++------
 drivers/scsi/ufs/ufshcd.c    | 14 +++++++-------
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 969a36b..ad2abc9 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -126,13 +126,16 @@ static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		return;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit == ahit)
-		goto out_unlock;
-	hba->ahit = ahit;
-	if (!pm_runtime_suspended(hba->dev))
-		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-out_unlock:
+	if (hba->ahit != ahit)
+		hba->ahit = ahit;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (!pm_runtime_suspended(hba->dev)) {
+		pm_runtime_get_sync(hba->dev);
+		ufshcd_hold(hba, false);
+		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_release(hba);
+		pm_runtime_put(hba->dev);
+	}
 }
 
 /* Convert Auto-Hibernate Idle Timer register value to microseconds */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 525f8e6..9bc2cad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3947,7 +3947,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
+void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
 {
 	unsigned long flags;
 
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
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..2740f69 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -926,6 +926,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 
+void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
+
 #define SD_ASCII_STD true
 #define SD_RAW false
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

