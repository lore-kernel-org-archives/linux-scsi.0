Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28652C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10AF260E94
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhJLXjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:32 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:46808 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbhJLXj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:26 -0400
Received: by mail-pf1-f171.google.com with SMTP id t15so807572pfl.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=upj/KnYLoS9C7cnMr4Y0XwV/YgR2WUy46bqjINgNPoI=;
        b=yUIS35YvfxajMM/MJUPLa5VxKLB8uauvI3cezg8vG+maQj4GFBe9cSNU4GM13Qzw+q
         WMnp0bF4dMOnElk42fS1hVMRm0mwVJiM8CNSzcV8M5PEuyq6coIZkWS9MKyP5B+9xKRd
         SIDzMRU+0f7g8uYIaDZuDgqAJ9v5NfOyPdEfEsvpo3IZQ5G+3jVjpvY2tttpcMd8X1aw
         5afd6dJttW35gnMNFVYvLA9k0p1FhYu4sZ3AX1l3myNKNU9hWOWnRQRU1TC0lHIB5J18
         7XKuSlqpfJSkH416SnLWWZhUgFHXQJeXXCKyOlysHZ4hiybIPQos/Q4UwqHNVxtVmg51
         Zxqg==
X-Gm-Message-State: AOAM531wySQRmLnrSxrAfaV3Se8LrOE/T/KgC/rlm1iEzZwh7D23n5GW
        PoDf2C/oec8++08EDQKe9ks=
X-Google-Smtp-Source: ABdhPJyANzNzPNlAffsxf05S9DRUybTYHPpgAh+q9XDQDVPpP9sml+TDyRa+kX6Ty92OPogFHllIIQ==
X-Received: by 2002:a05:6a00:d63:b0:44d:186d:c4c0 with SMTP id n35-20020a056a000d6300b0044d186dc4c0mr15561899pfv.47.1634081843738;
        Tue, 12 Oct 2021 16:37:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 41/46] scsi: qla4xxx: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:53 -0700
Message-Id: <20211012233558.4066756-42-bvanassche@acm.org>
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
