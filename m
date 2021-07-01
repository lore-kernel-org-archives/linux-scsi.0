Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CEDC11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7D461403
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhGAVPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:50 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44751 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbhGAVPu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:50 -0400
Received: by mail-pf1-f182.google.com with SMTP id g21so7067156pfc.11
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQabxQudN92+ikdQCpAYcI4fVSqRjSnAFJgG5n6aj3M=;
        b=LV1OqT43pefAyq+Y1n7GIWhzlSF3onLl+lCi+wqNCp4T4DAb5EACu5X36UN7JbCtRz
         lkHnZzryRrdcS+4ERGYovcvpK4R5uGysVuYvWHtHI1x7tI1mo+EYK+mdtCywzykAKdop
         suowroJOsBy87fJ+FLY/ha6FmcOUjxJDPN8GqW/hOX6GanoTgHueR6lYrColVybrHX/M
         eK+u26Hl+HUgGByA6OZ4pFbekwm+QvpxxbSz68aNB/pSqvKbSStGxwSSCMvS1x6Xoi2R
         UNL2i6NKoXGv/Nkkwk5BvvXVvY21qPJn9SoXuZIK1dDUF66H0goWGKa9UjBVmEaC24dV
         iPrg==
X-Gm-Message-State: AOAM5321vEB50RsCTKKRfLdBKaHk03GBeXde6IEmZCTyQGXFLNX4nKSz
        sv5KxXjSJ6z11th37Ie5fdw=
X-Google-Smtp-Source: ABdhPJzeC3ZHqs4FqPyjiKKtLhsJI5mUqY9x06RTknBSXGy9J01QY7BuTOGsswER97vqyVxKHXu+tA==
X-Received: by 2002:a05:6a00:7cb:b029:310:34e3:4830 with SMTP id n11-20020a056a0007cbb029031034e34830mr1981893pfu.8.1625173998138;
        Thu, 01 Jul 2021 14:13:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 11/21] ufs: Verify UIC locking requirements at runtime
Date:   Thu,  1 Jul 2021 14:12:14 -0700
Message-Id: <20210701211224.17070-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of documenting the locking requirements of the UIC code as comments,
use lockdep_assert_held() such that lockdep verifies the lockdep
requirements at runtime if lockdep is enabled.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 +++++++++-------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2e6aa614e3f5..1262f1a63e0b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2242,15 +2242,15 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
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
@@ -2268,11 +2268,10 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
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
@@ -2281,6 +2280,8 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+
 	if (wait_for_completion_timeout(&uic_cmd->done,
 					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
@@ -2310,14 +2311,15 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
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
index 79f6c261dfff..0dfb5e97ec0d 100644
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
