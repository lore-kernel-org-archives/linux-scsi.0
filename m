Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BECEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5634761130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhJGVVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:52 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:44764 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGVVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:50 -0400
Received: by mail-pf1-f169.google.com with SMTP id 145so6385232pfz.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=558P0CCZzKFOFS9s2jNS4IcULk/D+oEkMPOVQk4B1Rk=;
        b=et4zJX/zXldWx3lCOJ8I5WB9N9D7l0SDmZWp3ulyHyOlYsDOqGmyzPxKbCz9PBw4Vo
         M5G9abbHed7tbINKUG5NabtNHQ6JCJP6m24VPn43+RsbDZch6H2LhNByWzILl1vtuhrX
         RM87IM213sfOd7QYpIysW3WEaWcbEdjOHnt+mtAlQNPcIKfC/Yxj6QNsw4PxW3IrKCEi
         ztnNcuHgDmVGZAvKmOeI69kibeSwRW1HLjKH+1sdJdjQQU5dNCW1DaIZKII2GniAm1fF
         po5FLRJ7kD302DcLCLxnWg1Vc46O8VNnbTucpOrpkVLHBxQqqf+/cb2KQLWICbSyev78
         gXvw==
X-Gm-Message-State: AOAM531MTsXv/B53YuW9Ut9MT/sajZvI0W6VW3x3xnE5llK+lJhiiIbF
        DcHcue3UsOLpd5BJoQpAqUc=
X-Google-Smtp-Source: ABdhPJxeOvRWm8WwegCfL/JZwZwFsmoYC2oxTKnKeo3EhFfslm3Xa3dgIkmSQgqRLJjaD9yNPNEZGg==
X-Received: by 2002:a63:e057:: with SMTP id n23mr1520791pgj.183.1633641595977;
        Thu, 07 Oct 2021 14:19:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 21/46] scsi: hpsa: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:27 -0700
Message-Id: <20211007211852.256007-22-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 58 +++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..d012c74b8d7e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -936,30 +936,48 @@ static DEVICE_ATTR(ctlr_num, S_IRUGO,
 static DEVICE_ATTR(legacy_board, S_IRUGO,
 	host_show_legacy_board, NULL);
 
-static struct device_attribute *hpsa_sdev_attrs[] = {
-	&dev_attr_raid_level,
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_hp_ssd_smart_path_enabled,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
+static struct attribute *hpsa_sdev_attrs[] = {
+	&dev_attr_raid_level.attr,
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_hp_ssd_smart_path_enabled.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
 	NULL,
 };
 
-static struct device_attribute *hpsa_shost_attrs[] = {
-	&dev_attr_rescan,
-	&dev_attr_firmware_revision,
-	&dev_attr_commands_outstanding,
-	&dev_attr_transport_mode,
-	&dev_attr_resettable,
-	&dev_attr_hp_ssd_smart_path_status,
-	&dev_attr_raid_offload_debug,
-	&dev_attr_lockup_detected,
-	&dev_attr_ctlr_num,
-	&dev_attr_legacy_board,
+static const struct attribute_group hpsa_sdev_attr_group = {
+	.attrs = hpsa_sdev_attrs
+};
+
+static const struct attribute_group *hpsa_sdev_attr_groups[] = {
+	&hpsa_sdev_attr_group,
+	NULL
+};
+
+static struct attribute *hpsa_shost_attrs[] = {
+	&dev_attr_rescan.attr,
+	&dev_attr_firmware_revision.attr,
+	&dev_attr_commands_outstanding.attr,
+	&dev_attr_transport_mode.attr,
+	&dev_attr_resettable.attr,
+	&dev_attr_hp_ssd_smart_path_status.attr,
+	&dev_attr_raid_offload_debug.attr,
+	&dev_attr_lockup_detected.attr,
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_legacy_board.attr,
 	NULL,
 };
 
+static const struct attribute_group hpsa_shost_attr_group = {
+	.attrs = hpsa_shost_attrs
+};
+
+static const struct attribute_group *hpsa_shost_groups[] = {
+	&hpsa_shost_attr_group,
+	NULL
+};
+
 #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
 				 HPSA_MAX_CONCURRENT_PASSTHRUS)
 
@@ -980,8 +998,8 @@ static struct scsi_host_template hpsa_driver_template = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
-	.sdev_attrs = hpsa_sdev_attrs,
-	.shost_attrs = hpsa_shost_attrs,
+	.sdev_groups = hpsa_sdev_attr_groups,
+	.shost_groups = hpsa_shost_groups,
 	.max_sectors = 2048,
 	.no_write_same = 1,
 };
