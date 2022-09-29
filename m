Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3B6C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiI2WqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiI2Wpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:45 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD52427157
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:55 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 78so2650573pgb.13
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ggFXFXw8GzFeqSEw6TpqlKsVewsEFnUk9jps5x5QML4=;
        b=Xbor8gAUzr6dJhTzIfDuRrwzOJZlM4QOaU0IHS1qck/Cag9j5CcbT0pDvUj7vKIFHj
         ie3l8X4iH5asNa6TXJ7ZXBWSUmz8JRfUNqqLBxJFRPIhC/ZJE0g4c7dWiIwFIXUtppGx
         Zpi77PXHhwRm9vAUZJlU6AP3vDKMlvV0qr9a2VymJr0Jqy1CPCE6o8a9CqDNo1BJdk5x
         c1nxck/2z+sNyYxMn7Jl+eJxaofaDSR4f9Vmvk/Tp5L1dKXYs3Q8NPZ67LqvuX+ETC4w
         5ntWb8m8hcNbbdjAfVeSc36zy/fIlJmPDSZfmL0XduFI2NueVR/nx5oZl8m5HG4bAanx
         1GQQ==
X-Gm-Message-State: ACrzQf0efCIJPnIpU/ysRgyu504tqcSiqxDeINxL/x0CupPvYEXyupXB
        1/k/OCLQWotsM5dJj7v3xcw=
X-Google-Smtp-Source: AMsMyM7vRKf4X2n4/jPeJ7KvPAY2T4LSkmrW+YjJ+WLooFfjmxTAZBhHmmH4cj1aap05PPYtEPE4wQ==
X-Received: by 2002:a63:2cc2:0:b0:41c:681d:60d2 with SMTP id s185-20020a632cc2000000b0041c681d60d2mr4677805pgs.502.1664491495222;
        Thu, 29 Sep 2022 15:44:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 8/8] scsi: core: Release SCSI devices synchronously
Date:   Thu, 29 Sep 2022 15:44:21 -0700
Message-Id: <20220929224421.587465-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All upstream scsi_device_put() calls happen from thread context. Hence
simplify scsi_device_put() by always calling the release function
synchronously. This patch prepares for constifying the SCSI host template
by removing an assignment that clears the module pointer in the SCSI host
template.

scsi_device_dev_release_usercontext() was introduced in 2006 via
commit 65110b216895 ("[SCSI] fix wrong context bugs in SCSI").

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c        |  2 ++
 drivers/scsi/scsi_sysfs.c  | 12 ++----------
 include/scsi/scsi_device.h |  1 -
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 87bddd697fc6..e8bc4db297ab 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,6 +586,8 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
+	might_sleep();
+
 	/*
 	 * Decreasing the module reference count before the device reference
 	 * count is safe since scsi_remove_host() only returns after all
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dc4bda4d2319..dd8e0d0399cd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -441,10 +441,9 @@ static void scsi_device_cls_release(struct device *class_dev)
 	put_device(&sdev->sdev_gendev);
 }
 
-static void scsi_device_dev_release_usercontext(struct work_struct *work)
+static void scsi_device_dev_release(struct device *dev)
 {
-	struct scsi_device *sdev = container_of(work, struct scsi_device,
-						ew.work);
+	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
 	struct device *parent;
 	struct list_head *this, *tmp;
@@ -518,13 +517,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		put_device(parent);
 }
 
-static void scsi_device_dev_release(struct device *dev)
-{
-	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
-}
-
 static struct class sdev_class = {
 	.name		= "scsi_device",
 	.dev_release	= scsi_device_cls_release,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 78039d1ec405..fa6070ce8b9b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -236,7 +236,6 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
-	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
