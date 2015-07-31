From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] sd: Implement support for ZBC devices
Date: Fri, 31 Jul 2015 15:36:20 +0200
Message-ID: <1438349780-116429-9-git-send-email-hare@suse.de>
References: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438349780-116429-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Implement ZBC support functions to read in the zone information
and setup the zone tree.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig  |   8 ++
 drivers/scsi/Makefile |   1 +
 drivers/scsi/sd.c     | 125 ++++++++++++++--
 drivers/scsi/sd.h     |  34 +++++
 drivers/scsi/sd_zbc.c | 390 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 547 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 456e1567..4135448 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -200,6 +200,14 @@ config SCSI_ENCLOSURE
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
 	bool "Verbose SCSI error reporting (kernel size +=75K)"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 91209e3..8893305 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -176,6 +176,7 @@ hv_storvsc-y			:= storvsc_drv.o
 
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
+sd_mod-$(CONFIG_SCSI_ZBC) += sd_zbc.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f909684..3f20f86 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -91,6 +91,7 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -161,7 +162,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -259,7 +260,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -390,7 +391,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdkp->zoned == 1) {
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
 		if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
 			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 			return count;
@@ -464,7 +465,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -713,6 +714,10 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	int ret = 0;
 	char *buf;
 	struct page *page = NULL;
+#ifdef CONFIG_SCSI_ZBC
+	struct blk_zone *zone;
+	unsigned long flags;
+#endif
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
@@ -762,6 +767,52 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
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
+				  "Discarding busy zone %llu/%llu\n",
+				  zone->start, zone->len);
+			spin_unlock_irqrestore(&zone->lock, flags);
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+		if (!blk_zone_is_smr(zone)) {
+			sd_printk(KERN_INFO, sdkp,
+				  "Discarding %s zone %llu/%llu\n",
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
+				  "Misaligned RESET WP, start %llu/%zu "
+				  "len %llu/%u\n",
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
@@ -1016,6 +1067,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 			this_count = this_count >> 3;
 		}
 	}
