From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
Date: Thu, 16 Jul 2009 22:15:00 +0400
Message-ID: <4A5F6E24.3080800@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5D9C46.2000002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbZGPSOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 14:14:51 -0400
In-Reply-To: <4A5D9C46.2000002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>

Boaz Harrosh, on 07/15/2009 01:07 PM wrote:
> On 07/14/2009 07:17 PM, Vladislav Bolkhovitin wrote:
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
>> 4. When needed, copy_page() is used instead of memcpy() to copy the whole pages.
>>
>> Also this patch adds and exports functions sg_copy() and sg_copy_elem(), which
>> cop one SG to another and one SG element to another respectively.
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
>>  block/blk-map.c             |  408 ++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/scsi_lib.c     |  108 +++++++++++
>>  include/linux/blkdev.h      |    3 
>>  include/linux/scatterlist.h |    7 
>>  include/scsi/scsi_device.h  |   11 +
>>  lib/scatterlist.c           |  147 +++++++++++++++
>>  6 files changed, 683 insertions(+), 1 deletion(-)
>>
>> diff -upkr linux-2.6.30.1/block/blk-map.c linux-2.6.30.1/block/blk-map.c
>> --- linux-2.6.30.1/block/blk-map.c	2009-07-10 21:13:25.000000000 +0400
>> +++ linux-2.6.30.1/block/blk-map.c	2009-07-14 19:24:36.000000000 +0400
>> @@ -5,6 +5,7 @@
>>  #include <linux/module.h>
>>  #include <linux/bio.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/scatterlist.h>
>>  #include <scsi/sg.h>		/* for struct sg_iovec */
>>  
>>  #include "blk.h"
>> @@ -272,6 +273,413 @@ int blk_rq_unmap_user(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(blk_rq_unmap_user);
>>  
>> +struct blk_kern_sg_hdr {
>> +	struct scatterlist *orig_sgp;
>> +	union {
>> +		struct sg_table new_sg_table;
>> +		struct scatterlist *saved_sg;
>> +	};
> 
> There is a struct scatterlist * inside struct sg_table
> just use that. No need for a union. (It's not like your saving
> space). In the tail case nents == 1.
> (orig_nents==0 and loose the tail_only)

This will uncover internal details of SG-chaining implementation, which 
you wanted to hide. Or didn't?

>> +	while (hbio != NULL) {
>> +		bio = hbio;
>> +		hbio = hbio->bi_next;
>> +		bio->bi_next = NULL;
>> +
>> +		blk_queue_bounce(q, &bio);
> 
> I do not understand. If you are bouncing on the bio level.
> why do you need to do all the alignment checks and
> sg-bouncing + tail handling all this is done again on the bio
> level.

blk_queue_bounce() does another and completely independent level of 
bouncing for pages allocated in the not accessible by the device area.

> It looks to me that perhaps you did not understand Tejun's code
> His code, as I remember, was on the bio level, but here you
> are duplicating what is done in bio level.
> 
> But maybe I don't understand. Tejun?
>
>> +	req->cmd_len = cmd_len;
>> +	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
>> +	memcpy(req->cmd, cmd, req->cmd_len);
> 
> Does not support large commands.

Will be fixed.

(BTW, the SCSI layer assumes large CDBs as single big buffers, but all 
SCSI transports I checked transfer large CDBs in 2 different parts: the 
first 16 bytes and the rest. I.e. they deal with 2 different buffers. 
So, the target side (SCST) deals with 2 buffers for large CDBs as well. 
Having only one req->cmd will force SCST to merge those 2 buffers into a 
single buffer. So, scs[i,t]_execute_async() will have to make an 
allocation for this as well.)

>> +/**
>> + * sg_copy_elem - copy one SG element to another
>> + * @dst_sg:	destination SG element
>> + * @src_sg:	source SG element
>> + * @copy_len:	maximum amount of data to copy. If 0, then copy all.
>> + * @d_km_type:	kmap_atomic type for the destination SG
>> + * @s_km_type:	kmap_atomic type for the source SG
>> + *
>> + * Description:
>> + *    Data from the source SG element will be copied to the destination SG
>> + *    element. Returns number of bytes copied. Can switch to the next dst_sg
>> + *    element, so, to copy to strictly only one dst_sg element, it must be
>> + *    either last in the chain, or copy_len == dst_sg->length.
>> + */
>> +int sg_copy_elem(struct scatterlist *dst_sg, struct scatterlist *src_sg,
>> +		 size_t copy_len, enum km_type d_km_type,
>> +		 enum km_type s_km_type)
>> +{
>> +	size_t dst_len = dst_sg->length, dst_offs = dst_sg->offset;
>> +
>> +	return __sg_copy_elem(&dst_sg, &dst_len, &dst_offs, src_sg,
>> +		copy_len, d_km_type, s_km_type);
>> +}
>> +EXPORT_SYMBOL(sg_copy_elem);
> 
> Is not sg_copy_elem a copy of an sg with one element. Why do we need
> two exports.

Perhaps, yes.

> I would pass a nents count to below and discard this one.

Perhaps, yes, but only for possible future use. I don't see any use of 
it at the moment.

>> +
>> +/**
>> + * sg_copy - copy one SG vector to another
>> + * @dst_sg:	destination SG
>> + * @src_sg:	source SG
>> + * @copy_len:	maximum amount of data to copy. If 0, then copy all.
>> + * @d_km_type:	kmap_atomic type for the destination SG
>> + * @s_km_type:	kmap_atomic type for the source SG
>> + *
>> + * Description:
>> + *    Data from the source SG vector will be copied to the destination SG
>> + *    vector. End of the vectors will be determined by sg_next() returning
>> + *    NULL. Returns number of bytes copied.
>> + */
>> +int sg_copy(struct scatterlist *dst_sg,
>> +	    struct scatterlist *src_sg, size_t copy_len,
> 
> Total length is nice, but also a nents count
> 
>> +	    enum km_type d_km_type, enum km_type s_km_type)
>> +{
>> +	int res = 0;
>> +	size_t dst_len, dst_offs;
>> +
>> +	if (copy_len == 0)
>> +		copy_len = 0x7FFFFFFF; /* copy all */
>> +
>> +	dst_len = dst_sg->length;
>> +	dst_offs = dst_sg->offset;
>> +
>> +	do {
>> +		copy_len -= __sg_copy_elem(&dst_sg, &dst_len, &dst_offs,
>> +				src_sg, copy_len, d_km_type, s_km_type);
>> +		if ((copy_len == 0) || (dst_sg == NULL))
>> +			goto out;
>> +
>> +		src_sg = sg_next(src_sg);
>> +	} while (src_sg != NULL);
>> +
>> +out:
>> +	return res;
>> +}
>> +EXPORT_SYMBOL(sg_copy);

Thanks,
Vlad

