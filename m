From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx_2: Avoid calling __sym_mfree with irqs
	disabled
Date: Thu, 25 Mar 2010 12:05:38 -0600
Message-ID: <20100325180538.GN3875@parisc-linux.org>
References: <1269536751-2463-1-git-send-email-stefan.bader@canonical.com> <1269537678.9182.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37165 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0CYSFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2010 14:05:40 -0400
Content-Disposition: inline
In-Reply-To: <1269537678.9182.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-scsi@vger.kernel.org

On Thu, Mar 25, 2010 at 11:21:17AM -0600, James Bottomley wrote:
> On Thu, 2010-03-25 at 18:05 +0100, Stefan Bader wrote:
> > The following patch was tested and seemed to avoid the warning. Howver
> > I am not completely sure that none of the later functions need to be
> > protected with spinlocks. Though it feels ok. But maybe someone can do
> > some sanity checking.
> 
> So, I'm afraid you're right, the patch as is won't work ... the problem
> is that __sym_mfree_dma does list manipulation and for safety that has
> to be under a lock.
> 
> The inception of this problem is that ARM needs a sleeping function on
> DMA free but nothing else does so, on every platform that sym2 is
> supported, this warning is bogus.

Oh good, I'm glad you wrote this, it saves me the typing ;-)

> One way of getting rid of it might be to undef SYM_MEM_FREE_UNUSED which
> will prevent the free routines actually from releasing memory ...
> another might be to drop the lock and reacquire it around the free ...
> but that's sitting in a list traversal function so it may expose us to
> list races again, so really the whole of the freeing routines would have
> to be re-written to be list safe under lock ...

The solution I'd suggest is to take out the WARN_ON in the x86 code.
It's never going to cause trouble on x86.

The real solution is to use DMA pools, but my supply of tuits is quite
limited these days, and converting sym2 to modern APIs isn't high on
my priority list.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
