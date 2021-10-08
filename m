Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA194C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6520610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242570AbhJHU0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:32 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:40630 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbhJHU0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:31 -0400
Received: by mail-pg1-f182.google.com with SMTP id h3so4156683pgb.7
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6xpdXRUZrHa2dh7OhsosMe9PUV3PZXzVX6aPTtYLzwQ=;
        b=HXLM5JE2JThJJzVNpKpOpj6E8zNDcVvaTxLLrlAED+JwFwo45kegT35Kb0LnhvBPD6
         jnkoiN0znZ5K7UDOCvIFHeg5PeqtPAawtv8q/VBdR7kgGQLVJDnT49QOPb02KxkI1Klw
         ufbe6lKD5D2zCmzCzDHEwUasFfZSh1sRAZjhDKbHLhAVpSuLhgZpM7A1bjrxh+cBErFK
         CptZqkMOM8nyXIio0jZKj/Z7u1j2t0PkFnUogJbgEVksXJJ18FmKeJZwZSG4OUWM2wTD
         QXMFN7+46cfSUVHUtJh5YacOkIcEEafgwaIHvg6KwtEGUMxMBHdm49UiT1c4dzvpXh1k
         8Bqg==
X-Gm-Message-State: AOAM532KjJvYJvCPTMeBIXjtMl/3f9B3QpEO4rF4tkPYbNVZTWsNPIke
        G6SuQakA1hEEr33UARhiTmo=
X-Google-Smtp-Source: ABdhPJxxByIwDhulHecrGUJHq4wkMGet15+BANrrPrE752G21Z3aHl2Pgk6RF9uVL622+1J7pRd0Cg==
X-Received: by 2002:a63:d64c:: with SMTP id d12mr6517910pgj.186.1633724675452;
        Fri, 08 Oct 2021 13:24:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 16/46] scsi: bnx2i: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:23 -0700
Message-Id: <20211008202353.1448570-17-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i.h       |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 663a63d4dae4..df7d04afce05 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -795,7 +795,7 @@ extern struct cnic_ulp_ops bnx2i_cnic_cb;
 extern unsigned int sq_size;
 extern unsigned int rq_size;
 
-extern struct device_attribute *bnx2i_dev_attributes[];
+extern const struct attribute_group *bnx2i_dev_groups[];
 
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b5f3e143f07..e21b053b4f3e 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2266,7 +2266,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.cmd_per_lun		= 128,
 	.this_id		= -1,
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
-	.shost_attrs		= bnx2i_dev_attributes,
+	.shost_groups		= bnx2i_dev_groups,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index bea00073cb7c..d6b0bbb5176b 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -142,8 +142,17 @@ static DEVICE_ATTR(sq_size, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(num_ccell, S_IRUGO | S_IWUSR,
 		   bnx2i_show_ccell_info, bnx2i_set_ccell_info);
 
-struct device_attribute *bnx2i_dev_attributes[] = {
-	&dev_attr_sq_size,
-	&dev_attr_num_ccell,
+static struct attribute *bnx2i_dev_attributes[] = {
+	&dev_attr_sq_size.attr,
+	&dev_attr_num_ccell.attr,
+	NULL
+};
+
+static const struct attribute_group bnx2i_dev_attr_group = {
+	.attrs = bnx2i_dev_attributes
+};
+
+const struct attribute_group *bnx2i_dev_groups[] = {
+	&bnx2i_dev_attr_group,
 	NULL
 };
