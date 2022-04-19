Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84FDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358386AbiDSXBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358382AbiDSXBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:32 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1455838BDB
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:48 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so3284513pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QD+tceN/gEAQQC3Pa7ZlKSYJgpeqDDr4LSkw0SqEVW8=;
        b=RU834wkzzIe9mtZbJrnXONst6g+0Gjh44Cp7R30jp7cDlNmy2jlhZ0V3b6DGd0Tz08
         d4SAnXOX/YhKVALIGylLklmVWmb2LNYdLl7n/CxsoIC/iKSatP7sepsb6+zuS4eirRvV
         CH6nCWxojbW/9Vn7yXVhyYQUvYB8napqiwWn9TP+VIeis1dIDrJel0TzcyVLldoOTWlQ
         3kUD55t4Kc/IJ1VRMGUW/8B/uLdi6a+I/DiMUx1fIz/zW5oddYgkZL6moJ5kcXsLq9HG
         tbN9/9DG4D9qJNJHcwmcOc3HW5XTnVD7AHoEacwepc7z0WK8NWXgOI+FVZHPu+Zej9iI
         JD9Q==
X-Gm-Message-State: AOAM530emeH9hMDw3vZyF7EhlaZsrYcyCJoclsZ7xLU18dHx3IoT12Pi
        6diCVMAiETtgGE7ZRszamFo=
X-Google-Smtp-Source: ABdhPJyANM+KiToUKNk51hDoj87wV87+NyfRuis9pv8PtwNph7Azm1//Wvo3xB/n2Pq3fr8eqJz9hQ==
X-Received: by 2002:a17:902:b703:b0:158:2667:7447 with SMTP id d3-20020a170902b70300b0015826677447mr17850962pls.92.1650409127504;
        Tue, 19 Apr 2022 15:58:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v3 14/28] scsi: ufs: Make the config_scaling_param calls type safe
Date:   Tue, 19 Apr 2022 15:57:57 -0700
Message-Id: <20220419225811.4127248-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the actual type to config_scaling_param callback as the third
argment instead of a void pointer. Remove a superfluous NULL pointer
check from ufs_qcom_config_scaling_param().

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 14 ++++----------
 drivers/scsi/ufs/ufshcd.h   | 10 +++++-----
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 808b677f6083..dded29722880 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1463,23 +1463,17 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
 
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
-					  struct devfreq_dev_profile *p,
-					  void *data)
+					struct devfreq_dev_profile *p,
+					struct devfreq_simple_ondemand_data *d)
 {
-	static struct devfreq_simple_ondemand_data *d;
-
-	if (!data)
-		return;
-
-	d = (struct devfreq_simple_ondemand_data *)data;
 	p->polling_ms = 60;
 	d->upthreshold = 70;
 	d->downdifferential = 5;
 }
 #else
 static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
-					  struct devfreq_dev_profile *p,
-					  void *data)
+		struct devfreq_dev_profile *p,
+		struct devfreq_simple_ondemand_data *data)
 {
 }
 #endif
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 107d19e98d52..bb2624aabda2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -348,8 +348,8 @@ struct ufs_hba_variant_ops {
 	int	(*phy_initialization)(struct ufs_hba *);
 	int	(*device_reset)(struct ufs_hba *hba);
 	void	(*config_scaling_param)(struct ufs_hba *hba,
-					struct devfreq_dev_profile *profile,
-					void *data);
+				struct devfreq_dev_profile *profile,
+				struct devfreq_simple_ondemand_data *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
@@ -1360,11 +1360,11 @@ static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
 }
 
 static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
-						    struct devfreq_dev_profile
-						    *profile, void *data)
+		struct devfreq_dev_profile *p,
+		struct devfreq_simple_ondemand_data *data)
 {
 	if (hba->vops && hba->vops->config_scaling_param)
-		hba->vops->config_scaling_param(hba, profile, data);
+		hba->vops->config_scaling_param(hba, p, data);
 }
 
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
