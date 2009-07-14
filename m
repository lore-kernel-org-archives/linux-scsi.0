From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH]: New implementation of scsi_execute_async()
Date: Tue, 14 Jul 2009 20:16:38 +0400
Message-ID: <4A5CAF66.3090909@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A59DF14.7060807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755366AbZGNQQs@vger.kernel.org>
In-Reply-To: <4A59DF14.7060807@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On 07/09/2009 09:14 PM, Vladislav Bolkhovitin wrote:
>> This patch reimplements scsi_execute_async(). In the new version it's a lot less
>> hackish and also has additional features. Namely:
>>
>> 1. Possibility to insert commands both in tail and in head of the queue.
>>
>> 2. Possibility to explicitly specify if the last SG element has space for padding.
>>
>> This patch based on the previous patches posted by Tejun Heo. Comparing to them
>> it has the following improvements:
>>
>> 1. It uses BIOs chaining instead of kmalloc()ing the whole bio.
>>
>> 2. It uses SGs chaining instead of kmalloc()ing one big SG in case if direct
>> mapping failed (e.g. because of DMA alignment or padding).
>>
>> 3. If direct mapping failed, if possible, it copies only the last SG element,
>> not the whole SG.
>>
>> Also this patch adds and exports function blk_copy_sg(), which copies one SG to
>> another.
>>
>> At the moment SCST is the only user of this functionality. It needs it, because
>> its target drivers, which are, basically, SCSI drivers, can deal only with SGs,
>> not with BIOs. But, according the latest discussions, there are other potential
>> users for of this functionality, so I'm sending this patch in a hope that it will be
>> also useful for them and eventually will be merged in the mainline kernel.
>>
>> This patch requires previously sent patch with subject "[PATCH]: Rename REQ_COPY_USER
>> to more descriptive REQ_HAS_TAIL_SPACE_FOR_PADDING".
>>
>> It's against 2.6.30.1, but if necessary, I can update it to any necessary
>> kernel version.
>>
>> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
>>
>>  block/blk-map.c            |  536 +++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/scsi_lib.c    |  108 ++++++++-
>>  include/linux/blkdev.h     |    6 
>>  include/scsi/scsi_device.h |   11 
>>  4 files changed, 660 insertions(+), 1 deletion(-)
>>
> 
> The scsi bits are not needed and just add complexity. 
> allocate the request, call blk_rq_map_kern_sg() and
> blk_execute_xxx directly from your driver. Since you exacly
> know your code path lots of if(s) and flags are saved and that ugly
> scsi_io_context allocation.

Are you against any helper functions? scsi_lib.c has only scsi_execute_async(),
which is a small helper function, which only hides internal machinery details.
All the flags it has are needed and can't be avoided, especially
SCSI_ASYNC_EXEC_FLAG_HAS_TAIL_SPACE_FOR_PADDING

The allocation of scsi_io_context is unavoidable, because sense buffer should
be allocated anyway.
 
> If you absolutely need that scsi_normalize_sense() of scsi_execute_req
> call it from driver, its already exported.

No, I don't need scsi_normalize_sense() and not use it anywhere.
 
