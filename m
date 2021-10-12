Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB0EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2F9060E54
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhJLXjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:10 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38699 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbhJLXjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:08 -0400
Received: by mail-pl1-f174.google.com with SMTP id x4so576168pln.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24FcnP76JVFRjuZBpToKuYhGMB1lsEL0njGDm4SiUBM=;
        b=QBH2qFwvxFlfbvPXm/C3+u2ipkY3pGBNOCdvLKLT9lBduUwEvolSES5s8m7+/deMEN
         ZyhsLGQBBFXqAnxAt/GJtn0on9MM+Y/5ShYrZHY8dwBtum/i0m3Ia44BXLVyuvDl5J4+
         Oc4nXr+/w4rnRVtGS4cDFb/WS7kWxcgV1s7Q8Bp2tjQZlEA6u6N4MdyhV3Uoo4emAAmz
         sKImqsrnQkcz5NipYwDxrRXXMAjMXFqriuxwn6gannC43i3Cm6kHeZ7TzSbuO0hGYmx0
         NS85q24HRdb2fS5evs71a4seOpB5ZSRovSaSheXrdIuJeZ8zLCxTdbafT2H21Cbr1MGb
         CDEA==
X-Gm-Message-State: AOAM533UAtFcNildjEU4SdZMYzjtXxzZbTsrJTIjJzJ6efsQcQohgmZ3
        J+YOJjO65v+KwkW6AbP8/BI=
X-Google-Smtp-Source: ABdhPJyxv7RCoq0RJqGQNrTQ2ZkVe/R+RP57iI7Q7eJrAXAnPYmh3FLslolUOi6aGVUIuI/EXXX0lQ==
X-Received: by 2002:a17:903:234d:b0:13f:3180:626a with SMTP id c13-20020a170903234d00b0013f3180626amr15769717plh.49.1634081825691;
        Tue, 12 Oct 2021 16:37:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 31/46] scsi: myrb: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:43 -0700
Message-Id: <20211012233558.4066756-32-bvanassche@acm.org>
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
 
