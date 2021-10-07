Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6209C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC1F61077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhJGVW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:26 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:33762 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbhJGVWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:25 -0400
Received: by mail-pf1-f176.google.com with SMTP id s16so6464590pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o69cnK/U/335PRQimSnXYVHJgfg3vwULDtpD2oVWF7Y=;
        b=rKsYKvC8dCdboLAGy4SpUtJWD4eERPiojiLBImHJMk/7hxsMQ/Xscd2tCXV8PKIDxe
         OU/xMze4UnbBen6Fgc7x54376KPH8mxPznksm19USq/H/OHbuCI02gzeVowSROB9zGW/
         Ejn8ryoW5IUUh3EAUMB3/onqkiaoA++N2yUCR91q1d5Bcyq8O1VNqrANpjwCxlKmLiYT
         ZA1XIkAtGEV2kwLPecmSNqQWrj+B+Q04VyPVaRc7i5kYHN4ym+UoV7INtlXlN851Mg5r
         /t1DpnMp1iiKcKDTN1gDK9kUWm0fpuxUL+/BaXt+QvVAZmzS/hVHNUjxX3Pm5/YKmLOA
         1huQ==
X-Gm-Message-State: AOAM533u/ngH4bEvYT9hy+vhLx9o7qu51tUFvJLDEiiKn9Ec8luKZG3Z
        wcMx50+WaVecsDXM6xpLXwY=
X-Google-Smtp-Source: ABdhPJxE6gtA4k5ZKFfXe/2kMPFMbKMl4VeUpf4avi9A5GgXxUxBE3gQVQNoEqpOW1v8KNbdGHBvRQ==
X-Received: by 2002:a62:7a4f:0:b0:448:6a41:14bb with SMTP id v76-20020a627a4f000000b004486a4114bbmr6598015pfc.31.1633641631145;
        Thu, 07 Oct 2021 14:20:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 37/46] scsi: qedf: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:43 -0700
Message-Id: <20211007211852.256007-38-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf.h      |  2 +-
 drivers/scsi/qedf/qedf_attr.c | 15 ++++++++++++---
 drivers/scsi/qedf/qedf_main.c |  2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ba94413fe2ea..44d2058a4d78 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -498,7 +498,7 @@ extern void qedf_process_abts_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 extern struct qedf_ioreq *qedf_alloc_cmd(struct qedf_rport *fcport,
 	u8 cmd_type);
 
-extern struct device_attribute *qedf_host_attrs[];
+extern const struct attribute_group *qedf_host_attr_groups[];
 extern void qedf_cmd_timer_set(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	unsigned int timer_msec);
 extern int qedf_init_mp_req(struct qedf_ioreq *io_req);
diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 461c0c9180c4..8f04e11d0903 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -60,12 +60,21 @@ static ssize_t fka_period_show(struct device *dev,
 static DEVICE_ATTR_RO(fcoe_mac);
 static DEVICE_ATTR_RO(fka_period);
 
-struct device_attribute *qedf_host_attrs[] = {
-	&dev_attr_fcoe_mac,
-	&dev_attr_fka_period,
+static struct attribute *qedf_host_attrs[] = {
+	&dev_attr_fcoe_mac.attr,
+	&dev_attr_fka_period.attr,
 	NULL,
 };
 
+static const struct attribute_group qedf_host_attr_group = {
+	.attrs = qedf_host_attrs
+};
+
+const struct attribute_group *qedf_host_attr_groups[] = {
+	&qedf_host_attr_group,
+	NULL
+};
+
 extern const struct qed_fcoe_ops *qed_ops;
 
 void qedf_capture_grc_dump(struct qedf_ctx *qedf)
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 42d0d941dba5..3dd60acea4d8 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -986,7 +986,7 @@ static struct scsi_host_template qedf_host_template = {
 	.cmd_per_lun	= 32,
 	.max_sectors 	= 0xffff,
 	.queuecommand 	= qedf_queuecommand,
-	.shost_attrs	= qedf_host_attrs,
+	.shost_groups	= qedf_host_attr_groups,
 	.eh_abort_handler	= qedf_eh_abort,
 	.eh_device_reset_handler = qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = qedf_eh_target_reset, /* target reset */
