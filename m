From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Wed, 18 Jul 2007 16:36:37 -0700
Message-ID: <20070718163637.3f0e0164.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070716162206.392129000@pademelon.sonytel.be>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Andy Whitcroft <apw@shadowen.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James
	E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Jul 2007 18:15:40 +0200
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Add a Disk Storage Driver for the PS3:

Your patchset significantly hits powerpc, scsi and block.  So who gets to
merge this?  Jens?  James?  Paul?

Me, I guess ;)

>   - Implemented as a block device driver with a dynamic major
>   - Disk names (and partitions) are of the format ps3d%c(%u)
>   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>     doesn't support scatter-gather
> 
> ...
>
> --- /dev/null
> +++ b/drivers/block/ps3disk.c
> @@ -0,0 +1,624 @@
> +/*
> + * PS3 Disk Storage Driver
> + *
> + * Copyright (C) 2007 Sony Computer Entertainment Inc.
> + * Copyright 2007 Sony Corp.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published
> + * by the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <linux/ata.h>
> +#include <linux/blkdev.h>
> +
> +#include <asm/lv1call.h>
> +#include <asm/ps3stor.h>
> +#include <asm/firmware.h>
> +
> +
> +#define DEVICE_NAME		"ps3disk"
> +
> +#define BOUNCE_SIZE		(64*1024)
> +
> +#define PS3DISK_MAX_DISKS	16
> +#define PS3DISK_MINORS		16
> +
> +#define KERNEL_SECTOR_SIZE	512

Sigh.  We have at least ten separate definitions of SECTOR_SIZE< none of
them in the right place.  Cleanup opportunity for someone.

> +
> +#define PS3DISK_NAME		"ps3d%c"
> +
> +
> +struct ps3disk_private {
> +	spinlock_t lock;		/* Request queue spinlock */
> +	struct request_queue *queue;
> +	struct gendisk *gendisk;
> +	unsigned int blocking_factor;
> +	struct request *req;
> +	u64 raw_capacity;
> +	unsigned char model[ATA_ID_PROD_LEN+1];
> +};
> +#define ps3disk_priv(dev)	((dev)->sbd.core.driver_data)

hm, this code has "ata" all over it and actually uses a libata #define (at
least) but there is no Kconfig dependency on ATA.  Fair enough, I guess,
but a bit funny-looking.

> +static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
> +				   struct request *req, int gather)
> +{
> +	unsigned int sectors = 0, offset = 0;
> +	struct bio *bio;
> +	sector_t sector;
> +	struct bio_vec *bvec;
> +	unsigned int i = 0, j;
> +	size_t size;
> +	void *buf;
> +
> +	rq_for_each_bio(bio, req) {
> +		sector = bio->bi_sector;
> +		dev_dbg(&dev->sbd.core,
> +			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> +			__func__, __LINE__, i, bio_segments(bio),
> +			bio_sectors(bio), sector);
> +		bio_for_each_segment(bvec, bio, j) {
> +			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
> +			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
> +			if (gather)
> +				memcpy(dev->bounce_buf+offset, buf, size);
> +			else
> +				memcpy(buf, dev->bounce_buf+offset, size);
> +			offset += size;
> +			flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
> +			__bio_kunmap_atomic(bio, KM_IRQ0);
> +		}
> +		sectors += bio_sectors(bio);
> +		i++;
> +	}
> +}

