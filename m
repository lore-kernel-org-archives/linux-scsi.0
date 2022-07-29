Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA22C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 08:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiG2IzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 04:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiG2IzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 04:55:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFC7C29
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 01:55:07 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LvLpR4zZXz67bJf;
        Fri, 29 Jul 2022 16:51:11 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 10:55:05 +0200
Received: from [10.195.35.4] (10.195.35.4) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 29 Jul
 2022 09:55:04 +0100
Message-ID: <14fcc416-769f-fbc8-873f-8278c2b75ef2@huawei.com>
Date:   Fri, 29 Jul 2022 09:55:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [BUG] pm80xx crashing during SATA discovery
To:     Michal Grzedzicki <mge@fb.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <658BED74-1C07-44E8-B1FA-2FBB5E3F5DF2@fb.com>
 <64826481-8b07-d81c-2482-ce7edc5b377a@huawei.com>
 <E4CD9F54-21CA-4A0F-8835-2C3AA999DF48@fb.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <E4CD9F54-21CA-4A0F-8835-2C3AA999DF48@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.35.4]
X-ClientProxiedBy: lhreml734-chm.china.huawei.com (10.201.108.85) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/07/2022 21:10, Michal Grzedzicki wrote:
> 
> 
>> On 28 Jul 2022, at 20:03, John Garry <john.garry@huawei.com> wrote:
>>
>>> Hi,
>>> I'm having trouble getting the pm80xx driver to discover SATA drives.
>>> Enclosure has both SAS and SATA drives and the controller is Adaptec Device 8074 (rev 06) on x86_64 machine.
>>> Without ATA support in libsas, SAS drives alone are working correctly on 5.18.
>>> After enabling ATA support the driver started crashing.
>>> With scsi_mod.scan=sync and high loglevel for pm80xx I was able to perform a couple
>>> of commands before the kernel crashed.
>>
>> Has this worked ok for any other recent kernel version? It seems that 5.18 and 5.19-rcX are broken for you, but it would be good to know if your setup ever worked without issue. Damien (cc'ed) and I have been making changes to this driver and libsas recently but don't experience these sorts of problems.
> This is a new environmen, It did not work before. So far I tested 4.11 and 5.18 and 5.19 with similar crashes around spinlock in mpi_sata_completion

It's hard for me to say what the issue is. I have one of these cards and 
it does not work properly on my arm64 system - I always get timeouts 
after booting the system.

But since this is x86 then some people cc'ed may be more interested.

> 
>>
>>> Applying "libsas and drivers: NCQ error handling" (https://patchwork.kernel.org/project/linux-scsi/list/?series=662216)
>>> series of patches prevents the driver from crashing but all operations are timing out.
>>
>> That could be related to patch 1/6, where I think that you might experience a use-after-free (which that patch attempts to fix). Turning KASAN on should help detect (without my patch).
> 
> 
> vanilla 5.19-rc8 with KASAN enabled and scsi_mod.scan=sync , you ware right there is a use after free there
> 
> [   72.174677] ata8.00: qc timeout (cmd 0x27)
> [   72.174692] ata14.00: qc timeout (cmd 0x27)
> [   72.184006] ata14.00: failed to read native max address (err_mask=0x4)
> [   72.184011] ata14.00: HPA support seems broken, skipping HPA handling
> [   72.188588] ==================================================================
> [   72.188591] BUG: KASAN: use-after-free in mpi_sata_completion+0x2470/0x2d20 [pm80xx]
> [   72.203067] Read of size 8 at addr ffff8884336c4f00 by task ksoftirqd/0/14
> [   72.219769]
> [   72.219772] CPU: 0 PID: 14 Comm: ksoftirqd/0 Not tainted 5.19.0-rc8 #1
> [   72.227483] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   72.227545] ata8.00: failed to read native max address (err_mask=0x4)
> [   72.227549] ata8.00: HPA support seems broken, skipping HPA handling
> [   72.227552] ata8.00: revalidation failed (errno=-5)
> [   72.229110] Call Trace:
> [   72.229113]  <TASK>
> [   72.276458]  dump_stack_lvl+0x33/0x42
> [   72.280555]  print_report.cold.12+0xf5/0x67c
> [   72.285331]  ? mpi_sata_completion+0x2470/0x2d20 [pm80xx]
> [   72.291412]  kasan_report+0xa5/0x120
> [   72.295411]  ? mpi_sata_completion+0x2470/0x2d20 [pm80xx]
> [   72.301490]  mpi_sata_completion+0x2470/0x2d20 [pm80xx]
> [   72.307368]  ? ttwu_do_wakeup+0x21/0x560
> [   72.311753]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
> [   72.317927]  ? _raw_spin_unlock_irqrestore+0x46/0x70
> [   72.323475]  ? _raw_spin_unlock+0x39/0x60
> [   72.327955]  ? _raw_spin_lock_irqsave+0x8d/0xe0
> [   72.333018]  ? _raw_read_lock_bh+0x40/0x40
> [   72.337597]  ? sched_clock_cpu+0x69/0x2a0
> [   72.342079]  process_oq+0xe56/0x5bc0 [pm80xx]
> [   72.346988]  ? psi_task_switch+0x3e8/0x4a0
> [   72.351567]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
> [   72.357636]  ? put_prev_entity+0x4d/0x210
> [   72.362118]  ? psi_task_change+0x1f0/0x1f0
> [   72.366696]  ? __wake_up_common_lock+0x130/0x130
> [   72.371856]  ? __switch_to_asm+0x42/0x70
> [   72.376241]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
> [   72.381447]  tasklet_action_common.isra.19+0x1ed/0x340
> [   72.387192]  __do_softirq+0x199/0x575
> [   72.391286]  ? tasklet_kill+0x1b0/0x1b0
> [   72.395571]  run_ksoftirqd+0x26/0x30
> [   72.399564]  smpboot_thread_fn+0x420/0x6c0
> [   72.404143]  ? sort_range+0x20/0x20
> [   72.408040]  kthread+0x265/0x300
> [   72.411647]  ? kthread_complete_and_exit+0x20/0x20
> [   72.416999]  ret_from_fork+0x1f/0x30
> [   72.420997]  </TASK>
> [   72.423437]
> [   72.425100] Allocated by task 198:
> [   72.428898]  kasan_save_stack+0x1c/0x40
> [   72.433184]  __kasan_slab_alloc+0x6d/0x90
> [   72.437663]  kmem_cache_alloc+0x134/0x460
> [   72.442144]  sas_alloc_task+0x1d/0xa0 [libsas]
> [   72.447127]  sas_ata_qc_issue+0x1a8/0xba0 [libsas]
> [   72.452496]  ata_qc_issue+0x498/0xbb0
> [   72.456588]  ata_exec_internal_sg+0xafb/0x17f0
> [   72.461550]  ata_read_native_max_address+0x1b3/0x480
> [   72.467097]  ata_dev_configure+0x1ba7/0x5180
> [   72.471867]  ata_eh_recover+0x15b5/0x3030
> [   72.476346]  ata_do_eh+0x40/0xb0
> [   72.479952]  ata_scsi_port_error_handler+0x47d/0xb90
> [   72.485496]  async_sas_ata_eh+0xcf/0x112 [libsas]
> [   72.490768]  async_run_entry_fn+0x93/0x510
> [   72.495344]  process_one_work+0x889/0x14c0
> [   72.499919]  worker_thread+0x84/0x11f0
> [   72.504107]  kthread+0x265/0x300
> [   72.507712]  ret_from_fork+0x1f/0x30
> [   72.511705]
> [   72.513367] Freed by task 198:
> [   72.516776]  kasan_save_stack+0x1c/0x40
> [   72.521060]  kasan_set_track+0x21/0x30
> [   72.525247]  kasan_set_free_info+0x20/0x30
> [   72.529822]  __kasan_slab_free+0x101/0x170
> [   72.534398]  kmem_cache_free+0xa1/0x4b0
> [   72.538682]  ata_exec_internal_sg+0xc72/0x17f0
> [   72.543646]  ata_read_native_max_address+0x1b3/0x480
> [   72.549192]  ata_dev_configure+0x1ba7/0x5180
> [   72.553961]  ata_eh_recover+0x15b5/0x3030
> [   72.558440]  ata_do_eh+0x40/0xb0
> [   72.562045]  ata_scsi_port_error_handler+0x47d/0xb90
> [   72.567590]  async_sas_ata_eh+0xcf/0x112 [libsas]
> [   72.572861]  async_run_entry_fn+0x93/0x510
> [   72.577436]  process_one_work+0x889/0x14c0
> [   72.582012]  worker_thread+0x84/0x11f0
> [   72.586199]  kthread+0x265/0x300
> [   72.589803]  ret_from_fork+0x1f/0x30

Yes, I recognise this. The problem is that there is a race between the 
aborted IO completing and the associated sas_task being freed.

> [   72.593798]
> [   72.595461] The buggy address belongs to the object at ffff8884336c4f00
> [   72.595461]  which belongs to the cache sas_task of size 264
> [   72.609152] The buggy address is located 0 bytes inside of
> [   72.609152]  264-byte region [ffff8884336c4f00, ffff8884336c5008)
> [   72.622067]
> [   72.623729] The buggy address belongs to the physical page:
> [   72.629950] page:000000001e6555bf refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4336c4
> [   72.640445] head:000000001e6555bf order:1 compound_mapcount:0 compound_pincount:0
> [   72.648801] flags: 0xbfff80000010200(slab|head|node=0|zone=2|lastcpupid=0x7fff)
> [   72.656971] raw: 0bfff80000010200 0000000000000000 dead000000000122 ffff888106682dc0
> [   72.665620] raw: 0000000000000000 0000000000150015 00000001ffffffff 0000000000000000
> [   72.674265] page dumped because: kasan: bad access detected
> [   72.680486]
> [   72.682149] Memory state around the buggy address:
> [   72.687499]  ffff8884336c4e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   72.695565]  ffff8884336c4e80: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   72.703630] >ffff8884336c4f00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   72.711694]                    ^
> [   72.715297]  ffff8884336c4f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   72.723352]  ffff8884336c5000: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   72.731407] ==================================================================
> [   72.739460] Disabling lock debugging due to kernel taint
> [   79.854640] ata8.00: qc timeout (cmd 0xec)
> [   79.867706] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
> [   79.883327] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
> [   79.898953] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
> [   79.907810] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   79.914618] ata8.00: revalidation failed (errno=-5)
> [   81.902636] ata9.00: qc timeout (cmd 0x2f)
> [   81.907295] ata9.00: Read log 0x00 page 0x00 failed, Emask 0x4
> [   81.913829] ata9.00: failed to set xfermode (err_mask=0x40)
> [   89.582637] ata9.00: qc timeout (cmd 0xec)
> [   89.582637] ata14.00: qc timeout (cmd 0x2f)
> [   89.591934] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
> [   89.602140] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
> [   89.602153] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
> [   89.619835] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
> [   89.619859] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   89.635491] ata9.00: revalidation failed (errno=-5)
> [   89.635516] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
> [   89.650912] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
> [   89.659791] ata14.00: Read log 0x13 page 0x00 failed, Emask 0x4
> [   89.666407] ata14.00: Read log 0x00 page 0x00 failed, Emask 0x40
> [   89.673120] ata14.00: NCQ Send/Recv Log not supported
> [   89.678770] ata14.00: Read log 0x00 page 0x00 failed, Emask 0x40
> [   89.685498] ata14.00: failed to set xfermode (err_mask=0x40)
> [   89.691823] ata14.00: limiting speed to UDMA/133:PIO3
> [   91.323501] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> [   91.323504] Modules linked in: pm80xx(+) libsas scsi_transport_sas loop tg3 virtio_rng virtio_net net_failover failover
> [   91.323526] CPU: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G    B             5.19.0-rc8 #1
> [   91.323535] RIP: 0010:kasan_report+0x1b/0x120
> [   91.323542] Code: aa 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 41 56 41 55 41 54 55 53 48 83 ec 38 9c 41 5d 0f 01 ca 65 48 8b 04 25 00 ec 02 00 <8b> 80 20 0b 00 00 85 c0 0f 85 92 00 00 00 48 8b9
> [   91.323547] RSP: 0018:ffffc9000012f980 EFLAGS: 00000082
> [   91.323552] RAX: ffff8881003dec00 RBX: ffff8884336c4f08 RCX: ffffffff812b798b
> [   91.323556] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8884336c4f08
> [   91.323560] RBP: 0000000000000003 R08: fffffffffffffffb R09: ffffed10866d89e1
> [   91.323563] R10: 0000000000000003 R11: ffffed10866d89e1 R12: 1ffff92000025f3f
> [   91.323566] R13: 0000000000000082 R14: ffff8884336c4f6c R15: ffff8884336c4f70
> [   91.323570] FS:  0000000000000000(0000) GS:ffff88838b000000(0000) knlGS:0000000000000000
> [   91.323575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   91.323578] CR2: 000000c0002a9ff8 CR3: 0000000432ed2006 CR4: 00000000003706f0
> [   91.323582] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   91.323585] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   91.323589] Call Trace:
> [   91.323591]  <TASK>
> [   91.323596]  queued_spin_lock_slowpath+0x8fb/0xa50
> [   91.323604]  ? osq_unlock+0x1f0/0x1f0
> [   91.323610]  ? irq_work_claim+0x16/0x70
> [   91.323617]  ? irq_work_queue+0xd/0x50
> [   91.323623]  ? __wake_up_klogd.part.32+0x79/0xb0
> [   91.323629]  ? vprintk_emit+0xf7/0x2b0
> [   91.323633]  ? print_report.cold.12+0x66c/0x67c
> [   91.323642]  _raw_spin_lock_irqsave+0xd9/0xe0
> [   91.323649]  ? _raw_read_lock_bh+0x40/0x40
> [   91.323658]  mpi_sata_completion+0x389/0x2d20 [pm80xx]
> [   91.323717]  ? ttwu_do_wakeup+0x21/0x560
> [   91.323723]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
> [   91.323773]  ? _raw_spin_unlock+0x39/0x60
> [   91.323780]  ? _raw_spin_lock_irqsave+0x8d/0xe0
> [   91.323786]  ? _raw_read_lock_bh+0x40/0x40
> [   91.323793]  ? sched_clock_cpu+0x69/0x2a0
> [   91.323799]  process_oq+0xe56/0x5bc0 [pm80xx]
> [   91.323854]  ? psi_task_switch+0x3e8/0x4a0
> [   91.323861]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
> [   91.323911]  ? put_prev_entity+0x4d/0x210
> [   91.323918]  ? psi_task_change+0x1f0/0x1f0
> [   91.323924]  ? __wake_up_common_lock+0x130/0x130
> [   91.323930]  ? __switch_to_asm+0x42/0x70
> [   91.323937]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
> [   91.323988]  tasklet_action_common.isra.19+0x1ed/0x340
> [   91.323996]  __do_softirq+0x199/0x575
> [   91.324002]  ? tasklet_kill+0x1b0/0x1b0
> [   91.324008]  run_ksoftirqd+0x26/0x30
> [   91.324013]  smpboot_thread_fn+0x420/0x6c0
> [   91.324020]  ? sort_range+0x20/0x20
> [   91.324027]  kthread+0x265/0x300
> [   91.324031]  ? kthread_complete_and_exit+0x20/0x20
> [   91.324037]  ret_from_fork+0x1f/0x30
> [   91.324046]  </TASK>
> [   91.324049] Kernel panic - not syncing: Hard LOCKUP
> [   91.324052] CPU: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G    B             5.19.0-rc8 #1
> [   91.324058] Hardware name: EMC InfinityES6/110-365-300J-00, BIOS 33.15 08/17/2017
> [   91.324060] Call Trace:
> [   91.324062]  <NMI>
> [   91.324064]  dump_stack_lvl+0x33/0x42
> [   91.324072]  panic+0x1d4/0x3f7
> [   91.324078]  ? panic_print_sys_info+0x75/0x75
> [   91.324085]  ? nmi_panic+0x27/0x60
> [   91.324093]  nmi_panic.cold.7+0x14/0x14
> [   91.324098]  watchdog_overflow_callback.cold.3+0xcf/0x103
> [   91.324104]  __perf_event_overflow+0x11c/0x370
> [   91.324113]  handle_pmi_common+0x49a/0x6d0
> [   91.324122]  ? intel_pmu_save_and_restart+0xe0/0xe0
> [   91.324130]  ? __native_set_fixmap+0x24/0x30
> [   91.324138]  ? memcpy_fromio+0x26/0x110
> [   91.324147]  ? ghes_copy_tofrom_phys+0x90/0x160
> [   91.324158]  intel_pmu_handle_irq+0x269/0xbe0
> [   91.324167]  perf_event_nmi_handler+0x37/0x50
> [   91.324174]  nmi_handle+0xa5/0x260
> [   91.324183]  default_do_nmi+0x72/0x170
> [   91.324191]  exc_nmi+0x117/0x140
> [   91.324197]  end_repeat_nmi+0x16/0x31
> [   91.324202] RIP: 0010:kasan_report+0x1b/0x120
> [   91.324207] Code: aa 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 41 56 41 55 41 54 55 53 48 83 ec 38 9c 41 5d 0f 01 ca 65 48 8b 04 25 00 ec 02 00 <8b> 80 20 0b 00 00 85 c0 0f 85 92 00 00 00 48 8b9
> [   91.324212] RSP: 0018:ffffc9000012f980 EFLAGS: 00000082
> [   91.324216] RAX: ffff8881003dec00 RBX: ffff8884336c4f08 RCX: ffffffff812b798b
> [   91.324220] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8884336c4f08
> [   91.324224] RBP: 0000000000000003 R08: fffffffffffffffb R09: ffffed10866d89e1
> [   91.324227] R10: 0000000000000003 R11: ffffed10866d89e1 R12: 1ffff92000025f3f
> [   91.324230] R13: 0000000000000082 R14: ffff8884336c4f6c R15: ffff8884336c4f70
> [   91.324236]  ? queued_spin_lock_slowpath+0x8fb/0xa50
> [   91.324244]  ? kasan_report+0x1b/0x120
> [   91.324250]  ? kasan_report+0x1b/0x120
> [   91.324255]  </NMI>
> [   91.324257]  <TASK>
> [   91.324261]  queued_spin_lock_slowpath+0x8fb/0xa50
> [   91.324267]  ? osq_unlock+0x1f0/0x1f0
> [   91.324273]  ? irq_work_claim+0x16/0x70
> [   91.324279]  ? irq_work_queue+0xd/0x50
> [   91.324284]  ? __wake_up_klogd.part.32+0x79/0xb0
> [   91.324289]  ? vprintk_emit+0xf7/0x2b0
> [   91.324294]  ? print_report.cold.12+0x66c/0x67c
> [   91.324302]  _raw_spin_lock_irqsave+0xd9/0xe0
> [   91.324309]  ? _raw_read_lock_bh+0x40/0x40
> [   91.324317]  mpi_sata_completion+0x389/0x2d20 [pm80xx]
> [   91.324371]  ? ttwu_do_wakeup+0x21/0x560
> [   91.324376]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
> [   91.324427]  ? _raw_spin_unlock+0x39/0x60
> [   91.324433]  ? _raw_spin_lock_irqsave+0x8d/0xe0
> [   91.324440]  ? _raw_read_lock_bh+0x40/0x40
> [   91.324446]  ? sched_clock_cpu+0x69/0x2a0
> [   91.324452]  process_oq+0xe56/0x5bc0 [pm80xx]
> [   91.324507]  ? psi_task_switch+0x3e8/0x4a0
> [   91.324514]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
> [   91.324565]  ? put_prev_entity+0x4d/0x210
> [   91.324571]  ? psi_task_change+0x1f0/0x1f0
> [   91.324578]  ? __wake_up_common_lock+0x130/0x130
> [   91.324583]  ? __switch_to_asm+0x42/0x70
> [   91.324590]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
> [   91.324644]  tasklet_action_common.isra.19+0x1ed/0x340
> [   91.324651]  __do_softirq+0x199/0x575
> [   91.324658]  ? tasklet_kill+0x1b0/0x1b0
> [   91.324663]  run_ksoftirqd+0x26/0x30
> [   91.324668]  smpboot_thread_fn+0x420/0x6c0
> [   91.324676]  ? sort_range+0x20/0x20
> [   91.324682]  kthread+0x265/0x300
> [   91.324686]  ? kthread_complete_and_exit+0x20/0x20
> [   91.324692]  ret_from_fork+0x1f/0x30
> [   91.324701]  </TASK>
> [   91.324708] Kernel Offset: disabled
> 
> Thanks,
> Michal
> .

