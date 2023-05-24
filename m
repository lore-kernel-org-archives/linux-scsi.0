Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48484C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 20:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjEXUhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 16:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbjEXUhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 16:37:21 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EDC189
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:20 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-253520adb30so525472a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960640; x=1687552640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tNznh/PomHhDbxpK/V1uJa61xaYCstn1ZaFfe9gZwPs=;
        b=a/9gusCVe2JUcYLTtJt4l9UPUCGm9qHqi9GS6RlMs9KCHXl7NkLk0+FCt2eSMsWDCx
         ASxtxrjs1Qq7zHwxKLZvztczs42XwO8wsg4cvbmLvAQG0debFS9ks9Sg4FPMA0V1DlCG
         LWcJkJCUD10Hx0J6Budwqj+gqpuNIEKjuakjVBLd6LYJQGFReVpWIQQ4e3yTHIlAjx92
         5ExH6tNBEqyathc7l7Mf8rtW1WT5Jky9BInWeexSummFe6xBD0+jg6k7q5dtloU3ww1H
         9yNPE+FkoQr3Ir1G6JeWAlbSaMMgJgPKqG5B2EMG6rglfAHtQ/eMp8bjX7OqKcHPKqG6
         iQJQ==
X-Gm-Message-State: AC+VfDy8xkfBwycmXGxpnR/UusdmxF8lb8oevSpl80nTiGa9U08f1X5H
        Hdr/QFKVPkUIqrT1uKvQy14=
X-Google-Smtp-Source: ACHHUZ4By2fLDzx19/dnT7Tg6d55EH5jl8G/H8ZoWJRrRpvMgkvPF/vZgdgSabdRyJ67aSAPb7foTg==
X-Received: by 2002:a17:90a:17ec:b0:253:45e5:af5c with SMTP id q99-20020a17090a17ec00b0025345e5af5cmr18299687pja.32.1684960640229;
        Wed, 24 May 2023 13:37:20 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090a70c700b002535dc42bb5sm1690122pjm.47.2023.05.24.13.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:37:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH v3 3/4] scsi: ufs: Move ufshcd_wl_shutdown()
Date:   Wed, 24 May 2023 13:36:21 -0700
Message-ID: <20230524203659.1394307-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org>
References: <20230524203659.1394307-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of ufshcd_wl_shutdown() to make the next patch in
this series easier to review.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a7598120d23..908b9f98b2e0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9749,28 +9749,6 @@ static int ufshcd_wl_resume(struct device *dev)
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
@@ -9955,6 +9933,28 @@ int ufshcd_runtime_resume(struct device *dev)
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
