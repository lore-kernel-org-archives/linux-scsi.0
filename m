Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2950DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116E860F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhJLXif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:35 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41841 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbhJLXif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:35 -0400
Received: by mail-pf1-f181.google.com with SMTP id y7so832639pfg.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGryPJutLwtIW7kiq2LyrJM3XZ6rcHgPyWgYs0NR0VQ=;
        b=n7PZLVkfsWbjwEO4TuXRqxrVWhhqV9JfXqGWSqkCURLNrrpsFaMkTJKlA/Exfmpzb0
         95PtQf8uPMEl5CfnLgI7w9q9imhovwzQWSVcvXO7zyB07tf1RjNftoxAlQKaBPy7W44a
         Y+jtNSc6pSb6emHpBO5exnkoCGSaF5KjwYpOnx0EHlMw/VSJ7P05bIvl13D9oOYYTBv6
         22o99BATjsG7d4R2Ar9SSxjiw03ZzJ2oD1WT9CR7NalmA/RfE61IMWeYE8HVLM9Csm6u
         SJ6fcm//HOsvmPFB6LVlVo3GF0fQ1c/x9H08V0M3RwVIwbMCm9p/HwCCNgraK8GEZOi+
         EcWw==
X-Gm-Message-State: AOAM531buEIqrmvC4JqDm9GDgPpbbpidtRBlB/+B5y7Bqnkt17raQPnu
        pcJ9KTjlqSv2wAMySzti4Lw=
X-Google-Smtp-Source: ABdhPJzXy8a1ArfNhZQI3csf6tXkHmUSGP1NYG1qlRamIQQBOc0FEJumOVTRbVuOec3j7sGezimmsg==
X-Received: by 2002:a63:4717:: with SMTP id u23mr25030183pga.359.1634081792715;
        Tue, 12 Oct 2021 16:36:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Lee Jones <lee.jones@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 12/46] scsi: arcmsr: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:24 -0700
Message-Id: <20211012233558.4066756-13-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/arcmsr.h      |  2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c | 33 +++++++++++++++++++------------
 drivers/scsi/arcmsr/arcmsr_hba.c  |  2 +-
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 6ce57f031df5..07df255c4b1b 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -1041,6 +1041,6 @@ extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
 	struct QBUFFER __iomem *);
 extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
-extern struct device_attribute *arcmsr_host_attrs[];
+extern const struct attribute_group *arcmsr_host_groups[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 57be9609d504..baeb5e795690 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -58,8 +58,6 @@
 #include <scsi/scsi_transport.h>
 #include "arcmsr.h"
 
-struct device_attribute *arcmsr_host_attrs[];
-
 static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
 					     struct kobject *kobj,
 					     struct bin_attribute *bin,
@@ -389,16 +387,25 @@ static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, arcmsr_attr_host_fw_numbers_q
 static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, arcmsr_attr_host_fw_sdram_size, NULL);
 static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO, arcmsr_attr_host_fw_hd_channels, NULL);
 
-struct device_attribute *arcmsr_host_attrs[] = {
-	&dev_attr_host_driver_version,
-	&dev_attr_host_driver_posted_cmd,
-	&dev_attr_host_driver_reset,
-	&dev_attr_host_driver_abort,
-	&dev_attr_host_fw_model,
-	&dev_attr_host_fw_version,
-	&dev_attr_host_fw_request_len,
-	&dev_attr_host_fw_numbers_queue,
-	&dev_attr_host_fw_sdram_size,
-	&dev_attr_host_fw_hd_channels,
+static struct attribute *arcmsr_host_attrs[] = {
+	&dev_attr_host_driver_version.attr,
+	&dev_attr_host_driver_posted_cmd.attr,
+	&dev_attr_host_driver_reset.attr,
+	&dev_attr_host_driver_abort.attr,
+	&dev_attr_host_fw_model.attr,
+	&dev_attr_host_fw_version.attr,
+	&dev_attr_host_fw_request_len.attr,
+	&dev_attr_host_fw_numbers_queue.attr,
+	&dev_attr_host_fw_sdram_size.attr,
+	&dev_attr_host_fw_hd_channels.attr,
 	NULL,
 };
+
+static const struct attribute_group arcmsr_host_attr_group = {
+	.attrs = arcmsr_host_attrs,
+};
+
+const struct attribute_group *arcmsr_host_groups[] = {
+	&arcmsr_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ec1a834c922d..a2d7de96ff2b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -167,7 +167,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.sg_tablesize	        = ARCMSR_DEFAULT_SG_ENTRIES,
 	.max_sectors		= ARCMSR_MAX_XFER_SECTORS_C,
 	.cmd_per_lun		= ARCMSR_DEFAULT_CMD_PERLUN,
-	.shost_attrs		= arcmsr_host_attrs,
+	.shost_groups		= arcmsr_host_groups,
 	.no_write_same		= 1,
 };
 
