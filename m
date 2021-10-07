Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0000C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD29F610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhJGVVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:44 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:46659 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhJGVVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:43 -0400
Received: by mail-pl1-f172.google.com with SMTP id w11so4720281plz.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cW65z7/LTV3aCyXTScAx5pfPvVu6c26bkf/AFoIwOY0=;
        b=S8uRRTQKv+5ajS20o9mz+wTFYe7sAqZkj28whtvcbXdjH+X+45F/HgbJ9QlXCcW0Ib
         KM7ou0I48L0jIU15CWuFvX/lQfRVtxFAe9UHPk/+P7GqWvpkOwKAiYl0w/OuMHpv+3QD
         3nS3WDJ5veoSh/8HOwxiJmQLOwO/gYH//VplYMDlf5YEYIviKbQ7M3T8ZEqzog7NDIJj
         mLwXFkBpMgaZFtLMZs3Dv3VRCGRk1lFXwwaEClTuQUSGtJdYE6zeX3/OxadVwumNnvj+
         NvE6pKISq1FuWX/r3a1iiQyleZCFU0Ht38tXlRG4tYF72Jn/qXjmWmDQS2CkihFH1iLJ
         ew0A==
X-Gm-Message-State: AOAM532yYPhsbAUQKmY4HpRUCdisn9kQmKQ2mChMebHNnNXwNJXAH8iL
        jXI/3idSPxIIASdtgi+Z+vU=
X-Google-Smtp-Source: ABdhPJzVeu3KpNUuzJtq8SJqMh2m8Grbb32UNLFCuvSm29/0qn8hGkZn76gJ8VR0YjiFDXriiAeMnA==
X-Received: by 2002:a17:90b:3382:: with SMTP id ke2mr7876803pjb.153.1633641589581;
        Thu, 07 Oct 2021 14:19:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2 17/46] scsi: csiostor: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:23 -0700
Message-Id: <20211007211852.256007-18-bvanassche@acm.org>
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
 drivers/scsi/csiostor/csio_scsi.c | 38 +++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..b7ef0a6cae22 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1460,14 +1460,23 @@ static DEVICE_ATTR(disable_port, S_IWUSR, NULL, csio_disable_port);
 static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 		  csio_store_dbg_level);
 
-static struct device_attribute *csio_fcoe_lport_attrs[] = {
-	&dev_attr_hw_state,
-	&dev_attr_device_reset,
-	&dev_attr_disable_port,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_lport_attrs[] = {
+	&dev_attr_hw_state.attr,
+	&dev_attr_device_reset.attr,
+	&dev_attr_disable_port.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
+static const struct attribute_group csio_fcoe_lport_attr_group = {
+	.attrs = csio_fcoe_lport_attrs
+};
+
+static const struct attribute_group *csio_fcoe_lport_attr_groups[] = {
+	&csio_fcoe_lport_attr_group,
+	NULL
+};
+
 static ssize_t
 csio_show_num_reg_rnodes(struct device *dev,
 		     struct device_attribute *attr, char *buf)
@@ -1479,12 +1488,21 @@ csio_show_num_reg_rnodes(struct device *dev,
 
 static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);
 
-static struct device_attribute *csio_fcoe_vport_attrs[] = {
-	&dev_attr_num_reg_rnodes,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_vport_attrs[] = {
+	&dev_attr_num_reg_rnodes.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
+static const struct attribute_group csio_fcoe_vport_attr_group = {
+	.attrs = csio_fcoe_vport_attrs
+};
+
+static const struct attribute_group *csio_fcoe_vport_attr_groups[] = {
+	&csio_fcoe_vport_attr_group,
+	NULL
+};
+
 static inline uint32_t
 csio_scsi_copy_to_sgl(struct csio_hw *hw, struct csio_ioreq *req)
 {
@@ -2277,7 +2295,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
 	.cmd_per_lun		= CSIO_MAX_CMD_PER_LUN,
-	.shost_attrs		= csio_fcoe_lport_attrs,
+	.shost_groups		= csio_fcoe_lport_attr_groups,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
 };
 
@@ -2296,7 +2314,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
 	.cmd_per_lun		= CSIO_MAX_CMD_PER_LUN,
-	.shost_attrs		= csio_fcoe_vport_attrs,
+	.shost_groups		= csio_fcoe_vport_attr_groups,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
 };
 
