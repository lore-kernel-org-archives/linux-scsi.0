From: Nick Piggin <npiggin@suse.de>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Tue, 12 May 2009 06:57:16 +0200
Message-ID: <20090512045716.GC32535@wotan.suse.de>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au> <4A081002.4050802@in.ibm.com> <20090511115233.GB8112@parisc-linux.org> <4A081437.7000409@in.ibm.com> <20090511122135.GC8112@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090511122135.GC8112@parisc-linux.org>
Sender: linux-next-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sachin Sant <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 11, 2009 at 06:21:35AM -0600, Matthew Wilcox wrote:
> On Mon, May 11, 2009 at 05:34:07PM +0530, Sachin Sant wrote:
> > Matthew Wilcox wrote:
> >> On Mon, May 11, 2009 at 05:16:10PM +0530, Sachin Sant wrote:
> >>   
> >>> Today's Next tree failed to boot on a Power6 box with following BUG :
> >>
> >> This doesn't actually appear to be a SCSI bug ... it looks like SCSI tried
> >> to allocate memory and things went wrong in the memory allocator:
> >>
> >> [c0000000c7d038b0] [c0000000005d67d8] ._spin_lock+0x10/0x24
> >> [c0000000c7d03920] [c00000000013fbdc] .__slab_alloc_page+0x344/0x3cc
> >> [c0000000c7d039e0] [c000000000141168] .kmem_cache_alloc+0x13c/0x21c
> >> [c0000000c7d03aa0] [c000000000141b04] .kmem_cache_create+0x294/0x2a8
> >> [c0000000c7d03b90] [d000000000ea14cc] .scsi_init_queue+0x38/0x170 [scsi_mod]
> >>
> >> Which memory allocator did you have selected (SLAB, SLUB, SLOB, SLQB)?
> >>   
> > Default one. SLQB
> >
> > CONFIG_SLQB_ALLOCATOR=y
> > CONFIG_SLQB=y
> >
> > Page size is 64K with Config DEBUG_PAGEALLOC set.
> >
> > CONFIG_PPC_HAS_HASH_64K=y
> > CONFIG_PPC_64K_PAGES=y
> > CONFIG_DEBUG_PAGEALLOC=y
> 
> Hm.  We've seen some similar problems at Intel while doing database
> performance tests with SLQB.  Any ideas, Nick?

Hmm, I think (hope) your problems were fixed with the recent memory
coruption bug fix for SLQB. (if not, let me know)

This one possibly looks like a problem with remote memory allocation
or memory hotplug or something like that. I'll do a bit of code
review....
