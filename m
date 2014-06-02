From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: Implement 'ZBC' device type
Date: Mon,  2 Jun 2014 09:01:18 +0200
Message-ID: <1401692478-23557-4-git-send-email-hare@suse.de>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaFBHBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 03:01:22 -0400
In-Reply-To: <1401692478-23557-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

ZBC (zoned block command aka 'SMR drives') devices will have
a new device type 0x14 assigned by T10. So add the necessary
mappings to sd.c and make it an alias for ATA ZAC devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c |  8 +++++++-
 drivers/scsi/scsi.c       |  2 ++
 drivers/scsi/scsi_scan.c  |  1 +
 drivers/scsi/sd.c         | 16 ++++++++++------
 include/scsi/scsi.h       |  1 +
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 24be16d..49b0844 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1991,6 +1991,11 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (ata_id_removeable(args->id))
 		hdr[1] |= (1 << 7);
 
+	if (args->dev->class == ATA_DEV_ZAC) {
+		hdr[0] = TYPE_ZBC;
+		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
+	}
+
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
 	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
@@ -2198,7 +2203,8 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	rbuf[4] = media_rotation_rate >> 8;
 	rbuf[5] = media_rotation_rate;
 	rbuf[7] = form_factor;
-
+	if (args->dev->class == ATA_DEV_ZAC)
+		rbuf[8] |= 0x10;
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..d47db90 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -124,6 +124,8 @@ static const char *const scsi_device_types[] = {
 	"Bridge controller",
 	"Object storage   ",
 	"Automation/Drive ",
+	"Security Manager ",
+	"Direct-Access-ZBC",
 };
 
 /**
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e02b3aa..0788213 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -819,6 +819,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	case TYPE_COMM:
 	case TYPE_RAID:
 	case TYPE_OSD:
+	case TYPE_ZBC:
 		sdev->writeable = 1;
 		break;
 	case TYPE_ROM:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 321faf6..e147a78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -91,6 +91,7 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -148,7 +149,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -245,7 +246,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -375,7 +376,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP], 20))
@@ -442,7 +443,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -2497,7 +2498,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -2914,7 +2915,10 @@ static int sd_probe(struct device *dev)
 	int error;
 
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK &&
+	    sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC &&
+	    sdp->type != TYPE_ZBC)
 		goto out;
 
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 0a4edfe..e668eed 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -332,6 +332,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
 #define TYPE_OSD            0x11
+#define TYPE_ZBC            0x14    /* Zoned block device */
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.7.12.4

