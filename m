Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380E7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC5D610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhJGVWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:05 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:54937 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbhJGVWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:02 -0400
Received: by mail-pj1-f45.google.com with SMTP id np13so5900137pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0888WQQAG6E62FRWXYXL4SaAalO4wGt5IIAyVnanHY=;
        b=URNsA0rkHvGFQAK4xxV5Fg4Xc1YCv1DRwrOf7OFHzKNmIQS5sGzyvkYCeDwf6IWgfr
         euHLVrllk5unffCf2X5y80atKeivFG1cisDzJeGz4wLvBq9BwvTrl2S1eSCJQi0IYJv6
         aqZmrwHPFfIN8+TmoXEUaZI37by/VMlmo/amzHvDZywKNDfiIy3tEcuBuysA63sWXboU
         EnoRlRXmgHSXnz/JaZ07ASY/JK3ieSjiP8HsHPXuBhmw5n/JIIt+mbRkF3CUvkoZvvzE
         3P6J2ex3i2NVUHYV6asCBD/ee2ncK3vX9y4dBCiakrDKkEmMG31ii1TFCTbTbI0PAWF8
         CiGA==
X-Gm-Message-State: AOAM5301MaLH3586nQ7u3Gr7UhP4cvUZssZ3/A/XVDOcPy8eq49nDI2F
        t97soe6bc5e+yyuMpLc/Tge1EGCGDcar8A==
X-Google-Smtp-Source: ABdhPJzGQtcoI5IEt3nQ+YqyaHXMdvuJ1K+f03dU+CKeRSEIL8mOYrhBZf1LuPya5ZcPkCy4XEvPkQ==
X-Received: by 2002:a17:90b:282:: with SMTP id az2mr7413869pjb.215.1633641608485;
        Thu, 07 Oct 2021 14:20:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 29/46] scsi: mpt3sas: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:35 -0700
Message-Id: <20211007211852.256007-30-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 84 +++++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  8 +--
 3 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f87c0911f66a..cf3fbc4adc6d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1939,8 +1939,8 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_MPI_TRIGGERS_T *mpi_tg, bool set);
 
 /* ctl shared API */
-extern struct device_attribute *mpt3sas_host_attrs[];
-extern struct device_attribute *mpt3sas_dev_attrs[];
+extern const struct attribute_group *mpt3sas_host_attr_groups[];
+extern const struct attribute_group *mpt3sas_dev_attr_groups[];
 void mpt3sas_ctl_init(ushort hbas_to_enumerate);
 void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 770b241d7bb2..2e6f73f5b9a1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3842,37 +3842,46 @@ enable_sdev_max_qd_store(struct device *cdev,
 }
 static DEVICE_ATTR_RW(enable_sdev_max_qd);
 
-struct device_attribute *mpt3sas_host_attrs[] = {
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
-	&dev_attr_logging_level,
-	&dev_attr_fwfault_debug,
-	&dev_attr_fw_queue_depth,
-	&dev_attr_host_sas_address,
-	&dev_attr_ioc_reset_count,
-	&dev_attr_host_trace_buffer_size,
-	&dev_attr_host_trace_buffer,
-	&dev_attr_host_trace_buffer_enable,
-	&dev_attr_reply_queue_count,
-	&dev_attr_diag_trigger_master,
-	&dev_attr_diag_trigger_event,
-	&dev_attr_diag_trigger_scsi,
-	&dev_attr_diag_trigger_mpi,
-	&dev_attr_drv_support_bitmap,
-	&dev_attr_BRM_status,
-	&dev_attr_enable_sdev_max_qd,
+static struct attribute *mpt3sas_host_attrs[] = {
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
+	&dev_attr_logging_level.attr,
+	&dev_attr_fwfault_debug.attr,
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_host_sas_address.attr,
+	&dev_attr_ioc_reset_count.attr,
+	&dev_attr_host_trace_buffer_size.attr,
+	&dev_attr_host_trace_buffer.attr,
+	&dev_attr_host_trace_buffer_enable.attr,
+	&dev_attr_reply_queue_count.attr,
+	&dev_attr_diag_trigger_master.attr,
+	&dev_attr_diag_trigger_event.attr,
+	&dev_attr_diag_trigger_scsi.attr,
+	&dev_attr_diag_trigger_mpi.attr,
+	&dev_attr_drv_support_bitmap.attr,
+	&dev_attr_BRM_status.attr,
+	&dev_attr_enable_sdev_max_qd.attr,
 	NULL,
 };
 
+static const struct attribute_group mpt3sas_host_attr_group = {
+	.attrs = mpt3sas_host_attrs
+};
+
+const struct attribute_group *mpt3sas_host_attr_groups[] = {
+	&mpt3sas_host_attr_group,
+	NULL
+};
+
 /* device attributes */
 
 /**
@@ -3976,14 +3985,23 @@ sas_ncq_prio_enable_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(sas_ncq_prio_enable);
 
-struct device_attribute *mpt3sas_dev_attrs[] = {
-	&dev_attr_sas_address,
-	&dev_attr_sas_device_handle,
-	&dev_attr_sas_ncq_prio_supported,
-	&dev_attr_sas_ncq_prio_enable,
+struct attribute *mpt3sas_dev_attrs[] = {
+	&dev_attr_sas_address.attr,
+	&dev_attr_sas_device_handle.attr,
+	&dev_attr_sas_ncq_prio_supported.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL,
 };
 
+static const struct attribute_group mpt3sas_dev_attr_group = {
+	.attrs = mpt3sas_dev_attrs
+};
+
+const struct attribute_group *mpt3sas_dev_attr_groups[] = {
+	&mpt3sas_dev_attr_group,
+	NULL
+};
+
 /* file operations table for mpt3ctl device */
 static const struct file_operations ctl_fops = {
 	.owner = THIS_MODULE,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f82b1e629af..e79ace9b2bd9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11876,8 +11876,8 @@ static struct scsi_host_template mpt2sas_driver_template = {
 	.sg_tablesize			= MPT2SAS_SG_DEPTH,
 	.max_sectors			= 32767,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mpt3sas_host_attrs,
-	.sdev_attrs			= mpt3sas_dev_attrs,
+	.shost_groups			= mpt3sas_host_attr_groups,
+	.sdev_groups			= mpt3sas_dev_attr_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 };
@@ -11915,8 +11915,8 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.max_sectors			= 32767,
 	.max_segment_size		= 0xffffffff,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mpt3sas_host_attrs,
-	.sdev_attrs			= mpt3sas_dev_attrs,
+	.shost_groups			= mpt3sas_host_attr_groups,
+	.sdev_groups			= mpt3sas_dev_attr_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 	.map_queues			= scsih_map_queues,
