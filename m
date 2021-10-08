Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79F5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D318C61100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242570AbhJHU1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:01 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33656 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbhJHU0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:53 -0400
Received: by mail-pf1-f169.google.com with SMTP id s16so9167799pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mh3M1EkLxaT+jqCdmvj7prtfnoNQvYX0HXxwkfhWPFs=;
        b=TwvRQ2qlTXdvn28tmEQjuNScYnz7xIy18/OBrIVWbqxICGYSVDImTuW6aj6OnI+M87
         qe3P2SlCYeocbV70kYytOuPly2Ex/5SckFKZlgiJyJ0TmJrdfpVopqJaCD4vpLj+xqOi
         2oSKiCMim1xw79rOQNN14pZB2aM/cRYSne2DhC+zqIFbdetMyiW23Mk8AGhhb2Epdo3d
         8DMGjJDn80QxRJclK2v+hCK3pqJkiRM8CaIjdHrGqurXe+jadAE789aPuLf5pQwCd+2Q
         1+BrkGZzczU3/R8WLwqZ871FBzDiLCajI0knyzMnQKXUlJTLCovr2oPgospDEMBm4dFO
         kKcg==
X-Gm-Message-State: AOAM5330PXhZ6bTgfgTTWN7RENGLtFl42lcOsq6WkK2220U3sBLbSMRR
        xSTGUw1Yhv+vELUga6egXVI=
X-Google-Smtp-Source: ABdhPJz3iRG74VFkZO8NKWtJTsEREXyaKWPD3PbcPhOlzJU+lw1noAJI+7AgxOFe4ahaNEdDGSwm5w==
X-Received: by 2002:a63:6e8d:: with SMTP id j135mr6231596pgc.116.1633724697207;
        Fri, 08 Oct 2021 13:24:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 29/46] scsi: mpt3sas: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:36 -0700
Message-Id: <20211008202353.1448570-30-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 84 +++++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  8 +--
 3 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f87c0911f66a..db6a759de1e9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1939,8 +1939,8 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_MPI_TRIGGERS_T *mpi_tg, bool set);
 
 /* ctl shared API */
-extern struct device_attribute *mpt3sas_host_attrs[];
-extern struct device_attribute *mpt3sas_dev_attrs[];
+extern const struct attribute_group *mpt3sas_host_groups[];
+extern const struct attribute_group *mpt3sas_dev_groups[];
 void mpt3sas_ctl_init(ushort hbas_to_enumerate);
 void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 770b241d7bb2..adcf97a5ca81 100644
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
+const struct attribute_group *mpt3sas_host_groups[] = {
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
+const struct attribute_group *mpt3sas_dev_groups[] = {
+	&mpt3sas_dev_attr_group,
+	NULL
+};
+
 /* file operations table for mpt3ctl device */
 static const struct file_operations ctl_fops = {
 	.owner = THIS_MODULE,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f82b1e629af..4806dd240d6b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11876,8 +11876,8 @@ static struct scsi_host_template mpt2sas_driver_template = {
 	.sg_tablesize			= MPT2SAS_SG_DEPTH,
 	.max_sectors			= 32767,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mpt3sas_host_attrs,
-	.sdev_attrs			= mpt3sas_dev_attrs,
+	.shost_groups			= mpt3sas_host_groups,
+	.sdev_groups			= mpt3sas_dev_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 };
@@ -11915,8 +11915,8 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.max_sectors			= 32767,
 	.max_segment_size		= 0xffffffff,
 	.cmd_per_lun			= 7,
-	.shost_attrs			= mpt3sas_host_attrs,
-	.sdev_attrs			= mpt3sas_dev_attrs,
+	.shost_groups			= mpt3sas_host_groups,
+	.sdev_groups			= mpt3sas_dev_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 	.map_queues			= scsih_map_queues,
