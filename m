Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D40BC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70523611AD
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhESUW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 16:22:29 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:55938 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhESUW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 16:22:27 -0400
Received: by mail-pj1-f50.google.com with SMTP id gf3so935994pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 13:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fK/Nx/uJXLZgXaOq1lku5zritdZff4HjGYQCviqJBoQ=;
        b=i1cRmKPuP6Ta047EjDp/Cq1ot/EpMcrolsy/x3MmoTmNBxLVRbKqIo+1kJ7mOSuTp/
         yO4rT7NiXANM5KmBO+uZQ5BBBfKGDtxki0OHTzXgMtMfVbyHdpl31bzEhJphmNUA92Zd
         xpN4UtSGVI0V5th5PaWlcKs4aGf1hskFy6ELfia40ljChtneti3pkkSCZPSn6zVi2GVH
         dsbCoQbx+4nudc5W8H6/wTs6N18GfuDsm537MwCe1ejwwqP1M4JnQTzQNYTA9Waw2kte
         lLnwlG2pRjT0OdDm7QNdsMFaSGHw5vij6AMgQ4ojOaJ7AXa5LRdGctgOQLGpPDgsrKpj
         bncw==
X-Gm-Message-State: AOAM531ihBADPA5ZSzLhyUq/cGKcqiBE4+42q9jPJJpfldAq/GVx74TP
        4RK8IykRSMhlRODOhwI55fw=
X-Google-Smtp-Source: ABdhPJz/Cfq/O5KiTosAP+paZ2meK+9lmCxWtefyn/xLVCkcfQAd3eF50J80tmhkK/yTgftPkafbKQ==
X-Received: by 2002:a17:90a:5649:: with SMTP id d9mr749846pji.163.1621455667183;
        Wed, 19 May 2021 13:21:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:db5a:2bf3:3617:be1c])
        by smtp.gmail.com with ESMTPSA id o4sm220338pfk.15.2021.05.19.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 13:21:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 2/2] ufs: Use designated initializers in ufs_pm_lvl_states[]
Date:   Wed, 19 May 2021 13:20:58 -0700
Message-Id: <20210519202058.12634-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519202058.12634-1-bvanassche@acm.org>
References: <20210519202058.12634-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The comments in the enum ufs_pm_level definition are redundant. Remove the
comments from the ufs_pm_level enum and use designated initializers in the
ufs_pm_lvl_states[] definition instead.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++++-------
 drivers/scsi/ufs/ufshcd.h | 14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d330eae02890..ed8b570f929c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -162,17 +162,17 @@ enum {
 	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
 struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
-	{UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
-	{UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
-	{UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE},
-	{UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE},
-	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE},
-	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE},
+	[UFS_PM_LVL_0] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
+	[UFS_PM_LVL_1] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	[UFS_PM_LVL_2] = {UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE},
+	[UFS_PM_LVL_3] = {UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	[UFS_PM_LVL_4] = {UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE},
+	[UFS_PM_LVL_5] = {UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE},
 	/*
 	 * For DeepSleep, the link is first put in hibern8 and then off.
 	 * Leaving the link in hibern8 is not supported.
 	 */
-	{UFS_DEEPSLEEP_PWR_MODE, UIC_LINK_OFF_STATE},
+	[UFS_PM_LVL_6] = {UFS_DEEPSLEEP_PWR_MODE, UIC_LINK_OFF_STATE},
 };
 
 static inline enum ufs_dev_pwr_mode
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0f0e62bfdafd..91f0a8d6d750 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -155,13 +155,13 @@ enum uic_link_state {
  * power off.
  */
 enum ufs_pm_level {
-	UFS_PM_LVL_0, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE */
-	UFS_PM_LVL_1, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_2, /* UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE */
-	UFS_PM_LVL_3, /* UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_4, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE */
-	UFS_PM_LVL_5, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE */
-	UFS_PM_LVL_6, /* UFS_DEEPSLEEP_PWR_MODE, UIC_LINK_OFF_STATE */
+	UFS_PM_LVL_0,
+	UFS_PM_LVL_1,
+	UFS_PM_LVL_2,
+	UFS_PM_LVL_3,
+	UFS_PM_LVL_4,
+	UFS_PM_LVL_5,
+	UFS_PM_LVL_6,
 	UFS_PM_LVL_MAX
 };
 
