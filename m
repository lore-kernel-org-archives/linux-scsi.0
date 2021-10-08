Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1368DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DC661100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbhJHU1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:18 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44873 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242635AbhJHU1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:10 -0400
Received: by mail-pl1-f173.google.com with SMTP id t11so6838122plq.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ass/DDw+jAao+IjeSewlXwx/n01JkMuXZrSeajEp2NM=;
        b=1PmbaTj1T9iL+Eyg8/gScT8q2+6jzQCavYtMDESQca/kgMefsZjVOAXRolrGVRxE99
         e8mHtBrF4SCmvwOSE9puzIEBxDuRrqTFYewouElJTTdnY4c6GkZJWmFvHwYFGE2jxAJH
         mfpPN9hFRyXOPc+P102qJghmIQioG1KAN7PryWLmJHmHKJXWOvhZv6/kaFR0Dup2TXme
         Qgl6p1ziw5PN/ZjpfBkaQUtzDM807Cj1GUuNvFEXKdKVAo8tzpTnqTgOdNCjIVXpM1LX
         rJMakMW4TXR+owm/VEqJpaop9i6prUn7V1ijB9gtaSWbG2hVS47aoq9F1Pl2paMwbplq
         N2iQ==
X-Gm-Message-State: AOAM531yOzm07YQUSETVWr1+nHk7ErH0gxoNHMUH7SQN2t3kslJG4iZO
        Nxy5lpae3FJjyCDwdY+uzQQ=
X-Google-Smtp-Source: ABdhPJyMj1dzIeTlmjayLSTX7qHcA4hs+XTMgfEmP+w8Wsp3F2XZx9blaBUKMwkz8t871ySl/Jw48A==
X-Received: by 2002:a17:902:7d95:b0:13d:a304:1b55 with SMTP id a21-20020a1709027d9500b0013da3041b55mr11532627plm.51.1633724714562;
        Fri, 08 Oct 2021 13:25:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 37/46] scsi: qedf: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:44 -0700
Message-Id: <20211008202353.1448570-38-bvanassche@acm.org>
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
