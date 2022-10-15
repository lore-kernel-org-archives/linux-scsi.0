Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13EEC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJOAZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJOAYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:48 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1344DF44
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:43 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d10so6313086pfh.6
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=me3TZZ9YQv9Rupx9AI9XDyc6QvHjXPxe9brKdqSFDOA=;
        b=PprMoYuPjX10H52aze3aC36uHYZDHbfBaPwMZpqKuK9n+wqLt6A93VRbwqN5HDuCUz
         +WXycG/MYO0Sf0BbQNzd/3fHQ/mGQ6bIAUc0pDnwMwyFRsH6nqnXydmbRxv4XVThCzhl
         sse4wN0qG7oavVDbgQM3j881C4cyvlRKofVaxa1llgqwgkaEGAgdXdP2bziFyH6htaJa
         68m+5mKg83zyITgFoHjQKZ63iBC98mZ8Id6YgmVD6D3dyVP+xmTMwCFoXCx3kkRkAWbh
         Pri2ZSU53FNfGOVlUyD0oaDsrcBhSqL8o8B7AxC/23SWDxtT2Etqs81Uiwj+pn15vTbZ
         W4IA==
X-Gm-Message-State: ACrzQf3DqqpqPcyecuepyL6zBJNLXygLU5FMjAsXK2UOEbKtxi9qe/VR
        xXPP9bpAGpXrPdp2/E1OU4M=
X-Google-Smtp-Source: AMsMyM7Oit/xGO96wJ6A5+HLsiAecKSxXhwbvEg1NAEbPm5A54WeMFTe/Ilj5rhJ81+8WicFAvPVpg==
X-Received: by 2002:a63:5766:0:b0:440:2960:37d with SMTP id h38-20020a635766000000b004402960037dmr446200pgm.278.1665793482944;
        Fri, 14 Oct 2022 17:24:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 8/8] scsi: core: Release SCSI devices synchronously
Date:   Fri, 14 Oct 2022 17:24:18 -0700
Message-Id: <20221015002418.30955-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_sysfs.c  | 22 ++--------------------
 include/scsi/scsi_device.h |  1 -
 3 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9feb0323bc44..1426b9b03612 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -588,6 +588,8 @@ void scsi_device_put(struct scsi_device *sdev)
 {
 	struct module *mod = sdev->host->hostt->module;
 
+	might_sleep();
+
 	put_device(&sdev->sdev_gendev);
 	module_put(mod);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c8b178983585..c76f5757b863 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -441,20 +441,15 @@ static void scsi_device_cls_release(struct device *class_dev)
 	put_device(&sdev->sdev_gendev);
 }
 
-static void scsi_device_dev_release_usercontext(struct work_struct *work)
+static void scsi_device_dev_release(struct device *dev)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = to_scsi_device(dev);
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
-	struct module *mod;
-
-	sdev = container_of(work, struct scsi_device, ew.work);
-
-	mod = sdev->host->hostt->module;
 
 	parent = sdev->sdev_gendev.parent;
 
@@ -516,19 +511,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
-	module_put(mod);
-}
-
-static void scsi_device_dev_release(struct device *dev)
-{
-	struct scsi_device *sdp = to_scsi_device(dev);
-
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
-
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
 }
 
 static struct class sdev_class = {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c36656d8ac6c..24bdbf7999ab 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -236,7 +236,6 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
-	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
