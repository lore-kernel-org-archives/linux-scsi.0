Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97177C3DA6F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 21:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbjHWVHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 17:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbjHWVGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 17:06:45 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C210D8
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 14:06:43 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bba48b0bd2so41306345ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 14:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692824803; x=1693429603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=keE3JMiQyg8krI9Y3WdI2JzV5MnvZdstl5K7QvG1sYg=;
        b=NepwUAkg6eUiCpQYYtSjF7DQy82nAj7OuN3I6rSe8+vK6GetErNR4zv1qgfkl5QrHx
         5qFUthvI1GemvIPzl+OYYy3WQYJBcjKMP+3Wdct2j4ykbiekIkFN9Fj3ZhdI5uyDVMxw
         PUc4co4ToJ683RaWGq6EC5o5bi4ZHZ2dt9EnDNnk9ITLjfK9nQAvHPWzsPkuBTfvErrJ
         XmAKkMxuP6YIOyl1mx3wb+zJqNiP35ki667CkoJO95lZdeWbG4CW1W2S6LOrLeh7chYG
         2uA3pahKv12aXj6lPjQrQZtaABhEq1Wk2/E3Ge0knJl0k2hgOpqZkj+9zD3sCIPS6W0I
         PV/w==
X-Gm-Message-State: AOJu0YxXJX59bdoucenl1y6G9uke9m3mvg2AUu3oLY+JHQe6BAfxfjuH
        wgU5aZqMnXRHkZn8ksxyZQc=
X-Google-Smtp-Source: AGHT+IGHm4ODiALp/skOS5A+PsBmoVQMxJ0gYb4afRKZc4ZNt0LDZ4lKkHLMEz8gJtvRzDxR7ZhMgg==
X-Received: by 2002:a17:902:ec89:b0:1bc:2c79:c6b5 with SMTP id x9-20020a170902ec8900b001bc2c79c6b5mr11902499plg.4.1692824803033;
        Wed, 23 Aug 2023 14:06:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ecb6:e8b9:f433:b4b4])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b001b89b1b99fasm11573211plb.243.2023.08.23.14.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 14:06:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: sd: Remove the number of forward declarations
Date:   Wed, 23 Aug 2023 14:06:28 -0700
Message-ID: <20230823210628.523244-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the sd_pm_ops and sd_template data structures to just above
init_sd() such that the number of forward function declarations can be
reduced.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 66 +++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 68b12afa0721..4cd281368826 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -104,19 +104,7 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static int  sd_probe(struct device *);
-static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
-static int sd_suspend_system(struct device *);
-static int sd_suspend_runtime(struct device *);
-static int sd_resume_system(struct device *);
-static int sd_resume_runtime(struct device *);
-static void sd_rescan(struct device *);
-static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
-static void sd_uninit_command(struct scsi_cmnd *SCpnt);
-static int sd_done(struct scsi_cmnd *);
-static void sd_eh_reset(struct scsi_cmnd *);
-static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 
@@ -592,33 +580,6 @@ static struct class sd_disk_class = {
 	.dev_groups	= sd_disk_groups,
 };
 
-static const struct dev_pm_ops sd_pm_ops = {
-	.suspend		= sd_suspend_system,
-	.resume			= sd_resume_system,
-	.poweroff		= sd_suspend_system,
-	.restore		= sd_resume_system,
-	.runtime_suspend	= sd_suspend_runtime,
-	.runtime_resume		= sd_resume_runtime,
-};
-
-static struct scsi_driver sd_template = {
-	.gendrv = {
-		.name		= "sd",
-		.owner		= THIS_MODULE,
-		.probe		= sd_probe,
-		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.remove		= sd_remove,
-		.shutdown	= sd_shutdown,
-		.pm		= &sd_pm_ops,
-	},
-	.rescan			= sd_rescan,
-	.init_command		= sd_init_command,
-	.uninit_command		= sd_uninit_command,
-	.done			= sd_done,
-	.eh_action		= sd_eh_action,
-	.eh_reset		= sd_eh_reset,
-};
-
 /*
  * Don't request a new module, as that could deadlock in multipath
  * environment.
@@ -3926,6 +3887,33 @@ static int sd_resume_runtime(struct device *dev)
 	return sd_resume(dev);
 }
 
+static const struct dev_pm_ops sd_pm_ops = {
+	.suspend		= sd_suspend_system,
+	.resume			= sd_resume_system,
+	.poweroff		= sd_suspend_system,
+	.restore		= sd_resume_system,
+	.runtime_suspend	= sd_suspend_runtime,
+	.runtime_resume		= sd_resume_runtime,
+};
+
+static struct scsi_driver sd_template = {
+	.gendrv = {
+		.name		= "sd",
+		.owner		= THIS_MODULE,
+		.probe		= sd_probe,
+		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
+		.remove		= sd_remove,
+		.shutdown	= sd_shutdown,
+		.pm		= &sd_pm_ops,
+	},
+	.rescan			= sd_rescan,
+	.init_command		= sd_init_command,
+	.uninit_command		= sd_uninit_command,
+	.done			= sd_done,
+	.eh_action		= sd_eh_action,
+	.eh_reset		= sd_eh_reset,
+};
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).
