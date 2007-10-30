From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] Remove dma_coherent_mem interface
Date: Tue, 30 Oct 2007 14:35:14 -0600
Message-ID: <20071030203514.GC15111@parisc-linux.org>
References: <1193773405-15799-1-git-send-email-matthew@wil.cx> <1193773405-15799-2-git-send-email-matthew@wil.cx> <1193775991.3321.108.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43515 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXJ3UfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 16:35:15 -0400
Content-Disposition: inline
In-Reply-To: <1193775991.3321.108.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 30, 2007 at 03:26:31PM -0500, James Bottomley wrote:
> Its design was basically to facilitate the use of bus remote memory.
> There's a long thread somewhere discussing this with the ARM people.
> They had some type of SoC implementation that needed to allocate local
> memory for device descriptors.  The Q720 is pretty much the same way, so
> I used it to build the implementation when I created it for the ARM
> people.  This is the original thread:
> 
> http://marc.info/?t=108757862100001
> 
> They said they were implementing this system, so I've no idea what
> happened.

It's been over three years, and it hasn't happened.

> However, what are the problems the API is causing?  it seems
> useful, so there should be a preference in its favour of existence
> unless it's causing a problem.

What I'm currently looking at is the dmapool allocator.  It's not
exactly fast (a spinlock for each allocation ... no concept of cpu
affinity, etc), and some drivers (eg qla2xxx) use it in the performance
path.

One of the suggestions in the existing dmapool driver is to share the
guts of slab.  Well, slab is probably going away, so I took a look
at slub.  Slub really, *really* needs the struct page associated
with the page of memory allocated, so I'm currently working my way
through the architectures trying to turn dma_alloc_coherent into
dma_alloc_coherent_pages.

The dma_coherent_mem API is one of the things which gets in the way of
doing this.  So I deleted it, then sent the patch out for comments early.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
