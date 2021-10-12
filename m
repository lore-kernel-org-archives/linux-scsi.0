Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C9DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4AC460F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhJLXjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:22 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36722 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbhJLXjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:20 -0400
Received: by mail-pj1-f42.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so3053673pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ass/DDw+jAao+IjeSewlXwx/n01JkMuXZrSeajEp2NM=;
        b=4vhWAudC5g8uVi6hIomIehwFDhErSmWokinTsXh3dUWbriyECRKKgxMEP5JHc4SrKm
         vLRTjl4A5hHDKBsQzGBKGUXFw/8sLCGwXcsgvkEsxcNfnp2aVHNhfoCBoXoDMTssd94r
         XkBlzIkbM2DIOA7afP7AEwT59ZudBz0PcK21aIzfvTIFbgixZu5LTQB/tsMBpCU7LubW
         PnxnA/CHXD3eLiJ/BXW+EnoQbZU+uiNSYj/U7ZkYCJqUcgtil3iBRq/qXU6yVzW0204D
         uKaAt1GFdMPMwryUmY8L9nQswM6+h4qNslxU9cdq0ygwr/MrBDBXpNc1lwACC2b1mfmb
         fYUw==
X-Gm-Message-State: AOAM530iSdRyLHmurRzrarcShkjKOqlZNNp4cVApKHsk6Fjj1jGaQhjn
        A7Lxhbz0rZuCj5s6kw5553c=
X-Google-Smtp-Source: ABdhPJwvwS6mHCy5WxjV3STGGhzXGv//qLCYEjenWtfw+cmzcZ27y+t57yDT4jcr7TwE2/onZpXkZg==
X-Received: by 2002:a17:902:ec82:b0:13f:663c:87cc with SMTP id x2-20020a170902ec8200b0013f663c87ccmr811507plg.24.1634081837881;
        Tue, 12 Oct 2021 16:37:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 37/46] scsi: qedf: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:49 -0700
Message-Id: <20211012233558.4066756-38-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf.h      |  2 +-
 drivers/scsi/qedf/qedf_attr.c | 15 ++++++++++++---
 drivers/scsi/qedf/qedf_main.c |  2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ba94413fe2ea..4caddd6442f7 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -498,7 +498,7 @@ extern void qedf_process_abts_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 extern struct qedf_ioreq *qedf_alloc_cmd(struct qedf_rport *fcport,
 	u8 cmd_type);
 
-extern struct device_attribute *qedf_host_attrs[];
+extern const struct attribute_group *qedf_host_groups[];
 extern void qedf_cmd_timer_set(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	unsigned int timer_msec);
 extern int qedf_init_mp_req(struct qedf_ioreq *io_req);
diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 461c0c9180c4..fdc66d294813 100644
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
+const struct attribute_group *qedf_host_groups[] = {
+	&qedf_host_attr_group,
+	NULL
+};
+
 extern const struct qed_fcoe_ops *qed_ops;
 
 void qedf_capture_grc_dump(struct qedf_ctx *qedf)
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 42d0d941dba5..1eed6270e8f2 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -986,7 +986,7 @@ static struct scsi_host_template qedf_host_template = {
 	.cmd_per_lun	= 32,
 	.max_sectors 	= 0xffff,
 	.queuecommand 	= qedf_queuecommand,
-	.shost_attrs	= qedf_host_attrs,
+	.shost_groups	= qedf_host_groups,
 	.eh_abort_handler	= qedf_eh_abort,
 	.eh_device_reset_handler = qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = qedf_eh_target_reset, /* target reset */
