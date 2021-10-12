Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C78C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C305D60F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhJLXiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:50 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36698 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhJLXiq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:46 -0400
Received: by mail-pj1-f45.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so3053018pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0c+nV8p2rT/HmjUOeDz34YoCK9/gAs2RcO0O3Za1pc=;
        b=D14BSfOPLHeYLObBKhR5ND0FvkBV7Nxnoo1tk68aL5AKXV9UJ/YO/1YrIKK3uStNf4
         EdQ/97CzfocXywfMkifTL+O3NVgUXsuN7nKXxzu5tPUbK9caylVlTHQf1UomVt7GP+je
         gDweDftrlV54EtyD9RiBkhCOqOALSJ6SP7LczD2JZ7jqK2oYN9KJHk3FxJB9h70BJxKF
         AP9Kb3VRWBrNdh9N7oh47v4e6WS6jGm0dNV6+/SsTdArbc2es85FwwD8aK3bJyLaUt0a
         LjauFH8/qBQe4FeVg78rdv4wnynUft/PkLIvBP6VP5US5yBu1fF4iO8wgRpoAsqHlzzB
         hBIg==
X-Gm-Message-State: AOAM5306r6Ag7tn+bzS7QY1dXs+epdeYJqCiAqmb1hLU2hRPrrli6swU
        dcn+jzcDegPpn37+8/yX8S9pY+WGvH9B7w==
X-Google-Smtp-Source: ABdhPJxXUM33reuR7l7g+CMp8DdKrEVgodZUAL6NFimQjOTJoNeF/PFVbP1CZyCWC8aZcB4vguoejA==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr9199299pjq.64.1634081804122;
        Tue, 12 Oct 2021 16:36:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 18/46] scsi: cxlflash: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:30 -0700
Message-Id: <20211012233558.4066756-19-bvanassche@acm.org>
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
 drivers/scsi/cxlflash/main.c | 40 ++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b2730e859df8..0c806dc95e89 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3103,33 +3103,37 @@ static DEVICE_ATTR_RW(irqpoll_weight);
 static DEVICE_ATTR_RW(num_hwqs);
 static DEVICE_ATTR_RW(hwq_mode);
 
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_port2,
-	&dev_attr_port3,
-	&dev_attr_lun_mode,
-	&dev_attr_ioctl_version,
-	&dev_attr_port0_lun_table,
-	&dev_attr_port1_lun_table,
-	&dev_attr_port2_lun_table,
-	&dev_attr_port3_lun_table,
-	&dev_attr_irqpoll_weight,
-	&dev_attr_num_hwqs,
-	&dev_attr_hwq_mode,
+static struct attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0.attr,
+	&dev_attr_port1.attr,
+	&dev_attr_port2.attr,
+	&dev_attr_port3.attr,
+	&dev_attr_lun_mode.attr,
+	&dev_attr_ioctl_version.attr,
+	&dev_attr_port0_lun_table.attr,
+	&dev_attr_port1_lun_table.attr,
+	&dev_attr_port2_lun_table.attr,
+	&dev_attr_port3_lun_table.attr,
+	&dev_attr_irqpoll_weight.attr,
+	&dev_attr_num_hwqs.attr,
+	&dev_attr_hwq_mode.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(cxlflash_host);
+
 /*
  * Device attributes
  */
 static DEVICE_ATTR_RO(mode);
 
-static struct device_attribute *cxlflash_dev_attrs[] = {
-	&dev_attr_mode,
+static struct attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(cxlflash_dev);
+
 /*
  * Host template
  */
@@ -3150,8 +3154,8 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = 1,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
-	.shost_attrs = cxlflash_host_attrs,
-	.sdev_attrs = cxlflash_dev_attrs,
+	.shost_groups = cxlflash_host_groups,
+	.sdev_groups = cxlflash_dev_groups,
 };
 
 /*
