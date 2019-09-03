Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C556EC3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912E122CF8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfICJbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfICJbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 05:31:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 117513DFCD;
        Tue,  3 Sep 2019 09:31:04 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1180C5C21A;
        Tue,  3 Sep 2019 09:30:51 +0000 (UTC)
Date:   Tue, 3 Sep 2019 17:30:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190903093045.GB22399@ming.t460p>
References: <20190828110633.GC15524@ming.t460p>
 <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
 <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 03 Sep 2019 09:31:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 03, 2019 at 09:50:06AM +0200, Daniel Lezcano wrote:
> On 03/09/2019 09:28, Ming Lei wrote:
> > On Tue, Sep 03, 2019 at 08:40:35AM +0200, Daniel Lezcano wrote:
> >> On 03/09/2019 08:31, Ming Lei wrote:
> >>> Hi Daniel,
> >>>
> >>> On Tue, Sep 03, 2019 at 07:59:39AM +0200, Daniel Lezcano wrote:
> >>>>
> >>>> Hi Ming Lei,
> >>>>
> >>>> On 03/09/2019 05:30, Ming Lei wrote:
> >>>>
> >>>> [ ... ]
> >>>>
> >>>>
> >>>>>>> 2) irq/timing doesn't cover softirq
> >>>>>>
> >>>>>> That's solvable, right?
> >>>>>
> >>>>> Yeah, we can extend irq/timing, but ugly for irq/timing, since irq/timing
> >>>>> focuses on hardirq predication, and softirq isn't involved in that
> >>>>> purpose.
> >>>>>
> >>>>>>  
> >>>>>>> Daniel, could you take a look and see if irq flood detection can be
> >>>>>>> implemented easily by irq/timing.c?
> >>>>>>
> >>>>>> I assume you can take a look as well, right?
> >>>>>
> >>>>> Yeah, I have looked at the code for a while, but I think that irq/timing
> >>>>> could become complicated unnecessarily for covering irq flood detection,
> >>>>> meantime it is much less efficient for detecting IRQ flood.
> >>>>
> >>>> In the series, there is nothing describing rigorously the problem (I can
> >>>> only guess) and why the proposed solution solves it.
> >>>>
> >>>> What is your definition of an 'irq flood'? A high irq load? An irq
> >>>> arriving while we are processing the previous one in the bottom halves?
> >>>
> >>> So far, it means that handling interrupt & softirq takes all utilization
> >>> of one CPU, then processes can't be run on this CPU basically, usually
> >>> sort of CPU lockup warning will be triggered.
> >>
> >> It is a scheduler problem then ?
> > 
> > Scheduler can do nothing if the CPU is taken completely by handling
> > interrupt & softirq, so seems not a scheduler problem, IMO.
> 
> Why? If there is a irq pressure on one CPU reducing its capacity, the
> scheduler will balance the tasks on another CPU, no?

For example, the following two kinds[1][2] of warning can be triggered
easily when heavy fio test is run on NVMe. The 1st one could be that
network irq is affected by the nvme irq flood. The 2nd one is rcu_sched stall.

