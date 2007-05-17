From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 20:37:31 +0300
Message-ID: <464C92DB.4050509@panasas.com>
References: <20070517054811.GV23798@kernel.dk>	<20070517145958P.fujita.tomonori@lab.ntt.co.jp>	<464C1721.8030009@panasas.com> <20070517201243E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:49062 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756420AbXEQRn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 13:43:27 -0400
In-Reply-To: <20070517201243E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

FUJITA Tomonori wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: Re: [PATCH v2] add bidi support for block pc requests
> Date: Thu, 17 May 2007 11:49:37 +0300
> 
>> FUJITA Tomonori wrote:
>>> From: Jens Axboe <jens.axboe@oracle.com>
>>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>>> Date: Thu, 17 May 2007 07:48:13 +0200
>>>
>>>> On Thu, May 17 2007, FUJITA Tomonori wrote:
>>>>> From: Jens Axboe <jens.axboe@oracle.com>
>>>>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>>>>> Date: Wed, 16 May 2007 19:53:22 +0200
>>>>>
>>>>>> On Wed, May 16 2007, Boaz Harrosh wrote:
>>>>>>> now there are 2 issues with this:
>>>>>>> 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
>>>>>>>    requests for use_sg=128 which will crash the kernel.
>>>>>> That sounds like a serious issue, it should definitely not happen. Stuff
>>>>>> like that would bite other drivers as well, are you absolutely sure that
>>>>>> is happening? Power-of-2 bug in your code, or in the SCSI code?
>>>>> Boaz, how do you send requests to the scsi-ml, via fs, sg, or bsg?
>> These are regular fs (ext3) requests during bootup. The machine will not
>> boot. (Usually from the read ahead code)
>> Don't believe me look at the second patch Over Tomo's cleanup.
>> If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
>> did in code:
>> 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
>> I suppose someone is looking at a different definition. Or there is
>> another call I need to do for this to work.
> 
> I modified your patch a bit (sgtable allocation) and set
> SCSI_MAX_SG_SEGMENTS to 127. My ppc64 box seems to work (with
> iscsi_tcp and ipr drivers).
> 
> iscsi_tcp sets sg_tablesize to 255, but blk_queue_max_phys_segments
> seems to work.
> 
> One thing that I found is:
> 
> +#define scsi_resid(cmd) ((cmd)->sg_table->resid)
> 
> 
> This doesn't work for some drivers (at least ipr) since they set
> cmd->resid even with commands without data transfer.

Hmm, since we need a residual count also for the bidi_in transfer
this problem is another reason for having the scsi_cmd_buff in struct
scsi_cmnd, allocate another one from a pool for the bidi case,
and point to the sglist in both cases rather than having a sg_table
header allocated along with the sg list.
Alternatively, having a pool for the no-data case might be another
possible solution, though it seems a bit odd to me.

<snip>

> -void scsi_free_sgtable(struct scatterlist *sgl, int index)
> +static struct scsi_sg_table *scsi_alloc_sgtable(int nseg, gfp_t gfp_mask)
>  {
>  	struct scsi_host_sg_pool *sgp;
> +	struct scsi_sg_table *sgt;
> +	unsigned int idx;
>  
> -	BUG_ON(index >= SG_MEMPOOL_NR);
> +	for (idx = 0; idx < SG_MEMPOOL_NR; idx++)
> +		if (scsi_sg_pools[idx].size >= nseg)
> +			goto found;

Tomo, I prefer the loop to be based on calculation as follows rather
than scanning the scsi_sg_pools table in order to minimize memory access
(and thrashing of the cpu data cache - each scsi_host_sg_pool takes a cache
row on x86_64)

+	for (i = 0, size = 8; i < SG_MEMPOOL_NR-1; i++, size <<= 1)
+		if (size > nents)
+			return i;

Benny
