Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B2AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C48561019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbhJHU0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:50 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:46959 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242783AbhJHU0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:47 -0400
Received: by mail-pj1-f42.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so8627708pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pL0XsSmLM0S09oS82IXJArEaSeEy2ycMIy/uO6hE6rk=;
        b=qh0wQiQjgNkYKtrq+kQnSQS9ex6aBv6xRBGx12EDcAEIYhSXcYf2+hOwXiILctlqOm
         mVL6Fhrd8xvlT6gwFzzefdWch76ephQ8NHPiCDMqQfjEDYmYGxSCxhwqxtL5cpDCvqDM
         6yIJLkaSex7iR+k8zTlr515WwIDQRgdrmoyeqi/KZ5jOdaPRvfi73iAs2TUCHxV3hzK1
         EalIJZ6NKvbOHM5SoxNCTRoBArcCfPUGYUj13Wa60PCT23liyockkxohDX0GDJNVGwOc
         qD91ILb7FafD9RPwlLOiWth35MYcW/Kw49rTIHSiIzH5yhMHNMUleJbx7chEP/osA/27
         1GKg==
X-Gm-Message-State: AOAM530342y2N/j1ySVe4+iswPPDWoQEbY8KFTEETpSvUxIkNeMqcMBx
        MwbjPt7QowTpxfiTzW8O4uo=
X-Google-Smtp-Source: ABdhPJyn32cgR65yNjXLI4/ulInsGtnQSpSoVdDktK8Cfg5EqhSEXdSzYXsT9YYfHrl2dRC2jQN6nw==
X-Received: by 2002:a17:902:b095:b029:12c:de88:7d3b with SMTP id p21-20020a170902b095b029012cde887d3bmr11513324plr.15.1633724691180;
        Fri, 08 Oct 2021 13:24:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 25/46] scsi: ipr: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:32 -0700
Message-Id: <20211008202353.1448570-26-bvanassche@acm.org>
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
 drivers/scsi/ipr.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..00862e84308c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4236,18 +4236,20 @@ static struct bin_attribute ipr_ioa_async_err_log = {
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
 
+ATTRIBUTE_GROUPS(ipr_ioa);
+
 #ifdef CONFIG_SCSI_IPR_DUMP
 /**
  * ipr_read_dump - Dump the adapter
@@ -4732,15 +4734,17 @@ static struct device_attribute ipr_raw_mode_attr = {
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
 
+ATTRIBUTE_GROUPS(ipr_dev);
+
 /**
  * ipr_biosparam - Return the HSC mapping
  * @sdev:			scsi device struct
@@ -6762,8 +6766,8 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize = IPR_MAX_SGLIST,
 	.max_sectors = IPR_IOA_MAX_SECTORS,
 	.cmd_per_lun = IPR_MAX_CMD_PER_LUN,
-	.shost_attrs = ipr_ioa_attrs,
-	.sdev_attrs = ipr_dev_attrs,
+	.shost_groups = ipr_ioa_groups,
+	.sdev_groups = ipr_dev_groups,
 	.proc_name = IPR_NAME,
 };
 
