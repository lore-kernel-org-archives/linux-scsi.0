From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 11:22:28 +0100
Message-ID: <20081117102227.GG6703@one.firstfloor.org>
References: <20081115231113.8F2AF3E6618@basil.firstfloor.org> <491F8148.9000003@interlog.com> <20081116221722.GB6703@one.firstfloor.org> <20081117141240X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:34726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYKQKMw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Nov 2008 05:12:52 -0500
Content-Disposition: inline
In-Reply-To: <20081117141240X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Mon, Nov 17, 2008 at 02:11:51PM +0900, FUJITA Tomonori wrote:
> On Sun, 16 Nov 2008 23:17:22 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Sat, Nov 15, 2008 at 09:11:20PM -0500, Douglas Gilbert wrote:
> > > Andi Kleen wrote:
> > > >Instead of using GFP_DMA directly.
> > > >
> > > >Also I stubbed SG_SET_FORCE_LOW_DMA ioctls which don't make any sense
> > > >because the kernel should always use the correct values on its own.
> > > 
> > > You propose removing a define from a public interface and thereby
> > > might break existing code. A comment in sg.h might be appropriate.
> > 
> > Hmm, I assume those SG_SET_FORCE_* defines are only used 
> > in the kernel.
> 
> I don't think so. They are exported to userspace, the sg ioctl
> interface. There may be applications that use them.

I doubt it. For what would they use it? And when exactly
should an application know that some device has a 16MB
limit when the kernel driver doesn't know about that?

For me it looks more like a really old debugging interface.

> Well, I don't think that they are useful or a nice feature. They would
> become pointless when you finish your dma allocation rework. But I
> don't think that we can remove the existing API exported to userspace.

Ok I'll restore the defines. But readding the ioctls would
be messy. Do you really think that is needed? I would 
rather prefer to fix the driver to always GFP_DMA, but I am
not aware of any driver who needs it. Are you?

-Andi
