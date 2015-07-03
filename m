From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq vs kmemleak
Date: Fri, 3 Jul 2015 10:04:00 -0700
Message-ID: <5596C080.4050009@sandisk.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:35936
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754851AbbGCREG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2015 13:04:06 -0400
In-Reply-To: <20150703161137.GA10438@codemonkey.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/03/15 09:11, Dave Jones wrote:
> After a fuzzing run recently, I noticed that the machine had oom'd, and
> killed everything, but there was still 3GB of memory still in use, that
> I couldn't even reclaim with /proc/sys/vm/drop_caches
>
> So I enabled kmemleak. After applying this..
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index cf79f110157c..6dc18dbad9ec 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -553,8 +553,8 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>
>          object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
>          if (!object) {
> -               pr_warning("Cannot allocate a kmemleak_object structure\n");
> -               kmemleak_disable();
> +               //pr_warning("Cannot allocate a kmemleak_object structure\n");
> +               //kmemleak_disable();
>                  return NULL;
>          }
>
> otherwise it would disable itself within a minute of runtime.
>
> I notice now that I'm seeing a lot of traces like this..
>
>
> unreferenced object 0xffff8800ba8202c0 (size 320):
>    comm "kworker/u4:1", pid 38, jiffies 4294741176 (age 46887.690s)
>    hex dump (first 32 bytes):
>      21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00  !Ce.............
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff8969b80e>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff891b3e37>] kmem_cache_alloc+0x107/0x200
>      [<ffffffff8916528d>] mempool_alloc_slab+0x1d/0x30
>      [<ffffffff89165963>] mempool_alloc+0x63/0x180
>      [<ffffffff8945f85a>] scsi_sg_alloc+0x4a/0x50
>      [<ffffffff89323f0e>] __sg_alloc_table+0x11e/0x180
>      [<ffffffff8945dc03>] scsi_alloc_sgtable+0x43/0x90
>      [<ffffffff8945dc81>] scsi_init_sgtable+0x31/0x80
>      [<ffffffff8945dd1a>] scsi_init_io+0x4a/0x1c0
>      [<ffffffff8946da59>] sd_init_command+0x59/0xe40
>      [<ffffffff8945df81>] scsi_setup_cmnd+0xf1/0x160
>      [<ffffffff8945e75c>] scsi_queue_rq+0x57c/0x6a0
>      [<ffffffff892f60b8>] __blk_mq_run_hw_queue+0x1d8/0x390
>      [<ffffffff892f5e5e>] blk_mq_run_hw_queue+0x9e/0x120
>      [<ffffffff892f7524>] blk_mq_insert_requests+0xd4/0x1a0
>      [<ffffffff892f8273>] blk_mq_flush_plug_list+0x123/0x140
>
> unreferenced object 0xffff8800ba824800 (size 640):
>    comm "trinity-c2", pid 3687, jiffies 4294843075 (age 46785.966s)
>    hex dump (first 32 bytes):
>      21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00  !Ce.............
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff8969b80e>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff891b3e37>] kmem_cache_alloc+0x107/0x200
>      [<ffffffff8916528d>] mempool_alloc_slab+0x1d/0x30
>      [<ffffffff89165963>] mempool_alloc+0x63/0x180
>      [<ffffffff8945f85a>] scsi_sg_alloc+0x4a/0x50
>      [<ffffffff89323f0e>] __sg_alloc_table+0x11e/0x180
>      [<ffffffff8945dc03>] scsi_alloc_sgtable+0x43/0x90
>      [<ffffffff8945dc81>] scsi_init_sgtable+0x31/0x80
>      [<ffffffff8945dd1a>] scsi_init_io+0x4a/0x1c0
>      [<ffffffff8946da59>] sd_init_command+0x59/0xe40
>      [<ffffffff8945df81>] scsi_setup_cmnd+0xf1/0x160
>      [<ffffffff8945e75c>] scsi_queue_rq+0x57c/0x6a0
>      [<ffffffff892f60b8>] __blk_mq_run_hw_queue+0x1d8/0x390
>      [<ffffffff892f5e5e>] blk_mq_run_hw_queue+0x9e/0x120
>      [<ffffffff892f7524>] blk_mq_insert_requests+0xd4/0x1a0
>      [<ffffffff892f8273>] blk_mq_flush_plug_list+0x123/0x140
>
> unreferenced object 0xffff8800a9fe6780 (size 2560):
>    comm "kworker/1:1H", pid 171, jiffies 4294843118 (age 46785.923s)
>    hex dump (first 32 bytes):
>      21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00  !Ce.............
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff8969b80e>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff891b3e37>] kmem_cache_alloc+0x107/0x200
>      [<ffffffff8916528d>] mempool_alloc_slab+0x1d/0x30
>      [<ffffffff89165963>] mempool_alloc+0x63/0x180
>      [<ffffffff8945f85a>] scsi_sg_alloc+0x4a/0x50
>      [<ffffffff89323f0e>] __sg_alloc_table+0x11e/0x180
>      [<ffffffff8945dc03>] scsi_alloc_sgtable+0x43/0x90
>      [<ffffffff8945dc81>] scsi_init_sgtable+0x31/0x80
>      [<ffffffff8945dd1a>] scsi_init_io+0x4a/0x1c0
>      [<ffffffff8946da59>] sd_init_command+0x59/0xe40
>      [<ffffffff8945df81>] scsi_setup_cmnd+0xf1/0x160
>      [<ffffffff8945e75c>] scsi_queue_rq+0x57c/0x6a0
>      [<ffffffff892f60b8>] __blk_mq_run_hw_queue+0x1d8/0x390
>      [<ffffffff892f66b2>] blk_mq_run_work_fn+0x12/0x20
>      [<ffffffff8908eba7>] process_one_work+0x147/0x420
>      [<ffffffff8908f209>] worker_thread+0x69/0x470
>
> The sizes vary, but the hex dump is always the same.
>
> What's the usual completion path where these would get deallocated ?
> I'm wondering if there's just some annotation missing to appease kmemleak,
> because I'm seeing thousands of these.
>
> Or it could be a real leak, but it seems surprising no-one else is complaining.

(+Catalin)

Dave, with which kernel version has this behavior been observed ?

Catalin, can you recommend which patches Dave Jones should apply to 
kmemleak ? A few weeks ago I had noticed similar kmemleak reports. 
However, when I reran my test with kmemleak disabled memory usage was 
stable. See also 
https://www.redhat.com/archives/dm-devel/2015-May/msg00198.html.

Thanks,

Bart.

