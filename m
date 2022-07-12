Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320ABCCA47F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiGLWTz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiGLWTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:19:50 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DC73335D
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:50 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id a15so8612479pfv.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PK7GhXluDeO7vB7OgT+f4kVleUWpGV4FgrTIBb4orbk=;
        b=lLINBmHuVGUfEK0t9Ny3VskTDnhOMoHp9vJLutae4RAw9pvwI9qTR4RUcXQSuKZFkK
         xLVtsX+mh2EoyFBElgWDfGshuJf0FPj0jYG2KgZP2CmeLBtw6e9K39RuiQaHwlsN0nij
         4Kkb6QpHeK2OolRfyjgw++7TBCvDlmC1Ra8rdXu4/gppa+RGPfCU1NdNhpmgfVjPooHH
         yNiiAfDkKAV8REwuec5LJmSe0Eu/zRi7pj/h03W8JS+JrS6du0RdEBjuNKi0eJqvqsp1
         EFAGGj2dmyvEV27HwMP6sXl/qoWEUaJTLuV3D+nhiscqYT54yF4oC2owuBB9aRpzR/c4
         LDbg==
X-Gm-Message-State: AJIora9nkqWrDIGDE04LAwTRfnHhRuHg4a1ttIf4tM/vWa7njA7V6p+q
        +kAv46NpOr0GFPHSHikJ8t8=
X-Google-Smtp-Source: AGRyM1vOM7aQaeP2D80qPoRrpURdwVIKoBJ/DBC5MrNO17Ywdp3YpoZTOe2kg2Hz08bhbj7kntYydA==
X-Received: by 2002:a63:460f:0:b0:412:7a8b:128c with SMTP id t15-20020a63460f000000b004127a8b128cmr371256pga.270.1657664389569;
        Tue, 12 Jul 2022 15:19:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0040d0a57be02sm6640192pgh.31.2022.07.12.15.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:19:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v4 3/4] scsi: core: Simplify LLD module reference counting
Date:   Tue, 12 Jul 2022 15:19:35 -0700
Message-Id: <20220712221936.1199196-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
In-Reply-To: <20220712221936.1199196-1-bvanassche@acm.org>
References: <20220712221936.1199196-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

Swap two statements in scsi_device_put() now that it is guaranteed that
SCSI hosts outlive SCSI devices. Remove the reference counting code from
scsi_sysfs.c that became superfluous because SCSI hosts now outlive SCSI
devices.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: Extracted this patch from a larger patch ]
---
 drivers/scsi/scsi.c       | 9 ++++++---
 drivers/scsi/scsi_sysfs.c | 9 ---------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..086ec5b5862d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,10 +586,13 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct module *mod = sdev->host->hostt->module;
-
+	/*
+	 * Decreasing the module reference count before the device reference
+	 * count is safe since scsi_remove_host() only returns after all
+	 * devices have been removed.
+	 */
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
-	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1bc9c26fe1d4..213ebc88f76a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -452,9 +452,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
-	struct module *mod;
-
-	mod = sdev->host->hostt->module;
 
 	scsi_dh_release_device(sdev);
 
@@ -521,17 +518,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
-	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
-
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
