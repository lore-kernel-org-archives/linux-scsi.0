Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6602BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCFF61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhJGVVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:15 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46938 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhJGVVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:13 -0400
Received: by mail-pf1-f181.google.com with SMTP id u7so6376258pfg.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bqJcVZCUbfW9e5QC2dYagXhWvlGFkQaQfw/2RxDVN/s=;
        b=0DvqV6zlmlfpyFaw+cJEOMOBdL93S1TsL7i7y+wwL/jyvbp285zcUyYqfYznUyq14f
         O6n9AOVgj/YRaONpAObwTETIoP6SyiC2XkmkXcayeTj5xrj/8HQvgRkh0G9CWgS+5UtU
         UNKmh1o9RxbyCHl9cpqd06THG4KlSYVjC7q1fyn0dqyCfElUkpSFYRBTTb0t3o9CE/rP
         jOGoBKkUTb//3vZmAwDscO1ly7tXGlkuCTKAzKGiaG8+HlNs6HDeYQI4uvFNu2LPJskE
         0YzR7Rgd5KUrOSMH971m12iEKns6YuPCo7RyMNLNftQyQ0vb5RIhqUtbmEoG8jYRLaFc
         jlOQ==
X-Gm-Message-State: AOAM533S8FcazmvlRBjM1WV7QO6nKacgrYuYXKQA+Cu+1AXe+Mv6QIvM
        s8ObZeAJLUleZA/K4/le8cs=
X-Google-Smtp-Source: ABdhPJwdyzUtWJcnH+QthzJ13jijlaUhmE1koYMtltCuNQtcV9scojBDpzB8dL+/mAviUdOgTkK0MA==
X-Received: by 2002:a63:1656:: with SMTP id 22mr1551825pgw.20.1633641559064;
        Thu, 07 Oct 2021 14:19:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 11/46] scsi: aacraid: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:17 -0700
Message-Id: <20211007211852.256007-12-bvanassche@acm.org>
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
 drivers/scsi/aacraid/linit.c | 52 ++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa7..f9a51389e980 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -605,12 +605,21 @@ static struct device_attribute aac_unique_id_attr = {
 
 
 
-static struct device_attribute *aac_dev_attrs[] = {
-	&aac_raid_level_attr,
-	&aac_unique_id_attr,
+static struct attribute *aac_dev_attrs[] = {
+	&aac_raid_level_attr.attr,
+	&aac_unique_id_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group aac_dev_attr_group = {
+	.attrs = aac_dev_attrs
+};
+
+static const struct attribute_group *aac_dev_attr_groups[] = {
+	&aac_dev_attr_group,
+	NULL
+};
+
 static int aac_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg)
 {
@@ -1442,21 +1451,30 @@ static struct device_attribute aac_reset = {
 	.show = aac_show_reset_adapter,
 };
 
-static struct device_attribute *aac_attrs[] = {
-	&aac_model,
-	&aac_vendor,
-	&aac_flags,
-	&aac_kernel_version,
-	&aac_monitor_version,
-	&aac_bios_version,
-	&aac_lld_version,
-	&aac_serial_number,
-	&aac_max_channel,
-	&aac_max_id,
-	&aac_reset,
+static struct attribute *aac_attrs[] = {
+	&aac_model.attr,
+	&aac_vendor.attr,
+	&aac_flags.attr,
+	&aac_kernel_version.attr,
+	&aac_monitor_version.attr,
+	&aac_bios_version.attr,
+	&aac_lld_version.attr,
+	&aac_serial_number.attr,
+	&aac_max_channel.attr,
+	&aac_max_id.attr,
+	&aac_reset.attr,
 	NULL
 };
 
+static const struct attribute_group aac_attr_group = {
+	.attrs = aac_attrs,
+};
+
+static const struct attribute_group *aac_attr_groups[] = {
+	&aac_attr_group,
+	NULL,
+};
+
 ssize_t aac_get_serial_number(struct device *device, char *buf)
 {
 	return aac_show_serial_number(device, &aac_serial_number, buf);
@@ -1483,10 +1501,10 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
-	.shost_attrs			= aac_attrs,
+	.shost_groups			= aac_attr_groups,
 	.slave_configure		= aac_slave_configure,
 	.change_queue_depth		= aac_change_queue_depth,
-	.sdev_attrs			= aac_dev_attrs,
+	.sdev_groups			= aac_dev_attr_groups,
 	.eh_abort_handler		= aac_eh_abort,
 	.eh_device_reset_handler	= aac_eh_dev_reset,
 	.eh_target_reset_handler	= aac_eh_target_reset,
