From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 13:39:23 +0200
Message-ID: <20070615120848.352093000@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49681 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753798AbXFOML2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:28 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_disk.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a Disk Storage Driver for the PS3:
  - Implemented as a block device driver with a dynamic major
  - Disk names (and partitions) are of the format ps3d%c(%u)
  - Uses software scatter-gather with a 64 KiB bounce buffer as the hyp=
ervisor
    doesn't support scatter-gather

CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Changes since previous submission:
      o Don't use `default y' in Kconfig
      o Remove the thread for handling requests
      o Set up sysfs links between block device and PS3 system device:
          . /sys/block/ps3da/device -> ../../devices/ps3_system/sb_02
	  . /sys/devices/ps3_system/sb_02/block:ps3da -> ../../../block/ps3da
      o Fix all FIXMEs
      o Implement proper barrier support
      o Call add_disk_randomness()
      o Add a test to verify we are running on a PS3
      o Fix error path in ps3disk_init()
      o Fix cleanup order in ps3disk_exit()

 arch/powerpc/platforms/ps3/Kconfig |   10=20
 drivers/block/Makefile             |    1=20
 drivers/block/ps3disk.c            |  526 ++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 537 insertions(+)

--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -102,4 +102,14 @@ config PS3_STORAGE
 	depends on PPC_PS3
 	tristate
