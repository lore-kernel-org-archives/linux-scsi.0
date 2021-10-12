Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A951CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965C960E54
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhJLXjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:10 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:43614 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbhJLXjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:09 -0400
Received: by mail-pf1-f174.google.com with SMTP id 187so821249pfc.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EUe+T7BRbW2HGNCh4VxgcEN8rcNEKp+5yJ/I85ScS7k=;
        b=GpqkwCZ8pwh1Quz1DtPN9ua6iRX5znMeiVKugLWvoSq0IBme4ZVWSMackUtBj7pf0u
         3VSUGY1RQjqYG96VoI8ffa8NmAKU5E1z0NO9OTz/3mmJ1GGg1j+mM7JdLsa3H7LAM7CE
         8l+J7qExeMMDL7FSH/1/48+bSIZssXWlANyhu2d6+RRfsH102ecwgsrBvg8EvP32fe98
         NajUhi8wI7LJmavhcApq4HItA+2iTvVvRKcXKVjHBLRbGAWDyKXIaBgQIZdaPdNa/VZm
         w8FeimFPCnSnY0VMAhlnKGKAMiYVPlKiF2VMaP1dpeLQgDcVjSt9aQFKDslKnmkPN3pZ
         7z2w==
X-Gm-Message-State: AOAM532kzD+DTMeofkTdPnF1sJEv5DLGAlfKX6mLuHj4qo0eXysMVdW5
        6tKrIB9zw4QhGlm/2qd1V5BsfgmDLEjNNQ==
X-Google-Smtp-Source: ABdhPJzJl8cTw5Yu9ln3IHKFfGmFc7Eb7uV1PQiIMN0Ev7Xoc/Wz3aCK8FL34LprEpKiA7x5/pwLag==
X-Received: by 2002:a05:6a00:1242:b0:44c:2025:29e3 with SMTP id u2-20020a056a00124200b0044c202529e3mr34460755pfi.59.1634081827007;
        Tue, 12 Oct 2021 16:37:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 32/46] scsi: myrs: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:44 -0700
Message-Id: <20211012233558.4066756-33-bvanassche@acm.org>
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
 
