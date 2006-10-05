From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 04 Oct 2006 17:50:35 -0700
Message-ID: <452456DB.20407@us.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:63658 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751281AbWJEAuj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 20:50:39 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k950obSC029166
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:50:37 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k950oa5N541932
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 18:50:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k950oasG008939
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 18:50:36 -0600
In-Reply-To: <20061004164438.GC5091@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Muli Ben-Yehuda wrote:
> [resending as it probably hit the 100K limit the first time]
> 
> I'm seeing these aic94xx IO errors on an IBM x366, usually after I
> copy ~20GB but occasionally as soon as heavy IO starts. Happens with
> and without Calgary enabled (iommu=off). I'm seeing this on two
> different disks which badblocks claims are ok. The machine usually
> stays up and keeps chugging along after this happens.

I hit a real REQ_TASK_ABORT about five minutes into a pounder run.
Below is the serial log from what happened.  Muli, do you see something
like this?  (REQ_TASK_ABORT w/ reason code 0x6 (PROTOCOL ERROR)?)

I'm testing my experimental patch to feed these REQ_* errors up to
libsas; also note that there appear to be bugs in my implementation. :)

--D

[  862.993067] aic94xx: escb_tasklet_complete: phy0: REQ_TASK_ABORT(f0) tc: 16 stat: 6 dl->idx: 0
[  863.001658] aic94xx: escb_tasklet_complete: kicking ascb ffff810096953880 
[  863.047452] aic94xx: escb_tasklet_complete: kicking ascb ffff810096953880 

Suspicious that we try to fail this twice... looks like I have something to do tomorrow. :)

