From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: WARNING: at drivers/ata/libata-core.c:5049 ata_qc_issue+0x1c7/0x3a0()
Date: Wed, 20 Feb 2013 18:24:17 +0200
Message-ID: <CA+ydwtpPFK3y3LrXQd6j0oF4COz22zP2HWkag1V5R4dQAkJqpw@mail.gmail.com>
References: <CA+ydwtooKGVOVq246d1DdROs_ytezTt1JqwX4-TyvNdDi7o+jQ@mail.gmail.com>
	<5123E8E1.9000302@interlog.com>
	<20130219215212.GA22720@redhat.com>
	<512401B2.70009@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512401B2.70009@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Dave Jones <davej@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2013/2/20 Douglas Gilbert <dgilbert@interlog.com>:
> On 13-02-19 04:52 PM, Dave Jones wrote:
>>
>> On Tue, Feb 19, 2013 at 04:04:33PM -0500, Douglas Gilbert wrote:
>>   > On 13-02-19 01:37 PM, Tommi Rantala wrote:
>>   > > Hello,
>>   > >
>>   > > Hit this WARNING once while fuzzing the kernel with trinity in a
>> qemu
>>   > > virtual machine as the root user.
>>   > >
>>   > > Does this make any sense? I have occasionally seen some ATA related
>>   > > troubles while fuzzing in a VM, but this warning is new to me.
>>   > >
>>   > > [  490.717030] WARNING: at
>>   > > /home/ttrantal/git/linux-2.6/drivers/ata/libata-core.c:5049
>>   > > ata_qc_issue+0x1c7/0x3a0()
>>   > > [  490.717030] Hardware name: Bochs
>>   > > [  490.717030] Pid: 2548, comm: trinity-child6 Not tainted 3.8.0+
>> #87
>>   > > [  490.717030] Call Trace:
>>   > > [  490.717030]  [<ffffffff81097b86>] warn_slowpath_common+0x86/0xb0
>>   > > [  490.717030]  [<ffffffff81097c75>] warn_slowpath_null+0x15/0x20
>>   > > [  490.717030]  [<ffffffff8150efd7>] ata_qc_issue+0x1c7/0x3a0
>>   > > [  490.717030]  [<ffffffff81516550>] ?
>> ata_scsi_set_sense.constprop.13+0x30/0x30
>>   > > [  490.717030]  [<ffffffff815155c0>] ata_scsi_translate+0x120/0x190
>>   > > [  490.717030]  [<ffffffff81518f4e>] ? ata_scsi_queuecmd+0x2e/0x2d0
>>   > > [  490.717030]  [<ffffffff81519173>] ata_scsi_queuecmd+0x253/0x2d0
>>   > > [  490.717030]  [<ffffffff814e3e91>] scsi_dispatch_cmd+0x161/0x230
>>   > > [  490.717030]  [<ffffffff814e9fd4>] scsi_request_fn+0x544/0x580
>>   > > [  490.717030]  [<ffffffff813473a6>] ?
>> cfq_dispatch_requests+0x56/0xb30
>>   > > [  490.717030]  [<ffffffff810f173a>] ? __lock_is_held+0x5a/0x80
>>   > > [  490.717030]  [<ffffffff81332112>] __blk_run_queue+0x32/0x40
>>   > > [  490.717030]  [<ffffffff8132d0ea>] __elv_add_request+0x10a/0x280
>>   > > [  490.717030]  [<ffffffff813391f6>] blk_execute_rq_nowait+0xb6/0xf0
>>   > > [  490.717030]  [<ffffffff810c0151>] ?
>> __init_waitqueue_head+0x41/0x60
>>   > > [  490.717030]  [<ffffffff813392d8>] blk_execute_rq+0xa8/0x110
>>   > > [  490.717030]  [<ffffffff810f557e>] ?
>> lock_release_non_nested+0xde/0x310
>>   > > [  490.717030]  [<ffffffff812fc1a4>] ? selinux_capable+0x34/0x50
>>   > > [  490.717030]  [<ffffffff812f8aa3>] ? security_capable+0x13/0x20
>>   > > [  490.717030]  [<ffffffff810a55d3>] ? ns_capable+0x53/0x80
>>   > > [  490.717030]  [<ffffffff8133f6c1>] sg_scsi_ioctl+0x2b1/0x3a0
>>   > > [  490.717030]  [<ffffffff8133fbc2>] scsi_cmd_ioctl+0x412/0x4a0
>>   > > [  490.717030]  [<ffffffff810f41d7>] ? __lock_acquire+0x957/0x1c20
>>   > > [  490.717030]  [<ffffffff81084adf>] ? kvm_clock_read+0x1f/0x30
>>   > > [  490.717030]  [<ffffffff81342d36>] bsg_ioctl+0x146/0x270
>>   > > [  490.717030]  [<ffffffff810f5b18>] ?
>> trace_hardirqs_off_caller+0x28/0xd0
>>   > > [  490.717030]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
>>   > > [  490.717030]  [<ffffffff810d552a>] ? local_clock+0x4a/0x70
>>   > > [  490.717030]  [<ffffffff810f1e98>] ?
>> lock_release_holdtime+0x28/0x170
>>   > > [  490.717030]  [<ffffffff812fb640>] ?
>> avc_has_perm_flags+0x1d0/0x2a0
>>   > > [  490.717030]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
>>   > > [  490.717030]  [<ffffffff810f5b18>] ?
>> trace_hardirqs_off_caller+0x28/0xd0
>>   > > [  490.717030]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
>>   > > [  490.717030]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
>>   > > [  490.717030]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
>>   > > [  490.717030]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
>>   > > [  490.717030]  [<ffffffff813571de>] ?
>> trace_hardirqs_on_thunk+0x3a/0x3f
>>   > > [  490.717030]  [<ffffffff81ca07e9>] system_call_fastpath+0x16/0x1b
>>   > > [  490.717030] ---[ end trace fce35d2b40bd0565 ]---
>>   > > [  490.810874] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action
>> 0x0
>>   > > [  490.812538] ata1.00: failed command: READ DMA
>>   > > [  490.813715] ata1.00: cmd c8/00:2c:00:01:00/00:00:00:00:00/e0 tag
>> 0
>>   > > [  490.813715]          res 50/01:00:b0:16:04/00:00:00:00:00/a0
>> Emask
>>   > > 0x40 (internal error)
>>   > > [  490.817269] ata1.00: status: { DRDY }
>>   > > [watchdog] 333615 iterations. [F:326712 S:6891]
>>   > > [watchdog] kernel became tainted! Last seed was 71022097
>>   > > [  491.266158] ata1.00: configured for MWDMA2
>>   > > [  491.267358] ata1: EH complete
>>   > > child 2548 exitting
>>   > > child 2492 exitting
>>   > > child 2500 exitting
>>   > > [2351] Bailing main loop. Exit reason: kernel became tainted
>>   > > [2350] Watchdog exiting
>>   > >
>>   > > Ran 333617 syscalls. Successes: 6892  Failures: 326714
>>   >
>>   > Looks like some application is using the deprecated
>>   > SCSI_IOCTL_SEND_COMMAND ioctl via a bsg node to send
>>   > a SCSI ATA PASS-THROUGH command tunnelling a ATA READ
>>   > DMA command.
>>   >
>>   > Looking for something positive to say: only a very skilled
>>   > professional tester could come up with such a mismatch.
>>
>> Unless Tommi has local modifications, what trinity does with sys_ioctl
>> is incredibly naive compared to some of the other syscalls.
>> It's a miracle it managed to pair an fd from a /dev node that understands
>> this ioctl with this set of arguments tbh.

