Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5508C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0025610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhJGVVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:51 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:46640 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239126AbhJGVVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:48 -0400
Received: by mail-pg1-f182.google.com with SMTP id m21so1011100pgu.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGduMXnje8FAaWgDWJU39ddNp/YosmjrCwwkM76yp3k=;
        b=NC5RkKfSiNxzDPpxglx1O/uChbL5xNXAXDRHgTAcfpnoC4inPo4tB55rwNQ+43+fOx
         bBQQpqR4y5OjpdyzPCaRHFYI1xn3twIz6FTNLphNnBFsxcvYO3lcC59H8ojES9vcWgk2
         MwHBXUp+wgCP60YdLQ9Y4bDQz917pxXFnHyhp00WcjejDweD8dMLpzY/spnJfNK23nn4
         yID7A57rJJVWnWl84ArttwSEBrRV16KY8udgIjUlXpvzx9tEcKgIg7d86+FCKBOmtTSk
         sIdK4YBpB5ta5EcBLIyaXXZrBBkkJdCYShoXHgLk6jGIbzY9wjlP0JboYGFT0lpn+ajR
         Y3BQ==
X-Gm-Message-State: AOAM533BA/R9Dns6XszDtC1MyO/Z529a9RNOCJy6nyulMrODOt6IiVUq
        Eh+H1XKbUDYpaPVUqvw7t8w=
X-Google-Smtp-Source: ABdhPJyDfj9ud50B/uVjSwZE+/YnFJxJkXadNt2HwpyHn/WBNJlHLN4veACtknpbQXQ6TTOxgbY3gA==
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id b140-20020a621b92000000b003eb3f920724mr6631438pfb.3.1633641594578;
        Thu, 07 Oct 2021 14:19:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 20/46] scsi: hisi_sas: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:26 -0700
Message-Id: <20211007211852.256007-21-bvanassche@acm.org>
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
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 15 ++++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 15 ++++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 21 +++++++++++++++------
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 862f4e8b7eb5..95e2a6e3c105 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1749,8 +1749,17 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v1_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_attrs_v1_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
+	NULL
+};
+
+static const struct attribute_group host_attrs_v1_hw_group = {
+	.attrs = host_attrs_v1_hw
+};
+
+static const struct attribute_group *host_attrs_v1_hw_groups[] = {
+	&host_attrs_v1_hw_group,
 	NULL
 };
 
@@ -1777,7 +1786,7 @@ static struct scsi_host_template sht_v1_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v1_hw,
+	.shost_groups		= host_attrs_v1_hw_groups,
 	.host_reset             = hisi_sas_host_reset,
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 236cf65c2f97..26c2fa47b6ac 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3542,8 +3542,17 @@ static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 
 }
 
-static struct device_attribute *host_attrs_v2_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_attrs_v2_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
+	NULL
+};
+
+static const struct attribute_group host_attrs_v2_hw_group = {
+	.attrs = host_attrs_v2_hw
+};
+
+static const struct attribute_group *host_attrs_v2_hw_groups[] = {
+	&host_attrs_v2_hw_group,
 	NULL
 };
 
@@ -3590,7 +3599,7 @@ static struct scsi_host_template sht_v2_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v2_hw,
+	.shost_groups		= host_attrs_v2_hw_groups,
 	.host_reset		= hisi_sas_host_reset,
 	.map_queues		= map_queues_v2_hw,
 	.host_tagset		= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f4517f3eb922..ebd8d10112cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2771,11 +2771,20 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v3_hw[] = {
-	&dev_attr_phy_event_threshold,
-	&dev_attr_intr_conv_v3_hw,
-	&dev_attr_intr_coal_ticks_v3_hw,
-	&dev_attr_intr_coal_count_v3_hw,
+static struct attribute *host_attrs_v3_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
+	&dev_attr_intr_conv_v3_hw.attr,
+	&dev_attr_intr_coal_ticks_v3_hw.attr,
+	&dev_attr_intr_coal_count_v3_hw.attr,
+	NULL
+};
+
+static const struct attribute_group host_attrs_v3_hw_group = {
+	.attrs = host_attrs_v3_hw
+};
+
+static const struct attribute_group *host_attrs_v3_hw_groups[] = {
+	&host_attrs_v3_hw_group,
 	NULL
 };
 
@@ -3163,7 +3172,7 @@ static struct scsi_host_template sht_v3_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v3_hw,
+	.shost_groups		= host_attrs_v3_hw_groups,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
 	.host_tagset		= 1,
