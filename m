From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer
	in scsi_cmnd
Date: Mon, 24 Dec 2007 10:04:52 +1100
Message-ID: <1198451092.6686.26.camel@pasglop>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	 <476E41D1.50606@panasas.com>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:37680 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXLWXHF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Dec 2007 18:07:05 -0500
In-Reply-To: <476E41D1.50606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: james.bottomley@steeleye.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, ralf@linux-mips.org, Christoph Hellwig <hch@infradead.org>


> This has the potential of leaving a big fat ugly hole in the middle of 
> scsi_cmnd. I would suggest of *just* moving the sense_buffer array to be
> the *first member* of struct scsi_cmnd. The command itself is already cache
> aligned, allocated by the proper flags to it's slab. And put a fat comment
> near it's definition.

The hole would only be present on non coherent architectures though. We
also still need the padding after the sense_buffer. But yeah, moving the
sense buffer to first position would diminish the size of the hole I
suppose.

> This is until a proper fix is sent. I have in my Q a proposition for a 
> more prominent solution, which I will send next month. Do to short comings
> in the sense handling and optimizations, but should definitely cover this
> problem.
> 
> The code should have time to be discussed and tested, so it is only 2.6.26
> material. For the duration of the 2.6.25 kernel we can live with a reorder
> of scsi_cmnd members, if it solves such a grave bug for some ARCHs.

Re-oreder isn't enough. We need both re-order and the __dma_buffer
annotation to ensure proper padding. Some archs have 64 or even 128
bytes cache line size.

I agree that in the long run, a better solution should be done involving
reworking the way the sense buffer is allocated. I started modifying the
EH code to kmalloc it, but it gets very messy with the current interface
between drivers and EH. I still have some patches around I can send,
though some drivers need fixing (error handling on kmalloc failure).
James seem to have a better idea of pre-allocating sense buffers per
host based on how many they can have in flight which I haven't looked
at.

Ben.

> Boaz
> ----
> [RFD below]
> My proposed solution will be has follows:
> 
>  1. Since the scsi protocol mandates an immediate REQUEST_SENSE after an error
>     in effect the Q is frozen until the REQUEST_SENSE command returns.
> 
>  2. The scsi-ml needs the sense buffer for its normal operation, independent 
>     from the ULD's request of the sence_buffer or not at request->sense. But
>     in effect, 90% of all scsi-requests come with ULD's allocated buffer for
>     sense, that is copied to, on command completion.
> 
>  3. 99% of all commands complete successfully, so if an optimization is 
>     proposed for the successful case, sacrificing a few cycles for the error
>     case than thats a good thing.
> 
>  My suggestion is to have a per Q, driver-overridable, sense buffer that is 
>  DMAed/written to by drivers. At the end of the REQUEST_SENSE command one
>  of 2 things will be done. Either copy the sense to the ULD's supplied buffer,
>  or if not available, allocate one from a dedicated mem_cache pool.

I think that's pretty much was James was proposing indeed.

>  So we are completely saving 92 bytes from scsi_cmnd by replacing the buffer
>  with a pointer. We can always read the sense into a per Q buffer. And 10% of
>  %1 of the times we will need to allocate a sense buffer from a dedicated mem_cache
>  I would say thats a nice optimization.
> 
>  The changes to scsi_error/scsi_cmnd and friends, is pretty strait forward. But
>  it depends on a conversion of 4/5 drivers to the new scsi_eh API for 
>  REQUEST_SENSE. I have only converted these drivers that interfered with the accessors
>  effort + 1 other places. But there are a few more places that are not converted.
>  Once done. The implementation can easily change with no affect on drivers.
> 
>  The reason I've started with this work is because the SCSI standard permits up
>  to 260 bytes of sense, which you guest right, is needed by the OSD command set.
> 
> Boaz

