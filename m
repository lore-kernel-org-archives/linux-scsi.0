From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Mon, 09 Apr 2018 21:02:05 +0200
Message-ID: <51a7e805058ef7f35b226cbbf0ccc4ff@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name>
 <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

(fancy details for linux-block and BFQ people go below)

09.04.2018 20:32, Kees Cook wrote:
> Ah, this detail I didn't have. I've changed my environment to
> 
> build with:
> 
> CONFIG_BLK_MQ_PCI=y
> CONFIG_BLK_MQ_VIRTIO=y
> CONFIG_IOSCHED_BFQ=y
> 
> boot with scsi_mod.use_blk_mq=1
> 
> and select BFQ in the scheduler:
> 
> # cat /sys/block/sd?/queue/scheduler
> mq-deadline kyber [bfq] none
> mq-deadline kyber [bfq] none
> 
> Even with this, I'm not seeing anything yet...

Thanks for looking into it anyway. I was experimenting today a little 
bit, and for me it looks like setting queue_depth and nr_requests to 
minimal values speeds up the reproducing. Could you please try it too? 
Something like:

echo 1 | tee /sys/block/sd*/queue/nr_requests
echo 1 | tee /sys/block/sd*/device/queue_depth

Also, now I have a more solid proof that this is related to I/O 
scheduling.

I was hammering my VM, and after a couple of usercopy warnings/bugs I 
can reliably trigger I/O hang. I was able to obtain the stack traces of 
tasks in D state. Listing them here below. dmcrypt_write:

===
[ 1615.409622] dmcrypt_write   D    0   236      2 0x80000000
[ 1615.413422] Call Trace:
[ 1615.415428]  ? __schedule+0x336/0xf40
[ 1615.417824]  ? blk_mq_sched_dispatch_requests+0x117/0x190
[ 1615.421423]  ? __sbitmap_get_word+0x2a/0x80
[ 1615.424202]  schedule+0x32/0xc0
[ 1615.426521]  io_schedule+0x12/0x40
[ 1615.432414]  blk_mq_get_tag+0x181/0x2a0
[ 1615.434881]  ? elv_merge+0x79/0xe0
[ 1615.437447]  ? wait_woken+0x80/0x80
[ 1615.439553]  blk_mq_get_request+0xf9/0x400
[ 1615.444653]  blk_mq_make_request+0x10b/0x640
[ 1615.448025]  generic_make_request+0x124/0x2d0
[ 1615.450716]  ? raid10_unplug+0xfb/0x180 [raid10]
[ 1615.454069]  raid10_unplug+0xfb/0x180 [raid10]
[ 1615.456729]  blk_flush_plug_list+0xc1/0x250
[ 1615.460276]  blk_finish_plug+0x27/0x40
[ 1615.464103]  dmcrypt_write+0x233/0x240 [dm_crypt]
[ 1615.467443]  ? wake_up_process+0x20/0x20
[ 1615.470845]  ? crypt_iv_essiv_dtr+0x60/0x60 [dm_crypt]
[ 1615.475272]  ? kthread+0x113/0x130
[ 1615.477652]  kthread+0x113/0x130
[ 1615.480567]  ? kthread_create_on_node+0x70/0x70
[ 1615.483268]  ret_from_fork+0x35/0x40
===

One of XFS threads, too:

===
[ 1616.133298] xfsaild/dm-7    D    0   316      2 0x80000000
[ 1616.136679] Call Trace:
[ 1616.138845]  ? __schedule+0x336/0xf40
[ 1616.141581]  ? preempt_count_add+0x68/0xa0
[ 1616.147214]  ? _raw_spin_unlock+0x16/0x30
[ 1616.149813]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[ 1616.152478]  ? try_to_del_timer_sync+0x4d/0x80
[ 1616.154734]  schedule+0x32/0xc0
[ 1616.156579]  _xfs_log_force+0x146/0x290 [xfs]
[ 1616.159322]  ? wake_up_process+0x20/0x20
[ 1616.162175]  xfsaild+0x1a9/0x820 [xfs]
[ 1616.164695]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[ 1616.167567]  ? kthread+0x113/0x130
[ 1616.169722]  kthread+0x113/0x130
[ 1616.171908]  ? kthread_create_on_node+0x70/0x70
[ 1616.174073]  ? do_syscall_64+0x74/0x190
[ 1616.179008]  ? SyS_exit_group+0x10/0x10
[ 1616.182306]  ret_from_fork+0x35/0x40
===

journald is another victim:

