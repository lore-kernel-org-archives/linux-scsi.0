Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CDDC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ECF461077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhJGVVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:39 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34754 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbhJGVVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:37 -0400
Received: by mail-pf1-f176.google.com with SMTP id g14so6428725pfm.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+3Uwj2D4q3hy8MOz5KjrEDG2Gq3Osya5s/ucEvkU7o=;
        b=zAlAcAqT2zuTbm/NP7c0whVNSkrcuJQaslkUWBkNMZrrRRmpDBpyI5Il+NQtAiWxFe
         Rt+HBodkemNgu4FPjH/QDrRURgvdFmbyTggAC+25IQgI0zc/W0pwiuc+K1AI6nT+D5O+
         qk5hg2wm3x8HKynOgY5I7TM83ZbLFqBdoaqiXpQ7zoTpx8G6nzxsik8ksxdDjQbbPK5N
         HmOvJLnmwt1uQnnodgHGAgB5MIv5Ff7M9QnZj2NH/ZfgxVqvuxPDRGfpw1z7sOM7wqGq
         RwQcN46mbCkNKaTxHx32mmXlsn2CsEHpsiHKp8HwBHjG0OFsnNIfARWYAramB+X0W6Lr
         qHwA==
X-Gm-Message-State: AOAM532m4oUf5LHHUDkDbNiXHDPxF3XXhza/45HWkGhAHVU/VbwSOmVC
        18OH1jxU8390YFJef3LWX90=
X-Google-Smtp-Source: ABdhPJzZ2iJtRCQv5yA+eJaiM3YcMT3+mTMn8Ycv1XSDGg1BYtSNYN3ViQAVuMo2M7JwV9cbSk+3iQ==
X-Received: by 2002:a62:6203:0:b0:44c:7649:90b0 with SMTP id w3-20020a626203000000b0044c764990b0mr6740546pfb.21.1633641582908;
        Thu, 07 Oct 2021 14:19:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 16/46] scsi: bnx2i: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:22 -0700
Message-Id: <20211007211852.256007-17-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i.h       |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 663a63d4dae4..e9cf53559408 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -795,7 +795,7 @@ extern struct cnic_ulp_ops bnx2i_cnic_cb;
 extern unsigned int sq_size;
 extern unsigned int rq_size;
 
-extern struct device_attribute *bnx2i_dev_attributes[];
+extern const struct attribute_group *bnx2i_dev_attr_groups[];
 
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b5f3e143f07..4d034affbf09 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2266,7 +2266,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.cmd_per_lun		= 128,
 	.this_id		= -1,
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
-	.shost_attrs		= bnx2i_dev_attributes,
+	.shost_groups		= bnx2i_dev_attr_groups,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index bea00073cb7c..7aa5440aa13c 100644
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
+const struct attribute_group *bnx2i_dev_attr_groups[] = {
+	&bnx2i_dev_attr_group,
 	NULL
 };
