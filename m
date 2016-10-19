From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v3 0/11] Fix race conditions related to stopping block
 layer queues
Date: Wed, 19 Oct 2016 18:24:55 -0400
Message-ID: <20161019222454.GA1215@localhost.localdomain>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

I'm running linux 4.9-rc1 + linux-block/for-linus, and alternating tests
with and without this series.

Without this, I'm not seeing any problems in a link-down test while
running fio after ~30 runs.

With this series, I only see the test pass infrequently. Most of the
time I observe one of several failures. In all cases, it looks like the
rq->queuelist is in an unexpected state.

I think I've almost got this tracked down, but I have to leave for the
day soon. Rather than having a more useful suggestion, I've put the two
failures below.


First failure:

[  214.782075] ------------[ cut here ]------------
[  214.782098] kernel BUG at block/blk-mq.c:498!
[  214.782117] invalid opcode: 0000 [#1] SMP
[  214.782133] Modules linked in: nvme nvme_core nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_raw ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security ebtable_filter ebtables ip6table_filter ip6_tables vfat fat
[  214.782356] CPU: 6 PID: 160 Comm: kworker/u16:6 Not tainted 4.9.0-rc1+ #28
[  214.782383] Hardware name: Gigabyte Technology Co., Ltd. Z97X-UD5H/Z97X-UD5H, BIOS F8 06/17/2014
[  214.782419] Workqueue: nvme nvme_reset_work [nvme]
[  214.782440] task: ffff8c0815403b00 task.stack: ffffb6ad01384000
[  214.782463] RIP: 0010:[<ffffffff9f3b88a5>]  [<ffffffff9f3b88a5>] blk_mq_requeue_request+0x35/0x40
[  214.782502] RSP: 0018:ffffb6ad01387b88  EFLAGS: 00010287
[  214.782524] RAX: ffff8c0814b98400 RBX: ffff8c0814b98200 RCX: 0000000000007530
[  214.782551] RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff8c0814b98200
[  214.782578] RBP: ffffb6ad01387b98 R08: 0000000000000000 R09: ffffffff9f408680
[  214.783394] R10: 0000000000000394 R11: 0000000000000388 R12: 0000000000000001
[  214.784212] R13: ffff8c081593a000 R14: 0000000000000001 R15: ffff8c080cdea740
[  214.785033] FS:  0000000000000000(0000) GS:ffff8c081fb80000(0000) knlGS:0000000000000000
[  214.785869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  214.786710] CR2: 00007ffae4497f34 CR3: 00000001dfe06000 CR4: 00000000001406e0
[  214.787559] Stack:
[  214.788406]  ffff8c0814b98200 0000000000000000 ffffb6ad01387ba8 ffffffffc03451b3
[  214.789287]  ffffb6ad01387bd0 ffffffffc0357a4a ffff8c0814b98200 ffffd6acffc81a00
[  214.790174]  0000000000000006 ffffb6ad01387bf8 ffffffff9f3b8e22 ffff8c0814b98200
[  214.791066] Call Trace:
[  214.791935]  [<ffffffffc03451b3>] nvme_requeue_req+0x13/0x20 [nvme_core]
[  214.792810]  [<ffffffffc0357a4a>] nvme_complete_rq+0x16a/0x1d0 [nvme]
[  214.793680]  [<ffffffff9f3b8e22>] __blk_mq_complete_request+0x72/0xe0
[  214.794551]  [<ffffffff9f3b8eac>] blk_mq_complete_request+0x1c/0x20
[  214.795422]  [<ffffffffc0345e70>] nvme_cancel_request+0x50/0x90 [nvme_core]
[  214.796299]  [<ffffffff9f3bc09e>] bt_tags_iter+0x2e/0x40
[  214.797157]  [<ffffffff9f3bc523>] blk_mq_tagset_busy_iter+0x173/0x1e0
[  214.798005]  [<ffffffffc0345e20>] ? nvme_shutdown_ctrl+0x100/0x100 [nvme_core]
[  214.798852]  [<ffffffffc0345e20>] ? nvme_shutdown_ctrl+0x100/0x100 [nvme_core]
[  214.799682]  [<ffffffffc035603d>] nvme_dev_disable+0x11d/0x380 [nvme]
[  214.800511]  [<ffffffff9f0479fa>] ? acpi_unregister_gsi_ioapic+0x3a/0x40
[  214.801344]  [<ffffffff9f52d33c>] ? dev_warn+0x6c/0x90
[  214.802157]  [<ffffffffc0356bc4>] nvme_reset_work+0xa4/0xdc0 [nvme]
[  214.802961]  [<ffffffff9f025736>] ? __switch_to+0x2b6/0x5f0
[  214.803773]  [<ffffffff9f0bb1bf>] process_one_work+0x15f/0x430
[  214.804593]  [<ffffffff9f0bb4de>] worker_thread+0x4e/0x490
[  214.805419]  [<ffffffff9f0bb490>] ? process_one_work+0x430/0x430
[  214.806255]  [<ffffffff9f0c0d09>] kthread+0xd9/0xf0
[  214.807096]  [<ffffffff9f0c0c30>] ? kthread_park+0x60/0x60
[  214.807946]  [<ffffffff9f81dc15>] ret_from_fork+0x25/0x30
[  214.808801] Code: 54 53 48 89 fb 41 89 f4 e8 a9 fa ff ff 48 8b 03 48 39 c3 75 16 41 0f b6 d4 48 89 df be 01 00 00 00 e8 10 ff ff ff 5b 41 5c 5d c3 <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 be 40 00 00
[  214.810714] RIP  [<ffffffff9f3b88a5>] blk_mq_requeue_request+0x35/0x40
[  214.811628]  RSP <ffffb6ad01387b88>
[  214.812545] ---[ end trace 6ef3a3b6f8cea418 ]---
[  214.813437] ------------[ cut here ]------------


Second failure, warning followed by NMI watchdog:

[  410.736619] ------------[ cut here ]------------
[  410.736624] WARNING: CPU: 2 PID: 577 at lib/list_debug.c:29 __list_add+0x62/0xb0
[  410.736883] list_add corruption. next->prev should be prev (ffffacf481847d78), but was ffff931f8fb78000. (next=ffff931f8fb78000).
[  410.736884] Modules linked in: nvme nvme_core nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_mangle iptable_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables vfat fat
[  410.736902] CPU: 2 PID: 577 Comm: kworker/2:1H Not tainted 4.9.0-rc1+ #28
[  410.736903] Hardware name: Gigabyte Technology Co., Ltd. Z97X-UD5H/Z97X-UD5H, BIOS F8 06/17/2014
[  410.736906] Workqueue: kblockd blk_mq_run_work_fn
[  410.736907]  ffffacf481847c80 ffffffffae3dce7e ffffacf481847cd0 0000000000000000
[  410.736909]  ffffacf481847cc0 ffffffffae0a116b 0000001dae0b9cac ffff931f8fb78000
[  410.736910]  ffffacf481847d78 ffff931f8fb78000 ffff931f8fb78000 0000000000000000
[  410.736912] Call Trace:
[  410.736916]  [<ffffffffae3dce7e>] dump_stack+0x63/0x85
[  410.736918]  [<ffffffffae0a116b>] __warn+0xcb/0xf0
[  410.736920]  [<ffffffffae0a11ef>] warn_slowpath_fmt+0x5f/0x80
[  410.736921]  [<ffffffffae3fc362>] __list_add+0x62/0xb0
[  410.736923]  [<ffffffffae3ba108>] blk_mq_process_rq_list+0x258/0x350
[  410.736925]  [<ffffffffae3ba289>] __blk_mq_run_hw_queue+0x89/0x90
[  410.736926]  [<ffffffffae3ba2d2>] blk_mq_run_work_fn+0x12/0x20
[  410.736928]  [<ffffffffae0bb1bf>] process_one_work+0x15f/0x430
[  410.736929]  [<ffffffffae0bb4de>] worker_thread+0x4e/0x490
[  410.736931]  [<ffffffffae0bb490>] ? process_one_work+0x430/0x430
[  410.736932]  [<ffffffffae0bb490>] ? process_one_work+0x430/0x430
[  410.736934]  [<ffffffffae003c27>] ? do_syscall_64+0x67/0x180
[  410.736936]  [<ffffffffae0c0d09>] kthread+0xd9/0xf0
[  410.736937]  [<ffffffffae0c0c30>] ? kthread_park+0x60/0x60
[  410.736940]  [<ffffffffae81dc15>] ret_from_fork+0x25/0x30
[  410.736941] ---[ end trace 0d9c0b78654a9c5e ]---
[  410.736942] ------------[ cut here ]-----------

[  436.159108] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/2:1H:577]
[  436.159126] Modules linked in: nvme nvme_core nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw ip6table_mangle iptable_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables vfat fat
[  436.159138] CPU: 2 PID: 577 Comm: kworker/2:1H Tainted: G        W       4.9.0-rc1+ #28
[  436.159138] Hardware name: Gigabyte Technology Co., Ltd. Z97X-UD5H/Z97X-UD5H, BIOS F8 06/17/2014
[  436.159142] Workqueue: kblockd blk_mq_run_work_fn
[  436.159143] task: ffff931f95411d80 task.stack: ffffacf481844000
[  436.159143] RIP: 0010:[<ffffffffae3b7f11>]  [<ffffffffae3b7f11>] __blk_mq_free_request+0x31/0x50
[  436.159145] RSP: 0018:ffffacf481847d08  EFLAGS: 00000246
[  436.159146] RAX: ffff931f8fb78000 RBX: ffff931f8f9f8000 RCX: 0000000000010000
[  436.159146] RDX: 0000000000000040 RSI: ffffccf47fc81800 RDI: ffff931f8da45c00
[  436.159147] RBP: ffffacf481847d10 R08: 0000000000000000 R09: ffff931f8fb78000
[  436.159147] R10: 0000000000000000 R11: 0000000000000015 R12: 00000000fffffffb
[  436.159147] R13: ffffacf481847d88 R14: ffff931f8fb78000 R15: 0000000000000000
[  436.159148] FS:  0000000000000000(0000) GS:ffff931f9fa80000(0000) knlGS:0000000000000000
[  436.159148] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  436.159149] CR2: 000055dab2dc8b70 CR3: 000000009de06000 CR4: 00000000001406e0
[  436.159149] Stack:
[  436.159150]  ffff931f8fb78000 ffffacf481847d20 ffffffffae3b7f6d ffffacf481847d30
[  436.159151]  ffffffffae3b7fa2 ffffacf481847d50 ffffffffae3b8d93 ffff931f8da45c00
[  436.159152]  ffffacf481847d78 ffffacf481847de0 ffffffffae3ba1db ffff931f8f9f8000
[  436.159153] Call Trace:
[  436.159155]  [<ffffffffae3b7f6d>] blk_mq_free_hctx_request+0x3d/0x40
[  436.159156]  [<ffffffffae3b7fa2>] blk_mq_free_request+0x32/0x40
[  436.159157]  [<ffffffffae3b8d93>] blk_mq_end_request+0x53/0x70
[  436.159158]  [<ffffffffae3ba1db>] blk_mq_process_rq_list+0x32b/0x350
[  436.159159]  [<ffffffffae3ba289>] __blk_mq_run_hw_queue+0x89/0x90
[  436.159160]  [<ffffffffae3ba2d2>] blk_mq_run_work_fn+0x12/0x20
[  436.159162]  [<ffffffffae0bb1bf>] process_one_work+0x15f/0x430
[  436.159163]  [<ffffffffae0bb4de>] worker_thread+0x4e/0x490
[  436.159164]  [<ffffffffae0bb490>] ? process_one_work+0x430/0x430
[  436.159165]  [<ffffffffae0bb490>] ? process_one_work+0x430/0x430
[  436.159166]  [<ffffffffae003c27>] ? do_syscall_64+0x67/0x180
[  436.159168]  [<ffffffffae0c0d09>] kthread+0xd9/0xf0
[  436.159169]  [<ffffffffae0c0c30>] ? kthread_park+0x60/0x60
[  436.159171]  [<ffffffffae81dc15>] ret_from_fork+0x25/0x30
[  436.159172] Code: 89 d0 55 f6 40 4b 20 48 89 e5 53 8b 92 00 01 00 00 48 8b 58 30 74 07 f0 ff 8f e0 01 00 00 48 c7 40 48 00 00 00 00 f0 80 60 50 fd <e8> ba 47 00 00 48 89 df e8 d2 70 ff ff 5b 5d c3 66 66 66 66 66
