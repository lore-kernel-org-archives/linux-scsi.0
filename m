From: Mel Gorman <mgorman@suse.de>
Subject: 3.7-rc8 boot failure due to recent workqueue-related patch
Date: Sat, 8 Dec 2012 20:35:24 +0000
Message-ID: <20121208203524.GA1009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 8852aac2 (workqueue: mod_delayed_work_on() shouldn't queue timer on
0 delay) is causing the following boot failure for me. Found by bisection
but no further analysis unfortunately until I get back home properly.
I've added the relevant maintainers for megasas and SCSI in case it's
somehow specific to that driver.

[   10.959999] ------------[ cut here ]------------
[   10.964751] WARNING: at kernel/workqueue.c:1363 __queue_delayed_work+0x170/0x180()
[   10.972496] Hardware name: PowerEdge R810
[   10.976618] Modules linked in: i7core_edac(+) pcspkr joydev ses(+) enclosure lpc_ich(+) ata_piix(+) mfd_core edac_core sg serio_raw dcdbas wmi gf128mul acpi_power_meter button microcode autofs4 processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh_emc scsi_dh ata_generic megaraid_sas pata_atiixp
[   11.006274] Pid: 0, comm: swapper/4 Not tainted 3.7.0-rc8-numacore-20121207 #1
[   11.013671] Call Trace:
[   11.016236]  <IRQ>  [<ffffffff8104752f>] warn_slowpath_common+0x7f/0xc0
[   11.023102]  [<ffffffff8104758a>] warn_slowpath_null+0x1a/0x20
[   11.029053]  [<ffffffff81066430>] __queue_delayed_work+0x170/0x180
[   11.035357]  [<ffffffff8108aee6>] ? trigger_load_balance+0x1b6/0x260
[   11.037184] ata_piix 0000:00:1f.2: setting latency timer to 64
[   11.037814] scsi1 : ata_piix
[   11.038015] scsi2 : ata_piix
[   11.038106] ata1: SATA max UDMA/133 cmd 0xece8 ctl 0xecf8 bmdma 0xecc0 irq 23
[   11.038112] ata2: SATA max UDMA/133 cmd 0xecf0 ctl 0xecfc bmdma 0xecc8 irq 23
[   11.068248]  [<ffffffff8106652d>] queue_delayed_work_on+0x4d/0x60
[   11.074459]  [<ffffffff8106657c>] queue_delayed_work+0x1c/0x20
[   11.080409]  [<ffffffff8106659b>] schedule_delayed_work+0x1b/0x20
[   11.086630]  [<ffffffffa000cb3e>] megasas_complete_cmd+0x54e/0x6f0 [megaraid_sas]
[   11.094292]  [<ffffffff8106f419>] ? enqueue_hrtimer+0x29/0xc0
[   11.100195]  [<ffffffffa000cd6f>] megasas_complete_cmd_dpc+0x8f/0xf0 [megaraid_sas]
[   11.108063]  [<ffffffff8105027a>] tasklet_action+0x6a/0xe0
[   11.113667]  [<ffffffff8104fd80>] __do_softirq+0xd0/0x260
[   11.119188]  [<ffffffff8159da5c>] call_softirq+0x1c/0x30
[   11.124626]  [<ffffffff81004715>] do_softirq+0x75/0xb0
[   11.129882]  [<ffffffff81050095>] irq_exit+0xb5/0xc0
[   11.134968]  [<ffffffff8159e153>] do_IRQ+0x63/0xe0
[   11.139880]  [<ffffffff8159522d>] common_interrupt+0x6d/0x6d
[   11.145653]  <EOI>  [<ffffffff8133017d>] ? intel_idle+0xed/0x150
[   11.151922]  [<ffffffff8133015e>] ? intel_idle+0xce/0x150
[   11.157442]  [<ffffffff8145e389>] cpuidle_enter+0x19/0x20
[   11.163017]  [<ffffffff8145ea57>] cpuidle_idle_call+0xa7/0x340
[   11.168972]  [<ffffffff8100bf0a>] cpu_idle+0x7a/0xf0
[   11.174060]  [<ffffffff81581995>] start_secondary+0x209/0x20b
[   11.179945] ---[ end trace 61c662a962be9ab7 ]---
[   11.184683] ------------[ cut here ]------------
[   11.189412] kernel BUG at kernel/workqueue.c:1364!
[   11.194316] invalid opcode: 0000 [#1] PREEMPT SMP 
[   11.199400] Modules linked in: i7core_edac pcspkr joydev ses(+) enclosure lpc_ich ata_piix mfd_core edac_core sg serio_raw dcdbas wmi gf128mul acpi_power_meter button microcode autofs4 processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh_emc scsi_dh ata_generic megaraid_sas pata_atiixp
[   11.228314] CPU 4 
[   11.230206] Pid: 0, comm: swapper/4 Tainted: G        W    3.7.0-rc8-numacore-20121207 #1 Dell Inc. PowerEdge R810/0TT6JF
[   11.241923] RIP: 0010:[<ffffffff810663f5>]  [<ffffffff810663f5>] __queue_delayed_work+0x135/0x180
[   11.251035] RSP: 0018:ffff88047f843db0  EFLAGS: 00010086
[   11.256463] RAX: 0000000000000000 RBX: ffff88046d0bc9c0 RCX: 0000000000000ead
[   11.263740] RDX: 0000000000002365 RSI: 0000000000000046 RDI: 0000000000000009
[   11.270987] RBP: ffff88047f843de0 R08: 0000000000000000 R09: 00000000000004e0
[   11.278235] R10: ffff8800000bc740 R11: 0000000000000960 R12: 0000000000000200
[   11.285486] R13: 0000000000000000 R14: ffff88086f852380 R15: 0000000000000297
[   11.292788] FS:  0000000000000000(0000) GS:ffff88047f840000(0000) knlGS:0000000000000000
[   11.301055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.306915] CR2: 00007f9b7fe65000 CR3: 0000000001a0c000 CR4: 00000000000007e0
[   11.314163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   11.321412] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   11.328685] Process swapper/4 (pid: 0, threadinfo ffff88046f60e000, task ffff88046f60c4c0)
[   11.337117] Stack:
[   11.339244]  ffffffff8108aee6 0000000000000086 ffff88086f4636c0 ffff88086f463c30
[   11.347091]  ffff88086f463c38 0000000000000297 ffff88047f843e00 ffffffff8106652d
[   11.354937]  0000000000000004 ffff88086f89e1c0 ffff88047f843e10 ffffffff8106657c
[   11.362763] Call Trace:
[   11.365318]  <IRQ> 
[   11.367293]  [<ffffffff8108aee6>] ? trigger_load_balance+0x1b6/0x260
[   11.374150]  [<ffffffff8106652d>] queue_delayed_work_on+0x4d/0x60
[   11.380362]  [<ffffffff8106657c>] queue_delayed_work+0x1c/0x20
[   11.386313]  [<ffffffff8106659b>] schedule_delayed_work+0x1b/0x20
[   11.392565]  [<ffffffffa000cb3e>] megasas_complete_cmd+0x54e/0x6f0 [megaraid_sas]
[   11.400231]  [<ffffffff8106f419>] ? enqueue_hrtimer+0x29/0xc0
[   11.406105]  [<ffffffffa000cd6f>] megasas_complete_cmd_dpc+0x8f/0xf0 [megaraid_sas]
[   11.413957]  [<ffffffff8105027a>] tasklet_action+0x6a/0xe0
[   11.419566]  [<ffffffff8104fd80>] __do_softirq+0xd0/0x260
[   11.425084]  [<ffffffff8159da5c>] call_softirq+0x1c/0x30
[   11.430516]  [<ffffffff81004715>] do_softirq+0x75/0xb0
[   11.435771]  [<ffffffff81050095>] irq_exit+0xb5/0xc0
[   11.440851]  [<ffffffff8159e153>] do_IRQ+0x63/0xe0
[   11.445759]  [<ffffffff8159522d>] common_interrupt+0x6d/0x6d
[   11.451526]  <EOI> 
[   11.453501]  [<ffffffff8133017d>] ? intel_idle+0xed/0x150
[   11.459417]  [<ffffffff8133015e>] ? intel_idle+0xce/0x150
[   11.464932]  [<ffffffff8145e389>] cpuidle_enter+0x19/0x20
[   11.470462]  [<ffffffff8145ea57>] cpuidle_idle_call+0xa7/0x340
[   11.476459]  [<ffffffff8100bf0a>] cpu_idle+0x7a/0xf0
[   11.481541]  [<ffffffff81581995>] start_secondary+0x209/0x20b
[   11.487455] Code: 85 74 ff ff ff 65 8b 3c 25 c4 b0 00 00 e9 67 ff ff ff 0f 1f 40 00 48 3b 52 48 0f 85 11 ff ff ff 66 0f 1f 44 00 00 e9 13 ff ff ff <0f> 0b 0f 0b 44 89 e6 4c 89 ff e8 5c 1c ff ff e9 7c ff ff ff e8 
[   11.510825] RIP  [<ffffffff810663f5>] __queue_delayed_work+0x135/0x180
[   11.517532]  RSP <ffff88047f843db0>
[   11.521138] ---[ end trace 61c662a962be9ab8 ]---
[   11.527550] Kernel panic - not syncing: Fatal exception in interrupt

-- 
Mel Gorman
SUSE Labs
