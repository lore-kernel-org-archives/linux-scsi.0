From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] sd: Implement support for ZBC devices
Date: Mon,  4 Apr 2016 12:00:20 +0200
Message-ID: <1459764020-126038-10-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbcDDKAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:46 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Implement ZBC support functions to read in the zone information
and setup the zone tree.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig  |   8 +
 drivers/scsi/Makefile |   1 +
 drivers/scsi/sd.c     | 120 +++++++++++++--
 drivers/scsi/sd.h     |  41 +++++
 drivers/scsi/sd_zbc.c | 411 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 570 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 0950567..4c6cdc2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -201,6 +201,14 @@ config SCSI_ENCLOSURE
 	  it has an enclosure device.  Selecting this option will just allow
 	  certain enclosure conditions to be reported and is not required.
 
+config SCSI_ZBC
+	bool "SCSI ZBC (zoned block commands) Support"
+	depends on SCSI && BLK_DEV_ZONED
+	help
+	  Enable support for ZBC (zoned block commands) devices.
+
+	  If unsure say N.
+
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size += 36K)"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 862ab4e..49bde97 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -178,6 +178,7 @@ hv_storvsc-y			:= storvsc_drv.o
 
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
+sd_mod-$(CONFIG_SCSI_ZBC) += sd_zbc.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9220c66..ad7efbc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -92,6 +92,7 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -162,7 +163,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -261,7 +262,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -392,7 +393,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdkp->zoned == 1) {
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
 		if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
 			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 			return count;
@@ -466,7 +467,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -728,6 +729,10 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	int ret = 0;
 	char *buf;
 	struct page *page = NULL;
+#ifdef CONFIG_SCSI_ZBC
+	struct blk_zone *zone;
+	unsigned long flags;
+#endif
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
@@ -777,6 +782,52 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		break;
 
 	case SD_ZBC_RESET_WP:
+#ifdef CONFIG_SCSI_ZBC
+		zone = blk_lookup_zone(rq->q, sector);
+		if (!zone) {
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+		spin_lock_irqsave(&zone->lock, flags);
+		if (zone->state == BLK_ZONE_BUSY) {
+			sd_printk(KERN_INFO, sdkp,
+				  "Discarding busy zone %zu/%zu\n",
+				  zone->start, zone->len);
+			spin_unlock_irqrestore(&zone->lock, flags);
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+		if (!blk_zone_is_smr(zone)) {
+			sd_printk(KERN_INFO, sdkp,
+				  "Discarding %s zone %zu/%zu\n",
+				  blk_zone_is_cmr(zone) ? "CMR" : "unknown",
+				  zone->start, zone->len);
+			spin_unlock_irqrestore(&zone->lock, flags);
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+		if (blk_zone_is_empty(zone)) {
+			spin_unlock_irqrestore(&zone->lock, flags);
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+		if (zone->start != sector ||
+		    zone->len < nr_sectors) {
+			sd_printk(KERN_INFO, sdkp,
+				  "Misaligned RESET WP, start %zu/%zu "
+				  "len %zu/%u\n",
+				  zone->start, sector, zone->len, nr_sectors);
+			spin_unlock_irqrestore(&zone->lock, flags);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+		/*
+		 * Opportunistic setting, needs to be fixed up
+		 * if RESET WRITE POINTER fails.
+		 */
+		zone->wp = zone->start;
+		spin_unlock_irqrestore(&zone->lock, flags);
+#endif
 		cmd->cmd_len = 16;
 		cmd->cmnd[0] = ZBC_OUT;
 		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
@@ -990,6 +1041,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
+		/* sd_zbc_lookup_zone lba is in block layer sector units */
+		ret = sd_zbc_lookup_zone(sdkp, rq, block, this_count);
+		if (ret != BLKPREP_OK)
+			goto out;
+	}
+
 	/*
 	 * If we have a 1K hardware sectorsize, prevent access to single
 	 * 512 byte sectors.  In theory we could handle this - in fact
@@ -1804,6 +1862,13 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
 		} else {
+#ifdef CONFIG_SCSI_ZBC
+			if (op == ZBC_OUT)
+				/* RESET WRITE POINTER failed */
+				sd_zbc_update_zones(sdkp,
+						    blk_rq_pos(req),
+						    512, true);
+#endif
 			good_bytes = 0;
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
@@ -1867,6 +1932,26 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 				}
 			}
 		}
+		if (sshdr.asc == 0x21) {
+			/*
+			 * ZBC: read beyond the write pointer position.
+			 * Clear out error and return the buffer as-is.
+			 */
+			if (sshdr.ascq == 0x06) {
+				good_bytes = blk_rq_bytes(req);
+				scsi_set_resid(SCpnt, 0);
+			}
+#ifdef CONFIG_SCSI_ZBC
+			/*
+			 * ZBC: Unaligned write command.
+			 * Write did not start a write pointer position.
+			 */
+			if (sshdr.ascq == 0x04)
+				sd_zbc_update_zones(sdkp,
+						    blk_rq_pos(req),
+						    512, true);
+#endif
+		}
 		break;
 	default:
 		break;
@@ -2006,9 +2091,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	}
 }
 
