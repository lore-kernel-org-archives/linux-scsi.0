From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: fix map_region and unmap_region oops
Date: Wed, 30 Jun 2010 10:56:01 -0400
Message-ID: <4C2B5B01.3090305@interlog.com>
References: <20100628010219G.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36334 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0F3O4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 10:56:31 -0400
In-Reply-To: <20100628010219G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: martin.petersen@oracle.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On 10-06-27 12:04 PM, FUJITA Tomonori wrote:
> I got the following ops:
>
> BUG: unable to handle kernel paging request at ffffc90021c0c000
> IP: [<ffffffffa006cb8a>] unmap_region+0x5a/0x70 [scsi_debug]
> PGD 11fc06067 PUD 21f802067 PMD d5632067 PTE 0
> Oops: 0002 [#1] SMP
> last sysfs file:
> /sys/devices/pseudo_0/adapter0/host2/target2:0:0/2:0:0:0/type
> CPU 10
> Modules linked in: scsi_debug crc_t10dif sd_mod sg arcmsr cxgb3 mdio
> [last unloaded: scsi_debug]
>
> Pid: 0, comm: swapper Not tainted 2.6.35-rc3-dirty #1 /ProLiant DL360
> G6
> RIP: 0010:[<ffffffffa006cb8a>]  [<ffffffffa006cb8a>]
> unmap_region+0x5a/0x70 [scsi_debug]
> RSP: 0018:ffff880001d43c08  EFLAGS: 00010046
> RAX: 0000000000100000 RBX: 0000000000000001 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 0000000000100000 RDI: 00000000000fffff
> RBP: 0000000000000000 R08: 0000000000100000 R09: 0000000000000001
> R10: ffffc90021bec000 R11: 0000000020000000 R12: ffff88011abeaf00
> R13: 0000000000000000 R14: 0000000000100000 R15: 0000000000000046
> FS:  0000000000000000(0000) GS:ffff880001d40000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffc90021c0c000 CR3: 00000000019b9000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88021f65c000, task
> ffff88021f663000)
> Stack:
>   ffffffffa006d413 ffff88011abeae00 ffff88011e9b1560 0000000000000000
> <0>  ffff88011abeaf00 ffff88011ea284e0 0000000000000001
> 0000000000000000
> <0>  ffffffffa006f93d 0000000000001000 ffff88011abf2e00
> ffff88011a0c9000
> Call Trace:
>   <IRQ>
>   [<ffffffffa006d413>] ? resp_write_same+0x163/0x1a0 [scsi_debug]
>   [<ffffffffa006f93d>] ? scsi_debug_queuecommand+0x83d/0x1a30
>   [scsi_debug]
>   [<ffffffff81223580>] ? scsi_done+0x0/0x10
>   [<ffffffff81229e4e>] ? scsi_init_io+0x1e/0x100
>   [<ffffffff8122a09d>] ? scsi_setup_blk_pc_cmnd+0x6d/0x130
>   [<ffffffffa00658e2>] ? sd_prep_fn+0x1e2/0xa70 [sd_mod]
>   [<ffffffff81223682>] ? scsi_dispatch_cmd+0xf2/0x220
>   [<ffffffff8122979d>] ? scsi_request_fn+0x34d/0x450
>   [<ffffffff8116eff5>] ? __blk_run_queue+0x65/0x150
>   [<ffffffff8116f1b8>] ? blk_run_queue+0x28/0x50
>   [<ffffffff81228c32>] ? scsi_run_queue+0xd2/0x390
>   [<ffffffff81229b0b>] ? scsi_next_command+0x3b/0x60
>   [<ffffffff8122a6f4>] ? scsi_io_completion+0x354/0x580
>   [<ffffffff81173f35>] ? blk_done_softirq+0x75/0x90
>   [<ffffffff810425be>] ? __do_softirq+0xae/0x140
>   [<ffffffff8100347c>] ? call_softirq+0x1c/0x30
>   [<ffffffff81005155>] ? do_softirq+0x65/0xa0
>   [<ffffffff8101992b>] ? smp_apic_timer_interrupt+0x6b/0xa0
>   [<ffffffff81002f53>] ? apic_timer_interrupt+0x13/0x20
>   <EOI>
>   [<ffffffff811d4417>] ? acpi_idle_enter_bm+0x294/0x2cb
>   [<ffffffff811d4410>] ? acpi_idle_enter_bm+0x28d/0x2cb
>   [<ffffffff8128eb7a>] ? cpuidle_idle_call+0xba/0x120
>   [<ffffffff810017de>] ? cpu_idle+0x5e/0xa0
> Code: 00 48 89 c8 48 29 d0 48 01 c7 48 39 fe 76 2a 31 d2 4a 8d 04 0f
> 48 f7 f1 89 d2 49 89 c0 48 85 d2 75 df 48 8d 04 0f 48 39 c6 72 d6<f0>
> 45 0f b3 02 eb cf 0f 1f 80 00 00 00 00 f3 c3 66 0f 1f 44 00
> RIP  [<ffffffffa006cb8a>] unmap_region+0x5a/0x70 [scsi_debug]
>   RSP<ffff880001d43c08>
> CR2: ffffc90021c0c000
>
> Same problem?
>
> http://marc.info/?l=linux-scsi&m=125680100519614&w=2
>
> =
> From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi_debug: fix map_region and unmap_region oops
>
> map_region and unmap_region could access to invalid memory area since
> they don't check the size boundary.
>
> Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> ---
>   drivers/scsi/scsi_debug.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 136329b..b02bdc6 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1991,7 +1991,8 @@ static void map_region(sector_t lba, unsigned int len)
>   		block = lba + alignment;
>   		rem = do_div(block, granularity);
>
> -		set_bit(block, map_storep);
> +		if (block<  map_size)
> +			set_bit(block, map_storep);
>
>   		lba += granularity - rem;
>   	}
> @@ -2011,7 +2012,8 @@ static void unmap_region(sector_t lba, unsigned int len)
>   		block = lba + alignment;
>   		rem = do_div(block, granularity);
>
> -		if (rem == 0&&  lba + granularity<= end)
> +		if (rem == 0&&  lba + granularity<= end&&
> +		    block<  map_size)
>   			clear_bit(block, map_storep);
>
>   		lba += granularity - rem;

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
