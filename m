Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CA1C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B520610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhJGVWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:03 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52011 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbhJGVWB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:01 -0400
Received: by mail-pj1-f49.google.com with SMTP id kk10so5924461pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7aGY+un33PINJA1R2SVKhbBbMusgH29CstEqhnoTSU=;
        b=oI5akhiXVX06ureA6fXAwPhWDAGZ/UjHCiRsFV8Vgb8IWdj6jcbo1AAbEBbXAQCLzx
         YNJHkfPhhekRwTqBnKJAFFev6HgfOTLCSbMkdQQvhODU28+yAb2JURLS2jsfZb/mUh+n
         Y7FQpdxBfa6BLzVSvRY1+jaddB4VP4vRcujj2SKzpTuDfKtNFXQ/kWOKoi1VF4qGsUpg
         JhWK3kVtwYWRtbhSK+/Xe3/mBzaB69ecOUWYtY/Bi1sMXN9FqS+UsH5Avt1l0+w7YeSP
         oKkaO5raX3cqsibHyVLHBQszMqcR0aZlcjHpT0KKv5bAgQlWs6t5Cb0tjhgGsfDXf67K
         ul/Q==
X-Gm-Message-State: AOAM530kt570/ezLCYYf903Sm/4cpu3FstLSWEdayzWP2EkFw2aLfw1t
        V0512qqLxpele93hYtcmOnA=
X-Google-Smtp-Source: ABdhPJzPl9TUu+F+MulWr8t8Suf5XYymMfnOrNsA5NAV4tD2p321ufpKRLPvgBh2m5M6i+C91/XUAg==
X-Received: by 2002:a17:902:9689:b0:138:d2ac:44f with SMTP id n9-20020a170902968900b00138d2ac044fmr5945779plp.85.1633641606723;
        Thu, 07 Oct 2021 14:20:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 28/46] scsi: megaraid: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:34 -0700
Message-Id: <20211007211852.256007-29-bvanassche@acm.org>
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
 drivers/scsi/megaraid/megaraid_mbox.c     | 29 ++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c | 31 +++++++++++++++--------
 2 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d20c2e4ee793..1262bb4b225f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -305,20 +305,37 @@ static struct pci_driver megaraid_pci_driver = {
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_app_hndl);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_shost_attrs[] = {
-	&dev_attr_megaraid_mbox_app_hndl,
+static struct attribute *megaraid_shost_attrs[] = {
+	&dev_attr_megaraid_mbox_app_hndl.attr,
 	NULL,
 };
 
+static const struct attribute_group megaraid_shost_attr_group = {
+	.attrs = megaraid_shost_attrs
+};
+
+static const struct attribute_group *megaraid_shost_groups[] = {
+	&megaraid_shost_attr_group,
+	NULL
+};
 
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_ld);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_sdev_attrs[] = {
-	&dev_attr_megaraid_mbox_ld,
+static struct attribute *megaraid_sdev_attrs[] = {
+	&dev_attr_megaraid_mbox_ld.attr,
 	NULL,
 };
 
+static const struct attribute_group megaraid_sdev_attr_group = {
+	.attrs = megaraid_sdev_attrs
+};
+
+static const struct attribute_group *megaraid_sdev_attr_groups[] = {
+	&megaraid_sdev_attr_group,
+	NULL
+};
+
 /*
  * Scsi host template for megaraid unified driver
  */
@@ -331,8 +348,8 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.no_write_same			= 1,
-	.sdev_attrs			= megaraid_sdev_attrs,
-	.shost_attrs			= megaraid_shost_attrs,
+	.sdev_groups			= megaraid_sdev_attr_groups,
+	.shost_groups			= megaraid_shost_groups,
 };
 
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..c68d504ac31e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3481,19 +3481,28 @@ static DEVICE_ATTR_RW(enable_sdev_max_qd);
 static DEVICE_ATTR_RO(dump_system_regs);
 static DEVICE_ATTR_RO(raid_map_id);
 
-static struct device_attribute *megaraid_host_attrs[] = {
-	&dev_attr_fw_crash_buffer_size,
-	&dev_attr_fw_crash_buffer,
-	&dev_attr_fw_crash_state,
-	&dev_attr_page_size,
-	&dev_attr_ldio_outstanding,
-	&dev_attr_fw_cmds_outstanding,
-	&dev_attr_enable_sdev_max_qd,
-	&dev_attr_dump_system_regs,
-	&dev_attr_raid_map_id,
+static struct attribute *megaraid_host_attrs[] = {
+	&dev_attr_fw_crash_buffer_size.attr,
+	&dev_attr_fw_crash_buffer.attr,
+	&dev_attr_fw_crash_state.attr,
+	&dev_attr_page_size.attr,
+	&dev_attr_ldio_outstanding.attr,
+	&dev_attr_fw_cmds_outstanding.attr,
+	&dev_attr_enable_sdev_max_qd.attr,
+	&dev_attr_dump_system_regs.attr,
+	&dev_attr_raid_map_id.attr,
 	NULL,
 };
 
+static const struct attribute_group megaraid_host_attr_group = {
+	.attrs = megaraid_host_attrs,
+};
+
+static const struct attribute_group *megaraid_host_attr_groups[] = {
+	&megaraid_host_attr_group,
+	NULL
+};
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -3510,7 +3519,7 @@ static struct scsi_host_template megasas_template = {
 	.eh_abort_handler = megasas_task_abort,
 	.eh_host_reset_handler = megasas_reset_bus_host,
 	.eh_timed_out = megasas_reset_timer,
-	.shost_attrs = megaraid_host_attrs,
+	.shost_groups = megaraid_host_attr_groups,
 	.bios_param = megasas_bios_param,
 	.map_queues = megasas_map_queues,
 	.mq_poll = megasas_blk_mq_poll,