[1]
[  186.531069] NETDEV WATCHDOG: enP48661s1 (mlx4_core): transmit queue 12 timed out
[  186.545259] WARNING: CPU: 9 PID: 0 at net/sched/sch_generic.c:443 dev_watchdog+0x252/0x260
[  186.546222] Modules linked in: xt_owner ext4 mbcache jbd2 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter dm_mirror dm_region_hash dm_log dm_mod crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper crypto_simd cryptd mlx4_en mlx4_core nvme nvme_core hv_utils sg pcspkr i2c_piix4 ptp hv_balloon pci_hyperv pps_core joydev ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi hv_storvsc hv_netvsc hyperv_keyboard hid_hyperv scsi_transport_fc ata_piix hyperv_fb crc32c_intel libata hv_vmbus floppy serio_raw
[  186.546222] CPU: 9 PID: 0 Comm: swapper/9 Not tainted 5.3.0-rc6+ #17
[  186.546222] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  05/18/2018
[  186.546222] RIP: 0010:dev_watchdog+0x252/0x260
[  186.546222] Code: c0 75 e4 eb 98 4c 89 ef c6 05 38 ca c7 00 01 e8 04 93 fb ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 f0 9e 54 be 31 c0 e8 4e 14 95 ff <0f> 0b e9 75 ff ff ff 0f 1f 80 00 00 00 00 0f 1f 44 00 00 41 57 ba
[  186.546222] RSP: 0018:ffffae5518ee0e88 EFLAGS: 00010282
[  186.546222] RAX: 0000000000000000 RBX: 000000000000000c RCX: 0000000000000000
[  186.546222] RDX: 0000000000000001 RSI: ffff9d6b5f8577b8 RDI: ffff9d6b5f8577b8
[  186.546222] RBP: ffff9d5b4c300440 R08: 0000000000000363 R09: 0000000000000363
[  186.546222] R10: 0000000000000001 R11: 0000000000aaaaaa R12: 0000000000000100
[  186.546222] R13: ffff9d5b4c300000 R14: ffff9d5b4c30041c R15: 0000000000000009
[  186.546222] FS:  0000000000000000(0000) GS:ffff9d6b5f840000(0000) knlGS:0000000000000000
[  186.546222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  186.546222] CR2: 00007f6324aa19b8 CR3: 000000308981c000 CR4: 00000000003406e0
[  186.546222] Call Trace:
[  186.546222]  <IRQ>
[  186.546222]  ? pfifo_fast_enqueue+0x110/0x110
[  186.546222]  call_timer_fn+0x2f/0x140
[  186.546222]  run_timer_softirq+0x1f6/0x460
[  186.546222]  ? timerqueue_add+0x54/0x80
[  186.546222]  ? enqueue_hrtimer+0x38/0x90
[  186.546222]  __do_softirq+0xda/0x2a8
[  186.546222]  irq_exit+0xc5/0xd0
[  186.546222]  hv_stimer0_vector_handler+0x5a/0x70
[  186.546222]  hv_stimer0_callback_vector+0xf/0x20
[  186.546222]  </IRQ>
[  186.546222] RIP: 0010:native_safe_halt+0xe/0x10
[  186.546222] Code: 01 00 f0 80 48 02 20 48 8b 00 a8 08 0f 84 7a ff ff ff eb bc 90 90 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d a6 74 59 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 96 74 59 00 f4 c3 90 90 0f 1f 44 00
[  186.546222] RSP: 0018:ffffae5518993eb0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff12
[  186.546222] RAX: ffffffffbdc72970 RBX: ffff9d5ba5b79700 RCX: 0000000000000000
[  186.546222] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000002af36665fe
[  186.546222] RBP: 0000000000000009 R08: 0000000000000000 R09: fffffffe56427f06
[  186.546222] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[  186.546222] R13: 0000000000000000 R14: ffff9d5ba5b79700 R15: ffff9d5ba5b79700
[  186.546222]  ? __cpuidle_text_start+0x8/0x8
[  186.546222]  default_idle+0x1a/0x140
[  186.546222]  do_idle+0x1a6/0x290
[  186.546222]  cpu_startup_entry+0x19/0x20
[  186.546222]  start_secondary+0x166/0x1c0
[  186.546222]  secondary_startup_64+0xa4/0xb0
[  186.546222] ---[ end trace 8d7ef273033e5d7a ]---