+
+	if (sdkp->zoned || sdp->type == TYPE_ZBC) {
+		ret = sd_zbc_lookup_zone(sdkp, rq, block, this_count);
+		if (ret != BLKPREP_OK)
+			goto out;
+	}
+
 	if (rq_data_dir(rq) == WRITE) {
 		SCpnt->cmnd[0] = WRITE_6;
 
@@ -1693,6 +1751,13 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
@@ -1756,6 +1821,26 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
@@ -1895,9 +1980,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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
@@ -2575,7 +2659,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -2768,14 +2852,18 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 {
+	struct scsi_device *sdp = sdkp->device;
 	int retval;
 	unsigned char *desc;
 	u32 rep_len;
 	u8 same;
 	u64 zone_len;
 
-	if (sdkp->zoned != 1)
-		/* Device managed, no special handling required */
+	if (sdkp->zoned != 1 && sdp->type != TYPE_ZBC)
+		/*
+		 * Device managed or normal SCSI disk,
+		 * no special handling required
+		 */
 		return;
 
 	retval = sd_zbc_report_zones(sdkp, 0, buffer, SD_BUF_SIZE);
@@ -2875,6 +2963,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	sdkp->first_scan = 0;
 
+	if (sdkp->zoned || sdp->type == TYPE_ZBC)
+		sd_zbc_setup(sdkp, buffer, SD_BUF_SIZE);
+
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
@@ -3047,9 +3138,16 @@ static int sd_probe(struct device *dev)
 
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
 
@@ -3153,6 +3251,8 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	sd_zbc_remove(sdkp);
+
 	blk_register_region(devt, SD_MINORS, NULL,
 			    sd_default_probe, NULL, NULL);
 
@@ -3183,6 +3283,9 @@ static void scsi_disk_release(struct device *dev)
 	spin_unlock(&sd_index_lock);
 
 	blk_integrity_unregister(disk);
+#ifdef CONFIG_SCSI_ZBC
+	drain_workqueue(sdkp->zone_work_q);
+#endif
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4edcf54..e911306 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -65,6 +65,10 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
+#ifdef CONFIG_SCSI_ZBC
+	struct workqueue_struct *zone_work_q;
+	atomic_t	zone_reset;
+#endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		max_xfer_blocks;
@@ -260,4 +264,34 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_SCSI_ZBC
+
+extern int sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
+			       unsigned char *buffer, int bufflen );
+extern int sd_zbc_setup(struct scsi_disk *, unsigned char *, int);
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
index 0000000..67f18cb
--- /dev/null
+++ b/drivers/scsi/sd_zbc.c
@@ -0,0 +1,390 @@
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
+#define SD_ZBC_BUF_SIZE 131072
+#define SD_ZBC_QUEUE_DELAY 5
+
+#undef SD_ZBC_DEBUG
+
+struct zbc_update_work {
+	struct work_struct zone_work;
+	struct scsi_disk *sdkp;
+	spinlock_t	zone_lock;
+	sector_t	zone_lba;
+	int		zone_buflen;
+	bool		zone_update;
+	char		zone_buf[0];
+};
+
+struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
+{
+	struct blk_zone *zone;
+	enum zbc_zone_cond zone_cond;
+	u64 wp = (u64)-1;
+
+	zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
+	if (!zone)
+		return NULL;
+
+	spin_lock_init(&zone->lock);
+	zone->type = rec[0] & 0xf;
+	zone_cond = (rec[1] >> 4) & 0xf;
+	zone->len = get_unaligned_be64(&rec[8]);
+	zone->start = get_unaligned_be64(&rec[16]);
+
+	if (blk_zone_is_smr(zone)) {
+		wp = get_unaligned_be64(&rec[24]);
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
+			  "zone %llu state EMPTY wp %llu: adjust wp\n",
+			  zone->start, zone->wp);
+#endif
+		zone->wp = zone->start;
+	}
+	if (zone_cond == ZBC_ZONE_COND_FULL &&
+	    zone->wp != zone->start + zone->len) {
+#ifdef SD_ZBC_DEBUG
+		sd_printk(KERN_INFO, sdkp,
+			  "zone %llu state FULL wp %llu: adjust wp\n",
+			  zone->start, zone->wp);
+#endif
+		zone->wp = zone->start + zone->len;
+	}
+
+	return zone;
+}
+
+sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
+			 unsigned int buf_len, sector_t start_lba)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned char *rec = buf;
+	int rec_no = 0;
+	unsigned int list_length;
+	sector_t next_lba = -1;
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
+		next_lba = this->start + this->len;
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
+		  "Inserted %d zones, next lba %zu len %d\n",
+		  rec_no, next_lba, list_length);
+#endif
+	return next_lba;
+}
+
+void sd_zbc_refresh_zone_work(struct work_struct *work)
+{
+	struct zbc_update_work *zbc_work =
+		container_of(work, struct zbc_update_work, zone_work);
+	struct request_queue *q = zbc_work->sdkp->disk->queue;
+	unsigned long flags;
+	unsigned int zone_buflen;
+	int ret;
+	sector_t last_lba;
+
+	zone_buflen = zbc_work->zone_buflen;
+	ret = sd_zbc_report_zones(zbc_work->sdkp, zbc_work->zone_lba,
+				  zbc_work->zone_buf, zone_buflen);
+	if (ret)
+		goto done_free;
+
+	last_lba = zbc_parse_zones(zbc_work->sdkp, zbc_work->zone_buf,
+				   zone_buflen, zbc_work->zone_lba);
+	if (last_lba != -1 && last_lba < zbc_work->sdkp->capacity &&
+	    !zbc_work->zone_update) {
+		if (atomic_read(&zbc_work->sdkp->zone_reset)) {
+			sd_printk(KERN_INFO, zbc_work->sdkp,
+				  "zones in reset, cancelling refresh\n");
+			goto done_free;
+		}
+
+		zbc_work->zone_lba = last_lba;
+		queue_work(zbc_work->sdkp->zone_work_q, &zbc_work->zone_work);
+		/* Kick request queue to be on the safe side */
+		goto done_start_queue;
+	}
+done_free:
+	kfree(zbc_work);
+done_start_queue:
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t lba, int bufsize,
+			 bool update)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	struct zbc_update_work *zbc_work;
+	struct blk_zone *zone;
+	struct rb_node *node;
+	int zone_num = 0, zone_busy = 0, num_rec;
+	sector_t next_lba = lba;
+
+	if (atomic_read(&sdkp->zone_reset)) {
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
+		return;
+	}
+	zbc_work->zone_lba = lba;
+	zbc_work->zone_buflen = bufsize;
+	zbc_work->zone_update = update;
+	zbc_work->sdkp = sdkp;
+	INIT_WORK(&zbc_work->zone_work, sd_zbc_refresh_zone_work);
+	num_rec = (bufsize / 64) - 1;
+
+	for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+		unsigned long flags;
+
+		zone = rb_entry(node, struct blk_zone, node);
+		if (update) {
+			if (num_rec == 0)
+				break;
+			if (zone->start != next_lba)
+				continue;
+			next_lba += zone->len;
+			num_rec--;
+		}
+		spin_lock_irqsave(&zone->lock, flags);
+		if (blk_zone_is_smr(zone)) {
+			if (zone->state == BLK_ZONE_BUSY) {
+				zone_busy++;
+			} else {
+				zone->state = BLK_ZONE_BUSY;
+				zone->wp = zone->start;
+			}
+			zone_num++;
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+	if (zone_num && (zone_num == zone_busy)) {
+		sd_printk(KERN_INFO, sdkp,
+			  "zone %s for %zu in progress\n",
+			  update ? "update" : "refresh", lba);
+		kfree(zbc_work);
+		return;
+	}
+
+	if (atomic_read(&sdkp->zone_reset)) {
+		sd_printk(KERN_INFO, sdkp,
+			  "zones in reset, not starting update\n");
+		kfree(zbc_work);
+		return;
+	}
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
+		if (printk_ratelimit())
+			sd_printk(KERN_INFO, sdkp,
+				  "zone for sector %zu not found, %s\n",
+				  sector, sdkp->device->type == TYPE_ZBC ?
+				  "deferring" : "skipping");
+		if (sdkp->device->type != TYPE_ZBC)
+			return BLKPREP_OK;
+		blk_delay_queue(q, 5);
+		return BLKPREP_DEFER;
+	}
+	spin_lock_irqsave(&zone->lock, flags);
+	if (zone->state == BLK_ZONE_UNKNOWN ||
+	    zone->state == BLK_ZONE_BUSY) {
+		if (printk_ratelimit())
+			sd_printk(KERN_INFO, sdkp,
+				  "zone %llu state %x, deferring\n",
+				  zone->start, zone->state);
+		blk_delay_queue(q, 5);
+		ret = BLKPREP_DEFER;
+	} else {
+		if (rq_data_dir(rq) == WRITE) {
+			if (zone->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+				goto out;
+			if (blk_zone_is_full(zone)) {
+#ifdef SD_ZBC_DEBUG
+				sd_printk(KERN_ERR, sdkp,
+					  "Write to full zone %zu/%llu\n",
+					  sector, zone->wp);
+#endif
+				ret = BLKPREP_KILL;
+				goto out;
+			}
+			if (zone->wp != sector) {
+#ifdef SD_ZBC_DEBUG
+				sd_printk(KERN_ERR, sdkp,
+					  "Misaligned write %zu/%llu\n",
+					  sector, zone->wp);
+#endif
+				ret = BLKPREP_KILL;
+				goto out;
+			}
+			zone->wp += num_sectors;
+		} else if (blk_zone_is_smr(zone) && (zone->wp <= sector)) {
+#ifdef SD_ZBC_DEBUG
+			sd_printk(KERN_INFO, sdkp,
+				    "Read beyond wp %zu/%llu\n",
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
+int sd_zbc_setup(struct scsi_disk *sdkp, unsigned char *buf, int buf_len)
+{
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
+		atomic_set(&sdkp->zone_reset, 0);
+	} else {
+		atomic_inc(&sdkp->zone_reset);
+		drain_workqueue(sdkp->zone_work_q);
+		atomic_set(&sdkp->zone_reset, 0);
+	}
+
+	sd_zbc_update_zones(sdkp, 0, SD_ZBC_BUF_SIZE, false);
+
+	blk_queue_io_min(sdkp->disk->queue, 4);
+	return 0;
+}
+
+void sd_zbc_remove(struct scsi_disk *sdkp)
+{
+	if (sdkp->zone_work_q) {
+		atomic_inc(&sdkp->zone_reset);
+		drain_workqueue(sdkp->zone_work_q);
+		destroy_workqueue(sdkp->zone_work_q);
+	}
+}
-- 
1.8.5.2
