Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EB3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A29561019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242391AbhJHU00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:26 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51749 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhJHU0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:25 -0400
Received: by mail-pj1-f42.google.com with SMTP id kk10so8443803pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGryPJutLwtIW7kiq2LyrJM3XZ6rcHgPyWgYs0NR0VQ=;
        b=GynD+VkY7tg2OjtTA2bQqWWqnO+KpOtMI+B8pKzAOHTNqBOuKC+TYNbLGe//42hdN3
         XnYpnUtyWUO3+oNJRk+BacLb60VWwmGxbd8Ye0IOI7Repna6m/ZEWc+6H/OMX63UEsQK
         jrkHwiKGzEbv3/hSb+5qiuCNdWGDogjb65hrvLZXeqoXXHnCpNoXisorRrvCu4Ge9L4w
         nzrPhLV7OTrX8QvKkSoLqv6uOB7UNyeZ/D6TAsrrZn+fdEG6wtE1o6Rmclt9WQYOABxN
         P5pwahmhUwBQJlyk1fcqAUC9+7yPQLhy6u/XePv9bnRAFQwHRx42rfoN/4ODIVe6uMTu
         6Gpw==
X-Gm-Message-State: AOAM532Sl7QRCONE6mgQZIhtGmVtbN02TlOefa2nbRiZuxLL0wJ3eoVj
        f6IMw1S+cagrDeLk6ltnA5U=
X-Google-Smtp-Source: ABdhPJxV4Ks5EutkyQxc/DeTw6kM2Q7lk3GPdAjD8/ZNgYkIoOtgTeMtWRdkVwfZMlRm9hmfgPDQQA==
X-Received: by 2002:a17:902:930c:b0:13e:42b4:9149 with SMTP id bc12-20020a170902930c00b0013e42b49149mr11206033plb.86.1633724669519;
        Fri, 08 Oct 2021 13:24:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Lee Jones <lee.jones@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 12/46] scsi: arcmsr: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:19 -0700
Message-Id: <20211008202353.1448570-13-bvanassche@acm.org>
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
 
