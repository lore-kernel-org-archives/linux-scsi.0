Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A8EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB50610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbhJHU1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:12 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:51796 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhJHU1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:07 -0400
Received: by mail-pj1-f43.google.com with SMTP id kk10so8444943pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3h7aoMc84NKzjzZE/fO895YxKdkZ5QtZ6t4kOQrxBg=;
        b=pfCzoTTenazp07KwN46ryXVd0r2H7FP7L1eReHZycD85H+/JEuPqeNDk5BJjfW4tWO
         ti+TyQvBTc9jGcSxMW/d1lk/WU8efrF9oh+jTWh0vFmwI9WXme9kErs5h7W1lnnWcJ2K
         XxwYNfDOI6YczFBbfUnsJTsE0ngrd1HotKBaT0r5UIVE4hnQKx+2WGMJ3vzGeIWoj8s0
         +/4LAZdTgq4+e/qRazGtdYYI6+2rjXbI/Fpo6za2DtvfwtxIArDMP7vFcGv0tiPgl7kG
         cU+e+7zTbIetJImfPcR5+h8fIlP7WdK8rtqGE1hFI58FYhcfY0tKyiCRdRu6ywToXVbK
         8How==
X-Gm-Message-State: AOAM533AFsOV0V0Bzv2TNwrNSJzrvtXrPHAXYOyCyA/2LgOXbfu38DSl
        EuTZVfbZaLjRwdk9OXxYcio=
X-Google-Smtp-Source: ABdhPJzsAjRUCHx5md3vuacL05rN6XJ7JOBa59SoLZHjV2DywbcSmmSXUUIWDOq5q2YprO10/mtv7g==
X-Received: by 2002:a17:903:1ca:b0:13e:f367:9361 with SMTP id e10-20020a17090301ca00b0013ef3679361mr11426377plh.3.1633724711763;
        Fri, 08 Oct 2021 13:25:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 35/46] scsi: pm8001: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:42 -0700
Message-Id: <20211008202353.1448570-36-bvanassche@acm.org>
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
 drivers/scsi/pm8001/pm8001_ctl.c  | 64 +++++++++++++++++--------------
 drivers/scsi/pm8001/pm8001_init.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
 3 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index b25e447aa3bd..397eb9f6a1dd 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1002,34 +1002,42 @@ static ssize_t ctl_iop1_count_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_iop1_count);
 
-struct device_attribute *pm8001_host_attrs[] = {
-	&dev_attr_interface_rev,
-	&dev_attr_controller_fatal_error,
-	&dev_attr_fw_version,
-	&dev_attr_update_fw,
-	&dev_attr_aap_log,
-	&dev_attr_iop_log,
-	&dev_attr_fatal_log,
-	&dev_attr_non_fatal_log,
-	&dev_attr_non_fatal_count,
-	&dev_attr_gsm_log,
-	&dev_attr_max_out_io,
-	&dev_attr_max_devices,
-	&dev_attr_max_sg_list,
-	&dev_attr_sas_spec_support,
-	&dev_attr_logging_level,
-	&dev_attr_event_log_size,
-	&dev_attr_host_sas_address,
-	&dev_attr_bios_version,
-	&dev_attr_ib_log,
-	&dev_attr_ob_log,
-	&dev_attr_ila_version,
-	&dev_attr_inc_fw_ver,
-	&dev_attr_ctl_mpi_state,
-	&dev_attr_ctl_hmi_error,
-	&dev_attr_ctl_raae_count,
-	&dev_attr_ctl_iop0_count,
-	&dev_attr_ctl_iop1_count,
+static struct attribute *pm8001_host_attrs[] = {
+	&dev_attr_interface_rev.attr,
+	&dev_attr_controller_fatal_error.attr,
+	&dev_attr_fw_version.attr,
+	&dev_attr_update_fw.attr,
+	&dev_attr_aap_log.attr,
+	&dev_attr_iop_log.attr,
+	&dev_attr_fatal_log.attr,
+	&dev_attr_non_fatal_log.attr,
+	&dev_attr_non_fatal_count.attr,
+	&dev_attr_gsm_log.attr,
+	&dev_attr_max_out_io.attr,
+	&dev_attr_max_devices.attr,
+	&dev_attr_max_sg_list.attr,
+	&dev_attr_sas_spec_support.attr,
+	&dev_attr_logging_level.attr,
+	&dev_attr_event_log_size.attr,
+	&dev_attr_host_sas_address.attr,
+	&dev_attr_bios_version.attr,
+	&dev_attr_ib_log.attr,
+	&dev_attr_ob_log.attr,
+	&dev_attr_ila_version.attr,
+	&dev_attr_inc_fw_ver.attr,
+	&dev_attr_ctl_mpi_state.attr,
+	&dev_attr_ctl_hmi_error.attr,
+	&dev_attr_ctl_raae_count.attr,
+	&dev_attr_ctl_iop0_count.attr,
+	&dev_attr_ctl_iop1_count.attr,
 	NULL,
 };
 
+static const struct attribute_group pm8001_host_attr_group = {
+	.attrs = pm8001_host_attrs
+};
+
+const struct attribute_group *pm8001_host_groups[] = {
+	&pm8001_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7082fecf7ce8..bed8cc125544 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -107,7 +107,7 @@ static struct scsi_host_template pm8001_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= pm8001_host_attrs,
+	.shost_groups		= pm8001_host_groups,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 7e999768bfd2..83eec16d021d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -733,7 +733,7 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
-extern struct device_attribute *pm8001_host_attrs[];
+extern const struct attribute_group *pm8001_host_groups[];
 
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
