From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not elv_next_request()
Date: Thu, 30 Oct 2008 12:14:42 +0100
Message-ID: <20081030111441.GR31673@kernel.dk>
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk> <49096865.2050006@kernel.org> <20081030075855.GO31673@kernel.dk> <20081030092741.GA9478@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:52279 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYJ3LPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 07:15:54 -0400
Content-Disposition: inline
In-Reply-To: <20081030092741.GA9478@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>

On Thu, Oct 30 2008, Mike Anderson wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Oct 30 2008, Tejun Heo wrote:
> > > Jens Axboe wrote:
> > > > That's actually a pretty dumb error, I'm surprised it hasn't reared its
> > > > ugly face in more ways. Presumably because the timeout is usually so
> > > > long, that we'll get to actually issuing and completing it within the
> > > > normal timeout anyway.
> > > 
> > > Heh... it showed its ugly face in many different ways while I was
> > > playing with PMP connected via a very long eSATA cable.
> > 
> > Ah :-)
> > 
> > If we had it wired up for eg the old IDE drivers, it would have shown up
> > quite quickly as well I think.
> 
> I am getting errors now and my system will not boot up. The system is
> connected to storage with active / passive paths. If we are doing a
> BLKPREP_KILL we will call elv_dequeue_request which will add the
> timer for the request we are killing. 
> 
> The attached patch is a quick patch to work around my issue, but we
> probably need something better. I would like to run some short timeout
> testing on it for a while (though that previously did not catch Tejun's
> issue). I will look at this more tomorrow unless someone beats me to it.
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
> 
> 1.) Dmesg
> [   35.104483] Buffer I/O error on device sda, logical block 0
> [   35.104493] ------------[ cut here ]------------
> [   35.104496] WARNING: at
> /home/data/xbuild/source/linux-2.6_work/lib/list_debug.c:30
> __list_add+0x6e/0x87()
> [   35.104499] list_add corruption. prev->next should be next
> (ffff88007c5be568), but was ffff88007bd3ce88. (prev=ffff88007bd3ce88).
> [   35.104501] Modules linked in: sd_mod(+) usbcore(+) dm_snapshot dm_mod
> edd ext3 jbd fan mptsas mptscsih mptbase scsi_transport_sas lpfc
> scsi_transport_fc scsi_dh_rdac scsi_dh scsi_mod thermal processor
> [   35.104512] Pid: 1168, comm: modprobe Not tainted
> 2.6.28-rc2-00044-g9678cc9 #1
> [   35.104514] Call Trace:
> [   35.104521]  [<ffffffff8023a368>] warn_slowpath+0xae/0xd5
> [   35.104527]  [<ffffffff80256daf>] ? trace_hardirqs_off+0xd/0xf
> [   35.104531]  [<ffffffff8025ad17>] ? __lock_acquire+0x1541/0x155d
> [   35.104537]  [<ffffffff80457e17>] ? printk+0x67/0x70
> [   35.104542]  [<ffffffff80335106>] ? __ratelimit+0xb6/0xc0
> [   35.104546]  [<ffffffff80387d9e>] ? mix_pool_bytes_extract+0x13e/0x14d
> [   35.104549]  [<ffffffff80256daf>] ? trace_hardirqs_off+0xd/0xf
> [   35.104553]  [<ffffffff8045acb9>] ? _spin_unlock_irqrestore+0x38/0x47
> [   35.104556]  [<ffffffff8033b96b>] __list_add+0x6e/0x87
> [   35.104561]  [<ffffffff80327c6a>] blk_add_timer+0x99/0xe4
> [   35.104564]  [<ffffffff803219d4>] elv_dequeue_request+0x53/0x55
> [   35.104567]  [<ffffffff80323395>] end_that_request_last+0x4b/0x1e5
> [   35.104570]  [<ffffffff80323610>] __blk_end_request+0x3c/0x45
> [   35.104572]  [<ffffffff80321b9c>] elv_next_request+0x1c6/0x234
> [   35.104576]  [<ffffffff80243777>] ? lock_timer_base+0x26/0x4a
> [   35.104608]  [<ffffffffa0028d0a>] scsi_request_fn+0x93/0x510 [scsi_mod]
> [   35.104611]  [<ffffffff80323e02>] __generic_unplug_device+0x27/0x2c
> [   35.104614]  [<ffffffff80323e2b>] blk_start_queueing+0x24/0x26
> [   35.104617]  [<ffffffff8032ec40>] cfq_insert_request+0x333/0x352
> [   35.104620]  [<ffffffff80321dff>] elv_insert+0x1f5/0x29e
> [   35.104622]  [<ffffffff80321f3e>] __elv_add_request+0x96/0x9f
> [   35.104625]  [<ffffffff803249d6>] __make_request+0x405/0x46e
> [   35.104628]  [<ffffffff80258eed>] ? trace_hardirqs_on_caller+0xf9/0x124
> [   35.104631]  [<ffffffff8032306b>] generic_make_request+0x3a6/0x3e9
> [   35.104635]  [<ffffffff8027c1e3>] ? mempool_alloc+0x5b/0x113
> [   35.104638]  [<ffffffff80323161>] submit_bio+0xb3/0xbc
> [   35.104643]  [<ffffffff802c650f>] submit_bh+0xea/0x10e
> [   35.104647]  [<ffffffff802c98a3>] block_read_full_page+0x273/0x292
> [   35.104650]  [<ffffffff802cb011>] ? blkdev_get_block+0x0/0x5d
> [   35.104652]  [<ffffffff80279dd3>] ? __lock_page+0x63/0x6a
> [   35.104656]  [<ffffffff802cc502>] blkdev_readpage+0x13/0x15
> [   35.104658]  [<ffffffff8027a454>] read_cache_page_async+0x118/0x143
> [   35.104661]  [<ffffffff802cc4ef>] ? blkdev_readpage+0x0/0x15
> [   35.104663]  [<ffffffff8027a48d>] read_cache_page+0xe/0x46
> [   35.104668]  [<ffffffff802f03a0>] read_dev_sector+0x2e/0x93
> [   35.104671]  [<ffffffff802f411f>] read_lba+0x5b/0xb3
> [   35.104674]  [<ffffffff80258f25>] ? trace_hardirqs_on+0xd/0xf
> [   35.104677]  [<ffffffff802f43cb>] efi_partition+0x9f/0x5f8
> [   35.104679]  [<ffffffff80258f25>] ? trace_hardirqs_on+0xd/0xf
> [   35.104682]  [<ffffffff80258eed>] ? trace_hardirqs_on_caller+0xf9/0x124
> [   35.104686]  [<ffffffff802f0bb2>] rescan_partitions+0x159/0x2e1
> [   35.104693]  [<ffffffffa01a047a>] ? sd_open+0xcd/0x18d [sd_mod]
> [   35.104695]  [<ffffffff802cbf4b>] __blkdev_get+0x1ff/0x2cf
> [   35.104699]  [<ffffffff80332697>] ? kobject_put+0x47/0x4b
> [   35.104701]  [<ffffffff802cc026>] blkdev_get+0xb/0xd
> [   35.104704]  [<ffffffff802f04e5>] register_disk+0xe0/0x145
> [   35.104707]  [<ffffffff80329280>] add_disk+0xc0/0x124
> [   35.104711]  [<ffffffffa01a1fa8>] sd_probe+0x2c6/0x39e [sd_mod]
> [   35.104715]  [<ffffffff802f6c1e>] ? sysfs_create_link+0xe/0x10
> [   35.104719]  [<ffffffff803ad9f2>] driver_probe_device+0xc0/0x16e
> [   35.104721]  [<ffffffff803adb02>] __driver_attach+0x62/0x8c
> [   35.104724]  [<ffffffff803adaa0>] ? __driver_attach+0x0/0x8c
> [   35.104726]  [<ffffffff803ad269>] bus_for_each_dev+0x52/0x8c
> [   35.104729]  [<ffffffff803ad83a>] driver_attach+0x1c/0x1e
> [   35.104731]  [<ffffffff803acb2a>] bus_add_driver+0xba/0x207
> [   35.104734]  [<ffffffff803adcf6>] driver_register+0xab/0x12b
> [   35.104749]  [<ffffffffa002dcbc>] scsi_register_driver+0x11/0x13
> [scsi_mod]
> [   35.104752]  [<ffffffffa01ac0a4>] init_sd+0xa4/0xff [sd_mod]
> [   35.104756]  [<ffffffffa01ac000>] ? init_sd+0x0/0xff [sd_mod]
> [   35.104760]  [<ffffffff80209058>] _stext+0x58/0x138
> [   35.104763]  [<ffffffff80256daf>] ? trace_hardirqs_off+0xd/0xf
> [   35.104766]  [<ffffffff8045acb9>] ? _spin_unlock_irqrestore+0x38/0x47
> [   35.104769]  [<ffffffff80233a6c>] ? try_to_wake_up+0x186/0x198
> [   35.104772]  [<ffffffff80258f25>] ? trace_hardirqs_on+0xd/0xf
> [   35.104775]  [<ffffffff80258eed>] ? trace_hardirqs_on_caller+0xf9/0x124
> [   35.104780]  [<ffffffff802642a7>] sys_init_module+0xab/0x1bc
> [   35.104783]  [<ffffffff8020be9b>] system_call_fastpath+0x16/0x1b
> [   35.104785] ---[ end trace 08ddd733955d992c ]---
> [
> 
> 2.) Patch
> 
> From 698916fcee612e84ecce89f27ea66dd5f21bc351 Mon Sep 17 00:00:00 2001
> From: Mike Anderson <andmike@linux.vnet.ibm.com>
> Date: Thu, 30 Oct 2008 02:16:20 -0700
> Subject: [PATCH 1/1] blk: move blk_delete_timer call in end_that_request_last
> 
> Move the calling  blk_delete_timer to later in end_that_request_last to
> address an issue where blkdev_dequeue_request may have add a timer for the
> request.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
>  block/blk-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index c3df30c..10e8a64 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1770,8 +1770,6 @@ static void end_that_request_last(struct request *req, int error)
>  {
>  	struct gendisk *disk = req->rq_disk;
>  
> -	blk_delete_timer(req);
> -
>  	if (blk_rq_tagged(req))
>  		blk_queue_end_tag(req->q, req);
>  
> @@ -1781,6 +1779,8 @@ static void end_that_request_last(struct request *req, int error)
>  	if (unlikely(laptop_mode) && blk_fs_request(req))
>  		laptop_io_completion();
>  
> +	blk_delete_timer(req);
> +
>  	/*
>  	 * Account IO completion.  bar_rq isn't accounted as a normal
>  	 * IO on queueing nor completion.  Accounting the containing
> -- 
> 1.5.6.5

Good catch, I queued this up for 2.6.28 (and added Tejuns ack).


-- 
Jens Axboe

