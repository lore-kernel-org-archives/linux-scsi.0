Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B047C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45023610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhJHU1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:05 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:51789 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbhJHU06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:58 -0400
Received: by mail-pj1-f46.google.com with SMTP id kk10so8444684pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24FcnP76JVFRjuZBpToKuYhGMB1lsEL0njGDm4SiUBM=;
        b=GZhXTP8u8Qzx9+sFwzzgnTsJMK2zDdEvfY3T8rFcqRqRr52826vva+DtlNe1em4BQ5
         x+uHbGnF6gMEdlpiqnPTkTQVJVNF18X/Zfk4+ICG7U4sPHI8tYePyF2a7455iWXZlgYT
         xINk0lIla+dx6SQIwg74USilWeGu7AD7w1vE8HCasYDaNapAUfAGclGeebjECojULWa9
         f//dP5KQWUh9HYV9rhsmiZoCRDrdDokymI4RWecv4p0sm6pa5R8jegxq9CVBO6a2QBMu
         N+OcSRFT1sCg0wYUdiSmFWaDjAqtpmudA5izMbdC1pxCEfLxndOwY4f5yH2ND1In9b/T
         a0tA==
X-Gm-Message-State: AOAM531FY4ZK4IqJq6rJEwB3ENT8uUs10ukO+KWasur7rdO1ToB9b20+
        xzz2TzzPEB1Uijb+/1TI3mod9KGp78u91A==
X-Google-Smtp-Source: ABdhPJzWOSWZDGw0CGMhjdVuIAqnjEh1MIR1D0aK0NZ94aClAB+h9RY3zudfGykk+zhWdWc8GWXaaQ==
X-Received: by 2002:a17:903:234f:b0:13e:e6e1:c132 with SMTP id c15-20020a170903234f00b0013ee6e1c132mr11529391plh.57.1633724703025;
        Fri, 08 Oct 2021 13:25:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 31/46] scsi: myrb: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:38 -0700
Message-Id: <20211008202353.1448570-32-bvanassche@acm.org>
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
 drivers/scsi/myrb.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e020..72441c014f92 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2182,22 +2182,26 @@ static ssize_t flush_cache_store(struct device *dev,
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
+ATTRIBUTE_GROUPS(myrb_sdev);
+
+static struct attribute *myrb_shost_attrs[] = {
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_model.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_flush_cache.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(myrb_shost);
+
 static struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
@@ -2209,8 +2213,8 @@ static struct scsi_host_template myrb_template = {
 	.slave_destroy		= myrb_slave_destroy,
 	.bios_param		= myrb_biosparam,
 	.cmd_size		= sizeof(struct myrb_cmdblk),
-	.shost_attrs		= myrb_shost_attrs,
-	.sdev_attrs		= myrb_sdev_attrs,
+	.shost_groups		= myrb_shost_groups,
+	.sdev_groups		= myrb_sdev_groups,
 	.this_id		= -1,
 };
 
