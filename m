Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3CAC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C870060ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhJLXi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:27 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40689 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbhJLXiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:23 -0400
Received: by mail-pl1-f175.google.com with SMTP id v20so568016plo.7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bke2QLpps6GpzDcXZNnBKyGGpzVgxKxfRpS6Pp+DtoM=;
        b=X9UutX1g8+wRrM8B2MWcTteJ1PF8gB7u3s3z+wk0isGYLaYdBZPIpM/ktOu9qhA0m5
         o42ocCRR+Pnf7VN3/GMNa5Q6WTIZZyQKn+inoQE8WaSpKsIr+0WSfrO/HscdAlKF4o/d
         r8jaLQOPK+3gyjkbLRlVDsAPG4HioGkYniowsEpdUmzfpEHuKF0CjNsCH/+rmpd2H4fL
         HhkemNg1ro42a8tokWJ4GrOqNQN3JF8jznWFWsEPvMm4Fjj5QJB3+bmOxIMUX1H7P3gL
         xhGegQm5BoOJY+rZANPRWOuiOgbKgy2gM4sitVPFu/n6bCPJ7FU7GS3Yl8ymZli1VNFW
         sBPg==
X-Gm-Message-State: AOAM531SrCokhhuFBEX73Y5Gc3t4Q5FrW1TN+I1Zzb5ghiHaeTGPQun8
        oIBpATK6dhBkSRDlSY8OnU5ZcPb84xo=
X-Google-Smtp-Source: ABdhPJzdqroWBqW31LUGQLrXEa3DE/JUPt9zQYV8089iLhIFyYopSYJ6+KxY/hqW1LErYdCsc98Vqg==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr9442503pjb.186.1634081781010;
        Tue, 12 Oct 2021 16:36:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 10/46] scsi: 53c700: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:22 -0700
Message-Id: <20211012233558.4066756-11-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..931f9d44e83c 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -163,7 +163,7 @@ STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
-STATIC struct device_attribute *NCR_700_dev_attrs[];
+STATIC const struct attribute_group *NCR_700_dev_groups[];
 
 STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
 
@@ -300,8 +300,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	static int banner = 0;
 	int j;
 
-	if(tpnt->sdev_attrs == NULL)
-		tpnt->sdev_attrs = NCR_700_dev_attrs;
+	if (tpnt->sdev_groups == NULL)
+		tpnt->sdev_groups = NCR_700_dev_groups;
 
 	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
 	if (!memory) {
@@ -2087,11 +2087,13 @@ static struct device_attribute NCR_700_active_tags_attr = {
 	.show = NCR_700_show_active_tags,
 };
 
-STATIC struct device_attribute *NCR_700_dev_attrs[] = {
-	&NCR_700_active_tags_attr,
+STATIC struct attribute *NCR_700_dev_attrs[] = {
+	&NCR_700_active_tags_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(NCR_700_dev);
+
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
