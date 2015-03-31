From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] libata: support host-aware ZAC devices
Date: Tue, 31 Mar 2015 10:52:43 +0200
Message-ID: <1427791963-90832-4-git-send-email-hare@suse.de>
References: <1427791963-90832-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1427791963-90832-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Byte 69 bits 0:1 in the IDENTIFY DEVICE data are proposed
to indicate a host-aware ZAC device.
And whenever we detect a ZAC-compatible device we should
be displaying the zoned block characteristics VPD page.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 17 +++++++++++++++++
 drivers/ata/libata-scsi.c | 43 +++++++++++++++++++++++++++++++++++++------
 include/linux/ata.h       |  5 +++++
 include/linux/libata.h    |  1 +
 4 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1882fd2..a3cad3c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2165,6 +2165,22 @@ static void ata_dev_config_sense_reporting(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_config_zac(struct ata_device *dev)
+{
+	/*
+	 * Always set the 'ZAC' flag for Host-managed devices.
+	 */
+	if (dev->class == ATA_DEV_ZAC) {
+		dev->flags |= ATA_DFLAG_ZAC;
+		return;
+	}
+	/*
+	 * Check for host-aware devices.
+	 */
+	if (ata_id_is_zac_host_aware(dev->id))
+		dev->flags |= ATA_DFLAG_ZAC;
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2388,6 +2404,7 @@ int ata_dev_configure(struct ata_device *dev)
 				}
 		}
 		ata_dev_config_sense_reporting(dev);
+		ata_dev_config_zac(dev);
 		dev->cdb_len = 16;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fb81343..1bedbfc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2019,7 +2019,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		0x60,	/* SPC-4 (no version claimed) */
 
 		0x60,
-		0x20,   /* ZBC (no version claimed) */
+		0x22,   /* ZBC r02 */
 	};
 
 	u8 hdr[] = {
@@ -2036,9 +2036,10 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (ata_id_removable(args->id))
 		hdr[1] |= (1 << 7);
 
-	if (args->dev->class == ATA_DEV_ZAC) {
-		hdr[0] = TYPE_ZBC;
+	if (args->dev->flags & ATA_DFLAG_ZAC) {
 		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
+		if (args->dev->class == ATA_DEV_ZAC)
+			hdr[0] = TYPE_ZBC;
 	}
 
 	memcpy(rbuf, hdr, sizeof(hdr));
@@ -2053,7 +2054,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (rbuf[32] == 0 || rbuf[32] == ' ')
 		memcpy(&rbuf[32], "n/a ", 4);
 
-	if (args->dev->class == ATA_DEV_ZAC)
+	if (args->dev->flags & ATA_DFLAG_ZAC)
 		memcpy(rbuf + 58, versions_zbc, sizeof(versions_zbc));
 	else
 		memcpy(rbuf + 58, versions, sizeof(versions));
@@ -2073,6 +2074,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
  */
 static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 {
+	int num_pages;
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
@@ -2081,10 +2083,14 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
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
 
@@ -2255,6 +2261,9 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	rbuf[4] = media_rotation_rate >> 8;
 	rbuf[5] = media_rotation_rate;
 	rbuf[7] = form_factor;
+	/* Set the 'ZONED' bit for ZAC drives */
+	if (args->dev->flags & ATA_DFLAG_ZAC)
+		rbuf[8] = 1 << 4;
 
 	return 0;
 }
@@ -2269,6 +2278,22 @@ static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
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
+	put_unaligned_be32((u32)-1, &rbuf[8]);
+	put_unaligned_be32((u32)-1, &rbuf[12]);
+	put_unaligned_be32((u32)-1, &rbuf[16]);
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -3819,6 +3844,12 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
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
index 6b2d2b5..f8cab27 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -889,6 +889,11 @@ static inline bool ata_id_is_ssd(const u16 *id)
 	return id[ATA_ID_ROT_SPEED] == 0x01;
 }
 
+static inline bool ata_id_is_zac_host_aware(const u16 *id)
+{
+	return (id[ATA_ID_ADDITIONAL_SUPP] & 0x3) == 0x1;
+}
+
 static inline bool ata_id_pio_need_iordy(const u16 *id, const u8 pio)
 {
 	/* CF spec. r4.1 Table 22 says no IORDY on PIO5 and PIO6. */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6b08cc1..ffef372 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -181,6 +181,7 @@ enum {
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
 	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
+	ATA_DFLAG_ZAC		= (1 << 29), /* ZAC device */
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
-- 
1.8.5.2

