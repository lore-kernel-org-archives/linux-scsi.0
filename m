Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79F4C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 17:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C57C6143C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 17:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEMRNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 13:13:48 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:38584 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhEMRNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 13:13:46 -0400
Received: by mail-pf1-f173.google.com with SMTP id k19so22408313pfu.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 10:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMxje/aZ2RAhQ1qm6dJad4RiQPV5B0DmcVKZHMem3CM=;
        b=QGS9hJLViuW138lWevl3WVEZTVFwfBT0mPhrTVgoE7KO1wj1AHIBVMttJNMaNJJ5TO
         TBtdqF3MNfwhbBaavlP3c0a1udy98qosufTy7r7/CQ1YXXQxjMRtZg4UjTIWPt4AEcA0
         RVvlzIwKe7A6bp/0VQFoUKX2l8yW10gkeiAuZDPUyrpm16gRBSFH45myzfui7srzo1fg
         2M/zf+Xm+Ll2HegFWrr10tpEkaTmlhMKi9JxB5LMzqfTHX0lUVUWh1DeoXi0ntqU0lOc
         Qz/81RrlLFnBdBJydbjsSoljJ4iqJVzjeo/yW5nvFBwWcH0vTJ6ksZ6dY3FT7ayI3q+2
         vp+g==
X-Gm-Message-State: AOAM531Sqn7pT+yEOBYCcQUx8ITYTd69MQCmcdnk1zGHEklj7ivc066W
        ITIV/56atz46tkscGXYlOco=
X-Google-Smtp-Source: ABdhPJypsKalErSO5C4/LP+78XQSBTtdspC0raDvqiK79qETPUHGcP8IcPmp1RPuYMN7zqrrwrzfjg==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr5967361pjs.112.1620925956025;
        Thu, 13 May 2021 10:12:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6dd7:5386:8c63:ccae])
        by smtp.gmail.com with ESMTPSA id v22sm2412398pff.105.2021.05.13.10.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 10:12:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: Remove usfhcd_is_*_pm() macros
Date:   Thu, 13 May 2021 10:12:29 -0700
Message-Id: <20210513171229.7439-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove these macros to make the UFS driver source code easier to read.
These macros were introduced by commit 57d104c153d3 ("ufs: add UFS power
management support").

Cc: Can Guo <cang@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-hisi.c | 2 +-
 drivers/scsi/ufs/ufshcd.c   | 8 ++++----
 drivers/scsi/ufs/ufshcd.h   | 4 ----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 0aa58131e791..e4758757fbab 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -400,7 +400,7 @@ static int ufs_hisi_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
 
-	if (ufshcd_is_runtime_pm(pm_op))
+	if (pm_op == UFS_RUNTIME_PM)
 		return 0;
 
 	if (host->in_suspend) {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4f6b0e28735f..4510be031e14 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8668,8 +8668,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum uic_link_state req_link_state;
 
 	hba->pm_op_in_progress = 1;
-	if (!ufshcd_is_shutdown_pm(pm_op)) {
-		pm_lvl = ufshcd_is_runtime_pm(pm_op) ?
+	if (pm_op != UFS_SHUTDOWN_PM) {
+		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
 		req_dev_pwr_mode = ufs_get_pm_lvl_to_dev_pwr_mode(pm_lvl);
 		req_link_state = ufs_get_pm_lvl_to_link_pwr_state(pm_lvl);
@@ -8703,7 +8703,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		goto enable_gating;
 	}
 
-	if (ufshcd_is_runtime_pm(pm_op)) {
+	if (pm_op == UFS_RUNTIME_PM) {
 		if (ufshcd_can_autobkops_during_suspend(hba)) {
 			/*
 			 * The device is idle with no requests in the queue,
@@ -8733,7 +8733,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	flush_work(&hba->eeh_work);
 
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
-		if (!ufshcd_is_runtime_pm(pm_op))
+		if (pm_op != UFS_RUNTIME_PM)
 			/* ensure that bkops is disabled */
 			ufshcd_disable_auto_bkops(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5eb66a8debc7..08d86005f8aa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -106,10 +106,6 @@ enum ufs_pm_op {
 	UFS_SHUTDOWN_PM,
 };
 
-#define ufshcd_is_runtime_pm(op) ((op) == UFS_RUNTIME_PM)
-#define ufshcd_is_system_pm(op) ((op) == UFS_SYSTEM_PM)
-#define ufshcd_is_shutdown_pm(op) ((op) == UFS_SHUTDOWN_PM)
-
 /* Host <-> Device UniPro Link state */
 enum uic_link_state {
 	UIC_LINK_OFF_STATE	= 0, /* Link powered down or disabled */
