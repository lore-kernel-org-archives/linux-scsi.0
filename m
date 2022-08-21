Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39879C32789
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 22:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiHUWFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 18:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiHUWFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 18:05:20 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CA813F87
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:18 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id f17so2553787pfk.11
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7BkBiicCaEgyMOno+tfM9H2orpg5mKuuiwhxuVw8KTU=;
        b=orVoxvq5XAtFG71oeu8lID2OHikykh8eZX3nBiRVTn0xM93KQWZG10V8RTbBVGFZfV
         ogt/SU0GSbj4nwXvoJ+GMoF3/Sl844AipQa68BuYsReqFStP7nuy3n6yywm/xmX8vtUT
         pkjtzUSTY2bSJAw0vPLLbeBukBEUIvZJc9xjXn2N/Px+mePOtPfpA0c8OJef7Nl+Ws3/
         TASCrVQGhdEO6uc6L9qUJV8PnFY/qsvHpXcAyD6+Wedwu5qrkEgclZchBrRENYoQhnN+
         6HhX4ra/gchPmiWDVIgL/d30XTQFKwSnG6eZ0tJB0OyMnl+ibm+vx40XxUA8Vej5YKRy
         sPjQ==
X-Gm-Message-State: ACgBeo1utF0D+ESpcvPyr+LDSh/BkzvAKI2SmjNIFNZ4ynjsXxOrA+TT
        u7u9WDmt7IA3Nzc3b/lnCBg=
X-Google-Smtp-Source: AA6agR7oMNs8P1upIocwLJ9yycKTsMOp4iw9KZLYx8sVYCJkpv3XTlaKtUopLghMspb4zOzzfWvWpQ==
X-Received: by 2002:a63:5b4f:0:b0:426:9c52:a1f with SMTP id l15-20020a635b4f000000b004269c520a1fmr14667779pgm.511.1661119517371;
        Sun, 21 Aug 2022 15:05:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b0016c09a0ef87sm3110994plg.255.2022.08.21.15.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:05:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Subject: [PATCH 2/4] scsi: core: Revert "Simplify LLD module reference counting"
Date:   Sun, 21 Aug 2022 15:05:00 -0700
Message-Id: <20220821220502.13685-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220821220502.13685-1-bvanassche@acm.org>
References: <20220821220502.13685-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Revert the patch series "Call blk_mq_free_tag_set() earlier" because it
introduces a deadlock if the scsi_remove_host() caller holds a reference
on a device, target or host.

Reported-by: syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Fixes: 1a9283782df2 ("scsi: core: Simplify LLD module reference counting")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 9 +++------
 drivers/scsi/scsi_sysfs.c | 9 +++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 086ec5b5862d..c59eac7a32f2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,13 +586,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	/*
-	 * Decreasing the module reference count before the device reference
-	 * count is safe since scsi_remove_host() only returns after all
-	 * devices have been removed.
-	 */
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9dad2fd5297f..282b32781e8c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -452,6 +452,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
+	struct module *mod;
+
+	mod = sdev->host->hostt->module;
 
 	scsi_dh_release_device(sdev);
 
@@ -518,11 +521,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	/* Set module pointer as NULL in case of module unloading */
+	if (!try_module_get(sdp->host->hostt->module))
+		sdp->host->hostt->module = NULL;
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
