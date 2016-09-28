From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v3 6/7] sd: Implement support for ZBC devices
Date: Wed, 28 Sep 2016 10:22:36 +0900
Message-ID: <1475025757-6340-7-git-send-email-damien.lemoal@hgst.com>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Implement ZBC support functions to setup zoned disks, both
host-managed and host-aware models. Only zoned disks that satisfy
the following conditions are supported:
1) All zones are the same size, with the exception of an eventual
   last smaller runt zone.
2) For host-managed disks, reads are unrestricted (reads are not
   failed due to zone or write pointer alignement constraints).
Zoned disks that do not satisfy these 2 conditions will be ignored.

The capacity read of the device triggers the zoned block device
checks. As this needs the zone model of the disk, the call to
sd_read_capacity is moved after the call to
sd_read_block_characteristics so that host-aware devices are
properlly detected and initialized. The call to sd_zbc_read_zones
in sd_read_capacity may change the device capacity obtained with
the sd_read_capacity_16 function for devices reporting only the
capacity of conventional zones at the beginning of the LBA range
(i.e. devices with rc_basis set to 0).

Signed-off-by: Hannes Reinecke <hare@suse.de>

[Damien: * Removed zone cache support
         * Removed mapping of discard to reset write pointer command
         * Modified sd_zbc_read_zones to include checks that the
           device satisfies the kernel constraints
         * Implemeted REPORT ZONES setup and post-processing based
           on code from Shaun Tancheff <shaun.tancheff@seagate.com>]
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 drivers/scsi/Makefile     |   1 +
 drivers/scsi/sd.c         |  97 ++++++--
 drivers/scsi/sd.h         |  67 ++++++
 drivers/scsi/sd_zbc.c     | 586 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |  17 ++
 5 files changed, 754 insertions(+), 14 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.c

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index fc0d9b8..350513c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -180,6 +180,7 @@ hv_storvsc-y			:= storvsc_drv.o
 
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
+sd_mod-$(CONFIG_BLK_DEV_ZONED) += sd_zbc.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 51e5629..4b3523b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -93,6 +93,7 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -163,7 +164,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -262,7 +263,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -392,6 +393,11 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (sd_is_zoned(sdkp)) {
+		sd_config_discard(sdkp, SD_LBP_DISABLE);
+		return count;
+	}
+
 	if (sdp->type != TYPE_DISK)
 		return -EINVAL;
 
@@ -459,7 +465,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -844,6 +850,13 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
+	if (sd_is_zoned(sdkp)) {
+		/* sd_zbc_setup_read_write uses block layer sector units */
+		ret = sd_zbc_setup_read_write(sdkp, rq, sector, nr_sectors);
+		if (ret != BLKPREP_OK)
+			return ret;
+	}
+
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
@@ -963,6 +976,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
+	if (sd_is_zoned(sdkp)) {
+		/* sd_zbc_setup_read_write uses block layer sector units */
+		ret = sd_zbc_setup_read_write(sdkp, rq, block, this_count);
+		if (ret != BLKPREP_OK)
+			goto out;
+	}
+
 	/*
 	 * If we have a 1K hardware sectorsize, prevent access to single
 	 * 512 byte sectors.  In theory we could handle this - in fact
@@ -1149,6 +1169,10 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
+	case REQ_OP_ZONE_REPORT:
+		return sd_zbc_setup_report_cmnd(cmd);
+	case REQ_OP_ZONE_RESET:
+		return sd_zbc_setup_reset_cmnd(cmd);
 	default:
 		BUG();
 	}
@@ -1780,7 +1804,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if (req_op(req) == REQ_OP_DISCARD || req_op(req) == REQ_OP_WRITE_SAME) {
+	switch (req_op(req)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_ZONE_RESET:
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
@@ -1788,6 +1815,17 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = 0;
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
+		break;
+	case REQ_OP_ZONE_REPORT:
+		if (!result) {
+			good_bytes = scsi_bufflen(SCpnt)
+				- scsi_get_resid(SCpnt);
+			scsi_set_resid(SCpnt, 0);
+		} else {
+			good_bytes = 0;
+			scsi_set_resid(SCpnt, blk_rq_bytes(req));
+		}
+		break;
 	}
 
 	if (result) {
@@ -1848,7 +1886,11 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	default:
 		break;
 	}
+
  out:
+	if (sd_is_zoned(sdkp))
+		sd_zbc_complete(SCpnt, good_bytes, &sshdr);
+
 	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
 					   "sd_done: completed %d of %d bytes\n",
 					   good_bytes, scsi_bufflen(SCpnt)));
@@ -1983,7 +2025,6 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	}
 }
 
-
 /*
  * Determine whether disk supports Data Integrity Field.
  */
