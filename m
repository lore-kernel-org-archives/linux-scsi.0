Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB5BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070E660F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhJLXiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:21 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:46749 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbhJLXiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:16 -0400
Received: by mail-pl1-f174.google.com with SMTP id 21so547842plo.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gA6NRNH2A9Xt41KnXTAILbLbUYLHxLunMHE6eX3ZNbw=;
        b=IKmneDxJF6ecs0J4KvrV8lPexsqHM80RBgiMYve6uDu1akxx10eSdl/1vjFnUU5jCC
         0H0H3WLBS/j4f9P+lGxCu7nzPIkhRm/Hmjnhu2SEU2te1qyxNHqWQVVo8sLYhGC/zExb
         an3WEU9GXYbqIim+iG37fZIxP45cWArsNcaXxv3MgVgAYw35iBf8uQ0N7FRZxDmp9ahf
         2q+wfoYpaXwUd7rUdok+SOZIGG7U5ioX7ZCINxwy1vuCQt4Jy+o/g4XyHGzcXQPJeBvi
         1AOPiOr714Pw2Q5qA1hWUJBCzo2b7A3BukNKJY7xFYcvDdjIAitXvO85mNJQVGpvkpDp
         Lc+Q==
X-Gm-Message-State: AOAM532JGP2H+NA3HA3ZFRtQq982Ch+/8ZJPmmW8ozN4PTfeRzFRHbZc
        15TaC54abBkG7IqVjcQZ7s8=
X-Google-Smtp-Source: ABdhPJwfhsthil74rfMwZs4Xiyg/NiJxihh5X5X+0n2TyBCUSTqRsVPYQDtPOsMWJ137ZZOxb/bysA==
X-Received: by 2002:a17:90a:7d0f:: with SMTP id g15mr9398001pjl.227.1634081774057;
        Tue, 12 Oct 2021 16:36:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 05/46] scsi: message: fusion: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:17 -0700
Message-Id: <20211012233558.4066756-6-bvanassche@acm.org>
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
 drivers/message/fusion/mptfc.c    |  2 +-
 drivers/message/fusion/mptsas.c   |  2 +-
 drivers/message/fusion/mptscsih.c | 36 +++++++++++++++++++------------
 drivers/message/fusion/mptscsih.h |  2 +-
 drivers/message/fusion/mptspi.c   |  2 +-
 5 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 572333fadd68..ecca95d2b9bf 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -129,7 +129,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mptscsih_host_attrs,
+	.shost_groups			= mptscsih_host_attr_groups,
 };
 
 /****************************************************************************
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 85285ba8e817..e31167446a02 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2020,7 +2020,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mptscsih_host_attrs,
+	.shost_groups			= mptscsih_host_attr_groups,
 	.no_write_same			= 1,
 };
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b21978e..03573670c395 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3218,23 +3218,31 @@ mptscsih_debug_level_store(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(debug_level, S_IRUGO | S_IWUSR,
 	mptscsih_debug_level_show, mptscsih_debug_level_store);
 
-struct device_attribute *mptscsih_host_attrs[] = {
-	&dev_attr_version_fw,
-	&dev_attr_version_bios,
-	&dev_attr_version_mpi,
-	&dev_attr_version_product,
-	&dev_attr_version_nvdata_persistent,
-	&dev_attr_version_nvdata_default,
-	&dev_attr_board_name,
-	&dev_attr_board_assembly,
-	&dev_attr_board_tracer,
-	&dev_attr_io_delay,
-	&dev_attr_device_delay,
-	&dev_attr_debug_level,
+static struct attribute *mptscsih_host_attrs[] = {
+	&dev_attr_version_fw.attr,
+	&dev_attr_version_bios.attr,
+	&dev_attr_version_mpi.attr,
+	&dev_attr_version_product.attr,
+	&dev_attr_version_nvdata_persistent.attr,
+	&dev_attr_version_nvdata_default.attr,
+	&dev_attr_board_name.attr,
+	&dev_attr_board_assembly.attr,
+	&dev_attr_board_tracer.attr,
+	&dev_attr_io_delay.attr,
+	&dev_attr_device_delay.attr,
+	&dev_attr_debug_level.attr,
 	NULL,
 };
 
-EXPORT_SYMBOL(mptscsih_host_attrs);
+static const struct attribute_group mptscsih_host_attr_group = {
+	.attrs = mptscsih_host_attrs
+};
+
+const struct attribute_group *mptscsih_host_attr_groups[] = {
+	&mptscsih_host_attr_group,
+	NULL
+};
+EXPORT_SYMBOL(mptscsih_host_attr_groups);
 
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd9be7a..a22c5eaf703c 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -131,7 +131,7 @@ extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
-extern struct device_attribute *mptscsih_host_attrs[];
+extern const struct attribute_group *mptscsih_host_attr_groups[];
 extern struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
 extern void mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index af0ce5611e4a..63c25877a413 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -843,7 +843,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mptscsih_host_attrs,
+	.shost_groups			= mptscsih_host_attr_groups,
 };
 
 static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
