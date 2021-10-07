Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FCAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1379761077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhJGVVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:34 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:46038 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGVVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:34 -0400
Received: by mail-pl1-f182.google.com with SMTP id n2so4723554plk.12
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tNJN4AwYQAGimEQYMNQksn/1wzeQxmaJ1jxmWraz950=;
        b=toDR1wuTAWt3HBeSTfWseEKAWiNBUt/MFUiPPJ/49yg+7EEJuyCkANMSRiUBBz1iYl
         yzRBxrOo7RzZf4YlFDMUeBFlSV9aJH7WduQDfSZR1UljHanRiQPj/9h7jCZOEdAn9QvB
         MBhBevWGubauL5JRuVwgbUzovhxkbl4CB2NEL1bff9E8rYHXLM9De3HWIAdPa6QONUIw
         YVXzXr1dbj7YA7bM1xlG742gOt8qw3Sk1a1W0DQ/+ZOePKYM158DEnsd+4KJH094Mc44
         aX8rtxa020aoufzBdKdCun+rChpWVtWAg4Jt/HCdw38lKM2NvEDuNNqKy97PGu0lko2f
         S9ng==
X-Gm-Message-State: AOAM530ITedMU+nrx0UOIrbjg9tre93sMCn74dXOliNVsXjANkh9tlAd
        55qyPfqkXHqHmae5lSc66VgVAg3Wg6aewg==
X-Google-Smtp-Source: ABdhPJySDLw8WpZAREY/WGzfeV9XaSuZYwL+NQFME/xU1PbWh+95udHl0mCdkR5GaZntxItlvgv2ww==
X-Received: by 2002:a17:90b:17d0:: with SMTP id me16mr8118578pjb.152.1633641579735;
        Thu, 07 Oct 2021 14:19:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 14/46] scsi: bfa: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:20 -0700
Message-Id: <20211007211852.256007-15-bvanassche@acm.org>
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
 drivers/scsi/bfa/bfad_attr.c | 68 ++++++++++++++++++++++--------------
 drivers/scsi/bfa/bfad_im.c   |  4 +--
 drivers/scsi/bfa/bfad_im.h   |  4 +--
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 5ae1e3f78910..0f9e766b62e4 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -956,36 +956,52 @@ static          DEVICE_ATTR(driver_name, S_IRUGO, bfad_im_drv_name_show, NULL);
 static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
 				bfad_im_num_of_discovered_ports_show, NULL);
 
-struct device_attribute *bfad_im_host_attrs[] = {
-	&dev_attr_serial_number,
-	&dev_attr_model,
-	&dev_attr_model_description,
-	&dev_attr_node_name,
-	&dev_attr_symbolic_name,
-	&dev_attr_hardware_version,
-	&dev_attr_driver_version,
-	&dev_attr_option_rom_version,
-	&dev_attr_firmware_version,
-	&dev_attr_number_of_ports,
-	&dev_attr_driver_name,
-	&dev_attr_number_of_discovered_ports,
+static struct attribute *bfad_im_host_attrs[] = {
+	&dev_attr_serial_number.attr,
+	&dev_attr_model.attr,
+	&dev_attr_model_description.attr,
+	&dev_attr_node_name.attr,
+	&dev_attr_symbolic_name.attr,
+	&dev_attr_hardware_version.attr,
+	&dev_attr_driver_version.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_number_of_ports.attr,
+	&dev_attr_driver_name.attr,
+	&dev_attr_number_of_discovered_ports.attr,
 	NULL,
 };
 
-struct device_attribute *bfad_im_vport_attrs[] = {
-	&dev_attr_serial_number,
-	&dev_attr_model,
-	&dev_attr_model_description,
-	&dev_attr_node_name,
-	&dev_attr_symbolic_name,
-	&dev_attr_hardware_version,
-	&dev_attr_driver_version,
-	&dev_attr_option_rom_version,
-	&dev_attr_firmware_version,
-	&dev_attr_number_of_ports,
-	&dev_attr_driver_name,
-	&dev_attr_number_of_discovered_ports,
+static const struct attribute_group bfad_im_host_attr_group = {
+	.attrs = bfad_im_host_attrs
+};
+
+const struct attribute_group *bfad_im_host_attr_groups[] = {
+	&bfad_im_host_attr_group,
+	NULL
+};
+
+struct attribute *bfad_im_vport_attrs[] = {
+	&dev_attr_serial_number.attr,
+	&dev_attr_model.attr,
+	&dev_attr_model_description.attr,
+	&dev_attr_node_name.attr,
+	&dev_attr_symbolic_name.attr,
+	&dev_attr_hardware_version.attr,
+	&dev_attr_driver_version.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_number_of_ports.attr,
+	&dev_attr_driver_name.attr,
+	&dev_attr_number_of_discovered_ports.attr,
 	NULL,
 };
 
+static const struct attribute_group bfad_im_vport_attr_group = {
+	.attrs = bfad_im_vport_attrs
+};
 
+const struct attribute_group *bfad_im_vport_attr_groups[] = {
+	&bfad_im_vport_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..1eeb7d0b988f 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -809,7 +809,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
-	.shost_attrs = bfad_im_host_attrs,
+	.shost_groups = bfad_im_host_attr_groups,
 	.max_sectors = BFAD_MAX_SECTORS,
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
 };
@@ -831,7 +831,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
-	.shost_attrs = bfad_im_vport_attrs,
+	.shost_groups = bfad_im_vport_attr_groups,
 	.max_sectors = BFAD_MAX_SECTORS,
 };
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index f16d4b219e44..87c67259c38c 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -174,8 +174,8 @@ extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
 extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 
-extern struct device_attribute *bfad_im_host_attrs[];
-extern struct device_attribute *bfad_im_vport_attrs[];
+extern const struct attribute_group *bfad_im_host_attr_groups[];
+extern const struct attribute_group *bfad_im_vport_attr_groups[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
