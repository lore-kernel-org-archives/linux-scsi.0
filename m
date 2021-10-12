Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B37C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A44860EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhJLXiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:14 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:33461 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbhJLXiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:13 -0400
Received: by mail-pl1-f182.google.com with SMTP id y4so609870plb.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mdX3hkvfoYoF2fIUrn8m6GML1XzKXIEX378yasu53k=;
        b=GxD5SZTbT5cm1Kw/TB2TyO5XX8Hwni+Jn19OglsIPGlI7+Ht6hSF6rL0ZlPLMHL+CB
         kfYBJaG18YSOmIUfIkZ+l03NOyJPpN3qO7YlBFBOa3tgv7dlzD74kbK6A/MYwCDmmBCc
         1hBkpZSN/L0TPYZER9bDUYXhnlk48duw8WeTA8U5tmTHpNH6lgGZBh+fogiHhbxReitg
         8eMd6tVaR0Ca/JeSFFFmYIvspOa2A0HP6sFwZjhVO2BVjWZChg2rhfjLtZyfz3ZiWeZP
         RmsBMFASvH2fCK8I9ZO2zC5Fuq4IRBhvdC1w2lYOWTEp7WfhdJkFenEnO/lXyZbxFTU6
         wLPw==
X-Gm-Message-State: AOAM530ONkUzEeNy1h+uZ8s2L/TrKVA0ovvqfZwDCvJD/j8RSAgL+FxO
        UCI9YS4LZ7e8SYBDSfD6Y5Q=
X-Google-Smtp-Source: ABdhPJxMs9SWoVt16ygBy+ysz4ukgn+ArJN3aL4VWcFA0VUA5IC3MyQooN+EOwme2GMepcd1rez5YA==
X-Received: by 2002:a17:90b:4d8e:: with SMTP id oj14mr742963pjb.237.1634081771123;
        Tue, 12 Oct 2021 16:36:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v4 03/46] firewire: sbp2: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:15 -0700
Message-Id: <20211012233558.4066756-4-bvanassche@acm.org>
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
 drivers/firewire/sbp2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..c2a9d7d0bd1e 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1578,11 +1578,13 @@ static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);
 
-static struct device_attribute *sbp2_scsi_sysfs_attrs[] = {
-	&dev_attr_ieee1394_id,
+static struct attribute *sbp2_scsi_sysfs_attrs[] = {
+	&dev_attr_ieee1394_id.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(sbp2_scsi_sysfs);
+
 static struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
@@ -1595,7 +1597,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.max_segment_size	= SBP2_MAX_SEG_SIZE,
 	.can_queue		= 1,
-	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.sdev_groups		= sbp2_scsi_sysfs_groups,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
