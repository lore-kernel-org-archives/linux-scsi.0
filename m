Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D938C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbiCaWib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242585AbiCaWiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:23 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BA61FAA3C
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:31 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id f10so876999plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8pBWccnhBGS6nuo68rf8nxrmgqwiNj2WcLPkn9t2wY0=;
        b=a4r2mbqMr/RTjlRPtYz7XbwgciATsTjeRxH8yHYfS9RFZaVxSKc7t/Oh4D9q6LQWIR
         Kxc8DZ4b71OliGW1WMfSYBZtcCAeIy/f095bl9tnNsmURBglH26bXDvc7Yi+ewiMmpxb
         DykRs993PuqailU5IoUteHLBBR6K9aGC7nbGKE1OmtQZ4EbZfo1Yb7htVs7OtRosWADW
         bgxPm/kOWPi/lNw4WSJEvzLPXfPMq0V+7L5WGm7sB3zpykN3rgi+DWFI/l1EMoImKmX5
         Ty39qoQVU0ARe6bKPBpUrdmrM+DuQ8i3pc8REU3QTZwgKlwaEp82RAWCs3aZRMBzhCWs
         xfGg==
X-Gm-Message-State: AOAM532Aalsu4T+IZPhGZOORkMLkTchVcIkAPQ+IfuDDSKa+IxNrPBQT
        XFQCoCwBi2Y/qtycrf/VJEQ=
X-Google-Smtp-Source: ABdhPJyQsDsp6kz2GXH9kgimjGNHp8mJFRjIW90+Qyk2HQX3lr0j/34rnXN8yRHGvrE5251C4lw4XQ==
X-Received: by 2002:a17:902:e882:b0:154:445d:9818 with SMTP id w2-20020a170902e88200b00154445d9818mr7239870plg.40.1648766190471;
        Thu, 31 Mar 2022 15:36:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 12/29] scsi: ufs: Switch to aggregate initialization
Date:   Thu, 31 Mar 2022 15:34:07 -0700
Message-Id: <20220331223424.1054715-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to verify for humans that ufshcd_init_pwr_dev_param()
initializes all structure members. This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 87975d1a21c8..2725ce4de1c9 100644
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
 
