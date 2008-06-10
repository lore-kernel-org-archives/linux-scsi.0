From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
Date: Tue, 10 Jun 2008 16:52:20 -0400
Message-ID: <x491w359fne.fsf@segfault.boston.devel.redhat.com>
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662AbYFJUwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 16:52:30 -0400
In-Reply-To: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net> (Martin
	K. Petersen's message of "Sat, 07 Jun 2008 00:55:37 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

Comments inlined below.

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

That assignment isn't necessary.

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

I see you've changed this to:

        nr_sectors = (len + bi->tag_size - 1) / bi->tag_size;

why not simply use DIV_ROUND_UP?

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

set_tag and get_tag are almost identical.  Any chance you want to factor
out that code?

> +/**
> + * bio_integrity_generate - Generate integrity metadata for a bio
> + * @bio:	bio to generate integrity metadata for
> + *
> + * Description: Generates integrity metadata for a bio by calling the
> + * block device's generation callback function.	 The bio must have a
> + * bip attached with enough room to accomodate the generated integrity
                                       ^^^^^^^^^^
accommodate

> + * metadata.
> + */
> +static void bio_integrity_generate(struct bio *bio)
> +{
> +	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);

Hmm, up until this point you use bi to mean bio_integrity, but now
it means blk_integrity.  Confusion will ensue.  ;)

> +	struct blk_integrity_exchg bix;

struct blk_integrity_exchg is not yet defined in your patch set, so this
will likely break git bisect.

> +int bio_integrity_prep(struct bio *bio)
> +{
...
> +	buf = kzalloc(len, GFP_NOIO | q->bounce_gfp);

Does this actually need to be zeroed?

> +void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
...
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

> +void bio_integrity_trim(struct bio *bio, unsigned int offset, unsigned int sectors)
> +{
...
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

The above two loops look pretty much the same to me.  Can you factor
that out to a helper?

Cheers,

Jeff
