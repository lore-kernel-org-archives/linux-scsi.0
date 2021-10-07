Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C088C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 738A7610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhJGVVq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:46 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38695 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhJGVVp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:45 -0400
Received: by mail-pj1-f54.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so7902725pjc.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILCdfMjMlEywtFO+swooiCogyq33/AUvhdi2qGcJ4G8=;
        b=yZFOcTtuViA4hRB8ghoLHW4KdYQS3JbwhwlzYzLEoqtkXu3WAcUkSnGNS1PsN3zWnM
         f/avVy0TMHlwz0D0LYr1pQ2h27U+4ZYsjal4QbQJh++Zf9LgBWjefLZPhXyKKr6q3Ty8
         X/AB1sg0axhnY7jEgd4GE9EEPYJ8kjWd9GCg0UqgPrR7dvkK6ID2s4FoN9RR4DxHjH7p
         Gb4B5mUAPFxIQ5PR41f7tA81Lo+Y3aTXRk+084RcA+JE1cc8HdSaHC1qNspOeUOWiSXz
         Mehyi7JXUXoiBfVSQajaiEi8MHFdFdj+2uPdOdUlaajPHUZJNBFuRBQ02F7jgKg3csVs
         8q2Q==
X-Gm-Message-State: AOAM530PIoSKYSURQCAkbzuck3xKXJ8s8DDoAlX9gq+G4TQ5qnVV95ns
        4ObQnurdtgCwIBIBvoyADhI=
X-Google-Smtp-Source: ABdhPJz+Dw201n1JPJiutp4x3z4r2iBax1erYjOIGVo1QkO4zmHtM6tAyxUy/5lRocphAuV+B+oD+A==
X-Received: by 2002:a17:90a:3fc4:: with SMTP id u4mr7908098pjm.127.1633641591072;
        Thu, 07 Oct 2021 14:19:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 18/46] scsi: cxlflash: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:24 -0700
Message-Id: <20211007211852.256007-19-bvanassche@acm.org>
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
 drivers/scsi/cxlflash/main.c | 54 ++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b2730e859df8..c11ed8f1fc71 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3103,20 +3103,29 @@ static DEVICE_ATTR_RW(irqpoll_weight);
 static DEVICE_ATTR_RW(num_hwqs);
 static DEVICE_ATTR_RW(hwq_mode);
 
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_port2,
-	&dev_attr_port3,
-	&dev_attr_lun_mode,
-	&dev_attr_ioctl_version,
-	&dev_attr_port0_lun_table,
-	&dev_attr_port1_lun_table,
-	&dev_attr_port2_lun_table,
-	&dev_attr_port3_lun_table,
-	&dev_attr_irqpoll_weight,
-	&dev_attr_num_hwqs,
-	&dev_attr_hwq_mode,
+static struct attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0.attr,
+	&dev_attr_port1.attr,
+	&dev_attr_port2.attr,
+	&dev_attr_port3.attr,
+	&dev_attr_lun_mode.attr,
+	&dev_attr_ioctl_version.attr,
+	&dev_attr_port0_lun_table.attr,
+	&dev_attr_port1_lun_table.attr,
+	&dev_attr_port2_lun_table.attr,
+	&dev_attr_port3_lun_table.attr,
+	&dev_attr_irqpoll_weight.attr,
+	&dev_attr_num_hwqs.attr,
+	&dev_attr_hwq_mode.attr,
+	NULL
+};
+
+static const struct attribute_group cxlflash_host_attr_group = {
+	.attrs = cxlflash_host_attrs
+};
+
+static const struct attribute_group *cxlflash_host_attr_groups[] = {
+	&cxlflash_host_attr_group,
 	NULL
 };
 
@@ -3125,8 +3134,17 @@ static struct device_attribute *cxlflash_host_attrs[] = {
  */
 static DEVICE_ATTR_RO(mode);
 
-static struct device_attribute *cxlflash_dev_attrs[] = {
-	&dev_attr_mode,
+static struct attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode.attr,
+	NULL
+};
+
+static const struct attribute_group cxlflash_dev_attr_group = {
+	.attrs = cxlflash_dev_attrs
+};
+
+static const struct attribute_group *cxlflash_dev_attr_groups[] = {
+	&cxlflash_dev_attr_group,
 	NULL
 };
 
@@ -3150,8 +3168,8 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = 1,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
-	.shost_attrs = cxlflash_host_attrs,
-	.sdev_attrs = cxlflash_dev_attrs,
+	.shost_groups = cxlflash_host_attr_groups,
+	.sdev_groups = cxlflash_dev_attr_groups,
 };
 
 /*
