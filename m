From: Manuel Lauss <mano@roarinelk.homelinux.net>
Subject: Re: MTD kobject warnings due to block layer changes
Date: Fri, 29 Aug 2008 10:34:35 +0200
Message-ID: <20080829083435.GA27386@roarinelk.homelinux.net>
References: <20080829065029.GK20055@kernel.dk> <20080829165542L.fujita.tomonori@lab.ntt.co.jp> <20080829080123.GO20055@kernel.dk> <20080829171936Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:47961 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYH2Ieh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2008 04:34:37 -0400
Content-Disposition: inline
In-Reply-To: <20080829171936Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello Fujita-san,

On Fri, Aug 29, 2008 at 05:19:56PM +0900, FUJITA Tomonori wrote:
> On Fri, 29 Aug 2008 10:01:24 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > What about eg ide-cd?
> 
> I'm always SCSI biased.
> 
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] remove blk_register_filter and blk_unregister_filter in gendisk
> 
> This patch remove blk_register_filter and blk_unregister_filter in
> gendisk, and adds them to sd.c, sr.c. and ide-cd.c
> 
> The commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 moved cmdfilter
> from gendisk to request_queue. It turned out that in some subsystems
> multiple gendisks share a single request_queue. So we get:
> 
> Using physmap partition information
> Creating 3 MTD partitions on "physmap-flash":
> 0x00000000-0x01c00000 : "User FS"
> 0x01c00000-0x01c40000 : "booter"
> kobject (8511c410): tried to init an initialized object, something is seriously wrong.
> Call Trace:
> [<8036644c>] dump_stack+0x8/0x34
> [<8021f050>] kobject_init+0x50/0xcc
> [<8021fa18>] kobject_init_and_add+0x24/0x58
> [<8021d20c>] blk_register_filter+0x4c/0x64
> [<8021c194>] add_disk+0x78/0xe0
> [<8027d14c>] add_mtd_blktrans_dev+0x254/0x278
> [<8027c8f0>] blktrans_notify_add+0x40/0x78
> [<80279c00>] add_mtd_device+0xd0/0x150
> [<8027b090>] add_mtd_partitions+0x568/0x5d8
> [<80285458>] physmap_flash_probe+0x2ac/0x334
> [<802644f8>] driver_probe_device+0x12c/0x244
> [<8026465c>] __driver_attach+0x4c/0x84
> [<80263c64>] bus_for_each_dev+0x58/0xac
> [<802633ec>] bus_add_driver+0xc4/0x24c
> [<802648e0>] driver_register+0xcc/0x184
> [<80100460>] _stext+0x60/0x1bc
> 
> In the long term, we need to fix such subsystems but we need a quick
> fix now. This patch add the command filter support to only sd and sr
> though it might be useful for other SG_IO users (such as cciss).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Reported-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Thank you very much, works as advertised!

ManuelLauss
