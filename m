From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 09:42:16 -0600
Message-ID: <20090503154216.GU8822@parisc-linux.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756251AbZECPmc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49FDB21B.3080301@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On Sun, May 03, 2009 at 06:02:51PM +0300, Boaz Harrosh wrote:
> I agree with Hugh. The allocation is done at, too-low in the food chain.
> (And that free of buffer at upper layer allocated by lower layer).
> 
> I think you need to separate the: "does lld need buffer, what size"
> from the "here is buffer prepare", so upper layer that can sleep does
> sleep.

So you want two function pointers in the request queue relating to discard?

> In all other buffer needing operations the allocation is done before
> submission of request, No?

It's not true for the flush request (the example I quoted).  Obviously,
the solution adopted here by IDE is Bad and Wrong ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
