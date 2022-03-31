Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C142FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbiCaWid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242516AbiCaWib (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:31 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7CE200958
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:42 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id bx5so754171pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vp9Y/L0z+QOegqGR+Pg527DBSp0dYXYAFnaU9Nrsr00=;
        b=ik178wz4t7oI/qc8biNHByufvLOaz81tADqgiVATz7I4YjBKavgX8rQuObzZym5rSP
         lvxIVojH/fIqWFhPCTzELNd343fPx6gV3oMg+uceJZ2+Jn48TweIw+hyEYCkgDKsKYzi
         zT6rYktJ/MacwrMr6zyxYtEu+ewjmqGYNbe8mY1PM48sTzWookL2OSxJ12V25XP1IfAt
         NshVpiTqT8ApTawhyXdarMJurhCzjsEuppOs9xhRwfcZLDEMwCh+vlwcwCJj47L52g2I
         LhLUzOjUL6/3EC2yP8jX0PCE59wdObzrrJN2HxCwKMn0868ktUo3ZDsRCS8+afXvOaV6
         yStA==
X-Gm-Message-State: AOAM531F9iAksoErFf/hztsFRW7fSiSxivEA8DoRjquydpnz5ikF/I1X
        S3LinVP1zX9AxNPBhyOoB3U=
X-Google-Smtp-Source: ABdhPJy07Pn76FAS8FGOUWj41iheVBbuCnQK4SCA3gZ5pSmXOg3hBAXJGJs4aI6e00S5qshrJxT6fw==
X-Received: by 2002:a17:90b:4a06:b0:1c7:2020:b5b9 with SMTP id kk6-20020a17090b4a0600b001c72020b5b9mr8409856pjb.58.1648766202060;
        Thu, 31 Mar 2022 15:36:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 14/29] scsi: ufs: Make the config_scaling_param calls type safe
Date:   Thu, 31 Mar 2022 15:34:09 -0700
Message-Id: <20220331223424.1054715-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the actual type to config_scaling_param callback as the third
argment instead of a void pointer. Remove a superfluous NULL pointer
check from ufs_qcom_config_scaling_param().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 14 ++++----------
 drivers/scsi/ufs/ufshcd.h   | 10 +++++-----
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 808b677f6083..f24210652fe9 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1463,23 +1463,17 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
 
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
-					  struct devfreq_dev_profile *p,
-					  void *data)
+		struct devfreq_dev_profile *p,
+		struct devfreq_simple_ondemand_data *d)
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
