Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180FCCE79D1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbjITNzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbjITNy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:54:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34526CF;
        Wed, 20 Sep 2023 06:54:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47279C433CC;
        Wed, 20 Sep 2023 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218087;
        bh=KS5mwNSH05Nw+PEMmIwiqGK/3WLD4r5ZjNuBVPh1ROQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr+EhyVumBNGbKt1KEHxYO6uqACIw6Gkih0tjOPwEEBJt4yAnioO4cjKFY5Ae255t
         sURdXTDEFsXJZAXpNErbB9FFgNEeZOoa0ZiLZqagodf9KzxS6H50d5ps+I1TMqAxDc
         Jwr3sD9k1E+BGyAjQC0L9swJN0vAymx+DuYMHGVquPg2uVs02T2P/7oLe2x+rG7t/F
         GGhIxwkj4fPiVx0E/ez1j7O5KudPjByYD3gS9Ly/dbbAzFQsW7SjiC+4+74YFpXCLu
         LO5FOIVFxnm8HZopK2JcpQnFWKfd0R+Im55LmrlBvfDQi5YuHVhr81b/EgvPZwKAvN
         vq65DGKZT/MGw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v4 03/23] ata: libata-scsi: link ata port and scsi device
Date:   Wed, 20 Sep 2023 22:54:19 +0900
Message-ID: <20230920135439.929695-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 49 +++++++++++++++++++++++++++++++++++----
 drivers/ata/libata.h      |  1 +
 include/linux/libata.h    |  2 ++
 3 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fb73c145b49a..f420b65d3331 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1089,6 +1089,46 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
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
+			       DL_FLAG_STATELESS |
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
@@ -1105,14 +1145,11 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
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
 
@@ -1136,6 +1173,8 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 	unsigned long flags;
 	struct ata_device *dev;
 
+	device_link_remove(&sdev->sdev_gendev, &ap->tdev);
+
 	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
 	if (dev && dev->sdev) {
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
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bf4913f4d7ac..4ece1b7a2a5b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1148,6 +1148,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
+extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
@@ -1396,6 +1397,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\
 	.proc_name		= drv_name,			\
+	.slave_alloc		= ata_scsi_slave_alloc,		\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
 	.unlock_native_capacity	= ata_scsi_unlock_native_capacity,\
-- 
2.41.0

