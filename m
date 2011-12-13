From: "Nadolski, Edmund" <edmund.nadolski@intel.com>
Subject: RE: 3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
 (__scsi_queue_insert)
Date: Tue, 13 Dec 2011 15:04:56 -0700
Message-ID: <9EECC02A4CC333418C00A85D21E8932614C3E59BDD@azsmsx502.amr.corp.intel.com>
References: <alpine.SOC.1.00.1111231223090.15939@math.ut.ee>
 <alpine.SOC.1.00.1112131603130.28063@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1112131603130.28063@math.ut.ee>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Linux Kernel list <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Meelis
> Roos
> Sent: Tuesday, December 13, 2011 7:04 AM
> To: Linux Kernel list; linux-scsi@vger.kernel.org
> Subject: Re: 3.2-rc2+git: kernel BUG at block/blk-core.c:1000! (__scsi_queue_insert)
> 
> Any hope of somebody looking into it? It's still present and
> reproducible in 3.2-rc5.
> 
> > Hello,
> >
> > While trying 3.2.0-rc2-00143-ga767835 on Sun Ultra 10 (sparc64) with
> > Adaptec SCSI controller, I can consistently get the below BUG shortly
> > after bootup. Another machine, Sun Ultra 5 with IDE disk, works fine
> > (config might also differ in other details than ide/scsi).
...
> > kernel BUG at block/blk-core.c:1000!
> >               \|/ ____ \|/
> >               "@'/ .. \`@"
> >               /_| \__/ |_\
> >                  \__U_/
> > swapper(0): Kernel bad sw trap 5 [#1]
> > TSTATE: 0000008080e01602 TPC: 00000000005c3380 TNPC: 00000000005c3384 Y: 00000000    Not tainted
> > TPC: <blk_requeue_request+0x60/0x80>
> > g0: 0000000000000003 g1: 0000000000872000 g2: 0000000000000001 g3: ffffffffffffffd8
> > g4: 0000000000869b50 g5: f7ddef20f7767b60 g6: 0000000000860000 g7: 0000000000001000
> > o0: 0000000000000028 o1: 0000000000816440 o2: 00000000000003e8 o3: 00000000ffffa86e
> > o4: fffff8001f00cb60 o5: 0000000000816440 sp: fffff8001fefb471 ret_pc: 00000000005c3378
> > RPC: <blk_requeue_request+0x58/0x80>
> > l0: 00000000fffc00f0 l1: 0000000000883790 l2: 0000000000000001 l3: fffff8001f0060c0
> > l4: fffff8001f0020c0 l5: 0000000000000000 l6: 00000000008a2e18 l7: fffffffffffffff8
> > i0: fffff8001f2d3100 i1: fffff8001f329a20 i2: 000000000091d56c i3: 000000000091d400
> > i4: 0000000000000001 i5: 0000000000000000 i6: fffff8001fefb521 i7: 000000000065dc10
> > I7: <__scsi_queue_insert+0xb0/0x100>
> > Call Trace:
> >  [000000000065dc10] __scsi_queue_insert+0xb0/0x100
> >  [00000000005c812c] blk_done_softirq+0x6c/0xa0
> >  [000000000045a530] __do_softirq+0x90/0x120
> >  [000000000042b054] do_softirq+0x74/0xa0
> >  [000000000045a82c] irq_exit+0x8c/0xa0
> >  [000000000042af9c] handler_irq+0x9c/0xe0
> >  [00000000004208b4] tl0_irq5+0x14/0x20
> >  [0000000000439484] touch_nmi_watchdog+0x4/0x40
> >  [00000000008a8788] start_kernel+0x318/0x328
> >  [000000000074af88] tlb_fixup_done+0x80/0x88
> >  [0000000000000000]           (null)

I see similar to this using 3.2.0-rc5+ on x86_64 with one SAS drive
on an Intel C600.  It hits every time I run mkfs.  Stack shown
below. Running 'git bisect' leads to this:

commit b4fdcb02f1e39c27058a885905bd0277370ba441
Merge: 044595d 6dd9ad7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Nov 4 17:06:58 2011 -0700

    Merge branch 'for-3.2/core' of git://git.kernel.dk/linux-block

I see the failure with git reset --hard b4fdcb0, but it does not
occur with git reset --hard 6dd9ad7 or git reset --hard 044595d.

Any thoughts on what I can try next?

Thanks,
Ed

[root@scutest0 ~]# mkfs -t ext3 /dev/sdb1
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
8978432 inodes, 35909283 blocks
1795464 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
1096 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: [  122.752553] ------------[ cut here ]------------
[  122.757713] kernel BUG at block/blk-core.c:1000!
[  122.762863] invalid opcode: 0000 [#1] SMP
[  122.767465] CPU 8
[  122.769518] Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 uinput iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core ioatdma dca isci libsas scsi_transport_sas [last unloaded: scsi_wait_scan]
[  122.790910]
[  122.792578] Pid: 0, comm: swapper/8 Not tainted 3.2.0-rc5+ #2 Intel Corporation S2600CP/S2600CP
[  122.802322] RIP: 0010:[<ffffffff81267e81>]  [<ffffffff81267e81>] blk_requeue_request+0x6b/0x82
[  122.811962] RSP: 0018:ffff88083fa03dd0  EFLAGS: 00010006
[  122.817885] RAX: 0000000000000000 RBX: ffff880766890b00 RCX: ffff88083fa03dc0
[  122.825844] RDX: ffff8808205c2bd0 RSI: ffff880766890b00 RDI: ffff880422f694c0
[  122.833810] RBP: ffff88083fa03df0 R08: ffff880766890c30 R09: 0000000000000001
[  122.841769] R10: 0000000000000000 R11: ffff880422f69b20 R12: ffff880823217000
[  122.849735] R13: ffff880422f694c0 R14: ffff880422f694c0 R15: ffff880423a5f000
[  122.857695] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS:0000000000000000
[  122.866719] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  122.873128] CR2: 00000000008a9000 CR3: 000000081818c000 CR4: 00000000000406e0
[  122.881101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  122.889061] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  122.897021] Process swapper/8 (pid: 0, threadinfo ffff880425fbc000, task ffff880425fb5f40)
[  122.906247] Stack:
[  122.908489]  ffffffff813547e0 0000000000000282 ffff880823217000 ffff880423a5e000
[  122.916792]  ffff88083fa03e40 ffffffff813547f3 ffff88083fa03e30 ffff880423432028
[  122.925087]  ffff880766978d80 ffff880823217000 0000000000002006 0000000000007530
[  122.933383] Call Trace:
[  122.936122]  <IRQ>
[  122.938484]  [<ffffffff813547e0>] ? __scsi_queue_insert+0xc9/0x10b
[  122.945386]  [<ffffffff813547f3>] __scsi_queue_insert+0xdc/0x10b
[  122.952086]  [<ffffffff81354cce>] scsi_queue_insert+0x13/0x15
[  122.958495]  [<ffffffff81354db7>] scsi_softirq_done+0xe7/0x108
[  122.965018]  [<ffffffff8126d5b4>] blk_done_softirq+0x84/0x98
[  122.971340]  [<ffffffff810566c5>] __do_softirq+0xe3/0x1d5
[  122.977392]  [<ffffffff81511c67>] ? _raw_spin_lock+0x39/0x40
[  122.983713]  [<ffffffff810b36e2>] ? handle_irq_event+0x4f/0x65
[  122.990230]  [<ffffffff8151b3fc>] call_softirq+0x1c/0x30
[  122.996167]  [<ffffffff81010b5f>] do_softirq+0x4b/0xa3
[  123.001888]  [<ffffffff810563e5>] irq_exit+0x53/0xca
[  123.007433]  [<ffffffff8151bd0d>] do_IRQ+0x9d/0xb4
[  123.012790]  [<ffffffff815125b3>] common_interrupt+0x73/0x73
[  123.019101]  <EOI>
[  123.021467]  [<ffffffff8107bc7f>] ? tick_nohz_stop_sched_tick+0x31c/0x361
[  123.029057]  [<ffffffff810169d7>] ? mwait_idle+0xa1/0xde
[  123.034981]  [<ffffffff810169ce>] ? mwait_idle+0x98/0xde
[  123.040905]  [<ffffffff8100ee58>] cpu_idle+0xca/0x108
[  123.046550]  [<ffffffff81509796>] start_secondary+0x255/0x257
[  123.052960] Code: 48 89 da 4c 89 ee 41 ff 14 24 49 83 c4 10 49 83 3c 24 00 eb e4 f6 43 42 08 74 0b 48 89 de 4c 89 ef e8 35 20 00 00 48 39 1b 74 04 <0f> 0b eb fe 48 89 de 4c 89 ef e8 1b bb ff ff 5e 5b 41 5c 41 5d
[  123.074691] RIP  [<ffffffff81267e81>] blk_requeue_request+0x6b/0x82
[  123.081700]  RSP <ffff88083fa03dd0>
[  123.085598] ---[ end trace ebaf24a04fa3b80a ]---
[  123.090747] Kernel panic - not syncing: Fatal exception in interrupt
[  123.097833] Pid: 0, comm: swapper/8 Tainted: G      D      3.2.0-rc5+ #2
[  123.105309] Call Trace:
[  123.108034]  <IRQ>  [<ffffffff8150f58b>] panic+0x91/0x1b2
[  123.114079]  [<ffffffff81513332>] oops_end+0xb7/0xc7
[  123.119616]  [<ffffffff81011b5e>] die+0x5a/0x63
[  123.124670]  [<ffffffff81512ff0>] do_trap+0x121/0x130
[  123.130305]  [<ffffffff8100ffcb>] do_invalid_op+0x94/0x9d
[  123.136327]  [<ffffffff81267e81>] ? blk_requeue_request+0x6b/0x82
[  123.143141]  [<ffffffff81284a3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  123.150423]  [<ffffffff815126a4>] ? restore_args+0x30/0x30
[  123.156555]  [<ffffffff8151b17b>] invalid_op+0x1b/0x20
[  123.162286]  [<ffffffff81267e81>] ? blk_requeue_request+0x6b/0x82
[  123.169084]  [<ffffffff813547e0>] ? __scsi_queue_insert+0xc9/0x10b
[  123.175979]  [<ffffffff813547f3>] __scsi_queue_insert+0xdc/0x10b
[  123.182681]  [<ffffffff81354cce>] scsi_queue_insert+0x13/0x15
[  123.189092]  [<ffffffff81354db7>] scsi_softirq_done+0xe7/0x108
[  123.195598]  [<ffffffff8126d5b4>] blk_done_softirq+0x84/0x98
[  123.201911]  [<ffffffff810566c5>] __do_softirq+0xe3/0x1d5
[  123.207932]  [<ffffffff81511c67>] ? _raw_spin_lock+0x39/0x40
[  123.214244]  [<ffffffff810b36e2>] ? handle_irq_event+0x4f/0x65
[  123.220758]  [<ffffffff8151b3fc>] call_softirq+0x1c/0x30
[  123.226691]  [<ffffffff81010b5f>] do_softirq+0x4b/0xa3
[  123.232422]  [<ffffffff810563e5>] irq_exit+0x53/0xca
[  123.237958]  [<ffffffff8151bd0d>] do_IRQ+0x9d/0xb4
[  123.243303]  [<ffffffff815125b3>] common_interrupt+0x73/0x73
[  123.249621]  <EOI>  [<ffffffff8107bc7f>] ? tick_nohz_stop_sched_tick+0x31c/0x361
[  123.257883]  [<ffffffff810169d7>] ? mwait_idle+0xa1/0xde
[  123.263808]  [<ffffffff810169ce>] ? mwait_idle+0x98/0xde
[  123.269741]  [<ffffffff8100ee58>] cpu_idle+0xca/0x108
[  123.275376]  [<ffffffff81509796>] start_secondary+0x255/0x257
