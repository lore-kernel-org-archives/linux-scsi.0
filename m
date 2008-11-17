From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 20:07:20 +0900
Message-ID: <20081117200720M.fujita.tomonori@lab.ntt.co.jp>
References: <20081116221722.GB6703@one.firstfloor.org>
	<20081117141240X.fujita.tomonori@lab.ntt.co.jp>
	<20081117102227.GG6703@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:60816 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQLGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Nov 2008 06:06:22 -0500
In-Reply-To: <20081117102227.GG6703@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Mon, 17 Nov 2008 11:22:28 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Well, I don't think that they are useful or a nice feature. They would
> > become pointless when you finish your dma allocation rework. But I
> > don't think that we can remove the existing API exported to userspace.
> 
> Ok I'll restore the defines. But readding the ioctls would
> be messy. Do you really think that is needed?

As I wrote in the previous mail, I don't think that it's useful. But
it's not the point. My point is that we can't remove the existing sg
ioctl interface like we can't remove the system calls. Do I
misunderstand the rules about the userspace API?


> I would rather prefer to fix the driver to always GFP_DMA, but I am
> not aware of any driver who needs it. Are you?

Well, theoretically, there migth be an user who want these ioctl with
all the drivers that are not capable of 64bit DMA since sg allocates
the reserved buffer with GFP_KERNEL. These driver might use the
block-layer bounce buffer. Users might want to use
SG_SET_FORCE_LOW_DMA to avoid the bounce buffer latency.
