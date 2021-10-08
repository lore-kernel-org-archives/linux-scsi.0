Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF57BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF12F610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242410AbhJHU0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:31 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:55219 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbhJHU03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:29 -0400
Received: by mail-pj1-f50.google.com with SMTP id np13so8412721pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h978B1xPZVs8EBEqkQJzccy7GM6g4uoYqAZnY/bH15M=;
        b=Aa3Z/w0b9Q8dnjnv0fmerO75dS/U9b7Avr1lsi71e53hthANVCNi8OM2q0mKwv0A3a
         F43ULjGHKJyNSUMxZeFQUAYOTSbWzwL0/S3QQnHeeS7ulkUZuz3RDnOmHIdK6g7AY3fS
         qI5TtXhFqWWlJWR5twypR1sOstRHgBCWx0nynuY8OLj0w2bIh3gRlDUZl373SQzz15u6
         h6ikWt/COg5ie9ms1V8uiKrGKtPt4Ay8OGH8tFPMA/zlMBEmM6uunnAQsAn/D447zXMW
         pnfnnIiEFgqBhc+59rJ8a/T4BKda//TL8uzcRZN36oZfhSLDPv4buC7RQKzlGveVNk5J
         rZCA==
X-Gm-Message-State: AOAM531oYdMd3TjLmd52+HZ+eqGazfIe5KldtHl82uiuZo3us+8we+BZ
        /6EwaKvzia8Fz1QpmJxSncs=
X-Google-Smtp-Source: ABdhPJzTRQwEnbD9Zoy7KcrKtinizVwFgCI0VjS7ifR2W73346GP7VrJJBiyss6MDG08RZy0VTDR0g==
X-Received: by 2002:a17:902:eccf:b0:13e:b002:d8bd with SMTP id a15-20020a170902eccf00b0013eb002d8bdmr11452319plh.48.1633724672447;
        Fri, 08 Oct 2021 13:24:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/46] scsi: bfa: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:21 -0700
Message-Id: <20211008202353.1448570-15-bvanassche@acm.org>
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
 drivers/scsi/bfa/bfad_attr.c | 68 ++++++++++++++++++++++--------------
 drivers/scsi/bfa/bfad_im.c   |  4 +--
 drivers/scsi/bfa/bfad_im.h   |  4 +--
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 5ae1e3f78910..c8b947c16069 100644
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
+const struct attribute_group *bfad_im_host_groups[] = {
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
 
+const struct attribute_group *bfad_im_vport_groups[] = {
+	&bfad_im_vport_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..c074088afe12 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -809,7 +809,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
-	.shost_attrs = bfad_im_host_attrs,
+	.shost_groups = bfad_im_host_groups,
 	.max_sectors = BFAD_MAX_SECTORS,
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
 };
@@ -831,7 +831,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
-	.shost_attrs = bfad_im_vport_attrs,
+	.shost_groups = bfad_im_vport_groups,
 	.max_sectors = BFAD_MAX_SECTORS,
 };
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index f16d4b219e44..829345b514d1 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -174,8 +174,8 @@ extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
 extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 
-extern struct device_attribute *bfad_im_host_attrs[];
-extern struct device_attribute *bfad_im_vport_attrs[];
+extern const struct attribute_group *bfad_im_host_groups[];
+extern const struct attribute_group *bfad_im_vport_groups[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
