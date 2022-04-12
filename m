Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E5AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbiDLSXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358680AbiDLSXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:23:42 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B38C5D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:24 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id w7so18178173pfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QD+tceN/gEAQQC3Pa7ZlKSYJgpeqDDr4LSkw0SqEVW8=;
        b=hB9qNSxuS0Joxa2hReg8Vq0AOaDP5mI2ejX8rCCjFOgODgX/WEKpJt7GPeSnrP+S1p
         IuvLSEOl9pWZ6+bnPZ91M+4+FKGII+HnPkucY6M0t3Cr1a79BiYbSSJmyNltGXEojEk6
         aj8osRANaGENw5lHE2Q3fSTWS65PYH2KTE1TSUaOV2KngA8Xy7BJYR9DUZcl5SFL4Hxg
         p/5CQYFDup+KyEJEc4HLJfhZQx7jVZUEeV4xLp8owwroNTgdBx46M5DBPj9sUx9rvxdp
         oJf4DbAhuPb0bJt2oDaJdIP5MT3j+KaLhPLa+phT9UXUAKwI/PfN08F4yw5egPKkOXSU
         dxXA==
X-Gm-Message-State: AOAM533X+GUAfA4JU2jLhRj28/S96HPEeKd/7CZ5fPiR3gg1nebqDxuQ
        7DENDiHf//c8UT2T6/hvMjw=
X-Google-Smtp-Source: ABdhPJzVQwvjQ5odGZ5Zbi+q8jFvs80L+uFCuv3+r5FrWjf9KSu2BZs4uWuY+MyogLTQBhsVd8YEzg==
X-Received: by 2002:a05:6a00:21c2:b0:4fe:81f:46c7 with SMTP id t2-20020a056a0021c200b004fe081f46c7mr38826748pfj.5.1649787683755;
        Tue, 12 Apr 2022 11:21:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:21:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Ye Bin <yebin10@huawei.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 14/29] scsi: ufs: Make the config_scaling_param calls type safe
Date:   Tue, 12 Apr 2022 11:18:38 -0700
Message-Id: <20220412181853.3715080-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
