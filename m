From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add bsg queue resize
Date: Wed, 24 Jan 2007 09:04:57 +0100
Message-ID: <20070124080456.GB12718@kernel.dk>
References: <20070120232518E.fujita.tomonori@lab.ntt.co.jp> <20070123083403.GC5486@kernel.dk> <20070123152348.GD11995@kernel.dk> <20070124111613M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:22772 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198AbXAXIDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 03:03:19 -0500
Content-Disposition: inline
In-Reply-To: <20070124111613M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Wed, Jan 24 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH] add bsg queue resize
> Date: Tue, 23 Jan 2007 16:23:49 +0100
> 
> > On Tue, Jan 23 2007, Jens Axboe wrote:
> > > On Sat, Jan 20 2007, FUJITA Tomonori wrote:
> > > > This enables bsg to resize the queue depth via
> > > > SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
> > > > because the previous way to use contiguous memory makes it difficult
> > > > to resize the queue depth when a bsg_device has outstanding commands.
> > > 
> > > Overall the patch looks fine. I don't think we need a mempool though,
> > > and allocations could just use GFP_USER from the user invoked queuing
> > > paths. Just make it GFP_USER, we can always extend the
> > > bsg_alloc_command() to take a gfp_t argument as well If you get rid of
> > > the mempool, then resizing is simply just adjusting bd->max_queue.
> > 
> > Like so.
> 
> Thanks. I thought that pre-allocating bsg_command structures would be
> nice. But it doesn't matter much for me.

Probably not very useful in the end, we need to allocate some other
structures for IO anyway.

> One minor comment is that we could simplify __bsg_alloc_command
> failpath a bit?

Yep, applied. Another thing that needs cleaning up for the allocation is
the whole bsg_io_schedule() stuff.

-- 
Jens Axboe

