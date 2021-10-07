Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0A8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467EB610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhJGVV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:58 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:46774 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGVV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:56 -0400
Received: by mail-pj1-f41.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so6190453pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=718LRFgqd69ly4OA91qx9c7cRSF8wKoNhPwyqmALI/g=;
        b=aTUGhoipVPAkn/LThehU6av4Eh9GYRkTyUl1vlQ8eciIYPjx2g4Rl03d6cmVPyueh8
         JL9KkU/t1HiH5qb2JLTql3BEBoz/c7QDmcJzpARlhwDYz9bkJAGg5TbMs2DMCtndqSsR
         w4LeJc6M9usAwiRxjTbb1LRvtCgLgteHlT4LjoxkVWgLx0FgEbN5ZmuSdchnFGBr6Eha
         Xr/c5Dg5HB0rqdGM8ykQAdmJn6IKG/5FIswC3yRJMzpRrAhE4GGhG/xwP581MzYYbxb+
         OUrYidhxhAqqTl07JZjx5/QkLhNlll1tQiOncjUtAe/8Z7+l6Yvdhknqms8dpYUs9zhH
         3LJg==
X-Gm-Message-State: AOAM530z2qtNZQGe0zKZdl8jRat78WlyMYlEk5Oln7UjbI8c6Gi7SRZs
        NwPfDKMBlNEaAgDagfCBwmA=
X-Google-Smtp-Source: ABdhPJz1ocDH83w2nrWPHFDGQT1Xrvfn2/6CVqEpdBW1VXhsJEMASlo96yklYovodgaDQtOr0n2Orw==
X-Received: by 2002:a17:902:b213:b0:13e:cd44:b4b5 with SMTP id t19-20020a170902b21300b0013ecd44b4b5mr5876982plr.18.1633641601758;
        Thu, 07 Oct 2021 14:20:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 25/46] scsi: ipr: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:31 -0700
Message-Id: <20211007211852.256007-26-bvanassche@acm.org>
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
 drivers/scsi/ipr.c | 52 +++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..c872a28b8d5e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4236,18 +4236,27 @@ static struct bin_attribute ipr_ioa_async_err_log = {
 	.write = ipr_next_async_err_log
 };
 
-static struct device_attribute *ipr_ioa_attrs[] = {
-	&ipr_fw_version_attr,
-	&ipr_log_level_attr,
-	&ipr_diagnostics_attr,
-	&ipr_ioa_state_attr,
-	&ipr_ioa_reset_attr,
-	&ipr_update_fw_attr,
-	&ipr_ioa_fw_type_attr,
-	&ipr_iopoll_weight_attr,
+static struct attribute *ipr_ioa_attrs[] = {
+	&ipr_fw_version_attr.attr,
+	&ipr_log_level_attr.attr,
+	&ipr_diagnostics_attr.attr,
+	&ipr_ioa_state_attr.attr,
+	&ipr_ioa_reset_attr.attr,
+	&ipr_update_fw_attr.attr,
+	&ipr_ioa_fw_type_attr.attr,
+	&ipr_iopoll_weight_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group ipr_ioa_attr_group = {
+	.attrs = ipr_ioa_attrs
+};
+
+static const struct attribute_group *ipr_ioa_attr_groups[] = {
+	&ipr_ioa_attr_group,
+	NULL
+};
+
 #ifdef CONFIG_SCSI_IPR_DUMP
 /**
  * ipr_read_dump - Dump the adapter
@@ -4732,15 +4741,24 @@ static struct device_attribute ipr_raw_mode_attr = {
 	.store = ipr_store_raw_mode
 };
 
-static struct device_attribute *ipr_dev_attrs[] = {
-	&ipr_adapter_handle_attr,
-	&ipr_resource_path_attr,
-	&ipr_device_id_attr,
-	&ipr_resource_type_attr,
-	&ipr_raw_mode_attr,
+static struct attribute *ipr_dev_attrs[] = {
+	&ipr_adapter_handle_attr.attr,
+	&ipr_resource_path_attr.attr,
+	&ipr_device_id_attr.attr,
+	&ipr_resource_type_attr.attr,
+	&ipr_raw_mode_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group ipr_dev_attr_group = {
+	.attrs = ipr_dev_attrs
+};
+
+static const struct attribute_group *ipr_dev_attr_groups[] = {
+	&ipr_dev_attr_group,
+	NULL
+};
+
 /**
  * ipr_biosparam - Return the HSC mapping
  * @sdev:			scsi device struct
@@ -6762,8 +6780,8 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize = IPR_MAX_SGLIST,
 	.max_sectors = IPR_IOA_MAX_SECTORS,
 	.cmd_per_lun = IPR_MAX_CMD_PER_LUN,
-	.shost_attrs = ipr_ioa_attrs,
-	.sdev_attrs = ipr_dev_attrs,
+	.shost_groups = ipr_ioa_attr_groups,
+	.sdev_groups = ipr_dev_attr_groups,
 	.proc_name = IPR_NAME,
 };
 
