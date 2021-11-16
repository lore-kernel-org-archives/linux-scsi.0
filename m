Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6493BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 22:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323C56323A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 22:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhKPWeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 17:34:21 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:41760 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhKPWeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 17:34:20 -0500
Received: by mail-pj1-f54.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso755570pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 14:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tIq16oRek9dZcmeda6FfMgUmA6KCZc4vErYHAeA3dfc=;
        b=DgFfpgRnoaJo8r5+O3bbknLB2erMU9ffHpnuZo9Wg0X2rrXjHjqJ8Lkuv8UKStUiEN
         BKiWn+kOAhjgYZjuDzIWGOMfMr7co/YIbrqmhIjlz6KXC+BeAzrk9lvFbI+17an9qIOd
         Y5gJmgionnC8gocJI/QU2BZt6+wZSaRmPUpTAPKwCMwztUCC6NAxReTpsYbpdRNbm6xL
         f4yPQQhDiKMEUsTxaQRmDWEtclhkcNgZpYslDl9SzRCWbLDyjhXT1GXY+1Lv1h++Ii5J
         AwZNzhTvwyT0vgOAGd/ADL8AJTC8qUyYhmwblOx4OGhCRZ1wmNzcotzcusvXcCGkGEVI
         pbtA==
X-Gm-Message-State: AOAM5307I5b5BO5H0yt944A7T6ZWJB+HQVfFoR6eTBvKUr+Bx4/znalV
        VUy0ot7x/2aMRKqhdsu9c6w=
X-Google-Smtp-Source: ABdhPJzr+iJbXniiSJP03RfOkfE9B0PAmezFqZLSaXfqileFI0qa/3XsYBcC3auei4FNXa5OKDW03Q==
X-Received: by 2002:a17:90a:670e:: with SMTP id n14mr3207296pjj.144.1637101882791;
        Tue, 16 Nov 2021 14:31:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b86c:e552:2687:f5a7])
        by smtp.gmail.com with ESMTPSA id e11sm3153961pjl.20.2021.11.16.14.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 14:31:22 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Remove Scsi_Host.shost_dev_attr_groups
Date:   Tue, 16 Nov 2021 14:31:15 -0800
Message-Id: <20211116223115.2103031-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the scsi_host_alloc() implementation by setting the shost_class
.dev_groups member instead of copying all host attribute group pointers
into the shost_dev_attr_groups[] array.

Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Suggested-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c      | 15 +++------------
 drivers/scsi/scsi_priv.h  |  2 +-
 drivers/scsi/scsi_sysfs.c |  7 ++++++-
 include/scsi/scsi_host.h  |  6 ------
 4 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8049b00b6766..f69b77cbf538 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -61,6 +61,7 @@ static void scsi_host_cls_release(struct device *dev)
 static struct class shost_class = {
 	.name		= "scsi_host",
 	.dev_release	= scsi_host_cls_release,
+	.dev_groups	= scsi_shost_groups,
 };
 
 /**
@@ -377,7 +378,7 @@ static struct device_type scsi_host_type = {
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
-	int index, i, j = 0;
+	int index;
 
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
 	if (!shost)
@@ -483,17 +484,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_dev.parent = &shost->shost_gendev;
 	shost->shost_dev.class = &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
-	shost->shost_dev.groups = shost->shost_dev_attr_groups;
-	shost->shost_dev_attr_groups[j++] = &scsi_shost_attr_group;
-	if (sht->shost_groups) {
-		for (i = 0; sht->shost_groups[i] &&
-			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
-		     i++, j++) {
-			shost->shost_dev_attr_groups[j] =
-				sht->shost_groups[i];
-		}
-	}
-	WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
+	shost->shost_dev.groups = sht->shost_groups;
 
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index a278fc8948f4..0f5743f4769b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -144,7 +144,7 @@ extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
-extern const struct attribute_group scsi_shost_attr_group;
+extern const struct attribute_group *scsi_shost_groups[];
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7afcec250f9b..342a3de6b994 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -424,10 +424,15 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-const struct attribute_group scsi_shost_attr_group = {
+static const struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
+const struct attribute_group *scsi_shost_groups[] = {
+	&scsi_shost_attr_group,
+	NULL
+};
+
 static void scsi_device_cls_release(struct device *class_dev)
 {
 	struct scsi_device *sdev;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ebe059badba0..72e1a347baa6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -691,12 +691,6 @@ struct Scsi_Host {
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
-	/*
-	 * The array size 3 provides space for one attribute group defined by
-	 * the SCSI core, one attribute group defined by the SCSI LLD and one
-	 * terminating NULL pointer.
-	 */
-	const struct attribute_group *shost_dev_attr_groups[3];
 
 	/*
 	 * Points to the transport data (if any) which is allocated