-static int
-sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
-		    unsigned char *buffer, int bufflen )
+int sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
+			unsigned char *buffer, int bufflen )
 {
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
@@ -2095,8 +2179,11 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	u8 same;
 	u64 zone_len, lba;
 
-	if (sdkp->zoned != 1)
-		/* Device managed, no special handling required */
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		/*
+		 * Device managed or normal SCSI disk,
+		 * no special handling required
+		 */
 		return;
 
 	retval = sd_zbc_report_zones(sdkp, 0, buffer, SD_BUF_SIZE);
@@ -2137,6 +2224,8 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	zone_len = logical_to_sectors(sdkp->device,
 				      get_unaligned_be64(&desc[8]));
 	blk_queue_chunk_sectors(sdkp->disk->queue, zone_len);
+
+	sd_zbc_setup(sdkp, buffer, SD_BUF_SIZE);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
@@ -2732,7 +2821,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -3179,9 +3268,16 @@ static int sd_probe(struct device *dev)
 
 	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK &&
+	    sdp->type != TYPE_ZBC &&
+	    sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC)
 		goto out;
 
+#ifndef CONFIG_SCSI_ZBC
+	if (sdp->type == TYPE_ZBC)
+		goto out;
+#endif
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
 					"sd_probe\n"));
 
@@ -3285,6 +3381,8 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	sd_zbc_remove(sdkp);
+
 	blk_register_region(devt, SD_MINORS, NULL,
 			    sd_default_probe, NULL, NULL);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5debd49..35c75fa 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -65,6 +65,12 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
+#ifdef CONFIG_SCSI_ZBC
+	struct workqueue_struct *zone_work_q;
+	unsigned long	zone_flags;
+#define SD_ZBC_ZONE_RESET 1
+#define SD_ZBC_ZONE_INIT  2
+#endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
@@ -154,6 +160,11 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
 