@@ -2133,6 +2174,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	/* Logical blocks per physical block exponent */
 	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
+	/* RC basis */
+	sdkp->rc_basis = (buffer[12] >> 4) & 0x3;
+
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
 	blk_queue_alignment_offset(sdp->request_queue, alignment);
@@ -2323,6 +2367,13 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 		sector_size = 512;
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
+	blk_queue_physical_block_size(sdp->request_queue,
+				      sdkp->physical_block_size);
+	sdkp->device->sector_size = sector_size;
+
+	if (sd_zbc_read_zones(sdkp, buffer) < 0)
+		/* The drive zone layout could not be checked */
+		sdkp->capacity = 0;
 
 	{
 		char cap_str_2[10], cap_str_10[10];
@@ -2349,9 +2400,6 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	blk_queue_physical_block_size(sdp->request_queue,
-				      sdkp->physical_block_size);
-	sdkp->device->sector_size = sector_size;
 }
 
 /* called with buffer of length 512 */
@@ -2613,7 +2661,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -2720,6 +2768,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
+	struct request_queue *q = sdkp->disk->queue;
 	unsigned char *buffer;
 	u16 rot;
 	const int vpd_len = 64;
@@ -2734,10 +2783,21 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1) {
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
-		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
+	sdkp->zoned = (buffer[8] >> 4) & 3;
+	if (sdkp->zoned == 1)
+		q->limits.zoned = BLK_ZONED_HA;
+	else if (sdkp->device->type == TYPE_ZBC)
+		q->limits.zoned = BLK_ZONED_HM;
+	else
+		q->limits.zoned = BLK_ZONED_NONE;
+	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
+		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+
  out:
 	kfree(buffer);
 }
@@ -2836,14 +2896,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
-
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
 
+		sd_read_capacity(sdkp, buffer);
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
@@ -3041,9 +3101,16 @@ static int sd_probe(struct device *dev)
 
 	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK &&
+	    sdp->type != TYPE_ZBC &&
+	    sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC)
 		goto out;
 
+#ifndef CONFIG_BLK_DEV_ZONED
+	if (sdp->type == TYPE_ZBC)
+		goto out;
+#endif
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
 					"sd_probe\n"));
 
@@ -3147,6 +3214,8 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	sd_zbc_remove(sdkp);
+
 	blk_register_region(devt, SD_MINORS, NULL,
 			    sd_default_probe, NULL, NULL);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index c8d9863..0ba47c1 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -64,6 +64,15 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
+#ifdef CONFIG_BLK_DEV_ZONED
+	unsigned int	nr_zones;
+	sector_t	zone_sectors;
+	unsigned int	zone_shift;
+	unsigned long	*zones_wlock;
+	unsigned int	zones_optimal_open;
+	unsigned int	zones_optimal_nonseq;
+	unsigned int	zones_max_open;
+#endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
@@ -94,6 +103,9 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	rc_basis: 2;
+	unsigned	zoned: 2;
+	unsigned	urswrz : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
@@ -156,6 +168,11 @@ static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t b
 	return blocks * sdev->sector_size;
 }
 
