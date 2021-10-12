Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4042EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D0B60E94
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbhJLXjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:37 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45045 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbhJLXjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:36 -0400
Received: by mail-pf1-f177.google.com with SMTP id w6so818129pfd.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2wlaencmBZXG80fUDiOzKyqvkgiWrECJ2hbHOZjvYSU=;
        b=Qw+zUSdojne0dLbsHEkbI7XQaMJnvkb+Bc7eXylLYSAWBJTVZkvQ4IZsStHOK/TX7g
         lyxf6y5GTNB2jDAT7XKcQL9VsOQyKxyQIUU7cPfZGSvebdaWweE2Xuf2iMnYAMXe4Z5a
         qVkA5jfO6D0BHyqeLP1JPEVrHdul8Y4C6+6Rhxs+DpaV9v6c3HE21dHYRZPHAy9+VqXg
         RcSri0bw1ZH2hb6G3Rk30l9t8ntW6iSfrItkwWUrpelIfEOXeie6ZF0vsKGNsjW8srTR
         oMoSY7x4hcvERiVsp1t+fzJ2XSOUv2lW7X35gASN9uHbb94knd4nxfh0exIxB3acx1Nb
         Xn2A==
X-Gm-Message-State: AOAM530iwYBiMtRfHk06Ww2QJaPBYXaF5Xxj6u8qRbrxG3vrXsUCMnLr
        eFDzJc9VmWCEm/ZszyIWuDM=
X-Google-Smtp-Source: ABdhPJw8j6HoRF9+9aynrOLpTi5FfpuBM+S09azTCMUkWa1IxW8jH+HL0vt+gdLCAXefjjCknQcf7g==
X-Received: by 2002:a63:490d:: with SMTP id w13mr25431841pga.481.1634081854151;
        Tue, 12 Oct 2021 16:37:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 46/46] scsi: core: Remove two host template members that are no longer used
Date:   Tue, 12 Oct 2021 16:35:58 -0700
Message-Id: <20211012233558.4066756-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All SCSI drivers have been converted to use shost_groups and sdev_groups
instead of shost_attrs or sdev_attrs. Hence remove shost_attrs and
sdev_attrs. Additionally, remove the 'lld_attr_group' members and also
the scsi_convert_dev_attrs() function.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c       |  9 ---------
 drivers/scsi/scsi_priv.h   |  2 --
 drivers/scsi/scsi_sysfs.c  | 28 ----------------------------
 include/scsi/scsi_device.h |  1 -
 include/scsi/scsi_host.h   | 11 -----------
 5 files changed, 51 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3443f009a9e8..b3b7b55a90c6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -482,15 +482,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
 	shost->shost_dev.groups = shost->shost_dev_attr_groups;
 	shost->shost_dev_attr_groups[j++] = &scsi_shost_attr_group;
-	if (sht->shost_attrs) {
-		shost->lld_attr_group = (struct attribute_group){
-			.attrs = scsi_convert_dev_attrs(&shost->shost_gendev,
-							sht->shost_attrs)
-		};
-		if (shost->lld_attr_group.attrs)
-			shost->shost_dev_attr_groups[j++] =
-				&shost->lld_attr_group;
-	}
 	if (sht->shost_groups) {
 		for (i = 0; sht->shost_groups[i] &&
 			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index a5a2f18cc734..b7a82c426058 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -137,8 +137,6 @@ extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
-struct attribute **scsi_convert_dev_attrs(struct device *dev,
-					  struct device_attribute **dev_attr);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 05b4d69d53d4..2e69fad0dc51 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1563,26 +1563,6 @@ int scsi_sysfs_add_host(struct Scsi_Host *shost)
 	return 0;
 }
 
-/*
- * Convert an array of struct device_attribute pointers into an array of
- * struct attribute pointers.
- */
-struct attribute **scsi_convert_dev_attrs(struct device *dev,
-					  struct device_attribute **dev_attr)
-{
-	struct attribute **attrs;
-	int i;
-
-	for (i = 0; dev_attr[i]; i++)
-		;
-	attrs = devm_kzalloc(dev, (i + 1) * sizeof(*attrs), GFP_KERNEL);
-	if (!attrs)
-		return NULL;
-	for (i = 0; dev_attr[i]; i++)
-		attrs[i] = &dev_attr[i]->attr;
-	return attrs;
-}
-
 static struct device_type scsi_dev_type = {
 	.name =		"scsi_device",
 	.release =	scsi_device_dev_release,
@@ -1603,14 +1583,6 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->gendev_attr_groups[j++] = &scsi_sdev_attr_group;
-	if (hostt->sdev_attrs) {
-		sdev->lld_attr_group = (struct attribute_group){
-			.attrs = scsi_convert_dev_attrs(&sdev->sdev_gendev,
-							hostt->sdev_attrs)
-		};
-		if (sdev->lld_attr_group.attrs)
-			sdev->gendev_attr_groups[j++] = &sdev->lld_attr_group;
-	}
 	if (hostt->sdev_groups) {
 		for (i = 0; hostt->sdev_groups[i] &&
 			     j < ARRAY_SIZE(sdev->gendev_attr_groups);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 01732aabd7c3..b1e9b3bd3a60 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -225,7 +225,6 @@ struct scsi_device {
 
 	struct device		sdev_gendev,
 				sdev_dev;
-	struct attribute_group	lld_attr_group;
 	/*
 	 * The array size 6 provides space for one attribute group for the
 	 * SCSI core, four attribute groups defined by SCSI LLDs and one
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ab8775811e6f..c2b4d6677a76 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -473,16 +473,6 @@ struct scsi_host_template {
 	 */
 #define SCSI_DEFAULT_HOST_BLOCKED	7
 
-	/*
-	 * Pointer to the sysfs class properties for this host, NULL terminated.
-	 */
-	struct device_attribute **shost_attrs;
-
-	/*
-	 * Pointer to the SCSI device properties for this host, NULL terminated.
-	 */
-	struct device_attribute **sdev_attrs;
-
 	/*
 	 * Pointer to the SCSI host sysfs attribute groups, NULL terminated.
 	 */
@@ -700,7 +690,6 @@ struct Scsi_Host {
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
-	struct attribute_group	lld_attr_group;
 	/*
 	 * The array size 3 provides space for one attribute group defined by
 	 * the SCSI core, one attribute group defined by the SCSI LLD and one
