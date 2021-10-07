Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74711C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FE561130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhJGVVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:00 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:53953 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhJGVU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:20:59 -0400
Received: by mail-pj1-f48.google.com with SMTP id ls18so5900089pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8i7wrJKoNirhr+hHHb7KuJOmht99FU5BcbDnKqGMb5U=;
        b=fWPW7DZFlXgHiYSxnUQ+sSo7bdYnnY9rJ5z4d95QcQzkL6aCkq1vaYfQyAgcgufzP5
         tywEzlXPkOMDePivZzxGGVhIPQx15EefPxb2XxJ0QhxD0Z0IfJnZ9FPSjZGym9DPa+L1
         Xse9TFPRpsLQ5jV4wQRpAyzNAtbkkdozlY22ZyBPx2NB5ZHGMtgbv2g0p4CqtIez/uGt
         ZR/c1Oy21BQBhnfrDjLJ+DGoe3EHA0PhaGajYQhAxFlnhmgRNdez/T5VLuJY9RagGjeC
         JAAt+UtdTStIvPGzTVvOs9gAgNVbZO1bkB5vCsvPy2z0cHlsuibV96S4xYvIv/TPzJ/I
         AEiA==
X-Gm-Message-State: AOAM530hYhCGguSFW5SkutaGDDjydnXVS5zmYSUsGIx4W/Biag5elL0X
        At/AfRm9swrgsjFZ8iAHRnk=
X-Google-Smtp-Source: ABdhPJzsCc7WvUA8I+19phnE0rCpsPkHWf6fb6XyDzP2/lB/V5FMoLUQOkwxNJ+zhlRpa8Vg2G5MNQ==
X-Received: by 2002:a17:90a:4e43:: with SMTP id t3mr8061673pjl.163.1633641545093;
        Thu, 07 Oct 2021 14:19:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v2 02/46] ata: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:08 -0700
