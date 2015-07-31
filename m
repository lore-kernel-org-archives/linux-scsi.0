From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] libata: support host-aware ZAC devices
Date: Fri, 31 Jul 2015 15:02:08 +0200
Message-ID: <1438347728-106434-7-git-send-email-hare@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbGaNCY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:02:24 -0400
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>

Byte 69 bits 0:1 in the IDENTIFY DEVICE data indicate a
host-aware ZAC device.
And whenever we detect a ZAC-compatible device we should
be displaying the zoned block characteristics VPD page.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c | 33 +++++++++++++++++++++++++++++--
 include/linux/ata.h       |  1 +
 include/linux/libata.h    |  7 +++++++
 4 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index db5d9f7..d8c7bbc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -65,6 +65,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
 #include <linux/pm_runtime.h>
@@ -2165,6 +2166,54 @@ static void ata_dev_config_sense_reporting(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_config_zac(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned int err_mask;
+	u8 *identify_buf = ap->sector_buf;
+
+	dev->zac_zones_optimal_open = (u32)-1;
+	dev->zac_zones_optimal_nonseq = (u32)-1;
+	dev->zac_zones_max_open = (u32)-1;
+
+	/*
+	 * Always set the 'ZAC' flag for Host-managed devices.
+	 */
+	if (dev->class == ATA_DEV_ZAC)
+		dev->flags |= ATA_DFLAG_ZAC;
+	else if (ata_id_zoned_cap(dev->id) == 0x01)
+		/*
+		 * Check for host-aware devices.
+		 */
+		dev->flags |= ATA_DFLAG_ZAC;
+
+	if (!(dev->flags & ATA_DFLAG_ZAC))
+		return;
+
+	/*
+	 * Read IDENTIFY DEVICE data log, page 9 (Zoned-device information)
+	 */
+	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_ID_DEV_DATA,
+				     ATA_LOG_ZONED_INFORMATION,
+				     identify_buf, 1);
+	if (!err_mask) {
+		u64 zoned_cap, opt_open, opt_nonseq, max_open;
+
+		zoned_cap = get_unaligned_le64(&identify_buf[8]);
+		if ((zoned_cap >> 63))
+			dev->zac_zoned_cap = (zoned_cap & 1);
+		opt_open = get_unaligned_le64(&identify_buf[24]);
+		if ((opt_open >> 63))
+			dev->zac_zones_optimal_open = (u32)opt_open;
+		opt_nonseq = get_unaligned_le64(&identify_buf[32]);
+		if ((opt_nonseq >> 63))
+			dev->zac_zones_optimal_nonseq = (u32)opt_nonseq;
+		max_open = get_unaligned_le64(&identify_buf[40]);
+		if ((max_open >> 63))
+			dev->zac_zones_max_open = (u32)max_open;
+	}
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2388,6 +2437,7 @@ int ata_dev_configure(struct ata_device *dev)
 				}
 		}
 		ata_dev_config_sense_reporting(dev);
+		ata_dev_config_zac(dev);
 		dev->cdb_len = 16;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a5d1e74..984cef1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2046,6 +2046,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
  */
 static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 {
+	int num_pages;
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
@@ -2054,10 +2055,14 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
 		0xb2,	/* page 0xb2, thin provisioning page */
+		0xb6,	/* page 0xb6, zoned block device characteristics */
 	};
 
-	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
-	memcpy(rbuf + 4, pages, sizeof(pages));
+	num_pages = sizeof(pages);
+	if (!(args->dev->flags & ATA_DFLAG_ZAC))
+		num_pages--;
+	rbuf[3] = num_pages;	/* number of supported VPD pages */
+	memcpy(rbuf + 4, pages, num_pages);
 	return 0;
 }
 
@@ -2245,6 +2250,24 @@ static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
+{
+	/*
+	 * SCSI Zoned Block device characteristics VPD page:
+	 * ZBC rev 02 or later.
+	 */
+	rbuf[1] = 0xb6;
+	rbuf[3] = 0x3C;
+
+	if (args->dev->zac_zoned_cap & 1)
+		rbuf[4] |= 1;
+	put_unaligned_be32(args->dev->zac_zones_optimal_open, &rbuf[8]);
+	put_unaligned_be32(args->dev->zac_zones_optimal_nonseq, &rbuf[12]);
+	put_unaligned_be32(args->dev->zac_zones_max_open, &rbuf[16]);
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -3793,6 +3816,12 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		case 0xb2:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
 			break;
+		case 0xb6:
+			if (dev->flags & ATA_DFLAG_ZAC) {
+				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b6);
+				break;
+			}
+			/* Fallthrough */
 		default:
 			ata_scsi_invalid_field(cmd);
 			break;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 2d604ca..f607bf14 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -325,6 +325,7 @@ enum {
 	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
 	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
+	ATA_LOG_ZONED_INFORMATION = 0x09,
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
 	ATA_LOG_DEVSLP_SIZE	  = 0x08,
 	ATA_LOG_DEVSLP_MDAT	  = 0x00,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9cfbcd..d508cce 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -180,6 +180,7 @@ enum {
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
 	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
+	ATA_DFLAG_ZAC		= (1 << 29), /* ZAC device */
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -724,6 +725,12 @@ struct ata_device {
 	/* NCQ send and receive log subcommand support */
 	u8			ncq_send_recv_cmds[ATA_LOG_NCQ_SEND_RECV_SIZE];
 
+	/* ZAC zone configuration */
+	u32			zac_zoned_cap;
+	u32			zac_zones_optimal_open;
+	u32			zac_zones_optimal_nonseq;
+	u32			zac_zones_max_open;
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
-- 
1.8.5.2