Yes, I indeed have done some local changes to the trinity ioctl()
support, but I have not touched the trinity SCSI ioctl stuff. I'm a
bit busy at the moment, so cannot dig any deeper into this for now.

>> The actual code it uses for fuzzing SG_IO looks like this..
>>
>> https://github.com/kernelslacker/trinity/blob/master/ioctls/scsi-generic-sgio.c
>> It's not code I'm particularly proud of, it could be a lot more clever
>> than what it's currently doing, which is why I'm surprised it's having
>> positive results.
>>
>>   > Is this a recent kernel (linux-2.6 shown in path)? Processes
>>   > using the SCSI_IOCTL_SEND_COMMAND ioctl now get a yellow flag
>>   > in the logs.
>>
>> The trace shows 3.8.0+
>
>
> The backtrace shows sg_scsi_ioctl() being called and that is
> only visited when the SCSI_IOCTL_SEND_COMMAND ioctl is used
> (IOW not the SG_IO ioctl).
>
> And that ioctl can be used on a bsg node (as well as a SCSI
> block node (e.g. /dev/sdb) and a sg node). I would like Tommi
> to report if his log showed the output from this line (in
> block/scsi_ioctl.c):
>      printk(KERN_WARNING "program %s is using a deprecated SCSI ioctl,
>             please convert it to SG_IO\n", current->comm);

Yes, I can see these messages in the log, here are some lines from the
console right before the WARNING:

[  471.975252] Out of memory: Kill process 2488 (trinity-child4) score
169 or sacrifice child
[  471.978818] Killed process 2488 (trinity-child4) total-vm:470464kB,
anon-rss:196068kB, file-rss:1492kB
[watchdog] 311220 iterations. [F:304859 S:6349]
[2351] Random reseed: 1768566163
[2351] Regenerating random pages, fd's etc.
[watchdog] 311971 iterations. [F:305584 S:6375]
[  474.942408] program trinity-child0 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[watchdog] 314471 iterations. [F:308050 S:6409]
[watchdog] 316162 iterations. [F:309708 S:6441]
[watchdog] 317119 iterations. [F:310652 S:6455]
[  477.574703] trinity-child7 invoked oom-killer: gfp_mask=0x280da,
order=0, oom_score_adj=0
[  477.578514] trinity-child7 cpuset=/ mems_allowed=0
[  477.580774] Pid: 2500, comm: trinity-child7 Not tainted 3.8.0+ #87
[  477.583642] Call Trace:
[  477.584833]  [<ffffffff81c8bd86>] dump_header.isra.7+0x71/0x213
[  477.587843]  [<ffffffff810f5a45>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  477.590929]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[  477.593601]  [<ffffffff8134fe5c>] ? ___ratelimit+0x10c/0x150
[  477.596247]  [<ffffffff81154654>] oom_kill_process+0x84/0x360
[  477.598943]  [<ffffffff81155116>] out_of_memory+0x5d6/0x660
[  477.601816]  [<ffffffff8115a05b>] __alloc_pages_nodemask+0x6db/0x970
[  477.604720]  [<ffffffff8118f9af>] alloc_pages_vma+0xef/0x160
[  477.607367]  [<ffffffff81177b95>] handle_pte_fault+0x185/0x460
[  477.610071]  [<ffffffff81c9dd59>] ? __schedule+0x789/0x8a0
[  477.612579]  [<ffffffff811787c5>] handle_mm_fault+0x2b5/0x2e0
[  477.615226]  [<ffffffff8108a398>] __do_page_fault+0x478/0x4d0
[  477.617820]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[  477.620573]  [<ffffffff810d552a>] ? local_clock+0x4a/0x70
[  477.623063]  [<ffffffff810f1e98>] ? lock_release_holdtime+0x28/0x170
[  477.626025]  [<ffffffff8135721d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  477.629055]  [<ffffffff8108a419>] do_page_fault+0x9/0x10
[  477.631511]  [<ffffffff8108492c>] do_async_page_fault+0x4c/0xa0
[  477.634487]  [<ffffffff81ca01b8>] async_page_fault+0x28/0x30
[  477.637071] Mem-Info:
[  477.638161] Node 0 DMA per-cpu:
[  477.639699] CPU    0: hi:    0, btch:   1 usd:   0
[  477.642036] Node 0 DMA32 per-cpu:
[  477.643613] CPU    0: hi:  186, btch:  31 usd:  34
[  477.645821] active_anon:217462 inactive_anon:361 isolated_anon:0
[  477.645821]  active_file:73 inactive_file:0 isolated_file:0
[  477.645821]  unevictable:0 dirty:3 writeback:0 unstable:0
[  477.645821]  free:12229 slab_reclaimable:2287 slab_unreclaimable:9561
[  477.645821]  mapped:731 shmem:756 pagetables:1230 bounce:0
[  477.645821]  free_cma:0
[  477.660203] Node 0 DMA free:4644kB min:680kB low:848kB high:1020kB
active_anon:11212kB inactive_anon:0kB active_file:0kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15652kB managed:15908kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:4kB kernel_stack:0kB pagetables:48kB unstable:0kB
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[  477.678170] lowmem_reserve[]: 0 992 992 992
[  477.680585] Node 0 DMA32 free:44272kB min:44372kB low:55464kB
high:66556kB active_anon:858636kB inactive_anon:1444kB
active_file:292kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:1016056kB managed:975664kB mlocked:0kB
dirty:12kB writeback:0kB mapped:2924kB shmem:3024kB
slab_reclaimable:9148kB slab_unreclaimable:38240kB kernel_stack:848kB
pagetables:4872kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:5573 all_unreclaimable? yes
[  477.692000] lowmem_reserve[]: 0 0 0 0
[  477.693122] Node 0 DMA: 3*4kB (UM) 1*8kB (U) 1*16kB (M) 2*32kB (UM)
1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 2*1024kB (UM) 1*2048kB (R)
0*4096kB = 4644kB
[  477.697593] Node 0 DMA32: 78*4kB (UE) 131*8kB (UE) 50*16kB (UE)
12*32kB (UE) 12*64kB (UE) 22*128kB (UEM) 3*256kB (M) 3*512kB (UEM)
3*1024kB (UEM) 0*2048kB 8*4096kB (MR) = 44272kB
[  477.702411] 836 total pagecache pages
[  477.706467] 262126 pages RAM
[  477.707338] 13123 pages reserved
[  477.708179] 272373 pages shared
[  477.708962] 233728 pages non-shared
[  477.709854] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
oom_score_adj name
[  477.712234] [ 1371]     0  1371     7389      118      18        0
       -1000 systemd-udevd
[  477.714443] [ 1375]     0  1375    71983       75     144        0
           0 systemd-journal
[  477.716603] [ 1585]     0  1585     6523       65      19        0
           0 systemd-logind
[  477.719594] [ 1587]    81  1587     4843       63      14        0
        -900 dbus-daemon
[  477.723533] [ 1590]     0  1590     1585       31       9        0
           0 agetty
[  477.727782] [ 1593]     0  1593     2198       93      11        0
           0 dhcpcd
[  477.731608] [ 2003]     0  2003    15754      114      37        0
           0 login
[  477.735389] [ 2255]     0  2255     3503      105      12        0
           0 bash
[  477.738970] [ 2349]     0  2349     5501     1229       9        0
           0 trinity
[  477.742893] [ 2350]     0  2350     5501      582       8        0
           0 trinity-watchdo
[  477.747041] [ 2351]     0  2351     6041      583       8        0
           0 trinity-main
[  477.751137] [ 2492]     0  2492    65749    24274     100        0
           0 trinity-child2
[  477.755293] [ 2493]     0  2493    65511    24681     101        0
           0 trinity-child5
[  477.759457] [ 2496]     0  2496   138345    61616     246        0
           0 trinity-child6
[  477.763546] [ 2497]     0  2497    43900    11822      51        0
           0 trinity-child3
[  477.767423] [ 2499]     0  2499    87961    34964     141        0
           0 trinity-child0
[  477.771625] [ 2500]     0  2500    41151    10552      46        0
           0 trinity-child7
[  477.775719] [ 2533]     0  2533    34576     9140      41        0
           0 trinity-child1
[  477.779782] [ 2537]     0  2537     9944     2895      16        0
           0 trinity-child4
[  477.783880] Out of memory: Kill process 2496 (trinity-child6) score
218 or sacrifice child
[  477.787783] Killed process 2496 (trinity-child6) total-vm:553380kB,
anon-rss:244736kB, file-rss:1728kB
[watchdog] 317664 iterations. [F:311189 S:6463]
[2351] Random reseed: 1940626455
[watchdog] 319117 iterations. [F:312608 S:6497]
[watchdog] 320233 iterations. [F:313673 S:6548]
[watchdog] 322077 iterations. [F:315478 S:6587]
[  481.908683] program trinity-child6 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[watchdog] 324294 iterations. [F:317636 S:6646]
[  482.947541] program trinity-child0 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[watchdog] 325851 iterations. [F:319140 S:6699]
[  483.939344] program trinity-child1 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[watchdog] 326703 iterations. [F:319956 S:6735]
[watchdog] 326829 iterations. [F:320079 S:6736]
[  486.778940] trinity-child7 invoked oom-killer: gfp_mask=0x201da,
order=0, oom_score_adj=0
[  486.781105] trinity-child7 cpuset=/ mems_allowed=0
[  486.782406] Pid: 2500, comm: trinity-child7 Not tainted 3.8.0+ #87
[  486.783997] Call Trace:
[  486.784717]  [<ffffffff81c8bd86>] dump_header.isra.7+0x71/0x213
[  486.786237]  [<ffffffff810f5a45>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  486.788034]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[  486.789614]  [<ffffffff8134fe5c>] ? ___ratelimit+0x10c/0x150
[  486.791084]  [<ffffffff81154654>] oom_kill_process+0x84/0x360
[  486.792566]  [<ffffffff81155116>] out_of_memory+0x5d6/0x660
[  486.794087]  [<ffffffff8115a05b>] __alloc_pages_nodemask+0x6db/0x970
[  486.795707]  [<ffffffff8118fba4>] alloc_pages_current+0x124/0x150
[  486.797365]  [<ffffffff811506b7>] __page_cache_alloc+0xa7/0xc0
[  486.798935]  [<ffffffff81150db0>] ? __lock_page_or_retry+0xc0/0xc0
[  486.800543]  [<ffffffff8115140d>] filemap_fault+0x2ed/0x460
[  486.801975]  [<ffffffff81174e5f>] __do_fault+0xbf/0x420
[  486.803412]  [<ffffffff81177cca>] handle_pte_fault+0x2ba/0x460
[  486.804931]  [<ffffffff8108a0f4>] ? __do_page_fault+0x1d4/0x4d0
[  486.806503]  [<ffffffff811787c5>] handle_mm_fault+0x2b5/0x2e0
[  486.807988]  [<ffffffff8108a398>] __do_page_fault+0x478/0x4d0
[  486.809525]  [<ffffffff81c9f2cb>] ? _raw_spin_unlock_irq+0x2b/0x40
[  486.811149]  [<ffffffff810f5a45>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  486.812915]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[  486.814484]  [<ffffffff81c9f2cb>] ? _raw_spin_unlock_irq+0x2b/0x40
[  486.816148]  [<ffffffff810cc2d0>] ? finish_task_switch+0x80/0x120
[  486.817793]  [<ffffffff810cc293>] ? finish_task_switch+0x43/0x120
[  486.819363]  [<ffffffff8135721d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  486.821080]  [<ffffffff8108a419>] do_page_fault+0x9/0x10
[  486.822443]  [<ffffffff8108492c>] do_async_page_fault+0x4c/0xa0
[  486.824029]  [<ffffffff81ca01b8>] async_page_fault+0x28/0x30
[  486.825469] Mem-Info:
[  486.826125] Node 0 DMA per-cpu:
[  486.827044] CPU    0: hi:    0, btch:   1 usd:   0
[  486.828320] Node 0 DMA32 per-cpu:
[  486.829298] CPU    0: hi:  186, btch:  31 usd: 133
[  486.830584] active_anon:217391 inactive_anon:361 isolated_anon:0
[  486.830584]  active_file:1 inactive_file:31 isolated_file:0
[  486.830584]  unevictable:0 dirty:0 writeback:0 unstable:0
[  486.830584]  free:12236 slab_reclaimable:2287 slab_unreclaimable:9555
[  486.830584]  mapped:691 shmem:756 pagetables:1229 bounce:0
[  486.830584]  free_cma:0
[  486.838607] Node 0 DMA free:4644kB min:680kB low:848kB high:1020kB
active_anon:11120kB inactive_anon:0kB active_file:0kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15652kB managed:15908kB mlocked:0kB
dirty:0kB writeback:0kB mapped:16kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:4kB kernel_stack:0kB pagetables:44kB unstable:0kB
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:2
all_unreclaimable? yes
[  486.849502] lowmem_reserve[]: 0 992 992 992
[  486.850830] Node 0 DMA32 free:44300kB min:44372kB low:55464kB
high:66556kB active_anon:858444kB inactive_anon:1444kB active_file:4kB
inactive_file:124kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:1016056kB managed:975664kB mlocked:0kB
dirty:0kB writeback:0kB mapped:2748kB shmem:3024kB
slab_reclaimable:9148kB slab_unreclaimable:38216kB kernel_stack:840kB
pagetables:4872kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:341 all_unreclaimable? yes
[  486.861783] lowmem_reserve[]: 0 0 0 0
[  486.862887] Node 0 DMA: 1*4kB (U) 2*8kB (U) 1*16kB (M) 2*32kB (UM)
1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 2*1024kB (UM) 1*2048kB (R)
0*4096kB = 4644kB
[  486.867279] Node 0 DMA32: 87*4kB (UEM) 136*8kB (UEM) 49*16kB (UEM)
13*32kB (UEM) 13*64kB (UEM) 21*128kB (UEM) 3*256kB (M) 3*512kB (UEM)
3*1024kB (UEM) 0*2048kB 8*4096kB (MR) = 44300kB
[  486.872377] 794 total pagecache pages
[  486.876683] 262126 pages RAM
[  486.877585] 13123 pages reserved
[  486.878500] 272215 pages shared
[  486.879309] 233655 pages non-shared
[  486.880267] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
oom_score_adj name
[  486.882373] [ 1371]     0  1371     7389      118      18        0
       -1000 systemd-udevd
[  486.884631] [ 1375]     0  1375    71983       75     144        0
           0 systemd-journal
[  486.886883] [ 1585]     0  1585     6523       65      19        0
           0 systemd-logind
[  486.889186] [ 1587]    81  1587     4843       63      14        0
        -900 dbus-daemon
[  486.891378] [ 1590]     0  1590     1585       31       9        0
           0 agetty
[  486.893410] [ 1593]     0  1593     2198       93      11        0
           0 dhcpcd
[  486.895526] [ 2003]     0  2003    15754      114      37        0
           0 login
[  486.897544] [ 2255]     0  2255     3503      105      12        0
           0 bash
[  486.899659] [ 2349]     0  2349     5501     1229       9        0
           0 trinity
[  486.901953] [ 2350]     0  2350     5501      564       8        0
           0 trinity-watchdo
[  486.904343] [ 2351]     0  2351     6041      583       8        0
           0 trinity-main
[  486.906635] [ 2492]     0  2492    65749    24879     103        0
           0 trinity-child2
[  486.908967] [ 2493]     0  2493    65511    27279     111        0
           0 trinity-child5
[  486.911308] [ 2497]     0  2497    43900    13164      56        0
           0 trinity-child3
[  486.913591] [ 2499]     0  2499   153497    72982     290        0
           0 trinity-child0
[  486.915873] [ 2500]     0  2500    57535    24666     102        0
           0 trinity-child7
[  486.918174] [ 2533]     0  2533    34576    10248      45        0
           0 trinity-child1
[  486.920501] [ 2537]     0  2537    11267     3559      18        0
           0 trinity-child4
[  486.922828] [ 2548]     0  2548    26396     2947      17        0
           0 trinity-child6
[  486.925140] Out of memory: Kill process 2499 (trinity-child0) score
264 or sacrifice child
[  486.927347] Killed process 2499 (trinity-child0) total-vm:613988kB,
anon-rss:290360kB, file-rss:1568kB
[watchdog] 326835 iterations. [F:320085 S:6736]
[watchdog] 328990 iterations. [F:322191 S:6787]
[2351] Random reseed: 71022097
[watchdog] 330712 iterations. [F:323887 S:6813]
[  489.370176] program trinity-child0 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[watchdog] 332405 iterations. [F:325532 S:6861]
[  490.702103] program trinity-child6 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[  490.716089] ------------[ cut here ]------------
[  490.717030] WARNING: at
/home/ttrantal/git/linux-2.6/drivers/ata/libata-core.c:5049
ata_qc_issue+0x1c7/0x3a0()
[  490.717030] Hardware name: Bochs
[  490.717030] Pid: 2548, comm: trinity-child6 Not tainted 3.8.0+ #87
[  490.717030] Call Trace:
[  490.717030]  [<ffffffff81097b86>] warn_slowpath_common+0x86/0xb0
[  490.717030]  [<ffffffff81097c75>] warn_slowpath_null+0x15/0x20
[  490.717030]  [<ffffffff8150efd7>] ata_qc_issue+0x1c7/0x3a0
[  490.717030]  [<ffffffff81516550>] ? ata_scsi_set_sense.constprop.13+0x30/0x30
[  490.717030]  [<ffffffff815155c0>] ata_scsi_translate+0x120/0x190
[  490.717030]  [<ffffffff81518f4e>] ? ata_scsi_queuecmd+0x2e/0x2d0
[  490.717030]  [<ffffffff81519173>] ata_scsi_queuecmd+0x253/0x2d0
[  490.717030]  [<ffffffff814e3e91>] scsi_dispatch_cmd+0x161/0x230
[  490.717030]  [<ffffffff814e9fd4>] scsi_request_fn+0x544/0x580
...

Tommi
