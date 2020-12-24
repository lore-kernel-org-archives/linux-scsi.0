Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431D3C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DB1224B1
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgLXRVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 12:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbgLXRVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 12:21:09 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23782C0613ED;
        Thu, 24 Dec 2020 09:20:29 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 6so4037164ejz.5;
        Thu, 24 Dec 2020 09:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PYycvZZtwv/h41HPPKiYNBu4NL6LfmBrKKP66ExytA8=;
        b=p8gLsi1W5BS0fLO7h/XP01TZk9IHMhDz2+a0nVYDI1BQULoIXmMGQSy/rVwHmPpsZx
         jhQa88c7R+ERK2CvwEcNElAqiMz1f1Ms9afTjAh89irUo1YY2FCfL8AeKURciX5DZ6gF
         nvz132IAObMGwRTbDbiS2qpms8VfaF4AIE2kyxnaDrpwvwT7L2v/Plr2N3AxhdOddKzq
         eQa/pMeHAadtZroYliX/JK1bOQu9BIOuYpyvR7L6RWwcdjpG63WomFCe+tNc08Hzldq/
         FaefQZo/wv7SatN5goG7t9X57M3ai15+PRXuQ14bkgp9FhBpFdQhkeU5rsb6rj6gimWA
         J3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PYycvZZtwv/h41HPPKiYNBu4NL6LfmBrKKP66ExytA8=;
        b=EUqy3DT194KrAV5opTECU7HnzHsej3o5yOnz+/a86zqd5+ld98ZfM1PEBM6QC3y5Dj
         CF7HRUDHDxZOacV1cQDZVsZcd0AIBlnQ0JY4cqIJwaMc3AjjAXih1ApV8MlTE7d9CG2T
         +BEganrp86MUNHU0lFHu22UBpEc6PJ7vEqYwLeCss3rk1r0RqCFsGxW4TQ151j3P6q4u
         n/1Usrcd+Ksp9HZAtGtu5LFhig2fIzE6v+n1rYNGMbvKM3xm2zqocii9KFZrpWuO8ay9
         ZLVrdyi/GbW5/VGiH3hCemHB+smfF/jhsQcNxva2mZcFIkakBiuQUjtrU+GZjgcO9eqv
         QClg==
X-Gm-Message-State: AOAM532rO39d25FQDeoNTTroMJyAywm6jmbcADAn/Toua0l3mbXfKAsf
        E/YAqNVvy7R8Rmx8r1s52aa5fFjqpmjrKg==
X-Google-Smtp-Source: ABdhPJwDLNmkh3yZW5f7r/O2OrAwj05q/Ovu3ZsJimwP+OxRmgm+mvBPEqQRIn+R+o0JxLRTi4PKOQ==
X-Received: by 2002:a17:906:3711:: with SMTP id d17mr28536567ejc.121.1608830427928;
        Thu, 24 Dec 2020 09:20:27 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id m5sm12874446eja.11.2020.12.24.09.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 09:20:27 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v2 3/3] scsi: ufs: Let resume callback return -EBUSY after ufshcd_shutdown
Date:   Thu, 24 Dec 2020 18:20:10 +0100
Message-Id: <20201224172010.10701-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224172010.10701-1-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

After ufshcd_shutdown(), both UFS device and UFS LINk are powered off,
return '0' will mislead the upper PM layer since the device has not been
successfully resumed yet. This will let pm_runtime_get_sync() caller
mistakenly believe the device/LINK has been resumed, which leads to
request processing timeout that was en-queued later.

To fix this, let ufshcd_system/runtimie_resume() return -EBUSY in case of
hba->is_powered == false.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add25a7e..e1bcac51c01f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8950,14 +8950,16 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 		return -EINVAL;
 	}
 
-	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
+	if (!hba->is_powered || pm_runtime_suspended(hba->dev)) {
 		/*
 		 * Let the runtime resume take care of resuming
 		 * if runtime suspended.
 		 */
+		ret = -EBUSY;
 		goto out;
-	else
+	} else {
 		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
+	}
 out:
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
@@ -9026,10 +9028,12 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
 	if (!hba)
 		return -EINVAL;
 
-	if (!hba->is_powered)
+	if (!hba->is_powered) {
+		ret = -EBUSY;
 		goto out;
-	else
+	} else {
 		ret = ufshcd_resume(hba, UFS_RUNTIME_PM);
+	}
 out:
 	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-- 
2.17.1

