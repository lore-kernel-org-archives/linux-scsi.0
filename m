Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883C2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FAE61077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhJGVVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:05 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:34563 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhJGVVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:04 -0400
Received: by mail-pg1-f182.google.com with SMTP id 133so1052759pgb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gA6NRNH2A9Xt41KnXTAILbLbUYLHxLunMHE6eX3ZNbw=;
        b=EqFrSd9fyVH+AmeVUzAapp7o29XC1ao8EdJGLJNsHcKzKEhHO9UrCXt4edPmo+eL56
         GWmUx+/DpqcfpQfE0HMzVtJHQEv1gIJLGgVbROCJ8vs4f3WF106mcNz3WNRchUTqrZOE
         AEFPZ0TW7N1VlbfLygvsbnk6W5RkaEgisLafdITjUW9Oy15wqff/+VUVZGG2+blO0oXM
         G+mFKEyvdC01Lyfa15fUigfZ+cTjvHvOGQn90dI959IXgsWe7+PDq1pW0m0iHPaUHBf2
         HYABv1UGUJ4LCHkYuq5SNha3qKyXoeuQ8lOfCEC3m8YWETLzIA4YmWxC7ObRGtRzMzgn
         1VcA==
X-Gm-Message-State: AOAM530n6pqPrgq38nHchUo4vkbxRhNmYTccpnxMkJpj/1uFKWwcyPtd
        svncTtyYY2Kr+dwnjUn0Luh/Hp/I5RYr4A==
X-Google-Smtp-Source: ABdhPJxogWfKzyXdSzX7uSIGVrgbr5E4Z0+HFKg17RdX48kN17/tHtM0bmOZEfkFMbb7fZLprHxLSQ==
X-Received: by 2002:a63:e057:: with SMTP id n23mr1518174pgj.183.1633641550131;
        Thu, 07 Oct 2021 14:19:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 05/46] scsi: message: fusion: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:11 -0700
Message-Id: <20211007211852.256007-6-bvanassche@acm.org>
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