>> diff -upkr linux-2.6.30.1/block/blk-map.c linux-2.6.30.1/block/blk-map.c
>> --- linux-2.6.30.1/block/blk-map.c	2009-06-10 07:05:27.000000000 +0400
>> +++ linux-2.6.30.1/block/blk-map.c	2009-07-09 21:33:07.000000000 +0400
>> @@ -5,6 +5,7 @@
>>  #include <linux/module.h>
>>  #include <linux/bio.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/scatterlist.h>
>>  #include <scsi/sg.h>		/* for struct sg_iovec */
>>  
>>  #include "blk.h"
>> @@ -273,6 +274,541 @@ int blk_rq_unmap_user(struct bio *bio)
>>  EXPORT_SYMBOL(blk_rq_unmap_user);
>>  
>>  /**
>> + * blk_copy_sg - copy one SG vector to another
>> + * @dst_sg:	destination SG
>> + * @src_sg:	source SG
>> + * @copy_len:	maximum amount of data to copy. If 0, then copy all.
>> + * @d_km_type:	kmap_atomic type for the destination SG
>> + * @s_km_type:	kmap_atomic type for the source SG
>> + *
>> + * Description:
>> + *    Data from the destination SG vector will be copied to the source SG
>> + *    vector. End of the vectors will be determined by sg_next() returning
>> + *    NULL. Returns number of bytes copied.
>> + */
>> +int blk_copy_sg(struct scatterlist *dst_sg,
>> +		struct scatterlist *src_sg, size_t copy_len,
>> +		enum km_type d_km_type, enum km_type s_km_type)
>> +{
>> +	int res = 0;
>> +	size_t src_len, dst_len, src_offs, dst_offs;
>> +	struct page *src_page, *dst_page;
>> +
>> +	if (copy_len == 0)
>> +		copy_len = 0x7FFFFFFF; /* copy all */
>> +
>> +	dst_page = sg_page(dst_sg);
>> +	dst_len = dst_sg->length;
>> +	dst_offs = dst_sg->offset;
>> +
>> +	src_offs = 0;
>> +	do {
>> +		src_page = sg_page(src_sg);
>> +		src_len = src_sg->length;
>> +		src_offs = src_sg->offset;
>> +
>> +		do {
>> +			void *saddr, *daddr;
>> +			size_t n;
>> +
>> +			saddr = kmap_atomic(src_page, s_km_type) + src_offs;
>> +			daddr = kmap_atomic(dst_page, d_km_type) + dst_offs;
>> +
>> +			if ((src_offs == 0) && (dst_offs == 0) &&
>> +			    (src_len >= PAGE_SIZE) && (dst_len >= PAGE_SIZE) &&
>> +			    (copy_len >= PAGE_SIZE)) {
>> +				copy_page(daddr, saddr);
>> +				n = PAGE_SIZE;
>> +			} else {
>> +				n = min_t(size_t, PAGE_SIZE - dst_offs,
>> +						  PAGE_SIZE - src_offs);
>> +				n = min(n, src_len);
>> +				n = min(n, dst_len);
>> +				n = min_t(size_t, n, copy_len);
>> +				memcpy(daddr, saddr, n);
>> +				dst_offs += n;
>> +				src_offs += n;
>> +			}
>> +
>> +			kunmap_atomic(saddr, s_km_type);
>> +			kunmap_atomic(daddr, d_km_type);
>> +
>> +			res += n;
>> +			copy_len -= n;
>> +			if (copy_len == 0)
>> +				goto out;
>> +
>> +			if ((src_offs & ~PAGE_MASK) == 0) {
>> +				src_page = nth_page(src_page, 1);
>> +				src_offs = 0;
>> +			}
>> +			if ((dst_offs & ~PAGE_MASK) == 0) {
>> +				dst_page = nth_page(dst_page, 1);
>> +				dst_offs = 0;
>> +			}
>> +
>> +			src_len -= n;
>> +			dst_len -= n;
>> +			if (dst_len == 0) {
>> +				dst_sg = sg_next(dst_sg);
>> +				if (dst_sg == NULL)
>> +					goto out;
>> +				dst_page = sg_page(dst_sg);
>> +				dst_len = dst_sg->length;
>> +				dst_offs = dst_sg->offset;
>> +			}
>> +		} while (src_len > 0);
>> +
>> +		src_sg = sg_next(src_sg);
>> +	} while (src_sg != NULL);
>> +
>> +out:
>> +	return res;
>> +}
>> +EXPORT_SYMBOL(blk_copy_sg);
>> +
> 
> This has nothing to do with block layer lib/scatterlist.c is a better
> candidate.

Done. V2 of the patch is coming.
 
> see if you can refactor it better together with sg_copy_to/from_buffer

Unfortunately, they can't be used, because in there is a need to copy one SG
entry to another (sg_copy_elem() in the V2). Using sg_copy_elem() sg_copy()
implemented in just a few tens LOC.
 
