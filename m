Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCCBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F51610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhJGVVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:09 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:47075 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbhJGVVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:06 -0400
Received: by mail-pg1-f171.google.com with SMTP id m21so1009021pgu.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R6I1I5eX1La02qCMMnkH/r3EBmKBKA7fd7ebgjOp0Do=;
        b=ZiNKtyBmOlMwJZZX3nF7a0cwPsFU3axfbYMkSlIEYWfR5N0CqEVmIHTtxxmdXhply7
         5spcjOG4DOh2uI0KMXsljhKVtHjewiRXiOf4iayYSNctCi3fKcuv1PBIWHLjQ3XbpinE
         r388S1el06pVxU/AloqhuSAh4zdcPYa+pbN8FYgF0g1WnLydpXX029j3xhRCAGjepcXj
         L0Wl5PmW2qE06kX6W5dgi0DEDYLfdBn5WNwd/HC2clJ6oBIxGSX4eh8UqmtmJRnkr7ub
         TDy/Gg4RuOF5gBwVNsVxHWd/VyN9TpfviPqb/NKlD3lSTWdqDmFe4ThqzjE2pe2/q/Ku
         QwyA==
X-Gm-Message-State: AOAM533VFuQZXGoTrI4nMzG1R8HAAn82Q+7UPUhROeWMJ2YE4vaf4qrU
        22YxDzPdHmNeD2laxn9jKS4=
X-Google-Smtp-Source: ABdhPJxe3OB6JiAPvyRdU/POoCcQpzW/aXbOmLz7l55MlmzzpVoc84S5kQRmEWfG9LJ5DuZFoyFgbA==
X-Received: by 2002:a63:cc48:: with SMTP id q8mr1486232pgi.171.1633641551988;
        Thu, 07 Oct 2021 14:19:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 06/46] scsi: zfcp: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:12 -0700
Message-Id: <20211007211852.256007-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_ext.h   |  4 +--
 drivers/s390/scsi/zfcp_scsi.c  |  4 +--
 drivers/s390/scsi/zfcp_sysfs.c | 52 +++++++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 6bc96d70254d..87a35a755464 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -184,8 +184,8 @@ extern const struct attribute_group *zfcp_sysfs_adapter_attr_groups[];
 extern const struct attribute_group *zfcp_unit_attr_groups[];
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
-extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
-extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+extern const struct attribute_group *zfcp_sysfs_sdev_attr_groups[];
+extern const struct attribute_group *zfcp_shost_attr_groups[];
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9da9b2b2a580..875d14489699 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -444,8 +444,8 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	/* report size limit per scatter-gather segment */
 	.max_segment_size	 = ZFCP_QDIO_SBALE_LEN,
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
-	.shost_attrs		 = zfcp_sysfs_shost_attrs,
-	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
+	.shost_groups		 = zfcp_shost_attr_groups,
+	.sdev_groups		 = zfcp_sysfs_sdev_attr_groups,
 	.track_queue_depth	 = 1,
 	.supported_mode		 = MODE_INITIATOR,
 };
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index b8cd75a872ee..999cf6ee3598 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -672,17 +672,26 @@ ZFCP_DEFINE_SCSI_ATTR(zfcp_in_recovery, "%d\n",
 ZFCP_DEFINE_SCSI_ATTR(zfcp_status, "0x%08x\n",
 		      atomic_read(&zfcp_sdev->status));
 
-struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
-	&dev_attr_fcp_lun,
-	&dev_attr_wwpn,
-	&dev_attr_hba_id,
-	&dev_attr_read_latency,
-	&dev_attr_write_latency,
-	&dev_attr_cmd_latency,
-	&dev_attr_zfcp_access_denied,
-	&dev_attr_zfcp_failed,
-	&dev_attr_zfcp_in_recovery,
-	&dev_attr_zfcp_status,
+struct attribute *zfcp_sysfs_sdev_attrs[] = {
+	&dev_attr_fcp_lun.attr,
+	&dev_attr_wwpn.attr,
+	&dev_attr_hba_id.attr,
+	&dev_attr_read_latency.attr,
+	&dev_attr_write_latency.attr,
+	&dev_attr_cmd_latency.attr,
+	&dev_attr_zfcp_access_denied.attr,
+	&dev_attr_zfcp_failed.attr,
+	&dev_attr_zfcp_in_recovery.attr,
+	&dev_attr_zfcp_status.attr,
+	NULL
+};
+
+static const struct attribute_group zfcp_sysfs_sdev_attr_group = {
+	.attrs = zfcp_sysfs_sdev_attrs
+};
+
+const struct attribute_group *zfcp_sysfs_sdev_attr_groups[] = {
+	&zfcp_sysfs_sdev_attr_group,
 	NULL
 };
 
@@ -783,12 +792,21 @@ static ssize_t zfcp_sysfs_adapter_q_full_show(struct device *dev,
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);
 
-struct device_attribute *zfcp_sysfs_shost_attrs[] = {
-	&dev_attr_utilization,
-	&dev_attr_requests,
-	&dev_attr_megabytes,
-	&dev_attr_seconds_active,
-	&dev_attr_queue_full,
+static struct attribute *zfcp_sysfs_shost_attrs[] = {
+	&dev_attr_utilization.attr,
+	&dev_attr_requests.attr,
+	&dev_attr_megabytes.attr,
+	&dev_attr_seconds_active.attr,
+	&dev_attr_queue_full.attr,
+	NULL
+};
+
+static const struct attribute_group zfcp_shost_attr_group = {
+	.attrs = zfcp_sysfs_shost_attrs
+};
+
+const struct attribute_group *zfcp_shost_attr_groups[] = {
+	&zfcp_shost_attr_group,
 	NULL
 };
 
