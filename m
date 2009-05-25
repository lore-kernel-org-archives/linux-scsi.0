From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Mon, 25 May 2009 03:50:08 -0400
Message-ID: <20090525075008.GA23413@infradead.org>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <20090525074124.GA31746@infradead.org> <20090525074647.GK11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755501AbZEYHuT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090525074647.GK11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 25, 2009 at 09:46:47AM +0200, Jens Axboe wrote:
> > But that patch looks good to me, avoiding one allocation for each
> > command and simplifying the code.  I try to remember why these were
> > two slabs to start with but can't find any reason.
> > 
> > Btw, we might just want to declare the sense buffer directly as a sized
> > array in the scsi command as there really doesn't seem to be a reason
> > not to allocate it.
> 
> That is also a workable solution. I've been trying to cut down on the
> number of allocations required per-IO, and there's definitely still some
> low hanging fruit there. Some of it is already included, like the inline
> io_vecs in the bio.

Btw, one thing I wanted to do for years is to add ->alloc_cmnd and
->destroy_cmnd method to the host template which optionally move the
command allocation to the LLDD.  That way we can embedd the scsi_cmnd
into the drivers per-commad structure and eliminate another memory
allocation.  Also this would naturally extend the keep one cmnd pool
to drivers without requiring additional code.  As a second step it
would also allow killing the scsi_host_cmd_pool byt just having
a set of library routines that drivers which need SLAB_CACHE_DMA can
use.
