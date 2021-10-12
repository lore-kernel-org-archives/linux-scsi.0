Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AF4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D28360F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhJLXiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:21 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:51977 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbhJLXiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:18 -0400
Received: by mail-pj1-f50.google.com with SMTP id kk10so818651pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mp9ekGfBG0AnXhgZJmGluTHS+rWkMf+n4jEyCQoMsS0=;
        b=iYKmn72zL1eq6SutfF20vZSgeCvHHRwqILE771h4JUvh5z6/oEMQpkwqHe0ybo6z0Y
         Pv+oZwgSSrZdzjV1bHMdGTr363+qRORnSqBndNLeosxJ+S4HA9V+Zlg3UjEDVNTUq1kh
         /WlDSJGu4kfuR+fHTnydytpNN7oF1rpSGFsn5qyfGi622qNj09KgLw0yIqxsaWvWWDQO
         kcnigkCYVV2ZVKZP14VrT5H2TxNmbu+Bm7pF6d3NhDocN48bL8NZTKNJom6b/3mP+6h0
         lU5OWbBUCHfLVFRE5p9681l5DVS1SaCBAJRd2RV300WJQrVROxoeaGG+sXSm2Y5YOC/q
         ZoAA==
X-Gm-Message-State: AOAM531H1G46BIe2ANo54JcG/igpjTv3KnElI34Pt8xfQO2gMSCb+yvx
        4cBX7Q0I4nYF+6ahxIsWSyI=
X-Google-Smtp-Source: ABdhPJzCCzx915IyHheIdBsvdE/b7y5E67UPzcBJ2DgtvHup+QVElhqgF8JSBBDleJfrymvJbIbzGg==
X-Received: by 2002:a17:90a:6d27:: with SMTP id z36mr9197743pjj.231.1634081775626;
        Tue, 12 Oct 2021 16:36:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v4 06/46] scsi: zfcp: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:18 -0700
Message-Id: <20211012233558.4066756-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
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
index 6bc96d70254d..c302cbb18a55 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -184,8 +184,8 @@ extern const struct attribute_group *zfcp_sysfs_adapter_attr_groups[];
 extern const struct attribute_group *zfcp_unit_attr_groups[];
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
-extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
-extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+extern const struct attribute_group *zfcp_sysfs_sdev_attr_groups[];
+extern const struct attribute_group *zfcp_sysfs_shost_attr_groups[];
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9da9b2b2a580..709fea7c1380 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -444,8 +444,8 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	/* report size limit per scatter-gather segment */
 	.max_segment_size	 = ZFCP_QDIO_SBALE_LEN,
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
-	.shost_attrs		 = zfcp_sysfs_shost_attrs,
-	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
+	.shost_groups		 = zfcp_sysfs_shost_attr_groups,
+	.sdev_groups		 = zfcp_sysfs_sdev_attr_groups,
 	.track_queue_depth	 = 1,
 	.supported_mode		 = MODE_INITIATOR,
 };
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index b8cd75a872ee..dbf3e50444e6 100644
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
+struct attribute *zfcp_sdev_attrs[] = {
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
+	.attrs = zfcp_sdev_attrs
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
+static const struct attribute_group zfcp_sysfs_shost_attr_group = {
+	.attrs = zfcp_sysfs_shost_attrs
+};
+
+const struct attribute_group *zfcp_sysfs_shost_attr_groups[] = {
+	&zfcp_sysfs_shost_attr_group,
 	NULL
 };
 
