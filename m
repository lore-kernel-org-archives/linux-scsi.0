Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E48C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA6E610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhJGVVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:32 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40590 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhJGVVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:31 -0400
Received: by mail-pg1-f173.google.com with SMTP id h3so1033133pgb.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLZopT1ZnuY3S+aSR4gVDm/8/TwPFVJzX94oQLNWStQ=;
        b=Pt5RLMVZ1KVF2Cq3bfVwtkTY+JCG7UQfDcTDCyQXYaKGOmX5nBKF6yk/4WASoSTUaA
         i6ElsrVX72UO678IM/H7wRNMEPvLnODWyPz8n579q528vZT2VXN6xW5bCDPLweApTvio
         mNCeNC5ZdDRrO3/uui0Kni7rhO+NgA+9SjzLXPqNqvGNQpGh2IY4AS7eWbjRBG9+g2BT
         sfZQoNO8IBdkQV1n6NAbzYdvNNoI7TztlRYcPf249noq8ikI1ayB5h/7l6EKxpy7Iykg
         b4pFnKAy3Bzw7O5zmw2fe6uKbzdmTZe+RRiHTuvladODdKlw33zXM6Tgeey2czxJfqst
         zJtg==
X-Gm-Message-State: AOAM533/GV908Convtgo4E8k5/gF3deZZiLg5elY5/Xe3GSTMTwbE+FH
        Ut9v6Agg9VhuTWfwHSk6REk=
X-Google-Smtp-Source: ABdhPJyHlxOGOq9MKD6ZuG0gNeNESGN8Ib/7/YGb7ETT54HfqDXTM//sdhRG84a1di7loDZ0aZ0IBw==
X-Received: by 2002:a62:7a4f:0:b0:448:6a41:14bb with SMTP id v76-20020a627a4f000000b004486a4114bbmr6594508pfc.31.1633641576675;
        Thu, 07 Oct 2021 14:19:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 12/46] scsi: arcmsr: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:18 -0700
Message-Id: <20211007211852.256007-13-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/arcmsr.h      |  2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c | 33 +++++++++++++++++++------------
 drivers/scsi/arcmsr/arcmsr_hba.c  |  2 +-
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 6ce57f031df5..2b63145ed702 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -1041,6 +1041,6 @@ extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
 	struct QBUFFER __iomem *);
 extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
-extern struct device_attribute *arcmsr_host_attrs[];
+extern const struct attribute_group *arcmsr_host_attr_groups[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 57be9609d504..ef448549263c 100644
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
+const struct attribute_group *arcmsr_host_attr_groups[] = {
+	&arcmsr_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ec1a834c922d..2c794f4c7ea7 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -167,7 +167,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.sg_tablesize	        = ARCMSR_DEFAULT_SG_ENTRIES,
 	.max_sectors		= ARCMSR_MAX_XFER_SECTORS_C,
 	.cmd_per_lun		= ARCMSR_DEFAULT_CMD_PERLUN,
-	.shost_attrs		= arcmsr_host_attrs,
+	.shost_groups		= arcmsr_host_attr_groups,
 	.no_write_same		= 1,
 };
 
