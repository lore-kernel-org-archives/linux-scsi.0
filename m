Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0465C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C330461139
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbhJGVWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:16 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:39769 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhJGVWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:11 -0400
Received: by mail-pj1-f42.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso7433206pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1F7m2PlYrZRX9+kpVb/8z03qDjC0pd4g/2ZCvZjyRQ=;
        b=Um50+o51rQ+k6axfzjy5cgpleWDTIZ5vMLGCCccxd7xaodxdXHIBIKLsAWhuENDfa2
         J/tBwfKdBBtPShk0ltf4Rsn8aMvzqNVGctpg2SxrMz17z6BviiL60xD2r06oJ4FP/Yx0
         U8dcWFu2c83cWID1OkbeWCXqJsA//KaDffvkH4Szv0GEvDZB7X8nk2AGMxJMNzpNVuYg
         8B9M3jKsVSpS6u31nGgvVea4RvTFua6Wd7hxu56biYyWAwPB+6nilETBPh6yZvctLMQI
         vfzDhLSrFONiHXff2yTCjRpIIyj729mxJ2ERBeI3GNFsU1+ECjH1hZ5RQvT7wCHOMNN0
         wlPg==
X-Gm-Message-State: AOAM530sRFm3J2n160582PB0He81zcm++MojSMXhYq5Nn1VUztFaut0g
        GmId3XMm7U0Tlfx8q1emRms=
X-Google-Smtp-Source: ABdhPJwHsN3eAh8g3fTsussLtl1S5x1tNTSp8iXfoMKFdFs8wRb+We90ZlhS9NerWYokTUW3sMW0vQ==
X-Received: by 2002:a17:90a:d48c:: with SMTP id s12mr8076971pju.145.1633641616842;
        Thu, 07 Oct 2021 14:20:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 31/46] scsi: myrb: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:37 -0700
Message-Id: <20211007211852.256007-32-bvanassche@acm.org>
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
 drivers/scsi/myrb.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e020..0b9bd540db3b 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2182,22 +2182,40 @@ static ssize_t flush_cache_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(flush_cache);
 
-static struct device_attribute *myrb_sdev_attrs[] = {
-	&dev_attr_rebuild,
-	&dev_attr_consistency_check,
-	&dev_attr_raid_state,
-	&dev_attr_raid_level,
+static struct attribute *myrb_sdev_attrs[] = {
+	&dev_attr_rebuild.attr,
+	&dev_attr_consistency_check.attr,
+	&dev_attr_raid_state.attr,
+	&dev_attr_raid_level.attr,
 	NULL,
 };
 
-static struct device_attribute *myrb_shost_attrs[] = {
-	&dev_attr_ctlr_num,
-	&dev_attr_model,
-	&dev_attr_firmware,
-	&dev_attr_flush_cache,
+static const struct attribute_group myrb_sdev_attr_group = {
+	.attrs = myrb_sdev_attrs
+};
+
+static const struct attribute_group *myrb_sdev_attr_groups[] = {
+	&myrb_sdev_attr_group,
+	NULL
+};
+
+static struct attribute *myrb_shost_attrs[] = {
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_model.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_flush_cache.attr,
 	NULL,
 };
 
+static const struct attribute_group myrb_shost_attr_group = {
+	.attrs = myrb_shost_attrs
+};
+
+static const struct attribute_group *myrb_shost_groups[] = {
+	&myrb_shost_attr_group,
+	NULL
+};
+
 static struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
@@ -2209,8 +2227,8 @@ static struct scsi_host_template myrb_template = {
 	.slave_destroy		= myrb_slave_destroy,
 	.bios_param		= myrb_biosparam,
 	.cmd_size		= sizeof(struct myrb_cmdblk),
-	.shost_attrs		= myrb_shost_attrs,
-	.sdev_attrs		= myrb_sdev_attrs,
+	.shost_groups		= myrb_shost_groups,
+	.sdev_groups		= myrb_sdev_attr_groups,
 	.this_id		= -1,
 };
 