===
[ 1616.184343] systemd-journal D    0   354      1 0x00000104
[ 1616.187282] Call Trace:
[ 1616.189464]  ? __schedule+0x336/0xf40
[ 1616.191781]  ? call_function_single_interrupt+0xa/0x20
[ 1616.194788]  ? _raw_spin_lock_irqsave+0x25/0x50
[ 1616.197592]  schedule+0x32/0xc0
[ 1616.200171]  schedule_timeout+0x202/0x470
[ 1616.202851]  ? preempt_count_add+0x49/0xa0
[ 1616.206227]  wait_for_common+0xbb/0x180
[ 1616.209877]  ? wake_up_process+0x20/0x20
[ 1616.212511]  do_coredump+0x335/0xea0
[ 1616.214861]  ? schedule+0x3c/0xc0
[ 1616.216775]  ? futex_wait_queue_me+0xbb/0x110
[ 1616.218894]  ? _raw_spin_unlock+0x16/0x30
[ 1616.220868]  ? futex_wait+0x143/0x240
[ 1616.223450]  get_signal+0x250/0x5c0
[ 1616.225965]  do_signal+0x36/0x610
[ 1616.228246]  ? __seccomp_filter+0x3b/0x260
[ 1616.231000]  ? __check_object_size+0x9f/0x1a0
[ 1616.233716]  exit_to_usermode_loop+0x85/0xa0
[ 1616.238413]  do_syscall_64+0x18b/0x190
[ 1616.240798]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 1616.244401] RIP: 0033:0x7f78fc53e45d
[ 1616.246690] RSP: 002b:00007ffd40330d20 EFLAGS: 00000246 ORIG_RAX: 
00000000000000ca
[ 1616.251199] RAX: fffffffffffffe00 RBX: 00007f78f7806700 RCX: 
00007f78fc53e45d
[ 1616.254817] RDX: 00000000000004cd RSI: 0000000000000000 RDI: 
00007f78f78069d0
[ 1616.258410] RBP: 00007ffd40330d20 R08: 00000000000000ca R09: 
00007f78f78069d0
[ 1616.261813] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[ 1616.265065] R13: 0000000000000000 R14: 00007f78fc95e8c0 R15: 
00007f78f7806d28

[ 1616.272861] journal-offline D    0  1229      1 0x00000104
[ 1616.275856] Call Trace:
[ 1616.277396]  ? __schedule+0x336/0xf40
[ 1616.279258]  ? release_pages+0x192/0x3d0
[ 1616.282871]  schedule+0x32/0xc0
[ 1616.285218]  io_schedule+0x12/0x40
[ 1616.287267]  wait_on_page_bit+0xea/0x130
[ 1616.291084]  ? add_to_page_cache_lru+0xe0/0xe0
[ 1616.293898]  __filemap_fdatawait_range+0xbb/0x110
[ 1616.297391]  ? xen_swiotlb_init+0x85/0x4d0
[ 1616.303285]  file_write_and_wait_range+0x76/0xa0
[ 1616.306313]  xfs_file_fsync+0x5d/0x240 [xfs]
[ 1616.309196]  ? syscall_trace_enter+0xd8/0x2d0
[ 1616.312193]  do_fsync+0x38/0x60
[ 1616.314654]  SyS_fsync+0xc/0x10
[ 1616.318686]  do_syscall_64+0x74/0x190
[ 1616.321519]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 1616.324045] RIP: 0033:0x7f78fc5470ec
[ 1616.326257] RSP: 002b:00007f78f7805d30 EFLAGS: 00000293 ORIG_RAX: 
000000000000004a
[ 1616.333535] RAX: ffffffffffffffda RBX: 00005597340357b0 RCX: 
00007f78fc5470ec
[ 1616.337057] RDX: 0000000000000000 RSI: 00007f78fbea3811 RDI: 
0000000000000013
[ 1616.341176] RBP: 00007f78fbea4c60 R08: 00007f78f7806700 R09: 
00007f78f7806700
[ 1616.345029] R10: 0000000000000811 R11: 0000000000000293 R12: 
0000000000000002
[ 1616.349279] R13: 00007ffd40330e8f R14: 00007ffd40330e90 R15: 
0000000000000016

[ 1876.568670] systemd-journal D    0 14892      1 0x00000100
[ 1876.573395] Call Trace:
[ 1876.575559]  ? __schedule+0x336/0xf40
[ 1876.578005]  ? memcg_kmem_charge+0xad/0xf0
[ 1876.580797]  ? lock_page_memcg+0x11/0x80
[ 1876.583674]  schedule+0x32/0xc0
[ 1876.585516]  io_schedule+0x12/0x40
[ 1876.590223]  wait_on_page_bit+0xea/0x130
[ 1876.591840]  ? add_to_page_cache_lru+0xe0/0xe0
[ 1876.593554]  __filemap_fdatawait_range+0xbb/0x110
[ 1876.595340]  ? store_online+0x34/0xb0
[ 1876.596913]  ? __filemap_fdatawrite_range+0xc1/0x100
[ 1876.599338]  ? __filemap_fdatawrite_range+0xcf/0x100
[ 1876.601447]  file_write_and_wait_range+0x76/0xa0
[ 1876.604356]  xfs_file_fsync+0x5d/0x240 [xfs]
[ 1876.606599]  ? syscall_trace_enter+0xd8/0x2d0
[ 1876.608753]  do_fsync+0x38/0x60
[ 1876.610952]  SyS_fsync+0xc/0x10
[ 1876.612442]  do_syscall_64+0x74/0x190
[ 1876.615383]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 1876.622030] RIP: 0033:0x7fe056a840c4
[ 1876.624698] RSP: 002b:00007ffe7908ce88 EFLAGS: 00000246 ORIG_RAX: 
000000000000004a
[ 1876.628290] RAX: ffffffffffffffda RBX: 000055ad65d1f9c0 RCX: 
00007fe056a840c4
[ 1876.630922] RDX: 00007fe0563e1c7c RSI: 0000000000000003 RDI: 
0000000000000017
[ 1876.634244] RBP: 00007fe0563e1c60 R08: 0000000000000005 R09: 
0000000000000002
[ 1876.637153] R10: 000055ad65d1a010 R11: 0000000000000246 R12: 
0000000000000002
[ 1876.640099] R13: 00000000fffffff0 R14: 0000000000000002 R15: 
00007ffe7908d2e0
===

