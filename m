Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E57C7EE21
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbjDYXaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbjDYXae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:30:34 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78A0B454
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:33 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-63d4595d60fso39188382b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465433; x=1685057433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdtmOBVIHMDWDuS5/Wfo84zu3auQN36VU5gbul9sxvw=;
        b=QROZMcxdUFmq3e/wQsx5bnCtyxxcwmh7ews7RyVLKcVXI+cdQG69gRl/FOH6SQutVg
         HP4XUi+iQpWhuPkYz8a6fs5ZeIVjS3acaZV6CJe9UbavlWtA7QuYrbqjOaMxhJTwmDCl
         znMSV5b61T/N4FCX0Yyc2cFGdWAoJicr920RK/3wpWK7Te7+t+0lTAKg/ZM5W+4P8r/9
         cDq0Egv2q3lDQj7N22C8nhnScI9XhW2zaZg/RUxRaUA9R4Es1UFLtFKaNHL6houL0U17
         Wj7u1oEOR9MKRfhjP2qyCJxuNRjVngJ1peK+rmrk2P3g0oMxQIwqqaeET6NskATM2GCp
         dgPA==
X-Gm-Message-State: AC+VfDw1rDXHfC9OVHKvjVNOCzLjkDzgSoBDuu5vcU9/kgcrzsblTd1J
        UM1VjgrZo5Oo0ZiRtoDl224=
X-Google-Smtp-Source: ACHHUZ5Tx/w1wGZa5FRfjudgNlQ8c+OUD9sxIj9XURiXsWiUCINpVsIeatw15ASSb7HF4sfIj7vpbw==
X-Received: by 2002:a05:6a20:4417:b0:f2:4c39:8028 with SMTP id ce23-20020a056a20441700b000f24c398028mr555171pzb.21.1682465432990;
        Tue, 25 Apr 2023 16:30:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id b20-20020a056a0002d400b006348cb791f4sm9829941pft.192.2023.04.25.16.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:30:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 3/4] scsi: ufs: Move ufshcd_wl_shutdown()
Date:   Tue, 25 Apr 2023 16:29:53 -0700
Message-ID: <20230425232954.1229916-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425232954.1229916-1-bvanassche@acm.org>
References: <20230425232954.1229916-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of ufshcd_wl_shutdown() to make the next patch in
this series easier to review.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c691ddf09698..215a7f713b46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9761,28 +9761,6 @@ static int ufshcd_wl_resume(struct device *dev)
 }
 #endif
 
-static void ufshcd_wl_shutdown(struct device *dev)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
-
-	down(&hba->host_sem);
-	hba->shutting_down = true;
-	up(&hba->host_sem);
-
-	/* Turn on everything while shutting down */
-	ufshcd_rpm_get_sync(hba);
-	scsi_device_quiesce(sdev);
-	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->ufs_device_wlun)
-			continue;
-		scsi_device_quiesce(sdev);
-	}
-	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
-}
-
 /**
  * ufshcd_suspend - helper function for suspend operations
  * @hba: per adapter instance
@@ -9967,6 +9945,28 @@ int ufshcd_runtime_resume(struct device *dev)
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 #endif /* CONFIG_PM */
 
+static void ufshcd_wl_shutdown(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufs_hba *hba;
+
+	hba = shost_priv(sdev->host);
+
+	down(&hba->host_sem);
+	hba->shutting_down = true;
+	up(&hba->host_sem);
+
+	/* Turn on everything while shutting down */
+	ufshcd_rpm_get_sync(hba);
+	scsi_device_quiesce(sdev);
+	shost_for_each_device(sdev, hba->host) {
+		if (sdev == hba->ufs_device_wlun)
+			continue;
+		scsi_device_quiesce(sdev);
+	}
+	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
+}
+
 /**
  * ufshcd_shutdown - shutdown routine
  * @hba: per adapter instance