Local variable `sectors' doesn't do anything.

> +static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
> +				     struct request *req)
> +{
> +	struct ps3disk_private *priv = ps3disk_priv(dev);
> +	int write = rq_data_dir(req), res;
> +	const char *op = write ? "write" : "read";
> +	u64 start_sector, sectors;
> +	unsigned int region_id = dev->regions[dev->region_idx].id;

So we're ignoring the sector_t stuff.  I guess it's 64-bit only.  Still, it
might be nice to use sector_t for consistency, readability and possible
future 32-bitness?

> +#ifdef DEBUG
> +	unsigned int n = 0;
> +	struct bio *bio;
> +	rq_for_each_bio(bio, req)
> +		n++;

I'm surprised that the block core doesn't have a helper to count the number
of bios in a request.

Please prefer to put a blank line between end-of-locals and start-of-code.

> +	dev_dbg(&dev->sbd.core,
> +		"%s:%u: %s req has %u bios for %lu sectors %lu hard sectors\n",
> +		__func__, __LINE__, op, n, req->nr_sectors,
> +		req->hard_nr_sectors);
> +#endif
> +
> +	start_sector = req->sector*priv->blocking_factor;
> +	sectors = req->nr_sectors*priv->blocking_factor;

s/*/ * /.  checkpatch missed this.

I suspect you didn't run cehckpatch anyway.

Please run checkpatch.

> +	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
> +		__func__, __LINE__, op, sectors, start_sector);
> +
> +	if (write) {
> +		ps3disk_scatter_gather(dev, req, 1);
> +
> +		res = lv1_storage_write(dev->sbd.dev_id, region_id,
> +					start_sector, sectors, 0,
> +					dev->bounce_lpar, &dev->tag);
> +	} else {
> +		res = lv1_storage_read(dev->sbd.dev_id, region_id,
> +				       start_sector, sectors, 0,
> +				       dev->bounce_lpar, &dev->tag);
> +	}
> +	if (res) {
> +		dev_err(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
> +			__LINE__, op, res);
> +		end_request(req, 0);
> +		return 0;
> +	}
> +
> +	priv->req = req;
> +	return 1;
> +}
> +
>
> ...
>
> +
> +/* ATA helpers copied from drivers/ata/libata-core.c */

ooh, bad person.

> +static void swap_buf_le16(u16 *buf, unsigned int buf_words)
> +{
> +#ifdef __BIG_ENDIAN
> +	unsigned int i;
> +
> +	for (i = 0; i < buf_words; i++)
> +		buf[i] = le16_to_cpu(buf[i]);
> +#endif /* __BIG_ENDIAN */
> +}
> +
> +static u64 ata_id_n_sectors(const u16 *id)
> +{
> +	if (ata_id_has_lba(id)) {
> +		if (ata_id_has_lba48(id))
> +			return ata_id_u64(id, 100);
> +		else
> +			return ata_id_u32(id, 60);
> +	} else {
> +		if (ata_id_current_chs_valid(id))
> +			return ata_id_u32(id, 57);
> +		else
> +			return id[1] * id[3] * id[6];
> +	}
> +}
> +
> +static void ata_id_string(const u16 *id, unsigned char *s, unsigned int ofs,
> +			  unsigned int len)
> +{
> +	unsigned int c;
> +
> +	while (len > 0) {
> +		c = id[ofs] >> 8;
> +		*s = c;
> +		s++;
> +
> +		c = id[ofs] & 0xff;
> +		*s = c;
> +		s++;
> +
> +		ofs++;
> +		len -= 2;
> +	}
> +}
> +
> +static void ata_id_c_string(const u16 *id, unsigned char *s, unsigned int ofs,
> +			    unsigned int len)
> +{
> +	unsigned char *p;
> +
> +	WARN_ON(!(len & 1));
> +
> +	ata_id_string(id, s, ofs, len - 1);
> +
> +	p = s + strnlen(s, len - 1);
> +	while (p > s && p[-1] == ' ')
> +		p--;
> +	*p = '\0';
> +}
> +
>
> ...
>
> +static unsigned long ps3disk_mask;
> +
> +static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
> +{
> +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> +	struct ps3disk_private *priv;
> +	int error;
> +	unsigned int devidx;
> +	struct request_queue *queue;
> +	struct gendisk *gendisk;
> +
> +	if (dev->blk_size < KERNEL_SECTOR_SIZE) {
> +		dev_err(&dev->sbd.core,
> +			"%s:%u: cannot handle block size %lu\n", __func__,
> +			__LINE__, dev->blk_size);
> +		return -EINVAL;
> +	}
> +
> +	BUILD_BUG_ON(PS3DISK_MAX_DISKS > BITS_PER_LONG);
> +	devidx = find_first_zero_bit(&ps3disk_mask, PS3DISK_MAX_DISKS);
> +	if (devidx >= PS3DISK_MAX_DISKS) {
> +		dev_err(&dev->sbd.core, "%s:%u: Too many disks\n", __func__,
> +			__LINE__);
> +		return -ENOSPC;
> +	}
> +	__set_bit(devidx, &ps3disk_mask);
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		error = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	ps3disk_priv(dev) = priv;
> +	spin_lock_init(&priv->lock);
> +
> +	dev->bounce_size = BOUNCE_SIZE;
> +	dev->bounce_buf = kmalloc(BOUNCE_SIZE, GFP_DMA);
> +	if (!dev->bounce_buf) {
> +		error = -ENOMEM;
> +		goto fail_free_priv;
> +	}
> +
> +	error = ps3stor_setup(dev, ps3disk_interrupt);
> +	if (error)
> +		goto fail_free_bounce;
> +
> +	ps3disk_identify(dev);

ps3disk_identify() can return an error?

> +	queue = blk_init_queue(ps3disk_request, &priv->lock);
> +	if (!queue) {
> +		dev_err(&dev->sbd.core, "%s:%u: blk_init_queue failed\n",
> +			__func__, __LINE__);
> +		error = -ENOMEM;
> +		goto fail_teardown;
> +	}
> +
> +	priv->queue = queue;
> +	queue->queuedata = dev;
> +
> +	blk_queue_bounce_limit(queue, BLK_BOUNCE_HIGH);
> +
> +	blk_queue_max_sectors(queue, dev->bounce_size/KERNEL_SECTOR_SIZE);
> +	blk_queue_segment_boundary(queue, -1UL);
> +	blk_queue_dma_alignment(queue, dev->blk_size-1);
> +	blk_queue_hardsect_size(queue, dev->blk_size);
> +
> +	blk_queue_issue_flush_fn(queue, ps3disk_issue_flush);
> +	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
> +			  ps3disk_prepare_flush);
> +
> +	blk_queue_max_phys_segments(queue, -1);
> +	blk_queue_max_hw_segments(queue, -1);
> +	blk_queue_max_segment_size(queue, dev->bounce_size);
> +
> +	gendisk = alloc_disk(PS3DISK_MINORS);
> +	if (!gendisk) {
> +		dev_err(&dev->sbd.core, "%s:%u: alloc_disk failed\n", __func__,
> +			__LINE__);
> +		error = -ENOMEM;
> +		goto fail_cleanup_queue;
> +	}
> +
> +	priv->gendisk = gendisk;
> +	gendisk->major = ps3disk_major;
> +	gendisk->first_minor = devidx * PS3DISK_MINORS;
> +	gendisk->fops = &ps3disk_fops;
> +	gendisk->queue = queue;
> +	gendisk->private_data = dev;
> +	gendisk->driverfs_dev = &dev->sbd.core;
> +	snprintf(gendisk->disk_name, sizeof(gendisk->disk_name), PS3DISK_NAME,
> +		 devidx+'a');
> +	priv->blocking_factor = dev->blk_size/KERNEL_SECTOR_SIZE;
> +	set_capacity(gendisk,
> +		     dev->regions[dev->region_idx].size*priv->blocking_factor);
> +
> +	dev_info(&dev->sbd.core,
> +		 "%s is a %s (%lu MiB total, %lu MiB for OtherOS)\n",
> +		 gendisk->disk_name, priv->model, priv->raw_capacity >> 11,
> +		 get_capacity(gendisk) >> 11);
> +
> +	add_disk(gendisk);
> +	return 0;
> +
> +fail_cleanup_queue:
> +	blk_cleanup_queue(queue);
> +fail_teardown:
> +	ps3stor_teardown(dev);
> +fail_free_bounce:
> +	kfree(dev->bounce_buf);
> +fail_free_priv:
> +	kfree(priv);
> +	ps3disk_priv(dev) = NULL;
> +fail:
> +	__clear_bit(devidx, &ps3disk_mask);
> +	return error;
> +}
> +
> +static int ps3disk_remove(struct ps3_system_bus_device *_dev)
> +{
> +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> +	struct ps3disk_private *priv = ps3disk_priv(dev);
> +
> +	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
> +		    &ps3disk_mask);

I see no locking here which makes this __clear_bit and the above __set_bit
non-racy?

> +	del_gendisk(priv->gendisk);
> +	blk_cleanup_queue(priv->queue);
> +	put_disk(priv->gendisk);
> +	dev_notice(&dev->sbd.core, "Synchronizing disk cache\n");
> +	ps3disk_sync_cache(dev);
> +	ps3stor_teardown(dev);
> +	kfree(dev->bounce_buf);
> +	kfree(priv);
> +	ps3disk_priv(dev) = NULL;

I suspect this nulling here will just hide any bugs?  If we're going to
write anything there, probably 0xdeadbeef would be better?

> +	return 0;
> +}
> +
