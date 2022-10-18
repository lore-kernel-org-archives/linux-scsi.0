Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B32C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJRUbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJRUbZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:31:25 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A804B4B3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:23 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d10so15219386pfh.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HzAJlZt0y1OjoJayHlbUIais9dg6RO8lQh7wFO+mTNs=;
        b=Eftt+AmRkgcN2uwTJ/ObItSECgzH8WqjLd5cUx4+PGZLKBH6uvpvKBFb8NxVZn+eZF
         i1FD3qc+C+65u+aLMhJXx4Bvl8lwr89hmnYFgL1ohbcLyp7OVk0bXDgV0vPkuBU6kghE
         r+jatKwoE1KvIrMjXj2gsPOZbM9i703hbEnB6bxRm3H4gEsPsYgP1/gdgDO9FGh5wUfZ
         aHPo2rU5uWym5trF5EWNiZSBX5vnmNe6regOINTVQwxm3B29/P7UtF4uxvaxvV6LJRo1
         Ji3WRmRo8wrwt3W2XkVda2ygJns/Iuvr1e4NO6SoH4Z56RSCReRKCcC6O6ITg9sbMaIh
         xGSw==
X-Gm-Message-State: ACrzQf0yjDFYdTfi1TGRx6RSgT9zEsFqi6xKHD0V40ONB4ZCodZayezd
        cIwGGzIf6cghCUZ1UTEREx8=
X-Google-Smtp-Source: AMsMyM61QhUh09XjDl77m4Psng7ncAk27slN84DM5PPlhCyVI9B4F1x3mJLVqdq873QkvNRrNhWCwA==
X-Received: by 2002:a63:d314:0:b0:452:598a:cc5a with SMTP id b20-20020a63d314000000b00452598acc5amr4226450pgg.299.1666125082803;
        Tue, 18 Oct 2022 13:31:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:31:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        jongmin jeong <jjmin.jeong@samsung.com>
Subject: [PATCH v4 08/10] scsi: ufs: Track system suspend / resume activity
Date:   Tue, 18 Oct 2022 13:29:56 -0700
Message-Id: <20221018202958.1902564-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new boolean variable that tracks whether the system is suspending,
suspended or resuming. This information will be used in a later patch to
fix a deadlock between the SCSI error handler and the suspend code.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 include/ufs/ufshcd.h      | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 84ca17d29898..2a32bcc93d2e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9247,6 +9247,7 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
+	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -9288,6 +9289,7 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
+	hba->system_suspending = false;
 	up(&hba->host_sem);
 	return ret;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9f28349ebcff..96538eb3a6c0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -802,7 +802,9 @@ struct ufs_hba_monitor {
  * @caps: bitmask with information about UFS controller capabilities
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
- * @is_sys_suspended: whether or not the entire system has been suspended
+ * @system_suspending: system suspend has been started and system resume has
+ *	not yet finished.
+ * @is_sys_suspended: UFS device has been suspended because of system suspend
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
@@ -943,6 +945,7 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
+	bool system_suspending;
 	bool is_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
