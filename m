From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Sun, 16 Nov 2008 23:17:22 +0100
Message-ID: <20081116221722.GB6703@one.firstfloor.org>
References: <200811161211.212948789@firstfloor.org> <20081115231113.8F2AF3E6618@basil.firstfloor.org> <491F8148.9000003@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:55559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYKPWHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Nov 2008 17:07:46 -0500
Content-Disposition: inline
In-Reply-To: <491F8148.9000003@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sat, Nov 15, 2008 at 09:11:20PM -0500, Douglas Gilbert wrote:
> Andi Kleen wrote:
> >Instead of using GFP_DMA directly.
> >
> >Also I stubbed SG_SET_FORCE_LOW_DMA ioctls which don't make any sense
> >because the kernel should always use the correct values on its own.
> 
> You propose removing a define from a public interface and thereby
> might break existing code. A comment in sg.h might be appropriate.

Hmm, I assume those SG_SET_FORCE_* defines are only used 
in the kernel. Is there a realistic case where user space
could use them or are just just talking in general, objecting
to any change outside #ifdef __KERNEL__ ?


> Something that might trip:
>   find <kernel_src_tree> -name '*.[hc]' -exec \
>      grep SG_SET_FORCE_LOW_DMA {} \; -print
> 
> when the compiler gets upset.

I did that of course (using id-utils) and there were no users in tree.

-Andi

