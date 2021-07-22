Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDC6C07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986BD6124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhGVCyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:49 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:38845 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhGVCyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:47 -0400
Received: by mail-pj1-f42.google.com with SMTP id j8-20020a17090aeb08b0290173bac8b9c9so2303911pjz.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=koU+FcaW4t9BY1jN0JNAOYV8a8f/9b4v2qM5DbqkKB0=;
        b=i255D6xMAHFQL9GyDqmeOLn+usIto79e7iB2LVh3HuSN3jmpBBdDcnjJaPWaCwSB8T
         x0TE1AEOY+G57hcOGL5wbKA4d6M5HbYy0pOEKj9Hm1XUqvHGvqga9AgzFQJmj9OzUxmJ
         mFlXObhvLDhcC+xZXSr8MOJvgvEF+Sn7pY+VgH4NS1WUkY1z176Zaqwim4Z2tBNRJItp
         Mu7eNsLWG7po6cuarlnQ8+5hwPxA+iYb+ZOHYlEsmRxFRSfYKTltFl+dknfTqQWX09fR
         Gcs/+QTixX6gEh65xZ7NpcarmmpyL1RFYz03TuLxJPlLgWA9QGIGMt1ewsPrQXcA/uPZ
         EiXw==
X-Gm-Message-State: AOAM530xSZblqmMHp8RkmEhvCtCD3H4KP3CAJ1jgruZCDGARq1GLL+T4
        Fr/MiaKwr1DIwc8gyQuNtyQ=
X-Google-Smtp-Source: ABdhPJwkBHj1luRoWWpfJfEyvT0KRezkm3ZKsF8TmMhsExmaaOTMGI1mqQHgwBf1Z0bZEvRl18Z3eA==
X-Received: by 2002:a17:90b:246:: with SMTP id fz6mr37963676pjb.80.1626924922659;
        Wed, 21 Jul 2021 20:35:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 07/18] scsi: ufs: Verify UIC locking requirements at runtime
Date:   Wed, 21 Jul 2021 20:34:28 -0700
Message-Id: <20210722033439.26550-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of documenting the locking requirements of the UIC code as comments,
use lockdep_assert_held() such that lockdep verifies the lockdep
requirements at runtime if lockdep is enabled.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 +++++++++-------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ec12cd4eae03..233a1cf53dce 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2241,15 +2241,15 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
+ * ufshcd_dispatch_uic_cmd - Dispatch an UIC command to the Unipro layer
  * @hba: per adapter instance
  * @uic_cmd: UIC command
- *
- * Mutex must be held.
  */
 static inline void
 ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+
 	WARN_ON(hba->active_uic_cmd);
 
 	hba->active_uic_cmd = uic_cmd;
@@ -2267,11 +2267,10 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 }
 
 /**
- * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
+ * ufshcd_wait_for_uic_cmd - Wait for completion of an UIC command
  * @hba: per adapter instance
  * @uic_cmd: UIC command
  *
- * Must be called with mutex held.
  * Returns 0 only if success.
  */
 static int
@@ -2280,6 +2279,8 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+
 	if (wait_for_completion_timeout(&uic_cmd->done,
 					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
@@ -2309,14 +2310,15 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  * @uic_cmd: UIC command
  * @completion: initialize the completion only if this is set to true
  *
- * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
- * with mutex held and host_lock locked.
  * Returns 0 only if success.
  */
 static int
 __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 		      bool completion)
 {
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+	lockdep_assert_held(hba->host->host_lock);
+
 	if (!ufshcd_ready_for_uic_cmd(hba)) {
 		dev_err(hba->dev,
 			"Controller not ready to accept UIC commands\n");
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0a3afd9499c9..be9e6c683abe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -683,7 +683,7 @@ struct ufs_hba_monitor {
  * @priv: pointer to variant specific private data
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for uic command
+ * @uic_cmd_mutex: mutex for UIC command
  * @tmf_tag_set: TMF tag set.
  * @tmf_queue: Used to allocate TMF tags.
  * @pwr_done: completion for power mode change
