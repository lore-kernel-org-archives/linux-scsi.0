From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2.6.11] ide-scsi: map sg buffers in idescsi_input/output_buffers() to kernel virtual address
Date: Thu, 17 Mar 2005 21:33:21 +0100
Message-ID: <20050317203321.GF1800@suse.de>
References: <7A8F92187EF7A249BF847F1BF4903C040AFC85@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:31213 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261153AbVCQUdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 15:33:24 -0500
Content-Disposition: inline
In-Reply-To: <7A8F92187EF7A249BF847F1BF4903C040AFC85@ausx2kmpc103.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stuart_Hayes@Dell.com
Cc: linux-scsi@vger.kernel.org, Joshua_Giles@Dell.com

On Thu, Mar 17 2005, Stuart_Hayes@Dell.com wrote:
> Jens Axboe wrote:
> > On Wed, Mar 16 2005, Stuart_Hayes@Dell.com wrote:
> >> Jens Axboe wrote:
> >>> On Wed, Mar 16 2005, Stuart_Hayes@Dell.com wrote:
> >>>> Hayes, Stuart wrote:
> >>>>> This patch will map the sg buffers to kernel virtual memory space
> >>>>> in the functions idescsi_input_buffers() and
> >>>>> idescsi_output_buffers(). Without this patch, idescsi passes a
> >>>>> null pointer to atapi_input_bytes() and atapi_output_bytes() when
> >>>>> sg pages are in high memory (i686 architecture).
> >>>>> 
> >>>>> I'm attaching as a file, too, as the text will certainly be
> >>>>> wrapped. 
> >>>>> 
> >>>>> (Sorry for the subject rename--I'm trying to use the correct
> >>>>> format for patch emails.)
> >>>>> 
> >>>>> Thanks
> >>>>> Stuart
> >>>> 
> >>>> And, while there's another high memory/kmap patch question on this
> >>>> list... 
> >>>> 
> >>>> Is there some reason nobody seems interested in this patch (except
> >>>> Jens--thanks for the help!)?  I'm kind of new to sending in
> >>>> patches, and I'm not sure if I'm just not waiting long enough, or
> >>>> if there is a problem with this patch...
> >>>> 
> >>>> But really, we're getting a null pointer dereference oops when
> >>>> using ATAPI tape drives (with ide-scsi) without this patch...
> >>> 
> >>> Sorry, that did seem to get dropped on the floor. Actually I'm
> >>> wondering why you are seeing highmem pages there in the first place,
> >>> it would be easier/better just to limit ide-scsi to non-highmem
> >>> pages. That would remove the need to add any work arounds in the
> >>> driver.
> >> 
> >> I think we're seeing highmem pages in the sg list because that's
> >> where the user memory was when st_write() was called.
> >> 
> >> The sg list is set up when st_write(), which calls setup_buffering(),
> >> which calls st_map_user_pages()... this just sets up the sg pages to
> >> point directly to the user memory.  So, by the time ide-scsi comes
> >> into the picture, the sg list is already set up to point to high
> >> memory pages. 
> >> 
> >> Are you suggesting that ide-scsi should change the dma_mask for the
> >> device so that st_map_user_pages() won't let sg pages point to high
> >> memory?  Or is there something else I'm missing?
> > 
> > I think that is a bug, this effectively bypasses whatever
> > restrictions the scsi host adapter has said about memory limits. It
> > is a problem because the request doesn't come from the block layer
> > (which handles all of this).   
> > 
> > I would much prefer fixing that real issue!
> 
> By "whatever restrictions the scsi host adapter has said about memory
> limits", are you referring to the dma_boundary or the dma_mask?  I'm
> don't know any other ways a host adapter can specify memory limits.
> 
> I wasn't complete in my statement above, though--st_map_user_pages()
> does prevent the sg list from pointing to pages that are above the
> "max_pfn" for the device (it gets max_pfn from scsi_calculate_bounce_
> limit()), and that appears to be working ok.  But, even though
> max_pfn is 0xfffff (so that the maximum physical address of any sg
> page won't be over 4G (0xffffffff)), there are apparently high 
> memory pages that are below physical address of 4G (0xffffffff), but
> are still considered high memory.
> 
> So the entire first 4G of memory isn't low memory... for example,
> on my box, pfn 0xfbc3c, with physical address 0xfbc3c000, has the
> PG_highmem bit set in &(page)->flags.  Because of this, when ide-scsi
> needs to do PIO, it needs to do a kmap_atomic().
> 
> Am I completely missing your point?

Ok good, so st isn't broken at least. You are not missing my point, but
maybe you don't realize that highmem pages doesn't refer to any specific
address in memory - it refers to pages that don't have a virtual
mapping, so depending on the kernel config that can be anywhere between
~900MB and 2GB (typicall). ide-scsi should just use blk_max_low_pfn as
the bounce limit, that will work all the time.

-- 
Jens Axboe

