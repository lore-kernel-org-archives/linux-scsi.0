Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A32C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F13610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbhJGVWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:34 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44639 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbhJGVWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:33 -0400
Received: by mail-pg1-f178.google.com with SMTP id s11so1022337pgr.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFUyWvP294XKjeKbW0DRqZMjX2G+ZwKoro0KSFlEbXk=;
        b=1UbwfVX3F3zG1bl63QTxBLMVO8GM1bD6KbpOK1JYySGoAKXgKcSNZSuAM0UBcwTSEO
         aDUu0hTOw/EONMJ2lmO+tDPFb5jpq0PIOxffhItP935ng0REs5i5yfwzPk17krB1AAa0
         BbExOC9+bxyKyFLlNFzCuik+izS1AU2qzhizZ9orpzCPogve+9rbMsYeooSL2JLvEOzZ
         D47szTVg7RcTbzvcaoKz08Vo9lqyrOkUM6exYZ3Fo1IOy8LMFh0umWqPMnK4mRGhg41l
         J+sNmm3jOTmnTTMQnrPRDfTc0Ep8okNI3evX4IyBKJcA7wf3HcsaTmmNLl1dFJ1qmGBy
         FQ4Q==
X-Gm-Message-State: AOAM530HUIUdwaOygSezQwxUdiHAo95FWaHBtj0DpQsD7SamD5mr4ac+
        e5bN9ls6WV/7wJ+VE7SOZmY=
X-Google-Smtp-Source: ABdhPJznQATJ59hwtYuWUiaGgcciLU/Ti9Z8aL+LzehxAkLQ2defAXtjnNX3mTeuVzbp6aqtVtEe7A==
X-Received: by 2002:a63:105c:: with SMTP id 28mr1483233pgq.187.1633641639055;
        Thu, 07 Oct 2021 14:20:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 42/46] scsi: smartpqi: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:48 -0700
Message-Id: <20211007211852.256007-43-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 60 +++++++++++++++++----------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b966ce3b4385..8386ee556992 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6847,17 +6847,26 @@ static DEVICE_ATTR(enable_r5_writes, 0644,
 static DEVICE_ATTR(enable_r6_writes, 0644,
 	pqi_host_enable_r6_writes_show, pqi_host_enable_r6_writes_store);
 
-static struct device_attribute *pqi_shost_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_firmware_version,
-	&dev_attr_model,
-	&dev_attr_serial_number,
-	&dev_attr_vendor,
-	&dev_attr_rescan,
-	&dev_attr_lockup_action,
-	&dev_attr_enable_stream_detection,
-	&dev_attr_enable_r5_writes,
-	&dev_attr_enable_r6_writes,
+static struct attribute *pqi_shost_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_model.attr,
+	&dev_attr_serial_number.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_rescan.attr,
+	&dev_attr_lockup_action.attr,
+	&dev_attr_enable_stream_detection.attr,
+	&dev_attr_enable_r5_writes.attr,
+	&dev_attr_enable_r6_writes.attr,
+	NULL
+};
+
+static const struct attribute_group pqi_shost_attr_group = {
+	.attrs = pqi_shost_attrs
+};
+
+static const struct attribute_group *pqi_shost_groups[] = {
+	&pqi_shost_attr_group,
 	NULL
 };
 
@@ -7129,14 +7138,23 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 
-static struct device_attribute *pqi_sdev_attrs[] = {
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
-	&dev_attr_ssd_smart_path_enabled,
-	&dev_attr_raid_level,
-	&dev_attr_raid_bypass_cnt,
+static struct attribute *pqi_sdev_attrs[] = {
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
+	&dev_attr_ssd_smart_path_enabled.attr,
+	&dev_attr_raid_level.attr,
+	&dev_attr_raid_bypass_cnt.attr,
+	NULL
+};
+
+static const struct attribute_group pqi_sdev_attr_group = {
+	.attrs = pqi_sdev_attrs
+};
+
+static const struct attribute_group *pqi_sdev_attr_groups[] = {
+	&pqi_sdev_attr_group,
 	NULL
 };
 
@@ -7153,8 +7171,8 @@ static struct scsi_host_template pqi_driver_template = {
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
 	.map_queues = pqi_map_queues,
-	.sdev_attrs = pqi_sdev_attrs,
-	.shost_attrs = pqi_shost_attrs,
+	.sdev_groups = pqi_sdev_attr_groups,
+	.shost_groups = pqi_shost_groups,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
