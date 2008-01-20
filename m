From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] remove use_sg_chaining
Date: Sun, 20 Jan 2008 14:52:01 -0600
Message-ID: <1200862321.3105.20.camel@localhost.localdomain>
References: <1200419579.9273.39.camel@localhost.localdomain>
	 <47939E9B.9020906@panasas.com>
	 <1200857062.3105.15.camel@localhost.localdomain>
	 <4793A6ED.1080707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49176 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbYATUwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 15:52:05 -0500
In-Reply-To: <4793A6ED.1080707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>


On Sun, 2008-01-20 at 21:54 +0200, Boaz Harrosh wrote:
> On Sun, Jan 20 2008 at 21:24 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Sun, 2008-01-20 at 21:18 +0200, Boaz Harrosh wrote:
> >> On Tue, Jan 15 2008 at 19:52 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>> this patch depends on the sg branch of the block tree
> >>>
> >>> James
> >>>
> >>> ---
> >>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>> Date: Tue, 15 Jan 2008 11:11:46 -0600
> >>> Subject: remove use_sg_chaining
> >>>
> >>> With the sg table code, every SCSI driver is now either chain capable
> >>> or broken, so there's no need to have a check in the host template.
> >>>
> >>> Also tidy up the code by moving the scatterlist size defines into the
> >>> SCSI includes and permit the last entry of the scatterlist pools not
> >>> to be a power of two.
> >>> ---
> >> I have a theoretical problem that BUGed me from the beginning.
> >>
> >> Could it happen that a memory critical IO, (that is needed to free
> >> memory), be collected into an sg-chained large IO, and the allocation 
> >> of the multiple sg-pool-allocations fail, thous dead locking on
> >> out-of-memory? Is there a mechanism in place that will split large IO's 
> >> into smaller chunks in the event of out-of-memory condition in prep_fn?
> >>
> >> Is it possible to call blk_rq_map_sg() with less then what is present
> >> at request to only map the starting portion?
> > 
> > Obviously, that's why I was worrying about mempool size and default
> > blocks a while ago.
> > 
> > However, the deadlock only occurs if the device is swap or backing a
> > filesystem with memory mapped files.  The use cases for this are really
> > tapes and other entities that need huge buffers.  That's why we're
> > keeping the system sector size at 1024 unless you alter it through sysfs
> > (here gun, there foot ...)
> > 
> > James
> > 
> 
> OK Thanks for confirming my concern, In modern life with devices like
> iSCSI that have ~0 as it's max_sector, swapping over that should be considered
> and configured carefully. Once with pNFS over blocks/objects it should be addressed.
> Perhaps with a FAIL_FAST semantics for users like pNFS to split up the requests if they
> fail with out-of-memory.

Well, swap over networked backed devices is an order of magnitude worse
of a problem.

However, the block layer doesn't let you set max_sectors over 1024; even
when iscsi requests ~0 it gets 1024 but the user is allowed to raise
this via sysfs. (That's the difference between max_sectors [currently
operating parameter] and max_hw_sectors [passed in maximum])

James


