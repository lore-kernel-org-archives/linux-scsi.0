Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D0EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16B660F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhJLXjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:22 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43766 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhJLXjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:21 -0400
Received: by mail-pg1-f182.google.com with SMTP id r2so534006pgl.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZTBxLPqSs/6i0U7e7XZcvzD63NIy196LVs1TUn3088=;
        b=5KcUfU65oC3QXFIa17S5cdcrldm8K9zCf6ObmDge616paBTzTdzPKuZuPWtx8qzzdA
         EaRHmfhPqHBKQa3U4sFlCWQqvWLkcvnvj16Rp/fEs07j64EEgZg3qGNOtxzFKFX9Ig3/
         PvfnIchShdTPFc/XlVs4UsTB0BY+jddiYDuuoC2mY5xJ6xLGkG+MlPOr21ymhapCOhRX
         ZqZACQ5usQq8oi/+TxBTzP3ZFY6t7noieUAYlizX9QzE83M6mMs6K5yaCdKitkGabKbm
         c9Ak7WNseoHHjC8sKKhbF5XCDppDOoMp7LbcjHbl5cxbUi+pNql2WCqRlTvljt8EWWlj
         Yocg==
X-Gm-Message-State: AOAM5328ngb/7x0rMpEcditS9s+uW0+3kRQSw3nA0VwmDD4sshrxe+jk
        xXthZqq5fNO6yfN5mj0fwE8=
X-Google-Smtp-Source: ABdhPJxoTokgWXoPD/1YXS2TKfEs+0/hYvyx6bSvoen1mIbm/Srg7e0Xy0Wbyix2VgbheyUtWgH6BQ==
X-Received: by 2002:aa7:8b1a:0:b0:44d:37c7:dbb6 with SMTP id f26-20020aa78b1a000000b0044d37c7dbb6mr7843180pfd.11.1634081839402;
        Tue, 12 Oct 2021 16:37:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 38/46] scsi: qedi: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:50 -0700
Message-Id: <20211012233558.4066756-39-bvanassche@acm.org>
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
 drivers/scsi/qedi/qedi_gbl.h   |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 drivers/scsi/qedi/qedi_sysfs.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 9f8e8ef405a1..72942772b198 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -22,7 +22,7 @@ extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
 extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
 extern const struct file_operations qedi_dbg_fops[];
-extern struct device_attribute *qedi_shost_attrs[];
+extern const struct attribute_group *qedi_shost_groups[];
 
 int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
 void qedi_free_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index c5260429c637..88aa7d8b11c9 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -58,7 +58,7 @@ struct scsi_host_template qedi_host_template = {
 	.max_sectors = 0xffff,
 	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
-	.shost_attrs = qedi_shost_attrs,
+	.shost_groups = qedi_shost_groups,
 };
 
 static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qedi/qedi_sysfs.c b/drivers/scsi/qedi/qedi_sysfs.c
index be174d30eb7c..b00a7e08ef53 100644
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
+const struct attribute_group *qedi_shost_groups[] = {
+	&qedi_shost_attr_group,
 	NULL
 };
