Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBEC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BDB661040
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbhJHU0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:08 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:41642 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhJHU0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:03 -0400
Received: by mail-pj1-f50.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so8688391pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gA6NRNH2A9Xt41KnXTAILbLbUYLHxLunMHE6eX3ZNbw=;
        b=wIbdiAHIECrwd+0jHU4vMFEduXThQ/AFlRuzBUCAYdOIsOwS2jA7ygy06gQKQRNjZw
         8i1R5BHKys916uczVoc75AEom1Urg91kaGyJcG3KE+oUxZ2mZPPrSJYHrApfacBEOlQs
         VMmgzWoHrD9SNbNe51hUj0vtKBCW3y3SmO91YJvfB6Cv09cQXTna/PUezZUkyhjTu/ZW
         9GRXKhXrVAvwRYQPJHGZ0BfUSPP0IC3/+ARImq6WwZc7y2sEqQx3t2ZQTguo6S8VlPYA
         7rsmrsoNXTueOvkp7o4uuYZ3dH6sHsB19Z2+hfhcoeR2O8capcjUk7fX8t0YZlWA7NgM
         YENA==
X-Gm-Message-State: AOAM5332cpC4I+v+wCA3J9QCyjqdec3QvdAD+A9ZSj3e9zeQLCopw/Fx
        6gmuHC0c8BLOnKSvljjqu15/Y101YZqDbw==
X-Google-Smtp-Source: ABdhPJxoFgoYqcHf7WSMprP9G2kX+9XIG3O2FCmQBeVpl7/flGkWKbAwNogLa1DojwPpUHzBltiIew==
X-Received: by 2002:a17:90b:388a:: with SMTP id mu10mr14189682pjb.0.1633724647488;
        Fri, 08 Oct 2021 13:24:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 05/46] scsi: message: fusion: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:12 -0700
Message-Id: <20211008202353.1448570-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
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
