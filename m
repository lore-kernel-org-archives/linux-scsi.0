From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 14:11:51 +0900
Message-ID: <20081117141240X.fujita.tomonori@lab.ntt.co.jp>
References: <20081115231113.8F2AF3E6618@basil.firstfloor.org>
	<491F8148.9000003@interlog.com>
	<20081116221722.GB6703@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55211 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYKQFMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 00:12:12 -0500
In-Reply-To: <20081116221722.GB6703@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 16 Nov 2008 23:17:22 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Sat, Nov 15, 2008 at 09:11:20PM -0500, Douglas Gilbert wrote:
> > Andi Kleen wrote:
> > >Instead of using GFP_DMA directly.
> > >
> > >Also I stubbed SG_SET_FORCE_LOW_DMA ioctls which don't make any sense
> > >because the kernel should always use the correct values on its own.
> > 
> > You propose removing a define from a public interface and thereby
> > might break existing code. A comment in sg.h might be appropriate.
> 
> Hmm, I assume those SG_SET_FORCE_* defines are only used 
> in the kernel.

I don't think so. They are exported to userspace, the sg ioctl
interface. There may be applications that use them.


> Is there a realistic case where user space
> could use them or are just just talking in general, objecting
> to any change outside #ifdef __KERNEL__ ?

Users can use them to avoid the block-layer bouncing with a driver
doesn't set unchecked_isa_dma but can't dma with all the memory
addresses.

Well, I don't think that they are useful or a nice feature. They would
become pointless when you finish your dma allocation rework. But I
don't think that we can remove the existing API exported to userspace.
