From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request
 V2
Date: Thu, 26 Jan 2017 23:14:45 +0000
Message-ID: <1485472465.2540.19.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485455329.2540.7.camel@sandisk.com>
         <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
         <1485456745.2540.9.camel@sandisk.com>
         <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
         <20170126185924.GA25289@lst.de>
         <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
         <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
         <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
         <1485464486.2540.12.camel@sandisk.com>
         <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
         <1485467235.2540.14.camel@sandisk.com>
         <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0068.outbound.protection.outlook.com ([104.47.33.68]:13488
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752363AbdAZXPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 18:15:18 -0500
In-Reply-To: <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
Content-Language: en-US
Content-ID: <ACB40EE25202204EA5F37EECC851AC81@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Thu, 2017-01-26 at 14:51 -0700, Jens Axboe wrote:
> That is exactly what it means, looks like that one path doesn't handle
> that.  You'd have to exhaust the pool with atomic allocs for this to
> trigger, we don't do that at all in the normal IO path. So good catch,
> must be the dm part that enables this since it does NOWAIT allocations.
>=20
>=20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 3136696f4991..c27613de80c5 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -134,7 +134,8 @@ struct request *blk_mq_sched_get_request(struct reque=
st_queue *q,
>  			rq =3D __blk_mq_alloc_request(data, op);
>  	} else {
>  		rq =3D __blk_mq_alloc_request(data, op);
> -		data->hctx->tags->rqs[rq->tag] =3D rq;
> +		if (rq)
> +			data->hctx->tags->rqs[rq->tag] =3D rq;
>  	}
> =20
>  	if (rq) {

Hello Jens,

With these two patches applied the scheduling-while-atomic complaint and
the oops are gone. However, some tasks get stuck. Is the console output
below enough to figure out what is going on or do you want me to bisect
this? I don't think that any requests got stuck since no pending requests
are shown in /sys/block/*/mq/*/{pending,*/rq_list}.

Thanks,

Bart.

[  663.217074] sysrq: SysRq : Show Blocked State
[  663.217111]   task                        PC stack   pid father
[  663.217237] kworker/10:0    D    0    71      2 0x00000000
[  663.217267] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.217289] Call Trace:
[  663.217313]  __schedule+0x2da/0xb00
[  663.217337]  ? bit_wait+0x50/0x50
[  663.217360]  schedule+0x38/0x90
[  663.217383]  schedule_timeout+0x2fe/0x640
[  663.217406]  ? mark_held_locks+0x6f/0xa0
[  663.217430]  ? ktime_get+0x74/0x130
[  663.217452]  ? bit_wait+0x50/0x50
[  663.217473]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.217497]  ? trace_hardirqs_on+0xd/0x10
[  663.217520]  ? ktime_get+0x98/0x130
[  663.217542]  ? __delayacct_blkio_start+0x1a/0x30
[  663.217564]  ? bit_wait+0x50/0x50
[  663.217586]  io_schedule_timeout+0x9f/0x110
[  663.217609]  bit_wait_io+0x16/0x60
[  663.217637]  __wait_on_bit+0x53/0x80
[  663.217659]  ? bit_wait+0x50/0x50
[  663.217680]  out_of_line_wait_on_bit+0x6e/0x80
[  663.217703]  ? prepare_to_wait_event+0x170/0x170
[  663.217727]  sync_mapping_buffers+0x22f/0x390
[  663.217750]  __generic_file_fsync+0x4d/0x90
[  663.217772]  ext4_sync_file+0x2b4/0x540
[  663.217793]  vfs_fsync_range+0x46/0xa0
[  663.217814]  dio_complete+0x181/0x1b0
[  663.217835]  dio_aio_complete_work+0x17/0x20
[  663.217856]  process_one_work+0x208/0x6a0
[  663.217878]  ? process_one_work+0x18d/0x6a0
[  663.217899]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.217919]  worker_thread+0x49/0x4a0
[  663.217941]  kthread+0x107/0x140
[  663.217962]  ? process_one_work+0x6a0/0x6a0
[  663.217982]  ? kthread_create_on_node+0x40/0x40
[  663.218003]  ? acpi_ps_create_op+0x1c0/0x35a
[  663.218025]  ? acpi_ps_alloc_op+0x3f/0x80
[  663.218045]  ? acpi_os_acquire_object+0x28/0x2a
[  663.218068]  ret_from_fork+0x2e/0x40
[  663.218112] kworker/u24:8   D    0   141      2 0x00000000
[  663.218139] Workqueue: writeback wb_workfn (flush-254:0)
[  663.218160] Call Trace:
[  663.218182]  __schedule+0x2da/0xb00
[  663.218209]  schedule+0x38/0x90
[  663.218233]  schedule_timeout+0x2fe/0x640
[  663.218263]  ? ktime_get+0x74/0x130
[  663.218284]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.218307]  ? trace_hardirqs_on+0xd/0x10
[  663.218329]  ? ktime_get+0x98/0x130
[  663.218352]  ? __delayacct_blkio_start+0x1a/0x30
[  663.218448]  io_schedule_timeout+0x9f/0x110
[  663.218475]  blk_mq_get_tag+0x158/0x260
[  663.218499]  ? remove_wait_queue+0x70/0x70
[  663.218525]  __blk_mq_alloc_request+0x16/0xe0
[  663.218548]  blk_mq_sched_get_request+0x279/0x370
[  663.218571]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.218596]  ? generic_make_request+0xca/0x290
[  663.218619]  blk_sq_make_request+0x111/0xc90
[  663.218642]  ? blk_queue_enter+0x2d/0x280
[  663.218665]  ? generic_make_request+0xca/0x290
[  663.218688]  generic_make_request+0xd7/0x290
[  663.218712]  ? _raw_spin_unlock_irqrestore+0x31/0x50
[  663.218737]  submit_bio+0x5f/0x120
[  663.218761]  submit_bh_wbc+0x14d/0x180
[  663.218783]  __block_write_full_page+0x193/0x3f0
[  663.218805]  ? I_BDEV+0x10/0x10
[  663.218826]  ? I_BDEV+0x10/0x10
[  663.218847]  block_write_full_page+0xd0/0x120
[  663.218870]  blkdev_writepage+0x13/0x20
[  663.218892]  __writepage+0x11/0x40
[  663.218914]  write_cache_pages+0x216/0x640
[  663.218935]  ? wb_position_ratio+0x1f0/0x1f0
[  663.218957]  generic_writepages+0x41/0x60
[  663.218979]  blkdev_writepages+0x2a/0x30
[  663.219000]  do_writepages+0x1c/0x30
[  663.219022]  __writeback_single_inode+0x57/0x720
[  663.219042]  ? _raw_spin_unlock+0x22/0x30
[  663.219064]  writeback_sb_inodes+0x2f4/0x6a0
[  663.219086]  __writeback_inodes_wb+0x8d/0xc0
[  663.219107]  wb_writeback+0x33c/0x530
[  663.219127]  ? mark_held_locks+0x6f/0xa0
[  663.219149]  wb_workfn+0x356/0x630
[  663.219170]  process_one_work+0x208/0x6a0
[  663.219191]  ? process_one_work+0x18d/0x6a0
[  663.219212]  worker_thread+0x49/0x4a0
[  663.219233]  kthread+0x107/0x140
[  663.219253]  ? process_one_work+0x6a0/0x6a0
[  663.219275]  ? kthread_create_on_node+0x40/0x40
[  663.219299]  ret_from_fork+0x2e/0x40
[  663.219323] kworker/10:1    D    0   155      2 0x00000000
[  663.219349] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.219371] Call Trace:
[  663.219393]  __schedule+0x2da/0xb00
[  663.219421]  ? bit_wait+0x50/0x50
[  663.219443]  schedule+0x38/0x90
[  663.219465]  schedule_timeout+0x2fe/0x640
[  663.219487]  ? mark_held_locks+0x6f/0xa0
[  663.219509]  ? ktime_get+0x74/0x130
[  663.219531]  ? bit_wait+0x50/0x50
[  663.219553]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.219576]  ? trace_hardirqs_on+0xd/0x10
[  663.219598]  ? ktime_get+0x98/0x130
[  663.219619]  ? __delayacct_blkio_start+0x1a/0x30
[  663.219643]  ? bit_wait+0x50/0x50
[  663.219665]  io_schedule_timeout+0x9f/0x110
[  663.219688]  bit_wait_io+0x16/0x60
[  663.219711]  __wait_on_bit+0x53/0x80
[  663.219734]  ? bit_wait+0x50/0x50
[  663.219756]  out_of_line_wait_on_bit+0x6e/0x80
[  663.219779]  ? prepare_to_wait_event+0x170/0x170
[  663.219803]  sync_mapping_buffers+0x22f/0x390
[  663.219826]  __generic_file_fsync+0x4d/0x90
[  663.219848]  ext4_sync_file+0x2b4/0x540
[  663.219870]  vfs_fsync_range+0x46/0xa0
[  663.219892]  dio_complete+0x181/0x1b0
[  663.219915]  dio_aio_complete_work+0x17/0x20
[  663.219939]  process_one_work+0x208/0x6a0
[  663.219962]  ? process_one_work+0x18d/0x6a0
[  663.219986]  worker_thread+0x49/0x4a0
[  663.220011]  kthread+0x107/0x140
[  663.220038]  ? process_one_work+0x6a0/0x6a0
[  663.220063]  ? kthread_create_on_node+0x40/0x40
[  663.220090]  ret_from_fork+0x2e/0x40
[  663.220121] kworker/4:2     D    0   284      2 0x00000000
[  663.220148] Workqueue: srp_remove srp_remove_work [ib_srp]
[  663.220171] Call Trace:
[  663.220193]  __schedule+0x2da/0xb00
[  663.220214]  schedule+0x38/0x90
[  663.220236]  blk_mq_freeze_queue_wait+0x51/0xa0
[  663.220258]  ? remove_wait_queue+0x70/0x70
[  663.220281]  blk_mq_freeze_queue+0x15/0x20
[  663.220302]  blk_freeze_queue+0x9/0x10
[  663.220324]  blk_cleanup_queue+0xdd/0x290
[  663.220346]  __scsi_remove_device+0x49/0xd0
[  663.220368]  scsi_forget_host+0x5b/0x60
[  663.220390]  scsi_remove_host+0x6c/0x110
[  663.220412]  srp_remove_work+0x8b/0x220 [ib_srp]
[  663.220434]  process_one_work+0x208/0x6a0
[  663.220454]  ? process_one_work+0x18d/0x6a0
[  663.220475]  worker_thread+0x49/0x4a0
[  663.220496]  kthread+0x107/0x140
[  663.220516]  ? process_one_work+0x6a0/0x6a0
[  663.220537]  ? kthread_create_on_node+0x40/0x40
[  663.220560]  ret_from_fork+0x2e/0x40
[  663.220581] kworker/10:2    D    0   285      2 0x00000000
[  663.220605] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.220626] Call Trace:
[  663.220648]  __schedule+0x2da/0xb00
[  663.220669]  ? bit_wait+0x50/0x50
[  663.220690]  schedule+0x38/0x90
[  663.220711]  schedule_timeout+0x2fe/0x640
[  663.220732]  ? mark_held_locks+0x6f/0xa0
[  663.220753]  ? ktime_get+0x74/0x130
[  663.220774]  ? bit_wait+0x50/0x50
[  663.220794]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.220816]  ? trace_hardirqs_on+0xd/0x10
[  663.220837]  ? ktime_get+0x98/0x130
[  663.220858]  ? __delayacct_blkio_start+0x1a/0x30
[  663.220879]  ? bit_wait+0x50/0x50
[  663.220899]  io_schedule_timeout+0x9f/0x110
[  663.220920]  bit_wait_io+0x16/0x60
[  663.220941]  __wait_on_bit+0x53/0x80
[  663.220963]  ? bit_wait+0x50/0x50
[  663.220993]  out_of_line_wait_on_bit+0x6e/0x80
[  663.221015]  ? prepare_to_wait_event+0x170/0x170
[  663.221037]  sync_mapping_buffers+0x22f/0x390
[  663.221059]  __generic_file_fsync+0x4d/0x90
[  663.221081]  ext4_sync_file+0x2b4/0x540
[  663.221103]  vfs_fsync_range+0x46/0xa0
[  663.221124]  dio_complete+0x181/0x1b0
[  663.221146]  dio_aio_complete_work+0x17/0x20
[  663.221170]  process_one_work+0x208/0x6a0
[  663.221191]  ? process_one_work+0x18d/0x6a0
[  663.221214]  worker_thread+0x49/0x4a0
[  663.221237]  kthread+0x107/0x140
[  663.221259]  ? process_one_work+0x6a0/0x6a0
[  663.221281]  ? kthread_create_on_node+0x40/0x40
[  663.221304]  ret_from_fork+0x2e/0x40
[  663.221330] kworker/10:3    D    0   405      2 0x00000000
[  663.221354] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.221379] Call Trace:
[  663.221401]  __schedule+0x2da/0xb00
[  663.221424]  ? bit_wait+0x50/0x50
[  663.221446]  schedule+0x38/0x90
[  663.221470]  schedule_timeout+0x2fe/0x640
[  663.221495]  ? ktime_get+0x74/0x130
[  663.221520]  ? bit_wait+0x50/0x50
[  663.221546]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.221574]  ? trace_hardirqs_on+0xd/0x10
[  663.221600]  ? ktime_get+0x98/0x130
[  663.221622]  ? __delayacct_blkio_start+0x1a/0x30
[  663.221646]  ? bit_wait+0x50/0x50
[  663.221668]  io_schedule_timeout+0x9f/0x110
[  663.221690]  bit_wait_io+0x16/0x60
[  663.221712]  __wait_on_bit+0x53/0x80
[  663.221734]  ? bit_wait+0x50/0x50
[  663.221756]  out_of_line_wait_on_bit+0x6e/0x80
[  663.221778]  ? prepare_to_wait_event+0x170/0x170
[  663.221801]  __sync_dirty_buffer+0xdc/0x130
[  663.221822]  sync_dirty_buffer+0xe/0x10
[  663.221844]  ext4_write_inode+0x121/0x140
[  663.221866]  __writeback_single_inode+0x3ae/0x720
[  663.221887]  ? _raw_spin_unlock+0x22/0x30
[  663.221909]  writeback_single_inode+0xd0/0x190
[  663.221932]  sync_inode_metadata+0x2f/0x40
[  663.221953]  __generic_file_fsync+0x74/0x90
[  663.221975]  ext4_sync_file+0x2b4/0x540
[  663.221995]  vfs_fsync_range+0x46/0xa0
[  663.222016]  dio_complete+0x181/0x1b0
[  663.222036]  dio_aio_complete_work+0x17/0x20
[  663.222057]  process_one_work+0x208/0x6a0
[  663.222078]  ? process_one_work+0x18d/0x6a0
[  663.222099]  worker_thread+0x49/0x4a0
[  663.222121]  kthread+0x107/0x140
[  663.222141]  ? process_one_work+0x6a0/0x6a0
[  663.222161]  ? kthread_create_on_node+0x40/0x40
[  663.222183]  ret_from_fork+0x2e/0x40
[  663.222277] fio             D    0  9265   8846 0x00000000
[  663.222302] Call Trace:
[  663.222325]  __schedule+0x2da/0xb00
[  663.222347]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.222372]  schedule+0x38/0x90
[  663.222396]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.222423]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.222450]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.222479]  ? ___slab_alloc+0x178/0x520
[  663.222503]  call_rwsem_down_write_failed+0x17/0x30
[  663.222528]  down_write+0x5a/0x70
[  663.222553]  ? ext4_file_write_iter+0x45/0x360
[  663.222576]  ext4_file_write_iter+0x45/0x360
[  663.222600]  ? __sb_start_write+0xde/0x200
[  663.222621]  ? aio_write+0x14e/0x160
[  663.222643]  aio_write+0xd1/0x160
[  663.222795]  ? __might_fault+0x3e/0x90
[  663.222823]  do_io_submit+0x37d/0x900
[  663.222848]  ? do_io_submit+0x1ac/0x900
[  663.222871]  SyS_io_submit+0xb/0x10
[  663.222893]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.222915] RIP: 0033:0x7fc269d02787
[  663.222937] RSP: 002b:00007fc249e6f948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.222961] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.222984] RDX: 00007fc24004f190 RSI: 0000000000000001 RDI: 00007fc27bb=
fc000
[  663.223006] RBP: 0000000000000038 R08: 0000000000000001 R09: 00007fc2400=
4cfe0
[  663.223029] R10: 00007fc240039000 R11: 0000000000000202 R12: 00007fc24f0=
52000
[  663.223051] R13: 00007fc24004f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.223074] fio             D    0  9266   8846 0x00000000
[  663.223286] Call Trace:
[  663.223311]  __schedule+0x2da/0xb00
[  663.223333]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.223356]  schedule+0x38/0x90
[  663.223379]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.223402]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.223424]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.223447]  ? ___slab_alloc+0x178/0x520
[  663.223470]  call_rwsem_down_write_failed+0x17/0x30
[  663.223493]  down_write+0x5a/0x70
[  663.223514]  ? ext4_file_write_iter+0x45/0x360
[  663.223536]  ext4_file_write_iter+0x45/0x360
[  663.223558]  ? __sb_start_write+0xde/0x200
[  663.223579]  ? aio_write+0x14e/0x160
[  663.223599]  aio_write+0xd1/0x160
[  663.223621]  ? __might_fault+0x3e/0x90
[  663.223642]  do_io_submit+0x37d/0x900
[  663.223663]  ? do_io_submit+0x1ac/0x900
[  663.223684]  SyS_io_submit+0xb/0x10
[  663.223705]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.223725] RIP: 0033:0x7fc269d02787
[  663.223747] RSP: 002b:00007fc24a670948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.223769] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.223790] RDX: 00007fc23804f188 RSI: 0000000000000001 RDI: 00007fc27bc=
08000
[  663.223811] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc2380=
4d2a0
[  663.223833] R10: 00007fc238050000 R11: 0000000000000202 R12: 00000000000=
00020
[  663.223855] R13: 00007fc23804ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.223877] fio             D    0  9267   8846 0x00000000
[  663.224191] Call Trace:
[  663.224215]  __schedule+0x2da/0xb00
[  663.224236]  schedule+0x38/0x90
[  663.224258]  schedule_timeout+0x2fe/0x640
[  663.224280]  ? mark_held_locks+0x6f/0xa0
[  663.224303]  ? ktime_get+0x74/0x130
[  663.224325]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.224346]  ? trace_hardirqs_on+0xd/0x10
[  663.224368]  ? ktime_get+0x98/0x130
[  663.224389]  ? __delayacct_blkio_start+0x1a/0x30
[  663.224411]  io_schedule_timeout+0x9f/0x110
[  663.224433]  blk_mq_get_tag+0x158/0x260
[  663.224454]  ? remove_wait_queue+0x70/0x70
[  663.224476]  __blk_mq_alloc_request+0x16/0xe0
[  663.224521]  blk_mq_sched_get_request+0x279/0x370
[  663.224544]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.224567]  ? generic_make_request+0xca/0x290
[  663.224592]  blk_sq_make_request+0x111/0xc90
[  663.224620]  ? blk_queue_enter+0x2d/0x280
[  663.224643]  ? generic_make_request+0xca/0x290
[  663.224666]  generic_make_request+0xd7/0x290
[  663.224690]  submit_bio+0x5f/0x120
[  663.224711]  ? trace_hardirqs_on+0xd/0x10
[  663.224733]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.224758]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.224781]  ? _raw_spin_unlock+0x22/0x30
[  663.224806]  ? ext4_get_block_trans+0xe0/0xe0
[  663.224829]  __blockdev_direct_IO+0x35/0x40
[  663.224852]  ext4_direct_IO+0x19c/0x7b0
[  663.224874]  generic_file_direct_write+0xa6/0x150
[  663.224897]  __generic_file_write_iter+0xbb/0x1c0
[  663.224920]  ext4_file_write_iter+0x77/0x360
[  663.224946]  ? __sb_start_write+0xde/0x200
[  663.224967]  ? aio_write+0x14e/0x160
[  663.224988]  aio_write+0xd1/0x160
[  663.225009]  ? __might_fault+0x3e/0x90
[  663.225029]  do_io_submit+0x37d/0x900
[  663.225051]  ? do_io_submit+0x1ac/0x900
[  663.225076]  SyS_io_submit+0xb/0x10
[  663.225102]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225128] RIP: 0033:0x7fc269d02787
[  663.225151] RSP: 002b:00007fc24ae71948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.225175] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225205] RDX: 00007fc22804f2c8 RSI: 0000000000000001 RDI: 00007fc27bc=
0e000
[  663.225232] RBP: 00000000000000b0 R08: 0000000000000001 R09: 00007fc2280=
45fa0
[  663.225259] R10: 00007fc228012000 R11: 0000000000000202 R12: 00007fc24f0=
6e110
[  663.225283] R13: 00007fc22804f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.225309] fio             D    0  9268   8846 0x00000000
[  663.225338] Call Trace:
[  663.225366]  __schedule+0x2da/0xb00
[  663.225392]  schedule+0x38/0x90
[  663.225420]  schedule_timeout+0x2fe/0x640
[  663.225446]  ? mark_held_locks+0x6f/0xa0
[  663.225483]  ? ktime_get+0x74/0x130
[  663.225484]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.225486]  ? trace_hardirqs_on+0xd/0x10
[  663.225487]  ? ktime_get+0x98/0x130
[  663.225489]  ? __delayacct_blkio_start+0x1a/0x30
[  663.225491]  io_schedule_timeout+0x9f/0x110
[  663.225493]  blk_mq_get_tag+0x158/0x260
[  663.225494]  ? remove_wait_queue+0x70/0x70
[  663.225496]  __blk_mq_alloc_request+0x16/0xe0
[  663.225499]  blk_mq_sched_get_request+0x279/0x370
[  663.225500]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.225503]  ? generic_make_request+0xca/0x290
[  663.225505]  blk_sq_make_request+0x111/0xc90
[  663.225507]  ? blk_queue_enter+0x2d/0x280
[  663.225509]  ? generic_make_request+0xca/0x290
[  663.225511]  generic_make_request+0xd7/0x290
[  663.225513]  submit_bio+0x5f/0x120
[  663.225514]  ? trace_hardirqs_on+0xd/0x10
[  663.225516]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.225518]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.225520]  ? _raw_spin_unlock+0x22/0x30
[  663.225522]  ? ext4_get_block_trans+0xe0/0xe0
[  663.225524]  __blockdev_direct_IO+0x35/0x40
[  663.225526]  ext4_direct_IO+0x19c/0x7b0
[  663.225528]  generic_file_direct_write+0xa6/0x150
[  663.225530]  __generic_file_write_iter+0xbb/0x1c0
[  663.225531]  ext4_file_write_iter+0x77/0x360
[  663.225533]  ? __sb_start_write+0xde/0x200
[  663.225534]  ? aio_write+0x14e/0x160
[  663.225536]  aio_write+0xd1/0x160
[  663.225537]  ? __might_fault+0x3e/0x90
[  663.225539]  do_io_submit+0x37d/0x900
[  663.225540]  ? do_io_submit+0x1ac/0x900
[  663.225542]  SyS_io_submit+0xb/0x10
[  663.225543]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225544] RIP: 0033:0x7fc269d02787
[  663.225545] RSP: 002b:00007fc24f04e948 EFLAGS: 00000212 ORIG_RAX: 000000=
00000000d1
[  663.225549] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225550] RDX: 00007fc22004f1d0 RSI: 0000000000000001 RDI: 00007fc27bc=
00000
[  663.225551] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc2200=
4b8e0
[  663.225552] R10: 00007fc220031000 R11: 0000000000000212 R12: 00000000000=
00020
[  663.225552] R13: 00007fc22004ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.225554] fio             D    0  9269   8846 0x00000000
[  663.225557] Call Trace:
[  663.225559]  __schedule+0x2da/0xb00
[  663.225560]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.225562]  schedule+0x38/0x90
[  663.225564]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.225566]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.225568]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.225570]  ? ___slab_alloc+0x178/0x520
[  663.225573]  call_rwsem_down_write_failed+0x17/0x30
[  663.225575]  down_write+0x5a/0x70
[  663.225576]  ? ext4_file_write_iter+0x45/0x360
[  663.225578]  ext4_file_write_iter+0x45/0x360
[  663.225579]  ? __sb_start_write+0xde/0x200
[  663.225581]  ? aio_write+0x14e/0x160
[  663.225582]  aio_write+0xd1/0x160
[  663.225584]  ? __might_fault+0x3e/0x90
[  663.225585]  do_io_submit+0x37d/0x900
[  663.225586]  ? do_io_submit+0x1ac/0x900
[  663.225588]  SyS_io_submit+0xb/0x10
[  663.225589]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225590] RIP: 0033:0x7fc269d02787
[  663.225591] RSP: 002b:00007fc24e84d948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.225593] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225594] RDX: 00007fc23004f1e8 RSI: 0000000000000001 RDI: 00007fc27bc=
06000
[  663.225595] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc2300=
4b020
[  663.225595] R10: 00007fc23002e000 R11: 0000000000000202 R12: 00000000000=
00020
[  663.225596] R13: 00007fc23004ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.225598] fio             D    0  9270   8846 0x00000000
[  663.225600] Call Trace:
[  663.225602]  __schedule+0x2da/0xb00
[  663.225603]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.225605]  schedule+0x38/0x90
[  663.225607]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.225609]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.225611]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.225614]  ? ___slab_alloc+0x178/0x520
[  663.225616]  call_rwsem_down_write_failed+0x17/0x30
[  663.225618]  down_write+0x5a/0x70
[  663.225620]  ? ext4_file_write_iter+0x45/0x360
[  663.225622]  ext4_file_write_iter+0x45/0x360
[  663.225623]  ? __sb_start_write+0xde/0x200
[  663.225624]  ? aio_write+0x14e/0x160
[  663.225626]  aio_write+0xd1/0x160
[  663.225627]  ? __might_fault+0x3e/0x90
[  663.225629]  do_io_submit+0x37d/0x900
[  663.225630]  ? do_io_submit+0x1ac/0x900
[  663.225632]  SyS_io_submit+0xb/0x10
[  663.225633]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225634] RIP: 0033:0x7fc269d02787
[  663.225635] RSP: 002b:00007fc24e04c948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.225636] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225637] RDX: 00007fc21804f298 RSI: 0000000000000001 RDI: 00007fc27bc=
10000
[  663.225638] RBP: 0000000011bb7409 R08: 0000000000000001 R09: 00007fc2180=
470e0
[  663.225639] R10: 00007fc218018000 R11: 0000000000000202 R12: 0000000068b=
af4ba
[  663.225640] R13: 00000000165c8e46 R14: 000000002adf21b1 R15: 00000000169=
850e2
[  663.225642] fio             D    0  9271   8846 0x00000000
[  663.225644] Call Trace:
[  663.225646]  __schedule+0x2da/0xb00
[  663.225647]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.225649]  schedule+0x38/0x90
[  663.225651]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.225653]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.225656]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.225658]  ? ___slab_alloc+0x178/0x520
[  663.225660]  call_rwsem_down_write_failed+0x17/0x30
[  663.225662]  down_write+0x5a/0x70
[  663.225664]  ? ext4_file_write_iter+0x45/0x360
[  663.225665]  ext4_file_write_iter+0x45/0x360
[  663.225667]  ? __sb_start_write+0xde/0x200
[  663.225668]  ? aio_write+0x14e/0x160
[  663.225669]  aio_write+0xd1/0x160
[  663.225671]  ? __might_fault+0x3e/0x90
[  663.225673]  do_io_submit+0x37d/0x900
[  663.225674]  ? do_io_submit+0x1ac/0x900
[  663.225676]  SyS_io_submit+0xb/0x10
[  663.225677]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225678] RIP: 0033:0x7fc269d02787
[  663.225679] RSP: 002b:00007fc24d84b948 EFLAGS: 00000206 ORIG_RAX: 000000=
00000000d1
[  663.225681] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225682] RDX: 00007fc21004f210 RSI: 0000000000000001 RDI: 00007fc27bc=
0c000
[  663.225682] RBP: 0000000000000060 R08: 0000000000000001 R09: 00007fc2100=
4a1e0
[  663.225683] R10: 00007fc210029000 R11: 0000000000000206 R12: 00007fc24f0=
a6330
[  663.225684] R13: 00007fc21004f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.225686] fio             D    0  9272   8846 0x00000000
[  663.225689] Call Trace:
[  663.225691]  __schedule+0x2da/0xb00
[  663.225693]  schedule+0x38/0x90
[  663.225695]  schedule_timeout+0x2fe/0x640
[  663.225696]  ? mark_held_locks+0x6f/0xa0
[  663.225699]  ? ktime_get+0x74/0x130
[  663.225700]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.225702]  ? trace_hardirqs_on+0xd/0x10
[  663.225703]  ? ktime_get+0x98/0x130
[  663.225705]  ? __delayacct_blkio_start+0x1a/0x30
[  663.225707]  io_schedule_timeout+0x9f/0x110
[  663.225708]  blk_mq_get_tag+0x158/0x260
[  663.225710]  ? remove_wait_queue+0x70/0x70
[  663.225712]  __blk_mq_alloc_request+0x16/0xe0
[  663.225714]  blk_mq_sched_get_request+0x279/0x370
[  663.225715]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.225718]  ? generic_make_request+0xca/0x290
[  663.225720]  blk_sq_make_request+0x111/0xc90
[  663.225722]  ? blk_queue_enter+0x2d/0x280
[  663.225724]  ? generic_make_request+0xca/0x290
[  663.225727]  generic_make_request+0xd7/0x290
[  663.225730]  submit_bio+0x5f/0x120
[  663.225731]  ? trace_hardirqs_on+0xd/0x10
[  663.225733]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.225735]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.225737]  ? _raw_spin_unlock+0x22/0x30
[  663.225739]  ? ext4_get_block_trans+0xe0/0xe0
[  663.225741]  __blockdev_direct_IO+0x35/0x40
[  663.225743]  ext4_direct_IO+0x19c/0x7b0
[  663.225745]  generic_file_direct_write+0xa6/0x150
[  663.225747]  __generic_file_write_iter+0xbb/0x1c0
[  663.225749]  ext4_file_write_iter+0x77/0x360
[  663.225750]  ? __sb_start_write+0xde/0x200
[  663.225752]  ? aio_write+0x14e/0x160
[  663.225753]  aio_write+0xd1/0x160
[  663.225755]  ? __might_fault+0x3e/0x90
[  663.225756]  do_io_submit+0x37d/0x900
[  663.225758]  ? do_io_submit+0x1ac/0x900
[  663.225759]  SyS_io_submit+0xb/0x10
[  663.225761]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225762] RIP: 0033:0x7fc269d02787
[  663.225763] RSP: 002b:00007fc24d04a948 EFLAGS: 00000206 ORIG_RAX: 000000=
00000000d1
[  663.225764] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225765] RDX: 00007fc20804f260 RSI: 0000000000000001 RDI: 00007fc27bb=
fa000
[  663.225766] RBP: 00000000000000b8 R08: 0000000000000001 R09: 00007fc2080=
48520
[  663.225767] R10: 00007fc20801f000 R11: 0000000000000206 R12: 00007fc24f0=
b43b8
[  663.225768] R13: 00007fc20804f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.225770] fio             D    0  9273   8846 0x00000000
[  663.225772] Call Trace:
[  663.225774]  __schedule+0x2da/0xb00
[  663.225776]  schedule+0x38/0x90
[  663.225778]  schedule_timeout+0x2fe/0x640
[  663.225780]  ? mark_held_locks+0x6f/0xa0
[  663.225782]  ? ktime_get+0x74/0x130
[  663.225783]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.225784]  ? trace_hardirqs_on+0xd/0x10
[  663.225786]  ? ktime_get+0x98/0x130
[  663.225788]  ? __delayacct_blkio_start+0x1a/0x30
[  663.225790]  io_schedule_timeout+0x9f/0x110
[  663.225791]  blk_mq_get_tag+0x158/0x260
[  663.225793]  ? remove_wait_queue+0x70/0x70
[  663.225795]  __blk_mq_alloc_request+0x16/0xe0
[  663.225797]  blk_mq_sched_get_request+0x279/0x370
[  663.225798]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.225800]  ? generic_make_request+0xca/0x290
[  663.225803]  blk_sq_make_request+0x111/0xc90
[  663.225805]  ? blk_queue_enter+0x2d/0x280
[  663.225807]  ? generic_make_request+0xca/0x290
[  663.225809]  generic_make_request+0xd7/0x290
[  663.225811]  submit_bio+0x5f/0x120
[  663.225813]  ? trace_hardirqs_on+0xd/0x10
[  663.225814]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.225816]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.225818]  ? _raw_spin_unlock+0x22/0x30
[  663.225820]  ? ext4_get_block_trans+0xe0/0xe0
[  663.225822]  __blockdev_direct_IO+0x35/0x40
[  663.225824]  ext4_direct_IO+0x19c/0x7b0
[  663.225826]  generic_file_direct_write+0xa6/0x150
[  663.225828]  __generic_file_write_iter+0xbb/0x1c0
[  663.225829]  ext4_file_write_iter+0x77/0x360
[  663.225831]  ? __sb_start_write+0xde/0x200
[  663.225832]  ? aio_write+0x14e/0x160
[  663.225833]  aio_write+0xd1/0x160
[  663.225835]  ? __might_fault+0x3e/0x90
[  663.225837]  do_io_submit+0x37d/0x900
[  663.225838]  ? do_io_submit+0x1ac/0x900
[  663.225839]  SyS_io_submit+0xb/0x10
[  663.225841]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225842] RIP: 0033:0x7fc269d02787
[  663.225842] RSP: 002b:00007fc24c849948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.225844] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225845] RDX: 00007fc1d004f200 RSI: 0000000000000001 RDI: 00007fc27bb=
f2000
[  663.225846] RBP: 0000000000000050 R08: 0000000000000001 R09: 00007fc1d00=
4a7a0
[  663.225847] R10: 00007fc1d002b000 R11: 0000000000000202 R12: 00007fc24f0=
c2440
[  663.225848] R13: 00007fc1d004f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.225849] fio             D    0  9274   8846 0x00000000
[  663.225851] Call Trace:
[  663.225853]  __schedule+0x2da/0xb00
[  663.225855]  schedule+0x38/0x90
[  663.225857]  schedule_timeout+0x2fe/0x640
[  663.225858]  ? mark_held_locks+0x6f/0xa0
[  663.225860]  ? ktime_get+0x74/0x130
[  663.225861]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.225863]  ? trace_hardirqs_on+0xd/0x10
[  663.225864]  ? ktime_get+0x98/0x130
[  663.225866]  ? __delayacct_blkio_start+0x1a/0x30
[  663.225868]  io_schedule_timeout+0x9f/0x110
[  663.225869]  blk_mq_get_tag+0x158/0x260
[  663.225871]  ? remove_wait_queue+0x70/0x70
[  663.225873]  __blk_mq_alloc_request+0x16/0xe0
[  663.225875]  blk_mq_sched_get_request+0x279/0x370
[  663.225876]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.225878]  ? generic_make_request+0xca/0x290
[  663.225880]  blk_sq_make_request+0x111/0xc90
[  663.225882]  ? blk_queue_enter+0x2d/0x280
[  663.225885]  ? generic_make_request+0xca/0x290
[  663.225887]  generic_make_request+0xd7/0x290
[  663.225889]  submit_bio+0x5f/0x120
[  663.225890]  ? trace_hardirqs_on+0xd/0x10
[  663.225892]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.225894]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.225895]  ? _raw_spin_unlock+0x22/0x30
[  663.225898]  ? ext4_get_block_trans+0xe0/0xe0
[  663.225901]  __blockdev_direct_IO+0x35/0x40
[  663.225903]  ext4_direct_IO+0x19c/0x7b0
[  663.225905]  generic_file_direct_write+0xa6/0x150
[  663.225907]  __generic_file_write_iter+0xbb/0x1c0
[  663.225908]  ext4_file_write_iter+0x77/0x360
[  663.225910]  ? __sb_start_write+0xde/0x200
[  663.225911]  ? aio_write+0x14e/0x160
[  663.225913]  aio_write+0xd1/0x160
[  663.225915]  ? __might_fault+0x3e/0x90
[  663.225916]  do_io_submit+0x37d/0x900
[  663.225918]  ? do_io_submit+0x1ac/0x900
[  663.225920]  SyS_io_submit+0xb/0x10
[  663.225921]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.225922] RIP: 0033:0x7fc269d02787
[  663.225923] RSP: 002b:00007fc24c048948 EFLAGS: 00000206 ORIG_RAX: 000000=
00000000d1
[  663.225925] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.225926] RDX: 00007fc20004f1f0 RSI: 0000000000000001 RDI: 00007fc27bc=
02000
[  663.225927] RBP: 000000001d36c979 R08: 0000000000000001 R09: 00007fc2000=
4ad60
[  663.225927] R10: 00007fc20002d000 R11: 0000000000000206 R12: 00000000d32=
2e5e6
[  663.225928] R13: 000000002b3b7b00 R14: 00000000573a44d8 R15: 0000000001e=
412a3
[  663.225930] fio             D    0  9275   8846 0x00000000
[  663.225932] Call Trace:
[  663.225935]  __schedule+0x2da/0xb00
[  663.225936]  schedule+0x38/0x90
[  663.225939]  schedule_timeout+0x2fe/0x640
[  663.225940]  ? mark_held_locks+0x6f/0xa0
[  663.225942]  ? ktime_get+0x74/0x130
[  663.225943]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.225945]  ? trace_hardirqs_on+0xd/0x10
[  663.225946]  ? ktime_get+0x98/0x130
[  663.225948]  ? __delayacct_blkio_start+0x1a/0x30
[  663.225949]  io_schedule_timeout+0x9f/0x110
[  663.225951]  blk_mq_get_tag+0x158/0x260
[  663.225952]  ? remove_wait_queue+0x70/0x70
[  663.225954]  __blk_mq_alloc_request+0x16/0xe0
[  663.225956]  blk_mq_sched_get_request+0x279/0x370
[  663.225958]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.225960]  ? generic_make_request+0xca/0x290
[  663.225963]  blk_sq_make_request+0x111/0xc90
[  663.225965]  ? blk_queue_enter+0x2d/0x280
[  663.225967]  ? generic_make_request+0xca/0x290
[  663.225969]  generic_make_request+0xd7/0x290
[  663.225971]  submit_bio+0x5f/0x120
[  663.225973]  ? trace_hardirqs_on+0xd/0x10
[  663.225974]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.225976]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.225977]  ? _raw_spin_unlock+0x22/0x30
[  663.225980]  ? ext4_get_block_trans+0xe0/0xe0
[  663.225981]  __blockdev_direct_IO+0x35/0x40
[  663.225983]  ext4_direct_IO+0x19c/0x7b0
[  663.225985]  generic_file_direct_write+0xa6/0x150
[  663.225987]  __generic_file_write_iter+0xbb/0x1c0
[  663.225988]  ext4_file_write_iter+0x77/0x360
[  663.225990]  ? __sb_start_write+0xde/0x200
[  663.225991]  ? aio_write+0x14e/0x160
[  663.225992]  aio_write+0xd1/0x160
[  663.225994]  ? __might_fault+0x3e/0x90
[  663.225995]  do_io_submit+0x37d/0x900
[  663.225997]  ? do_io_submit+0x1ac/0x900
[  663.225998]  SyS_io_submit+0xb/0x10
[  663.226000]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226000] RIP: 0033:0x7fc269d02787
[  663.226001] RSP: 002b:00007fc24b847948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.226003] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226004] RDX: 00007fc1f804f1c0 RSI: 0000000000000001 RDI: 00007fc27bb=
f8000
[  663.226005] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc1f80=
4bea0
[  663.226006] R10: 00007fc1f8033000 R11: 0000000000000202 R12: 00000000000=
00020
[  663.226007] R13: 00007fc1f804ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.226009] fio             D    0  9276   8846 0x00000000
[  663.226011] Call Trace:
[  663.226013]  __schedule+0x2da/0xb00
[  663.226014]  schedule+0x38/0x90
[  663.226016]  schedule_timeout+0x2fe/0x640
[  663.226018]  ? mark_held_locks+0x6f/0xa0
[  663.226019]  ? ktime_get+0x74/0x130
[  663.226021]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226022]  ? trace_hardirqs_on+0xd/0x10
[  663.226024]  ? ktime_get+0x98/0x130
[  663.226025]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226027]  io_schedule_timeout+0x9f/0x110
[  663.226028]  blk_mq_get_tag+0x158/0x260
[  663.226030]  ? remove_wait_queue+0x70/0x70
[  663.226032]  __blk_mq_alloc_request+0x16/0xe0
[  663.226033]  blk_mq_sched_get_request+0x279/0x370
[  663.226035]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.226038]  ? generic_make_request+0xca/0x290
[  663.226040]  blk_sq_make_request+0x111/0xc90
[  663.226042]  ? blk_queue_enter+0x2d/0x280
[  663.226044]  ? generic_make_request+0xca/0x290
[  663.226046]  generic_make_request+0xd7/0x290
[  663.226048]  submit_bio+0x5f/0x120
[  663.226049]  ? trace_hardirqs_on+0xd/0x10
[  663.226051]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.226053]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.226054]  ? _raw_spin_unlock+0x22/0x30
[  663.226057]  ? ext4_get_block_trans+0xe0/0xe0
[  663.226058]  __blockdev_direct_IO+0x35/0x40
[  663.226060]  ext4_direct_IO+0x19c/0x7b0
[  663.226062]  generic_file_direct_write+0xa6/0x150
[  663.226064]  __generic_file_write_iter+0xbb/0x1c0
[  663.226066]  ext4_file_write_iter+0x77/0x360
[  663.226068]  ? __sb_start_write+0xde/0x200
[  663.226070]  ? aio_write+0x14e/0x160
[  663.226072]  aio_write+0xd1/0x160
[  663.226074]  ? __might_fault+0x3e/0x90
[  663.226076]  do_io_submit+0x37d/0x900
[  663.226077]  ? do_io_submit+0x1ac/0x900
[  663.226079]  SyS_io_submit+0xb/0x10
[  663.226080]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226081] RIP: 0033:0x7fc269d02787
[  663.226082] RSP: 002b:00007fc248e6d948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.226084] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226085] RDX: 00007fc1f004f158 RSI: 0000000000000001 RDI: 00007fc27bb=
fe000
[  663.226086] RBP: 0000000000000815 R08: 0000000000000001 R09: 00007fc1f00=
4e3e0
[  663.226087] R10: 00007fc1f0040000 R11: 0000000000000202 R12: 00000000000=
006d0
[  663.226088] R13: 00007fc1f004e930 R14: 0000000000001000 R15: 00000000000=
00830
[  663.226089] fio             D    0  9277   8846 0x00000000
[  663.226091] Call Trace:
[  663.226094]  __schedule+0x2da/0xb00
[  663.226095]  schedule+0x38/0x90
[  663.226097]  schedule_timeout+0x2fe/0x640
[  663.226099]  ? mark_held_locks+0x6f/0xa0
[  663.226101]  ? ktime_get+0x74/0x130
[  663.226102]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226103]  ? trace_hardirqs_on+0xd/0x10
[  663.226105]  ? ktime_get+0x98/0x130
[  663.226107]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226109]  io_schedule_timeout+0x9f/0x110
[  663.226110]  blk_mq_get_tag+0x158/0x260
[  663.226112]  ? remove_wait_queue+0x70/0x70
[  663.226114]  __blk_mq_alloc_request+0x16/0xe0
[  663.226115]  blk_mq_sched_get_request+0x279/0x370
[  663.226117]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.226119]  ? generic_make_request+0xca/0x290
[  663.226121]  blk_sq_make_request+0x111/0xc90
[  663.226123]  ? blk_queue_enter+0x2d/0x280
[  663.226125]  ? generic_make_request+0xca/0x290
[  663.226127]  generic_make_request+0xd7/0x290
[  663.226130]  submit_bio+0x5f/0x120
[  663.226131]  ? trace_hardirqs_on+0xd/0x10
[  663.226133]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.226135]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.226136]  ? _raw_spin_unlock+0x22/0x30
[  663.226138]  ? ext4_get_block_trans+0xe0/0xe0
[  663.226140]  __blockdev_direct_IO+0x35/0x40
[  663.226142]  ext4_direct_IO+0x19c/0x7b0
[  663.226144]  generic_file_direct_write+0xa6/0x150
[  663.226146]  __generic_file_write_iter+0xbb/0x1c0
[  663.226148]  ext4_file_write_iter+0x77/0x360
[  663.226149]  ? __sb_start_write+0xde/0x200
[  663.226150]  ? aio_write+0x14e/0x160
[  663.226152]  aio_write+0xd1/0x160
[  663.226153]  ? __might_fault+0x3e/0x90
[  663.226155]  do_io_submit+0x37d/0x900
[  663.226156]  ? do_io_submit+0x1ac/0x900
[  663.226157]  SyS_io_submit+0xb/0x10
[  663.226159]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226160] RIP: 0033:0x7fc269d02787
[  663.226160] RSP: 002b:00007fc24866c948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.226162] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226163] RDX: 00007fc1d804f1e8 RSI: 0000000000000001 RDI: 00007fc27bb=
f6000
[  663.226164] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc1d80=
4b020
[  663.226165] R10: 00007fc1d802e000 R11: 0000000000000202 R12: 00000000000=
00020
[  663.226166] R13: 00007fc1d804ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.226167] fio             D    0  9278   8846 0x00000000
[  663.226169] Call Trace:
[  663.226171]  __schedule+0x2da/0xb00
[  663.226172]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.226174]  schedule+0x38/0x90
[  663.226176]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226178]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226181]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226183]  ? ___slab_alloc+0x178/0x520
[  663.226186]  call_rwsem_down_write_failed+0x17/0x30
[  663.226188]  down_write+0x5a/0x70
[  663.226190]  ? ext4_file_write_iter+0x45/0x360
[  663.226191]  ext4_file_write_iter+0x45/0x360
[  663.226193]  ? __sb_start_write+0xde/0x200
[  663.226194]  ? aio_write+0x14e/0x160
[  663.226195]  aio_write+0xd1/0x160
[  663.226197]  ? __might_fault+0x3e/0x90
[  663.226198]  do_io_submit+0x37d/0x900
[  663.226201]  ? do_io_submit+0x1ac/0x900
[  663.226202]  SyS_io_submit+0xb/0x10
[  663.226204]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226205] RIP: 0033:0x7fc269d02787
[  663.226206] RSP: 002b:00007fc247e6b948 EFLAGS: 00000206 ORIG_RAX: 000000=
00000000d1
[  663.226208] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226209] RDX: 00007fc23c04f288 RSI: 0000000000000001 RDI: 00007fc27bc=
0a000
[  663.226210] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc23c0=
476a0
[  663.226211] R10: 00007fc23c01a000 R11: 0000000000000206 R12: 00000000000=
00020
[  663.226212] R13: 00007fc23c04ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.226214] fio             D    0  9279   8846 0x00000000
[  663.226216] Call Trace:
[  663.226218]  __schedule+0x2da/0xb00
[  663.226220]  schedule+0x38/0x90
[  663.226222]  schedule_timeout+0x2fe/0x640
[  663.226223]  ? mark_held_locks+0x6f/0xa0
[  663.226225]  ? ktime_get+0x74/0x130
[  663.226227]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226228]  ? trace_hardirqs_on+0xd/0x10
[  663.226230]  ? ktime_get+0x98/0x130
[  663.226231]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226233]  io_schedule_timeout+0x9f/0x110
[  663.226235]  blk_mq_get_tag+0x158/0x260
[  663.226237]  ? remove_wait_queue+0x70/0x70
[  663.226239]  __blk_mq_alloc_request+0x16/0xe0
[  663.226241]  blk_mq_sched_get_request+0x279/0x370
[  663.226243]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.226245]  ? generic_make_request+0xca/0x290
[  663.226247]  blk_sq_make_request+0x111/0xc90
[  663.226249]  ? blk_queue_enter+0x2d/0x280
[  663.226251]  ? generic_make_request+0xca/0x290
[  663.226253]  generic_make_request+0xd7/0x290
[  663.226255]  submit_bio+0x5f/0x120
[  663.226257]  ? trace_hardirqs_on+0xd/0x10
[  663.226258]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.226261]  ? ext4_get_block_trans+0xe0/0xe0
[  663.226263]  __blockdev_direct_IO+0x35/0x40
[  663.226265]  ext4_direct_IO+0x19c/0x7b0
[  663.226267]  generic_file_direct_write+0xa6/0x150
[  663.226269]  __generic_file_write_iter+0xbb/0x1c0
[  663.226270]  ext4_file_write_iter+0x77/0x360
[  663.226272]  ? __sb_start_write+0xde/0x200
[  663.226274]  ? aio_write+0x14e/0x160
[  663.226275]  aio_write+0xd1/0x160
[  663.226276]  ? __might_fault+0x3e/0x90
[  663.226278]  do_io_submit+0x37d/0x900
[  663.226279]  ? do_io_submit+0x1ac/0x900
[  663.226281]  SyS_io_submit+0xb/0x10
[  663.226282]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226283] RIP: 0033:0x7fc269d02787
[  663.226284] RSP: 002b:00007fc24766a948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.226285] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226286] RDX: 00007fc1e804f248 RSI: 0000000000000001 RDI: 00007fc27bb=
f4000
[  663.226287] RBP: 0000000000000088 R08: 0000000000000001 R09: 00007fc1e80=
48da0
[  663.226288] R10: 00007fc1e8022000 R11: 0000000000000202 R12: 00007fc24f1=
16770
[  663.226289] R13: 00007fc1e804f360 R14: 0000000000000000 R15: 00000000000=
00001
[  663.226291] fio             D    0  9280   8846 0x00000000
[  663.226293] Call Trace:
[  663.226295]  __schedule+0x2da/0xb00
[  663.226297]  schedule+0x38/0x90
[  663.226298]  schedule_timeout+0x2fe/0x640
[  663.226300]  ? mark_held_locks+0x6f/0xa0
[  663.226302]  ? ktime_get+0x74/0x130
[  663.226303]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226305]  ? trace_hardirqs_on+0xd/0x10
[  663.226307]  ? ktime_get+0x98/0x130
[  663.226309]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226310]  io_schedule_timeout+0x9f/0x110
[  663.226312]  blk_mq_get_tag+0x158/0x260
[  663.226313]  ? remove_wait_queue+0x70/0x70
[  663.226315]  __blk_mq_alloc_request+0x16/0xe0
[  663.226317]  blk_mq_sched_get_request+0x279/0x370
[  663.226319]  ? blk_mq_sched_bypass_insert+0x70/0x70
[  663.226321]  ? generic_make_request+0xca/0x290
[  663.226323]  blk_sq_make_request+0x111/0xc90
[  663.226325]  ? blk_queue_enter+0x2d/0x280
[  663.226327]  ? generic_make_request+0xca/0x290
[  663.226329]  generic_make_request+0xd7/0x290
[  663.226331]  submit_bio+0x5f/0x120
[  663.226333]  ? trace_hardirqs_on+0xd/0x10
[  663.226334]  do_blockdev_direct_IO+0x280f/0x31f0
[  663.226337]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  663.226338]  ? _raw_spin_unlock+0x22/0x30
[  663.226341]  ? ext4_get_block_trans+0xe0/0xe0
[  663.226343]  __blockdev_direct_IO+0x35/0x40
[  663.226345]  ext4_direct_IO+0x19c/0x7b0
[  663.226347]  generic_file_direct_write+0xa6/0x150
[  663.226349]  __generic_file_write_iter+0xbb/0x1c0
[  663.226350]  ext4_file_write_iter+0x77/0x360
[  663.226352]  ? __sb_start_write+0xde/0x200
[  663.226354]  ? aio_write+0x14e/0x160
[  663.226355]  aio_write+0xd1/0x160
[  663.226357]  ? __might_fault+0x3e/0x90
[  663.226358]  do_io_submit+0x37d/0x900
[  663.226360]  ? do_io_submit+0x1ac/0x900
[  663.226362]  SyS_io_submit+0xb/0x10
[  663.226363]  entry_SYSCALL_64_fastpath+0x18/0xad
[  663.226364] RIP: 0033:0x7fc269d02787
[  663.226365] RSP: 002b:00007fc246e69948 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000d1
[  663.226367] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fc269d=
02787
[  663.226368] RDX: 00007fc1e004f188 RSI: 0000000000000001 RDI: 00007fc27bc=
04000
[  663.226369] RBP: 0000000000000065 R08: 0000000000000001 R09: 00007fc1e00=
4d2a0
[  663.226370] R10: 00007fc1e0050000 R11: 0000000000000202 R12: 00000000000=
00020
[  663.226371] R13: 00007fc1e004ffe0 R14: 0000000000001000 R15: 00000000000=
00080
[  663.226374] kworker/10:4    D    0  9296      2 0x00000000
[  663.226377] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226378] Call Trace:
[  663.226381]  __schedule+0x2da/0xb00
[  663.226383]  ? bit_wait+0x50/0x50
[  663.226384]  schedule+0x38/0x90
[  663.226386]  schedule_timeout+0x2fe/0x640
[  663.226388]  ? mark_held_locks+0x6f/0xa0
[  663.226390]  ? ktime_get+0x74/0x130
[  663.226392]  ? bit_wait+0x50/0x50
[  663.226393]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226395]  ? trace_hardirqs_on+0xd/0x10
[  663.226396]  ? ktime_get+0x98/0x130
[  663.226398]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226400]  ? bit_wait+0x50/0x50
[  663.226401]  io_schedule_timeout+0x9f/0x110
[  663.226404]  bit_wait_io+0x16/0x60
[  663.226406]  __wait_on_bit+0x53/0x80
[  663.226407]  ? bit_wait+0x50/0x50
[  663.226409]  out_of_line_wait_on_bit+0x6e/0x80
[  663.226411]  ? prepare_to_wait_event+0x170/0x170
[  663.226413]  sync_mapping_buffers+0x22f/0x390
[  663.226415]  __generic_file_fsync+0x4d/0x90
[  663.226418]  ext4_sync_file+0x2b4/0x540
[  663.226420]  vfs_fsync_range+0x46/0xa0
[  663.226421]  dio_complete+0x181/0x1b0
[  663.226423]  dio_aio_complete_work+0x17/0x20
[  663.226424]  process_one_work+0x208/0x6a0
[  663.226425]  ? process_one_work+0x18d/0x6a0
[  663.226427]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226429]  worker_thread+0x49/0x4a0
[  663.226431]  kthread+0x107/0x140
[  663.226432]  ? process_one_work+0x6a0/0x6a0
[  663.226434]  ? kthread_create_on_node+0x40/0x40
[  663.226436]  ret_from_fork+0x2e/0x40
[  663.226438] kworker/10:5    D    0  9297      2 0x00000000
[  663.226441] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226442] Call Trace:
[  663.226444]  __schedule+0x2da/0xb00
[  663.226446]  schedule+0x38/0x90
[  663.226448]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226450]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226452]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226454]  call_rwsem_down_write_failed+0x17/0x30
[  663.226457]  down_write+0x5a/0x70
[  663.226458]  ? __generic_file_fsync+0x43/0x90
[  663.226460]  __generic_file_fsync+0x43/0x90
[  663.226462]  ext4_sync_file+0x2b4/0x540
[  663.226463]  vfs_fsync_range+0x46/0xa0
[  663.226465]  dio_complete+0x181/0x1b0
[  663.226466]  dio_aio_complete_work+0x17/0x20
[  663.226468]  process_one_work+0x208/0x6a0
[  663.226470]  ? process_one_work+0x18d/0x6a0
[  663.226472]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226473]  worker_thread+0x49/0x4a0
[  663.226475]  kthread+0x107/0x140
[  663.226477]  ? process_one_work+0x6a0/0x6a0
[  663.226479]  ? kthread_create_on_node+0x40/0x40
[  663.226480]  ret_from_fork+0x2e/0x40
[  663.226482] kworker/10:6    D    0  9298      2 0x00000000
[  663.226485] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226486] Call Trace:
[  663.226488]  __schedule+0x2da/0xb00
[  663.226490]  schedule+0x38/0x90
[  663.226492]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226494]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226496]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226498]  call_rwsem_down_write_failed+0x17/0x30
[  663.226500]  down_write+0x5a/0x70
[  663.226503]  ? __generic_file_fsync+0x43/0x90
[  663.226504]  __generic_file_fsync+0x43/0x90
[  663.226506]  ext4_sync_file+0x2b4/0x540
[  663.226508]  vfs_fsync_range+0x46/0xa0
[  663.226509]  dio_complete+0x181/0x1b0
[  663.226510]  dio_aio_complete_work+0x17/0x20
[  663.226512]  process_one_work+0x208/0x6a0
[  663.226513]  ? process_one_work+0x18d/0x6a0
[  663.226515]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226517]  worker_thread+0x49/0x4a0
[  663.226519]  kthread+0x107/0x140
[  663.226521]  ? process_one_work+0x6a0/0x6a0
[  663.226522]  ? kthread_create_on_node+0x40/0x40
[  663.226524]  ret_from_fork+0x2e/0x40
[  663.226525] kworker/10:7    D    0  9299      2 0x00000000
[  663.226528] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226529] Call Trace:
[  663.226531]  __schedule+0x2da/0xb00
[  663.226533]  schedule+0x38/0x90
[  663.226535]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226537]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226539]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226541]  call_rwsem_down_write_failed+0x17/0x30
[  663.226543]  down_write+0x5a/0x70
[  663.226545]  ? __generic_file_fsync+0x43/0x90
[  663.226546]  __generic_file_fsync+0x43/0x90
[  663.226548]  ext4_sync_file+0x2b4/0x540
[  663.226549]  vfs_fsync_range+0x46/0xa0
[  663.226550]  dio_complete+0x181/0x1b0
[  663.226552]  dio_aio_complete_work+0x17/0x20
[  663.226553]  process_one_work+0x208/0x6a0
[  663.226554]  ? process_one_work+0x18d/0x6a0
[  663.226556]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226557]  worker_thread+0x49/0x4a0
[  663.226559]  kthread+0x107/0x140
[  663.226560]  ? process_one_work+0x6a0/0x6a0
[  663.226562]  ? kthread_create_on_node+0x40/0x40
[  663.226563]  ret_from_fork+0x2e/0x40
[  663.226565] kworker/10:8    D    0  9300      2 0x00000000
[  663.226568] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226569] Call Trace:
[  663.226571]  __schedule+0x2da/0xb00
[  663.226573]  schedule+0x38/0x90
[  663.226575]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226577]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226578]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226581]  call_rwsem_down_write_failed+0x17/0x30
[  663.226583]  down_write+0x5a/0x70
[  663.226584]  ? __generic_file_fsync+0x43/0x90
[  663.226586]  __generic_file_fsync+0x43/0x90
[  663.226588]  ext4_sync_file+0x2b4/0x540
[  663.226589]  vfs_fsync_range+0x46/0xa0
[  663.226591]  dio_complete+0x181/0x1b0
[  663.226592]  dio_aio_complete_work+0x17/0x20
[  663.226594]  process_one_work+0x208/0x6a0
[  663.226595]  ? process_one_work+0x18d/0x6a0
[  663.226597]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226599]  worker_thread+0x49/0x4a0
[  663.226601]  kthread+0x107/0x140
[  663.226602]  ? process_one_work+0x6a0/0x6a0
[  663.226604]  ? kthread_create_on_node+0x40/0x40
[  663.226606]  ret_from_fork+0x2e/0x40
[  663.226607] kworker/10:9    D    0  9301      2 0x00000000
[  663.226610] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226611] Call Trace:
[  663.226613]  __schedule+0x2da/0xb00
[  663.226615]  schedule+0x38/0x90
[  663.226617]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226619]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226621]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226624]  call_rwsem_down_write_failed+0x17/0x30
[  663.226626]  down_write+0x5a/0x70
[  663.226628]  ? __generic_file_fsync+0x43/0x90
[  663.226629]  __generic_file_fsync+0x43/0x90
[  663.226632]  ext4_sync_file+0x2b4/0x540
[  663.226633]  vfs_fsync_range+0x46/0xa0
[  663.226635]  dio_complete+0x181/0x1b0
[  663.226636]  dio_aio_complete_work+0x17/0x20
[  663.226638]  process_one_work+0x208/0x6a0
[  663.226639]  ? process_one_work+0x18d/0x6a0
[  663.226641]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226642]  worker_thread+0x49/0x4a0
[  663.226644]  kthread+0x107/0x140
[  663.226646]  ? process_one_work+0x6a0/0x6a0
[  663.226647]  ? kthread_create_on_node+0x40/0x40
[  663.226649]  ret_from_fork+0x2e/0x40
[  663.226650] kworker/10:10   D    0  9302      2 0x00000000
[  663.226653] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226654] Call Trace:
[  663.226656]  __schedule+0x2da/0xb00
[  663.226658]  schedule+0x38/0x90
[  663.226660]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226662]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226664]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226667]  call_rwsem_down_write_failed+0x17/0x30
[  663.226669]  down_write+0x5a/0x70
[  663.226671]  ? __generic_file_fsync+0x43/0x90
[  663.226673]  __generic_file_fsync+0x43/0x90
[  663.226674]  ext4_sync_file+0x2b4/0x540
[  663.226676]  vfs_fsync_range+0x46/0xa0
[  663.226677]  dio_complete+0x181/0x1b0
[  663.226678]  dio_aio_complete_work+0x17/0x20
[  663.226680]  process_one_work+0x208/0x6a0
[  663.226681]  ? process_one_work+0x18d/0x6a0
[  663.226683]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226684]  worker_thread+0x49/0x4a0
[  663.226686]  kthread+0x107/0x140
[  663.226687]  ? process_one_work+0x6a0/0x6a0
[  663.226688]  ? kthread_create_on_node+0x40/0x40
[  663.226690]  ret_from_fork+0x2e/0x40
[  663.226692] kworker/10:11   D    0  9303      2 0x00000000
[  663.226695] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226696] Call Trace:
[  663.226698]  __schedule+0x2da/0xb00
[  663.226700]  schedule+0x38/0x90
[  663.226702]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226704]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226706]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226708]  call_rwsem_down_write_failed+0x17/0x30
[  663.226710]  down_write+0x5a/0x70
[  663.226712]  ? __generic_file_fsync+0x43/0x90
[  663.226713]  __generic_file_fsync+0x43/0x90
[  663.226715]  ext4_sync_file+0x2b4/0x540
[  663.226717]  vfs_fsync_range+0x46/0xa0
[  663.226718]  dio_complete+0x181/0x1b0
[  663.226719]  dio_aio_complete_work+0x17/0x20
[  663.226721]  process_one_work+0x208/0x6a0
[  663.226722]  ? process_one_work+0x18d/0x6a0
[  663.226724]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226726]  worker_thread+0x49/0x4a0
[  663.226728]  kthread+0x107/0x140
[  663.226729]  ? process_one_work+0x6a0/0x6a0
[  663.226731]  ? kthread_create_on_node+0x40/0x40
[  663.226732]  ret_from_fork+0x2e/0x40
[  663.226734] kworker/10:12   D    0  9304      2 0x00000000
[  663.226737] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226738] Call Trace:
[  663.226740]  __schedule+0x2da/0xb00
[  663.226742]  schedule+0x38/0x90
[  663.226744]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226746]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226748]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226751]  call_rwsem_down_write_failed+0x17/0x30
[  663.226753]  down_write+0x5a/0x70
[  663.226755]  ? __generic_file_fsync+0x43/0x90
[  663.226757]  __generic_file_fsync+0x43/0x90
[  663.226758]  ext4_sync_file+0x2b4/0x540
[  663.226760]  vfs_fsync_range+0x46/0xa0
[  663.226761]  dio_complete+0x181/0x1b0
[  663.226763]  dio_aio_complete_work+0x17/0x20
[  663.226764]  process_one_work+0x208/0x6a0
[  663.226765]  ? process_one_work+0x18d/0x6a0
[  663.226767]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226769]  worker_thread+0x49/0x4a0
[  663.226771]  kthread+0x107/0x140
[  663.226772]  ? process_one_work+0x6a0/0x6a0
[  663.226773]  ? kthread_create_on_node+0x40/0x40
[  663.226775]  ret_from_fork+0x2e/0x40
[  663.226777] kworker/10:13   D    0  9305      2 0x00000000
[  663.226779] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226781] Call Trace:
[  663.226783]  __schedule+0x2da/0xb00
[  663.226785]  ? bit_wait+0x50/0x50
[  663.226787]  schedule+0x38/0x90
[  663.226789]  schedule_timeout+0x2fe/0x640
[  663.226790]  ? mark_held_locks+0x6f/0xa0
[  663.226792]  ? ktime_get+0x74/0x130
[  663.226794]  ? bit_wait+0x50/0x50
[  663.226795]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.226796]  ? trace_hardirqs_on+0xd/0x10
[  663.226798]  ? ktime_get+0x98/0x130
[  663.226800]  ? __delayacct_blkio_start+0x1a/0x30
[  663.226801]  ? bit_wait+0x50/0x50
[  663.226803]  io_schedule_timeout+0x9f/0x110
[  663.226805]  bit_wait_io+0x16/0x60
[  663.226808]  __wait_on_bit+0x53/0x80
[  663.226810]  ? bit_wait+0x50/0x50
[  663.226811]  out_of_line_wait_on_bit+0x6e/0x80
[  663.226813]  ? prepare_to_wait_event+0x170/0x170
[  663.226816]  sync_mapping_buffers+0x22f/0x390
[  663.226818]  __generic_file_fsync+0x4d/0x90
[  663.226820]  ext4_sync_file+0x2b4/0x540
[  663.226822]  vfs_fsync_range+0x46/0xa0
[  663.226823]  dio_complete+0x181/0x1b0
[  663.226824]  dio_aio_complete_work+0x17/0x20
[  663.226826]  process_one_work+0x208/0x6a0
[  663.226827]  ? process_one_work+0x18d/0x6a0
[  663.226829]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226830]  worker_thread+0x49/0x4a0
[  663.226832]  kthread+0x107/0x140
[  663.226834]  ? process_one_work+0x6a0/0x6a0
[  663.226835]  ? kthread_create_on_node+0x40/0x40
[  663.226837]  ret_from_fork+0x2e/0x40
[  663.226838] kworker/10:14   D    0  9306      2 0x00000000
[  663.226841] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226842] Call Trace:
[  663.226844]  __schedule+0x2da/0xb00
[  663.226846]  schedule+0x38/0x90
[  663.226848]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226851]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226853]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226855]  ? trace_hardirqs_on+0xd/0x10
[  663.226857]  call_rwsem_down_write_failed+0x17/0x30
[  663.226859]  down_write+0x5a/0x70
[  663.226861]  ? __generic_file_fsync+0x43/0x90
[  663.226863]  __generic_file_fsync+0x43/0x90
[  663.226864]  ext4_sync_file+0x2b4/0x540
[  663.226866]  vfs_fsync_range+0x46/0xa0
[  663.226867]  dio_complete+0x181/0x1b0
[  663.226869]  dio_aio_complete_work+0x17/0x20
[  663.226870]  process_one_work+0x208/0x6a0
[  663.226872]  ? process_one_work+0x18d/0x6a0
[  663.226874]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226875]  worker_thread+0x49/0x4a0
[  663.226877]  kthread+0x107/0x140
[  663.226878]  ? process_one_work+0x6a0/0x6a0
[  663.226880]  ? kthread_create_on_node+0x40/0x40
[  663.226881]  ret_from_fork+0x2e/0x40
[  663.226883] kworker/10:15   D    0  9307      2 0x00000000
[  663.226885] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226886] Call Trace:
[  663.226888]  __schedule+0x2da/0xb00
[  663.226890]  schedule+0x38/0x90
[  663.226892]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226894]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226896]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226898]  call_rwsem_down_write_failed+0x17/0x30
[  663.226900]  down_write+0x5a/0x70
[  663.226901]  ? __generic_file_fsync+0x43/0x90
[  663.226903]  __generic_file_fsync+0x43/0x90
[  663.226905]  ext4_sync_file+0x2b4/0x540
[  663.226906]  vfs_fsync_range+0x46/0xa0
[  663.226907]  dio_complete+0x181/0x1b0
[  663.226909]  dio_aio_complete_work+0x17/0x20
[  663.226910]  process_one_work+0x208/0x6a0
[  663.226912]  ? process_one_work+0x18d/0x6a0
[  663.226914]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226916]  worker_thread+0x49/0x4a0
[  663.226917]  kthread+0x107/0x140
[  663.226918]  ? process_one_work+0x6a0/0x6a0
[  663.226920]  ? kthread_create_on_node+0x40/0x40
[  663.226921]  ret_from_fork+0x2e/0x40
[  663.226923] kworker/10:16   D    0  9308      2 0x00000000
[  663.226926] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226927] Call Trace:
[  663.226929]  __schedule+0x2da/0xb00
[  663.226931]  schedule+0x38/0x90
[  663.226933]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226935]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226937]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226939]  call_rwsem_down_write_failed+0x17/0x30
[  663.226941]  down_write+0x5a/0x70
[  663.226943]  ? __generic_file_fsync+0x43/0x90
[  663.226945]  __generic_file_fsync+0x43/0x90
[  663.226946]  ext4_sync_file+0x2b4/0x540
[  663.226948]  vfs_fsync_range+0x46/0xa0
[  663.226949]  dio_complete+0x181/0x1b0
[  663.226951]  dio_aio_complete_work+0x17/0x20
[  663.226952]  process_one_work+0x208/0x6a0
[  663.226954]  ? process_one_work+0x18d/0x6a0
[  663.226956]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.226957]  worker_thread+0x49/0x4a0
[  663.226959]  kthread+0x107/0x140
[  663.226960]  ? process_one_work+0x6a0/0x6a0
[  663.226962]  ? kthread_create_on_node+0x40/0x40
[  663.226964]  ret_from_fork+0x2e/0x40
[  663.226965] kworker/10:17   D    0  9309      2 0x00000000
[  663.226968] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.226969] Call Trace:
[  663.226971]  __schedule+0x2da/0xb00
[  663.226973]  schedule+0x38/0x90
[  663.226975]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.226978]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.226980]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.226982]  call_rwsem_down_write_failed+0x17/0x30
[  663.226984]  down_write+0x5a/0x70
[  663.226986]  ? __generic_file_fsync+0x43/0x90
[  663.226988]  __generic_file_fsync+0x43/0x90
[  663.226989]  ext4_sync_file+0x2b4/0x540
[  663.226992]  vfs_fsync_range+0x46/0xa0
[  663.226993]  dio_complete+0x181/0x1b0
[  663.226994]  dio_aio_complete_work+0x17/0x20
[  663.226995]  process_one_work+0x208/0x6a0
[  663.226996]  ? process_one_work+0x18d/0x6a0
[  663.226998]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227000]  worker_thread+0x49/0x4a0
[  663.227001]  kthread+0x107/0x140
[  663.227002]  ? process_one_work+0x6a0/0x6a0
[  663.227004]  ? kthread_create_on_node+0x40/0x40
[  663.227005]  ret_from_fork+0x2e/0x40
[  663.227007] kworker/10:18   D    0  9310      2 0x00000000
[  663.227010] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227011] Call Trace:
[  663.227013]  __schedule+0x2da/0xb00
[  663.227015]  schedule+0x38/0x90
[  663.227017]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227019]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227020]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227023]  call_rwsem_down_write_failed+0x17/0x30
[  663.227025]  down_write+0x5a/0x70
[  663.227027]  ? __generic_file_fsync+0x43/0x90
[  663.227028]  __generic_file_fsync+0x43/0x90
[  663.227031]  ext4_sync_file+0x2b4/0x540
[  663.227032]  vfs_fsync_range+0x46/0xa0
[  663.227034]  dio_complete+0x181/0x1b0
[  663.227035]  dio_aio_complete_work+0x17/0x20
[  663.227036]  process_one_work+0x208/0x6a0
[  663.227037]  ? process_one_work+0x18d/0x6a0
[  663.227039]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227041]  worker_thread+0x49/0x4a0
[  663.227043]  kthread+0x107/0x140
[  663.227044]  ? process_one_work+0x6a0/0x6a0
[  663.227046]  ? kthread_create_on_node+0x40/0x40
[  663.227047]  ret_from_fork+0x2e/0x40
[  663.227049] kworker/10:19   D    0  9311      2 0x00000000
[  663.227052] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227053] Call Trace:
[  663.227055]  __schedule+0x2da/0xb00
[  663.227057]  schedule+0x38/0x90
[  663.227059]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227061]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227063]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227066]  call_rwsem_down_write_failed+0x17/0x30
[  663.227068]  down_write+0x5a/0x70
[  663.227070]  ? __generic_file_fsync+0x43/0x90
[  663.227072]  __generic_file_fsync+0x43/0x90
[  663.227074]  ext4_sync_file+0x2b4/0x540
[  663.227075]  vfs_fsync_range+0x46/0xa0
[  663.227077]  dio_complete+0x181/0x1b0
[  663.227078]  dio_aio_complete_work+0x17/0x20
[  663.227079]  process_one_work+0x208/0x6a0
[  663.227080]  ? process_one_work+0x18d/0x6a0
[  663.227082]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227083]  worker_thread+0x49/0x4a0
[  663.227085]  kthread+0x107/0x140
[  663.227087]  ? process_one_work+0x6a0/0x6a0
[  663.227088]  ? kthread_create_on_node+0x40/0x40
[  663.227090]  ret_from_fork+0x2e/0x40
[  663.227092] kworker/10:20   D    0  9312      2 0x00000000
[  663.227094] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227095] Call Trace:
[  663.227098]  __schedule+0x2da/0xb00
[  663.227099]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.227101]  schedule+0x38/0x90
[  663.227103]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227105]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227106]  ? trace_hardirqs_on+0xd/0x10
[  663.227108]  call_rwsem_down_write_failed+0x17/0x30
[  663.227111]  down_write+0x5a/0x70
[  663.227112]  ? __generic_file_fsync+0x43/0x90
[  663.227114]  __generic_file_fsync+0x43/0x90
[  663.227115]  ext4_sync_file+0x2b4/0x540
[  663.227117]  vfs_fsync_range+0x46/0xa0
[  663.227118]  dio_complete+0x181/0x1b0
[  663.227119]  dio_aio_complete_work+0x17/0x20
[  663.227121]  process_one_work+0x208/0x6a0
[  663.227122]  ? process_one_work+0x18d/0x6a0
[  663.227123]  worker_thread+0x49/0x4a0
[  663.227125]  kthread+0x107/0x140
[  663.227126]  ? process_one_work+0x6a0/0x6a0
[  663.227128]  ? kthread_create_on_node+0x40/0x40
[  663.227129]  ret_from_fork+0x2e/0x40
[  663.227131] kworker/10:21   D    0  9313      2 0x00000000
[  663.227134] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227135] Call Trace:
[  663.227137]  __schedule+0x2da/0xb00
[  663.227139]  schedule+0x38/0x90
[  663.227141]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227143]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227145]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227147]  call_rwsem_down_write_failed+0x17/0x30
[  663.227149]  down_write+0x5a/0x70
[  663.227151]  ? __generic_file_fsync+0x43/0x90
[  663.227153]  __generic_file_fsync+0x43/0x90
[  663.227155]  ext4_sync_file+0x2b4/0x540
[  663.227156]  vfs_fsync_range+0x46/0xa0
[  663.227157]  dio_complete+0x181/0x1b0
[  663.227159]  dio_aio_complete_work+0x17/0x20
[  663.227160]  process_one_work+0x208/0x6a0
[  663.227161]  ? process_one_work+0x18d/0x6a0
[  663.227163]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227165]  worker_thread+0x49/0x4a0
[  663.227167]  kthread+0x107/0x140
[  663.227168]  ? process_one_work+0x6a0/0x6a0
[  663.227170]  ? kthread_create_on_node+0x40/0x40
[  663.227171]  ret_from_fork+0x2e/0x40
[  663.227173] kworker/10:22   D    0  9314      2 0x00000000
[  663.227176] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227177] Call Trace:
[  663.227179]  __schedule+0x2da/0xb00
[  663.227181]  schedule+0x38/0x90
[  663.227183]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227185]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227187]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227190]  call_rwsem_down_write_failed+0x17/0x30
[  663.227192]  down_write+0x5a/0x70
[  663.227194]  ? __generic_file_fsync+0x43/0x90
[  663.227195]  __generic_file_fsync+0x43/0x90
[  663.227197]  ext4_sync_file+0x2b4/0x540
[  663.227199]  vfs_fsync_range+0x46/0xa0
[  663.227200]  dio_complete+0x181/0x1b0
[  663.227202]  dio_aio_complete_work+0x17/0x20
[  663.227203]  process_one_work+0x208/0x6a0
[  663.227204]  ? process_one_work+0x18d/0x6a0
[  663.227206]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227207]  worker_thread+0x49/0x4a0
[  663.227209]  kthread+0x107/0x140
[  663.227210]  ? process_one_work+0x6a0/0x6a0
[  663.227212]  ? kthread_create_on_node+0x40/0x40
[  663.227213]  ret_from_fork+0x2e/0x40
[  663.227215] kworker/10:23   D    0  9315      2 0x00000000
[  663.227218] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227219] Call Trace:
[  663.227221]  __schedule+0x2da/0xb00
[  663.227223]  schedule+0x38/0x90
[  663.227225]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227226]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227228]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227231]  call_rwsem_down_write_failed+0x17/0x30
[  663.227233]  down_write+0x5a/0x70
[  663.227234]  ? __generic_file_fsync+0x43/0x90
[  663.227236]  __generic_file_fsync+0x43/0x90
[  663.227237]  ext4_sync_file+0x2b4/0x540
[  663.227239]  vfs_fsync_range+0x46/0xa0
[  663.227240]  dio_complete+0x181/0x1b0
[  663.227241]  dio_aio_complete_work+0x17/0x20
[  663.227242]  process_one_work+0x208/0x6a0
[  663.227243]  ? process_one_work+0x18d/0x6a0
[  663.227246]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227247]  worker_thread+0x49/0x4a0
[  663.227249]  kthread+0x107/0x140
[  663.227250]  ? process_one_work+0x6a0/0x6a0
[  663.227252]  ? kthread_create_on_node+0x40/0x40
[  663.227253]  ret_from_fork+0x2e/0x40
[  663.227255] kworker/10:24   D    0  9316      2 0x00000000
[  663.227257] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227258] Call Trace:
[  663.227260]  __schedule+0x2da/0xb00
[  663.227262]  schedule+0x38/0x90
[  663.227264]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227265]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227267]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227269]  ? trace_hardirqs_on+0xd/0x10
[  663.227271]  call_rwsem_down_write_failed+0x17/0x30
[  663.227273]  down_write+0x5a/0x70
[  663.227274]  ? __generic_file_fsync+0x43/0x90
[  663.227276]  __generic_file_fsync+0x43/0x90
[  663.227278]  ext4_sync_file+0x2b4/0x540
[  663.227280]  vfs_fsync_range+0x46/0xa0
[  663.227281]  dio_complete+0x181/0x1b0
[  663.227282]  dio_aio_complete_work+0x17/0x20
[  663.227284]  process_one_work+0x208/0x6a0
[  663.227285]  ? process_one_work+0x18d/0x6a0
[  663.227287]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227288]  worker_thread+0x49/0x4a0
[  663.227290]  kthread+0x107/0x140
[  663.227291]  ? process_one_work+0x6a0/0x6a0
[  663.227293]  ? kthread_create_on_node+0x40/0x40
[  663.227295]  ret_from_fork+0x2e/0x40
[  663.227296] kworker/10:25   D    0  9317      2 0x00000000
[  663.227299] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227300] Call Trace:
[  663.227302]  __schedule+0x2da/0xb00
[  663.227304]  schedule+0x38/0x90
[  663.227306]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227309]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227311]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227314]  call_rwsem_down_write_failed+0x17/0x30
[  663.227316]  down_write+0x5a/0x70
[  663.227318]  ? __generic_file_fsync+0x43/0x90
[  663.227320]  __generic_file_fsync+0x43/0x90
[  663.227321]  ext4_sync_file+0x2b4/0x540
[  663.227323]  vfs_fsync_range+0x46/0xa0
[  663.227324]  dio_complete+0x181/0x1b0
[  663.227326]  dio_aio_complete_work+0x17/0x20
[  663.227327]  process_one_work+0x208/0x6a0
[  663.227328]  ? process_one_work+0x18d/0x6a0
[  663.227330]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227332]  worker_thread+0x49/0x4a0
[  663.227334]  kthread+0x107/0x140
[  663.227335]  ? process_one_work+0x6a0/0x6a0
[  663.227337]  ? kthread_create_on_node+0x40/0x40
[  663.227338]  ret_from_fork+0x2e/0x40
[  663.227340] kworker/10:26   D    0  9318      2 0x00000000
[  663.227342] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227343] Call Trace:
[  663.227345]  __schedule+0x2da/0xb00
[  663.227347]  schedule+0x38/0x90
[  663.227349]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227351]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227353]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227356]  call_rwsem_down_write_failed+0x17/0x30
[  663.227358]  down_write+0x5a/0x70
[  663.227359]  ? __generic_file_fsync+0x43/0x90
[  663.227361]  __generic_file_fsync+0x43/0x90
[  663.227363]  ext4_sync_file+0x2b4/0x540
[  663.227365]  vfs_fsync_range+0x46/0xa0
[  663.227366]  dio_complete+0x181/0x1b0
[  663.227367]  dio_aio_complete_work+0x17/0x20
[  663.227368]  process_one_work+0x208/0x6a0
[  663.227369]  ? process_one_work+0x18d/0x6a0
[  663.227371]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227373]  worker_thread+0x49/0x4a0
[  663.227374]  kthread+0x107/0x140
[  663.227376]  ? process_one_work+0x6a0/0x6a0
[  663.227377]  ? kthread_create_on_node+0x40/0x40
[  663.227378]  ret_from_fork+0x2e/0x40
[  663.227380] kworker/10:27   D    0  9319      2 0x00000000
[  663.227383] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227383] Call Trace:
[  663.227385]  __schedule+0x2da/0xb00
[  663.227387]  schedule+0x38/0x90
[  663.227389]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227391]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227393]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227395]  call_rwsem_down_write_failed+0x17/0x30
[  663.227397]  down_write+0x5a/0x70
[  663.227400]  ? __generic_file_fsync+0x43/0x90
[  663.227401]  __generic_file_fsync+0x43/0x90
[  663.227403]  ext4_sync_file+0x2b4/0x540
[  663.227404]  vfs_fsync_range+0x46/0xa0
[  663.227406]  dio_complete+0x181/0x1b0
[  663.227407]  dio_aio_complete_work+0x17/0x20
[  663.227409]  process_one_work+0x208/0x6a0
[  663.227410]  ? process_one_work+0x18d/0x6a0
[  663.227412]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227414]  worker_thread+0x49/0x4a0
[  663.227416]  kthread+0x107/0x140
[  663.227417]  ? process_one_work+0x6a0/0x6a0
[  663.227419]  ? kthread_create_on_node+0x40/0x40
[  663.227420]  ret_from_fork+0x2e/0x40
[  663.227422] kworker/10:28   D    0  9320      2 0x00000000
[  663.227425] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227426] Call Trace:
[  663.227428]  __schedule+0x2da/0xb00
[  663.227430]  schedule+0x38/0x90
[  663.227432]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227435]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227437]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227440]  call_rwsem_down_write_failed+0x17/0x30
[  663.227442]  down_write+0x5a/0x70
[  663.227443]  ? __generic_file_fsync+0x43/0x90
[  663.227445]  __generic_file_fsync+0x43/0x90
[  663.227447]  ext4_sync_file+0x2b4/0x540
[  663.227448]  vfs_fsync_range+0x46/0xa0
[  663.227449]  dio_complete+0x181/0x1b0
[  663.227451]  dio_aio_complete_work+0x17/0x20
[  663.227452]  process_one_work+0x208/0x6a0
[  663.227454]  ? process_one_work+0x18d/0x6a0
[  663.227455]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227457]  worker_thread+0x49/0x4a0
[  663.227459]  kthread+0x107/0x140
[  663.227460]  ? process_one_work+0x6a0/0x6a0
[  663.227462]  ? kthread_create_on_node+0x40/0x40
[  663.227463]  ret_from_fork+0x2e/0x40
[  663.227466] kworker/10:29   D    0  9321      2 0x00000000
[  663.227468] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227469] Call Trace:
[  663.227471]  __schedule+0x2da/0xb00
[  663.227473]  schedule+0x38/0x90
[  663.227475]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227477]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227479]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227481]  call_rwsem_down_write_failed+0x17/0x30
[  663.227483]  down_write+0x5a/0x70
[  663.227485]  ? __generic_file_fsync+0x43/0x90
[  663.227486]  __generic_file_fsync+0x43/0x90
[  663.227488]  ext4_sync_file+0x2b4/0x540
[  663.227489]  vfs_fsync_range+0x46/0xa0
[  663.227490]  dio_complete+0x181/0x1b0
[  663.227492]  dio_aio_complete_work+0x17/0x20
[  663.227493]  process_one_work+0x208/0x6a0
[  663.227494]  ? process_one_work+0x18d/0x6a0
[  663.227496]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227497]  worker_thread+0x49/0x4a0
[  663.227499]  kthread+0x107/0x140
[  663.227501]  ? process_one_work+0x6a0/0x6a0
[  663.227502]  ? kthread_create_on_node+0x40/0x40
[  663.227504]  ret_from_fork+0x2e/0x40
[  663.227505] kworker/10:30   D    0  9322      2 0x00000000
[  663.227508] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227508] Call Trace:
[  663.227510]  __schedule+0x2da/0xb00
[  663.227512]  schedule+0x38/0x90
[  663.227514]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227516]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227518]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227520]  ? trace_hardirqs_on+0xd/0x10
[  663.227523]  call_rwsem_down_write_failed+0x17/0x30
[  663.227525]  down_write+0x5a/0x70
[  663.227527]  ? __generic_file_fsync+0x43/0x90
[  663.227528]  __generic_file_fsync+0x43/0x90
[  663.227530]  ext4_sync_file+0x2b4/0x540
[  663.227532]  vfs_fsync_range+0x46/0xa0
[  663.227533]  dio_complete+0x181/0x1b0
[  663.227535]  dio_aio_complete_work+0x17/0x20
[  663.227536]  process_one_work+0x208/0x6a0
[  663.227537]  ? process_one_work+0x18d/0x6a0
[  663.227539]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227540]  worker_thread+0x49/0x4a0
[  663.227542]  kthread+0x107/0x140
[  663.227544]  ? process_one_work+0x6a0/0x6a0
[  663.227545]  ? kthread_create_on_node+0x40/0x40
[  663.227547]  ret_from_fork+0x2e/0x40
[  663.227549] kworker/10:31   D    0  9323      2 0x00000000
[  663.227551] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227552] Call Trace:
[  663.227555]  __schedule+0x2da/0xb00
[  663.227556]  schedule+0x38/0x90
[  663.227559]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227561]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227563]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227565]  call_rwsem_down_write_failed+0x17/0x30
[  663.227568]  down_write+0x5a/0x70
[  663.227569]  ? __generic_file_fsync+0x43/0x90
[  663.227571]  __generic_file_fsync+0x43/0x90
[  663.227572]  ext4_sync_file+0x2b4/0x540
[  663.227574]  vfs_fsync_range+0x46/0xa0
[  663.227575]  dio_complete+0x181/0x1b0
[  663.227577]  dio_aio_complete_work+0x17/0x20
[  663.227578]  process_one_work+0x208/0x6a0
[  663.227579]  ? process_one_work+0x18d/0x6a0
[  663.227581]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227582]  worker_thread+0x49/0x4a0
[  663.227584]  kthread+0x107/0x140
[  663.227586]  ? process_one_work+0x6a0/0x6a0
[  663.227587]  ? kthread_create_on_node+0x40/0x40
[  663.227589]  ret_from_fork+0x2e/0x40
[  663.227591] kworker/10:32   D    0  9324      2 0x00000000
[  663.227593] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227594] Call Trace:
[  663.227596]  __schedule+0x2da/0xb00
[  663.227598]  schedule+0x38/0x90
[  663.227601]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227603]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227604]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227607]  call_rwsem_down_write_failed+0x17/0x30
[  663.227609]  down_write+0x5a/0x70
[  663.227610]  ? __generic_file_fsync+0x43/0x90
[  663.227612]  __generic_file_fsync+0x43/0x90
[  663.227614]  ext4_sync_file+0x2b4/0x540
[  663.227616]  vfs_fsync_range+0x46/0xa0
[  663.227617]  dio_complete+0x181/0x1b0
[  663.227618]  dio_aio_complete_work+0x17/0x20
[  663.227619]  process_one_work+0x208/0x6a0
[  663.227620]  ? process_one_work+0x18d/0x6a0
[  663.227622]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227624]  worker_thread+0x49/0x4a0
[  663.227625]  kthread+0x107/0x140
[  663.227626]  ? process_one_work+0x6a0/0x6a0
[  663.227628]  ? kthread_create_on_node+0x40/0x40
[  663.227629]  ret_from_fork+0x2e/0x40
[  663.227631] kworker/10:33   D    0  9325      2 0x00000000
[  663.227634] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227635] Call Trace:
[  663.227637]  __schedule+0x2da/0xb00
[  663.227639]  schedule+0x38/0x90
[  663.227641]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227643]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227645]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227647]  call_rwsem_down_write_failed+0x17/0x30
[  663.227649]  down_write+0x5a/0x70
[  663.227651]  ? __generic_file_fsync+0x43/0x90
[  663.227653]  __generic_file_fsync+0x43/0x90
[  663.227654]  ext4_sync_file+0x2b4/0x540
[  663.227656]  vfs_fsync_range+0x46/0xa0
[  663.227657]  dio_complete+0x181/0x1b0
[  663.227659]  dio_aio_complete_work+0x17/0x20
[  663.227660]  process_one_work+0x208/0x6a0
[  663.227661]  ? process_one_work+0x18d/0x6a0
[  663.227663]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227665]  worker_thread+0x49/0x4a0
[  663.227667]  kthread+0x107/0x140
[  663.227668]  ? process_one_work+0x6a0/0x6a0
[  663.227670]  ? kthread_create_on_node+0x40/0x40
[  663.227672]  ret_from_fork+0x2e/0x40
[  663.227673] kworker/10:34   D    0  9326      2 0x00000000
[  663.227676] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227677] Call Trace:
[  663.227679]  __schedule+0x2da/0xb00
[  663.227681]  schedule+0x38/0x90
[  663.227683]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227685]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227687]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227690]  call_rwsem_down_write_failed+0x17/0x30
[  663.227692]  down_write+0x5a/0x70
[  663.227693]  ? __generic_file_fsync+0x43/0x90
[  663.227695]  __generic_file_fsync+0x43/0x90
[  663.227697]  ext4_sync_file+0x2b4/0x540
[  663.227698]  vfs_fsync_range+0x46/0xa0
[  663.227700]  dio_complete+0x181/0x1b0
[  663.227701]  dio_aio_complete_work+0x17/0x20
[  663.227702]  process_one_work+0x208/0x6a0
[  663.227703]  ? process_one_work+0x18d/0x6a0
[  663.227705]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227707]  worker_thread+0x49/0x4a0
[  663.227709]  kthread+0x107/0x140
[  663.227710]  ? process_one_work+0x6a0/0x6a0
[  663.227711]  ? kthread_create_on_node+0x40/0x40
[  663.227713]  ret_from_fork+0x2e/0x40
[  663.227715] kworker/10:35   D    0  9327      2 0x00000000
[  663.227717] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227718] Call Trace:
[  663.227720]  __schedule+0x2da/0xb00
[  663.227722]  schedule+0x38/0x90
[  663.227724]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227726]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227728]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227730]  call_rwsem_down_write_failed+0x17/0x30
[  663.227733]  down_write+0x5a/0x70
[  663.227734]  ? __generic_file_fsync+0x43/0x90
[  663.227736]  __generic_file_fsync+0x43/0x90
[  663.227738]  ext4_sync_file+0x2b4/0x540
[  663.227739]  vfs_fsync_range+0x46/0xa0
[  663.227741]  dio_complete+0x181/0x1b0
[  663.227742]  dio_aio_complete_work+0x17/0x20
[  663.227743]  process_one_work+0x208/0x6a0
[  663.227745]  ? process_one_work+0x18d/0x6a0
[  663.227747]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227748]  worker_thread+0x49/0x4a0
[  663.227750]  kthread+0x107/0x140
[  663.227751]  ? process_one_work+0x6a0/0x6a0
[  663.227753]  ? kthread_create_on_node+0x40/0x40
[  663.227754]  ret_from_fork+0x2e/0x40
[  663.227756] kworker/10:36   D    0  9328      2 0x00000000
[  663.227759] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227760] Call Trace:
[  663.227762]  __schedule+0x2da/0xb00
[  663.227764]  schedule+0x38/0x90
[  663.227767]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227769]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227771]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227773]  call_rwsem_down_write_failed+0x17/0x30
[  663.227775]  down_write+0x5a/0x70
[  663.227777]  ? __generic_file_fsync+0x43/0x90
[  663.227779]  __generic_file_fsync+0x43/0x90
[  663.227780]  ext4_sync_file+0x2b4/0x540
[  663.227782]  vfs_fsync_range+0x46/0xa0
[  663.227783]  dio_complete+0x181/0x1b0
[  663.227785]  dio_aio_complete_work+0x17/0x20
[  663.227786]  process_one_work+0x208/0x6a0
[  663.227787]  ? process_one_work+0x18d/0x6a0
[  663.227789]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227790]  worker_thread+0x49/0x4a0
[  663.227792]  kthread+0x107/0x140
[  663.227794]  ? process_one_work+0x6a0/0x6a0
[  663.227795]  ? kthread_create_on_node+0x40/0x40
[  663.227797]  ret_from_fork+0x2e/0x40
[  663.227799] kworker/10:37   D    0  9329      2 0x00000000
[  663.227802] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227803] Call Trace:
[  663.227805]  __schedule+0x2da/0xb00
[  663.227807]  schedule+0x38/0x90
[  663.227809]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227810]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227812]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227815]  call_rwsem_down_write_failed+0x17/0x30
[  663.227817]  down_write+0x5a/0x70
[  663.227818]  ? __generic_file_fsync+0x43/0x90
[  663.227820]  __generic_file_fsync+0x43/0x90
[  663.227821]  ext4_sync_file+0x2b4/0x540
[  663.227823]  vfs_fsync_range+0x46/0xa0
[  663.227824]  dio_complete+0x181/0x1b0
[  663.227825]  dio_aio_complete_work+0x17/0x20
[  663.227826]  process_one_work+0x208/0x6a0
[  663.227828]  ? process_one_work+0x18d/0x6a0
[  663.227829]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227831]  worker_thread+0x49/0x4a0
[  663.227833]  kthread+0x107/0x140
[  663.227834]  ? process_one_work+0x6a0/0x6a0
[  663.227836]  ? kthread_create_on_node+0x40/0x40
[  663.227837]  ret_from_fork+0x2e/0x40
[  663.227838] kworker/10:38   D    0  9330      2 0x00000000
[  663.227841] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227842] Call Trace:
[  663.227844]  __schedule+0x2da/0xb00
[  663.227845]  schedule+0x38/0x90
[  663.227847]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227849]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227851]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227853]  call_rwsem_down_write_failed+0x17/0x30
[  663.227855]  down_write+0x5a/0x70
[  663.227857]  ? __generic_file_fsync+0x43/0x90
[  663.227858]  __generic_file_fsync+0x43/0x90
[  663.227860]  ext4_sync_file+0x2b4/0x540
[  663.227861]  vfs_fsync_range+0x46/0xa0
[  663.227863]  dio_complete+0x181/0x1b0
[  663.227864]  dio_aio_complete_work+0x17/0x20
[  663.227865]  process_one_work+0x208/0x6a0
[  663.227866]  ? process_one_work+0x18d/0x6a0
[  663.227868]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227869]  worker_thread+0x49/0x4a0
[  663.227871]  kthread+0x107/0x140
[  663.227872]  ? process_one_work+0x6a0/0x6a0
[  663.227874]  ? kthread_create_on_node+0x40/0x40
[  663.227876]  ret_from_fork+0x2e/0x40
[  663.227877] kworker/10:39   D    0  9331      2 0x00000000
[  663.227880] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227881] Call Trace:
[  663.227883]  __schedule+0x2da/0xb00
[  663.227885]  schedule+0x38/0x90
[  663.227887]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227889]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227891]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227894]  call_rwsem_down_write_failed+0x17/0x30
[  663.227896]  down_write+0x5a/0x70
[  663.227897]  ? __generic_file_fsync+0x43/0x90
[  663.227899]  __generic_file_fsync+0x43/0x90
[  663.227901]  ext4_sync_file+0x2b4/0x540
[  663.227902]  vfs_fsync_range+0x46/0xa0
[  663.227904]  dio_complete+0x181/0x1b0
[  663.227905]  dio_aio_complete_work+0x17/0x20
[  663.227907]  process_one_work+0x208/0x6a0
[  663.227908]  ? process_one_work+0x18d/0x6a0
[  663.227910]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227911]  worker_thread+0x49/0x4a0
[  663.227913]  kthread+0x107/0x140
[  663.227915]  ? process_one_work+0x6a0/0x6a0
[  663.227916]  ? kthread_create_on_node+0x40/0x40
[  663.227918]  ret_from_fork+0x2e/0x40
[  663.227920] kworker/10:40   D    0  9332      2 0x00000000
[  663.227922] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227923] Call Trace:
[  663.227925]  __schedule+0x2da/0xb00
[  663.227927]  schedule+0x38/0x90
[  663.227929]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227931]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227933]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227936]  call_rwsem_down_write_failed+0x17/0x30
[  663.227938]  down_write+0x5a/0x70
[  663.227939]  ? __generic_file_fsync+0x43/0x90
[  663.227941]  __generic_file_fsync+0x43/0x90
[  663.227942]  ext4_sync_file+0x2b4/0x540
[  663.227944]  vfs_fsync_range+0x46/0xa0
[  663.227945]  dio_complete+0x181/0x1b0
[  663.227947]  dio_aio_complete_work+0x17/0x20
[  663.227948]  process_one_work+0x208/0x6a0
[  663.227949]  ? process_one_work+0x18d/0x6a0
[  663.227951]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227953]  worker_thread+0x49/0x4a0
[  663.227954]  kthread+0x107/0x140
[  663.227956]  ? process_one_work+0x6a0/0x6a0
[  663.227957]  ? kthread_create_on_node+0x40/0x40
[  663.227959]  ret_from_fork+0x2e/0x40
[  663.227960] kworker/10:41   D    0  9333      2 0x00000000
[  663.227963] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.227964] Call Trace:
[  663.227966]  __schedule+0x2da/0xb00
[  663.227968]  schedule+0x38/0x90
[  663.227969]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.227971]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.227973]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.227976]  call_rwsem_down_write_failed+0x17/0x30
[  663.227978]  down_write+0x5a/0x70
[  663.227979]  ? __generic_file_fsync+0x43/0x90
[  663.227981]  __generic_file_fsync+0x43/0x90
[  663.227982]  ext4_sync_file+0x2b4/0x540
[  663.227983]  vfs_fsync_range+0x46/0xa0
[  663.227985]  dio_complete+0x181/0x1b0
[  663.227986]  dio_aio_complete_work+0x17/0x20
[  663.227987]  process_one_work+0x208/0x6a0
[  663.227988]  ? process_one_work+0x18d/0x6a0
[  663.227990]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.227991]  worker_thread+0x49/0x4a0
[  663.227993]  kthread+0x107/0x140
[  663.227994]  ? process_one_work+0x6a0/0x6a0
[  663.227996]  ? kthread_create_on_node+0x40/0x40
[  663.227997]  ret_from_fork+0x2e/0x40
[  663.227999] kworker/10:42   D    0  9334      2 0x00000000
[  663.228001] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228002] Call Trace:
[  663.228004]  __schedule+0x2da/0xb00
[  663.228006]  schedule+0x38/0x90
[  663.228008]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228011]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228013]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228015]  call_rwsem_down_write_failed+0x17/0x30
[  663.228017]  down_write+0x5a/0x70
[  663.228019]  ? __generic_file_fsync+0x43/0x90
[  663.228020]  __generic_file_fsync+0x43/0x90
[  663.228022]  ext4_sync_file+0x2b4/0x540
[  663.228024]  vfs_fsync_range+0x46/0xa0
[  663.228025]  dio_complete+0x181/0x1b0
[  663.228027]  dio_aio_complete_work+0x17/0x20
[  663.228028]  process_one_work+0x208/0x6a0
[  663.228029]  ? process_one_work+0x18d/0x6a0
[  663.228031]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228033]  worker_thread+0x49/0x4a0
[  663.228035]  kthread+0x107/0x140
[  663.228036]  ? process_one_work+0x6a0/0x6a0
[  663.228038]  ? kthread_create_on_node+0x40/0x40
[  663.228039]  ret_from_fork+0x2e/0x40
[  663.228042] kworker/10:43   D    0  9335      2 0x00000000
[  663.228044] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228045] Call Trace:
[  663.228048]  __schedule+0x2da/0xb00
[  663.228050]  schedule+0x38/0x90
[  663.228052]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228054]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228056]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228058]  call_rwsem_down_write_failed+0x17/0x30
[  663.228060]  down_write+0x5a/0x70
[  663.228062]  ? __generic_file_fsync+0x43/0x90
[  663.228064]  __generic_file_fsync+0x43/0x90
[  663.228065]  ext4_sync_file+0x2b4/0x540
[  663.228067]  vfs_fsync_range+0x46/0xa0
[  663.228068]  dio_complete+0x181/0x1b0
[  663.228069]  dio_aio_complete_work+0x17/0x20
[  663.228071]  process_one_work+0x208/0x6a0
[  663.228072]  ? process_one_work+0x18d/0x6a0
[  663.228074]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228075]  worker_thread+0x49/0x4a0
[  663.228077]  kthread+0x107/0x140
[  663.228079]  ? process_one_work+0x6a0/0x6a0
[  663.228081]  ? kthread_create_on_node+0x40/0x40
[  663.228082]  ret_from_fork+0x2e/0x40
[  663.228084] kworker/10:44   D    0  9336      2 0x00000000
[  663.228087] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228088] Call Trace:
[  663.228090]  __schedule+0x2da/0xb00
[  663.228092]  schedule+0x38/0x90
[  663.228093]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228095]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228097]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228100]  call_rwsem_down_write_failed+0x17/0x30
[  663.228101]  down_write+0x5a/0x70
[  663.228103]  ? __generic_file_fsync+0x43/0x90
[  663.228104]  __generic_file_fsync+0x43/0x90
[  663.228106]  ext4_sync_file+0x2b4/0x540
[  663.228108]  vfs_fsync_range+0x46/0xa0
[  663.228109]  dio_complete+0x181/0x1b0
[  663.228110]  dio_aio_complete_work+0x17/0x20
[  663.228112]  process_one_work+0x208/0x6a0
[  663.228114]  ? process_one_work+0x18d/0x6a0
[  663.228115]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228117]  worker_thread+0x49/0x4a0
[  663.228118]  kthread+0x107/0x140
[  663.228120]  ? process_one_work+0x6a0/0x6a0
[  663.228122]  ? kthread_create_on_node+0x40/0x40
[  663.228123]  ret_from_fork+0x2e/0x40
[  663.228125] kworker/10:45   D    0  9337      2 0x00000000
[  663.228127] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228128] Call Trace:
[  663.228130]  __schedule+0x2da/0xb00
[  663.228132]  schedule+0x38/0x90
[  663.228134]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228136]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228138]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228141]  call_rwsem_down_write_failed+0x17/0x30
[  663.228143]  down_write+0x5a/0x70
[  663.228145]  ? __generic_file_fsync+0x43/0x90
[  663.228146]  __generic_file_fsync+0x43/0x90
[  663.228148]  ext4_sync_file+0x2b4/0x540
[  663.228149]  vfs_fsync_range+0x46/0xa0
[  663.228151]  dio_complete+0x181/0x1b0
[  663.228152]  dio_aio_complete_work+0x17/0x20
[  663.228153]  process_one_work+0x208/0x6a0
[  663.228155]  ? process_one_work+0x18d/0x6a0
[  663.228157]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228158]  worker_thread+0x49/0x4a0
[  663.228160]  kthread+0x107/0x140
[  663.228162]  ? process_one_work+0x6a0/0x6a0
[  663.228164]  ? kthread_create_on_node+0x40/0x40
[  663.228166]  ? ___slab_alloc+0x4db/0x520
[  663.228168]  ? mempool_alloc_slab+0x10/0x20
[  663.228169]  ret_from_fork+0x2e/0x40
[  663.228171] kworker/10:46   D    0  9338      2 0x00000000
[  663.228174] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228175] Call Trace:
[  663.228177]  __schedule+0x2da/0xb00
[  663.228179]  schedule+0x38/0x90
[  663.228181]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228183]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228185]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228188]  call_rwsem_down_write_failed+0x17/0x30
[  663.228190]  down_write+0x5a/0x70
[  663.228192]  ? __generic_file_fsync+0x43/0x90
[  663.228193]  __generic_file_fsync+0x43/0x90
[  663.228195]  ext4_sync_file+0x2b4/0x540
[  663.228196]  vfs_fsync_range+0x46/0xa0
[  663.228198]  dio_complete+0x181/0x1b0
[  663.228199]  dio_aio_complete_work+0x17/0x20
[  663.228200]  process_one_work+0x208/0x6a0
[  663.228202]  ? process_one_work+0x18d/0x6a0
[  663.228204]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228206]  worker_thread+0x49/0x4a0
[  663.228207]  kthread+0x107/0x140
[  663.228208]  ? process_one_work+0x6a0/0x6a0
[  663.228210]  ? kthread_create_on_node+0x40/0x40
[  663.228212]  ? ___slab_alloc+0x4db/0x520
[  663.228214]  ? mempool_alloc_slab+0x10/0x20
[  663.228215]  ret_from_fork+0x2e/0x40
[  663.228217] kworker/10:47   D    0  9339      2 0x00000000
[  663.228219] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228220] Call Trace:
[  663.228222]  __schedule+0x2da/0xb00
[  663.228224]  schedule+0x38/0x90
[  663.228226]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228228]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228230]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228232]  call_rwsem_down_write_failed+0x17/0x30
[  663.228234]  down_write+0x5a/0x70
[  663.228236]  ? __generic_file_fsync+0x43/0x90
[  663.228238]  __generic_file_fsync+0x43/0x90
[  663.228239]  ext4_sync_file+0x2b4/0x540
[  663.228241]  vfs_fsync_range+0x46/0xa0
[  663.228243]  dio_complete+0x181/0x1b0
[  663.228244]  dio_aio_complete_work+0x17/0x20
[  663.228245]  process_one_work+0x208/0x6a0
[  663.228246]  ? process_one_work+0x18d/0x6a0
[  663.228248]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228249]  worker_thread+0x49/0x4a0
[  663.228251]  kthread+0x107/0x140
[  663.228253]  ? process_one_work+0x6a0/0x6a0
[  663.228254]  ? kthread_create_on_node+0x40/0x40
[  663.228256]  ret_from_fork+0x2e/0x40
[  663.228258] kworker/10:48   D    0  9340      2 0x00000000
[  663.228261] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228262] Call Trace:
[  663.228264]  __schedule+0x2da/0xb00
[  663.228266]  schedule+0x38/0x90
[  663.228268]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228270]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228272]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228274]  call_rwsem_down_write_failed+0x17/0x30
[  663.228276]  down_write+0x5a/0x70
[  663.228278]  ? __generic_file_fsync+0x43/0x90
[  663.228280]  __generic_file_fsync+0x43/0x90
[  663.228282]  ext4_sync_file+0x2b4/0x540
[  663.228283]  vfs_fsync_range+0x46/0xa0
[  663.228285]  dio_complete+0x181/0x1b0
[  663.228286]  dio_aio_complete_work+0x17/0x20
[  663.228287]  process_one_work+0x208/0x6a0
[  663.228289]  ? process_one_work+0x18d/0x6a0
[  663.228291]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228292]  worker_thread+0x49/0x4a0
[  663.228294]  kthread+0x107/0x140
[  663.228295]  ? process_one_work+0x6a0/0x6a0
[  663.228297]  ? kthread_create_on_node+0x40/0x40
[  663.228298]  ret_from_fork+0x2e/0x40
[  663.228300] kworker/10:49   D    0  9341      2 0x00000000
[  663.228303] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228304] Call Trace:
[  663.228306]  __schedule+0x2da/0xb00
[  663.228308]  schedule+0x38/0x90
[  663.228310]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228312]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228313]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228316]  call_rwsem_down_write_failed+0x17/0x30
[  663.228318]  down_write+0x5a/0x70
[  663.228319]  ? __generic_file_fsync+0x43/0x90
[  663.228321]  __generic_file_fsync+0x43/0x90
[  663.228323]  ext4_sync_file+0x2b4/0x540
[  663.228324]  vfs_fsync_range+0x46/0xa0
[  663.228326]  dio_complete+0x181/0x1b0
[  663.228327]  dio_aio_complete_work+0x17/0x20
[  663.228328]  process_one_work+0x208/0x6a0
[  663.228329]  ? process_one_work+0x18d/0x6a0
[  663.228331]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228332]  worker_thread+0x49/0x4a0
[  663.228334]  kthread+0x107/0x140
[  663.228335]  ? process_one_work+0x6a0/0x6a0
[  663.228337]  ? kthread_create_on_node+0x40/0x40
[  663.228338]  ret_from_fork+0x2e/0x40
[  663.228340] kworker/10:50   D    0  9342      2 0x00000000
[  663.228342] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228343] Call Trace:
[  663.228345]  __schedule+0x2da/0xb00
[  663.228347]  schedule+0x38/0x90
[  663.228348]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228350]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228352]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228355]  call_rwsem_down_write_failed+0x17/0x30
[  663.228357]  down_write+0x5a/0x70
[  663.228359]  ? __generic_file_fsync+0x43/0x90
[  663.228360]  __generic_file_fsync+0x43/0x90
[  663.228362]  ext4_sync_file+0x2b4/0x540
[  663.228363]  vfs_fsync_range+0x46/0xa0
[  663.228364]  dio_complete+0x181/0x1b0
[  663.228366]  dio_aio_complete_work+0x17/0x20
[  663.228367]  process_one_work+0x208/0x6a0
[  663.228368]  ? process_one_work+0x18d/0x6a0
[  663.228370]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228372]  worker_thread+0x49/0x4a0
[  663.228373]  kthread+0x107/0x140
[  663.228375]  ? process_one_work+0x6a0/0x6a0
[  663.228376]  ? kthread_create_on_node+0x40/0x40
[  663.228378]  ret_from_fork+0x2e/0x40
[  663.228379] kworker/10:51   D    0  9343      2 0x00000000
[  663.228382] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228383] Call Trace:
[  663.228385]  __schedule+0x2da/0xb00
[  663.228387]  schedule+0x38/0x90
[  663.228390]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228392]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228394]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228396]  call_rwsem_down_write_failed+0x17/0x30
[  663.228399]  down_write+0x5a/0x70
[  663.228400]  ? __generic_file_fsync+0x43/0x90
[  663.228402]  __generic_file_fsync+0x43/0x90
[  663.228404]  ext4_sync_file+0x2b4/0x540
[  663.228405]  vfs_fsync_range+0x46/0xa0
[  663.228407]  dio_complete+0x181/0x1b0
[  663.228408]  dio_aio_complete_work+0x17/0x20
[  663.228410]  process_one_work+0x208/0x6a0
[  663.228411]  ? process_one_work+0x18d/0x6a0
[  663.228413]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228414]  worker_thread+0x49/0x4a0
[  663.228416]  kthread+0x107/0x140
[  663.228417]  ? process_one_work+0x6a0/0x6a0
[  663.228419]  ? kthread_create_on_node+0x40/0x40
[  663.228422]  ? kmem_cache_alloc+0x230/0x2c0
[  663.228424]  ? __slab_alloc+0x3e/0x70
[  663.228426]  ? ___slab_alloc+0x4db/0x520
[  663.228427]  ret_from_fork+0x2e/0x40
[  663.228429] kworker/10:52   D    0  9344      2 0x00000000
[  663.228432] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228433] Call Trace:
[  663.228435]  __schedule+0x2da/0xb00
[  663.228436]  schedule+0x38/0x90
[  663.228438]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228440]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228442]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228445]  call_rwsem_down_write_failed+0x17/0x30
[  663.228447]  down_write+0x5a/0x70
[  663.228449]  ? __generic_file_fsync+0x43/0x90
[  663.228450]  __generic_file_fsync+0x43/0x90
[  663.228452]  ext4_sync_file+0x2b4/0x540
[  663.228454]  vfs_fsync_range+0x46/0xa0
[  663.228455]  dio_complete+0x181/0x1b0
[  663.228456]  dio_aio_complete_work+0x17/0x20
[  663.228458]  process_one_work+0x208/0x6a0
[  663.228459]  ? process_one_work+0x18d/0x6a0
[  663.228460]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228462]  worker_thread+0x49/0x4a0
[  663.228464]  kthread+0x107/0x140
[  663.228465]  ? process_one_work+0x6a0/0x6a0
[  663.228466]  ? kthread_create_on_node+0x40/0x40
[  663.228468]  ? ___slab_alloc+0x4db/0x520
[  663.228470]  ? mempool_alloc_slab+0x10/0x20
[  663.228471]  ret_from_fork+0x2e/0x40
[  663.228473] kworker/10:53   D    0  9345      2 0x00000000
[  663.228475] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228476] Call Trace:
[  663.228478]  __schedule+0x2da/0xb00
[  663.228480]  schedule+0x38/0x90
[  663.228482]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228484]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228486]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228488]  ? trace_hardirqs_on+0xd/0x10
[  663.228491]  call_rwsem_down_write_failed+0x17/0x30
[  663.228493]  down_write+0x5a/0x70
[  663.228495]  ? __generic_file_fsync+0x43/0x90
[  663.228497]  __generic_file_fsync+0x43/0x90
[  663.228498]  ext4_sync_file+0x2b4/0x540
[  663.228500]  vfs_fsync_range+0x46/0xa0
[  663.228501]  dio_complete+0x181/0x1b0
[  663.228503]  dio_aio_complete_work+0x17/0x20
[  663.228504]  process_one_work+0x208/0x6a0
[  663.228505]  ? process_one_work+0x18d/0x6a0
[  663.228507]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228508]  worker_thread+0x49/0x4a0
[  663.228510]  kthread+0x107/0x140
[  663.228511]  ? process_one_work+0x6a0/0x6a0
[  663.228513]  ? kthread_create_on_node+0x40/0x40
[  663.228515]  ret_from_fork+0x2e/0x40
[  663.228517] kworker/10:54   D    0  9346      2 0x00000000
[  663.228520] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228521] Call Trace:
[  663.228523]  __schedule+0x2da/0xb00
[  663.228525]  schedule+0x38/0x90
[  663.228527]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228529]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228531]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228533]  ? trace_hardirqs_on+0xd/0x10
[  663.228535]  call_rwsem_down_write_failed+0x17/0x30
[  663.228537]  down_write+0x5a/0x70
[  663.228539]  ? __generic_file_fsync+0x43/0x90
[  663.228540]  __generic_file_fsync+0x43/0x90
[  663.228542]  ext4_sync_file+0x2b4/0x540
[  663.228544]  vfs_fsync_range+0x46/0xa0
[  663.228545]  dio_complete+0x181/0x1b0
[  663.228546]  dio_aio_complete_work+0x17/0x20
[  663.228548]  process_one_work+0x208/0x6a0
[  663.228549]  ? process_one_work+0x18d/0x6a0
[  663.228551]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228552]  worker_thread+0x49/0x4a0
[  663.228554]  kthread+0x107/0x140
[  663.228555]  ? process_one_work+0x6a0/0x6a0
[  663.228557]  ? kthread_create_on_node+0x40/0x40
[  663.228559]  ret_from_fork+0x2e/0x40
[  663.228561] kworker/10:55   D    0  9347      2 0x00000000
[  663.228564] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228565] Call Trace:
[  663.228567]  __schedule+0x2da/0xb00
[  663.228568]  schedule+0x38/0x90
[  663.228570]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228572]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228574]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228576]  call_rwsem_down_write_failed+0x17/0x30
[  663.228578]  down_write+0x5a/0x70
[  663.228580]  ? __generic_file_fsync+0x43/0x90
[  663.228581]  __generic_file_fsync+0x43/0x90
[  663.228583]  ext4_sync_file+0x2b4/0x540
[  663.228584]  vfs_fsync_range+0x46/0xa0
[  663.228586]  dio_complete+0x181/0x1b0
[  663.228587]  dio_aio_complete_work+0x17/0x20
[  663.228589]  process_one_work+0x208/0x6a0
[  663.228590]  ? process_one_work+0x18d/0x6a0
[  663.228592]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228593]  worker_thread+0x49/0x4a0
[  663.228595]  kthread+0x107/0x140
[  663.228597]  ? process_one_work+0x6a0/0x6a0
[  663.228598]  ? kthread_create_on_node+0x40/0x40
[  663.228600]  ret_from_fork+0x2e/0x40
[  663.228602] kworker/10:56   D    0  9348      2 0x00000000
[  663.228604] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228605] Call Trace:
[  663.228607]  __schedule+0x2da/0xb00
[  663.228609]  schedule+0x38/0x90
[  663.228611]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228613]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228615]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228617]  call_rwsem_down_write_failed+0x17/0x30
[  663.228619]  down_write+0x5a/0x70
[  663.228621]  ? __generic_file_fsync+0x43/0x90
[  663.228623]  __generic_file_fsync+0x43/0x90
[  663.228625]  ext4_sync_file+0x2b4/0x540
[  663.228626]  vfs_fsync_range+0x46/0xa0
[  663.228627]  dio_complete+0x181/0x1b0
[  663.228629]  dio_aio_complete_work+0x17/0x20
[  663.228630]  process_one_work+0x208/0x6a0
[  663.228632]  ? process_one_work+0x18d/0x6a0
[  663.228633]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228635]  worker_thread+0x49/0x4a0
[  663.228637]  kthread+0x107/0x140
[  663.228638]  ? process_one_work+0x6a0/0x6a0
[  663.228640]  ? kthread_create_on_node+0x40/0x40
[  663.228641]  ret_from_fork+0x2e/0x40
[  663.228643] kworker/10:57   D    0  9349      2 0x00000000
[  663.228645] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228647] Call Trace:
[  663.228649]  __schedule+0x2da/0xb00
[  663.228651]  schedule+0x38/0x90
[  663.228653]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228655]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228657]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228660]  call_rwsem_down_write_failed+0x17/0x30
[  663.228662]  down_write+0x5a/0x70
[  663.228663]  ? __generic_file_fsync+0x43/0x90
[  663.228665]  __generic_file_fsync+0x43/0x90
[  663.228666]  ext4_sync_file+0x2b4/0x540
[  663.228668]  vfs_fsync_range+0x46/0xa0
[  663.228669]  dio_complete+0x181/0x1b0
[  663.228670]  dio_aio_complete_work+0x17/0x20
[  663.228671]  process_one_work+0x208/0x6a0
[  663.228672]  ? process_one_work+0x18d/0x6a0
[  663.228674]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228675]  worker_thread+0x49/0x4a0
[  663.228677]  kthread+0x107/0x140
[  663.228678]  ? process_one_work+0x6a0/0x6a0
[  663.228680]  ? kthread_create_on_node+0x40/0x40
[  663.228681]  ret_from_fork+0x2e/0x40
[  663.228683] kworker/10:58   D    0  9350      2 0x00000000
[  663.228686] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228687] Call Trace:
[  663.228689]  __schedule+0x2da/0xb00
[  663.228690]  schedule+0x38/0x90
[  663.228692]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228694]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228696]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228698]  call_rwsem_down_write_failed+0x17/0x30
[  663.228701]  down_write+0x5a/0x70
[  663.228702]  ? __generic_file_fsync+0x43/0x90
[  663.228704]  __generic_file_fsync+0x43/0x90
[  663.228706]  ext4_sync_file+0x2b4/0x540
[  663.228707]  vfs_fsync_range+0x46/0xa0
[  663.228709]  dio_complete+0x181/0x1b0
[  663.228710]  dio_aio_complete_work+0x17/0x20
[  663.228711]  process_one_work+0x208/0x6a0
[  663.228712]  ? process_one_work+0x18d/0x6a0
[  663.228714]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228716]  worker_thread+0x49/0x4a0
[  663.228718]  kthread+0x107/0x140
[  663.228719]  ? process_one_work+0x6a0/0x6a0
[  663.228721]  ? kthread_create_on_node+0x40/0x40
[  663.228722]  ret_from_fork+0x2e/0x40
[  663.228724] kworker/10:59   D    0  9351      2 0x00000000
[  663.228727] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228728] Call Trace:
[  663.228730]  __schedule+0x2da/0xb00
[  663.228732]  schedule+0x38/0x90
[  663.228734]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228736]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228738]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228740]  call_rwsem_down_write_failed+0x17/0x30
[  663.228742]  down_write+0x5a/0x70
[  663.228744]  ? __generic_file_fsync+0x43/0x90
[  663.228746]  __generic_file_fsync+0x43/0x90
[  663.228748]  ext4_sync_file+0x2b4/0x540
[  663.228750]  vfs_fsync_range+0x46/0xa0
[  663.228751]  dio_complete+0x181/0x1b0
[  663.228752]  dio_aio_complete_work+0x17/0x20
[  663.228754]  process_one_work+0x208/0x6a0
[  663.228755]  ? process_one_work+0x18d/0x6a0
[  663.228757]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228758]  worker_thread+0x49/0x4a0
[  663.228760]  kthread+0x107/0x140
[  663.228761]  ? process_one_work+0x6a0/0x6a0
[  663.228763]  ? kthread_create_on_node+0x40/0x40
[  663.228764]  ret_from_fork+0x2e/0x40
[  663.228766] kworker/10:60   D    0  9352      2 0x00000000
[  663.228769] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228770] Call Trace:
[  663.228772]  __schedule+0x2da/0xb00
[  663.228774]  schedule+0x38/0x90
[  663.228776]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228778]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228780]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228782]  call_rwsem_down_write_failed+0x17/0x30
[  663.228784]  down_write+0x5a/0x70
[  663.228786]  ? __generic_file_fsync+0x43/0x90
[  663.228788]  __generic_file_fsync+0x43/0x90
[  663.228790]  ext4_sync_file+0x2b4/0x540
[  663.228791]  vfs_fsync_range+0x46/0xa0
[  663.228792]  dio_complete+0x181/0x1b0
[  663.228794]  dio_aio_complete_work+0x17/0x20
[  663.228795]  process_one_work+0x208/0x6a0
[  663.228796]  ? process_one_work+0x18d/0x6a0
[  663.228798]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228799]  worker_thread+0x49/0x4a0
[  663.228801]  kthread+0x107/0x140
[  663.228802]  ? process_one_work+0x6a0/0x6a0
[  663.228804]  ? kthread_create_on_node+0x40/0x40
[  663.228805]  ret_from_fork+0x2e/0x40
[  663.228806] kworker/10:61   D    0  9353      2 0x00000000
[  663.228809] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228811] Call Trace:
[  663.228813]  __schedule+0x2da/0xb00
[  663.228814]  schedule+0x38/0x90
[  663.228816]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228818]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228820]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228823]  call_rwsem_down_write_failed+0x17/0x30
[  663.228825]  down_write+0x5a/0x70
[  663.228826]  ? __generic_file_fsync+0x43/0x90
[  663.228828]  __generic_file_fsync+0x43/0x90
[  663.228830]  ext4_sync_file+0x2b4/0x540
[  663.228831]  vfs_fsync_range+0x46/0xa0
[  663.228832]  dio_complete+0x181/0x1b0
[  663.228834]  dio_aio_complete_work+0x17/0x20
[  663.228835]  process_one_work+0x208/0x6a0
[  663.228836]  ? process_one_work+0x18d/0x6a0
[  663.228838]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228840]  worker_thread+0x49/0x4a0
[  663.228842]  kthread+0x107/0x140
[  663.228843]  ? process_one_work+0x6a0/0x6a0
[  663.228845]  ? kthread_create_on_node+0x40/0x40
[  663.228847]  ret_from_fork+0x2e/0x40
[  663.228848] kworker/10:62   D    0  9354      2 0x00000000
[  663.228851] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228852] Call Trace:
[  663.228854]  __schedule+0x2da/0xb00
[  663.228856]  schedule+0x38/0x90
[  663.228858]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228860]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228862]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228865]  call_rwsem_down_write_failed+0x17/0x30
[  663.228867]  down_write+0x5a/0x70
[  663.228868]  ? __generic_file_fsync+0x43/0x90
[  663.228870]  __generic_file_fsync+0x43/0x90
[  663.228872]  ext4_sync_file+0x2b4/0x540
[  663.228873]  vfs_fsync_range+0x46/0xa0
[  663.228876]  dio_complete+0x181/0x1b0
[  663.228877]  dio_aio_complete_work+0x17/0x20
[  663.228879]  process_one_work+0x208/0x6a0
[  663.228880]  ? process_one_work+0x18d/0x6a0
[  663.228882]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228883]  worker_thread+0x49/0x4a0
[  663.228885]  kthread+0x107/0x140
[  663.228886]  ? process_one_work+0x6a0/0x6a0
[  663.228888]  ? kthread_create_on_node+0x40/0x40
[  663.228889]  ret_from_fork+0x2e/0x40
[  663.228891] kworker/10:63   D    0  9355      2 0x00000000
[  663.228893] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228894] Call Trace:
[  663.228896]  __schedule+0x2da/0xb00
[  663.228898]  schedule+0x38/0x90
[  663.228900]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228902]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228904]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228905]  ? trace_hardirqs_on+0xd/0x10
[  663.228907]  call_rwsem_down_write_failed+0x17/0x30
[  663.228909]  down_write+0x5a/0x70
[  663.228911]  ? __generic_file_fsync+0x43/0x90
[  663.228913]  __generic_file_fsync+0x43/0x90
[  663.228914]  ext4_sync_file+0x2b4/0x540
[  663.228916]  vfs_fsync_range+0x46/0xa0
[  663.228917]  dio_complete+0x181/0x1b0
[  663.228918]  dio_aio_complete_work+0x17/0x20
[  663.228920]  process_one_work+0x208/0x6a0
[  663.228921]  ? process_one_work+0x18d/0x6a0
[  663.228923]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228924]  worker_thread+0x49/0x4a0
[  663.228926]  kthread+0x107/0x140
[  663.228927]  ? process_one_work+0x6a0/0x6a0
[  663.228929]  ? kthread_create_on_node+0x40/0x40
[  663.228931]  ret_from_fork+0x2e/0x40
[  663.228933] kworker/10:64   D    0  9356      2 0x00000000
[  663.228935] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228936] Call Trace:
[  663.228938]  __schedule+0x2da/0xb00
[  663.228940]  schedule+0x38/0x90
[  663.228943]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228945]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228947]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228949]  call_rwsem_down_write_failed+0x17/0x30
[  663.228951]  down_write+0x5a/0x70
[  663.228953]  ? __generic_file_fsync+0x43/0x90
[  663.228955]  __generic_file_fsync+0x43/0x90
[  663.228956]  ext4_sync_file+0x2b4/0x540
[  663.228958]  vfs_fsync_range+0x46/0xa0
[  663.228959]  dio_complete+0x181/0x1b0
[  663.228961]  dio_aio_complete_work+0x17/0x20
[  663.228962]  process_one_work+0x208/0x6a0
[  663.228963]  ? process_one_work+0x18d/0x6a0
[  663.228965]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.228967]  worker_thread+0x49/0x4a0
[  663.228969]  kthread+0x107/0x140
[  663.228970]  ? process_one_work+0x6a0/0x6a0
[  663.228972]  ? kthread_create_on_node+0x40/0x40
[  663.228974]  ret_from_fork+0x2e/0x40
[  663.228976] kworker/10:65   D    0  9357      2 0x00000000
[  663.228978] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.228979] Call Trace:
[  663.228981]  __schedule+0x2da/0xb00
[  663.228983]  schedule+0x38/0x90
[  663.228985]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.228987]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.228989]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.228992]  call_rwsem_down_write_failed+0x17/0x30
[  663.228994]  down_write+0x5a/0x70
[  663.228995]  ? __generic_file_fsync+0x43/0x90
[  663.228997]  __generic_file_fsync+0x43/0x90
[  663.228998]  ext4_sync_file+0x2b4/0x540
[  663.229000]  vfs_fsync_range+0x46/0xa0
[  663.229001]  dio_complete+0x181/0x1b0
[  663.229002]  dio_aio_complete_work+0x17/0x20
[  663.229003]  process_one_work+0x208/0x6a0
[  663.229004]  ? process_one_work+0x18d/0x6a0
[  663.229007]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229008]  worker_thread+0x49/0x4a0
[  663.229010]  kthread+0x107/0x140
[  663.229011]  ? process_one_work+0x6a0/0x6a0
[  663.229013]  ? kthread_create_on_node+0x40/0x40
[  663.229014]  ret_from_fork+0x2e/0x40
[  663.229016] kworker/10:66   D    0  9358      2 0x00000000
[  663.229018] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229019] Call Trace:
[  663.229021]  __schedule+0x2da/0xb00
[  663.229023]  schedule+0x38/0x90
[  663.229025]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229027]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229029]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229032]  call_rwsem_down_write_failed+0x17/0x30
[  663.229034]  down_write+0x5a/0x70
[  663.229036]  ? __generic_file_fsync+0x43/0x90
[  663.229038]  __generic_file_fsync+0x43/0x90
[  663.229040]  ext4_sync_file+0x2b4/0x540
[  663.229041]  vfs_fsync_range+0x46/0xa0
[  663.229043]  dio_complete+0x181/0x1b0
[  663.229044]  dio_aio_complete_work+0x17/0x20
[  663.229045]  process_one_work+0x208/0x6a0
[  663.229047]  ? process_one_work+0x18d/0x6a0
[  663.229049]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229050]  worker_thread+0x49/0x4a0
[  663.229052]  kthread+0x107/0x140
[  663.229053]  ? process_one_work+0x6a0/0x6a0
[  663.229055]  ? kthread_create_on_node+0x40/0x40
[  663.229057]  ret_from_fork+0x2e/0x40
[  663.229058] kworker/10:67   D    0  9359      2 0x00000000
[  663.229061] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229062] Call Trace:
[  663.229064]  __schedule+0x2da/0xb00
[  663.229066]  schedule+0x38/0x90
[  663.229068]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229070]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229072]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229074]  ? trace_hardirqs_on+0xd/0x10
[  663.229076]  call_rwsem_down_write_failed+0x17/0x30
[  663.229079]  down_write+0x5a/0x70
[  663.229081]  ? __generic_file_fsync+0x43/0x90
[  663.229083]  __generic_file_fsync+0x43/0x90
[  663.229085]  ext4_sync_file+0x2b4/0x540
[  663.229086]  vfs_fsync_range+0x46/0xa0
[  663.229087]  dio_complete+0x181/0x1b0
[  663.229089]  dio_aio_complete_work+0x17/0x20
[  663.229090]  process_one_work+0x208/0x6a0
[  663.229092]  ? process_one_work+0x18d/0x6a0
[  663.229094]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229095]  worker_thread+0x49/0x4a0
[  663.229097]  kthread+0x107/0x140
[  663.229098]  ? process_one_work+0x6a0/0x6a0
[  663.229099]  ? kthread_create_on_node+0x40/0x40
[  663.229101]  ret_from_fork+0x2e/0x40
[  663.229103] kworker/10:68   D    0  9360      2 0x00000000
[  663.229105] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229106] Call Trace:
[  663.229108]  __schedule+0x2da/0xb00
[  663.229110]  schedule+0x38/0x90
[  663.229112]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229113]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229115]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229118]  call_rwsem_down_write_failed+0x17/0x30
[  663.229120]  down_write+0x5a/0x70
[  663.229121]  ? __generic_file_fsync+0x43/0x90
[  663.229123]  __generic_file_fsync+0x43/0x90
[  663.229124]  ext4_sync_file+0x2b4/0x540
[  663.229126]  vfs_fsync_range+0x46/0xa0
[  663.229127]  dio_complete+0x181/0x1b0
[  663.229128]  dio_aio_complete_work+0x17/0x20
[  663.229130]  process_one_work+0x208/0x6a0
[  663.229131]  ? process_one_work+0x18d/0x6a0
[  663.229132]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229134]  worker_thread+0x49/0x4a0
[  663.229136]  kthread+0x107/0x140
[  663.229137]  ? process_one_work+0x6a0/0x6a0
[  663.229138]  ? kthread_create_on_node+0x40/0x40
[  663.229140]  ret_from_fork+0x2e/0x40
[  663.229141] kworker/10:69   D    0  9361      2 0x00000000
[  663.229144] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229145] Call Trace:
[  663.229147]  __schedule+0x2da/0xb00
[  663.229148]  schedule+0x38/0x90
[  663.229150]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229152]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229154]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229156]  ? trace_hardirqs_on+0xd/0x10
[  663.229158]  call_rwsem_down_write_failed+0x17/0x30
[  663.229161]  down_write+0x5a/0x70
[  663.229163]  ? __generic_file_fsync+0x43/0x90
[  663.229164]  __generic_file_fsync+0x43/0x90
[  663.229166]  ext4_sync_file+0x2b4/0x540
[  663.229167]  vfs_fsync_range+0x46/0xa0
[  663.229169]  dio_complete+0x181/0x1b0
[  663.229170]  dio_aio_complete_work+0x17/0x20
[  663.229172]  process_one_work+0x208/0x6a0
[  663.229173]  ? process_one_work+0x18d/0x6a0
[  663.229175]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229176]  worker_thread+0x49/0x4a0
[  663.229178]  kthread+0x107/0x140
[  663.229179]  ? process_one_work+0x6a0/0x6a0
[  663.229181]  ? kthread_create_on_node+0x40/0x40
[  663.229182]  ret_from_fork+0x2e/0x40
[  663.229184] kworker/10:70   D    0  9362      2 0x00000000
[  663.229187] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229188] Call Trace:
[  663.229190]  __schedule+0x2da/0xb00
[  663.229192]  schedule+0x38/0x90
[  663.229194]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229197]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229199]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229200]  ? trace_hardirqs_on+0xd/0x10
[  663.229202]  call_rwsem_down_write_failed+0x17/0x30
[  663.229205]  down_write+0x5a/0x70
[  663.229206]  ? __generic_file_fsync+0x43/0x90
[  663.229208]  __generic_file_fsync+0x43/0x90
[  663.229210]  ext4_sync_file+0x2b4/0x540
[  663.229211]  vfs_fsync_range+0x46/0xa0
[  663.229213]  dio_complete+0x181/0x1b0
[  663.229214]  dio_aio_complete_work+0x17/0x20
[  663.229215]  process_one_work+0x208/0x6a0
[  663.229216]  ? process_one_work+0x18d/0x6a0
[  663.229218]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229219]  worker_thread+0x49/0x4a0
[  663.229221]  kthread+0x107/0x140
[  663.229223]  ? process_one_work+0x6a0/0x6a0
[  663.229224]  ? kthread_create_on_node+0x40/0x40
[  663.229225]  ret_from_fork+0x2e/0x40
[  663.229227] kworker/10:71   D    0  9363      2 0x00000000
[  663.229230] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229231] Call Trace:
[  663.229233]  __schedule+0x2da/0xb00
[  663.229235]  schedule+0x38/0x90
[  663.229237]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229239]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229241]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229243]  ? trace_hardirqs_on+0xd/0x10
[  663.229245]  call_rwsem_down_write_failed+0x17/0x30
[  663.229247]  down_write+0x5a/0x70
[  663.229248]  ? __generic_file_fsync+0x43/0x90
[  663.229250]  __generic_file_fsync+0x43/0x90
[  663.229251]  ext4_sync_file+0x2b4/0x540
[  663.229253]  vfs_fsync_range+0x46/0xa0
[  663.229254]  dio_complete+0x181/0x1b0
[  663.229256]  dio_aio_complete_work+0x17/0x20
[  663.229257]  process_one_work+0x208/0x6a0
[  663.229259]  ? process_one_work+0x18d/0x6a0
[  663.229260]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229262]  worker_thread+0x49/0x4a0
[  663.229264]  kthread+0x107/0x140
[  663.229265]  ? process_one_work+0x6a0/0x6a0
[  663.229266]  ? kthread_create_on_node+0x40/0x40
[  663.229268]  ret_from_fork+0x2e/0x40
[  663.229269] kworker/10:72   D    0  9364      2 0x00000000
[  663.229272] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229273] Call Trace:
[  663.229275]  __schedule+0x2da/0xb00
[  663.229277]  schedule+0x38/0x90
[  663.229279]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229281]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229283]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229285]  ? trace_hardirqs_on+0xd/0x10
[  663.229287]  call_rwsem_down_write_failed+0x17/0x30
[  663.229289]  down_write+0x5a/0x70
[  663.229291]  ? __generic_file_fsync+0x43/0x90
[  663.229292]  __generic_file_fsync+0x43/0x90
[  663.229294]  ext4_sync_file+0x2b4/0x540
[  663.229296]  vfs_fsync_range+0x46/0xa0
[  663.229297]  dio_complete+0x181/0x1b0
[  663.229298]  dio_aio_complete_work+0x17/0x20
[  663.229299]  process_one_work+0x208/0x6a0
[  663.229301]  ? process_one_work+0x18d/0x6a0
[  663.229303]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229304]  worker_thread+0x49/0x4a0
[  663.229306]  kthread+0x107/0x140
[  663.229308]  ? process_one_work+0x6a0/0x6a0
[  663.229310]  ? kthread_create_on_node+0x40/0x40
[  663.229311]  ret_from_fork+0x2e/0x40
[  663.229313] kworker/10:73   D    0  9365      2 0x00000000
[  663.229316] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229317] Call Trace:
[  663.229319]  __schedule+0x2da/0xb00
[  663.229321]  schedule+0x38/0x90
[  663.229323]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229325]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229327]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229328]  ? trace_hardirqs_on+0xd/0x10
[  663.229330]  call_rwsem_down_write_failed+0x17/0x30
[  663.229333]  down_write+0x5a/0x70
[  663.229334]  ? __generic_file_fsync+0x43/0x90
[  663.229336]  __generic_file_fsync+0x43/0x90
[  663.229338]  ext4_sync_file+0x2b4/0x540
[  663.229340]  vfs_fsync_range+0x46/0xa0
[  663.229341]  dio_complete+0x181/0x1b0
[  663.229342]  dio_aio_complete_work+0x17/0x20
[  663.229343]  process_one_work+0x208/0x6a0
[  663.229345]  ? process_one_work+0x18d/0x6a0
[  663.229347]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229348]  worker_thread+0x49/0x4a0
[  663.229350]  kthread+0x107/0x140
[  663.229353]  ? process_one_work+0x6a0/0x6a0
[  663.229354]  ? kthread_create_on_node+0x40/0x40
[  663.229356]  ret_from_fork+0x2e/0x40
[  663.229357] kworker/10:74   D    0  9366      2 0x00000000
[  663.229360] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229361] Call Trace:
[  663.229363]  __schedule+0x2da/0xb00
[  663.229365]  schedule+0x38/0x90
[  663.229366]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229369]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229371]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229373]  call_rwsem_down_write_failed+0x17/0x30
[  663.229375]  down_write+0x5a/0x70
[  663.229377]  ? __generic_file_fsync+0x43/0x90
[  663.229378]  __generic_file_fsync+0x43/0x90
[  663.229380]  ext4_sync_file+0x2b4/0x540
[  663.229381]  vfs_fsync_range+0x46/0xa0
[  663.229383]  dio_complete+0x181/0x1b0
[  663.229384]  dio_aio_complete_work+0x17/0x20
[  663.229385]  process_one_work+0x208/0x6a0
[  663.229387]  ? process_one_work+0x18d/0x6a0
[  663.229388]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229390]  worker_thread+0x49/0x4a0
[  663.229392]  kthread+0x107/0x140
[  663.229393]  ? process_one_work+0x6a0/0x6a0
[  663.229395]  ? kthread_create_on_node+0x40/0x40
[  663.229396]  ret_from_fork+0x2e/0x40
[  663.229398] kworker/10:75   D    0  9367      2 0x00000000
[  663.229401] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229403] Call Trace:
[  663.229405]  __schedule+0x2da/0xb00
[  663.229407]  schedule+0x38/0x90
[  663.229409]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229411]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229413]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229415]  call_rwsem_down_write_failed+0x17/0x30
[  663.229417]  down_write+0x5a/0x70
[  663.229419]  ? __generic_file_fsync+0x43/0x90
[  663.229421]  __generic_file_fsync+0x43/0x90
[  663.229423]  ext4_sync_file+0x2b4/0x540
[  663.229424]  vfs_fsync_range+0x46/0xa0
[  663.229425]  dio_complete+0x181/0x1b0
[  663.229427]  dio_aio_complete_work+0x17/0x20
[  663.229428]  process_one_work+0x208/0x6a0
[  663.229429]  ? process_one_work+0x18d/0x6a0
[  663.229431]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229433]  worker_thread+0x49/0x4a0
[  663.229435]  kthread+0x107/0x140
[  663.229436]  ? process_one_work+0x6a0/0x6a0
[  663.229438]  ? kthread_create_on_node+0x40/0x40
[  663.229439]  ret_from_fork+0x2e/0x40
[  663.229441] kworker/10:76   D    0  9368      2 0x00000000
[  663.229443] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229444] Call Trace:
[  663.229446]  __schedule+0x2da/0xb00
[  663.229448]  schedule+0x38/0x90
[  663.229450]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229453]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229455]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229457]  call_rwsem_down_write_failed+0x17/0x30
[  663.229459]  down_write+0x5a/0x70
[  663.229461]  ? __generic_file_fsync+0x43/0x90
[  663.229462]  __generic_file_fsync+0x43/0x90
[  663.229464]  ext4_sync_file+0x2b4/0x540
[  663.229465]  vfs_fsync_range+0x46/0xa0
[  663.229467]  dio_complete+0x181/0x1b0
[  663.229468]  dio_aio_complete_work+0x17/0x20
[  663.229470]  process_one_work+0x208/0x6a0
[  663.229471]  ? process_one_work+0x18d/0x6a0
[  663.229473]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229474]  worker_thread+0x49/0x4a0
[  663.229476]  kthread+0x107/0x140
[  663.229477]  ? process_one_work+0x6a0/0x6a0
[  663.229479]  ? kthread_create_on_node+0x40/0x40
[  663.229481]  ret_from_fork+0x2e/0x40
[  663.229482] kworker/10:77   D    0  9369      2 0x00000000
[  663.229485] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229486] Call Trace:
[  663.229488]  __schedule+0x2da/0xb00
[  663.229490]  schedule+0x38/0x90
[  663.229491]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229493]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229495]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229498]  call_rwsem_down_write_failed+0x17/0x30
[  663.229499]  down_write+0x5a/0x70
[  663.229502]  ? __generic_file_fsync+0x43/0x90
[  663.229503]  __generic_file_fsync+0x43/0x90
[  663.229505]  ext4_sync_file+0x2b4/0x540
[  663.229506]  vfs_fsync_range+0x46/0xa0
[  663.229507]  dio_complete+0x181/0x1b0
[  663.229509]  dio_aio_complete_work+0x17/0x20
[  663.229510]  process_one_work+0x208/0x6a0
[  663.229511]  ? process_one_work+0x18d/0x6a0
[  663.229513]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229514]  worker_thread+0x49/0x4a0
[  663.229516]  kthread+0x107/0x140
[  663.229517]  ? process_one_work+0x6a0/0x6a0
[  663.229519]  ? kthread_create_on_node+0x40/0x40
[  663.229520]  ret_from_fork+0x2e/0x40
[  663.229522] kworker/10:78   D    0  9370      2 0x00000000
[  663.229524] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229525] Call Trace:
[  663.229527]  __schedule+0x2da/0xb00
[  663.229529]  schedule+0x38/0x90
[  663.229530]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229532]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229535]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229536]  ? trace_hardirqs_on_caller+0xf9/0x1b0
[  663.229539]  call_rwsem_down_write_failed+0x17/0x30
[  663.229541]  down_write+0x5a/0x70
[  663.229543]  ? __generic_file_fsync+0x43/0x90
[  663.229545]  __generic_file_fsync+0x43/0x90
[  663.229546]  ext4_sync_file+0x2b4/0x540
[  663.229548]  vfs_fsync_range+0x46/0xa0
[  663.229549]  dio_complete+0x181/0x1b0
[  663.229551]  dio_aio_complete_work+0x17/0x20
[  663.229552]  process_one_work+0x208/0x6a0
[  663.229553]  ? process_one_work+0x18d/0x6a0
[  663.229555]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229556]  worker_thread+0x49/0x4a0
[  663.229558]  kthread+0x107/0x140
[  663.229560]  ? process_one_work+0x6a0/0x6a0
[  663.229561]  ? kthread_create_on_node+0x40/0x40
[  663.229563]  ret_from_fork+0x2e/0x40
[  663.229565] kworker/10:79   D    0  9371      2 0x00000000
[  663.229568] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229569] Call Trace:
[  663.229571]  __schedule+0x2da/0xb00
[  663.229573]  schedule+0x38/0x90
[  663.229575]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229577]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229579]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229582]  call_rwsem_down_write_failed+0x17/0x30
[  663.229584]  down_write+0x5a/0x70
[  663.229586]  ? __generic_file_fsync+0x43/0x90
[  663.229587]  __generic_file_fsync+0x43/0x90
[  663.229589]  ext4_sync_file+0x2b4/0x540
[  663.229591]  vfs_fsync_range+0x46/0xa0
[  663.229592]  dio_complete+0x181/0x1b0
[  663.229593]  dio_aio_complete_work+0x17/0x20
[  663.229595]  process_one_work+0x208/0x6a0
[  663.229596]  ? process_one_work+0x18d/0x6a0
[  663.229597]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229599]  worker_thread+0x49/0x4a0
[  663.229601]  kthread+0x107/0x140
[  663.229602]  ? process_one_work+0x6a0/0x6a0
[  663.229604]  ? kthread_create_on_node+0x40/0x40
[  663.229605]  ret_from_fork+0x2e/0x40
[  663.229607] kworker/10:80   D    0  9372      2 0x00000000
[  663.229609] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229610] Call Trace:
[  663.229612]  __schedule+0x2da/0xb00
[  663.229614]  schedule+0x38/0x90
[  663.229616]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229618]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229620]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229622]  call_rwsem_down_write_failed+0x17/0x30
[  663.229624]  down_write+0x5a/0x70
[  663.229626]  ? __generic_file_fsync+0x43/0x90
[  663.229628]  __generic_file_fsync+0x43/0x90
[  663.229629]  ext4_sync_file+0x2b4/0x540
[  663.229631]  vfs_fsync_range+0x46/0xa0
[  663.229633]  dio_complete+0x181/0x1b0
[  663.229634]  dio_aio_complete_work+0x17/0x20
[  663.229635]  process_one_work+0x208/0x6a0
[  663.229636]  ? process_one_work+0x18d/0x6a0
[  663.229638]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229639]  worker_thread+0x49/0x4a0
[  663.229641]  kthread+0x107/0x140
[  663.229643]  ? process_one_work+0x6a0/0x6a0
[  663.229644]  ? kthread_create_on_node+0x40/0x40
[  663.229646]  ret_from_fork+0x2e/0x40
[  663.229648] kworker/10:81   D    0  9373      2 0x00000000
[  663.229650] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229651] Call Trace:
[  663.229653]  __schedule+0x2da/0xb00
[  663.229655]  schedule+0x38/0x90
[  663.229657]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229659]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229661]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229664]  call_rwsem_down_write_failed+0x17/0x30
[  663.229666]  down_write+0x5a/0x70
[  663.229669]  ? __generic_file_fsync+0x43/0x90
[  663.229671]  __generic_file_fsync+0x43/0x90
[  663.229672]  ext4_sync_file+0x2b4/0x540
[  663.229674]  vfs_fsync_range+0x46/0xa0
[  663.229675]  dio_complete+0x181/0x1b0
[  663.229677]  dio_aio_complete_work+0x17/0x20
[  663.229678]  process_one_work+0x208/0x6a0
[  663.229679]  ? process_one_work+0x18d/0x6a0
[  663.229681]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229683]  worker_thread+0x49/0x4a0
[  663.229685]  kthread+0x107/0x140
[  663.229686]  ? process_one_work+0x6a0/0x6a0
[  663.229688]  ? kthread_create_on_node+0x40/0x40
[  663.229689]  ret_from_fork+0x2e/0x40
[  663.229691] kworker/10:82   D    0  9374      2 0x00000000
[  663.229693] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229694] Call Trace:
[  663.229697]  __schedule+0x2da/0xb00
[  663.229699]  schedule+0x38/0x90
[  663.229701]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229703]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229705]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229708]  call_rwsem_down_write_failed+0x17/0x30
[  663.229710]  down_write+0x5a/0x70
[  663.229711]  ? __generic_file_fsync+0x43/0x90
[  663.229713]  __generic_file_fsync+0x43/0x90
[  663.229715]  ext4_sync_file+0x2b4/0x540
[  663.229716]  vfs_fsync_range+0x46/0xa0
[  663.229717]  dio_complete+0x181/0x1b0
[  663.229719]  dio_aio_complete_work+0x17/0x20
[  663.229720]  process_one_work+0x208/0x6a0
[  663.229721]  ? process_one_work+0x18d/0x6a0
[  663.229723]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229724]  worker_thread+0x49/0x4a0
[  663.229726]  kthread+0x107/0x140
[  663.229727]  ? process_one_work+0x6a0/0x6a0
[  663.229729]  ? kthread_create_on_node+0x40/0x40
[  663.229731]  ret_from_fork+0x2e/0x40
[  663.229732] kworker/10:83   D    0  9375      2 0x00000000
[  663.229735] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229736] Call Trace:
[  663.229738]  __schedule+0x2da/0xb00
[  663.229739]  schedule+0x38/0x90
[  663.229741]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229743]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229745]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229747]  call_rwsem_down_write_failed+0x17/0x30
[  663.229749]  down_write+0x5a/0x70
[  663.229751]  ? __generic_file_fsync+0x43/0x90
[  663.229752]  __generic_file_fsync+0x43/0x90
[  663.229754]  ext4_sync_file+0x2b4/0x540
[  663.229755]  vfs_fsync_range+0x46/0xa0
[  663.229757]  dio_complete+0x181/0x1b0
[  663.229759]  dio_aio_complete_work+0x17/0x20
[  663.229760]  process_one_work+0x208/0x6a0
[  663.229762]  ? process_one_work+0x18d/0x6a0
[  663.229763]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229765]  worker_thread+0x49/0x4a0
[  663.229767]  kthread+0x107/0x140
[  663.229768]  ? process_one_work+0x6a0/0x6a0
[  663.229770]  ? kthread_create_on_node+0x40/0x40
[  663.229771]  ret_from_fork+0x2e/0x40
[  663.229773] kworker/10:84   D    0  9376      2 0x00000000
[  663.229775] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229777] Call Trace:
[  663.229779]  __schedule+0x2da/0xb00
[  663.229780]  schedule+0x38/0x90
[  663.229783]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229785]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229787]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229789]  call_rwsem_down_write_failed+0x17/0x30
[  663.229791]  down_write+0x5a/0x70
[  663.229793]  ? __generic_file_fsync+0x43/0x90
[  663.229795]  __generic_file_fsync+0x43/0x90
[  663.229797]  ext4_sync_file+0x2b4/0x540
[  663.229798]  vfs_fsync_range+0x46/0xa0
[  663.229800]  dio_complete+0x181/0x1b0
[  663.229801]  dio_aio_complete_work+0x17/0x20
[  663.229803]  process_one_work+0x208/0x6a0
[  663.229804]  ? process_one_work+0x18d/0x6a0
[  663.229806]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229807]  worker_thread+0x49/0x4a0
[  663.229809]  kthread+0x107/0x140
[  663.229810]  ? process_one_work+0x6a0/0x6a0
[  663.229812]  ? kthread_create_on_node+0x40/0x40
[  663.229814]  ret_from_fork+0x2e/0x40
[  663.229815] kworker/10:85   D    0  9377      2 0x00000000
[  663.229818] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229819] Call Trace:
[  663.229821]  __schedule+0x2da/0xb00
[  663.229823]  schedule+0x38/0x90
[  663.229825]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229828]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229830]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229832]  call_rwsem_down_write_failed+0x17/0x30
[  663.229834]  down_write+0x5a/0x70
[  663.229835]  ? __generic_file_fsync+0x43/0x90
[  663.229837]  __generic_file_fsync+0x43/0x90
[  663.229838]  ext4_sync_file+0x2b4/0x540
[  663.229840]  vfs_fsync_range+0x46/0xa0
[  663.229841]  dio_complete+0x181/0x1b0
[  663.229842]  dio_aio_complete_work+0x17/0x20
[  663.229844]  process_one_work+0x208/0x6a0
[  663.229845]  ? process_one_work+0x18d/0x6a0
[  663.229847]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229849]  worker_thread+0x49/0x4a0
[  663.229850]  kthread+0x107/0x140
[  663.229852]  ? process_one_work+0x6a0/0x6a0
[  663.229853]  ? kthread_create_on_node+0x40/0x40
[  663.229854]  ret_from_fork+0x2e/0x40
[  663.229856] kworker/10:86   D    0  9378      2 0x00000000
[  663.229859] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229860] Call Trace:
[  663.229862]  __schedule+0x2da/0xb00
[  663.229864]  schedule+0x38/0x90
[  663.229866]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229868]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229870]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229873]  call_rwsem_down_write_failed+0x17/0x30
[  663.229875]  down_write+0x5a/0x70
[  663.229876]  ? __generic_file_fsync+0x43/0x90
[  663.229878]  __generic_file_fsync+0x43/0x90
[  663.229880]  ext4_sync_file+0x2b4/0x540
[  663.229881]  vfs_fsync_range+0x46/0xa0
[  663.229883]  dio_complete+0x181/0x1b0
[  663.229884]  dio_aio_complete_work+0x17/0x20
[  663.229885]  process_one_work+0x208/0x6a0
[  663.229887]  ? process_one_work+0x18d/0x6a0
[  663.229888]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229890]  worker_thread+0x49/0x4a0
[  663.229893]  kthread+0x107/0x140
[  663.229894]  ? process_one_work+0x6a0/0x6a0
[  663.229896]  ? kthread_create_on_node+0x40/0x40
[  663.229897]  ret_from_fork+0x2e/0x40
[  663.229899] kworker/10:87   D    0  9379      2 0x00000000
[  663.229902] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229903] Call Trace:
[  663.229905]  __schedule+0x2da/0xb00
[  663.229906]  schedule+0x38/0x90
[  663.229908]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229910]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229912]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229915]  call_rwsem_down_write_failed+0x17/0x30
[  663.229917]  down_write+0x5a/0x70
[  663.229919]  ? __generic_file_fsync+0x43/0x90
[  663.229920]  __generic_file_fsync+0x43/0x90
[  663.229922]  ext4_sync_file+0x2b4/0x540
[  663.229924]  vfs_fsync_range+0x46/0xa0
[  663.229926]  dio_complete+0x181/0x1b0
[  663.229927]  dio_aio_complete_work+0x17/0x20
[  663.229928]  process_one_work+0x208/0x6a0
[  663.229929]  ? process_one_work+0x18d/0x6a0
[  663.229931]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229932]  worker_thread+0x49/0x4a0
[  663.229934]  kthread+0x107/0x140
[  663.229936]  ? process_one_work+0x6a0/0x6a0
[  663.229938]  ? kthread_create_on_node+0x40/0x40
[  663.229939]  ret_from_fork+0x2e/0x40
[  663.229941] kworker/10:88   D    0  9380      2 0x00000000
[  663.229943] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229944] Call Trace:
[  663.229946]  __schedule+0x2da/0xb00
[  663.229948]  schedule+0x38/0x90
[  663.229950]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229952]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229954]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229956]  call_rwsem_down_write_failed+0x17/0x30
[  663.229958]  down_write+0x5a/0x70
[  663.229960]  ? __generic_file_fsync+0x43/0x90
[  663.229962]  __generic_file_fsync+0x43/0x90
[  663.229963]  ext4_sync_file+0x2b4/0x540
[  663.229965]  vfs_fsync_range+0x46/0xa0
[  663.229966]  dio_complete+0x181/0x1b0
[  663.229967]  dio_aio_complete_work+0x17/0x20
[  663.229968]  process_one_work+0x208/0x6a0
[  663.229970]  ? process_one_work+0x18d/0x6a0
[  663.229971]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.229973]  worker_thread+0x49/0x4a0
[  663.229975]  kthread+0x107/0x140
[  663.229976]  ? process_one_work+0x6a0/0x6a0
[  663.229978]  ? kthread_create_on_node+0x40/0x40
[  663.229979]  ret_from_fork+0x2e/0x40
[  663.229981] kworker/10:89   D    0  9381      2 0x00000000
[  663.229983] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.229984] Call Trace:
[  663.229986]  __schedule+0x2da/0xb00
[  663.229988]  schedule+0x38/0x90
[  663.229990]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.229992]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.229994]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.229997]  call_rwsem_down_write_failed+0x17/0x30
[  663.229999]  down_write+0x5a/0x70
[  663.230001]  ? __generic_file_fsync+0x43/0x90
[  663.230002]  __generic_file_fsync+0x43/0x90
[  663.230004]  ext4_sync_file+0x2b4/0x540
[  663.230006]  vfs_fsync_range+0x46/0xa0
[  663.230007]  dio_complete+0x181/0x1b0
[  663.230008]  dio_aio_complete_work+0x17/0x20
[  663.230010]  process_one_work+0x208/0x6a0
[  663.230011]  ? process_one_work+0x18d/0x6a0
[  663.230013]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230015]  worker_thread+0x49/0x4a0
[  663.230016]  kthread+0x107/0x140
[  663.230018]  ? process_one_work+0x6a0/0x6a0
[  663.230019]  ? kthread_create_on_node+0x40/0x40
[  663.230021]  ret_from_fork+0x2e/0x40
[  663.230023] kworker/10:90   D    0  9382      2 0x00000000
[  663.230026] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230027] Call Trace:
[  663.230029]  __schedule+0x2da/0xb00
[  663.230031]  schedule+0x38/0x90
[  663.230033]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230035]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230037]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230039]  call_rwsem_down_write_failed+0x17/0x30
[  663.230041]  down_write+0x5a/0x70
[  663.230042]  ? __generic_file_fsync+0x43/0x90
[  663.230044]  __generic_file_fsync+0x43/0x90
[  663.230046]  ext4_sync_file+0x2b4/0x540
[  663.230047]  vfs_fsync_range+0x46/0xa0
[  663.230049]  dio_complete+0x181/0x1b0
[  663.230050]  dio_aio_complete_work+0x17/0x20
[  663.230051]  process_one_work+0x208/0x6a0
[  663.230053]  ? process_one_work+0x18d/0x6a0
[  663.230054]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230056]  worker_thread+0x49/0x4a0
[  663.230058]  kthread+0x107/0x140
[  663.230059]  ? process_one_work+0x6a0/0x6a0
[  663.230060]  ? kthread_create_on_node+0x40/0x40
[  663.230062]  ret_from_fork+0x2e/0x40
[  663.230063] kworker/10:91   D    0  9383      2 0x00000000
[  663.230066] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230067] Call Trace:
[  663.230069]  __schedule+0x2da/0xb00
[  663.230070]  schedule+0x38/0x90
[  663.230072]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230074]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230076]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230079]  call_rwsem_down_write_failed+0x17/0x30
[  663.230081]  down_write+0x5a/0x70
[  663.230083]  ? __generic_file_fsync+0x43/0x90
[  663.230084]  __generic_file_fsync+0x43/0x90
[  663.230086]  ext4_sync_file+0x2b4/0x540
[  663.230087]  vfs_fsync_range+0x46/0xa0
[  663.230089]  dio_complete+0x181/0x1b0
[  663.230090]  dio_aio_complete_work+0x17/0x20
[  663.230092]  process_one_work+0x208/0x6a0
[  663.230093]  ? process_one_work+0x18d/0x6a0
[  663.230095]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230096]  worker_thread+0x49/0x4a0
[  663.230098]  kthread+0x107/0x140
[  663.230099]  ? process_one_work+0x6a0/0x6a0
[  663.230101]  ? kthread_create_on_node+0x40/0x40
[  663.230102]  ret_from_fork+0x2e/0x40
[  663.230104] kworker/10:92   D    0  9384      2 0x00000000
[  663.230107] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230108] Call Trace:
[  663.230110]  __schedule+0x2da/0xb00
[  663.230112]  schedule+0x38/0x90
[  663.230114]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230116]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230118]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230121]  call_rwsem_down_write_failed+0x17/0x30
[  663.230123]  down_write+0x5a/0x70
[  663.230125]  ? __generic_file_fsync+0x43/0x90
[  663.230126]  __generic_file_fsync+0x43/0x90
[  663.230128]  ext4_sync_file+0x2b4/0x540
[  663.230130]  vfs_fsync_range+0x46/0xa0
[  663.230131]  dio_complete+0x181/0x1b0
[  663.230132]  dio_aio_complete_work+0x17/0x20
[  663.230134]  process_one_work+0x208/0x6a0
[  663.230135]  ? process_one_work+0x18d/0x6a0
[  663.230137]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230138]  worker_thread+0x49/0x4a0
[  663.230140]  kthread+0x107/0x140
[  663.230142]  ? process_one_work+0x6a0/0x6a0
[  663.230143]  ? kthread_create_on_node+0x40/0x40
[  663.230145]  ret_from_fork+0x2e/0x40
[  663.230146] kworker/10:93   D    0  9385      2 0x00000000
[  663.230149] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230150] Call Trace:
[  663.230152]  __schedule+0x2da/0xb00
[  663.230153]  schedule+0x38/0x90
[  663.230155]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230157]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230159]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230161]  call_rwsem_down_write_failed+0x17/0x30
[  663.230163]  down_write+0x5a/0x70
[  663.230165]  ? __generic_file_fsync+0x43/0x90
[  663.230166]  __generic_file_fsync+0x43/0x90
[  663.230168]  ext4_sync_file+0x2b4/0x540
[  663.230169]  vfs_fsync_range+0x46/0xa0
[  663.230171]  dio_complete+0x181/0x1b0
[  663.230172]  dio_aio_complete_work+0x17/0x20
[  663.230173]  process_one_work+0x208/0x6a0
[  663.230174]  ? process_one_work+0x18d/0x6a0
[  663.230176]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230177]  worker_thread+0x49/0x4a0
[  663.230179]  kthread+0x107/0x140
[  663.230180]  ? process_one_work+0x6a0/0x6a0
[  663.230182]  ? kthread_create_on_node+0x40/0x40
[  663.230183]  ret_from_fork+0x2e/0x40
[  663.230185] kworker/10:94   D    0  9386      2 0x00000000
[  663.230187] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230188] Call Trace:
[  663.230190]  __schedule+0x2da/0xb00
[  663.230192]  schedule+0x38/0x90
[  663.230194]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230195]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230197]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230199]  ? trace_hardirqs_on+0xd/0x10
[  663.230201]  call_rwsem_down_write_failed+0x17/0x30
[  663.230203]  down_write+0x5a/0x70
[  663.230205]  ? __generic_file_fsync+0x43/0x90
[  663.230206]  __generic_file_fsync+0x43/0x90
[  663.230208]  ext4_sync_file+0x2b4/0x540
[  663.230209]  vfs_fsync_range+0x46/0xa0
[  663.230211]  dio_complete+0x181/0x1b0
[  663.230212]  dio_aio_complete_work+0x17/0x20
[  663.230214]  process_one_work+0x208/0x6a0
[  663.230215]  ? process_one_work+0x18d/0x6a0
[  663.230217]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230218]  worker_thread+0x49/0x4a0
[  663.230220]  kthread+0x107/0x140
[  663.230221]  ? process_one_work+0x6a0/0x6a0
[  663.230223]  ? kthread_create_on_node+0x40/0x40
[  663.230224]  ret_from_fork+0x2e/0x40
[  663.230226] kworker/10:95   D    0  9387      2 0x00000000
[  663.230230] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230231] Call Trace:
[  663.230233]  __schedule+0x2da/0xb00
[  663.230235]  schedule+0x38/0x90
[  663.230237]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230239]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230241]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230243]  call_rwsem_down_write_failed+0x17/0x30
[  663.230246]  down_write+0x5a/0x70
[  663.230247]  ? __generic_file_fsync+0x43/0x90
[  663.230249]  __generic_file_fsync+0x43/0x90
[  663.230251]  ext4_sync_file+0x2b4/0x540
[  663.230252]  vfs_fsync_range+0x46/0xa0
[  663.230254]  dio_complete+0x181/0x1b0
[  663.230255]  dio_aio_complete_work+0x17/0x20
[  663.230256]  process_one_work+0x208/0x6a0
[  663.230258]  ? process_one_work+0x18d/0x6a0
[  663.230259]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230261]  worker_thread+0x49/0x4a0
[  663.230262]  kthread+0x107/0x140
[  663.230264]  ? process_one_work+0x6a0/0x6a0
[  663.230265]  ? kthread_create_on_node+0x40/0x40
[  663.230267]  ret_from_fork+0x2e/0x40
[  663.230268] kworker/10:96   D    0  9388      2 0x00000000
[  663.230271] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230272] Call Trace:
[  663.230274]  __schedule+0x2da/0xb00
[  663.230276]  schedule+0x38/0x90
[  663.230278]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230280]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230282]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230285]  call_rwsem_down_write_failed+0x17/0x30
[  663.230287]  down_write+0x5a/0x70
[  663.230288]  ? __generic_file_fsync+0x43/0x90
[  663.230290]  __generic_file_fsync+0x43/0x90
[  663.230291]  ext4_sync_file+0x2b4/0x540
[  663.230293]  vfs_fsync_range+0x46/0xa0
[  663.230294]  dio_complete+0x181/0x1b0
[  663.230295]  dio_aio_complete_work+0x17/0x20
[  663.230296]  process_one_work+0x208/0x6a0
[  663.230298]  ? process_one_work+0x18d/0x6a0
[  663.230299]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230301]  worker_thread+0x49/0x4a0
[  663.230303]  kthread+0x107/0x140
[  663.230304]  ? process_one_work+0x6a0/0x6a0
[  663.230305]  ? kthread_create_on_node+0x40/0x40
[  663.230307]  ret_from_fork+0x2e/0x40
[  663.230308] kworker/10:97   D    0  9389      2 0x00000000
[  663.230311] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230312] Call Trace:
[  663.230314]  __schedule+0x2da/0xb00
[  663.230316]  schedule+0x38/0x90
[  663.230317]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230319]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230321]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230324]  call_rwsem_down_write_failed+0x17/0x30
[  663.230326]  down_write+0x5a/0x70
[  663.230327]  ? __generic_file_fsync+0x43/0x90
[  663.230329]  __generic_file_fsync+0x43/0x90
[  663.230331]  ext4_sync_file+0x2b4/0x540
[  663.230333]  vfs_fsync_range+0x46/0xa0
[  663.230335]  dio_complete+0x181/0x1b0
[  663.230336]  dio_aio_complete_work+0x17/0x20
[  663.230337]  process_one_work+0x208/0x6a0
[  663.230338]  ? process_one_work+0x18d/0x6a0
[  663.230340]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230342]  worker_thread+0x49/0x4a0
[  663.230344]  kthread+0x107/0x140
[  663.230345]  ? process_one_work+0x6a0/0x6a0
[  663.230347]  ? kthread_create_on_node+0x40/0x40
[  663.230348]  ret_from_fork+0x2e/0x40
[  663.230350] kworker/10:98   D    0  9390      2 0x00000000
[  663.230353] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230354] Call Trace:
[  663.230356]  __schedule+0x2da/0xb00
[  663.230358]  schedule+0x38/0x90
[  663.230360]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230362]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230364]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230367]  call_rwsem_down_write_failed+0x17/0x30
[  663.230369]  down_write+0x5a/0x70
[  663.230371]  ? __generic_file_fsync+0x43/0x90
[  663.230372]  __generic_file_fsync+0x43/0x90
[  663.230374]  ext4_sync_file+0x2b4/0x540
[  663.230376]  vfs_fsync_range+0x46/0xa0
[  663.230377]  dio_complete+0x181/0x1b0
[  663.230378]  dio_aio_complete_work+0x17/0x20
[  663.230380]  process_one_work+0x208/0x6a0
[  663.230381]  ? process_one_work+0x18d/0x6a0
[  663.230383]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230384]  worker_thread+0x49/0x4a0
[  663.230386]  kthread+0x107/0x140
[  663.230387]  ? process_one_work+0x6a0/0x6a0
[  663.230390]  ? kthread_create_on_node+0x40/0x40
[  663.230391]  ret_from_fork+0x2e/0x40
[  663.230393] kworker/10:99   D    0  9391      2 0x00000000
[  663.230396] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230397] Call Trace:
[  663.230399]  __schedule+0x2da/0xb00
[  663.230401]  schedule+0x38/0x90
[  663.230403]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230405]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230407]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230409]  call_rwsem_down_write_failed+0x17/0x30
[  663.230411]  down_write+0x5a/0x70
[  663.230413]  ? __generic_file_fsync+0x43/0x90
[  663.230414]  __generic_file_fsync+0x43/0x90
[  663.230416]  ext4_sync_file+0x2b4/0x540
[  663.230417]  vfs_fsync_range+0x46/0xa0
[  663.230419]  dio_complete+0x181/0x1b0
[  663.230420]  dio_aio_complete_work+0x17/0x20
[  663.230421]  process_one_work+0x208/0x6a0
[  663.230422]  ? process_one_work+0x18d/0x6a0
[  663.230424]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230425]  worker_thread+0x49/0x4a0
[  663.230427]  kthread+0x107/0x140
[  663.230428]  ? process_one_work+0x6a0/0x6a0
[  663.230431]  ? kthread_create_on_node+0x40/0x40
[  663.230432]  ret_from_fork+0x2e/0x40
[  663.230434] kworker/10:100  D    0  9392      2 0x00000000
[  663.230436] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230437] Call Trace:
[  663.230440]  __schedule+0x2da/0xb00
[  663.230442]  schedule+0x38/0x90
[  663.230445]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230447]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230448]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230451]  call_rwsem_down_write_failed+0x17/0x30
[  663.230453]  down_write+0x5a/0x70
[  663.230455]  ? __generic_file_fsync+0x43/0x90
[  663.230456]  __generic_file_fsync+0x43/0x90
[  663.230458]  ext4_sync_file+0x2b4/0x540
[  663.230460]  vfs_fsync_range+0x46/0xa0
[  663.230461]  dio_complete+0x181/0x1b0
[  663.230463]  dio_aio_complete_work+0x17/0x20
[  663.230464]  process_one_work+0x208/0x6a0
[  663.230465]  ? process_one_work+0x18d/0x6a0
[  663.230467]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230469]  worker_thread+0x49/0x4a0
[  663.230471]  kthread+0x107/0x140
[  663.230473]  ? process_one_work+0x6a0/0x6a0
[  663.230474]  ? kthread_create_on_node+0x40/0x40
[  663.230476]  ret_from_fork+0x2e/0x40
[  663.230478] kworker/10:101  D    0  9393      2 0x00000000
[  663.230480] Workqueue: dio/dm-0 dio_aio_complete_work
[  663.230481] Call Trace:
[  663.230483]  __schedule+0x2da/0xb00
[  663.230485]  ? _raw_spin_unlock_irq+0x27/0x40
[  663.230487]  schedule+0x38/0x90
[  663.230489]  ? rwsem_down_write_failed+0x2ac/0x4b0
[  663.230491]  rwsem_down_write_failed+0x2b1/0x4b0
[  663.230493]  ? rwsem_down_write_failed+0x50/0x4b0
[  663.230494]  ? trace_hardirqs_on+0xd/0x10
[  663.230496]  call_rwsem_down_write_failed+0x17/0x30
[  663.230499]  down_write+0x5a/0x70
[  663.230500]  ? __generic_file_fsync+0x43/0x90
[  663.230502]  __generic_file_fsync+0x43/0x90
[  663.230504]  ext4_sync_file+0x2b4/0x540
[  663.230506]  vfs_fsync_range+0x46/0xa0
[  663.230507]  dio_complete+0x181/0x1b0
[  663.230508]  dio_aio_complete_work+0x17/0x20
[  663.230509]  process_one_work+0x208/0x6a0
[  663.230510]  ? process_one_work+0x18d/0x6a0
[  663.230512]  ? __mutex_unlock_slowpath+0x3e/0x290
[  663.230514]  worker_thread+0x49/0x4a0
[  663.230515]  kthread+0x107/0x140
[  663.230517]  ? process_one_work+0x6a0/0x6a0
[  663.230518]  ? kthread_create_on_node+0x40/0x40
[  663.230519]  ret_from_fork+0x2e/0x40=