And what's more important, I can make smartctl hang too!

===
[ 1876.466385] smartctl        D    0 14891    495 0x00000000
[ 1876.469100] Call Trace:
[ 1876.471267]  ? __schedule+0x336/0xf40
[ 1876.473541]  ? blk_mq_sched_dispatch_requests+0x117/0x190
[ 1876.476331]  ? __sbitmap_get_word+0x2a/0x80
[ 1876.478784]  ? sbitmap_get_shallow+0x5c/0xa0
[ 1876.481353]  schedule+0x32/0xc0
[ 1876.484412]  io_schedule+0x12/0x40
[ 1876.486892]  blk_mq_get_tag+0x181/0x2a0
[ 1876.489448]  ? wait_woken+0x80/0x80
[ 1876.492018]  blk_mq_get_request+0xf9/0x400
[ 1876.497734]  ? lookup_fast+0xc8/0x2d0
[ 1876.501050]  blk_mq_alloc_request+0x7e/0xe0
[ 1876.503705]  blk_get_request_flags+0x40/0x160
[ 1876.506306]  sg_io+0x9d/0x3f0
[ 1876.507920]  ? path_lookupat+0xaa/0x1f0
[ 1876.509750]  ? current_time+0x18/0x70
[ 1876.511496]  scsi_cmd_ioctl+0x257/0x410
[ 1876.513151]  ? xfs_bmapi_read+0x1c3/0x340 [xfs]
[ 1876.515355]  sd_ioctl+0xbf/0x1a0 [sd_mod]
[ 1876.517638]  blkdev_ioctl+0x8ca/0x990
[ 1876.519219]  ? read_null+0x10/0x10
[ 1876.520849]  block_ioctl+0x39/0x40
[ 1876.522368]  do_vfs_ioctl+0xa4/0x630
[ 1876.524490]  ? vfs_write+0x164/0x1a0
[ 1876.526841]  SyS_ioctl+0x74/0x80
[ 1876.528328]  do_syscall_64+0x74/0x190
[ 1876.529886]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 1876.537471] RIP: 0033:0x7f4f232c8d87
[ 1876.540388] RSP: 002b:00007ffd0fe530a8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[ 1876.545738] RAX: ffffffffffffffda RBX: 00007ffd0fe53350 RCX: 
00007f4f232c8d87
[ 1876.548950] RDX: 00007ffd0fe530c0 RSI: 0000000000002285 RDI: 
0000000000000003
[ 1876.552912] RBP: 00007ffd0fe533a0 R08: 0000000000000010 R09: 
00007ffd0fe53980
[ 1876.559750] R10: 0000000000000200 R11: 0000000000000246 R12: 
000055e98902dce0
[ 1876.563829] R13: 0000000000000000 R14: 000055e989027550 R15: 
00000000000000d0
===

Workqueues, also from alt+sysrq+t dump:

===
[ 1876.676508] Showing busy workqueues and worker pools:
[ 1876.681916] workqueue events_power_efficient: flags=0x82
[ 1876.685388]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=2/256
[ 1876.688962]     pending: fb_flashcursor, neigh_periodic_work
[ 1876.694414] workqueue events_freezable_power_: flags=0x86
[ 1876.699262]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/256
[ 1876.703777]     pending: disk_events_workfn
[ 1876.707279] workqueue dm-thin: flags=0xa000a
[ 1876.709053]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/1
[ 1876.715598]     pending: do_waker [dm_thin_pool]
===

So far, I can reproduce it only with blk-mq *and* BFQ enabled. I've 
switched another machine (my server) to Kyber, and I do not observe the 
issue (so far, at least).

Paolo, Jens? I don't know whom to address, actually :(. Can someone give 
me an idea on this please?

> The thing I can't figure out is how req->sense is slipping forward in
> (and even beyond!) the allocation.

*cough* race condition *cough* ☺

Regards,
   Oleksandr
