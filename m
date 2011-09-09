From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
 / scsi_eh_0: page allocation failure: order:6, mode:0x20
Date: Fri, 09 Sep 2011 10:23:30 -0700
Message-ID: <4E6A4B92.9040306@xenotime.net>
References: <4E67CEF9.9090808@techboom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E67CEF9.9090808@techboom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: TB <lkml@techboom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/07/11 13:07, TB wrote:
> Please CC me as I am not subscribed to the mailing list.

[add linux-scsi mailing list]

> After this, the hard drives were inaccessible on the server and it had
> to be sys-rq rebooted.
> 
> Kernel: 3.0.0
> # gcc --version
> gcc (Debian 4.3.2-1.1) 4.3.2
> 
> 
> # as --version
> GNU assembler (GNU Binutils for Debian) 2.18.0.20080103
> This assembler was configured for a target of `x86_64-linux-gnu'.
> 
> 
> [138321.660418] aacraid: Host adapter abort request (0,0,0,0)
> [138321.660597] aacraid: Host adapter reset request. SCSI hang ?
> [138381.804920] aacraid: SCSI bus appears hung
> [138476.667838] scsi_eh_0: page allocation failure: order:6, mode:0x20
> [138476.667841] Pid: 1073, comm: scsi_eh_0 Not tainted 3.0.0 #1
> [138476.667843] Call Trace:
> [138476.667850]  [<ffffffff8108fd42>] ? warn_alloc_failed+0x112/0x127
> [138476.667854]  [<ffffffff8109049e>] ? __alloc_pages_nodemask+0x698/0x704
> [138476.667858]  [<ffffffff8108f3f1>] ? __get_free_pages+0x9/0x46
> [138476.667862]  [<ffffffff812fd9ea>] ? intel_alloc_coherent+0x83/0xdb
> [138476.667866]  [<ffffffff81387c35>] ? aac_fib_setup+0xf8/0x227
> [138476.667868]  [<ffffffff813879d5>] ? aac_init_adapter+0x7a9/0x7d7
> [138476.667871]  [<ffffffff8138c263>] ? aac_src_init+0x26b/0x3bb
> [138476.667875]  [<ffffffff810bdfc9>] ? add_partial+0x11/0x57
> [138476.667877]  [<ffffffff81388bf7>] ? _aac_reset_adapter+0x29e/0x465
> [138476.667880]  [<ffffffff81389c32>] ? aac_reset_adapter+0x10e/0x248
> [138476.667882]  [<ffffffff8138298e>] ? aac_eh_reset+0x154/0x17b
> [138476.667887]  [<ffffffff8136afe8>] ? scsi_try_host_reset+0x51/0xc5
> [138476.667889]  [<ffffffff8136c472>] ? scsi_eh_ready_devs+0x694/0x80e
> [138476.667892]  [<ffffffff8136cb52>] ? scsi_error_handler+0x3be/0x5c0
> [138476.667894]  [<ffffffff8136c794>] ? scsi_eh_get_sense+0x1a8/0x1a8
> [138476.667898]  [<ffffffff8104f09e>] ? kthread+0x7e/0x86
> [138476.667902]  [<ffffffff8159c6d4>] ? kernel_thread_helper+0x4/0x10
> [138476.667905]  [<ffffffff8104f020>] ? kthread_worker_fn+0x10d/0x10d
> [138476.667907]  [<ffffffff8159c6d0>] ? gs_change+0xb/0xb
> [138476.667908] Mem-Info:
> [138476.667910] Node 0 DMA per-cpu:
> [138476.667912] CPU    0: hi:    0, btch:   1 usd:   0
> [138476.667913] CPU    1: hi:    0, btch:   1 usd:   0
> [138476.667915] CPU    2: hi:    0, btch:   1 usd:   0
> [138476.667917] CPU    3: hi:    0, btch:   1 usd:   0
> [138476.667919] CPU    4: hi:    0, btch:   1 usd:   0
> [138476.667920] CPU    5: hi:    0, btch:   1 usd:   0
> [138476.667922] CPU    6: hi:    0, btch:   1 usd:   0
> [138476.667924] CPU    7: hi:    0, btch:   1 usd:   0
> [138476.667925] CPU    8: hi:    0, btch:   1 usd:   0
> [138476.667927] CPU    9: hi:    0, btch:   1 usd:   0
> [138476.667929] CPU   10: hi:    0, btch:   1 usd:   0
> [138476.667930] CPU   11: hi:    0, btch:   1 usd:   0
> [138476.667932] CPU   12: hi:    0, btch:   1 usd:   0
> [138476.667934] CPU   13: hi:    0, btch:   1 usd:   0
> [138476.667935] CPU   14: hi:    0, btch:   1 usd:   0
> [138476.667937] CPU   15: hi:    0, btch:   1 usd:   0
> [138476.667938] Node 0 DMA32 per-cpu:
> [138476.667940] CPU    0: hi:  186, btch:  31 usd: 180
> [138476.667942] CPU    1: hi:  186, btch:  31 usd: 157
> [138476.667944] CPU    2: hi:  186, btch:  31 usd:  47
> [138476.667946] CPU    3: hi:  186, btch:  31 usd: 181
> [138476.667947] CPU    4: hi:  186, btch:  31 usd:   0
> [138476.667949] CPU    5: hi:  186, btch:  31 usd:   0
> [138476.667951] CPU    6: hi:  186, btch:  31 usd:   0
> [138476.667952] CPU    7: hi:  186, btch:  31 usd:   0
> [138476.667954] CPU    8: hi:  186, btch:  31 usd: 162
> [138476.667956] CPU    9: hi:  186, btch:  31 usd: 166
> [138476.667957] CPU   10: hi:  186, btch:  31 usd: 164
> [138476.667959] CPU   11: hi:  186, btch:  31 usd: 176
> [138476.667961] CPU   12: hi:  186, btch:  31 usd:  24
> [138476.667962] CPU   13: hi:  186, btch:  31 usd:   0
> [138476.667964] CPU   14: hi:  186, btch:  31 usd:   0
> [138476.667966] CPU   15: hi:  186, btch:  31 usd:   0
> [138476.667967] Node 0 Normal per-cpu:
> [138476.667969] CPU    0: hi:  186, btch:  31 usd: 162
> [138476.667971] CPU    1: hi:  186, btch:  31 usd: 186
> [138476.667972] CPU    2: hi:  186, btch:  31 usd: 153
> [138476.667974] CPU    3: hi:  186, btch:  31 usd:  46
> [138476.667976] CPU    4: hi:  186, btch:  31 usd:  97
> [138476.667977] CPU    5: hi:  186, btch:  31 usd:  99
> [138476.667979] CPU    6: hi:  186, btch:  31 usd:  58
> [138476.667981] CPU    7: hi:  186, btch:  31 usd:   1
> [138476.667982] CPU    8: hi:  186, btch:  31 usd:  46
> [138476.667984] CPU    9: hi:  186, btch:  31 usd:  50
> [138476.667985] CPU   10: hi:  186, btch:  31 usd: 181
> [138476.667987] CPU   11: hi:  186, btch:  31 usd:  29
> [138476.667989] CPU   12: hi:  186, btch:  31 usd:   0
> [138476.667990] CPU   13: hi:  186, btch:  31 usd:  68
> [138476.667992] CPU   14: hi:  186, btch:  31 usd:  58
> [138476.667994] CPU   15: hi:  186, btch:  31 usd:   0
> [138476.667995] Node 1 Normal per-cpu:
> [138476.667997] CPU    0: hi:  186, btch:  31 usd:  99
> [138476.667999] CPU    1: hi:  186, btch:  31 usd: 172
> [138476.668001] CPU    2: hi:  186, btch:  31 usd: 110
> [138476.668002] CPU    3: hi:  186, btch:  31 usd:  52
> [138476.668004] CPU    4: hi:  186, btch:  31 usd: 157
> [138476.668006] CPU    5: hi:  186, btch:  31 usd:  65
> [138476.668008] CPU    6: hi:  186, btch:  31 usd:  78
> [138476.668010] CPU    7: hi:  186, btch:  31 usd: 173
> [138476.668011] CPU    8: hi:  186, btch:  31 usd:   0
> [138476.668013] CPU    9: hi:  186, btch:  31 usd:   0
> [138476.668014] CPU   10: hi:  186, btch:  31 usd:   8
> [138476.668016] CPU   11: hi:  186, btch:  31 usd:   1
> [138476.668018] CPU   12: hi:  186, btch:  31 usd: 157
> [138476.668020] CPU   13: hi:  186, btch:  31 usd:  84
> [138476.668021] CPU   14: hi:  186, btch:  31 usd:  91
> [138476.668023] CPU   15: hi:  186, btch:  31 usd: 165
> [138476.668028] active_anon:970040 inactive_anon:112827 isolated_anon:0
> [138476.668029]  active_file:3246082 inactive_file:3465017 isolated_file:35
> [138476.668030]  unevictable:945 dirty:23 writeback:94285 unstable:0
> [138476.668030]  free:227592 slab_reclaimable:128687
> slab_unreclaimable:56834
> [138476.668031]  mapped:4490 shmem:2843 pagetables:20763 bounce:0
> [138476.668033] Node 0 DMA free:15880kB min:40kB low:48kB high:60kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15656kB
> mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
> slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
> pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> all_unreclaimable? yes
> [138476.668043] lowmem_reserve[]: 0 2991 16121 16121
> [138476.668046] Node 0 DMA32 free:103184kB min:8344kB low:10428kB
> high:12516kB active_anon:574636kB inactive_anon:144044kB
> active_file:1032176kB inactive_file:1057608kB unevictable:384kB
> isolated(anon):0kB isolated(file):0kB present:3063520kB mlocked:384kB
> dirty:0kB writeback:17400kB mapped:48kB shmem:0kB
> slab_reclaimable:91152kB slab_unreclaimable:97176kB kernel_stack:1280kB
> pagetables:2628kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> [138476.668056] lowmem_reserve[]: 0 0 13130 13130
> [138476.668058] Node 0 Normal free:302680kB min:36632kB low:45788kB
> high:54948kB active_anon:1844360kB inactive_anon:184904kB
> active_file:4910564kB inactive_file:5760864kB unevictable:1300kB
> isolated(anon):0kB isolated(file):140kB present:13445120kB
> mlocked:1300kB dirty:28kB writeback:27132kB mapped:7096kB shmem:5172kB
> slab_reclaimable:193112kB slab_unreclaimable:63508kB kernel_stack:1880kB
> pagetables:58580kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:32 all_unreclaimable? no
> [138476.668069] lowmem_reserve[]: 0 0 0 0
> [138476.668071] Node 1 Normal free:489244kB min:45088kB low:56360kB
> high:67632kB active_anon:1461164kB inactive_anon:122360kB
> active_file:7041588kB inactive_file:7041092kB unevictable:2096kB
> isolated(anon):0kB isolated(file):0kB present:16547840kB mlocked:2096kB
> dirty:64kB writeback:332608kB mapped:10816kB shmem:6200kB
> slab_reclaimable:230484kB slab_unreclaimable:66652kB kernel_stack:776kB
> pagetables:21844kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:69 all_unreclaimable? no
> [138476.668082] lowmem_reserve[]: 0 0 0 0
> [138476.668084] Node 0 DMA: 0*4kB 1*8kB 0*16kB 0*32kB 2*64kB 1*128kB
> 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15880kB
> [138476.668091] Node 0 DMA32: 6456*4kB 4893*8kB 2133*16kB 134*32kB
> 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 103576kB
> [138476.668098] Node 0 Normal: 34828*4kB 10905*8kB 4332*16kB 211*32kB
> 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 303640kB
> [138476.668105] Node 1 Normal: 53146*4kB 21707*8kB 5935*16kB 264*32kB
> 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 489648kB
> [138476.668113] 6714269 total pagecache pages
> [138476.668114] 207 pages in swap cache
> [138476.668116] Swap cache stats: add 30314, delete 30107, find 48439/49664
> [138476.668117] Free swap  = 7975932kB
> [138476.668118] Total swap = 7999416kB
> [138476.777700] 8388592 pages RAM
> [138476.777702] 119966 pages reserved
> [138476.777703] 2963225 pages shared
> [138476.777704] 5620884 pages non-shared
> [138496.749132] aacraid: Host adapter abort request (0,0,0,0)
> [138506.733854] aacraid: Host adapter abort request (0,0,1,0)
> [138506.733917] aacraid: Host adapter reset request. SCSI hang ?
> [138506.734001] AAC: Host adapter BLINK LED 0x10
> [138506.734033] BUG: unable to handle kernel NULL pointer dereference at
>           (null)
> [138506.734092] IP: [<ffffffff810542ac>] exit_creds+0x12/0x78
> [138506.734131] PGD 42dd36067 PUD 42d47e067 PMD 0
> [138506.734174] Oops: 0000 [#1] SMP
> [138506.734210] CPU 10
> [138506.734219] Modules linked in: i2c_i801 evdev i2c_core button [last
> unloaded: scsi_wait_scan]
> [138506.734319]
> [138506.734342] Pid: 1073, comm: scsi_eh_0 Not tainted 3.0.0 #1
> Supermicro X8DTH-i/6/iF/6F/X8DTH
> [138506.734408] RIP: 0010:[<ffffffff810542ac>]  [<ffffffff810542ac>]
> exit_creds+0x12/0x78
> [138506.734463] RSP: 0000:ffff88042e9f7b30  EFLAGS: 00010287
> [138506.734493] RAX: 0000000000000000 RBX: ffff88042f491700 RCX:
> ffff88042fa19000
> [138506.734541] RDX: 0000000000000432 RSI: 0000000000000000 RDI:
> 0000000000000000
> [138506.734589] RBP: ffff88042f491700 R08: 000000000010c8c7 R09:
> 0000000000000000
> [138506.734637] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [138506.734685] R13: ffff88042fa19450 R14: ffff88042fa194b0 R15:
> ffff88042fa19000
> [138506.734733] FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000)
> knlGS:0000000000000000
> [138506.734783] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [138506.734814] CR2: 0000000000000000 CR3: 000000042e35e000 CR4:
> 00000000000006e0
> [138506.734862] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [138506.734910] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [138506.734959] Process scsi_eh_0 (pid: 1073, threadinfo
> ffff88042e9f6000, task ffff88042f492840)
> [138506.735010] Stack:
> [138506.735033]  ffff88042f491700 ffffffff81035758 ffff88042f491710
> ffffffff8104f21d
> [138506.735101]  ffff88042fa19000 0000000000000000 ffff88042fa19450
> ffffffff813889be
> [138506.735166]  ffff88042ea16f90 00000000000000ef 0000000000002002
> ffff88042fa19000
> [138506.735231] Call Trace:
> [138506.735259]  [<ffffffff81035758>] ? __put_task_struct+0x5d/0x83
> [138506.735291]  [<ffffffff8104f21d>] ? kthread_stop+0x7b/0xac
> [138506.735324]  [<ffffffff813889be>] ? _aac_reset_adapter+0x65/0x465
> [138506.735356]  [<ffffffff81389051>] ? aac_check_health+0x293/0x2f4
> [138506.735388]  [<ffffffff813828bb>] ? aac_eh_reset+0x81/0x17b
> [138506.735420]  [<ffffffff8136afe8>] ? scsi_try_host_reset+0x51/0xc5
> [138506.735452]  [<ffffffff8136bb8f>] ? scsi_send_eh_cmnd+0x225/0x28d
> [138506.735485]  [<ffffffff81042223>] ? del_timer_sync+0x34/0x3e
> [138506.735517]  [<ffffffff81599c31>] ? schedule_timeout+0x1dc/0x1fc
> [138506.735549]  [<ffffffff81042333>] ? del_timer+0xb1/0xb1
> [138506.735579]  [<ffffffff8136bc85>] ? scsi_eh_tur+0x28/0x78
> [138506.735609]  [<ffffffff8136bd32>] ? scsi_eh_test_devices+0x5d/0x109
> [138506.735641]  [<ffffffff8136c552>] ? scsi_eh_ready_devs+0x774/0x80e
> [138506.735673]  [<ffffffff8136cb52>] ? scsi_error_handler+0x3be/0x5c0
> [138506.735705]  [<ffffffff8136c794>] ? scsi_eh_get_sense+0x1a8/0x1a8
> [138506.735736]  [<ffffffff8104f09e>] ? kthread+0x7e/0x86
> [138506.735768]  [<ffffffff8159c6d4>] ? kernel_thread_helper+0x4/0x10
> [138506.735800]  [<ffffffff8104f020>] ? kthread_worker_fn+0x10d/0x10d
> [138506.735832]  [<ffffffff8159c6d0>] ? gs_change+0xb/0xb
> [138506.743720] Code: ff 4d 00 0f 94 c0 84 c0 74 08 48 89 ef e8 60 fd ff
> ff 31 c0 5b 5d 41 5c c3 53 48 89 fb 48 8b 87 00 03 00 00 48 8b bf f8 02
> 00 00 <8b> 00 48 c7 83 f8 02 00 00 00 00 00 00 f0 ff 0f 0f 94 c0 84 c0
> [138506.744099] RIP  [<ffffffff810542ac>] exit_creds+0x12/0x78
> [138506.744134]  RSP <ffff88042e9f7b30>
> [138506.744160] CR2: 0000000000000000
> [138506.744743] ---[ end trace 82be210c3648ecce ]---
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
