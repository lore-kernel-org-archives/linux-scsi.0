From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold structure
Date: Wed, 08 Aug 2007 11:58:14 -0500
Message-ID: <46B9F626.9020200@cs.wisc.edu>
References: <46B600F4.7020601@torque.net>	<20070806130944R.fujita.tomonori@lab.ntt.co.jp>	<46B8A845.4080106@cs.wisc.edu> <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44633 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXHHQ6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 12:58:51 -0400
In-Reply-To: <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

FUJITA Tomonori wrote:
> On Tue, 07 Aug 2007 12:13:41 -0500
> Mike Christie <michaelc@cs.wisc.edu> wrote:
> 
>> FUJITA Tomonori wrote:
>>> Allocating 64K contiguous memory is not good so the next thing to do
>>> is converting sg to use the sg chaining support fully. Or it might be
>> For LLDs like aic7xxx, I think we are stuck with a small 
>> scsi_host_template->sg_tablesize, so to continue to get large requests 
>> like before will we have to still allocate large segments?
> 
> No. sg.c has:
> 
> sizeof(struct scatterlist) * min(q->max_hw_segments, q->max_phys_segments)
> 
> If a lld has small max_hw_segments, it doesn't allocate big contiguous
> memory.
> 

Are we talking about the same thing? Are you saying that it does not 
allocate big continuous memory for the scatterlist right? I was asking 
about continuous memory for the buffer sg.c copies data to/from for the 
IO operation. I was saying that currently for something like aic if we 
want to continue to support 8 MB commands (or whatever it was) like 
before, then because its sg_tablesize/max_hw_segments is so small we 
have to continue allocating large IO buffers. That did not change right? 
If so let me know because you save me :)


> 
>> Is block/scsi_ioctl.c converted to sg chaining in any tree yet? Is that 
>> in your tree or one of Jen's branches.
> 
> block/scsi_ioctl.c uses the standard block layer functions, there is
> nothing to convert in it. sglist doesn't change the standard block
> layer functions much since it doesn't allocate sg list. It changes
> only blk_rq_map_sg.
> 
> Now only scsi-ml is changed to allocate chaining sg list
> properly. Others like cciss are not converted yet, I think. It might
> make sense to have the standard block layer functions to allocate
> chaining sg list properly. So we could convert to potential consumers
> (scsi-ml, sg, ccisss, etc) use them though I'm not sure how many non
> scsi-ml needs chaining sg list.

For drivers like sg and st, do mean the the sg list that is passed to 
functions like scsi_execute_async? If we kill that argument, and instead 
have sg.c and other scsi_execute_async callers just call blk helpers 
like blk_rq_map_user then we would not have to worry about drivers like 
sg needing to know about chaining right? I mean sg.c would not every 
interact with a scatterlist. It would just interact with a request and 
the blk helpers map data for it. The scatterlist that sg and st interact 
with is bogus. It gets thrown away in scsi_execute_async and is only 
used for book keeping.

I think it would be best to either have drivers like sg and st use 
blk_rq helpers to map data to requests like in my patches (this way they 
never know about scatterlists), or have sg and st allocate and setup a 
scatterlist properly and then just attach that to the request like we 
did before (we would have to add back in those checks to scsi-ml to 
check for that case again for this latter idea).

cciss is different right since it is doing blk_rq_map_sg and that 
itself. I am not getting into that :)
