From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 20:48:03 +0200
Message-ID: <200905032048.04219.bzolnier@gmail.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090503154216.GU8822@parisc-linux.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On Sunday 03 May 2009 17:42:16 Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 06:02:51PM +0300, Boaz Harrosh wrote:
> > I agree with Hugh. The allocation is done at, too-low in the food chain.
> > (And that free of buffer at upper layer allocated by lower layer).
> > 
> > I think you need to separate the: "does lld need buffer, what size"
> > from the "here is buffer prepare", so upper layer that can sleep does
> > sleep.
> 
> So you want two function pointers in the request queue relating to discard?
> 
> > In all other buffer needing operations the allocation is done before
> > submission of request, No?
> 
> It's not true for the flush request (the example I quoted).  Obviously,
> the solution adopted here by IDE is Bad and Wrong ...

When speaking about "the solution" do you mean that quick & ugly hack
that I needed to fix the unexpected regression during late -rc cycle? ;)

The proper solution would involve adding 'struct ide_cmd flush_cmd' to
ide_drive_t but I never got to verify/inquiry that is OK with the block
layer (if there can be only one flush rq outstanding or if we can have
both q->pre_flush_rq and q->post_flush_rq queued at the same time)...

Thanks,
Bart
