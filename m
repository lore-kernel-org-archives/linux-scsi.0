From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 19:34:14 +0300
Message-ID: <49FDC786.6070309@panasas.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090503154216.GU8822@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On 05/03/2009 06:42 PM, Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 06:02:51PM +0300, Boaz Harrosh wrote:
>> I agree with Hugh. The allocation is done at, too-low in the food chain.
>> (And that free of buffer at upper layer allocated by lower layer).
>>
>> I think you need to separate the: "does lld need buffer, what size"
>> from the "here is buffer prepare", so upper layer that can sleep does
>> sleep.
> 
> So you want two function pointers in the request queue relating to discard?
> 

OK I don't know what I want, I guess. ;-)

I'm not a block-device export but from the small osdblk device I maintain
it looks like osdblk_prepare_flush which is set into:
    blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);

does some internal structure setup, but the actual flush command is only executed
later in the global osdblk_rq_fn which is set into:
    blk_init_queue(osdblk_rq_fn, &osdev->lock);

But I'm not even sure that prepare_flush is called in a better context then
queue_fn, and what does it means to let block devices take care of another
new command type at queue_fn.

I guess it comes back to Jeff Garzik's comment about not having a central
place to ask the request what we need to do.

But I do hate that allocation is done by driver and free by mid-layer,
so yes two vectors, request_queue is allocated once per device it's not
that bad. And later when Jeff's comment is addressed it can be removed.

>> In all other buffer needing operations the allocation is done before
>> submission of request, No?
> 
> It's not true for the flush request (the example I quoted).  Obviously,
> the solution adopted here by IDE is Bad and Wrong ...
> 

So now I don't understand, is flush executed by the queue_fn or by the
prepare_flush, or am I seeing two type of flushes?

Thanks
Boaz
