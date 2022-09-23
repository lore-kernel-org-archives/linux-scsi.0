Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD90C07E9D
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiIWUND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiIWUNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:13:02 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93228122A67
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:13:00 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso1247044pjd.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jXWR4AVAWF987AHP3UYR0s/kfBXgLj1RujhUau0QATU=;
        b=peh72EMCLcL+W8WLAJrHYHJaVj4f4++NhJNgC7an7MP5RxvcXsrmurKkGUJ6PhaUT6
         hML9knCLIieNHLa8JwRiv5p3WMtGiTQgdQWIrnVW8txuIf6BdgGEneF+58qj/XoZpkt6
         0fyIqJvr0vl60J6B+altpvIdm22xJt0f4xzveoJRKLUUvd4bkZMUjs8C54JrutTQdfQc
         pJBG+3wjtyR7kSfTWN7lWOTL20wQrmqZSd+eyZcMswuL8YnHqNEaC2T/4hVTrmjYRcS3
         j53Fk6VKAO1TB9ujuZDvp2pt9gHCuhRkSJQ9Ad/fL+S0RW/I7IvF5WMqpa7ihHa1CutN
         0zpg==
X-Gm-Message-State: ACrzQf2EulCHRFbBP0qMjJTWm8kh90Vh1371rVNVxNIdi1ftCDLeOEX6
        TXpLkQ0qc7gB8lsa09H4rNk=
X-Google-Smtp-Source: AMsMyM4Rq2bQonlSzZaOlCcbD4FbgLcAQcnuFq++swEL+AbZJ9ILvhdkYGxyRl3x3cYPIx+r8XohFw==
X-Received: by 2002:a17:903:246:b0:179:96b5:1ad2 with SMTP id j6-20020a170903024600b0017996b51ad2mr9926711plh.37.1663963979904;
        Fri, 23 Sep 2022 13:12:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:12:59 -0700 (PDT)
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        jongmin jeong <jjmin.jeong@samsung.com>
Subject: [PATCH 7/8] scsi: ufs: Add a PM notifier
Date:   Fri, 23 Sep 2022 13:11:37 -0700
Message-Id: <20220923201138.2113123-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a PM notifier to track whether or not the system is suspending. This
information will be used in a later patch to fix a deadlock between the
SCSI error handler and the suspend code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 24 ++++++++++++++++++++++++
 include/ufs/ufshcd.h      |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d7453f788d0d..abeb120b12eb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9246,6 +9246,25 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 }
 #endif
 
+static int ufshcd_pm_cb(struct notifier_block *nb, unsigned long action,
+			void *data)
+{
+	struct ufs_hba *hba = container_of(nb, typeof(*hba), pm_nb);
+
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		hba->system_suspending = true;
+		break;
+	case PM_POST_RESTORE:
+	case PM_POST_SUSPEND:
+		hba->system_suspending = false;
+		break;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_wl_suspend(struct device *dev)
 {
@@ -9534,6 +9553,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+	unregister_pm_notifier(&hba->pm_nb);
 	if (hba->ufs_device_wlun)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
@@ -9832,7 +9852,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
+	hba->pm_nb = (struct notifier_block){ .notifier_call = ufshcd_pm_cb };
+	register_pm_notifier(&hba->pm_nb);
+
 	device_enable_async_suspend(dev);
+
 	return 0;
 
 free_tmf_queue:
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 24c97e0772bb..9bc48c13006f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -802,7 +802,10 @@ struct ufs_hba_monitor {
  * @caps: bitmask with information about UFS controller capabilities
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
- * @is_sys_suspended: whether or not the entire system has been suspended
+ * @system_suspending: system suspend has been started and system resume has
+ *	not yet finished.
+ * @is_sys_suspended: UFS device has been suspended because of system suspend
+ * @pm_nb: power management notifier block
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
@@ -943,7 +946,9 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
+	bool system_suspending;
 	bool is_sys_suspended;
+	struct notifier_block pm_nb;
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