[2]
[  247.296117] rcu: INFO: rcu_sched self-detected stall on CPU
[  247.441146] rcu: 	64-....: (1 GPs behind) idle=1fe/1/0x4000000000000002 softirq=498/499 fqs=13379 
[  247.588155] 	(t=60291 jiffies g=6261 q=16750)
[  247.726156] NMI backtrace for cpu 64
[  247.862150] CPU: 64 PID: 7772 Comm: fio Tainted: G        W         5.3.0-rc6+ #17
[  248.004148] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  05/18/2018
[  248.150158] Call Trace:
[  248.279195]  <IRQ>
[  248.401151]  dump_stack+0x5a/0x73
[  248.522126]  nmi_cpu_backtrace+0x90/0xa0
[  248.640147]  ? lapic_can_unplug_cpu+0xa0/0xa0
[  248.757151]  nmi_trigger_cpumask_backtrace+0x6c/0x110
[  248.871145]  rcu_dump_cpu_stacks+0x8a/0xb8
[  248.980152]  rcu_sched_clock_irq+0x55a/0x7a0
[  249.089152]  ? smp_call_function_single_async+0x1f/0x40
[  249.197151]  ? blk_mq_complete_request+0x8e/0xf0
[  249.301157]  ? tick_sched_do_timer+0x80/0x80
[  249.404177]  update_process_times+0x28/0x50
[  249.505152]  tick_sched_handle+0x25/0x60
[  249.605151]  tick_sched_timer+0x37/0x70
[  249.705149]  __hrtimer_run_queues+0xfb/0x270
[  249.804160]  hrtimer_interrupt+0x122/0x270
[  249.904166]  hv_stimer0_vector_handler+0x33/0x70
[  250.004148]  hv_stimer0_callback_vector+0xf/0x20
[  250.102144]  </IRQ>
[  250.195164] RIP: 0010:nvme_queue_rq+0x42/0x710 [nvme]
[  250.294147] Code: 68 48 8b a8 c8 00 00 00 48 8b 97 b8 00 00 00 48 8b 1e 65 48 8b 0c 25 28 00 00 00 48 89 4c 24 60 31 c9 48 8b 7a 70 4c 8b 6d 00 <c7> 83 3c 01 00 00 00 00 00 00 c7 83 40 01 00 00 ff ff ff ff c7 83
[  250.518141] RSP: 0018:ffffae551c7ef8f8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff12
[  250.630150] RAX: ffff9d5b49fb6c00 RBX: ffff9d5b5aaf4500 RCX: 0000000000000000
[  250.743121] RDX: ffff9d5b4a719020 RSI: ffffae551c7ef9a8 RDI: ffff9d5b5e8e2e80
[  250.856148] RBP: ffff9d5b4ba20100 R08: 0000000000000001 R09: ffff9d4bc51ef080
[  250.970154] R10: 000000000000007f R11: ffff9d5b4a719020 R12: ffffae551c7ef9a8
[  251.084177] R13: ffff9d5b5e430000 R14: ffffae551c7efab0 R15: ffffce44ffa0bbc0
[  251.200157]  ? __sbitmap_get_word+0x2a/0x80
[  251.311146]  ? sbitmap_get+0x61/0x130
[  251.421145]  __blk_mq_try_issue_directly+0x143/0x1f0
[  251.533144]  blk_mq_request_issue_directly+0x4d/0xa0
[  251.646148]  blk_mq_try_issue_list_directly+0x51/0xc0
[  251.758155]  blk_mq_sched_insert_requests+0xbb/0x110
[  251.865149]  blk_mq_flush_plug_list+0x191/0x2c0
[  251.971149]  blk_flush_plug_list+0xcc/0xf0
[  252.074146]  blk_finish_plug+0x27/0x40
[  252.177154]  blkdev_direct_IO+0x410/0x4a0
[  252.280155]  generic_file_read_iter+0xb1/0xc70
[  252.384166]  ? common_interrupt+0xa/0xf
[  252.486149]  ? _cond_resched+0x15/0x30
[  252.588168]  aio_read+0xf6/0x150
[  252.688145]  ? common_interrupt+0xa/0xf
[  252.789147]  ? __switch_to_asm+0x40/0x70
[  252.892151]  ? __switch_to_asm+0x34/0x70
[  252.994125]  ? __check_object_size+0x75/0x1b0
[  253.097148]  ? _copy_to_user+0x22/0x30
[  253.198147]  ? aio_read_events+0x279/0x300
[  253.298149]  ? kmem_cache_alloc+0x15c/0x200
[  253.396155]  io_submit_one+0x199/0xb50
[  253.492163]  ? read_events+0x5c/0x160
[  253.588152]  ? __switch_to_asm+0x40/0x70
[  253.683146]  ? __switch_to_asm+0x34/0x70
[  253.773145]  ? __switch_to_asm+0x40/0x70
[  253.863148]  ? __switch_to_asm+0x34/0x70
[  253.950431]  ? __switch_to_asm+0x40/0x70
[  254.037146]  __x64_sys_io_submit+0xb3/0x1a0
[  254.125153]  ? __audit_syscall_exit+0x1d9/0x280
[  254.214149]  do_syscall_64+0x5b/0x1d0
[  254.300154]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  254.390145] RIP: 0033:0x7f63580f1697
[  254.478137] Code: 49 83 38 00 75 eb 49 83 78 08 00 75 e4 8b 47 0c 39 47 08 75 dc 31 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 90 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00
[  254.682145] RSP: 002b:00007ffe5fee3d18 EFLAGS: 00000293 ORIG_RAX: 00000000000000d1
[  254.784142] RAX: ffffffffffffffda RBX: 0000000001defb90 RCX: 00007f63580f1697
[  254.885146] RDX: 0000000001defdf8 RSI: 0000000000000001 RDI: 00007f636c142000
[  254.989153] RBP: 0000000000000000 R08: 0000000000000010 R09: 0000000001dee3e0
[  255.092126] R10: 0000000001dde000 R11: 0000000000000293 R12: 0000000000000001
[  255.194148] R13: 0000000000000018 R14: 00007f632cb45980 R15: 0000000001defe70
[  299.228276] nvme nvme7: I/O 220 QID 2 timeout, aborting
[  299.298199] nvme nvme7: Abort status: 0x0
[  300.425912] mlx4_en: enP48661s1: Steering Mode 2
[  438.694592] rcu: INFO: rcu_sched self-detected stall on CPU
[  438.783121] rcu: 	77-....: (1 GPs behind) idle=c1e/1/0x4000000000000004 softirq=795/796 fqs=12978 
[  438.929120] 	(t=60235 jiffies g=6541 q=3725)
[  439.029124] NMI backtrace for cpu 77
[  439.130120] CPU: 77 PID: 7718 Comm: fio Tainted: G        W         5.3.0-rc6+ #17
[  439.245123] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  05/18/2018
[  439.357125] Call Trace:
[  439.467157]  <IRQ>
[  439.522121]  dump_stack+0x5a/0x73
[  439.670123]  nmi_cpu_backtrace+0x90/0xa0
[  439.767124]  ? lapic_can_unplug_cpu+0xa0/0xa0
[  439.877119]  nmi_trigger_cpumask_backtrace+0x6c/0x110
[  439.987122]  rcu_dump_cpu_stacks+0x8a/0xb8
[  440.087121]  rcu_sched_clock_irq+0x55a/0x7a0
[  440.186126]  ? smp_call_function_single_async+0x1f/0x40
[  440.293125]  ? blk_mq_complete_request+0x8e/0xf0
[  440.399122]  ? tick_sched_do_timer+0x80/0x80
[  440.505118]  update_process_times+0x28/0x50
[  440.607119]  tick_sched_handle+0x25/0x60
[  440.709122]  tick_sched_timer+0x37/0x70
[  440.814119]  __hrtimer_run_queues+0xfb/0x270
[  440.919122]  hrtimer_interrupt+0x122/0x270
[  441.024116]  hv_stimer0_vector_handler+0x33/0x70
[  441.108126]  hv_stimer0_callback_vector+0xf/0x20
[  441.220121] RIP: 0010:__do_softirq+0x77/0x2a8
[  441.319130] Code: 0f b7 ca 89 4c 24 04 c7 44 24 20 0a 00 00 00 48 89 44 24 08 48 89 44 24 18 65 66 c7 05 d0 a5 02 42 00 00 fb 66 0f 1f 44 00 00 <b8> ff ff ff ff 48 c7 c5 00 51 60 be 0f bc 44 24 04 83 c0 01 89 04
[  441.552119] RSP: 0018:ffffae5519cc0f78 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff12
[  441.698119] RAX: ffff9d7b5ac7dc00 RBX: 0000000000000000 RCX: 0000000000000002
[  441.826119] RDX: ffff9ddba50d0002 RSI: 0000000000000000 RDI: 0000000000000000
[  441.943122] RBP: 0000000000000000 R08: 0000000000000000 R09: 01484a5406289ee5
[  442.052121] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  442.180121] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  442.307119]  ? hv_stimer0_callback_vector+0xa/0x20
[  442.423123]  ? clockevents_program_event+0x79/0xf0
[  442.543117]  irq_exit+0xc5/0xd0
[  442.655124]  hv_stimer0_vector_handler+0x5a/0x70
[  442.783119]  hv_stimer0_callback_vector+0xf/0x20
[  442.896120]  </IRQ>
[  443.004119] RIP: 0010:__blk_mq_try_issue_directly+0x157/0x1f0


thanks,
Ming
