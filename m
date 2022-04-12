Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071D0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358683AbiDLSXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358681AbiDLSXd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:23:33 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFD66006F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:15 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id z128so18017302pgz.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ggqJd+K00tQFtanOxz0I5riMOWXTnNeexPzEA8SIb8=;
        b=Ni2QZMTrLIK5B4WdJ87P0iPZAw96b7nh6ehWehOXYuaflRz4Rlqr+PxAWnhS0ySDZS
         setylVzBEoYk0anvdqQI5O+F+AxCBTa0vLrWKhRNIQgrY/6cHQOBdGHo1d6VsEBYQSyO
         Ke51Q5NVBtV4naRQX0Ww30gVhQU2AzMAO/+GYbVohweAM9XeRiMyOtiZM2BpTKguoBrr
         6o7aZbaDqh8xMD83QSZYmVuTqvvmVfIwFySnIirKooFpn0ltOTAJskMLelcIarnY1JYY
         rfIonHDjMB6BajRUMEJLppJsuJtMkCvCsVMt9Bqr6nya2ZwXE4uWzgyMWtfpofTKDhVH
         sSmQ==
X-Gm-Message-State: AOAM532A8wbTn/GYq8EX51rGszesc0bmKXhQeqL+rODu+Kh0JTGubpqX
        rld8Iu+l6daEExJLaFAwW4U=
X-Google-Smtp-Source: ABdhPJxW2sGwvKUu/guQAjIWqKMX+hGEBJhR8G2c0l73rFBIqhKVya8rng9UypChBsOyeMIfrSAn0Q==
X-Received: by 2002:aa7:943b:0:b0:505:70bd:61ab with SMTP id y27-20020aa7943b000000b0050570bd61abmr5801636pfo.58.1649787675011;
        Tue, 12 Apr 2022 11:21:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:21:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 13/29] scsi: ufs: Switch to aggregate initialization
Date:   Tue, 12 Apr 2022 11:18:37 -0700
Message-Id: <20220412181853.3715080-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
 