+static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sector)
+{
+	return sector >> (ilog2(sdev->sector_size) - 9);
+}
+
 /*
  * Look up the DIX operation based on whether the command is read or
  * write and whether dix and dif are enabled.
@@ -239,4 +256,54 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+static inline int sd_is_zoned(struct scsi_disk *sdkp)
+{
+	return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
+}
+
+#ifdef CONFIG_BLK_DEV_ZONED
+
+extern int sd_zbc_read_zones(struct scsi_disk *, unsigned char *);
+extern void sd_zbc_remove(struct scsi_disk *);
+extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
+				   sector_t, unsigned int);
+extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *);
+extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *);
+extern void sd_zbc_complete(struct scsi_cmnd *, unsigned int,
+			    struct scsi_sense_hdr *);
+
+#else /* CONFIG_BLK_DEV_ZONED */
+
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
+				    unsigned char *buf)
+{
+	return 0;
+}
+
+static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
+
+static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
+					  struct request *rq, sector_t sector,
+					  unsigned int num_sectors)
+{
+	/* Let the drive fail requests */
+	return BLKPREP_OK;
+}
+
+static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+
+static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+
+static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
+				   unsigned int good_bytes,
+				   struct scsi_sense_hdr *sshdr) {}
+
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
new file mode 100644
index 0000000..2680f51
--- /dev/null
+++ b/drivers/scsi/sd_zbc.c
@@ -0,0 +1,586 @@
+/*
+ * SCSI Zoned Block commands
+ *
+ * Copyright (C) 2014-2015 SUSE Linux GmbH
+ * Written by: Hannes Reinecke <hare@suse.de>
+ * Modified by: Damien Le Moal <damien.lemoal@hgst.com>
+ * Modified by: Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/blkdev.h>
+
+#include <asm/unaligned.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
+
+#include "sd.h"
+#include "scsi_priv.h"
+
+enum zbc_zone_type {
+	ZBC_ZONE_TYPE_CONV = 0x1,
+	ZBC_ZONE_TYPE_SEQWRITE_REQ,
+	ZBC_ZONE_TYPE_SEQWRITE_PREF,
+	ZBC_ZONE_TYPE_RESERVED,
+};
+
+enum zbc_zone_cond {
+	ZBC_ZONE_COND_NO_WP,
+	ZBC_ZONE_COND_EMPTY,
+	ZBC_ZONE_COND_IMP_OPEN,
+	ZBC_ZONE_COND_EXP_OPEN,
+	ZBC_ZONE_COND_CLOSED,
+	ZBC_ZONE_COND_READONLY = 0xd,
+	ZBC_ZONE_COND_FULL,
+	ZBC_ZONE_COND_OFFLINE,
+};
+
+/**
+ * Convert a zone descriptor to a zone struct.
+ */
+static void sd_zbc_parse_report(struct scsi_disk *sdkp,
+				u8 *buf,
+				struct blk_zone *zone)
+{
+	struct scsi_device *sdp = sdkp->device;
+
+	memset(zone, 0, sizeof(struct blk_zone));
+
+	zone->type = buf[0] & 0x0f;
+	zone->cond = (buf[1] >> 4) & 0xf;
+	if (buf[1] & 0x01)
+		zone->reset = 1;
+	if (buf[1] & 0x02)
+		zone->non_seq = 1;
+
+	zone->len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
+	zone->start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
+	zone->wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
+	if (zone->type != ZBC_ZONE_TYPE_CONV &&
+	    zone->cond == ZBC_ZONE_COND_FULL)
+		zone->wp = zone->start + zone->len;
+}
+
+/**
+ * Issue a REPORT ZONES scsi command.
+ */
+static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
+			       unsigned int buflen, sector_t start_sector)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
+	unsigned char cmd[16];
+	unsigned int rep_len;
+	int result;
+
+	memset(cmd, 0, 16);
+	cmd[0] = ZBC_IN;
+	cmd[1] = ZI_REPORT_ZONES;
+	put_unaligned_be64(start_lba, &cmd[2]);
+	put_unaligned_be32(buflen, &cmd[10]);
+	memset(buf, 0, buflen);
+
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+				  buf, buflen, &sshdr,
+				  timeout, SD_MAX_RETRIES, NULL);
+	if (result) {
+		sd_printk(KERN_ERR, sdkp,
+			  "REPORT ZONES lba %llu failed with %d/%d\n",
+			  (unsigned long long)start_lba,
+			  host_byte(result), driver_byte(result));
+		return -EIO;
+	}
+
+	rep_len = get_unaligned_be32(&buf[0]);
+	if (rep_len < 64) {
+		sd_printk(KERN_ERR, sdkp,
+			  "REPORT ZONES report invalid length %u\n",
+			  rep_len);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t lba, sector = blk_rq_pos(rq);
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+	int ret;
+
+	WARN_ON(nr_bytes == 0);
+
+	if (!sd_is_zoned(sdkp))
+		/* Not a zoned device */
+		return BLKPREP_KILL;
+
+	ret = scsi_init_io(cmd);
+	if (ret != BLKPREP_OK)
+		return ret;
+
+	cmd->cmd_len = 16;
+	memset(cmd->cmnd, 0, cmd->cmd_len);
+	cmd->cmnd[0] = ZBC_IN;
+	cmd->cmnd[1] = ZI_REPORT_ZONES;
+	lba = sectors_to_logical(sdkp->device, sector);
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
+	/* Do partial report for speeding things up */
+	cmd->cmnd[14] = ZBC_REPORT_ZONE_PARTIAL;
+
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
+	cmd->sdb.length = nr_bytes;
+	cmd->transfersize = sdkp->device->sector_size;
+	cmd->allowed = 0;
+
+	/*
+	 * Report may return less bytes than requested. Make sure
+	 * to report completion on the entire initial request.
+	 */
+	rq->__data_len = nr_bytes;
+
+	return BLKPREP_OK;
+}
+
+static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
+					 unsigned int good_bytes)
+{
+	struct request *rq = scmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct sg_mapping_iter miter;
+	struct blk_zone_report_hdr hdr;
+	struct blk_zone zone;
+	unsigned int offset, bytes = 0;
+	unsigned long flags;
+	u8 *buf;
+
+	if (good_bytes < 64)
+		return;
+
+	memset(&hdr, 0, sizeof(struct blk_zone_report_hdr));
+
+	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
+		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+
+	local_irq_save(flags);
+	while (sg_miter_next(&miter) && bytes < good_bytes) {
+
+		buf = miter.addr;
+		offset = 0;
+
+		if (bytes == 0) {
+			/* Set the report header */
+			hdr.nr_zones = min_t(unsigned int,
+					 (good_bytes - 64) / 64,
+					 get_unaligned_be32(&buf[0]) / 64);
+			memcpy(buf, &hdr, sizeof(struct blk_zone_report_hdr));
+			offset += 64;
+			bytes += 64;
+		}
+
+		/* Parse zone descriptors */
+		while (offset < miter.length && hdr.nr_zones) {
+			WARN_ON(offset > miter.length);
+			buf = miter.addr + offset;
+			sd_zbc_parse_report(sdkp, buf, &zone);
+			memcpy(buf, &zone, sizeof(struct blk_zone));
+			offset += 64;
+			bytes += 64;
+			hdr.nr_zones--;
+		}
+
+		if (!hdr.nr_zones)
+			break;
+
+	}
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
+}
+
+int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int zone_no = sector >> sdkp->zone_shift;
+
+	if (!sd_is_zoned(sdkp))
+		/* Not a zoned device */
+		return BLKPREP_KILL;
+
+	if (sector & (sdkp->zone_sectors - 1))
+		/* Unaligned request */
+		return BLKPREP_KILL;
+
+	/* Do not allow concurrent reset and writes */
+	if (!test_and_set_bit(zone_no, sdkp->zones_wlock))
+		return BLKPREP_DEFER;
+
+	cmd->cmd_len = 16;
+	memset(cmd->cmnd, 0, cmd->cmd_len);
+	cmd->cmnd[0] = ZBC_OUT;
+	cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+	put_unaligned_be64(sectors_to_logical(sdkp->device, sector),
+			   &cmd->cmnd[2]);
+
+	rq->timeout = SD_TIMEOUT;
+	cmd->sc_data_direction = DMA_NONE;
+	cmd->transfersize = 0;
+	cmd->allowed = 0;
+
+	return BLKPREP_OK;
+}
+
+int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
+			    sector_t sector, unsigned int sectors)
+{
+	sector_t zone_ofst = sector & (sdkp->zone_sectors - 1);
+
+	/* Do not allow zone boundaries crossing */
+	if (zone_ofst + sectors > sdkp->zone_sectors)
+		return BLKPREP_KILL;
+
+	/*
+	 * Do not issue more than one write at a time per
+	 * zone. This solves write ordering problems due to
+	 * the unlocking of the request queue in the dispatch
+	 * path in the non scsi-mq case. For scsi-mq, this
+	 * also avoids potential write reordering when multiple
+	 * threads running on different CPUs write to the same
+	 * zone (with a synchronized sequential pattern).
+	 */
+	if (req_op(rq) == REQ_OP_WRITE ||
+	    req_op(rq) == REQ_OP_WRITE_SAME) {
+		unsigned int zone_no = sector >> sdkp->zone_shift;
+		if (!test_and_set_bit(zone_no, sdkp->zones_wlock))
+			return BLKPREP_DEFER;
+	}
+
+	return BLKPREP_OK;
+}
+
+void sd_zbc_complete(struct scsi_cmnd *cmd,
+		     unsigned int good_bytes,
+		     struct scsi_sense_hdr *sshdr)
+{
+	int result = cmd->result;
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	unsigned int zone_no;
+
+	switch (req_op(rq)) {
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_SAME:
+
+		if (result &&
+		    sshdr->sense_key == ILLEGAL_REQUEST &&
+		    sshdr->asc == 0x21)
+			/*
+			 * It is unlikely that retrying write requests failed
+			 * with any kind of alignement error will result in
+			 * success. So don't.
+			 */
+			cmd->allowed = 0;
+
+		/* Fallthru */
+
+	case REQ_OP_ZONE_RESET:
+
+		/* Unlock the zone */
+		zone_no = blk_rq_pos(rq) >> sdkp->zone_shift;
+		clear_bit_unlock(zone_no, sdkp->zones_wlock);
+		smp_mb__after_atomic();
+
+		if (result &&
+		    sshdr->sense_key == ILLEGAL_REQUEST &&
+		    sshdr->asc == 0x24)
+			/*
+			 * INVALID FIELD IN CDB error: Reset of a conventional
+			 * zone was attempted. Nothing to worry about,
+			 * so be quiet about the error.
+			 */
+			rq->cmd_flags |= REQ_QUIET;
+
+		break;
+
+	case REQ_OP_ZONE_REPORT:
+
+		if (!result)
+			sd_zbc_report_zones_complete(cmd, good_bytes);
+		break;
+
+	}
+}
+
+/**
+ * Read zoned block device characteristics (VPD page B6).
+ */
+static int sd_zbc_read_zoned_charateristics(struct scsi_disk *sdkp,
+					    unsigned char *buf)
+{
+
+	if (scsi_get_vpd_page(sdkp->device, 0xb6, buf, 64))
+		return -ENODEV;
+
+	if (sdkp->device->type != TYPE_ZBC) {
+		/* Host-aware */
+		sdkp->urswrz = 1;
+		sdkp->zones_optimal_open = get_unaligned_be64(&buf[8]);
+		sdkp->zones_optimal_nonseq = get_unaligned_be64(&buf[12]);
+		sdkp->zones_max_open = 0;
+	} else {
+		/* Host-managed */
+		sdkp->urswrz = buf[4] & 1;
+		sdkp->zones_optimal_open = 0;
+		sdkp->zones_optimal_nonseq = 0;
+		sdkp->zones_max_open = get_unaligned_be64(&buf[16]);
+	}
+
+	return 0;
+}
+
+/**
+ * Check reported capacity.
+ */
+static int sd_zbc_check_capacity(struct scsi_disk *sdkp,
+				 unsigned char *buf)
+{
+	sector_t lba;
+	int ret;
+
+	if (sdkp->rc_basis != 0)
+		return 0;
+
+	/* Do a report zone to get the maximum LBA to check capacity */
+	ret = sd_zbc_report_zones(sdkp, buf, SD_BUF_SIZE, 0);
+	if (ret)
+		return ret;
+
+	/* The max_lba field is the capacity of this device */
+	lba = get_unaligned_be64(&buf[8]);
+	if (lba + 1 > sdkp->capacity) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_WARNING, sdkp,
+				  "Changing capacity from %zu "
+				  "to max LBA+1 %llu\n",
+				  sdkp->capacity,
+				  (unsigned long long)lba + 1);
+		sdkp->capacity = lba + 1;
+	}
+
+	return 0;
+}
+
+#define SD_ZBC_BUF_SIZE 131072
+
+static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
+{
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	struct blk_zone zone;
+	sector_t sector = 0;
+	unsigned char *buf;
+	unsigned char *rec;
+	unsigned int buf_len;
+	unsigned int list_length;
+	int ret;
+	u8 same;
+
+	/* Get a buffer */
+	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Do a report zone to get the same field */
+	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
+	if (ret)
+		goto out;
+
+	same = buf[4] & 0x0f;
+	if (same > 0) {
+		unsigned char *rec = &buf[64];
+		sdkp->zone_sectors = logical_to_sectors(sdkp->device,
+						get_unaligned_be64(&rec[8]));
+		goto out;
+	}
+
+	/* Check the size of all zones */
+	sdkp->zone_sectors = (sector_t)-1;
+	do {
+
+		/* Parse REPORT ZONES header */
+		list_length = get_unaligned_be32(&buf[0]) + 64;
+		rec = buf + 64;
+		if (list_length < SD_ZBC_BUF_SIZE)
+			buf_len = list_length;
+		else
+			buf_len = SD_ZBC_BUF_SIZE;
+
+		/* Parse zone descriptors */
+		while (rec < buf + buf_len) {
+			sd_zbc_parse_report(sdkp, rec, &zone);
+			if (sdkp->zone_sectors == (sector_t)-1) {
+				sdkp->zone_sectors = zone.len;
+			} else if (sector + zone.len < capacity &&
+				   zone.len != sdkp->zone_sectors) {
+				sdkp->zone_sectors = 0;
+				goto out;
+			}
+			sector += zone.len;
+			rec += 64;
+		}
+
+		if (sector < capacity) {
+			ret = sd_zbc_report_zones(sdkp, buf,
+					SD_ZBC_BUF_SIZE, sector);
+			if (ret)
+				return ret;
+		}
+
+	} while (sector < capacity);
+
+out:
+	kfree(buf);
+
+	if (!sdkp->zone_sectors) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Devices with non constant zone "
+				  "size are not supported\n");
+		return -ENODEV;
+	}
+
+	if (!is_power_of_2(sdkp->zone_sectors)) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Devices with non power of 2 zone "
+				  "size are not supported\n");
+		return -ENODEV;
+	}
+
+	if ((sdkp->zone_sectors << 9) > UINT_MAX) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Zone size too large\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int sd_zbc_setup(struct scsi_disk *sdkp)
+{
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+
+	/* chunk_sectors indicates the zone size */
+	blk_queue_chunk_sectors(sdkp->disk->queue, sdkp->zone_sectors);
+	sdkp->zone_shift = ilog2(sdkp->zone_sectors);
+	sdkp->nr_zones = capacity >> sdkp->zone_shift;
+	if (capacity & (sdkp->zone_sectors - 1))
+		sdkp->nr_zones++;
+
+	if (!sdkp->zones_wlock) {
+		sdkp->zones_wlock = kzalloc(BITS_TO_LONGS(sdkp->nr_zones),
+					    GFP_KERNEL);
+		if (!sdkp->zones_wlock)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int sd_zbc_read_zones(struct scsi_disk *sdkp,
+		      unsigned char *buf)
+{
+	sector_t capacity;
+	int ret = 0;
+
+	if (!sd_is_zoned(sdkp))
+		/*
+		 * Device managed or normal SCSI disk,
+		 * no special handling required
+		 */
+		return 0;
+
+
+	/* Get zoned block device characteristics */
+	ret = sd_zbc_read_zoned_charateristics(sdkp, buf);
+	if (ret)
+		return ret;
+
+	/*
+	 * Check for unconstrained reads: host-managed devices with
+	 * constrained reads (drives failing read after write pointer)
+	 * are not supported.
+	 */
+	if (!sdkp->urswrz) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+			  "constrained reads devices are not supported\n");
+		return -ENODEV;
+	}
+
+	/* Check capacity */
+	ret = sd_zbc_check_capacity(sdkp, buf);
+	if (ret)
+		return ret;
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+
+	/*
+	 * Check zone size: only devices with a constant zone size (except
+	 * an eventual last runt zone) that is a power of 2 are supported.
+	 */
+	ret = sd_zbc_check_zone_size(sdkp);
+	if (ret)
+		return ret;
+
+	/* The drive satisfies the kernel restrictions: set it up */
+	ret = sd_zbc_setup(sdkp);
+	if (ret)
+		return ret;
+
+	if (sdkp->first_scan) {
+		if (sdkp->nr_zones * sdkp->zone_sectors == capacity)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u zones of %llu sectors\n",
+				  sdkp->nr_zones,
+				  (unsigned long long)sdkp->zone_sectors);
+		else
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u zones of %llu sectors "
+				  "+ 1 runt zone\n",
+				  sdkp->nr_zones - 1,
+				  (unsigned long long)sdkp->zone_sectors);
+	}
+
+	return 0;
+}
+
+void sd_zbc_remove(struct scsi_disk *sdkp)
+{
+	kfree(sdkp->zones_wlock);
+	sdkp->zones_wlock = NULL;
+}
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index d1defd1..6ba66e0 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -299,4 +299,21 @@ struct scsi_lun {
 #define SCSI_ACCESS_STATE_MASK        0x0f
 #define SCSI_ACCESS_STATE_PREFERRED   0x80
 
+/* Reporting options for REPORT ZONES */
+enum zbc_zone_reporting_options {
+	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
+	ZBC_ZONE_REPORTING_OPTION_EMPTY,
+	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_CLOSED,
+	ZBC_ZONE_REPORTING_OPTION_FULL,
+	ZBC_ZONE_REPORTING_OPTION_READONLY,
+	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
+	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
+	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
+	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
+};
+
+#define ZBC_REPORT_ZONE_PARTIAL 0x80
+
 #endif /* _SCSI_PROTO_H_ */
-- 
2.7.4

