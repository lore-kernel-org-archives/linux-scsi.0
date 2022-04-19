Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F690C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358388AbiDSXBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358375AbiDSXB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:28 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F7438BDA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:45 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id md4so179994pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ggqJd+K00tQFtanOxz0I5riMOWXTnNeexPzEA8SIb8=;
        b=5gtg8Jz+55w9AVYCEY3TCUFMDpodzH49j13VsJA58SSNm+S5ymiF+bWFSItM8pAsfL
         iLBw9IzyOTGKJW58/qFBgSqj3kk5EiXq664peji8OcnqY8lhUVY3W9qc3JXdRe8/8NKm
         TwXmxfCEEqJZger3DOUw1VOy2YjI/Sw6pJ/Jlg+4QLGPmedHfIwCQ9MTP7k4VHfpWgIJ
         uS1E7yDTPcLuVUHCTwG3eHLbqc9BPJq9VrTvZ4gOji7bJLUWK3rfy8j01FhWEyPF0eEm
         KeLsDptQLQQtVEtuL7hN88QDK24zRkioJZJOHWJ6KKydmSRHiRhnHgiy3fGUoGZzaQL1
         CGDg==
X-Gm-Message-State: AOAM530/bqUJgJbub+XBOJsFTj5lUUjdul9yYhQIBi+AXnK0GH0Ueu8W
        O/QEuiQNP3HtU0ryD8MbelY=
X-Google-Smtp-Source: ABdhPJz8jVNoaFZ5CQDjkUvW9VWGLbEi+N/uSx4u5erlocLYJLOfKMKn3pvkCokbrXkoAx5sU2KpQw==
X-Received: by 2002:a17:90b:4a05:b0:1d2:bdc9:df39 with SMTP id kk5-20020a17090b4a0500b001d2bdc9df39mr974163pjb.51.1650409124793;
        Tue, 19 Apr 2022 15:58:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 13/28] scsi: ufs: Switch to aggregate initialization
Date:   Tue, 19 Apr 2022 15:57:56 -0700
Message-Id: <20220419225811.4127248-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to verify for humans that ufshcd_init_pwr_dev_param()
initializes all structure members. This patch does not change any
functionality.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index cca4b2181a81..9923cbc70653 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -297,18 +297,20 @@ EXPORT_SYMBOL_GPL(ufshcd_get_pwr_dev_param);
 
 void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param)
 {
-	dev_param->tx_lanes = 2;
-	dev_param->rx_lanes = 2;
-	dev_param->hs_rx_gear = UFS_HS_G3;
-	dev_param->hs_tx_gear = UFS_HS_G3;
-	dev_param->pwm_rx_gear = UFS_PWM_G4;
-	dev_param->pwm_tx_gear = UFS_PWM_G4;
-	dev_param->rx_pwr_pwm = SLOW_MODE;
-	dev_param->tx_pwr_pwm = SLOW_MODE;
-	dev_param->rx_pwr_hs = FAST_MODE;
-	dev_param->tx_pwr_hs = FAST_MODE;
-	dev_param->hs_rate = PA_HS_MODE_B;
-	dev_param->desired_working_mode = UFS_HS_MODE;
+	*dev_param = (struct ufs_dev_params){
+		.tx_lanes = 2,
+		.rx_lanes = 2,
+		.hs_rx_gear = UFS_HS_G3,
+		.hs_tx_gear = UFS_HS_G3,
+		.pwm_rx_gear = UFS_PWM_G4,
+		.pwm_tx_gear = UFS_PWM_G4,
+		.rx_pwr_pwm = SLOW_MODE,
+		.tx_pwr_pwm = SLOW_MODE,
+		.rx_pwr_hs = FAST_MODE,
+		.tx_pwr_hs = FAST_MODE,
+		.hs_rate = PA_HS_MODE_B,
+		.desired_working_mode = UFS_HS_MODE,
+	};
 }
 EXPORT_SYMBOL_GPL(ufshcd_init_pwr_dev_param);
 
