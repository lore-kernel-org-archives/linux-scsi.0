Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD179C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A37460F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhJLXjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:00 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:40703 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhJLXi4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:56 -0400
Received: by mail-pf1-f173.google.com with SMTP id o133so835196pfg.7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pL0XsSmLM0S09oS82IXJArEaSeEy2ycMIy/uO6hE6rk=;
        b=IcHGVvWZovK67kVPwoOStuzjNJCTCbPR97Dv6KO46ZWbAuuSBKud+eEBjQkfF1rwDq
         0aYhyvAqKj+C0hUHI4bclcmIzeW6T3t8fBvkTJ/URwb5xRG+/wkWh33Ao4XZpQAldZmA
         1iTPhPO/9RizauvEehncCHL1FERi4DdJG7oYNZx1YDv6qyMNVGuYj50rXgBj6IyOGW1h
         CZfPblW1MNBWdZwhrHGYuDwRpBob2lXOIhlNtQaUIvshA7ZyokWJ4/M4yBUC+YrXeiCn
         DqZS5N/ufC8/F/w6ZyGEDxAziKgUuMFB9bw9L5SXIeLiGREmGMaDEdD1x1mMnAdW4FB+
         cqrA==
X-Gm-Message-State: AOAM532q7NqZ9nlBJ/PANMM9J1y7ap3JE6OYXl3pHHesPfI0981CEsxC
        eaGOv183nOuurTi5cOk9V+k=
X-Google-Smtp-Source: ABdhPJykYQBJuIe722enElXg2iMAKNlGTuRKEvWUfQf+ZT0GFnidcuNjtArHQig+kJjpUP+9eY4DpQ==
X-Received: by 2002:a63:f84f:: with SMTP id v15mr25523699pgj.204.1634081813864;
        Tue, 12 Oct 2021 16:36:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 25/46] scsi: ipr: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:37 -0700
Message-Id: <20211012233558.4066756-26-bvanassche@acm.org>
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
 
