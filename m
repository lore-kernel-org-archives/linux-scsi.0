Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564FAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FAD360F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhJLXiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:52 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:34785 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbhJLXit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:49 -0400
Received: by mail-pj1-f49.google.com with SMTP id ns7-20020a17090b250700b001a0937b87b7so2616277pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7fS3vfVjSUAQtncOlTU0F2ED99R9H0HV+z+Q4ZYAT9k=;
        b=LnHKvxBKfsy1NdJJLi5o+x1hjQHcQXicCJeWfPFKGjCJrG8zZXVFL6L+sW9tKJVXuv
         B+7LjBKEyCxlRNuXmXap7KygT4sRqR+3Q6hwejFpxkmX8Eb/eT2TsvGCXkK9ZZmFG6wM
         zlWRbsj1xT5kx0HyYHkikRMinGnLZB+XjM6Fc91CRktWQKGnei/DmrEfGA+QPXzXziKC
         w33ybMsu8TKZtIt4SKuNOexs0tx9pewDDaaxkqSfmIByBDyO+wjEHUxwisrOeINA42ts
         VwI0yjJDAPZWpMv5qFp0nBpmfO4v0MPUcFiQxUBER2NZ1i4mBA+nY+0jBT3Pp7UIN7pi
         kDjg==
X-Gm-Message-State: AOAM530P/uUuKbRqqZltC+tDmWmswiVhkVNmXFx5vlpWzcrzLaiRamD6
        JMOuvlokWS3O4/i/P5Myx1Y=
X-Google-Smtp-Source: ABdhPJzIzdUvv0lHt//8hoBPzV9AMix3RpeQg/cxfv07MUs3f/jrcFRyjvJv5JCjrCm5v5jbjNi3yg==
X-Received: by 2002:a17:90b:1d0d:: with SMTP id on13mr9560017pjb.118.1634081807090;
        Tue, 12 Oct 2021 16:36:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 20/46] scsi: hisi_sas: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:32 -0700
Message-Id: <20211012233558.4066756-21-bvanassche@acm.org>
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
