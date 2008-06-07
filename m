From: Monakhov Dmitri <dmonakhov@openvz.org>
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
Date: Sat, 07 Jun 2008 18:45:03 +0400
Message-ID: <m3od6duwwg.fsf@dmon-lap.sw.ru>
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:38787 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbYFGOy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jun 2008 10:54:59 -0400
In-Reply-To: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net> (Martin K. Petersen's message of "Sat\, 07 Jun 2008 00\:55\:37 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> 4 files changed, 825 insertions(+), 3 deletions(-)
> fs/Makefile         |    1 
> fs/bio-integrity.c  |  715 +++++++++++++++++++++++++++++++++++++++++++++++++++
> fs/bio.c            |   27 +
> include/linux/bio.h |   85 ++++++
>
>
> Allows integrity metadata to be attached to a bio.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> ---
>
> diff -r 318fa71e735d -r f2ae9d5bce4c fs/Makefile
> --- a/fs/Makefile	Sat Jun 07 00:45:14 2008 -0400
> +++ b/fs/Makefile	Sat Jun 07 00:45:15 2008 -0400
> @@ -19,6 +19,7 @@
>  obj-y +=	no-block.o
>  endif
>  
> +obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
>  obj-$(CONFIG_INOTIFY)		+= inotify.o
>  obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
>  obj-$(CONFIG_EPOLL)		+= eventpoll.o
> diff -r 318fa71e735d -r f2ae9d5bce4c fs/bio-integrity.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/fs/bio-integrity.c	Sat Jun 07 00:45:15 2008 -0400
> @@ -0,0 +1,715 @@
> +/*
> + * bio-integrity.c - bio data integrity extensions
> + *
> + * Copyright (C) 2007, 2008 Oracle Corporation
> + * Written by: Martin K. Petersen <martin.petersen@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; see the file COPYING.  If not, write to
> + * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
> + * USA.
> + *
> + */
> +
> +#include <linux/blkdev.h>
> +#include <linux/mempool.h>
> +#include <linux/bio.h>
> +#include <linux/workqueue.h>
> +
> +static struct kmem_cache *bio_integrity_slab __read_mostly;
> +static struct workqueue_struct *kintegrityd_wq;
> +
> +/**
> + * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
> + * @bio:	bio to attach integrity metadata to
> + * @gfp_mask:	Memory allocation mask
> + * @nr_vecs:	Number of integrity metadata scatter-gather elements
> + * @bs:		bio_set to allocate from
> + *
> + * Description: This function prepares a bio for attaching integrity
> + * metadata.  nr_vecs specifies the maximum number of pages containing
> + * integrity metadata that can be attached.
> + */
> +struct bip *bio_integrity_alloc_bioset(struct bio *bio, gfp_t gfp_mask, unsigned int nr_vecs, struct bio_set *bs)
> +{
> +	struct bip *bip;
> +	struct bio_vec *bv;
> +	unsigned long idx;
> +
> +	BUG_ON(bio == NULL);
> +
> +	bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> +	if (unlikely(bip == NULL)) {
> +		printk(KERN_ERR "%s: could not alloc bip\n", __func__);
> +		return NULL;
> +	}
> +
> +	memset(bip, 0, sizeof(*bip));
> +	idx = 0;
> +
> +	bv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, bs);
> +	if (unlikely(bv == NULL)) {
> +		printk(KERN_ERR "%s: could not alloc bip_vec\n", __func__);
> +		mempool_free(bip, bs->bio_integrity_pool);
> +		return NULL;
> +	}
> +
> +	bip->bip_pool = idx;
> +	bip->bip_vec = bv;
> +	bip->bip_bio = bio;
> +	bio->bi_integrity = bip;
> +
> +	return bip;
> +}
> +EXPORT_SYMBOL(bio_integrity_alloc_bioset);
> +
> +/**
> + * bio_integrity_alloc - Allocate integrity payload and attach it to bio
> + * @bio:	bio to attach integrity metadata to
> + * @gfp_mask:	Memory allocation mask
> + * @nr_vecs:	Number of integrity metadata scatter-gather elements
> + *
> + * Description: This function prepares a bio for attaching integrity
> + * metadata.  nr_vecs specifies the maximum number of pages containing
> + * integrity metadata that can be attached.
> + */
> +struct bip *bio_integrity_alloc(struct bio *bio, gfp_t gfp_mask,
> +				unsigned int nr_vecs)
> +{
> +	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
> +}
> +EXPORT_SYMBOL(bio_integrity_alloc);
> +
> +/**
> + * bio_integrity_free - Free bio integrity payload
> + * @bio:	bio containing bip to be freed
> + * @bs:		bio_set this bio was allocated from
> + *
> + * Description: Used to free the integrity portion of a bio. Usually
> + * called from bio_free().
> + */
> +void bio_integrity_free(struct bio *bio, struct bio_set *bs)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +
> +	BUG_ON(bip == NULL);
> +
> +	/* A cloned bio doesn't own the integrity metadata */
> +	if (!bio_flagged(bio, BIO_CLONED) && bip->bip_buf != NULL)
> +		kfree(bip->bip_buf);
> +
> +	mempool_free(bip->bip_vec, bs->bvec_pools[bip->bip_pool]);
> +	mempool_free(bip, bs->bio_integrity_pool);
> +
> +	bio->bi_integrity = NULL;
> +}
> +EXPORT_SYMBOL(bio_integrity_free);
> +
> +/**
> + * bio_integrity_add_page - Attach integrity metadata
> + * @bio:	bio to update
> + * @page:	page containing integrity metadata
> + * @len:	number of bytes of integrity metadata in page
> + * @offset:	start offset within page
> + *
> + * Description: Attach a page containing integrity metadata to bio.
> + */
> +int bio_integrity_add_page(struct bio *bio, struct page *page,
> +			   unsigned int len, unsigned int offset)
> +{
> +	struct bip *bip;
> +	struct bio_vec *iv;
> +
> +	bip = bio->bi_integrity;
> +
> +	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_pool)) {
> +		printk(KERN_ERR "%s: bip_vec full\n", __func__);
> +		return 0;
> +	}
> +
> +	iv = bip_vec_idx(bip, bip->bip_vcnt);
> +	BUG_ON(iv == NULL);
> +	BUG_ON(iv->bv_page != NULL);
> +
> +	iv->bv_page = page;
> +	iv->bv_len = len;
> +	iv->bv_offset = offset;
> +	bip->bip_vcnt++;
> +
> +	return len;
> +}
> +EXPORT_SYMBOL(bio_integrity_add_page);
> +
> +/**
> + * bio_integrity_enabled - Check whether integrity can be passed
> + * @bio:	bio to check
> + *
> + * Description: Determines whether bio_integrity_prep() can be called
> + * on this bio or not.	bio data direction and target device must be
> + * set prior to calling.  The functions honors the write_generate and
> + * read_verify flags in sysfs.
> + */
> +inline int bio_integrity_enabled(struct bio *bio)
> +{
> +	/* Already protected? */
> +	if (bio_integrity(bio))
> +		return 0;
> +
> +	return bdev_integrity_enabled(bio->bi_bdev, bio_data_dir(bio));
> +}
> +EXPORT_SYMBOL(bio_integrity_enabled);
> +
> +/**
> + * bio_integrity_tag_size - Retrieve integrity tag space
> + * @bio:	bio to inspect
> + *
> + * Description: Returns the maximum number of tag bytes that can be
> + * attached to this bio. Filesystems can use this to determine how
> + * much metadata to attach to an I/O.
> + */
> +unsigned int bio_integrity_tag_size(struct bio *bio)
> +{
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +
> +	BUG_ON(bio->bi_size == 0);
> +
> +	return bi->tag_size * (bio->bi_size / bi->sector_size);
> +}
> +EXPORT_SYMBOL(bio_integrity_tag_size);
> +
> +/**
> + * bio_integrity_set_tag - Attach a tag buffer to a bio
> + * @bio:	bio to attach buffer to
> + * @tag_buf:	Pointer to a buffer containing tag data
> + * @len:	Length of the included buffer
> + *
> + * Description: Use this function to tag a bio by leveraging the extra
> + * space provided by devices formatted with integrity protection.  The
> + * size of the integrity buffer must be <= to the size reported by
> + * bio_integrity_tag_size().
> + */
> +int bio_integrity_set_tag(struct bio *bio, void *tag_buf, unsigned int len)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	unsigned int nr_sectors;
> +
> +	BUG_ON(bip->bip_buf == NULL);
> +	BUG_ON(bio_data_dir(bio) != WRITE);
> +
> +	if (bi->tag_size == 0)
> +		return -1;
> +
> +	nr_sectors = len / bi->tag_size;
> +
> +	if (len % 2)
> +		nr_sectors++;
Seems i've missing something. What is purpose of this black magic?
do you want just express following?
       nr_sectors = (len + bi->tag_size - 1) / bi->tag_size;
