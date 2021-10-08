Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3728C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5D261019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhJHU0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:40 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:36521 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242391AbhJHU0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:40 -0400
Received: by mail-pj1-f44.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so10167004pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7fS3vfVjSUAQtncOlTU0F2ED99R9H0HV+z+Q4ZYAT9k=;
        b=de42n7AtqHTiCWY4Fc/CpR73ZOjqjeFfmxHkqYn82xhV/w/BDzxON6/4JMT7uHUlxR
         zj9NBOGFQX31funCejQ0L4GXhzbc72C28LTTUeOnTz/ZQn3Zrc1ctu2TsTY2GyKyo9hD
         JmchJ/scCKybfD9Og/b9ZWoqO5KGlLF0Tl+1mLWjT6vGoSoLNBchof96dXdCg7yrXN5H
         BDXoycrpLn52gjDPqRys6Brebzp4eqKdF9Y6OhVtXPgPmLrI54xBS1X2MO72rIiKF/2q
         Bwvqg76kit7s9xUNM9TRD3HsGuIla2PghrvvnLlq+GC4o+vOWDbHb6ZUytGRPlHpRk1f
         Iz6g==
X-Gm-Message-State: AOAM532JD8Q6DwyhMsrrhXTq+dKFoCy7zFxSrtXYRb9C4W8rY+YT9OKr
        8LTX7kf0edS5YKx8ezqnbNn20fdfYCEGeg==
X-Google-Smtp-Source: ABdhPJwRlOYPTXvYaZa9SeLXyJF/e0M6yKPGXxe33JDDP5GazAdSdGsIOoWP1GPPGX0l22r/MRCv5g==
X-Received: by 2002:a17:902:bd03:b0:13d:f6d7:813e with SMTP id p3-20020a170902bd0300b0013df6d7813emr11227582pls.1.1633724684185;
        Fri, 08 Oct 2021 13:24:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 20/46] scsi: hisi_sas: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:27 -0700
Message-Id: <20211008202353.1448570-21-bvanassche@acm.org>
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
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  8 +++++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 +++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 862f4e8b7eb5..14a6065390ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1749,11 +1749,13 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v1_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_v1_hw_attrs[] = {
+	&dev_attr_phy_event_threshold.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(host_v1_hw);
+
 static struct scsi_host_template sht_v1_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
@@ -1777,7 +1779,7 @@ static struct scsi_host_template sht_v1_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v1_hw,
+	.shost_groups		= host_v1_hw_groups,
 	.host_reset             = hisi_sas_host_reset,
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 236cf65c2f97..2ad80171c957 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3542,11 +3542,13 @@ static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 
 }
 
-static struct device_attribute *host_attrs_v2_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_v2_hw_attrs[] = {
+	&dev_attr_phy_event_threshold.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(host_v2_hw);
+
 static int map_queues_v2_hw(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
@@ -3590,7 +3592,7 @@ static struct scsi_host_template sht_v2_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v2_hw,
+	.shost_groups		= host_v2_hw_groups,
 	.host_reset		= hisi_sas_host_reset,
 	.map_queues		= map_queues_v2_hw,
 	.host_tagset		= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f4517f3eb922..c84318869e8e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2771,14 +2771,16 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v3_hw[] = {
-	&dev_attr_phy_event_threshold,
-	&dev_attr_intr_conv_v3_hw,
-	&dev_attr_intr_coal_ticks_v3_hw,
-	&dev_attr_intr_coal_count_v3_hw,
+static struct attribute *host_v3_hw_attrs[] = {
+	&dev_attr_phy_event_threshold.attr,
+	&dev_attr_intr_conv_v3_hw.attr,
+	&dev_attr_intr_coal_ticks_v3_hw.attr,
+	&dev_attr_intr_coal_count_v3_hw.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(host_v3_hw);
+
 #define HISI_SAS_DEBUGFS_REG(x) {#x, x}
 
 struct hisi_sas_debugfs_reg_lu {
@@ -3163,7 +3165,7 @@ static struct scsi_host_template sht_v3_hw = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= host_attrs_v3_hw,
+	.shost_groups		= host_v3_hw_groups,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
 	.host_tagset		= 1,
