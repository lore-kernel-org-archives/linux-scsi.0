From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer
 in scsi_cmnd
Date: Mon, 07 Jan 2008 15:53:32 +0900
Message-ID: <20080107155332J.fujita.tomonori@lab.ntt.co.jp>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	<476E41D1.50606@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:63217 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYAGGzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 01:55:10 -0500
In-Reply-To: <476E41D1.50606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: benh@kernel.crashing.org, james.bottomley@steeleye.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, ralf@linux-mips.org, hch@infradead.org

On Sun, 23 Dec 2007 13:09:05 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Fri, Dec 21 2007 at 4:30 +0200, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
> > by some low level drivers (that typically happens with USB mass
> > storage).
> > 
> > This is a problem on non cache coherent architectures such as
> > embedded PowerPCs where the sense buffer can share cache lines with
> > other structure members, which leads to various forms of corruption.
> > 
> > This uses the newly defined __dma_buffer annotation to enforce that
> > on such platforms, the sense_buffer is contained within its own
> > cache line. This has no effect on cache coherent architectures.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> >  include/scsi/scsi_cmnd.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-merge.orig/include/scsi/scsi_cmnd.h	2007-12-21 13:07:14.000000000 +1100
> > +++ linux-merge/include/scsi/scsi_cmnd.h	2007-12-21 13:07:29.000000000 +1100
> > @@ -88,7 +88,7 @@ struct scsi_cmnd {
> >  				   	   working on */
> >  
> >  #define SCSI_SENSE_BUFFERSIZE 	96
> > -	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
> > +	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE] __dma_buffer;
> >  				/* obtained by REQUEST SENSE when
> >  				 * CHECK CONDITION is received on original
> >  				 * command (auto-sense) */
> 
> This has the potential of leaving a big fat ugly hole in the middle of 
> scsi_cmnd. I would suggest of *just* moving the sense_buffer array to be
> the *first member* of struct scsi_cmnd. The command itself is already cache
> aligned, allocated by the proper flags to it's slab. And put a fat comment
> near it's definition.
> 
> This is until a proper fix is sent. I have in my Q a proposition for a 
> more prominent solution, which I will send next month. Do to short comings
> in the sense handling and optimizations, but should definitely cover this
> problem.
> 
> The code should have time to be discussed and tested, so it is only 2.6.26
> material. For the duration of the 2.6.25 kernel we can live with a reorder
> of scsi_cmnd members, if it solves such a grave bug for some ARCHs.
> 
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
>  
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

I think that removing the sense_buffer array from scsi_cmnd effects
lots of LLDs. As I wrote in other mail, many LLDs assume that
scsi_cmnd:sense_buffer is always available. Another big task is to
take care about auto sense.

Have you already had some patches? I've just started to work on this
and I'd like to push that fix into 2.6.25.
