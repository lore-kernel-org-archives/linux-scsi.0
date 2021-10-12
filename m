Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB53CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9582F60E54
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhJLXjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:33 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:55182 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbhJLXj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:27 -0400
Received: by mail-pj1-f51.google.com with SMTP id np13so789137pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Znd2qZV0vS99jLjSB0zn46RpnpMii7+G/Fr87UH6vgU=;
        b=k6ZKTsSwM+1db8POSnFG5TKh7DeK5z1f5BYtThqUwFfFjgHOB59+LClELrrsL3905b
         H/+Pl9kO8pHEdD04e/RVszq5vnPkx9NcMDjvWYWSfOsOycNQHnTF6Jbwr0/UVqA7+da6
         TDyJGHLJI58ae1UbiD60+sDF74syiVZwgAFgZp3hYucvXgzc+2sRCLVchBpEQYfXqvtp
         esJ/ZsPGWbRv6bJ4Edn7EQ/vaq27BbUAiaaBptveCpWVNKfz0hmkRLW8v9b7YXlXJtQM
         8VtoR732e2aA2pSqskBoHH+pvFdeW+GFKtYYUn8D0gg04ja7h9bKjshDsiXigNNY1jS7
         ixVg==
X-Gm-Message-State: AOAM532KM3YeImDsfku9NQNCnz0SzI7hY1LBc9zcVhaU35nYT+al7rip
        J6fdnPvBtFRKBri91EyyL3M=
X-Google-Smtp-Source: ABdhPJwcusHmSUwjylqXicdNVgbuAikAdW9B/LkukWhcALQ7iaU1HdBEN0TZ0oTyiGOikKVYQntKHw==
X-Received: by 2002:a17:902:e202:b0:13f:398d:97b0 with SMTP id u2-20020a170902e20200b0013f398d97b0mr14366106plb.53.1634081845188;
        Tue, 12 Oct 2021 16:37:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 42/46] scsi: smartpqi: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:54 -0700
Message-Id: <20211012233558.4066756-43-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 46 +++++++++++++++------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b966ce3b4385..6a6a83331ef0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6847,20 +6847,22 @@ static DEVICE_ATTR(enable_r5_writes, 0644,
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
 	NULL
 };
 
+ATTRIBUTE_GROUPS(pqi_shost);
+
 static ssize_t pqi_unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
@@ -7129,17 +7131,19 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
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
 	NULL
 };
 
+ATTRIBUTE_GROUPS(pqi_sdev);
+
 static struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
@@ -7153,8 +7157,8 @@ static struct scsi_host_template pqi_driver_template = {
 	.slave_alloc = pqi_slave_alloc,
 	.slave_configure = pqi_slave_configure,
 	.map_queues = pqi_map_queues,
-	.sdev_attrs = pqi_sdev_attrs,
-	.shost_attrs = pqi_shost_attrs,
+	.sdev_groups = pqi_sdev_groups,
+	.shost_groups = pqi_shost_groups,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
