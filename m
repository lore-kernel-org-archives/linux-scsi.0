From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Fix possible overflow for memcpy address in iovec
Date: Tue, 11 Jul 2017 01:41:05 -0700
Message-ID: <1499762465.28145.48.camel@haakon3.daterainc.com>
References: <1499758843-14159-1-git-send-email-lixiubo@cmss.chinamobile.com>
         <c77ef933-1d47-b885-e3be-4a8b39b5e9fe@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49893 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755650AbdGKIlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 04:41:21 -0400
In-Reply-To: <c77ef933-1d47-b885-e3be-4a8b39b5e9fe@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>
Cc: mchristi@redhat.com, bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>

Hey Xiubo,

On Tue, 2017-07-11 at 16:04 +0800, Xiubo Li wrote:
> Hi All
> 
> Please ignore about this patch.
> 
> Just my mistake.
> 
> Sorry.
> 

Damien (CC'ed) has been observing something similar atop the latest
target-pending/for-next with his user-space ZBC backend:

http://www.spinics.net/lists/target-devel/msg15804.html

Just curious, are you going to re-send a different patch to address
this..?

Is there anything that he can test to verify it's the same bug..?

> 
> Brs
> 
> Xiubo
> 
> 
> 
> On 2017年07月11日 15:40, lixiubo@cmss.chinamobile.com wrote:
> > From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> >
> > Before the data area dynamic grow patches, though the overflow
> > bug was already exist, since the data area memories are all
> > preallocated, so there mostly won't any bad page fault core
> > trace produced.
> >
> > The dynamic grow patches will only allocate and map the block
> > needed in data area, so when memcpy overflow, the system will
> > die.
> >
> > [  367.864705] [c0000000fc657340] [c0000000000d220c] do_exit+0x79c/0xcf0
> > [  367.864710] [c0000000fc657410] [c0000000000249a4] die+0x314/0x470
> > [  367.864715] [c0000000fc6574a0] [c00000000005425c] bad_page_fault+0xdc/0x150
> > [  367.864720] [c0000000fc657510] [c000000000008964] handle_page_fault+0x2c/0x30
> > [  367.864726] --- interrupt: 300 at memcpy_power7+0x20c/0x840
> > [  367.864726]     LR = tcmu_queue_cmd+0x844/0xa80 [target_core_user]
> > [  367.864732] [c0000000fc657800] [d0000000088916d8] tcmu_queue_cmd+0x768/0xa80 [target_core_user] (unreliable)
> > [  367.864746] [c0000000fc657940] [d000000002993184] __target_execute_cmd+0x54/0x150 [target_core_mod]
> > [  367.864758] [c0000000fc657970] [d000000002994708] transport_generic_new_cmd+0x158/0x2d0 [target_core_mod]
> > [  367.864770] [c0000000fc6579f0] [d0000000029948e4] transport_handle_cdb_direct+0x64/0xd0 [target_core_mod]
> > [  367.864783] [c0000000fc657a60] [d000000002994af8] target_submit_cmd_map_sgls+0x1a8/0x320 [target_core_mod]
> > [  367.864796] [c0000000fc657af0] [d000000002994cb8] target_submit_cmd+0x48/0x60 [target_core_mod]
> > [  367.864803] [c0000000fc657b90] [d000000002a54bd0] ibmvscsis_scheduler+0x350/0x5c0 [ibmvscsis]
> > [  367.864808] [c0000000fc657c50] [c0000000000f1c28] process_one_work+0x1e8/0x5b0
> > [  367.864813] [c0000000fc657ce0] [c0000000000f2098] worker_thread+0xa8/0x650
> > [  367.864818] [c0000000fc657d80] [c0000000000fa864] kthread+0x114/0x140
> > [  367.864823] [c0000000fc657e30] [c0000000000098f0] ret_from_kernel_thread+0x5c/0x6c
> > [  367.864827] Instruction dump:
> > [  367.864829] 60420000 7fe3fb78 4bfcd175 60000000 4bfffecc 7c0802a6 f8010010 60000000
> > [  367.864838] 7c0802a6 f8010010 f821ffe1 e9230690 <e869ffd8> 38210020 e8010010 7c0803a6
> > [  367.864847] ---[ end trace 8d085df7e65f7d20 ]---
> > [  367.870358]
> > [  367.870362] Fixing recursive fault but reboot is needed!
> > [  388.859695] INFO: rcu_sched detected stalls on CPUs/tasks:
> > [  388.859717]  16-...: (0 ticks this GP) idle=7e3/140000000000000/0 softirq=12245/12245 fqs=2622
> > [  388.859722]  (detected by 20, t=5252 jiffies, g=12458, c=12457, q=2904)
> > [  388.859744] Task dump for CPU 16:
> > [  388.859747] kworker/16:2    D 0000000000000000     0  6865 0 0x00000800
> > [  388.859762] Call Trace:
> > [  388.859768] [c0000000fc6579a0] [c0000000014ef090] sysctl_sched_migration_cost+0x0/0x4 (unreliable)
> > [  388.859778] [c0000000fc6579c0] [d000000008890c1c] tcmu_parse_cdb+0x2c/0x40 [target_core_user]
> > [  388.859782] [c0000000fc6579e0] [c0000000fc657a60] 0xc0000000fc657a60
> >
> > Reported-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> > Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> > ---
> >   drivers/target/target_core_user.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> > index 930800c..86a845a 100644
> > --- a/drivers/target/target_core_user.c
> > +++ b/drivers/target/target_core_user.c
> > @@ -437,7 +437,7 @@ static int scatter_data_area(struct tcmu_dev *udev,
> >   			to_offset = get_block_offset_user(udev, dbi,
> >   					block_remaining);
> >   			offset = DATA_BLOCK_SIZE - block_remaining;
> > -			to = (void *)(unsigned long)to + offset;
> > +			to = (void *)((unsigned long)to + offset);
> >   
> >   			if (*iov_cnt != 0 &&
> >   			    to_offset == iov_tail(udev, *iov)) {
> > @@ -510,7 +510,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
> >   			copy_bytes = min_t(size_t, sg_remaining,
> >   					block_remaining);
> >   			offset = DATA_BLOCK_SIZE - block_remaining;
> > -			from = (void *)(unsigned long)from + offset;
> > +			from = (void *)((unsigned long)from + offset);
> >   			tcmu_flush_dcache_range(from, copy_bytes);
> >   			memcpy(to + sg->length - sg_remaining, from,
> >   					copy_bytes);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
