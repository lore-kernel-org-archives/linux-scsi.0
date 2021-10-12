Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B389C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472C460ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbhJLXjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:02 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:45834 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbhJLXjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:00 -0400
Received: by mail-pg1-f174.google.com with SMTP id f5so525575pgc.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MKglPxxtWsZ4JxXkn0tjxCJiBfgbvPBkn1oV5hyjPG8=;
        b=jopbaCt0xYgr+uV0HYDg/9r3vYXJH39m9+ZJxXEq//MgRPHbEUqR6gBXn66YvTZ++T
         1yoAdpsZxmJTxyst6ohlozmVJdmGB6lvu2BkRbv8H5ypscDwBelNPPzPpqT+kZGPU9u+
         oyc7rqiGPJRUxWsQpU+lIiRtEo/hYzNxSatwqASYgF5SXYAqNPJjiZf5UbgdIZj4QQP3
         V3iesh5HeDnwDCKcLEmTjo+2aqYSdZMRcnHWUFHaHiQrSn2UB7SkfxUN3+BcTYTZbc3v
         Luy9zh+dcxlxU4CVp6OKPnCjA12WKUVNKEb68jMvAfmLHvsm8X1bgiz0kajMb+8PKP+7
         QC6w==
X-Gm-Message-State: AOAM530+wRpVcIVePYIvzoaD6XeA+a/6kBBlp4zXhvqOI3e3ja7EaWiH
        +6z3oWlYamOFVw+gtrEQqbw=
X-Google-Smtp-Source: ABdhPJyLS0mb9drgP1nalFtqpk6XhPgDa9Cgb6Y/4B0nJpJoiFltbtBK2hnQwGXzyG1OvavG5Mw0+w==
X-Received: by 2002:a05:6a00:1944:b0:438:d002:6e35 with SMTP id s4-20020a056a00194400b00438d0026e35mr34227612pfk.20.1634081818408;
        Tue, 12 Oct 2021 16:36:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 28/46] scsi: megaraid: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:40 -0700
Message-Id: <20211012233558.4066756-29-bvanassche@acm.org>
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
 drivers/scsi/megaraid/megaraid_mbox.c     | 15 ++++++++------
 drivers/scsi/megaraid/megaraid_sas_base.c | 24 ++++++++++++-----------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d20c2e4ee793..bd1f64ae33dd 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -305,20 +305,23 @@ static struct pci_driver megaraid_pci_driver = {
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_app_hndl);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_shost_attrs[] = {
-	&dev_attr_megaraid_mbox_app_hndl,
+static struct attribute *megaraid_shost_attrs[] = {
+	&dev_attr_megaraid_mbox_app_hndl.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(megaraid_shost);
 
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_ld);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_sdev_attrs[] = {
-	&dev_attr_megaraid_mbox_ld,
+static struct attribute *megaraid_sdev_attrs[] = {
+	&dev_attr_megaraid_mbox_ld.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(megaraid_sdev);
+
 /*
  * Scsi host template for megaraid unified driver
  */
@@ -331,8 +334,8 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.no_write_same			= 1,
-	.sdev_attrs			= megaraid_sdev_attrs,
-	.shost_attrs			= megaraid_shost_attrs,
+	.sdev_groups			= megaraid_sdev_groups,
+	.shost_groups			= megaraid_shost_groups,
 };
 
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..2011e081bca4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3481,19 +3481,21 @@ static DEVICE_ATTR_RW(enable_sdev_max_qd);
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
 
+ATTRIBUTE_GROUPS(megaraid_host);
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -3510,7 +3512,7 @@ static struct scsi_host_template megasas_template = {
 	.eh_abort_handler = megasas_task_abort,
 	.eh_host_reset_handler = megasas_reset_bus_host,
 	.eh_timed_out = megasas_reset_timer,
-	.shost_attrs = megaraid_host_attrs,
+	.shost_groups = megaraid_host_groups,
 	.bios_param = megasas_bios_param,
 	.map_queues = megasas_map_queues,
 	.mq_poll = megasas_blk_mq_poll,
