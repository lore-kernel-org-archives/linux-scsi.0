Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4C0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6893D61177
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbhJHU1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:19 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:42974 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbhJHU1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:12 -0400
Received: by mail-pl1-f169.google.com with SMTP id l6so6845840plh.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZTBxLPqSs/6i0U7e7XZcvzD63NIy196LVs1TUn3088=;
        b=lDMQ3EzTOKG7gkoOdFBEvVdbZCbhM6IGnnFvr6W3hnRVZclg4aVv2HcX4+htCDipX7
         GFlVqjNb7E3kLt7siq31egUEiowphzmXsbps++Mie5pMCLsEydIHxrTunEA6TnpSRbMc
         6HxfXiKOdgv0yQ3aG0MMwUzgiVrIdsMlT2uxki3yDGkI6IbZwxsnfiPgbqVxsbpm5DtN
         XNxQJvi/aInyux8Gj1hPKduIEgw6TRUWDmgB7wabGXJh57FoAcP33zoeC4+ebhBpL2y8
         IwRVHfU2jqpxvJK9+a8g9VVp76rrzm3RDDIdLEvRNC4yezJr23xtRXMYKE/++Z4N/ETw
         s0dw==
X-Gm-Message-State: AOAM533BbYkTWgt4U2zpG8Ch7criroX8d+yhIEMVAB5lNvwKL5G0I8IK
        fpSKYJE3uEOqX+be/zQ+rkU=
X-Google-Smtp-Source: ABdhPJygs5MWLmkhZYmRomdXXp00sa50NXeAr4UHBarg5E++dfMuE7GjRUyieD63hKKMhn4cOpvP7Q==
X-Received: by 2002:a17:902:7ec2:b0:13d:b563:c39 with SMTP id p2-20020a1709027ec200b0013db5630c39mr11342957plb.14.1633724716109;
        Fri, 08 Oct 2021 13:25:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 38/46] scsi: qedi: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:45 -0700
Message-Id: <20211008202353.1448570-39-bvanassche@acm.org>
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
