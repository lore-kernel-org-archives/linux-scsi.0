Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05B2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4F761100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbhJHU1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:23 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:46784 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbhJHU1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:16 -0400
Received: by mail-pl1-f179.google.com with SMTP id 21so676126plo.13
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=upj/KnYLoS9C7cnMr4Y0XwV/YgR2WUy46bqjINgNPoI=;
        b=nszBSxDmjxaLFtGZ0sGEoxCcMFs7EKZgpIvly9q803XBv0tN3BmAlvsNzM7vk0Zn5X
         /Vm68YCcEbXNVFcz6mYqysf+Cn5Tzv6mW8iLKgLZbfvPcPEWElfK/ZZG9bZ2BU7GGO8u
         y+HtIQgXr6hK+LViOKY2T5AeyBd9Wzb4i3HxY15xy1VY/k7O+iBQYmOxpSEKu/rFn+xg
         sdHQamImjCApEFskTB4Bg9kr9Dk6HaOzVAT57DEfVcjBqjJD3XBH7QZU6CVvG52lLAmG
         iSZ5VkXLdR2BLsiCjLkLs61LK2MU5rhYbe3ZPu/re0g0DHJ4YMMQJ6RAPQubWK8BfR0f
         mZ9A==
X-Gm-Message-State: AOAM530PeIdeT9e10NOR+qy/r98ot0EHb6wwhDuEXUTVRktZBJUYT9kO
        EIJheRL5XY6s8UvOrt8dvvhzf2OUvLBEnA==
X-Google-Smtp-Source: ABdhPJwKXAWk4nKWGeEZ97imi2KJTaqhDVns90Ym3mjywrjhXm+WsB6CjLhDqofsL56hKpnPPp4rOA==
X-Received: by 2002:a17:902:8495:b0:13e:6a01:f5fb with SMTP id c21-20020a170902849500b0013e6a01f5fbmr11292293plo.61.1633724720621;
        Fri, 08 Oct 2021 13:25:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 41/46] scsi: qla4xxx: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:48 -0700
Message-Id: <20211008202353.1448570-42-bvanassche@acm.org>
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
 drivers/scsi/qla4xxx/ql4_attr.c | 41 ++++++++++++++++++++-------------
 drivers/scsi/qla4xxx/ql4_glbl.h |  3 ++-
 drivers/scsi/qla4xxx/ql4_os.c   |  2 +-
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index ec4352818fbf..abfa6ef60480 100644
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
+const struct attribute_group *qla4xxx_host_groups[] = {
+	&qla4xxx_host_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index ea60057b2e20..c0873381508d 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -286,5 +286,6 @@ extern int ql4xenablemsix;
 extern int ql4xmdcapmask;
 extern int ql4xenablemd;
 
-extern struct device_attribute *qla4xxx_host_attrs[];
+extern const struct attribute_group *qla4xxx_host_groups[];
+
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1ea65c6e5f5..d0cf7d1a364e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -241,7 +241,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla4xxx_host_attrs,
+	.shost_groups		= qla4xxx_host_groups,
 	.host_reset		= qla4xxx_host_reset,
 	.vendor_id		= SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
 };
