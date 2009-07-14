From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH]: New implementation of scsi_execute_async()
Date: Tue, 14 Jul 2009 20:16:08 +0400
Message-ID: <4A5CAF48.9020802@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A564685.9050907@cisco.com> <4A571F2D.3080609@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZGNQQI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2009 12:16:08 -0400
In-Reply-To: <4A571F2D.3080609@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>

Joe Eykholt wrote:
> Joe Eykholt wrote:
>> Vladislav Bolkhovitin wrote:
>>> This patch reimplements scsi_execute_async(). In the new version it's
>>> a lot less
>>> hackish and also has additional features. Namely:
>>>
>>> 1. Possibility to insert commands both in tail and in head of the queue.
>>>
>>> 2. Possibility to explicitly specify if the last SG element has space
>>> for padding.
>>>
>>> This patch based on the previous patches posted by Tejun Heo.
>>> Comparing to them
>>> it has the following improvements:
>>>
>>> 1. It uses BIOs chaining instead of kmalloc()ing the whole bio.
>>>
>>> 2. It uses SGs chaining instead of kmalloc()ing one big SG in case if
>>> direct
>>> mapping failed (e.g. because of DMA alignment or padding).
>>>
>>> 3. If direct mapping failed, if possible, it copies only the last SG
>>> element,
>>> not the whole SG.
>>>
>>> Also this patch adds and exports function blk_copy_sg(), which copies
>>> one SG to
>>> another.
>>>
>>> At the moment SCST is the only user of this functionality. It needs
>>> it, because
>>> its target drivers, which are, basically, SCSI drivers, can deal only
>>> with SGs,
>>> not with BIOs. But, according the latest discussions, there are other
>>> potential
>>> users for of this functionality, so I'm sending this patch in a hope
>>> that it will be
>>> also useful for them and eventually will be merged in the mainline
>>> kernel.
>>>
>>> This patch requires previously sent patch with subject "[PATCH]:
>>> Rename REQ_COPY_USER
>>> to more descriptive REQ_HAS_TAIL_SPACE_FOR_PADDING".
>>>
>>> It's against 2.6.30.1, but if necessary, I can update it to any
>>> necessary
>>> kernel version.
>>>
>>> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
>>>
>>>  block/blk-map.c            |  536
>>> +++++++++++++++++++++++++++++++++++++++++++++
>>>  drivers/scsi/scsi_lib.c    |  108 ++++++++-
>>>  include/linux/blkdev.h     |    6  include/scsi/scsi_device.h |   11
>>>  4 files changed, 660 insertions(+), 1 deletion(-)
>>>
>>> diff -upkr linux-2.6.30.1/block/blk-map.c linux-2.6.30.1/block/blk-map.c
>>> --- linux-2.6.30.1/block/blk-map.c    2009-06-10 07:05:27.000000000
>>> +0400
>>> +++ linux-2.6.30.1/block/blk-map.c    2009-07-09 21:33:07.000000000
>>> +0400
>>> @@ -5,6 +5,7 @@
>>>  #include <linux/module.h>
>>>  #include <linux/bio.h>
>>>  #include <linux/blkdev.h>
>>> +#include <linux/scatterlist.h>
>>>  #include <scsi/sg.h>        /* for struct sg_iovec */
>>>  
>>>  #include "blk.h"
>>> @@ -273,6 +274,541 @@ int blk_rq_unmap_user(struct bio *bio)
>>>  EXPORT_SYMBOL(blk_rq_unmap_user);
>>>  
>>>  /**
>>> + * blk_copy_sg - copy one SG vector to another
>>> + * @dst_sg:    destination SG
>>> + * @src_sg:    source SG
>>> + * @copy_len:    maximum amount of data to copy. If 0, then copy all.
>>> + * @d_km_type:    kmap_atomic type for the destination SG
>>> + * @s_km_type:    kmap_atomic type for the source SG
>>> + *
>>> + * Description:
>>> + *    Data from the destination SG vector will be copied to the
>>> source SG
>>
>> This should say:
>>
>> *    Data from the source SG vector will be copied to the destination SG
>>
>> It seems unlikely to result in real misuse, though!

Fixed, thanks. V2 of the patch is coming.

>>> + *    vector. End of the vectors will be determined by sg_next()
>>> returning
>>> + *    NULL. Returns number of bytes copied.
>>> + */
>>> +int blk_copy_sg(struct scatterlist *dst_sg,
>>> +        struct scatterlist *src_sg, size_t copy_len,
>>> +        enum km_type d_km_type, enum km_type s_km_type)
>>> +{
>>> +    int res = 0;
>>> +    size_t src_len, dst_len, src_offs, dst_offs;
>>> +    struct page *src_page, *dst_page;
>>> +
>>> +    if (copy_len == 0)
>>> +        copy_len = 0x7FFFFFFF; /* copy all */
>>> +
>>> +    dst_page = sg_page(dst_sg);
>>> +    dst_len = dst_sg->length;
>>> +    dst_offs = dst_sg->offset;
>>> +
>>> +    src_offs = 0;
>>> +    do {
>>> +        src_page = sg_page(src_sg);
>>> +        src_len = src_sg->length;
>>> +        src_offs = src_sg->offset;
>>> +
>>> +        do {
>>> +            void *saddr, *daddr;
>>> +            size_t n;
>>> +
>>> +            saddr = kmap_atomic(src_page, s_km_type) + src_offs;
>>> +            daddr = kmap_atomic(dst_page, d_km_type) + dst_offs;
>>
>> This may be correct, but what happens if dst_page is compound
>> and larger than PAGE_SIZE?  Could dst_offs be larger than PAGE_SIZE
>> and cause daddr to be past the mapping?  Can that happen?
>>
>> It seems better to me to do:
>>     daddr = kmap_atomic(dst_page + (dst_offs >> PAGE_SHIFT), d_km_type);
> 
> Just realized this isn't right either because the low bits of the offset
> are lost, but you get the issue.  Maybe if the page is compound
> the mapping is always contiguous anyway.

Correct will be something like:

saddr = kmap_atomic(src_page + (src_offs >> PAGE_SHIFT), s_km_type) + (src_offs & ~PAGE_MASK);

I fixed it together with a bunch of similar issues I found reviewing the code
after your comments.

>> I'm not an expert on sg list use, though, so what you have could
>> be perfectly all right.
>>
>> This should be tested on both i386 and x86_64 both.  Of course,
>> this comment applies to other places in the file.
>>
>>> +
>>> +            if ((src_offs == 0) && (dst_offs == 0) &&
>>> +                (src_len >= PAGE_SIZE) && (dst_len >= PAGE_SIZE) &&
>>> +                (copy_len >= PAGE_SIZE)) {
>>
>> The above has ten extra parens and would look nicer without them.
>> The same comment applies to other places in the patch.

Maybe, but I like the "extra" parens (BTW, in many languages they are required, not
extra), because they give for eyes "points of stop" during reading and, so,
make overlooking various errors much harder.

>> Also, I think the approved style is to do !src_offs instead of
>> src_offs == 0, though I also prefer the latter.

I've not found anything about it.

>>> +                copy_page(daddr, saddr);
>>> +                n = PAGE_SIZE;
>>
>>> +            } else {
>>> +                n = min_t(size_t, PAGE_SIZE - dst_offs,
>>> +                          PAGE_SIZE - src_offs);
>>> +                n = min(n, src_len);
>>> +                n = min(n, dst_len);
>>> +                n = min_t(size_t, n, copy_len);
>>> +                memcpy(daddr, saddr, n);
>>> +                dst_offs += n;
>>> +                src_offs += n;
>>> +            }
>>> +
>>> +            kunmap_atomic(saddr, s_km_type);
>>> +            kunmap_atomic(daddr, d_km_type);
>>> +
>>> +            res += n;
>>> +            copy_len -= n;
>>> +            if (copy_len == 0)
>>> +                goto out;
>>> +
>>> +            if ((src_offs & ~PAGE_MASK) == 0) {
>>> +                src_page = nth_page(src_page, 1);
>>> +                src_offs = 0;
>>> +            }
>>> +            if ((dst_offs & ~PAGE_MASK) == 0) {
>>> +                dst_page = nth_page(dst_page, 1);
>>> +                dst_offs = 0;
>>> +            }
>>> +
>>> +            src_len -= n;
>>> +            dst_len -= n;
>>> +            if (dst_len == 0) {
>>> +                dst_sg = sg_next(dst_sg);
>>> +                if (dst_sg == NULL)
>>> +                    goto out;
>>> +                dst_page = sg_page(dst_sg);
>>> +                dst_len = dst_sg->length;
>>> +                dst_offs = dst_sg->offset;
>>> +            }
>>> +        } while (src_len > 0);
>>> +
>>> +        src_sg = sg_next(src_sg);
>>> +    } while (src_sg != NULL);
>>> +
>>> +out:
>>> +    return res;
>>> +}
>>> +EXPORT_SYMBOL(blk_copy_sg);
>>> +
>>> +/**
>>> + * blk_rq_unmap_kern_sg - "unmaps" data buffers in the request
>>> + * @req:    request to unmap
>>> + * @do_copy:    sets copy data between buffers, if needed, or not
>>> + *
>>> + * Description:
>>> + *    It frees all additional buffers allocated for SG->BIO mapping.
>>> + */
>>> +void blk_rq_unmap_kern_sg(struct request *req, int do_copy)
>>> +{
>>> +    struct scatterlist *hdr = (struct scatterlist *)req->end_io_data;
>>> +
>>> +    if (hdr == NULL)
>>> +        goto out;
>>> +
>>> +    if (hdr->length == 0) {
>>> +        /* Tail element only was copied */
>>> +        struct scatterlist *new_sg = &hdr[1];
>>> +        struct scatterlist *orig_sg = (struct scatterlist
>>> *)hdr->page_link;
>>
>> Shouldn't these declarations be at the top?
>> Otherwise, there will be a cleanup patch to move it at some point.

I prefer having for variables the visibility scope as small as possible, hence
the style.

>> I'm not reviewing this in detail, by the way.  Just a few things that
>> caught my eye.

Thanks very much!
Vlad

