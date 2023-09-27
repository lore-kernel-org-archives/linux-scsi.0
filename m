Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F007DE80AB1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjI0OSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjI0OSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:18:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B128FC;
        Wed, 27 Sep 2023 07:18:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6FBC433C7;
        Wed, 27 Sep 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824316;
        bh=6/gHyN2ekZWWjPRG6Y55Waf1Y/Wfg30IYpSFTS1WmfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXYzbgsAArvIoE4FFsELDrZwt/fzgED19S+YHwxS9k4IYFMRof467jjxVEGrMnL/Y
         hOO1337Gt5RZTD8vfQFclAtc+pySEdJAOkIDd7KUrelbhWjx2iOvt6tpU6Ymnnj3wY
         kgZ/URY1x/ZrpRYadYzHDaJ5pLP3dVFti2nx+DPquj/P8kO/hKEPdXWOszxu/1KB0v
         xvHmQRwtD4a9VyaJJ4YS7Jrl6DQigK+NG5DYJAF+w/IW1dkmX3Es+6CJNaJW82x1OH
         at+c14ZOYEkVQucikFNxRbJ/jU+vqE7kndUyJJ3lGomUddxUTb3fEQB8kQf0AZYF5g
         GMfn4ImoR4aRQ==
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
Subject: [PATCH v8 03/23] ata: libata-scsi: link ata port and scsi device
Date:   Wed, 27 Sep 2023 23:18:08 +0900
Message-ID: <20230927141828.90288-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
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
ata_scsi_slave_alloc(), and this function is used to define the
->slave_alloc callback of the scsi host template of all ata drivers.

Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/libata-scsi.c | 45 ++++++++++++++++++++++++++++++++++-----
 include/linux/libata.h    |  2 ++
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fb73c145b49a..8b43290ca2cd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1089,6 +1089,42 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
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
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
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
+EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -1105,14 +1141,11 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
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
 
@@ -1136,6 +1169,8 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 	unsigned long flags;
 	struct ata_device *dev;
 
+	device_link_remove(&sdev->sdev_gendev, &ap->tdev);
+
 	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
 	if (dev && dev->sdev) {
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