[  863.085458] ----------- [cut here ] --------- [please bite here ] ---------
[  863.092397] Kernel BUG at include/linux/mm.h:300
[  863.096998] invalid opcode: 0000 [1] PREEMPT SMP 
[  863.101714] CPU 0 
[  863.103725] Modules linked in: ext2 ext3 jbd mbcache acpi_cpufreq processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_onde
mand freq_table cpufreq_conservative dm_mod md_mod ipv6 sg sd_mod aic94xx libsas firmware_class scsi_transport_sas ide_cd cdrom ata_generic a
ta_piix generic serio_raw ahci ehci_hcd libata scsi_mod piix ide_core shpchp pci_hotplug uhci_hcd usbcore mousedev tsdev evdev unix
[  863.140063] Pid: 3838, comm: memxfer5b Not tainted 2.6.18-git4-dic94xx #104
[  863.147002] RIP: 0010:[<ffffffff8012e033>]  [<ffffffff8012e033>] __free_pages+0xb/0x32
[  863.154909] RSP: 0000:ffffffff80513d70  EFLAGS: 00010046
[  863.160203] RAX: 0000000000000000 RBX: ffff810098478000 RCX: 000000000000003f
[  863.167314] RDX: ffff81000000d000 RSI: 0000000000000000 RDI: ffff8100bf13e940
[  863.174426] RBP: ffffffff80513d70 R08: 0000000000000002 R09: ffffffff80115ab8
[  863.181538] R10: ffffffff80115ab8 R11: 00000000000f4240 R12: 0000000000000000
[  863.188650] R13: ffff8100ba048000 R14: ffff810096953880 R15: ffff8100ba126d08
[  863.195763] FS:  00002b3835d4c6d0(0000) GS:ffffffff808af000(0000) knlGS:0000000000000000
[  863.203827] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  863.209553] CR2: 00002ac0e3e27000 CR3: 00000000baea3000 CR4: 00000000000006e0
[  863.216666] Process memxfer5b (pid: 3838, threadinfo ffff810071e1c000, task ffff81003d284080)
[  863.225162] Stack:  ffffffff80513d90 ffffffff80135dd6 00000000000001c0 ffff810098478000
[  863.233186]  ffffffff80513db0 ffffffff8016fbc2 ffff8100ba759680 ffff810081ed9480
[  863.240594]  ffffffff80513de0 ffffffff88181965 0000000000000002 0000000000000006
[  863.247819] Call Trace:
[  863.250555]  [<ffffffff80135dd6>] free_pages+0x85/0x8a
[  863.255787]  [<ffffffff8016fbc2>] dma_free_coherent+0x41/0x46
[  863.261539]  [<ffffffff88181965>] :aic94xx:asd_unbuild_ssp_ascb+0x98/0xfa
[  863.268320]  [<ffffffff88182be3>] :aic94xx:asd_escb_tasklet_complete+0x2dc/0x465
[  863.275704]  [<ffffffff8817e3d8>] :aic94xx:escb_tasklet_complete+0x8d1/0xa25
[  863.282739]  [<ffffffff88173916>] :aic94xx:asd_dl_tasklet_handler+0xd0/0x103
[  863.289768]  [<ffffffff8018e03f>] tasklet_action+0x6d/0xc5
[  863.295294]  [<ffffffff80110837>] __do_softirq+0x6b/0xf6
[  863.300646]  [<ffffffff8015dae8>] call_softirq+0x1c/0x28
[  863.305950] DWARF2 unwinder stuck at call_softirq+0x1c/0x28
[  863.311503] Leftover inexact backtrace:
[  863.315323]  <IRQ> [<ffffffff8016c0d3>] do_softirq+0x36/0x9c
[  863.320983]  [<ffffffff8018de7c>] irq_exit+0x4e/0x5a
[  863.325933]  [<ffffffff8016c2fd>] do_IRQ+0xf4/0xfe
[  863.330710]  [<ffffffff8015cd46>] ret_from_intr+0x0/0xf
[  863.335917]  <EOI>
[  863.337938] 
[  863.337939] Code: 0f 0b 68 40 a6 37 80 c2 2c 01 f0 ff 4f 08 0f 94 c0 84 c0 74 
[  863.346801] RIP  [<ffffffff8012e033>] __free_pages+0xb/0x32
[  863.352365]  RSP <ffffffff80513d70>
[  863.356089]  <3>BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[  863.364077] in_atomic():1, irqs_disabled():1
[  863.368329] 
[  863.368330] Call Trace:
[  863.372338]  [<ffffffff8016af36>] show_trace+0xae/0x33a
[  863.377556]  [<ffffffff8016b3d9>] dump_stack+0x13/0x15
[  863.382686]  [<ffffffff8010b294>] __might_sleep+0xb3/0xb5
[  863.388112]  [<ffffffff8019ce3a>] down_read+0x1a/0x42
[  863.393225]  [<ffffffff80194c87>] blocking_notifier_call_chain+0x18/0x3d
[  863.399972]  [<ffffffff8018ba8a>] profile_task_exit+0x15/0x17
[  863.405755]  [<ffffffff80113c1c>] do_exit+0x25/0x9c6
[  863.410756]  [<ffffffff8016b41f>] kernel_math_error+0x0/0x96
[  863.416406]  [<ffff81003d284080>]
[  863.419711] DWARF2 unwinder stuck at 0xffff81003d284080
[  863.424917] Leftover inexact backtrace:
[  863.428737]  <IRQ> [<ffffffff80164e70>] do_trap+0xdb/0xea
[  863.434138]  [<ffffffff8016b8dc>] do_invalid_op+0xac/0xb8
[  863.439520]  [<ffffffff8012e033>] __free_pages+0xb/0x32
[  863.444731]  [<ffffffff80115c52>] release_console_sem+0x1e4/0x21e
[  863.450811]  [<ffffffff8018b8c2>] vprintk+0x2d8/0x333
[  863.455851]  [<ffffffff8015d5c1>] error_exit+0x0/0x96
[  863.460890]  [<ffffffff80115ab8>] release_console_sem+0x4a/0x21e
[  863.466878]  [<ffffffff80115ab8>] release_console_sem+0x4a/0x21e
[  863.472868]  [<ffffffff8012e033>] __free_pages+0xb/0x32
[  863.478080]  [<ffffffff80135dd6>] free_pages+0x85/0x8a
[  863.483205]  [<ffffffff8016fbc2>] dma_free_coherent+0x41/0x46
[  863.488941]  [<ffffffff88181965>] :aic94xx:asd_unbuild_ssp_ascb+0x98/0xfa
[  863.495715]  [<ffffffff88182be3>] :aic94xx:asd_escb_tasklet_complete+0x2dc/0x465
[  863.503100]  [<ffffffff8817e3d8>] :aic94xx:escb_tasklet_complete+0x8d1/0xa25
[  863.510133]  [<ffffffff8019f3f7>] trace_hardirqs_on+0xe6/0x124
[  863.515955]  [<ffffffff88173916>] :aic94xx:asd_dl_tasklet_handler+0xd0/0x103
[  863.522985]  [<ffffffff8018e03f>] tasklet_action+0x6d/0xc5
[  863.528455]  [<ffffffff80110837>] __do_softirq+0x6b/0xf6
[  863.533753]  [<ffffffff8015dae8>] call_softirq+0x1c/0x28
[  863.539050]  [<ffffffff8016c0d3>] do_softirq+0x36/0x9c
[  863.544173]  [<ffffffff8018de7c>] irq_exit+0x4e/0x5a
[  863.549122]  [<ffffffff8016c2fd>] do_IRQ+0xf4/0xfe
[  863.553899]  [<ffffffff8015cd46>] ret_from_intr+0x0/0xf
[  863.559106]  <EOI>
[  863.561147] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  863.567831]  <0>Rebooting in 30 seconds..
