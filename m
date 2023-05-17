Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC39AC7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjEQWcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjEQWcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:32:08 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8427D2112
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:06 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5307502146aso904110a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362726; x=1686954726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlqmL7TqYg7KAdV8g+R4LitmgpZaCm8VAciGH7EULQU=;
        b=C1RSCDDQWsjOKHAjIQlI0kPI63QoUqooVNpl3gDC37/QKi8pd/Cb0jsJJptZK5H/VD
         QVTZjdefyeAgYLK2p2Y0W5KI8VjY9Sy/phe4lNA/6hlr31XU/PRL3VkDn3KWAlHf3DEu
         DjVt8dbfAqAYdwXu2bIVXJrURzrYEew/aGoq6bmHRTTbE0WqnG+weOnLemNE6dUDGuPh
         cvn2jIn16YcrN/y8ZMgoaySM4+fs5E2wMw8kt6ERNp06rke6lr+sorK7kvtL1l1txBeB
         TfNnO9NeG/4ocLAIq3vpatr764iJWYOfJlchAu644IkCmEZyEHiWhXo+wgxvs8qokPER
         cGew==
X-Gm-Message-State: AC+VfDz1lBcufhj8auM5oPZMS2Wfbw6WFnCr7hDQwAEVMO0qmbDLLPS9
        nxOAtc3snTh9/UALxJ7ZEQAWHPLZk4U=
X-Google-Smtp-Source: ACHHUZ5aOJCnjY8njPA6qYn0qdMecilWxx86uZNqsYWntoq7T50Q3HGF4TZlNeRnyZvsMAyPS44Kqw==
X-Received: by 2002:a17:90a:d505:b0:24e:46ee:e30d with SMTP id t5-20020a17090ad50500b0024e46eee30dmr459441pju.15.1684362725854;
        Wed, 17 May 2023 15:32:05 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a9f0100b00250d908a771sm61938pjp.50.2023.05.17.15.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:32:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 3/4] scsi: ufs: Move ufshcd_wl_shutdown()
Date:   Wed, 17 May 2023 15:31:56 -0700
Message-ID: <20230517223157.1068210-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517223157.1068210-1-bvanassche@acm.org>
References: <20230517223157.1068210-1-bvanassche@acm.org>
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
index 68d9e24fac98..0f426d46d91e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9746,28 +9746,6 @@ static int ufshcd_wl_resume(struct device *dev)
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
@@ -9952,6 +9930,28 @@ int ufshcd_runtime_resume(struct device *dev)
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
