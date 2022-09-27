Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA04C6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiI0SpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiI0Sor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:44:47 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0890647DC
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:42 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id t3so9888668ply.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3ITzk+ZRZ59eMKdf+XTB3AoLD9+LWF5ZWoxbHXTbn5Q=;
        b=R1rFg/qsfwHrDBwOi1OOpsUj0i1+cpZ2/7GXlYbEk3N0q+yJHkqINgZ3VPLUi+3of+
         fL/Zf7Lqa8efcPrHGF/W70ae640byx4WhX02JQ5W+01m86RaKMDx8gCyBk+CGqFizxf7
         Ha+N+uXBWbVW8nAmhNDfGCDJmK/fH/2kG9o/NK3tvXC63djFAMpPcjx/ygkavhiv4/pU
         atAkgau8iO2SZBKLa9s4poDjhumASbpsPOurHrMqE5ki0RRI3Uh/rkgNP6UwZE4Vlaqn
         tR1T+9xSAGhmmr4/9/EhTJpfOGPzOgonTBCNy7FA0ks5LmQXHc4lVxdixcp3Nzbv5XPM
         ilOA==
X-Gm-Message-State: ACrzQf2k8HQ1KO8872bwlFK92LL4PBGDJ6WirGW47wsygZTBxzSYKABD
        1bDIEHB/kVNSNiF/nweXVzfHFjycRJE=
X-Google-Smtp-Source: AMsMyM6mafPGdCS72ZkWJQDA0Me+De/D8UGJSX/Fwa21BR/CQq7H27NsXNkazNNuirxeuUFjiXCtIg==
X-Received: by 2002:a17:90b:1a87:b0:202:6b60:be62 with SMTP id ng7-20020a17090b1a8700b002026b60be62mr5841852pjb.69.1664304282018;
        Tue, 27 Sep 2022 11:44:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:44:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 7/8] scsi: ufs: Track system suspend / resume activity
Date:   Tue, 27 Sep 2022 11:43:08 -0700
Message-Id: <20220927184309.2223322-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new boolean variable that tracks whether the system is suspending,
suspended or resuming. This information will be used in a later patch to
fix a deadlock between the SCSI error handler and the suspend code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 include/ufs/ufshcd.h      | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8c0504e9e83..5507d93a4bba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9253,6 +9253,7 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
+	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -9294,6 +9295,7 @@ static int ufshcd_wl_resume(struct device *dev)
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
