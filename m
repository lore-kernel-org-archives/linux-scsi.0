From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Tue, 26 May 2009 14:08:57 +0900
Message-ID: <20090526140918I.fujita.tomonori@lab.ntt.co.jp>
References: <20090525074647.GK11363@kernel.dk>
	<20090525075008.GA23413@infradead.org>
	<20090526133549Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090526133549Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: hch@infradead.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 May 2009 13:36:43 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 25 May 2009 03:50:08 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, May 25, 2009 at 09:46:47AM +0200, Jens Axboe wrote:
> > > > But that patch looks good to me, avoiding one allocation for each
> > > > command and simplifying the code.  I try to remember why these were
> > > > two slabs to start with but can't find any reason.
> > > > 
> > > > Btw, we might just want to declare the sense buffer directly as a sized
> > > > array in the scsi command as there really doesn't seem to be a reason
> > > > not to allocate it.
> > > 
> > > That is also a workable solution. I've been trying to cut down on the
> > > number of allocations required per-IO, and there's definitely still some
> > > low hanging fruit there. Some of it is already included, like the inline
> > > io_vecs in the bio.
> > 
> > Btw, one thing I wanted to do for years is to add ->alloc_cmnd and
> > ->destroy_cmnd method to the host template which optionally move the
> > command allocation to the LLDD.  That way we can embedd the scsi_cmnd
> > into the drivers per-commad structure and eliminate another memory
> > allocation.  Also this would naturally extend the keep one cmnd pool
> > to drivers without requiring additional code.  As a second step it
> > would also allow killing the scsi_host_cmd_pool byt just having
> > a set of library routines that drivers which need SLAB_CACHE_DMA can
> > use.
> 
> We discussed this idea when I rewrote the sense allocation code, I
> think.
> 
> I like that idea that unifying scsi_cmnd and llds' per-commad
> structure however there is one tricky thing about it.
> 
> Currently, a lld frees (or reuses) its per-commad structure when it
> calls scsi_done(). SCSI-ml uses scsi_cmd after that so we need to
> change the lifetime management (so we need to inspect all the llds,
> e.g. this change will break iscsi ldd).

Oops, as you said, this can be optional (so we don't need to convert
all llds). But as I said, this changes the definition of when
scsi_cmnd is free and ldds don't like that change, I think.


> With that change, we can't tell llds how many per-commad structure are
> possibly necessary. In general, LLDs want to know the maximum number
> of per-commad structure; drivers allocates the number of per-commad
> structure equal to host_template->can_queue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
