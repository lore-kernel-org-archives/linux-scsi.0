From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 20:47:47 +0900
Message-ID: <20081117204828Y.fujita.tomonori@lab.ntt.co.jp>
References: <20081117112346.GI6703@one.firstfloor.org>
	<20081117202248D.fujita.tomonori@lab.ntt.co.jp>
	<20081117114338.GJ6703@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37515 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYKQLsC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 06:48:02 -0500
In-Reply-To: <20081117114338.GJ6703@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Mon, 17 Nov 2008 12:43:38 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Yeah, I know. It's not nice (as I wrote in the first mail), it doesn't
> > work well, etc. But it's not the point (as I wrote in the previous
> > mail). I'm against the patch just because I don't think the rules
> > about the userspace API permit removing the exiting API like this.
> 
> Ok perhaps removing the define was a bit much, but at least stubbing
> the ioctl should be transparent to the application.
> 
> Ok except that I return EINVAL in the set variant now. I could lie and return 0
> instead, although I suspect it wouldn't make much difference either 
> way.
>  
> > 
> > If the rules permit, I'm happy to try to remove more old features of
> > sg.
> 
> As long as old binaries don't break I don't see a problem with
> any such changes (afaik that's true for my change)

Well, your change might break old binaries. We never know.

As discussed, SG_SET_FORCE_LOW_DMA is not useful and doesn't work
well. But it might work in some environments.

If you make it lie and just return 0, the bounce buffer latency could
break old binaries. It's unlikely but we never know, that's the whole
point of the rules about the userspace API?

But if the rules permit, the patch is fine by me.
