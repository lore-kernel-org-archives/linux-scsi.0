Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A464C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8338161077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbhJGVWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:23 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:43593 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhJGVWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:22 -0400
Received: by mail-pg1-f175.google.com with SMTP id r2so1023953pgl.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSqdlEd51D1G13fXTl3WMtijrgfWuGIxBZO2N1mdIGA=;
        b=eqfhf/x7e4l493rfq8i9Xha+gSv/6OFBbHOGd6L65qNNvaA9RapVKxUzIX4k5F6fBJ
         NqPQp+ArbKqa4OLFityI+jb36u1EO9Pmpo55x5Zexbs1Qg5Id55Dp14ZLXCAAPdEqfZA
         p6ThF2lRVC4HYqz57ib5rWSrDgSMcQUKTHP+VUUUNHOYr85qmUehWwTxD4SWw1+NHuMU
         YqpOhTeDk4sB46s54nqIbKnuueiyX3y5XaIMQImwakl0fCZIPsuN5wvRu3+R6ZWWi7js
         QwBGkefNroAXci3pZEUc0rF3CjLoUVRkXDgoWgikNkVnb/sYNJl4oUiETHmlXOC91702
         h6UA==
X-Gm-Message-State: AOAM532y0lud2b1dTbeMkI7/KpExWi2zhuMAeXnHfB9ah7iRe+8ctdpS
        bLZQ7a7KohuYZHFvWnQlThE=
X-Google-Smtp-Source: ABdhPJxV/zcX1PnVy2t3BfirfWCps36ebvWotO3AXc0xcdNB5S/Q7Z7yT5VxIenp3WEdNqdwbvp8/g==
X-Received: by 2002:aa7:949c:0:b0:44c:a0df:2c7f with SMTP id z28-20020aa7949c000000b0044ca0df2c7fmr6642491pfk.34.1633641628080;
        Thu, 07 Oct 2021 14:20:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 35/46] scsi: pm8001: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:41 -0700
Message-Id: <20211007211852.256007-36-bvanassche@acm.org>
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
 drivers/scsi/pm8001/pm8001_ctl.c  | 64 +++++++++++++++++--------------
 drivers/scsi/pm8001/pm8001_init.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
 3 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index b25e447aa3bd..916a95211b03 100644
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
+const struct attribute_group *pm8001_host_attr_groups[] = {
+	&pm8001_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7082fecf7ce8..6c48bf6ce370 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -107,7 +107,7 @@ static struct scsi_host_template pm8001_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= pm8001_host_attrs,
+	.shost_groups		= pm8001_host_attr_groups,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 7e999768bfd2..b43dedc5c9d9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -733,7 +733,7 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
-extern struct device_attribute *pm8001_host_attrs[];
+extern const struct attribute_group *pm8001_host_attr_groups[];
 
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
