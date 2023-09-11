Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE186EEB580
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbjIKECl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjIKECc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8613AD2;
        Sun, 10 Sep 2023 21:02:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C7AC433C8;
        Mon, 11 Sep 2023 04:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404947;
        bh=TspSqaHS71kaLMyWAuVhQ8iylk96zFAHCndJZ92DOps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZF1SDv+M+9HHrLAR8PYhKnjne8hcZ0WWOTwdrrFWF2PqJQ4JQrMm4p5XSBMGiM2V
         8bXn4mDfdmJktdQfIwuUORPm+0eDghAkmHzhz8df2LJzZ9XRU4axq3A996fR0IR9i0
         mgiT3s+LZvydYICeFztNXXDdE3LfVs8zfdBMjEJVYwzWnlv1kKL2QX+9wYUuOsZlkX
         MmexRpZwPsfbjEZHzLs8/Bj57C/k6QL6CluQ3A2UWJhYX5eTxuCXM5nzwRZ9XGxO+x
         kYrEguWa5lI9nUhgd4EMKOtJATUDgTBDFDrwGu7XKDXmoSC+1XDqV9/dm1Z6AJQbOR
         qbIrBj4rYStHQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
Date:   Mon, 11 Sep 2023 13:02:01 +0900
Message-ID: <20230911040217.253905-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no direct device ancestry defined between an ata_device and
its scsi device which prevents the power management code from correctly
ordering suspend and resume operations. Create such ancestry with the
ata device as the parent to ensure that the scsi device (child) is
suspended before the ata device and that resume handles the ata device
before the scsi device.

The parent-child (supplier-consumer) relationship is established between
the ata_port (parent) and the scsi device (child) with the function
device_add_link(). The parent used is not the ata_device as the PM
operations are defined per port and the status of all devices connected
through that port is controlled from the port operations.

The device link is established with the new function
ata_scsi_dev_alloc(). This function is used to define the ->slave_alloc
callback of the scsi host template of most drivers.

Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 46 ++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata.h      |  1 +
 drivers/ata/pata_macio.c  |  1 +
 drivers/ata/sata_mv.c     |  1 +
 drivers/ata/sata_nv.c     |  2 ++
 drivers/ata/sata_sil24.c  |  1 +
 include/linux/libata.h    |  3 +++
 7 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d3f28b82c97b..f63cf6e7332e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1089,6 +1089,45 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
+int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap)
+{
+	struct device_link *link;
+
+	ata_scsi_sdev_config(sdev);
+
+	/*
+	 * Create a link from the ata_port device to the scsi device to ensure
+	 * that PM does suspend/resume in the correct order: the scsi device is
+	 * consumer (child) and the ata port the supplier (parent).
+	 */
+	link = device_link_add(&sdev->sdev_gendev, &ap->tdev,
+			       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
+	if (!link) {
+		ata_port_err(ap, "Failed to create link to scsi device %s\n",
+			     dev_name(&sdev->sdev_gendev));
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/**
+ *	ata_scsi_slave_alloc - Early setup of SCSI device
+ *	@sdev: SCSI device to examine
+ *
+ *	This is called from scsi_alloc_sdev() when the scsi device
+ *	associated with an ATA device is scanned on a port.
+ *
+ *	LOCKING:
+ *	Defined by SCSI layer.  We don't really care.
+ */
+
+int ata_scsi_slave_alloc(struct scsi_device *sdev)
+{
+	return ata_scsi_dev_alloc(sdev, ata_shost_to_port(sdev->host));
+}
+EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -1105,14 +1144,11 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
-	int rc = 0;
-
-	ata_scsi_sdev_config(sdev);
 
 	if (dev)
-		rc = ata_scsi_dev_config(sdev, dev);
+		return ata_scsi_dev_config(sdev, dev);
 
-	return rc;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 6e7d352803bd..079981e7156a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -111,6 +111,7 @@ extern struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 extern int ata_scsi_add_hosts(struct ata_host *host,
 			      const struct scsi_host_template *sht);
 extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
+extern int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
 extern void ata_scsi_set_sense(struct ata_device *dev,
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 17f6ccee53c7..32968b4cf8e4 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -918,6 +918,7 @@ static const struct scsi_host_template pata_macio_sht = {
 	 * use 64K minus 256
 	 */
 	.max_segment_size	= MAX_DBDMA_SEG,
+	.slave_alloc		= ata_scsi_slave_alloc,
 	.slave_configure	= pata_macio_slave_config,
 	.sdev_groups		= ata_common_sdev_groups,
 	.can_queue		= ATA_DEF_QUEUE,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d105db5c7d81..353ac7b2f14a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -673,6 +673,7 @@ static const struct scsi_host_template mv6_sht = {
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.slave_alloc		= ata_scsi_slave_alloc,
 	.slave_configure	= ata_scsi_slave_config
 };
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0a0cee755bde..5428dc2ec5e3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -380,6 +380,7 @@ static const struct scsi_host_template nv_adma_sht = {
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
+	.slave_alloc		= ata_scsi_slave_alloc,
 	.slave_configure	= nv_adma_slave_config,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
@@ -391,6 +392,7 @@ static const struct scsi_host_template nv_swncq_sht = {
 	.can_queue		= ATA_MAX_QUEUE - 1,
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_alloc		= ata_scsi_slave_alloc,
 	.slave_configure	= nv_swncq_slave_config,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 142e70bfc498..e0b1b3625031 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -381,6 +381,7 @@ static const struct scsi_host_template sil24_sht = {
 	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.slave_alloc		= ata_scsi_slave_alloc,
 	.slave_configure	= ata_scsi_slave_config
 };
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 52d58b13e5ee..c8cfea386c16 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1144,6 +1144,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
+extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
@@ -1401,12 +1402,14 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
+	.slave_alloc		= ata_scsi_slave_alloc,		\
 	.slave_configure	= ata_scsi_slave_config
 
 #define ATA_SUBBASE_SHT_QD(drv_name, drv_qd)			\
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		= drv_qd,			\
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
+	.slave_alloc		= ata_scsi_slave_alloc,		\
 	.slave_configure	= ata_scsi_slave_config
 
 #define ATA_BASE_SHT(drv_name)					\
-- 
2.41.0