>> +/**
>> + * blk_rq_unmap_kern_sg - "unmaps" data buffers in the request
>> + * @req:	request to unmap
>> + * @do_copy:	sets copy data between buffers, if needed, or not
>> + *
>> + * Description:
>> + *    It frees all additional buffers allocated for SG->BIO mapping.
>> + */
>> +void blk_rq_unmap_kern_sg(struct request *req, int do_copy)
>> +{
>> +	struct scatterlist *hdr = (struct scatterlist *)req->end_io_data;
>> +
> 
> You can't use req->end_io_data  here! req->end_io_data is reserved for
> blk_execute_async callers. It can not be used for private block use.

Why? I see blk_execute_rq() happily uses it. Plus, I implemented stacking of
it in scsi_execute_async().

Do you have better suggestion?
 
> (Don't you use it in this patchset from scsi_execute_async ?)

As I wrote, I used patches posted by Tejun Heo.
 
>> +	if (hdr == NULL)
>> +		goto out;
>> +
>> +	if (hdr->length == 0) {
>> +		/* Tail element only was copied */
>> +		struct scatterlist *new_sg = &hdr[1];
>> +		struct scatterlist *orig_sg = (struct scatterlist *)hdr->page_link;
>> +
> 
> I don't like that overloading of (scatterlist *) like that. Put a well defined struct
> or union with proper flags and types, so all possibilities are clear at both sides of
> the code. Document that structure for the different options.

Done.
 
>> +		if ((rq_data_dir(req) == READ) && do_copy) {
>> +			void *saddr, *daddr;
>> +
>> +			saddr = kmap_atomic(sg_page(orig_sg), KM_BIO_SRC_IRQ);
>> +			daddr = kmap_atomic(sg_page(new_sg), KM_BIO_DST_IRQ) +
>> +					new_sg->offset;
>> +			memcpy(daddr, saddr, orig_sg->length);
>> +			kunmap_atomic(saddr, KM_BIO_SRC_IRQ);
>> +			kunmap_atomic(daddr, KM_BIO_DST_IRQ);
>> +		}
>> +
>> +		__free_pages(sg_page(orig_sg), get_order(orig_sg->length));
>> +		*orig_sg = *new_sg;
>> +		kfree(hdr);
>> +	} else {
>> +		/* The whole SG was copied */
>> +		struct scatterlist *new_sgl = &hdr[1];
>> +		struct scatterlist *orig_sgl = (struct scatterlist *)hdr->page_link;
>> +		struct scatterlist *sg, *start_sg;
> 
> Here too ugly as hell, use a proper structure with the needed types.

The same.
 
>> +		int n;
>> +
>> +		if ((rq_data_dir(req) == READ) && do_copy) {
>> +			blk_copy_sg(orig_sgl, new_sgl, 0, KM_BIO_DST_IRQ,
>> +				KM_BIO_SRC_IRQ);
>> +		}
>> +
>> +		start_sg = hdr;
>> +		sg = new_sgl;
>> +		n = 1;
>> +		while (sg != NULL) {
>> +			__free_page(sg_page(sg));
>> +			sg = sg_next(sg);
>> +			n++;
>> +			/* One entry for chaining */
>> +			if ((sg == NULL) || (n == (SG_MAX_SINGLE_ALLOC - 1))) {
>> +				kfree(start_sg);
>> +				start_sg = sg;
>> +				n = 0;
>> +			}
>> +		}
>> +	}
>> +
>> +out:
>> +	return;
>> +}
>> +EXPORT_SYMBOL(blk_rq_unmap_kern_sg);
>> +
>> +static int blk_rq_handle_align_tail_only(struct request *rq,
>> +					 struct scatterlist *sg_to_copy,
>> +					 gfp_t gfp, gfp_t page_gfp)
>> +{
>> +	int res = 0;
>> +	struct scatterlist *tail_sg = sg_to_copy;
>> +	struct scatterlist *new_sg;
>> +	struct scatterlist *hdr;
>> +	int new_sg_nents;
>> +	struct page *pg;
>> +
>> +	new_sg_nents = 2;
>> +
>> +	new_sg = kmalloc(sizeof(*new_sg) * new_sg_nents, gfp);
>> +	if (new_sg == NULL)
>> +		goto out_nomem;
>> +
>> +	sg_init_table(new_sg, new_sg_nents);
>> +
>> +	hdr = new_sg;
>> +	new_sg++;
>> +	new_sg_nents--;
>> +
>> +	hdr->page_link = (unsigned long)tail_sg;
>> +	*new_sg = *tail_sg;
>> +
>> +	pg = alloc_pages(page_gfp, get_order(tail_sg->length));
>> +	if (pg == NULL)
>> +		goto err_free_new_sg;
>> +
>> +	if (rq_data_dir(rq) == WRITE) {
>> +		void *saddr, *daddr;
>> +		saddr = kmap_atomic(sg_page(tail_sg), KM_USER0) +
>> +				tail_sg->offset;
>> +		daddr = kmap_atomic(pg, KM_USER1);
>> +		memcpy(daddr, saddr, tail_sg->length);
>> +		kunmap_atomic(saddr, KM_USER0);
>> +		kunmap_atomic(daddr, KM_USER1);
>> +	}
>> +
>> +	sg_assign_page(tail_sg, pg);
>> +	tail_sg->offset = 0;
>> +
>> +	rq->end_io_data = hdr;
>> +	rq->cmd_flags |= REQ_HAS_TAIL_SPACE_FOR_PADDING;
>> +
>> +out:
>> +	return res;
>> +
>> +err_free_new_sg:
>> +	kfree(new_sg);
>> +
>> +out_nomem:
>> +	res = -ENOMEM;
>> +	goto out;
>> +}
>> +
>> +static int blk_rq_handle_align(struct request *rq, struct scatterlist **psgl,
>> +			       int *pnents, struct scatterlist *sgl_to_copy,
>> +			       int nents_to_copy, gfp_t gfp, gfp_t page_gfp)
>> +{
>> +	int res = 0, i;
>> +	struct scatterlist *sgl = *psgl;
>> +	int nents = *pnents;
>> +	struct scatterlist *sg, *prev_sg;
>> +	struct scatterlist *new_sgl;
>> +	struct scatterlist *hdr;
>> +	size_t len = 0, to_copy;
>> +	int new_sgl_nents, new_sgl_nents_to_alloc, n;
>> +
> 
> below should use the sg_alloc_table / sg_free_table constructs for
> the proper chaining/setting of scatterlist chains. Failing to do so
> is both a code duplication and hinder of future changes to these constructs.
> see all places that use sg_alloc_table/sg_free_table in source like scsi_lib.c.

Done. I didn't know about sg_alloc_table()/sg_free_table().

> I'll stop the review here. You need to solve the req->end_io_data use and change
> this to sg_alloc_table/sg_free_table (perhaps the one with the callback i'm not sure)
> 
> I'll continue review on the next patchset.

Thanks!
Vlad
