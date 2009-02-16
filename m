From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Mon, 16 Feb 2009 13:18:16 +0900
Message-ID: <20090216131806X.fujita.tomonori@lab.ntt.co.jp>
References: <49902A9E.3070002@panasas.com>
	<1234185129-31858-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: bharrosh@panasas.com
Cc: avishay@gmail.com, jeff@garzik.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon,  9 Feb 2009 15:12:09 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> This patch includes osd infrastructure that will be used later by
> the file system.
> 
> Also the declarations of constants, on disk structures,
> and prototypes.
> 
> And the Kbuild+Kconfig files needed to build the exofs module.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  fs/exofs/Kbuild   |   30 +++++++
>  fs/exofs/Kconfig  |   13 +++
>  fs/exofs/common.h |  181 +++++++++++++++++++++++++++++++++++++++++
>  fs/exofs/exofs.h  |  139 ++++++++++++++++++++++++++++++++
>  fs/exofs/osd.c    |  230 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 593 insertions(+), 0 deletions(-)
>  create mode 100644 fs/exofs/Kbuild
>  create mode 100644 fs/exofs/Kconfig
>  create mode 100644 fs/exofs/common.h
>  create mode 100644 fs/exofs/exofs.h
>  create mode 100644 fs/exofs/osd.c

> +static void _osd_read(struct osd_request *or,
> +	const struct osd_obj_id *obj, uint64_t offset, struct bio *bio)
> +{
> +	osd_req_read(or, obj, bio, offset);
> +	EXOFS_DBGMSG("osd_req_read(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
> +		_LLU(obj->partition), _LLU(obj->id), _LLU(bio->bi_size),
> +		_LLU(offset));
> +}
> +
> +#ifdef __KERNEL__

Hmm?

> +static struct bio *_bio_map_pages(struct request_queue *req_q,
> +				  struct page **pages, unsigned page_count,
> +				  size_t length, gfp_t gfp_mask)
> +{
> +	struct bio *bio;
> +	int i;
> +
> +	bio = bio_alloc(gfp_mask, page_count);
> +	if (!bio) {
> +		EXOFS_DBGMSG("Failed to bio_alloc page_count=%d\n", page_count);
> +		return NULL;
> +	}
> +
> +	for (i = 0; i < page_count && length; i++) {
> +		size_t use_len = min(length, PAGE_SIZE);
> +
> +		if (use_len !=
> +		    bio_add_pc_page(req_q, bio, pages[i], use_len, 0)) {
> +			EXOFS_ERR("Failed bio_add_pc_page req_q=%p pages[i]=%p "
> +				  "use_len=%Zd page_count=%d length=%Zd\n",
> +				  req_q, pages[i], use_len, page_count, length);
> +			bio_put(bio);
> +			return NULL;
> +		}
> +
> +		length -= use_len;
> +	}
> +
> +	WARN_ON(length);
> +	return bio;
> +}

1) exofs builds bios by hand.
2) exofs passes bio to OSD SCSI ULD.

As a result, exofs and OSD SCSI ULD need to know the internal of bio,
that is, you reinvent the bio handling infrastructure, as pointed out
in another thread in scsi-ml.

_bio_map_pages is called where the VFS passes an array of a pointer to
a page frame.

Why can't you simply pass the array to OSD SCSI ULD? Then OSD SCSI ULD
can use the block layer helper functions to build a request out of
pages without knowing the internal of bio.


> +int osd_req_read_pages(struct osd_request *or,
> +	const struct osd_obj_id *obj, u64 offset, u64 length,
> +	struct page **pages, int page_count)
> +{
> +	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
> +	struct bio *bio = _bio_map_pages(req_q, pages, page_count, length,
> +					 GFP_KERNEL);
> +
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	_osd_read(or, obj, offset, bio);
> +	return 0;
> +}
> +#endif /* def __KERNEL__ */
> +
> +int osd_req_read_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
> +{
> +	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
> +	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
> +
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	_osd_read(or, obj, offset, bio);
> +	return 0;
> +}
> +
> +static void _osd_write(struct osd_request *or,
> +	const struct osd_obj_id *obj, uint64_t offset, struct bio *bio)
> +{
> +	osd_req_write(or, obj, bio, offset);
> +	EXOFS_DBGMSG("osd_req_write(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
> +		_LLU(obj->partition), _LLU(obj->id), _LLU(bio->bi_size),
> +		_LLU(offset));
> +}
> +
> +#ifdef __KERNEL__
> +int osd_req_write_pages(struct osd_request *or,
> +	const struct osd_obj_id *obj, u64 offset, u64 length,
> +	struct page **pages, int page_count)
> +{
> +	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
> +	struct bio *bio = _bio_map_pages(req_q, pages, page_count, length,
> +					 GFP_KERNEL);
> +
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	_osd_write(or, obj, offset, bio);
> +	return 0;
> +}
> +#endif /* def __KERNEL__ */
> +
> +int osd_req_write_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
> +{
> +	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
> +	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
> +
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	_osd_write(or, obj, offset, bio);
> +	return 0;
> +}
> -- 
> 1.6.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
