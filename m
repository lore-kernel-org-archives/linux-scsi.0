From: Christoph Hellwig <hch@lst.de>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
	746650160
Date: Mon, 13 Apr 2015 19:41:05 +0200
Message-ID: <20150413174105.GA14988@lst.de>
References: <20150408183333.493607a3@goldlack.schiller106>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34056 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbbDMRlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 13:41:07 -0400
Content-Disposition: inline
In-Reply-To: <20150408183333.493607a3@goldlack.schiller106>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Luettgert <ml-lkml@enda.eu>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 08, 2015 at 06:33:33PM +0200, Torsten Luettgert wrote:
> Hello,
> 
> I'm getting NULL pointer deref BUGs on a Supermicro machine of
> mine since 3.17. It occurs at random uptimes, often a few hours
> after booting (max uptime was 2 days yet).
> 
> I bisected the problem (took a while); the problematic commit seems
> to be 746650160866 (scsi: convert host_busy to atomic_t) by
> Christoph Hellwig.

Seems like a very unlikely commit for this sort of change, so let's try
to dig a bit deeper.

> Here's one of the logs (it's always the same trace):
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010 IP: [<ffffffff8133af60>]
> swiotlb_unmap_sg_attrs+0x30/0x80 PGD 0 
> Oops: 0000 [#1] SMP 
> Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich mfd_core
> usb_storage CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 3.16.0-74665016086615bb+ #1 Hardware name: Supermicro X8DTT/X8DTT, BIOS
> 080016  10/05/2010 task: ffffffff81c16480 ti: ffffffff81c00000 task.ti:
> ffffffff81c00000 RIP: 0010:[<ffffffff8133af60>]  [<ffffffff8133af60>]
> swiotlb_unmap_sg_attrs+0x30/0x80 RSP: 0018:ffff88063fc03e08  EFLAGS:
> 00010002 RAX: 0000000000000000 RBX: 0000000000000001 RCX:
> 0000000000000002 RDX: 0000000000000000 RSI: 000000090e2ef000 RDI:
> ffff880c14e61a00 RBP: ffff88063fc03e38 R08: 0000000000000000 R09:
> ffff8806209cc098 R10: ffff88063f400120 R11: 0000000000001268 R12:
> 0000000000000002 R13: 0000000000000002 R14: ffff8806209cc098 R15:
> ffff880c200fcc70 FS:  0000000000000000(0000) GS:ffff88063fc00000(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000010 CR3: 0000000001c11000 CR4: 00000000000027e0
> Stack:
>  0000000000000094 0000000000000094 ffff880c200f8718 0000000000000094
>  0000000000000094 0000000000000094 ffff88063fc03e48 ffffffff8146a0b4
>  ffff88063fc03e88 ffffffff81477c1d ffff88063fc03e78 ffff880c213a57c0
> Call Trace:
>  <IRQ> 
>  [<ffffffff8146a0b4>] scsi_dma_unmap+0x54/0x70

Can you run gdb on your vmlinux file and send the output of the
following command in gdb

l *(scsi_dma_unmap+0x54)

Thanks!
