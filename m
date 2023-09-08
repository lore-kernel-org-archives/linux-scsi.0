Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096DDEE8012
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 14:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbjIHOyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbjIHOyw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2023 10:54:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4BD2100
        for <linux-scsi@vger.kernel.org>; Fri,  8 Sep 2023 07:54:27 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-68a3b66f350so1975320b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Sep 2023 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694184867; x=1694789667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v0/IfcD+bVp+TwfTl9BonGyGe+3MQ6GUS3Cq64UrgTs=;
        b=i/prfLoQBAJv5JeNcRoJ0k7D8scN144PeGCyyS0LqUMlyJwGCJ9Toh40FXN1kjxNpS
         0xFIQ8REKv/o6Qe8uxTEjjBwPTYXxORatEKbKfTpTOINPzclQoMh6E3eHxvsXd/xDWK0
         GGBM0/SyY0sCKHkWQzvk5KGrjEySG+kWQm7QQ8LNU7IeTi1WBcWTeVj1etOWpAOLAb9d
         GoqCbVcINuwhPyBOIXU/Afqw5FLsBySQT+g1QzaEMnAuTHlHsPTjKm3O+kLw409svJDv
         8drIGiIpHrOI53of/ec616ewcAq+GaufzLAfjfN5dR8ACp/3ovufiAfRfXADcFEKFj1O
         PUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694184867; x=1694789667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0/IfcD+bVp+TwfTl9BonGyGe+3MQ6GUS3Cq64UrgTs=;
        b=Vbx3lAtsub3JhD/6sdaLFxOdfi84oZMchD+7s6rBne6OpXNsfoypT/MZk6SBdlQCJd
         hDPjjWO0+lYIRAOykkEC4hS87eQs7mmiEorQbpyarkZgQjU/2KbUIj6v0rjKlC0dDoFY
         0CFqHjhuKONFg9DTrWDg8B5qm7tx/a40vBzvC4RGNJ3CwTV96+3WUaT83BBSQR6XfoSn
         jui/bDNxNGy2NO7pbQxSHom7lF5wxhAMYeEMSpEH3o2iPgkD9RjexUnfpfSlmn8/+jWN
         67UZ5NHerKc7JLv/ROegyYMYgpOHJFlgK1a++Kpml5iG5bOC+l1xQrnzf7IYJEoXyYUx
         Gjxw==
X-Gm-Message-State: AOJu0YxYxwAgtuuzolveJpCBZDcf+qcba7TaM/OQ9SF6LBdTPWKoil7T
        yZOUQazgSUXSRfTUpFKcxjgz
X-Google-Smtp-Source: AGHT+IHYIFo3OMAOQfRI0s5oC0CJ3wzrb/Rkg+Xten7sB/lRtfVzRDXX2fUj57YnJVr4eUxM1qFMjg==
X-Received: by 2002:a05:6a00:1825:b0:68e:2dad:13a5 with SMTP id y37-20020a056a00182500b0068e2dad13a5mr2811724pfa.10.1694184866738;
        Fri, 08 Sep 2023 07:54:26 -0700 (PDT)
Received: from localhost.localdomain ([117.193.215.15])
        by smtp.gmail.com with ESMTPSA id t4-20020a62ea04000000b0068a30f6cf32sm1463212pfh.143.2023.09.08.07.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Sep 2023 07:54:26 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     bvanassche@acm.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: ufs: ufs-qcom: Update PHY settings only when scaling to higher gears
Date:   Fri,  8 Sep 2023 20:23:28 +0530
Message-Id: <20230908145329.154024-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "hs_gear" variable is used to program the PHY settings (submode) during
ufs_qcom_power_up_sequence(). Currently, it is being updated every time the
agreed gear changes. Due to this, if the gear got downscaled before suspend
(runtime/system), then while resuming, the PHY settings for the lower gear
will be applied first and later when scaling to max gear with REINIT, the
PHY settings for the max gear will be applied.

This adds a latency while resuming and also really not needed as the PHY
gear settings are backwards compatible i.e., we can continue using the PHY
settings for max gear with lower gear speed.

So let's update the "hs_gear" variable _only_ when the agreed gear is
greater than the current one. This guarantees that the PHY settings will be
changed only during probe time and fatal error condition.

Due to this, UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH can now be skipped
when the PM operation is in progress.

Cc: stable@vger.kernel.org
Fixes: 96a7141da332 ("scsi: ufs: core: Add support for reinitializing the UFS device")
Reported-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/core/ufshcd.c   | 3 ++-
 drivers/ufs/host/ufs-qcom.c | 9 +++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 34472871610d..1f0a9d96e613 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8782,7 +8782,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	if (ret)
 		goto out;
 
-	if (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
+	if (!hba->pm_op_in_progress &&
+	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
 		ufshcd_device_reset(hba);
 		ufshcd_hba_stop(hba);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 78689d3479e4..ebb8054a3b3e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -909,8 +909,13 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 			return ret;
 		}
 
-		/* Use the agreed gear */
-		host->hs_gear = dev_req_params->gear_tx;
+		/*
+		 * Update hs_gear only when the gears are scaled to a higher value. This is because,
+		 * the PHY gear settings are backwards compatible and we only need to change the PHY
+		 * settings while scaling to higher gears.
+		 */
+		if (dev_req_params->gear_tx > host->hs_gear)
+			host->hs_gear = dev_req_params->gear_tx;
 
 		/* enable the device ref clock before changing to HS mode */
 		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
-- 
2.25.1

