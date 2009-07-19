From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
Date: Sun, 19 Jul 2009 14:35:36 +0300
Message-ID: <4A630508.1020802@panasas.com>
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5D9C46.2000002@panasas.com> <4A5F6E24.3080800@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:32344
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285AbZGSLfi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jul 2009 07:35:38 -0400
In-Reply-To: <4A5F6E24.3080800@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>

On 07/16/2009 09:15 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 07/15/2009 01:07 PM wrote:
>> On 07/14/2009 07:17 PM, Vladislav Bolkhovitin wrote:
<snip>
>>> +struct blk_kern_sg_hdr {
>>> +	struct scatterlist *orig_sgp;
>>> +	union {
>>> +		struct sg_table new_sg_table;
>>> +		struct scatterlist *saved_sg;
>>> +	};
>> There is a struct scatterlist * inside struct sg_table
>> just use that. No need for a union. (It's not like your saving
>> space). In the tail case nents == 1.
>> (orig_nents==0 and loose the tail_only)
> 
> This will uncover internal details of SG-chaining implementation, which 
> you wanted to hide. Or didn't?
> 

Are you commenting on the remove of tail_only, or the reuse of
->new_sg_table.sgl instead of ->saved_sg. The later makes tons of sense
to me.

if you want to keep the "tail_only" and not hack with nents && orig_nents
that's fine.

>>> +	while (hbio != NULL) {
>>> +		bio = hbio;
>>> +		hbio = hbio->bi_next;
>>> +		bio->bi_next = NULL;
>>> +
>>> +		blk_queue_bounce(q, &bio);
>> I do not understand. If you are bouncing on the bio level.
>> why do you need to do all the alignment checks and
>> sg-bouncing + tail handling all this is done again on the bio
>> level.
> 
> blk_queue_bounce() does another and completely independent level of 
> bouncing for pages allocated in the not accessible by the device area.
> 

No! you miss-understood. blk_queue_bounce() does all the bouncing,
high-mem, alignment, padding, draining, all of them.

The code you took from Tejun was meant to go at the bio level. Here
you are already taken care of.

All you need to do is:
	loop on all pages
		add_pc_page();
		when bio is full
			chain a new bio 
	and so on.

Then at the end call blk_make_request() which will do the bouncing and
the merging. No need for all the copy/tail_only etc.. this is done by
lower levels for you already.

If you do that then Tejun is right you should do an:
	bio_map_sg()
and not:
	blk_map_sg()

>> It looks to me that perhaps you did not understand Tejun's code
>> His code, as I remember, was on the bio level, but here you
>> are duplicating what is done in bio level.
>>
>> But maybe I don't understand. Tejun?
>>
>>> +	req->cmd_len = cmd_len;
>>> +	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
>>> +	memcpy(req->cmd, cmd, req->cmd_len);
>> Does not support large commands.
> 
> Will be fixed.
> 
> (BTW, the SCSI layer assumes large CDBs as single big buffers, but all 
> SCSI transports I checked transfer large CDBs in 2 different parts: the 
> first 16 bytes and the rest. I.e. they deal with 2 different buffers. 
> So, the target side (SCST) deals with 2 buffers for large CDBs as well. 
> Having only one req->cmd will force SCST to merge those 2 buffers into a 
> single buffer. 
> So, scs[i,t]_execute_async() will have to make an 
> allocation for this as well.)
> 

Yep, allocation of command buffer if command_size > 16

>>> +/**
>>> + * sg_copy_elem - copy one SG element to another
>>> + * @dst_sg:	destination SG element
>>> + * @src_sg:	source SG element
>>> + * @copy_len:	maximum amount of data to copy. If 0, then copy all.
>>> + * @d_km_type:	kmap_atomic type for the destination SG
>>> + * @s_km_type:	kmap_atomic type for the source SG
>>> + *
>>> + * Description:
>>> + *    Data from the source SG element will be copied to the destination SG
>>> + *    element. Returns number of bytes copied. Can switch to the next dst_sg
>>> + *    element, so, to copy to strictly only one dst_sg element, it must be
>>> + *    either last in the chain, or copy_len == dst_sg->length.
>>> + */
>>> +int sg_copy_elem(struct scatterlist *dst_sg, struct scatterlist *src_sg,
>>> +		 size_t copy_len, enum km_type d_km_type,
>>> +		 enum km_type s_km_type)
>>> +{
>>> +	size_t dst_len = dst_sg->length, dst_offs = dst_sg->offset;
>>> +
>>> +	return __sg_copy_elem(&dst_sg, &dst_len, &dst_offs, src_sg,
>>> +		copy_len, d_km_type, s_km_type);
>>> +}
>>> +EXPORT_SYMBOL(sg_copy_elem);
>> Is not sg_copy_elem a copy of an sg with one element. Why do we need
>> two exports.
> 
> Perhaps, yes.
> 
>> I would pass a nents count to below and discard this one.
> 
> Perhaps, yes, but only for possible future use. I don't see any use of 
> it at the moment.
> 

Why? for example the use of not having another export.

>>> +
>>> +/**
>>> + * sg_copy - copy one SG vector to another
>>> + * @dst_sg:	destination SG
>>> + * @src_sg:	source SG
>>> + * @copy_len:	maximum amount of data to copy. If 0, then copy all.
>>> + * @d_km_type:	kmap_atomic type for the destination SG
>>> + * @s_km_type:	kmap_atomic type for the source SG
>>> + *
>>> + * Description:
>>> + *    Data from the source SG vector will be copied to the destination SG
>>> + *    vector. End of the vectors will be determined by sg_next() returning
>>> + *    NULL. Returns number of bytes copied.
>>> + */
>>> +int sg_copy(struct scatterlist *dst_sg,
>>> +	    struct scatterlist *src_sg, size_t copy_len,
>> Total length is nice, but also a nents count
>>
>>> +	    enum km_type d_km_type, enum km_type s_km_type)
>>> +{
>>> +	int res = 0;
>>> +	size_t dst_len, dst_offs;
>>> +
>>> +	if (copy_len == 0)
>>> +		copy_len = 0x7FFFFFFF; /* copy all */
>>> +
>>> +	dst_len = dst_sg->length;
>>> +	dst_offs = dst_sg->offset;
>>> +
>>> +	do {
>>> +		copy_len -= __sg_copy_elem(&dst_sg, &dst_len, &dst_offs,
>>> +				src_sg, copy_len, d_km_type, s_km_type);
>>> +		if ((copy_len == 0) || (dst_sg == NULL))
>>> +			goto out;
>>> +
>>> +		src_sg = sg_next(src_sg);
>>> +	} while (src_sg != NULL);
>>> +
>>> +out:
>>> +	return res;
>>> +}
>>> +EXPORT_SYMBOL(sg_copy);
> 
> Thanks,
> Vlad
> 

