Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB3EC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629FE61077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbhJGVWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:33 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:53208 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbhJGVWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:31 -0400
Received: by mail-pj1-f51.google.com with SMTP id oa4so5203890pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DrQMDwdkqIz01ZAK1JAuH5KT2QgYQkcbJrXXgoJgBPQ=;
        b=gKz3JznxzhDp43pbR3CWi3c8NTqDaMi5l/6JFXAw3G0lePF//MmLHWKuZ/McU++xc7
         2+DZb/SwYO6fCYTvDIR3CBy4YOND0PpE8uJnizmEn96mmCSj4FvmLaPfY8Oigm6+Upim
         QEnC+E32us4UVMbJvzyVbZ3XZN25V7kVX0rPTZ9Khc3va3++noY4Hre4R5JaNfCMFu87
         UFarY3E8b0ab8NcMvJtH1Q7tNk7aSLn3+uJXGdnSmCUx+ghgIQW6vv8eSD9ZP7ZViAE6
         8GC0fJ9Hw3US64PKs+B7Jf5zBrT0w1xMyGCs3fDYN59/YDtJP549rmeZTqZF+WBfWrDI
         e9gQ==
X-Gm-Message-State: AOAM532HDTqt4JZkobq0IoxhOsIh1NP1pNioFzOX0+h3ey0NbPbM2QYS
        XxcVXHzLrOW9v0n2sCb+SDA=
X-Google-Smtp-Source: ABdhPJz9VUIIAl+batr9IcxHW8E4aHE7dxvLuSGwEC5nsHQn9iQA5tKN4Ak9sUV8jGKVGyEiyeSR4A==
X-Received: by 2002:a17:902:dacf:b0:13e:ab53:87dc with SMTP id q15-20020a170902dacf00b0013eab5387dcmr5997013plx.78.1633641637630;
        Thu, 07 Oct 2021 14:20:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 41/46] scsi: qla4xxx: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:47 -0700
Message-Id: <20211007211852.256007-42-bvanassche@acm.org>
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
 drivers/scsi/qla4xxx/ql4_attr.c | 41 ++++++++++++++++++++-------------
 drivers/scsi/qla4xxx/ql4_glbl.h |  3 ++-
 drivers/scsi/qla4xxx/ql4_os.c   |  2 +-
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index ec4352818fbf..2595b64febf9 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -330,21 +330,30 @@ static DEVICE_ATTR(fw_ext_timestamp, S_IRUGO, qla4xxx_fw_ext_timestamp_show,
 static DEVICE_ATTR(fw_load_src, S_IRUGO, qla4xxx_fw_load_src_show, NULL);
 static DEVICE_ATTR(fw_uptime, S_IRUGO, qla4xxx_fw_uptime_show, NULL);
 
-struct device_attribute *qla4xxx_host_attrs[] = {
-	&dev_attr_fw_version,
-	&dev_attr_serial_num,
-	&dev_attr_iscsi_version,
-	&dev_attr_optrom_version,
-	&dev_attr_board_id,
-	&dev_attr_fw_state,
-	&dev_attr_phy_port_cnt,
-	&dev_attr_phy_port_num,
-	&dev_attr_iscsi_func_cnt,
-	&dev_attr_hba_model,
-	&dev_attr_fw_timestamp,
-	&dev_attr_fw_build_user,
-	&dev_attr_fw_ext_timestamp,
-	&dev_attr_fw_load_src,
-	&dev_attr_fw_uptime,
+static struct attribute *qla4xxx_host_attrs[] = {
+	&dev_attr_fw_version.attr,
+	&dev_attr_serial_num.attr,
+	&dev_attr_iscsi_version.attr,
+	&dev_attr_optrom_version.attr,
+	&dev_attr_board_id.attr,
+	&dev_attr_fw_state.attr,
+	&dev_attr_phy_port_cnt.attr,
+	&dev_attr_phy_port_num.attr,
+	&dev_attr_iscsi_func_cnt.attr,
+	&dev_attr_hba_model.attr,
+	&dev_attr_fw_timestamp.attr,
+	&dev_attr_fw_build_user.attr,
+	&dev_attr_fw_ext_timestamp.attr,
+	&dev_attr_fw_load_src.attr,
+	&dev_attr_fw_uptime.attr,
 	NULL,
 };
+
+static const struct attribute_group qla4xxx_host_attr_group = {
+	.attrs = qla4xxx_host_attrs
+};
+
+const struct attribute_group *qla4xxx_host_attr_groups[] = {
+	&qla4xxx_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index ea60057b2e20..25b33194e811 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -286,5 +286,6 @@ extern int ql4xenablemsix;
 extern int ql4xmdcapmask;
 extern int ql4xenablemd;
 
-extern struct device_attribute *qla4xxx_host_attrs[];
+extern const struct attribute_group *qla4xxx_host_attr_groups[];
+
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1ea65c6e5f5..fc9180816455 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -241,7 +241,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla4xxx_host_attrs,
+	.shost_groups		= qla4xxx_host_attr_groups,
 	.host_reset		= qla4xxx_host_reset,
 	.vendor_id		= SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
 };
