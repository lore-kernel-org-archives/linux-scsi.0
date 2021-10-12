Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEDDC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4666D60EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhJLXi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:27 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:37844 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbhJLXiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:24 -0400
Received: by mail-pg1-f182.google.com with SMTP id r201so558003pgr.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3dt644jJFcxByiVopzbHO/3VhgDBHnjcH7YBR0cYF4=;
        b=vR6Oz99k2v4VAmCGOo6viem606SilVs35gvamdXyUXAvC6Yx8NRn32sFvlbgnPb9i4
         GcCDxF/7FgHyom9tv8uCrQqAFtyu11Eqz9Yo/olpeUywV/ITqvswmkBmdlDyc7aXtcZW
         m5uVLDL4X8KyELRNIu+HPbqx/E3cS8LL6U7xqcxuk03RKAJOyY5VkwHIdxcu+2q46wo7
         XHfCZ3lcRTPcr6Hv+gFR/18LSOXLpeS4QGuDnijiMfS2tPSzu/8PBEJGucBYnyivGadM
         GZ3sdMZm+y6HH1qi6bnrMfvR8pTqInevrUpgbF9tzaG2uzH9vrm54vJuCDBxXLJ/Ue1m
         e7Gg==
X-Gm-Message-State: AOAM533eYv7blr7DUvLM36nQt7HtbsYidTVygbxxScYwNSA07RUElqZU
        +R0eBaCpvm8wljtiz01vP+Y=
X-Google-Smtp-Source: ABdhPJz9gYE8yAjz27TsMmjQ9iM66mliZLKAkhI+m1tEzqkY1kWb8vGISFoyDZRyqnrpbskHrTaS5w==
X-Received: by 2002:a63:470b:: with SMTP id u11mr24836487pga.441.1634081782332;
        Tue, 12 Oct 2021 16:36:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 11/46] scsi: aacraid: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:23 -0700
Message-Id: <20211012233558.4066756-12-bvanassche@acm.org>
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
 drivers/scsi/aacraid/linit.c | 38 ++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa7..a911252075a6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -605,12 +605,14 @@ static struct device_attribute aac_unique_id_attr = {
 
 
 
-static struct device_attribute *aac_dev_attrs[] = {
-	&aac_raid_level_attr,
-	&aac_unique_id_attr,
+static struct attribute *aac_dev_attrs[] = {
+	&aac_raid_level_attr.attr,
+	&aac_unique_id_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(aac_dev);
+
 static int aac_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg)
 {
@@ -1442,21 +1444,23 @@ static struct device_attribute aac_reset = {
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
+static struct attribute *aac_host_attrs[] = {
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
 
+ATTRIBUTE_GROUPS(aac_host);
+
 ssize_t aac_get_serial_number(struct device *device, char *buf)
 {
 	return aac_show_serial_number(device, &aac_serial_number, buf);
@@ -1483,10 +1487,10 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
-	.shost_attrs			= aac_attrs,
+	.shost_groups			= aac_host_groups,
 	.slave_configure		= aac_slave_configure,
 	.change_queue_depth		= aac_change_queue_depth,
-	.sdev_attrs			= aac_dev_attrs,
+	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
 	.eh_device_reset_handler	= aac_eh_dev_reset,
 	.eh_target_reset_handler	= aac_eh_target_reset,