Message-Id: <20211007211852.256007-3-bvanassche@acm.org>
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
 drivers/ata/ahci.h        |  8 +++---
 drivers/ata/ata_piix.c    | 15 ++++++++---
 drivers/ata/libahci.c     | 52 ++++++++++++++++++++++++++-------------
 drivers/ata/libata-sata.c | 19 ++++++++++----
 drivers/ata/libata-scsi.c | 15 ++++++++---
 drivers/ata/pata_macio.c  |  2 +-
 drivers/ata/sata_mv.c     |  2 +-
 drivers/ata/sata_nv.c     |  4 +--
 drivers/ata/sata_sil24.c  |  2 +-
 include/linux/libata.h    |  8 +++---
 10 files changed, 86 insertions(+), 41 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2e89499bd9c3..ef77b6551382 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -376,8 +376,8 @@ struct ahci_host_priv {
 
 extern int ahci_ignore_sss;
 
-extern struct device_attribute *ahci_shost_attrs[];
-extern struct device_attribute *ahci_sdev_attrs[];
+extern const struct attribute_group *ahci_shost_attr_groups[];
+extern const struct attribute_group *ahci_sdev_attr_groups[];
 
 /*
  * This must be instantiated by the edge drivers.  Read the comments
@@ -388,8 +388,8 @@ extern struct device_attribute *ahci_sdev_attrs[];
 	.can_queue		= AHCI_MAX_CMDS,			\
 	.sg_tablesize		= AHCI_MAX_SG,				\
 	.dma_boundary		= AHCI_DMA_BOUNDARY,			\
-	.shost_attrs		= ahci_shost_attrs,			\
-	.sdev_attrs		= ahci_sdev_attrs,			\
+	.shost_groups		= ahci_shost_attr_groups,		\
+	.sdev_groups		= ahci_sdev_attr_groups,		\
 	.change_queue_depth     = ata_scsi_change_queue_depth,		\
 	.tag_alloc_policy       = BLK_TAG_ALLOC_RR,             	\
 	.slave_configure        = ata_scsi_slave_config
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3ca7720e7d8f..f845cee501e8 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1085,14 +1085,23 @@ static struct ata_port_operations ich_pata_ops = {
 	.set_dmamode		= ich_set_dmamode,
 };
 
-static struct device_attribute *piix_sidpr_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
+static struct attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_policy.attr,
+	NULL
+};
+
+static const struct attribute_group piix_sidpr_shost_attr_group = {
+	.attrs = piix_sidpr_shost_attrs
+};
+
+static const struct attribute_group *piix_sidpr_shost_groups[] = {
+	&piix_sidpr_shost_attr_group,
 	NULL
 };
 
 static struct scsi_host_template piix_sidpr_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
-	.shost_attrs		= piix_sidpr_shost_attrs,
+	.shost_groups		= piix_sidpr_shost_groups,
 };
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 5b3fa2cbe722..ebf990944054 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -108,28 +108,46 @@ static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);
 static DEVICE_ATTR(em_message_supported, S_IRUGO, ahci_show_em_supported, NULL);
 
-struct device_attribute *ahci_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
-	&dev_attr_em_message_type,
-	&dev_attr_em_message,
-	&dev_attr_ahci_host_caps,
-	&dev_attr_ahci_host_cap2,
-	&dev_attr_ahci_host_version,
-	&dev_attr_ahci_port_cmd,
-	&dev_attr_em_buffer,
-	&dev_attr_em_message_supported,
+static struct attribute *ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_policy.attr,
+	&dev_attr_em_message_type.attr,
+	&dev_attr_em_message.attr,
+	&dev_attr_ahci_host_caps.attr,
+	&dev_attr_ahci_host_cap2.attr,
+	&dev_attr_ahci_host_version.attr,
+	&dev_attr_ahci_port_cmd.attr,
+	&dev_attr_em_buffer.attr,
+	&dev_attr_em_message_supported.attr,
 	NULL
 };
-EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 
-struct device_attribute *ahci_sdev_attrs[] = {
-	&dev_attr_sw_activity,
-	&dev_attr_unload_heads,
-	&dev_attr_ncq_prio_supported,
-	&dev_attr_ncq_prio_enable,
+static const struct attribute_group ahci_shost_attr_group = {
+	.attrs = ahci_shost_attrs
+};
+
+const struct attribute_group *ahci_shost_attr_groups[] = {
+	&ahci_shost_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ahci_shost_attr_groups);
+
+struct attribute *ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity.attr,
+	&dev_attr_unload_heads.attr,
+	&dev_attr_ncq_prio_supported.attr,
+	&dev_attr_ncq_prio_enable.attr,
+	NULL
+};
+
+static const struct attribute_group ahci_sdev_attr_group = {
+	.attrs = ahci_sdev_attrs
+};
+
+const struct attribute_group *ahci_sdev_attr_groups[] = {
+	&ahci_sdev_attr_group,
 	NULL
 };
-EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
+EXPORT_SYMBOL_GPL(ahci_sdev_attr_groups);
 
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8f3ff830ab0c..0d332b40ec42 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -922,13 +922,22 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
 	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
 EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
 
-struct device_attribute *ata_ncq_sdev_attrs[] = {
-	&dev_attr_unload_heads,
-	&dev_attr_ncq_prio_enable,
-	&dev_attr_ncq_prio_supported,
+struct attribute *ata_ncq_sdev_attrs[] = {
+	&dev_attr_unload_heads.attr,
+	&dev_attr_ncq_prio_enable.attr,
+	&dev_attr_ncq_prio_supported.attr,
 	NULL
 };
-EXPORT_SYMBOL_GPL(ata_ncq_sdev_attrs);
+
+static const struct attribute_group ata_ncq_sdev_attr_group = {
+	.attrs = ata_ncq_sdev_attrs
+};
+
+const struct attribute_group *ata_ncq_sdev_attr_groups[] = {
+	&ata_ncq_sdev_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_ncq_sdev_attr_groups);
 
 static ssize_t
 ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1fb4611f7eeb..84c696960f4c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -234,11 +234,20 @@ static void ata_scsi_set_invalid_parameter(struct ata_device *dev,
 				     field, 0xff, 0);
 }
 
-struct device_attribute *ata_common_sdev_attrs[] = {
-	&dev_attr_unload_heads,
+static struct attribute *ata_common_sdev_attrs[] = {
+	&dev_attr_unload_heads.attr,
 	NULL
 };
-EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
+
+static const struct attribute_group ata_common_sdev_attr_group = {
+	.attrs = ata_common_sdev_attrs
+};
+
+const struct attribute_group *ata_common_sdev_attr_groups[] = {
+	&ata_common_sdev_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_common_sdev_attr_groups);
 
 /**
  *	ata_std_bios_param - generic bios head/sector/cylinder calculator used by sd.
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index be0ca8d5b345..a7a6a26175fe 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -923,7 +923,7 @@ static struct scsi_host_template pata_macio_sht = {
 	 */
 	.max_segment_size	= MAX_DBDMA_SEG,
 	.slave_configure	= pata_macio_slave_config,
-	.sdev_attrs		= ata_common_sdev_attrs,
+	.sdev_groups		= ata_common_sdev_attr_groups,
 	.can_queue		= ATA_DEF_QUEUE,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 };
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 9d86203e1e7a..35a97b7c2791 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -670,7 +670,7 @@ static struct scsi_host_template mv6_sht = {
 	.can_queue		= MV_MAX_Q_DEPTH - 1,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.dma_boundary		= MV_DMA_BOUNDARY,
-	.sdev_attrs             = ata_ncq_sdev_attrs,
+	.sdev_groups		= ata_ncq_sdev_attr_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.slave_configure	= ata_scsi_slave_config
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index c385d18ce87b..7ff1a2f30cea 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -380,7 +380,7 @@ static struct scsi_host_template nv_adma_sht = {
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
 	.slave_configure	= nv_adma_slave_config,
-	.sdev_attrs             = ata_ncq_sdev_attrs,
+	.sdev_groups		= ata_ncq_sdev_attr_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 };
@@ -391,7 +391,7 @@ static struct scsi_host_template nv_swncq_sht = {
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= nv_swncq_slave_config,
-	.sdev_attrs             = ata_ncq_sdev_attrs,
+	.sdev_groups		= ata_ncq_sdev_attr_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 };
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 06a1e27c4f84..ada0dbb9f703 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -379,7 +379,7 @@ static struct scsi_host_template sil24_sht = {
 	.sg_tablesize		= SIL24_MAX_SGE,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
-	.sdev_attrs		= ata_ncq_sdev_attrs,
+	.sdev_groups		= ata_ncq_sdev_attr_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.slave_configure	= ata_scsi_slave_config
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c0c64f03e107..6df8d0034d77 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1388,7 +1388,7 @@ extern int ata_link_nr_enabled(struct ata_link *link);
  */
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
-extern struct device_attribute *ata_common_sdev_attrs[];
+extern const struct attribute_group *ata_common_sdev_attr_groups[];
 
 /*
  * All sht initializers (BASE, PIO, BMDMA, NCQ) must be instantiated
@@ -1418,14 +1418,14 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 
 #define ATA_BASE_SHT(drv_name)					\
 	ATA_SUBBASE_SHT(drv_name),				\
-	.sdev_attrs		= ata_common_sdev_attrs
+	.sdev_groups		= ata_common_sdev_attr_groups
 
 #ifdef CONFIG_SATA_HOST
-extern struct device_attribute *ata_ncq_sdev_attrs[];
+extern const struct attribute_group *ata_ncq_sdev_attr_groups[];
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_SUBBASE_SHT(drv_name),				\
-	.sdev_attrs		= ata_ncq_sdev_attrs,		\
+	.sdev_groups		= ata_ncq_sdev_attr_groups,	\
 	.change_queue_depth	= ata_scsi_change_queue_depth
 #endif
 
