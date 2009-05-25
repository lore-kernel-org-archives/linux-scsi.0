From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
Date: Mon, 25 May 2009 13:33:42 +0300
Message-ID: <4A1A7406.5060106@panasas.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <20090525074124.GA31746@infradead.org> <20090525074647.GK11363@kernel.dk> <20090525075008.GA23413@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090525075008.GA23413@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 05/25/2009 10:50 AM, Christoph Hellwig wrote:
> On Mon, May 25, 2009 at 09:46:47AM +0200, Jens Axboe wrote:
>>> But that patch looks good to me, avoiding one allocation for each
>>> command and simplifying the code.  I try to remember why these were
>>> two slabs to start with but can't find any reason.
>>>

I posted an answer to that here:
http://www.spinics.net/lists/kernel/msg889604.html

It was done for none-cache-coherent systems that need to dma into sense_buffer.

>>> Btw, we might just want to declare the sense buffer directly as a sized
>>> array in the scsi command as there really doesn't seem to be a reason
>>> not to allocate it.
>> That is also a workable solution. I've been trying to cut down on the
>> number of allocations required per-IO, and there's definitely still some
>> low hanging fruit there. Some of it is already included, like the inline
>> io_vecs in the bio.
> 
> Btw, one thing I wanted to do for years is to add ->alloc_cmnd and
> ->destroy_cmnd method to the host template which optionally move the
> command allocation to the LLDD.  That way we can embedd the scsi_cmnd
> into the drivers per-commad structure and eliminate another memory
> allocation.  

It is nice in theory, but when trying to implement I encountered some
problems.

1. If we have a machine with few type of hosts active each with it's own
cmnd_slab we end up with many more slabs then today. Even though at the
end they all happen to be of the same size. (With the pool reserves it
can get big also).

2. Some considerations are system-wide and system-dependent (like above
   problem) and should be centralized into one place so if/when things
   change they can be changed in one place.
2.1. Don't trust driver writers to do the right thing.

3. There are common needs that are cross drivers, and no code should be duplicated.
   For example Bidi-Commands, use of scsi_ptr, ISA_DMA, ... and such not.

I totally agree with the need and robustness this will give...

So I think we might approach this from a slightly different way.

Hosts specify an size_of_private_command at host template, which might include
the common-scsi_cmnd + sense_buffer + private_cmnd + optional scsi_ptr +
bidi_data_buffer + ...

scsi_ml has a base-two-sized set of slabs that get allocated on first use
(at host registration) and hosts get to share the pools with same size.
[Alternatively hosts just keep reserved-commands list and regular use gets
 kmalloced]

All handling is centralized, with special needs specified at host template
like dma_mask ISA_flags and such.

> Also this would naturally extend the keep one cmnd pool
> to drivers without requiring additional code.  As a second step it
> would also allow killing the scsi_host_cmd_pool byt just having
> a set of library routines that drivers which need SLAB_CACHE_DMA can
> use.
> 

I'm afraid this will need to be done first. Layout the new facilities
and implement today's lowest-denominator on top of that. Then convert
driver by driver. Finally remove the old croft.

Lets all agree on a rough sketch and we can all get behind it. There are
a few people I know that will help, Matthew Wilcox, Me , perhaps Jens
and Christoph.

This will also finally help Andi Kleen's needs with the masked allocators

Boaz
