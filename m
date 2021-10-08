Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF57C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B1B610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhJHU0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:14 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:35525 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242602AbhJHU0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:12 -0400
Received: by mail-pg1-f170.google.com with SMTP id e7so4177881pgk.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3dt644jJFcxByiVopzbHO/3VhgDBHnjcH7YBR0cYF4=;
        b=iJ2Q5C3JfxIRcvDYEA1NHMaLs5eD+qS2ZSHO6vOYxSpg6wsoECHzjJYvUnnjEC/udi
         nBNxEjsPGrur1XfCX1VaFNah80JP2CJubue7GDc5tu7PY6eaEnlZj7K+wZ6eRR6EExnr
         M/QQ0aSIwT01P+k0UHLAYTYSF9xqJgy+g0FEKR1qizXTo0jMWLK0P8rgLADvPTZQjcuL
         rircZ6r3JalcbWUZDjfwcB7AhUFRuODZTFxO1aBH1ICnljcn9xbK8g8qLko/TR7+6Wrt
         Etb/pAtS2kJ8X9MYpqbEu6bSqQJWj5s+IGzOz2JFRwatQAyB+NS6c9Hlri5bs2DcJ891
         luLA==
X-Gm-Message-State: AOAM531aZrfYk8bC91zoI5i/EtOMa/hBWc7llKXN4OYcwRSgAVvG8LyJ
        NB/Uh4IUPpinJQtKiU95i0LzM2gVSYxfGA==
X-Google-Smtp-Source: ABdhPJwFOx0ZvElsNtFQ3M9MlQv37XlpGTdLlChRmrp7W0JWjZt7KNeh8OKre9MKn1q0ySrxB8gawg==
X-Received: by 2002:a63:e002:: with SMTP id e2mr6276560pgh.386.1633724655989;
        Fri, 08 Oct 2021 13:24:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 11/46] scsi: aacraid: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:18 -0700
Message-Id: <20211008202353.1448570-12-bvanassche@acm.org>
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
