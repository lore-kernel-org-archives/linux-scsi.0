From: Jeff Garzik <jeff@garzik.org>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 18:47:27 -0400
Message-ID: <49FE1EFF.2050406@garzik.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>	 <20090503071619.GP8822@parisc-linux.org>	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>	 <49FDEE64.5090302@garzik.org> <1241380067.5596.103.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241380067.5596.103.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2009-05-03 at 15:20 -0400, Jeff Garzik wrote:
>> [tangent...]
>>
>> Does make you wonder if a ->init_rq_fn() would be helpful, one that 
>> could perform gfp_t allocations rather than GFP_ATOMIC?  The idea being 
>> to call ->init_rq_fn() almost immediately after creation of struct 
>> request, by the struct request creator.
> 
> Isn't that what the current prep_fn actually is?

> It's hard to see how ... prep_rq_fn is already called pretty early ...
> almost as soon as the elevator has decided to spit out the request

prep_rq_fn is called very, very late -- from elv_next_request(), which 
is called from ->request_fn.

As quoted above, I'm talking about something closer to -creation- time, 
not -execution- time.


>> The creator of struct request generally has more freedom to sleep, and 
>> it seems logical to give low-level drivers a "fill in LLD-specific info" 
>> hook BEFORE the request is ever added to a request_queue.
> 
> Unfortunately it's not really possible to find a sleeping context in
> there:  The elevators have to operate from the current
> elv_next_request() context, which, in most drivers can either be user or
> interrupt.

Sure, because that's further down the pipeline at the request execution 
stage.  Think more like make_request time...

> The ideal for REQ_TYPE_DISCARD seems to be to force a page allocation
> tied to a bio when it's issued at the top.  That way everyone has enough
> memory when it comes down the stack (both extents and WRITE SAME sector
> will fit into a page ... although only just for WRITE SAME on 4k
> sectors).

Makes sense...

	Jeff


