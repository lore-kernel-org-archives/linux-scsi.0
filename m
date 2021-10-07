Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B22C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D01610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbhJGVWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:15 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:36787 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhJGVWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:12 -0400
Received: by mail-pg1-f174.google.com with SMTP id 75so1048147pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEFBvcbaPpVGNTliLb3FLEV71WXDnWSku/Og5SVOWmU=;
        b=7NlnUYQdcj2lQtuCV3gT9uugUtKojamTUjxtbrq3ZMZ78eyXyOW/G5K19db8yM48GR
         p4MeY/5nWjDrd1w8SK0WNcpdf5IHYAL03THuVilbxLtRQ2X9MwpVhY5Z9Hs4GlCSvUW/
         mLJ1Q8rTwy5EkWV6WqfnNCBw8YZLizKr1Rur3qayy3gnPYYME3nYLUb7HvCUjYn7YcL3
         eVvdbrZJPDAxMxGin54LTnEsw4eCWZNBiUJCMm4bA5w+ywTbpixkTL7pxTn9ya7rMMoy
         dBukuEpGI35wAhTp2/4kbtXwaFlj69ywWdicLhHDIV6dhM7m7r9QnyG4pGOzfgiI+ULR
         CJew==
X-Gm-Message-State: AOAM531ElipD0VFiFfnIBFiR2DFq0jXe75PJs7TeC5/hd7k8ldjg3N80
        S95oTZvygpB8crZ+ZHS9GEs=
X-Google-Smtp-Source: ABdhPJy90AUuvcOaeDZGLyhaSFUes1vkIDJMjolKraUZ9CMF+ZkZ4HSF6uZlDmqyJ2EQYUsTo0BJlA==
X-Received: by 2002:a05:6a00:188b:b0:44c:70a8:cf4 with SMTP id x11-20020a056a00188b00b0044c70a80cf4mr6262822pfh.85.1633641618318;
        Thu, 07 Oct 2021 14:20:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 32/46] scsi: myrs: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:38 -0700
Message-Id: <20211007211852.256007-33-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 54 ++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..c4a897939729 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1286,14 +1286,23 @@ static ssize_t consistency_check_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(consistency_check);
 
-static struct device_attribute *myrs_sdev_attrs[] = {
-	&dev_attr_consistency_check,
-	&dev_attr_rebuild,
-	&dev_attr_raid_state,
-	&dev_attr_raid_level,
+static struct attribute *myrs_sdev_attrs[] = {
+	&dev_attr_consistency_check.attr,
+	&dev_attr_rebuild.attr,
+	&dev_attr_raid_state.attr,
+	&dev_attr_raid_level.attr,
 	NULL,
 };
 
+static const struct attribute_group myrs_sdev_attr_group = {
+	.attrs = myrs_sdev_attrs
+};
+
+static const struct attribute_group *myrs_sdev_attr_groups[] = {
+	&myrs_sdev_attr_group,
+	NULL
+};
+
 static ssize_t serial_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1510,20 +1519,29 @@ static ssize_t disable_enclosure_messages_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(disable_enclosure_messages);
 
-static struct device_attribute *myrs_shost_attrs[] = {
-	&dev_attr_serial,
-	&dev_attr_ctlr_num,
-	&dev_attr_processor,
-	&dev_attr_model,
-	&dev_attr_ctlr_type,
-	&dev_attr_cache_size,
-	&dev_attr_firmware,
-	&dev_attr_discovery,
-	&dev_attr_flush_cache,
-	&dev_attr_disable_enclosure_messages,
+static struct attribute *myrs_shost_attrs[] = {
+	&dev_attr_serial.attr,
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_processor.attr,
+	&dev_attr_model.attr,
+	&dev_attr_ctlr_type.attr,
+	&dev_attr_cache_size.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_discovery.attr,
+	&dev_attr_flush_cache.attr,
+	&dev_attr_disable_enclosure_messages.attr,
 	NULL,
 };
 
+static const struct attribute_group myrs_shost_attr_group = {
+	.attrs = myrs_shost_attrs
+};
+
+static const struct attribute_group *myrs_shost_groups[] = {
+	&myrs_shost_attr_group,
+	NULL
+};
+
 /*
  * SCSI midlayer interface
  */
@@ -1923,8 +1941,8 @@ static struct scsi_host_template myrs_template = {
 	.slave_configure	= myrs_slave_configure,
 	.slave_destroy		= myrs_slave_destroy,
 	.cmd_size		= sizeof(struct myrs_cmdblk),
-	.shost_attrs		= myrs_shost_attrs,
-	.sdev_attrs		= myrs_sdev_attrs,
+	.shost_groups		= myrs_shost_groups,
+	.sdev_groups		= myrs_sdev_attr_groups,
 	.this_id		= -1,
 };
 
