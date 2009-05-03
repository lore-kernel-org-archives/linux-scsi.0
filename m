From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 15:48:37 -0600
Message-ID: <20090503214836.GV8822@parisc-linux.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com> <49FDE3BB.505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49FDE3BB.505@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, May 03, 2009 at 02:34:35PM -0400, Jeff Garzik wrote:
> Yes, the task of figuring out -what to do- in the queue's request  
> function is quite complex, and discard makes it even more so.
>
> The API makes life difficult -- you have to pass temporary info to  
> yourself in ->prepare_flush_fn() and ->prepare_discard_fn(), and the  
> overall sum is a bewildering collection of opcodes, flags, and internal  
> driver notes to itself.
>
> Add to this yet another prep function, ->prep_rq_fn()
>
> It definitely sucks, especially with regards to failed atomic  
> allocations...   but I think fixing this quite a big more than Matthew  
> probably willing to tackle ;-)

I'm completely confused by the block layer API, to be honest.  Trying to
deduce how to add a new feature at this stage is hard (compare it to
adding the reflink operation to the VFS ...).  I'm definitely willing to
tackle changing the block device API, but it may take a while.

> My ideal block layer interface would be a lot more opcode-based, e.g.
>
> (1) create REQ_TYPE_DISCARD
>
> (2) determine at init if queue (a) supports explicit DISCARD and/or (b)  
> supports DISCARD flag passed with READ or WRITE
>
> (3) when creating a discard request, use block helpers w/ queue-specific  
> knowledge to create either
> 	(a) one request, REQ_TYPE_FS, with discard flag or
> 	(b) two requests, REQ_TYPE_FS followed by REQ_TYPE_DISCARD

I'm not sure we need option 3b.

> (4) blkdev_issue_discard() would function like an empty barrier, and  
> unconditionally create REQ_TYPE_DISCARD.

I can certainly prototype a replacement for discard_prep_fn along these lines.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