=20
+config PS3_DISK
+	tristate "PS3 Disk Storage Driver"
+	depends on PPC_PS3 && BLOCK
+	select PS3_STORAGE
+	help
+	  Include support for the PS3 Disk Storage.
+
+	  This support is required to access the PS3 hard disk.
+	  In general, all users will say Y or M.
+
 endmenu
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_VIODASD)		+=3D viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+=3D sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+=3D ub.o
=20
+obj-$(CONFIG_PS3_DISK)		+=3D ps3disk.o
--- /dev/null
+++ b/drivers/block/ps3disk.c
@@ -0,0 +1,526 @@
+/*
+ * PS3 Disk Storage Driver
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long
+ * with this program; if not, write to the Free Software Foundation, I=
nc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/blkdev.h>
+#include <linux/freezer.h>
+#include <linux/hdreg.h>
+#include <linux/interrupt.h>
+#include <linux/kthread.h>
+
+#include <asm/lv1call.h>
+#include <asm/ps3stor.h>
+#include <asm/firmware.h>
+
+
+#define DEVICE_NAME		"ps3disk"
+
+#define BOUNCE_SIZE		(64*1024)
+
+#define PS3DISK_MAJOR		0
+
+#define PS3DISK_MAX_DISKS	16
+#define PS3DISK_MINORS		16
+
+#define KERNEL_SECTOR_SIZE	512
+
+
+#define PS3DISK_NAME		"ps3d%c"
+
+#define LV1_STORAGE_ATA_HDDOUT		(0x23)
+
+
+struct ps3disk_private {
+	spinlock_t lock;		/* Request queue spinlock */
+	struct request_queue *queue;
+	struct gendisk *gendisk;
+	unsigned int blocking_factor;
+	struct request *req;
+};
+#define ps3disk_priv(dev)	((dev)->sbd.core.driver_data)
+
+static int ps3disk_major =3D PS3DISK_MAJOR;
+
+
+static int ps3disk_open(struct inode *inode, struct file *file)
+{
+	struct ps3_storage_device *dev =3D inode->i_bdev->bd_disk->private_da=
ta;
+
+	file->private_data =3D dev;
+	return 0;
+}
+
+static struct block_device_operations ps3disk_fops =3D {
+	.owner		=3D THIS_MODULE,
+	.open		=3D ps3disk_open,
+};
+
+
+static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
+				   struct request *req, int gather)
+{
+	unsigned int sectors =3D 0, offset =3D 0;
+	struct bio *bio;
+	sector_t sector;
+	struct bio_vec *bvec;
+	unsigned int i =3D 0, j;
+	size_t size;
+	void *buf;
+
+	rq_for_each_bio(bio, req) {
+		sector =3D bio->bi_sector;
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
+			__func__, __LINE__, i, bio_segments(bio),
+			bio_sectors(bio), sector);
+		bio_for_each_segment(bvec, bio, j) {
+			size =3D bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
+			buf =3D __bio_kmap_atomic(bio, j, KM_USER0);
+			if (gather)
+				memcpy(dev->bounce_buf+offset, buf, size);
+			else
+				memcpy(buf, dev->bounce_buf+offset, size);
+			offset +=3D size;
+			__bio_kunmap_atomic(bio, KM_USER0);
+		}
+		sectors +=3D bio_sectors(bio);
+		i++;
+	}
+}
+
+static u64 ps3disk_read_write_sectors(struct ps3_storage_device *dev, =
u64 lpar,
+				      u64 start_sector, u64 sectors, int write)
+{
+	unsigned int region_id =3D dev->regions[dev->region_idx].id;
+	const char *op =3D write ? "write" : "read";
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
+		__func__, __LINE__, op, sectors, start_sector);
+
+	res =3D write ? lv1_storage_write(dev->sbd.dev_id, region_id,
+					start_sector, sectors, 0, lpar,
+					&dev->tag)
+		    : lv1_storage_read(dev->sbd.dev_id, region_id,
+				       start_sector, sectors, 0, lpar,
+				       &dev->tag);
+	if (res) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
+			__LINE__, op, res);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
+				     struct request *req)
+{
+	struct ps3disk_private *priv =3D ps3disk_priv(dev);
+	int write =3D rq_data_dir(req);
+	const char *op =3D write ? "write" : "read";
+	u64 res;
+
+#ifdef DEBUG
+	unsigned int n =3D 0;
+	struct bio *bio;
+	rq_for_each_bio(bio, req)
+		n++;
+	dev_dbg(&dev->sbd.core,
+		"%s:%u: %s req has %u bios for %lu sectors %lu hard sectors\n",
+		__func__, __LINE__, op, n, req->nr_sectors,
+		req->hard_nr_sectors);
+#endif
+
+	if (write)
+		ps3disk_scatter_gather(dev, req, 1);
+
+	res =3D ps3disk_read_write_sectors(dev, dev->bounce_lpar,
+					 req->sector*priv->blocking_factor,
+					 req->nr_sectors*priv->blocking_factor,
+					 write);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
+			__LINE__, op, res);
+		end_request(req, 0);
+		return 0;
+	}
+
+	priv->req =3D req;
+	return 1;
+}
+
+static int ps3disk_submit_flush_request(struct ps3_storage_device *dev=
,
+					struct request *req)
+{
+	struct ps3disk_private *priv =3D ps3disk_priv(dev);
+	u64 res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: flush request\n", __func__, __LINE__)=
;
+
+	res =3D lv1_storage_send_device_command(dev->sbd.dev_id,
+					      LV1_STORAGE_ATA_HDDOUT, 0, 0, 0,
+					      0, &dev->tag);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%lx\n",
+			__func__, __LINE__, res);
+		end_request(req, 0);
+		return 0;
+	}
+
+	priv->req =3D req;
+	return 1;
+}
+
+static void ps3disk_do_request(struct ps3_storage_device *dev,
+			       request_queue_t *q)
+{
+	struct request *req;
+
+	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
+
+	while ((req =3D elv_next_request(q))) {
+		if (blk_fs_request(req)) {
+			if (ps3disk_submit_request_sg(dev, req))
+				break;
+		} else if (req->cmd_type =3D=3D REQ_TYPE_FLUSH) {
+			if (ps3disk_submit_flush_request(dev, req))
+				break;
+		} else {
+			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
+			end_request(req, 0);
+			continue;
+		}
+	}
+}
+
+static void ps3disk_request(request_queue_t *q)
+{
+	struct ps3_storage_device *dev =3D q->queuedata;
+	struct ps3disk_private *priv =3D ps3disk_priv(dev);
+
+	if (priv->req) {
+		dev_dbg(&dev->sbd.core, "%s:%u busy\n", __func__, __LINE__);
+		return;
+	}
+
+	ps3disk_do_request(dev, q);
+}
+
+static irqreturn_t ps3disk_interrupt(int irq, void *data)
+{
+	struct ps3_storage_device *dev =3D data;
+	struct ps3disk_private *priv;
+	struct request *req;
+	int res, read, uptodate;
+	u64 tag, status;
+	unsigned long num_sectors;
+	const char *op;
+
+	res =3D lv1_storage_get_async_status(dev->sbd.dev_id, &tag, &status);
+
+	if (tag !=3D dev->tag)
+		dev_err(&dev->sbd.core,
+			"%s:%u: tag mismatch, got %lx, expected %lx\n",
+			__func__, __LINE__, tag, dev->tag);
+
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: res=3D%d status=3D0x%lx\n",
+			__func__, __LINE__, res, status);
+		return IRQ_HANDLED;
+	}
+
+	priv =3D ps3disk_priv(dev);
+	req =3D priv->req;
+	if (!req) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u non-block layer request completed\n", __func__,
+			__LINE__);
+		dev->lv1_status =3D status;
+		complete(&dev->done);
+		return IRQ_HANDLED;
+	}
+
+	if (req->cmd_type =3D=3D REQ_TYPE_FLUSH) {
+		read =3D 0;
+		num_sectors =3D req->hard_cur_sectors;
+		op =3D "flush";
+	} else {
+		read =3D !rq_data_dir(req);
+		num_sectors =3D req->nr_sectors;
+		op =3D read ? "read" : "write";
+	}
+	if (status) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
+			__LINE__, op, status);
+		uptodate =3D 0;
+	} else {
+		dev_dbg(&dev->sbd.core, "%s:%u: %s completed\n", __func__,
+			__LINE__, op);
+		uptodate =3D 1;
+		if (read)
+			ps3disk_scatter_gather(dev, req, 0);
+	}
+
+	spin_lock(&priv->lock);
+	if (!end_that_request_first(req, uptodate, num_sectors)) {
+		add_disk_randomness(req->rq_disk);
+		blkdev_dequeue_request(req);
+		end_that_request_last(req, uptodate);
+	}
+	priv->req =3D NULL;
+	ps3disk_do_request(dev, priv->queue);
+	spin_unlock(&priv->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int ps3disk_sync_cache(struct ps3_storage_device *dev)
+{
+	u64 res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: sync cache\n", __func__, __LINE__);
+
+	res =3D ps3stor_send_command(dev, LV1_STORAGE_ATA_HDDOUT, 0, 0, 0, 0)=
;
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%lx\n",
+			__func__, __LINE__, res);
+		return -EIO;
+	}
+	return 0;
+}
+
+static void ps3disk_prepare_flush(request_queue_t *q, struct request *=
req)
+{
+	struct ps3_storage_device *dev =3D q->queuedata;
+
+	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
+
+	memset(req->cmd, 0, sizeof(req->cmd));
+	req->cmd_type =3D REQ_TYPE_FLUSH;
+}
+
+static int ps3disk_issue_flush(request_queue_t *q, struct gendisk *gen=
disk,
+			       sector_t *sector)
+{
+	struct ps3_storage_device *dev =3D q->queuedata;
+	struct request *req;
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
+
+	req =3D blk_get_request(q, WRITE, __GFP_WAIT);
+	ps3disk_prepare_flush(q, req);
+	res =3D blk_execute_rq(q, gendisk, req, 0);
+	if (res)
+		dev_err(&dev->sbd.core, "%s:%u: flush request failed %d\n",
+			__func__, __LINE__, res);
+	blk_put_request(req);
+	return res;
+}
+
+
+static unsigned long ps3disk_mask;
+
+static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+	struct ps3disk_private *priv;
+	int error;
+	unsigned int devidx;
+	struct request_queue *queue;
+	struct gendisk *gendisk;
+
+	if (dev->blk_size < KERNEL_SECTOR_SIZE) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: cannot handle block size %lu\n", __func__,
+			__LINE__, dev->blk_size);
+		return -EINVAL;
+	}
+
+	BUILD_BUG_ON(PS3DISK_MAX_DISKS > BITS_PER_LONG);
+	devidx =3D find_first_zero_bit(&ps3disk_mask, PS3DISK_MAX_DISKS);
+	if (devidx >=3D PS3DISK_MAX_DISKS) {
+		dev_err(&dev->sbd.core, "%s:%u: Too many disks\n", __func__,
+			__LINE__);
+		return -ENOSPC;
+	}
+	__set_bit(devidx, &ps3disk_mask);
+
+	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		error =3D -ENOMEM;
+		goto fail;
+	}
+
+	ps3disk_priv(dev) =3D priv;
+	spin_lock_init(&priv->lock);
+
+	dev->bounce_size =3D BOUNCE_SIZE;
+	dev->bounce_buf =3D kmalloc(BOUNCE_SIZE, GFP_DMA);
+	if (!dev->bounce_buf) {
+		error =3D -ENOMEM;
+		goto fail_free_priv;
+	}
+
+	error =3D ps3stor_setup(dev);
+	if (error)
+		goto fail_free_bounce;
+
+	/* override the interrupt handler */
+	free_irq(dev->irq, dev);
+	error =3D request_irq(dev->irq, ps3disk_interrupt, IRQF_DISABLED,
+			    dev->sbd.core.driver->name, dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
+			__func__, __LINE__, error);
+		goto fail_teardown;
+	}
+
+	queue =3D blk_init_queue(ps3disk_request, &priv->lock);
+	if (!queue) {
+		dev_err(&dev->sbd.core, "%s:%u: blk_init_queue failed\n",
+			__func__, __LINE__);
+		error =3D -ENOMEM;
+		goto fail_teardown;
+	}
+
+	priv->queue =3D queue;
+	queue->queuedata =3D dev;
+
+	blk_queue_bounce_limit(queue, BLK_BOUNCE_HIGH);
+
+	blk_queue_max_sectors(queue, dev->bounce_size/KERNEL_SECTOR_SIZE);
+	blk_queue_segment_boundary(queue, -1UL);
+	blk_queue_dma_alignment(queue, dev->blk_size-1);
+	blk_queue_hardsect_size(queue, dev->blk_size);
+
+	blk_queue_issue_flush_fn(queue, ps3disk_issue_flush);
+	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  ps3disk_prepare_flush);
+
+	blk_queue_max_phys_segments(queue, -1);
+	blk_queue_max_hw_segments(queue, -1);
+	blk_queue_max_segment_size(queue, dev->bounce_size);
+
+	gendisk =3D alloc_disk(PS3DISK_MINORS);
+	if (!gendisk) {
+		dev_err(&dev->sbd.core, "%s:%u: alloc_disk failed\n", __func__,
+			__LINE__);
+		error =3D -ENOMEM;
+		goto fail_cleanup_queue;
+	}
+
+	priv->gendisk =3D gendisk;
+	gendisk->major =3D ps3disk_major;
+	gendisk->first_minor =3D devidx * PS3DISK_MINORS;
+	gendisk->fops =3D &ps3disk_fops;
+	gendisk->queue =3D queue;
+	gendisk->private_data =3D dev;
+	gendisk->driverfs_dev =3D &dev->sbd.core;
+	snprintf(gendisk->disk_name, sizeof(gendisk->disk_name), PS3DISK_NAME=
,
+		 devidx+'a');
+	priv->blocking_factor =3D dev->blk_size/KERNEL_SECTOR_SIZE;
+	set_capacity(gendisk,
+		     dev->regions[dev->region_idx].size*priv->blocking_factor);
+
+	add_disk(gendisk);
+	return 0;
+
+fail_cleanup_queue:
+	blk_cleanup_queue(queue);
+fail_teardown:
+	ps3stor_teardown(dev);
+fail_free_bounce:
+	kfree(dev->bounce_buf);
+fail_free_priv:
+	kfree(priv);
+fail:
+	__clear_bit(devidx, &ps3disk_mask);
+	return error;
+}
+
+static int ps3disk_remove(struct ps3_system_bus_device *_dev)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+	struct ps3disk_private *priv =3D ps3disk_priv(dev);
+
+	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
+		    &ps3disk_mask);
+	del_gendisk(priv->gendisk);
+	put_disk(priv->gendisk);
+	blk_cleanup_queue(priv->queue);
+	dev_notice(&dev->sbd.core, "Synchronizing disk cache\n");
+	ps3disk_sync_cache(dev);
+	ps3stor_teardown(dev);
+	kfree(dev->bounce_buf);
+	kfree(priv);
+	return 0;
+}
+
+static struct ps3_system_bus_driver ps3disk =3D {
+	.match_id	=3D PS3_MATCH_ID_STOR_DISK,
+	.core.name	=3D DEVICE_NAME,
+	.core.owner	=3D THIS_MODULE,
+	.probe		=3D ps3disk_probe,
+	.remove		=3D ps3disk_remove,
+	.shutdown	=3D ps3disk_remove,
+};
+
+
+static int __init ps3disk_init(void)
+{
+	int error;
+
+	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
+		return -ENODEV;
+
+	error =3D register_blkdev(ps3disk_major, DEVICE_NAME);
+	if (error <=3D 0) {
+		printk(KERN_ERR "%s:%u: register_blkdev failed %d\n", __func__,
+		       __LINE__, error);
+		return error;
+	}
+	if (!ps3disk_major)
+		ps3disk_major =3D error;
+
+	pr_info("%s:%u: registered block device major %d\n", __func__,
+		__LINE__, ps3disk_major);
+
+	error =3D ps3_system_bus_driver_register(&ps3disk);
+	if (error)
+		unregister_blkdev(ps3disk_major, DEVICE_NAME);
+
+	return error;
+}
+
+static void __exit ps3disk_exit(void)
+{
+	ps3_system_bus_driver_unregister(&ps3disk);
+	unregister_blkdev(ps3disk_major, DEVICE_NAME);
+}
+
+module_init(ps3disk_init);
+module_exit(ps3disk_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PS3 Disk Storage Driver");
+MODULE_AUTHOR("Sony Corporation");
+MODULE_ALIAS(PS3_MODULE_ALIAS_STOR_DISK);

--=20
With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
=46ax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Be=
lgium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
=46ortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
