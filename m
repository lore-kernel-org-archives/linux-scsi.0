Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25241C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F498610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbhJGVW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:29 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41681 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbhJGVW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:27 -0400
Received: by mail-pg1-f172.google.com with SMTP id v11so1029062pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4R4gXLjjIZLIkF7sgikLLbh6/kop4jDlVkJ3In8wKi4=;
        b=BdBGzqEAJDeD5mBUrHlg/y1kHCHVM/F3Mx7x9ojJRNB1ote8YY8ehZ5oaL3ziNAcS1
         NzCoZbsXx655T99GGUJm1nwxvECEU9Bg8aDWC1xpmYFeC327vX0N9nZsZGePIw7R1xBn
         mSWZr/nAc8u2u590oElV+2js6qseBvBIeuO5sbDlaKUeWefAj6gSGT8DMYG1znBRjSWg
         HWYvVVjOdXr5HPEhOLu8x7z3IpACT2FM2abcLHtP8KUIg7JFMYRnQ/9gvnlCdBVGXUhM
         8kLNcPq8YatgGWlumrkd1AbPtFnU77fFT3Mq4m8V8fTKB7OIxi6CdpjSdmwmie+Jo/LR
         9gXw==
X-Gm-Message-State: AOAM532mwGbJzDu8KvxfKhOO7YBYOqtfv8CJJ41LEHvDrYE6C3kQqX9N
        xvznU7M0BfrxvfHnEbY4lRE=
X-Google-Smtp-Source: ABdhPJygH4GAu4J0n7b8pLdU1Pp6eABODuFVwUwhklumC4AqZGp2nZrR/O/ihW513Ag3/7hTaXN/ug==
X-Received: by 2002:a62:8284:0:b0:44c:6490:4a2d with SMTP id w126-20020a628284000000b0044c64904a2dmr6698366pfd.38.1633641632810;
        Thu, 07 Oct 2021 14:20:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 38/46] scsi: qedi: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:44 -0700
Message-Id: <20211007211852.256007-39-bvanassche@acm.org>
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
 drivers/scsi/qedi/qedi_gbl.h   |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 drivers/scsi/qedi/qedi_sysfs.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 9f8e8ef405a1..84e575fbd491 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -22,7 +22,7 @@ extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
 extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
 extern const struct file_operations qedi_dbg_fops[];
-extern struct device_attribute *qedi_shost_attrs[];
+extern const struct attribute_group *qedi_shost_attr_groups[];
 
 int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
 void qedi_free_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index c5260429c637..29b8e7a88653 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -58,7 +58,7 @@ struct scsi_host_template qedi_host_template = {
 	.max_sectors = 0xffff,
 	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
-	.shost_attrs = qedi_shost_attrs,
+	.shost_groups = qedi_shost_attr_groups,
 };
 
 static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qedi/qedi_sysfs.c b/drivers/scsi/qedi/qedi_sysfs.c
index be174d30eb7c..2ce8b3926e0a 100644
--- a/drivers/scsi/qedi/qedi_sysfs.c
+++ b/drivers/scsi/qedi/qedi_sysfs.c
@@ -42,8 +42,17 @@ static ssize_t speed_show(struct device *dev,
 static DEVICE_ATTR_RO(port_state);
 static DEVICE_ATTR_RO(speed);
 
-struct device_attribute *qedi_shost_attrs[] = {
-	&dev_attr_port_state,
-	&dev_attr_speed,
+static struct attribute *qedi_shost_attrs[] = {
+	&dev_attr_port_state.attr,
+	&dev_attr_speed.attr,
+	NULL
+};
+
+static const struct attribute_group qedi_shost_attr_group = {
+	.attrs = qedi_shost_attrs
+};
+
+const struct attribute_group *qedi_shost_attr_groups[] = {
+	&qedi_shost_attr_group,
 	NULL
 };
