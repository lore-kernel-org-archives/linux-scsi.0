Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3A8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005596112D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbhJHU1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:06 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:33475 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbhJHU1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:00 -0400
Received: by mail-pl1-f178.google.com with SMTP id a11so6925186plm.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EUe+T7BRbW2HGNCh4VxgcEN8rcNEKp+5yJ/I85ScS7k=;
        b=g0xV3d4ZeAxa23BNSByyckCzgyxQuJ51M2PkxD8DO2WxgLhW5fJckCgV5+cjqwIbd0
         AQ2KjKkeuEAp2JRuqhQ4fMGP9kXpjHNChDa2J/MXbAPxCxOvxYgPFOPn4/9X+BL/d7PE
         Em199sEYgX6/KmJxnE0BIlSccNrDDON4hnxmkNy4gL6n2H4nLFwHtzHzCImh41ovfvDq
         4rK3xz1V2+RzAB0Ed00fkBxP+Y8/xX2Xa/5GVIKHYyEwoJCaVK6By7lXRS9SSxho7qjq
         Jff6BjblFs+IAzU6KO8PCKeflzQyf7Erqhb34v7QdIKtXc3DCCLxJ0DTsXF7tANADY3U
         hnjw==
X-Gm-Message-State: AOAM5325DIZMW4B6MfIonxkq5vxQaZvxM671eSbWvAGqn2sF9AedqXu6
        4bOALnIhKTCOxFOWTJU3LL4=
X-Google-Smtp-Source: ABdhPJyj6mXZrWqeTBCR4+7PWPcVYhWrh+CPFLw/Q7qoTtueizHpkkUM2YYjZBQ96lgB03P74Bjk2w==
X-Received: by 2002:a17:903:230e:b0:13f:5f6:3722 with SMTP id d14-20020a170903230e00b0013f05f63722mr11006291plh.84.1633724704425;
        Fri, 08 Oct 2021 13:25:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 32/46] scsi: myrs: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:39 -0700
Message-Id: <20211008202353.1448570-33-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..ca42f7f6244b 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1286,14 +1286,16 @@ static ssize_t consistency_check_store(struct device *dev,
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
 
+ATTRIBUTE_GROUPS(myrs_sdev);
+
 static ssize_t serial_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1510,20 +1512,22 @@ static ssize_t disable_enclosure_messages_store(struct device *dev,
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
 
+ATTRIBUTE_GROUPS(myrs_shost);
+
 /*
  * SCSI midlayer interface
  */
@@ -1923,8 +1927,8 @@ static struct scsi_host_template myrs_template = {
 	.slave_configure	= myrs_slave_configure,
 	.slave_destroy		= myrs_slave_destroy,
 	.cmd_size		= sizeof(struct myrs_cmdblk),
-	.shost_attrs		= myrs_shost_attrs,
-	.sdev_attrs		= myrs_sdev_attrs,
+	.shost_groups		= myrs_shost_groups,
+	.sdev_groups		= myrs_sdev_groups,
 	.this_id		= -1,
 };
 