> +
> +	if (bi->sector_size == 4096)
> +		nr_sectors >>= 3;
Why here and later sector_size == 4096 is so special, what about 1k and
2k sect_sz? Do you want just transform value from 512 to bi->sectors_size?
> +
> +	if (nr_sectors * bi->tuple_size > bip->bip_size) {
> +		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n",
> +		       __func__, nr_sectors * bi->tuple_size, bip->bip_size);
> +		return -1;
> +	}
> +
> +	bi->set_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(bio_integrity_set_tag);
> +
> +/**
> + * bio_integrity_get_tag - Retrieve a tag buffer from a bio
> + * @bio:	bio to retrieve buffer from
> + * @tag_buf:	Pointer to a buffer for the tag data
> + * @len:	Length of the target buffer
> + *
> + * Description: Use this function to retrieve the tag buffer from a
> + * completed I/O. The size of the integrity buffer must be <= to the
> + * size reported by bio_integrity_tag_size().
> + */
> +int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	unsigned int nr_sectors;
> +
> +	BUG_ON(bip->bip_buf == NULL);
> +	BUG_ON(bio_data_dir(bio) != READ);
> +
> +	if (bi->tag_size == 0)
> +		return -1;
> +
> +	nr_sectors = len / bi->tag_size;
> +
> +	if (len % 2)
> +		nr_sectors++;
> +
> +	if (bi->sector_size == 4096)
> +		nr_sectors >>= 3;
> +
> +	if (nr_sectors * bi->tuple_size > bip->bip_size) {
> +		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n",
> +		       __func__, nr_sectors * bi->tuple_size, bip->bip_size);
> +		return -1;
> +	}
> +
> +	bi->get_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(bio_integrity_get_tag);
> +
> +/**
> + * bio_integrity_generate - Generate integrity metadata for a bio
> + * @bio:	bio to generate integrity metadata for
> + *
> + * Description: Generates integrity metadata for a bio by calling the
> + * block device's generation callback function.	 The bio must have a
> + * bip attached with enough room to accomodate the generated integrity
> + * metadata.
> + */
> +static void bio_integrity_generate(struct bio *bio)
> +{
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	struct blk_integrity_exchg bix;
> +	struct bio_vec *bv;
> +	sector_t sector = bio->bi_sector;
> +	unsigned int i, sectors, total;
> +	void *prot_buf = bio->bi_integrity->bip_buf;
> +
> +	total = 0;
> +	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
> +	bix.sector_size = bi->sector_size;
> +
> +	bio_for_each_segment(bv, bio, i) {
> +		bix.data_buf = kmap_atomic(bv->bv_page, KM_USER0)
> +			+ bv->bv_offset;
> +		bix.data_size = bv->bv_len;
> +		bix.prot_buf = prot_buf;
> +		bix.sector = sector;
> +
> +		bi->generate_fn(&bix);
> +
> +		sectors = bv->bv_len / bi->sector_size;
> +		sector += sectors;
> +		prot_buf += sectors * bi->tuple_size;
> +		total += sectors * bi->tuple_size;
> +		BUG_ON(total > bio->bi_integrity->bip_size);
> +
> +		kunmap_atomic(bv->bv_page, KM_USER0);
> +	}
> +}
> +
> +/**
> + * bio_integrity_prep - Prepare bio for integrity I/O
> + * @bio:	bio to prepare
> + *
> + * Description: Allocates a buffer for integrity metadata, maps the
> + * pages and attaches them to a bio.  The bio must have data
> + * direction, target device and start sector set priot to calling.  In
> + * the WRITE case, integrity metadata will be generated using the
> + * block device's integrity function.  In the READ case, the buffer
> + * will be prepared for DMA and a suitable end_io handler set up.
> + */
> +int bio_integrity_prep(struct bio *bio)
> +{
> +	struct bip *bip;
> +	struct blk_integrity *bi;
> +	struct request_queue *q;
> +	void *buf;
> +	unsigned long start, end;
> +	unsigned int len, nr_pages;
> +	unsigned int bytes, offset, i;
> +	unsigned int sectors = bio_sectors(bio);
> +
> +	bi = bdev_get_integrity(bio->bi_bdev);
> +	q = bdev_get_queue(bio->bi_bdev);
> +	BUG_ON(bi == NULL);
> +	BUG_ON(bio_integrity(bio));
> +
> +	if (bi->sector_size == 4096)
> +		sectors >>= 3;
> +
> +	/* Allocate kernel buffer for protection data */
> +	len = sectors * blk_integrity_tuple_size(bi);
> +	buf = kzalloc(len, GFP_NOIO | q->bounce_gfp);
> +	if (unlikely(buf == NULL)) {
> +		printk(KERN_ERR "could not allocate integrity buffer\n");
> +		return -EIO;
> +	}
> +
> +	end = (((unsigned long) buf) + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	start = ((unsigned long) buf) >> PAGE_SHIFT;
> +	nr_pages = end - start;
> +
> +	/* Allocate bio integrity payload and integrity vectors */
> +	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_pages);
> +	if (unlikely(bip == NULL)) {
> +		printk(KERN_ERR "could not allocate data integrity bioset\n");
> +		kfree(buf);
> +		return -EIO;
> +	}
> +
> +	bip->bip_buf = buf;
> +	bip->bip_size = len;
> +	bip->bip_sector = bio->bi_sector;
> +
> +	/* Map it */
> +	offset = offset_in_page(buf);
> +	for (i = 0 ; i < nr_pages ; i++) {
> +		int ret;
> +		bytes = PAGE_SIZE - offset;
> +
> +		if (len <= 0)
> +			break;
> +
> +		if (bytes > len)
> +			bytes = len;
> +
> +		ret = bio_integrity_add_page(bio, virt_to_page(buf),
> +					     bytes, offset);
> +
> +		if (ret == 0)
> +			return 0;
> +
> +		if (ret < bytes)
> +			break;
> +
> +		buf += bytes;
> +		len -= bytes;
> +		offset = 0;
> +	}
> +
> +	/* Install custom I/O completion handler if read verify is enabled */
> +	if (bio_data_dir(bio) == READ) {
> +		bip->bip_end_io = bio->bi_end_io;
> +		bio->bi_end_io = bio_integrity_endio;
> +	}
> +
> +	/* Auto-generate integrity metadata if this is a write */
> +	if (bio_data_dir(bio) == WRITE)
> +		bio_integrity_generate(bio);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(bio_integrity_prep);
> +
> +/**
> + * bio_integrity_verify - Verify integrity metadata for a bio
> + * @bio:	bio to verify
> + *
> + * Description: This function is called to verify the integrity of a
> + * bio.	 The data in the bio io_vec is compared to the integrity
> + * metadata returned by the HBA.
> + */
> +static int bio_integrity_verify(struct bio *bio)
> +{
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	struct blk_integrity_exchg bix;
> +	struct bio_vec *bv;
> +	sector_t sector = bio->bi_integrity->bip_sector;
> +	unsigned int i, sectors, total, ret;
> +	void *prot_buf = bio->bi_integrity->bip_buf;
> +
> +	total = 0;
> +	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
> +	bix.sector_size = bi->sector_size;
> +
> +	bio_for_each_segment(bv, bio, i) {
> +		bix.data_buf = kmap_atomic(bv->bv_page, KM_USER0)
> +			+ bv->bv_offset;
> +		bix.data_size = bv->bv_len;
> +		bix.prot_buf = prot_buf;
> +		bix.sector = sector;
> +
> +		ret = bi->verify_fn(&bix);
> +
> +		if (ret) {
> +			kunmap_atomic(bv->bv_page, KM_USER0);
> +			return ret;
> +		}
> +
> +		sectors = bv->bv_len / bi->sector_size;
> +		sector += sectors;
> +		prot_buf += sectors * bi->tuple_size;
> +		total += sectors * bi->tuple_size;
> +		BUG_ON(total > bio->bi_integrity->bip_size);
> +
> +		kunmap_atomic(bv->bv_page, KM_USER0);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * bio_integrity_verify_fn - Integrity I/O completion worker
> + * @work:	Work struct stored in bio to be verified
> + *
> + * Description: This workqueue function is called to complete a READ
> + * request.  The function verifies the transferred integrity metadata
> + * and then calls the original bio end_io function.
> + */
> +static void bio_integrity_verify_fn(struct work_struct *work)
> +{
> +	struct bip *bip = container_of(work, struct bip, bip_work);
> +	struct bio *bio = bip->bip_bio;
> +	int error = bip->bip_error;
> +
> +	if (bio_integrity_verify(bio)) {
> +		clear_bit(BIO_UPTODATE, &bio->bi_flags);
> +		error = -EIO;
> +	}
> +
> +	/* Restore original bio completion handler */
> +	bio->bi_end_io = bip->bip_end_io;
> +
> +	if (bio->bi_end_io)
> +		bio->bi_end_io(bio, error);
> +}
> +
> +/**
> + * bio_integrity_endio - Integrity I/O completion function
> + * @bio:	Protected bio
> + * @error:	Pointer to errno
> + *
> + * Description: Completion for integrity I/O
> + *
> + * Normally I/O completion is done in interrupt context.  However,
> + * verifying I/O integrity is a time-consuming task which must be run
> + * in process context.	This function postpones completion
> + * accordingly.
> + */
> +void bio_integrity_endio(struct bio *bio, int error)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +
> +	BUG_ON(bip->bip_bio != bio);
> +
> +	bip->bip_error = error;
> +	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
> +	queue_work(kintegrityd_wq, &bip->bip_work);
> +}
> +EXPORT_SYMBOL(bio_integrity_endio);
> +
> +/**
> + * bio_integrity_advance - Advance integrity vector
> + * @bio:	bio whose integrity vector to update
> + * @bytes_done:	number of data bytes that have been completed
> + *
> + * Description: This function calculates how many integrity bytes the
> + * number of completed data bytes correspond to and advances the
> + * integrity vector accordingly.
> + */
> +void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	struct bio_vec *iv;
> +	unsigned int i, skip, nr_sectors;
> +
> +	BUG_ON(bip == NULL);
> +	BUG_ON(bi == NULL);
> +
> +	nr_sectors = bytes_done >> 9;
> +
> +	if (bi->sector_size == 4096)
> +		nr_sectors >>= 3;
> +
> +	skip = nr_sectors * bi->tuple_size;
> +
> +	bip_for_each_vec(iv, bip, i) {
> +		if (skip == 0) {
> +			bip->bip_idx = i;
> +			return;
> +		} else if (skip >= iv->bv_len) {
> +			skip -= iv->bv_len;
> +		} else { /* skip < iv->bv_len) */
> +			iv->bv_offset += skip;
> +			iv->bv_len -= skip;
> +			bip->bip_idx = i;
> +			return;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(bio_integrity_advance);
> +
> +/**
> + * bio_integrity_trim - Trim integrity vector
> + * @bio:	bio whose integrity vector to update
> + * @offset:	offset to first data sector
> + * @sectors:	number of data sectors
> + *
> + * Description: Used to trim the integrity vector in a cloned bio.
> + * The ivec will be advanced corresponding to 'offset' data sectors
> + * and the length will be truncated corresponding to 'len' data
> + * sectors.
> + */
> +void bio_integrity_trim(struct bio *bio, unsigned int offset, unsigned int sectors)
> +{
> +	struct bip *bip = bio->bi_integrity;
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> +	struct bio_vec *iv;
> +	unsigned int i, skip, nr_bytes;
> +
> +	BUG_ON(bip == NULL);
> +	BUG_ON(bi == NULL);
> +	BUG_ON(!bio_flagged(bio, BIO_CLONED));
> +
> +	if (bi->sector_size == 4096)
> +		sectors >>= 3;
> +
> +	bip->bip_sector = bip->bip_sector + offset;
> +	skip = offset * bi->tuple_size;
> +	nr_bytes = sectors * bi->tuple_size;
> +
> +	/* Mark head */
> +	bip_for_each_vec(iv, bip, i) {
> +		if (skip == 0) {
> +			bip->bip_idx = i;
> +			break;
> +		} else if (skip >= iv->bv_len) {
> +			skip -= iv->bv_len;
> +		} else { /* skip < iv->bv_len) */
> +			iv->bv_offset += skip;
> +			iv->bv_len -= skip;
> +			bip->bip_idx = i;
> +			break;
> +		}
> +	}
> +
> +	/* Mark tail */
> +	bip_for_each_vec(iv, bip, i) {
> +		if (nr_bytes == 0) {
> +			bip->bip_vcnt = i;
> +			break;
> +		} else if (nr_bytes >= iv->bv_len) {
> +			nr_bytes -= iv->bv_len;
> +		} else { /* nr_bytes < iv->bv_len) */
> +			iv->bv_len = nr_bytes;
> +			nr_bytes = 0;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(bio_integrity_trim);
> +
> +/**
> + * bio_integrity_split - Split integrity metadata
> + * @bio:	Protected bio
> + * @bp:		Resulting bio_pair
> + * @sectors:	Offset
> + *
> + * Description: Splits an integrity page into a bio_pair.
> + */
> +void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> +{
> +	struct blk_integrity *bi;
> +	struct bip *bip = bio->bi_integrity;
> +
> +	if (bio_integrity(bio) == 0)
> +		return;
> +
> +	bi = bdev_get_integrity(bio->bi_bdev);
> +	BUG_ON(bi == NULL);
> +	BUG_ON(bip->bip_vcnt != 1);
> +
> +	if (bi->sector_size == 4096)
> +		sectors >>= 3;
> +
> +	bp->bio1.bi_integrity = &bp->bip1;
> +	bp->bio2.bi_integrity = &bp->bip2;
> +
> +	bp->iv1 = bip->bip_vec[0];
> +	bp->iv2 = bip->bip_vec[0];
> +
> +	bp->bip1.bip_vec = &bp->iv1;
> +	bp->bip2.bip_vec = &bp->iv2;
> +
> +	bp->iv1.bv_len = sectors * bi->tuple_size;
> +	bp->iv2.bv_offset += sectors * bi->tuple_size;
> +	bp->iv2.bv_len -= sectors * bi->tuple_size;
> +
> +	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
> +	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + sectors;
> +
> +	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
> +	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
> +}
> +EXPORT_SYMBOL(bio_integrity_split);
> +
> +/**
> + * bio_integrity_clone - Callback for cloning bios with integrity metadata
> + * @bio:	New bio
> + * @bio_src:	Original bio
> + * @bs:		bio_set to allocate bip from
> + *
> + * Description:	Called to allocate a bip when cloning a bio
> + */
> +int bio_integrity_clone(struct bio *bio, struct bio *bio_src, struct bio_set *bs)
> +{
> +	struct bip *bip_src = bio_src->bi_integrity;
> +	struct bip *bip;
> +
> +	BUG_ON(bip_src == NULL);
> +
> +	bip = bio_integrity_alloc_bioset(bio, GFP_NOIO, bip_src->bip_vcnt, bs);
> +
> +	if (bip == NULL)
> +		return -EIO;
> +
> +	memcpy(bip->bip_vec, bip_src->bip_vec,
> +	       bip_src->bip_vcnt * sizeof(struct bio_vec));
> +
> +	bip->bip_sector = bip_src->bip_sector;
> +	bip->bip_vcnt = bip_src->bip_vcnt;
> +	bip->bip_idx = bip_src->bip_idx;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(bio_integrity_clone);
> +
> +int bioset_integrity_create(struct bio_set *bs, int pool_size)
> +{
> +	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size,
> +							  bio_integrity_slab);
> +	if (!bs->bio_integrity_pool)
> +		return -1;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(bioset_integrity_create);
> +
> +void bioset_integrity_free(struct bio_set *bs)
> +{
> +	if (bs->bio_integrity_pool)
> +		mempool_destroy(bs->bio_integrity_pool);
> +}
> +EXPORT_SYMBOL(bioset_integrity_free);
> +
> +void __init bio_integrity_init_slab(void)
> +{
> +	bio_integrity_slab = KMEM_CACHE(bip, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
> +}
> +EXPORT_SYMBOL(bio_integrity_init_slab);
> +
> +static int __init integrity_init(void)
> +{
> +	kintegrityd_wq = create_workqueue("kintegrityd");
> +
> +	if (!kintegrityd_wq)
> +		panic("Failed to create kintegrityd\n");
> +
> +	return 0;
> +}
> +subsys_initcall(integrity_init);
> diff -r 318fa71e735d -r f2ae9d5bce4c fs/bio.c
> --- a/fs/bio.c	Sat Jun 07 00:45:14 2008 -0400
> +++ b/fs/bio.c	Sat Jun 07 00:45:15 2008 -0400
> @@ -96,6 +96,9 @@
>  
>  		mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
>  	}
> +
> +	if (bio_integrity(bio))
> +		bio_integrity_free(bio, bio_set);
>  
>  	mempool_free(bio, bio_set->bio_pool);
>  }
> @@ -255,9 +258,19 @@
>  {
>  	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
>  
> -	if (b) {
> -		b->bi_destructor = bio_fs_destructor;
> -		__bio_clone(b, bio);
> +	if (!b)
> +		return NULL;
> +
> +	b->bi_destructor = bio_fs_destructor;
> +	__bio_clone(b, bio);
> +
> +	if (bio_integrity(bio)) {
> +		int ret;
> +
> +		ret = bio_integrity_clone(b, bio, fs_bio_set);
> +
> +		if (ret < 0)
> +			return NULL;
>  	}
>  
>  	return b;
> @@ -1229,6 +1242,9 @@
>  	bp->bio1.bi_private = bi;
>  	bp->bio2.bi_private = pool;
>  
> +	if (bio_integrity(bi))
> +		bio_integrity_split(bi, bp, first_sectors);
> +
>  	return bp;
>  }
>  
> @@ -1294,6 +1310,7 @@
>  	if (bs->bio_pool)
>  		mempool_destroy(bs->bio_pool);
>  
> +	bioset_integrity_free(bs);
>  	biovec_free_pools(bs);
>  
>  	kfree(bs);
> @@ -1308,6 +1325,9 @@
>  
>  	bs->bio_pool = mempool_create_slab_pool(bio_pool_size, bio_slab);
>  	if (!bs->bio_pool)
> +		goto bad;
> +
> +	if (bioset_integrity_create(bs, bio_pool_size))
>  		goto bad;
>  
>  	if (!biovec_create_pools(bs, bvec_pool_size))
> @@ -1336,6 +1356,7 @@
>  {
>  	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  
> +	bio_integrity_init_slab();
>  	biovec_init_slabs();
>  
>  	fs_bio_set = bioset_create(BIO_POOL_SIZE, 2);
> diff -r 318fa71e735d -r f2ae9d5bce4c include/linux/bio.h
> --- a/include/linux/bio.h	Sat Jun 07 00:45:14 2008 -0400
> +++ b/include/linux/bio.h	Sat Jun 07 00:45:15 2008 -0400
> @@ -64,6 +64,7 @@
>  
>  struct bio_set;
>  struct bio;
> +struct bip;
>  typedef void (bio_end_io_t) (struct bio *, int);
>  typedef void (bio_destructor_t) (struct bio *);
>  
> @@ -112,6 +113,9 @@
>  	atomic_t		bi_cnt;		/* pin count */
>  
>  	void			*bi_private;
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +	struct bip		*bi_integrity;  /* data integrity */
> +#endif
>  
>  	bio_destructor_t	*bi_destructor;	/* destructor */
>  };
> @@ -271,6 +275,29 @@
>   */
>  #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
>  
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +/*
> + * bio integrity payload
> + */
> +struct bip {
> +	struct bio		*bip_bio;	/* parent bio */
> +	struct bio_vec		*bip_vec;	/* integrity data vector */
> +
> +	sector_t		bip_sector;	/* virtual start sector */
> +
> +	void			*bip_buf;	/* generated integrity data */
> +	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
> +
> +	int			bip_error;	/* saved I/O error */
> +	unsigned int		bip_size;
> +
> +	unsigned short		bip_pool;	/* pool the ivec came from */
> +	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
> +	unsigned short		bip_idx;	/* current bip_vec index */
> +
> +	struct work_struct	bip_work;	/* I/O completion */
> +};
> +#endif /* CONFIG_BLK_DEV_INTEGRITY */
>  
>  /*
>   * A bio_pair is used when we need to split a bio.
> @@ -285,6 +312,10 @@
>  struct bio_pair {
>  	struct bio	bio1, bio2;
>  	struct bio_vec	bv1, bv2;
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +	struct bip	bip1, bip2;
> +	struct bio_vec	iv1, iv2;
> +#endif
>  	atomic_t	cnt;
>  	int		error;
>  };
> @@ -349,6 +380,9 @@
>  
>  struct bio_set {
>  	mempool_t *bio_pool;
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +	mempool_t *bio_integrity_pool;
> +#endif
>  	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
>  };
>  
> @@ -413,5 +447,56 @@
>  	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
>  #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
>  
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +
> +#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
> +#define bip_vec(bip)		bip_vec_idx(bip, 0)
> +
> +#define __bip_for_each_vec(bvl, bip, i, start_idx)			\
> +	for (bvl = bip_vec_idx((bip), (start_idx)), i = (start_idx);	\
> +	     i < (bip)->bip_vcnt;					\
> +	     bvl++, i++)
> +
> +#define bip_for_each_vec(bvl, bip, i)					\
> +	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
> +
> +#define bio_integrity(bio)	((bio)->bi_integrity ? 1 : 0)
> +
> +extern struct bip *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
> +extern struct bip *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
> +extern void bio_integrity_free(struct bio *, struct bio_set *);
> +extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
> +extern inline int bio_integrity_enabled(struct bio *bio);
> +extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
> +extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
> +extern int bio_integrity_prep(struct bio *);
> +extern void bio_integrity_endio(struct bio *, int);
> +extern void bio_integrity_advance(struct bio *, unsigned int);
> +extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
> +extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
> +extern int bio_integrity_clone(struct bio *, struct bio *, struct bio_set *);
> +extern int bioset_integrity_create(struct bio_set *, int);
> +extern void bioset_integrity_free(struct bio_set *);
> +extern void bio_integrity_init_slab(void);
> +
> +#else /* CONFIG_BLK_DEV_INTEGRITY */
> +
> +#define bio_integrity(a)		(0)
> +#define bioset_integrity_create(a, b)	(0)
> +#define bio_integrity_prep(a)		(0)
> +#define bio_integrity_enabled(a)	(0)
> +#define bio_integrity_clone(a, b, c)	(0)
> +#define bioset_integrity_free(a)	do { } while (0)
> +#define bio_integrity_free(a, b)	do { } while (0)
> +#define bio_integrity_endio(a, b)	do { } while (0)
> +#define bio_integrity_advance(a, b)	do { } while (0)
> +#define bio_integrity_trim(a, b, c)	do { } while (0)
> +#define bio_integrity_split(a, b, c)	do { } while (0)
> +#define bio_integrity_set_tag(a, b, c)	do { } while (0)
> +#define bio_integrity_get_tag(a, b, c)	do { } while (0)
> +#define bio_integrity_init_slab(a)	do { } while (0)
> +
> +#endif /* CONFIG_BLK_DEV_INTEGRITY */
> +
>  #endif /* CONFIG_BLOCK */
>  #endif /* __LINUX_BIO_H */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