+static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sector)
+{
+	return sector >> (ilog2(sdev->sector_size) - 9);
+}
+
 /*
  * A DIF-capable target device can be formatted with different
  * protection schemes.  Currently 0 through 3 are defined:
@@ -267,4 +278,34 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_SCSI_ZBC
+
+extern int sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
+			       unsigned char *buffer, int bufflen );
+extern int sd_zbc_setup(struct scsi_disk *, char *, int);
+extern void sd_zbc_remove(struct scsi_disk *);
+extern void sd_zbc_reset_zones(struct scsi_disk *);
+extern int sd_zbc_lookup_zone(struct scsi_disk *, struct request *,
+			      sector_t, unsigned int);
+extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, bool);
+extern void sd_zbc_refresh_zone_work(struct work_struct *);
+
+#else /* CONFIG_SCSI_ZBC */
+
+static inline int sd_zbc_setup(struct scsi_disk *sdkp,
+			       unsigned char *buf, int buf_len)
+{
+	return 0;
+}
+
+static inline int sd_zbc_lookup_zone(struct scsi_disk *sdkp,
+				     struct request *rq, sector_t sector,
+				     unsigned int num_sectors)
+{
+	return BLKPREP_OK;
+}
+
+static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
+#endif /* CONFIG_SCSI_ZBC */
+
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
new file mode 100644
index 0000000..9d8221c
--- /dev/null
+++ b/drivers/scsi/sd_zbc.c
@@ -0,0 +1,411 @@
+/*
+ * sd_zbc.c - SCSI Zoned Block commands
+ *
+ * Copyright (C) 2014-2015 SUSE Linux GmbH
+ * Written by: Hannes Reinecke <hare@suse.de>
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
+#include <linux/rbtree.h>
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
+enum zbc_zone_cond {
+	ZBC_ZONE_COND_NO_WP,
+	ZBC_ZONE_COND_EMPTY,
+	ZBC_ZONE_COND_IMPLICIT_OPEN,
+	ZBC_ZONE_COND_EXPLICIT_OPEN,
+	ZBC_ZONE_COND_CLOSED,
+	ZBC_ZONE_COND_READONLY = 0xd,
+	ZBC_ZONE_COND_FULL,
+	ZBC_ZONE_COND_OFFLINE,
+};
+
+#define SD_ZBC_BUF_SIZE 524288
+
+#undef SD_ZBC_DEBUG
+
+struct zbc_update_work {
+	struct work_struct zone_work;
+	struct scsi_disk *sdkp;
+	spinlock_t	zone_lock;
+	sector_t	zone_sector;
+	int		zone_buflen;
+	char		zone_buf[0];
+};
+
+struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
+{
+	struct blk_zone *zone;
+	enum zbc_zone_cond zone_cond;
+	sector_t wp = (sector_t)-1;
+
+	zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
+	if (!zone)
+		return NULL;
+
+	spin_lock_init(&zone->lock);
+	zone->type = rec[0] & 0xf;
+	zone_cond = (rec[1] >> 4) & 0xf;
+	zone->len = logical_to_sectors(sdkp->device,
+				       get_unaligned_be64(&rec[8]));
+	zone->start = logical_to_sectors(sdkp->device,
+					 get_unaligned_be64(&rec[16]));
+
+	if (blk_zone_is_smr(zone)) {
+		wp = logical_to_sectors(sdkp->device,
+					get_unaligned_be64(&rec[24]));
+		if (zone_cond == ZBC_ZONE_COND_READONLY) {
+			zone->state = BLK_ZONE_READONLY;
+		} else if (zone_cond == ZBC_ZONE_COND_OFFLINE) {
+			zone->state = BLK_ZONE_OFFLINE;
+		} else {
+			zone->state = BLK_ZONE_OPEN;
+		}
+	} else
+		zone->state = BLK_ZONE_NO_WP;
+
+	zone->wp = wp;
+	/*
+	 * Fixup block zone state
+	 */
+	if (zone_cond == ZBC_ZONE_COND_EMPTY &&
+	    zone->wp != zone->start) {
+#ifdef SD_ZBC_DEBUG
+		sd_printk(KERN_INFO, sdkp,
+			  "zone %zu state EMPTY wp %zu: adjust wp\n",
+			  zone->start, zone->wp);
+#endif
+		zone->wp = zone->start;
+	}
+	if (zone_cond == ZBC_ZONE_COND_FULL &&
+	    zone->wp != zone->start + zone->len) {
+#ifdef SD_ZBC_DEBUG
+		sd_printk(KERN_INFO, sdkp,
+			  "zone %zu state FULL wp %zu: adjust wp\n",
+			  zone->start, zone->wp);
+#endif
+		zone->wp = zone->start + zone->len;
+	}
+
+	return zone;
+}
+
+sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
+			 unsigned int buf_len)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned char *rec = buf;
+	int rec_no = 0;
+	unsigned int list_length;
+	sector_t next_sector = -1;
+	u8 same;
+
+	/* Parse REPORT ZONES header */
+	list_length = get_unaligned_be32(&buf[0]);
+	same = buf[4] & 0xf;
+	rec = buf + 64;
+	list_length += 64;
+
+	if (list_length < buf_len)
+		buf_len = list_length;
+
+	while (rec < buf + buf_len) {
+		struct blk_zone *this, *old;
+		unsigned long flags;
+
+		this = zbc_desc_to_zone(sdkp, rec);
+		if (!this)
+			break;
+
+		next_sector = this->start + this->len;
+		old = blk_insert_zone(q, this);
+		if (old) {
+			spin_lock_irqsave(&old->lock, flags);
+			if (blk_zone_is_smr(old)) {
+				old->wp = this->wp;
+				old->state = this->state;
+			}
+			spin_unlock_irqrestore(&old->lock, flags);
+			kfree(this);
+		}
+		rec += 64;
+		rec_no++;
+	}
+
+#ifdef SD_ZBC_DEBUG
+	sd_printk(KERN_INFO, sdkp,
+		  "Inserted %d zones, next sector %zu len %d\n",
+		  rec_no, next_sector, list_length);
+#endif
+	return next_sector;
+}
+
+void sd_zbc_refresh_zone_work(struct work_struct *work)
+{
+	struct zbc_update_work *zbc_work =
+		container_of(work, struct zbc_update_work, zone_work);
+	struct scsi_disk *sdkp = zbc_work->sdkp;
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned int zone_buflen;
+	int ret;
+	sector_t last_sector;
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	sector_t zone_lba = sectors_to_logical(sdkp->device,
+					       zbc_work->zone_sector);
+
+	zone_buflen = zbc_work->zone_buflen;
+	ret = sd_zbc_report_zones(sdkp, zone_lba, zbc_work->zone_buf,
+				  zone_buflen);
+	if (ret)
+		goto done_free;
+
+	last_sector = zbc_parse_zones(sdkp, zbc_work->zone_buf, zone_buflen);
+	if (last_sector != -1 && last_sector < capacity) {
+		if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
+#ifdef SD_ZBC_DEBUG
+			sd_printk(KERN_INFO, sdkp,
+				  "zones in reset, cancelling refresh\n");
+#endif
+			ret = -EAGAIN;
+			goto done_free;
+		}
+
+		zbc_work->zone_sector = last_sector;
+		queue_work(sdkp->zone_work_q, &zbc_work->zone_work);
+		/* Kick request queue to be on the safe side */
+		goto done_start_queue;
+	}
+done_free:
+	kfree(zbc_work);
+	if (test_and_clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags) && ret) {
+		sd_printk(KERN_INFO, sdkp,
+			  "Cancelling zone initialisation\n");
+	}
+done_start_queue:
+	if (q->mq_ops)
+		blk_mq_start_hw_queues(q);
+	else {
+		unsigned long flags;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+}
+
+void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
+			 bool update)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	struct zbc_update_work *zbc_work;
+	struct blk_zone *zone;
+	struct rb_node *node;
+	int zone_num = 0, zone_busy = 0, num_rec;
+	sector_t next_sector = sector;
+
+	if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
+		sd_printk(KERN_INFO, sdkp,
+			  "zones in reset, not starting update\n");
+		return;
+	}
+
+retry:
+	zbc_work = kzalloc(sizeof(struct zbc_update_work) + bufsize,
+			   GFP_KERNEL);
+	if (!zbc_work) {
+		if (bufsize > 512) {
+			sd_printk(KERN_INFO, sdkp,
+				  "retry with buffer size %d\n", bufsize);
+			bufsize = bufsize >> 1;
+			goto retry;
+		}
+		sd_printk(KERN_INFO, sdkp,
+			  "failed to allocate %d bytes\n", bufsize);
+		if (!update)
+			clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
+		return;
+	}
+	zbc_work->zone_sector = sector;
+	zbc_work->zone_buflen = bufsize;
+	zbc_work->sdkp = sdkp;
+	INIT_WORK(&zbc_work->zone_work, sd_zbc_refresh_zone_work);
+	num_rec = (bufsize / 64) - 1;
+
+	/*
+	 * Mark zones under update as BUSY
+	 */
+	if (update) {
+		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+			unsigned long flags;
+
+			zone = rb_entry(node, struct blk_zone, node);
+			if (num_rec == 0)
+				break;
+			if (zone->start != next_sector)
+				continue;
+			next_sector += zone->len;
+			num_rec--;
+
+			spin_lock_irqsave(&zone->lock, flags);
+			if (blk_zone_is_smr(zone)) {
+				if (zone->state == BLK_ZONE_BUSY) {
+					zone_busy++;
+				} else {
+					zone->state = BLK_ZONE_BUSY;
+					zone->wp = zone->start;
+				}
+				zone_num++;
+			}
+			spin_unlock_irqrestore(&zone->lock, flags);
+		}
+		if (zone_num && (zone_num == zone_busy)) {
+			sd_printk(KERN_INFO, sdkp,
+			  "zone update for %zu in progress\n", sector);
+			kfree(zbc_work);
+			return;
+		}
+	}
+
+	if (!queue_work(sdkp->zone_work_q, &zbc_work->zone_work)) {
+		sd_printk(KERN_INFO, sdkp,
+			  "zone update already queued?\n");
+		kfree(zbc_work);
+	}
+}
+
+int sd_zbc_lookup_zone(struct scsi_disk *sdkp, struct request *rq,
+		       sector_t sector, unsigned int num_sectors)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	struct blk_zone *zone = NULL;
+	int ret = BLKPREP_OK;
+	unsigned long flags;
+
+	zone = blk_lookup_zone(q, sector);
+	/* Might happen during zone initialization */
+	if (!zone) {
+#ifdef SD_ZBC_DEBUG
+		if (printk_ratelimit())
+			sd_printk(KERN_INFO, sdkp,
+				  "zone for sector %zu not found, skipping\n",
+				  sector);
+#endif
+		return BLKPREP_OK;
+	}
+	spin_lock_irqsave(&zone->lock, flags);
+	if (zone->state == BLK_ZONE_UNKNOWN ||
+	    zone->state == BLK_ZONE_BUSY) {
+		if (printk_ratelimit())
+			sd_printk(KERN_INFO, sdkp,
+				  "zone %zu state %x, deferring\n",
+				  zone->start, zone->state);
+		ret = BLKPREP_DEFER;
+	} else {
+		if (rq_data_dir(rq) == WRITE) {
+			if (zone->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+				goto out;
+			if (blk_zone_is_full(zone)) {
+#ifdef SD_ZBC_DEBUG
+				sd_printk(KERN_ERR, sdkp,
+					  "Write to full zone %zu/%zu\n",
+					  sector, zone->wp);
+#endif
+				ret = BLKPREP_KILL;
+				goto out;
+			}
+			if (zone->wp != sector) {
+#ifdef SD_ZBC_DEBUG
+				sd_printk(KERN_ERR, sdkp,
+					  "Misaligned write %zu/%zu\n",
+					  sector, zone->wp);
+#endif
+				ret = BLKPREP_KILL;
+				goto out;
+			}
+			zone->wp += num_sectors;
+		} else if (blk_zone_is_smr(zone) && (zone->wp <= sector)) {
+#ifdef SD_ZBC_DEBUG
+			sd_printk(KERN_INFO, sdkp,
+				    "Read beyond wp %zu/%zu\n",
+				    sector, zone->wp);
+#endif
+			ret = BLKPREP_DONE;
+		}
+	}
+out:
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return ret;
+}
+
+int sd_zbc_setup(struct scsi_disk *sdkp, char *buf, int buf_len)
+{
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	sector_t last_sector;
+
+	if (test_and_set_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags)) {
+		sdev_printk(KERN_WARNING, sdkp->device,
+			    "zone initialisation already running\n");
+		return 0;
+	}
+
+	if (!sdkp->zone_work_q) {
+		char wq_name[32];
+
+		sprintf(wq_name, "zbc_wq_%s", sdkp->disk->disk_name);
+		sdkp->zone_work_q = create_singlethread_workqueue(wq_name);
+		if (!sdkp->zone_work_q) {
+			sdev_printk(KERN_WARNING, sdkp->device,
+				    "create zoned disk workqueue failed\n");
+			return -ENOMEM;
+		}
+	} else if (!test_and_set_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
+		drain_workqueue(sdkp->zone_work_q);
+		clear_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags);
+	}
+
+	last_sector = zbc_parse_zones(sdkp, buf, buf_len);
+	if (last_sector != -1 && last_sector < capacity) {
+		sd_zbc_update_zones(sdkp, last_sector, SD_ZBC_BUF_SIZE, false);
+	} else
+		clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
+
+	return 0;
+}
+
+void sd_zbc_remove(struct scsi_disk *sdkp)
+{
+	if (sdkp->zone_work_q) {
+		if (!test_and_set_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags))
+			drain_workqueue(sdkp->zone_work_q);
+		clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
+		destroy_workqueue(sdkp->zone_work_q);
+	}
+}
-- 
1.8.5.6

