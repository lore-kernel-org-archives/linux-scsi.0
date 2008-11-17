From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 20:22:16 +0900
Message-ID: <20081117202248D.fujita.tomonori@lab.ntt.co.jp>
References: <20081117102227.GG6703@one.firstfloor.org>
	<20081117200720M.fujita.tomonori@lab.ntt.co.jp>
	<20081117112346.GI6703@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43127 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbYKQLWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 06:22:30 -0500
In-Reply-To: <20081117112346.GI6703@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Mon, 17 Nov 2008 12:23:46 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > > I would rather prefer to fix the driver to always GFP_DMA, but I am
> > > not aware of any driver who needs it. Are you?
> > 
> > Well, theoretically, there migth be an user who want these ioctl with
> > all the drivers that are not capable of 64bit DMA since sg allocates
> > the reserved buffer with GFP_KERNEL. These driver might use the
> > block-layer bounce buffer. Users might want to use
> > SG_SET_FORCE_LOW_DMA to avoid the bounce buffer latency.
> 
> But that would force everything through the 16MB zone,
> putting a lot of pressure on it and might even overflow on some
> loads. I don't think that's a good strategy for any application.

Yeah, I know. It's not nice (as I wrote in the first mail), it doesn't
work well, etc. But it's not the point (as I wrote in the previous
mail). I'm against the patch just because I don't think the rules
about the userspace API permit removing the exiting API like this.

If the rules permit, I'm happy to try to remove more old features of
sg.
