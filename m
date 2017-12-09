From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198111] New: watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
 [swapper/0:0] [libahci]
Date: Sat, 09 Dec 2017 17:45:48 +0000
Message-ID: <bug-198111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32936 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750998AbdLIRpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2017 12:45:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 75CFC28FB3
        for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2017 17:45:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198111

            Bug ID: 198111
           Summary: watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
                    [swapper/0:0] [libahci]
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.14.3-1.el6.elrepo.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: svimik@gmail.com
        Regression: No

>From 'libahci' and scsi_* functions I guess this bug goes to 'IO/Storage'.
Correct me if I'm wrong.

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
Modules linked in: sch_fq_codel tcp_westwood des_generic authenc echainiv
xfrm4_mode_transport cbc drbg ansi_cprng seqiv xfrm6_mode_tunnel
xfrm4_mode_tunnel ctr ghash_generic gf128mul cryptd gcm arc4 ecb ppp_mppe
xt_set xt_multiport ip_set_hash_ip ip_set_hash_net ip_set nfnetlink ts_kmp
ipt_REJECT nf_reject_ipv4 xt_connlimit xt_conntrack xt_hashlimit nf_log_ipv4
nf_log_common xt_LOG xt_mark xt_nat ts_bm xt_string xt_TCPMSS iptable_mangle
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat arptable_filter
arp_tables ebtable_filter ebtables tun l2tp_ppp l2tp_core udp_tunnel
ip6_udp_tunnel pptp pppox ppp_generic slhc gre xfrm4_tunnel tunnel4 ipcomp
xfrm_ipcomp esp4 ah4 af_key netconsole configfs iptable_filter ip_tables
ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6
xt_state nf_conntrack libcrc32c ip6table_filter ip6_tables ppdev parport_pc
parport pcspkr qemu_fw_cfg joydev input_leds shpchp e1000 virtio_balloon
i2c_piix4 sg ext4 jbd2 mbcache sr_mod cdrom sd_mod pata_acpi ata_generic
ata_piix ahci libahci virtio_pci virtio_ring virtio floppy bochs_drm ttm
dm_mirror dm_region_hash dm_log dm_mod dax
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.3-1.el6.elrepo.x86_64 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
task: ffffffff81e104c0 task.stack: ffffffff81e00000
RIP: 0010:_raw_spin_unlock_irqrestore+0x11/0x20
RSP: 0018:ffff88013fc03a48 EFLAGS: 00000292 ORIG_RAX: ffffffffffffff10
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880134d0c018
RDX: 0000000000000000 RSI: 0000000000000292 RDI: 0000000000000292
RBP: ffff88013fc03a48 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000009 R12: ffff88007f884160
R13: ffff880134d9c000 R14: 0000000000000292 R15: ffff88007f884160
FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f90fd313000 CR3: 0000000137f44000 CR4: 00000000000006f0
Call Trace:
<IRQ>
ata_scsi_queuecmd+0xb2/0x270
scsi_dispatch_cmd+0xbb/0x270
? blk_queue_start_tag+0xa9/0x1c0
? cfq_rb_erase+0x2d/0x50
scsi_request_fn+0x544/0x730
? cfq_prio_tree_add+0xb7/0xc0
? free_request_size+0x2d/0x40
? kvm_clock_read+0x1e/0x20
? __freed_request+0xab/0xc0
? freed_request+0x45/0x70
__blk_run_queue+0x4c/0x70
blk_run_queue+0x3a/0x60
scsi_run_queue+0x7e/0x90
scsi_end_request+0x16c/0x210
? kvm_clock_get_cycles+0x9/0x10
? native_apic_msr_write+0x32/0x40
? lapic_next_event+0x1d/0x30
scsi_io_completion+0xdf/0x670
? hrtimer_interrupt+0x10f/0x1d0
scsi_finish_command+0x112/0x170
? smp_apic_timer_interrupt+0x7d/0x140
? do_IRQ+0x60/0xf0
scsi_softirq_done+0x132/0x150
blk_done_softirq+0x9f/0xc0
__do_softirq+0xe2/0x2ec
? handle_irq_event+0x4b/0x70
? handle_edge_irq+0x77/0x120
irq_exit+0xbc/0xd0
do_IRQ+0x60/0xf0
common_interrupt+0x93/0x93
</IRQ>
RIP: 0010:native_safe_halt+0x6/0x10
RSP: 0018:ffffffff81e03dc8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffbe
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88013fc12020
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff81e03dc8 R08: ffff880135335088 R09: ffffc9000088bdb8
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff81e104c0 R14: 0000000000000000 R15: 0000000000000000
default_idle+0x29/0x110
? sched_clock+0x9/0x10
? sched_clock_cpu+0x22/0xc0
arch_cpu_idle+0xf/0x20
default_idle_call+0x23/0x40
cpuidle_idle_call+0xcb/0x160
do_idle+0x85/0xd0
cpu_startup_entry+0x68/0x70
rest_init+0xae/0xb0
start_kernel+0x40c/0x415
? set_init_arg+0x63/0x63
x86_64_start_reservations+0x2a/0x2c
x86_64_start_kernel+0x77/0x7b
secondary_startup_64+0xa5/0xa5
Code: ba 01 00 00 00 f0 0f b1 17 85 c0 75 04 b0 01 c9 c3 31 c0 c9 c3 0f 1f 44
00 00 55 48 89 e5 0f 1f 44 00 00 c6 07 00 48 89 f7 57 9d <0f> 1f 44 00 00 c9 c3
0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f
Kernel panic - not syncing: softlockup: hung tasks
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 
4.14.3-1.el6.elrepo.x86_64 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
Call Trace:
<IRQ>
dump_stack+0x67/0x98
panic+0xd2/0x236
watchdog_timer_fn+0x219/0x230
__run_hrtimer+0x77/0x1b0
? kfree_skbmem+0x2b/0x70
? watchdog+0x30/0x30
? internal_add_timer+0x23/0xb0
? kvm_clock_read+0x1e/0x20
? kvm_clock_get_cycles+0x9/0x10
__hrtimer_run_queues+0x67/0x90
? __fprop_inc_percpu_max+0x5d/0x90
hrtimer_interrupt+0xa4/0x1d0
? wb_domain_writeout_inc+0x4c/0x50
smp_apic_timer_interrupt+0x6b/0x140
? swiotlb_map_sg_attrs+0x5a/0x110
? ahci_qc_prep+0xb2/0x180 [libahci]
apic_timer_interrupt+0x93/0xa0
RIP: 0010:_raw_spin_unlock_irqrestore+0x11/0x20
RSP: 0018:ffff88013fc03a48 EFLAGS: 00000292 ORIG_RAX: ffffffffffffff10
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880134d0c018
RDX: 0000000000000000 RSI: 0000000000000292 RDI: 0000000000000292
RBP: ffff88013fc03a48 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000009 R12: ffff88007f884160
R13: ffff880134d9c000 R14: 0000000000000292 R15: ffff88007f884160
ata_scsi_queuecmd+0xb2/0x270
scsi_dispatch_cmd+0xbb/0x270
? blk_queue_start_tag+0xa9/0x1c0
? cfq_rb_erase+0x2d/0x50
scsi_request_fn+0x544/0x730
? cfq_prio_tree_add+0xb7/0xc0
? free_request_size+0x2d/0x40
? kvm_clock_read+0x1e/0x20
? __freed_request+0xab/0xc0
? freed_request+0x45/0x70
__blk_run_queue+0x4c/0x70
blk_run_queue+0x3a/0x60
scsi_run_queue+0x7e/0x90
scsi_end_request+0x16c/0x210
? kvm_clock_get_cycles+0x9/0x10
? native_apic_msr_write+0x32/0x40
? lapic_next_event+0x1d/0x30
scsi_io_completion+0xdf/0x670
? hrtimer_interrupt+0x10f/0x1d0
scsi_finish_command+0x112/0x170
? smp_apic_timer_interrupt+0x7d/0x140
? do_IRQ+0x60/0xf0
scsi_softirq_done+0x132/0x150
blk_done_softirq+0x9f/0xc0
__do_softirq+0xe2/0x2ec
? handle_irq_event+0x4b/0x70
? handle_edge_irq+0x77/0x120
irq_exit+0xbc/0xd0
do_IRQ+0x60/0xf0
common_interrupt+0x93/0x93
</IRQ>
RIP: 0010:native_safe_halt+0x6/0x10
RSP: 0018:ffffffff81e03dc8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffbe
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88013fc12020
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff81e03dc8 R08: ffff880135335088 R09: ffffc9000088bdb8
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff81e104c0 R14: 0000000000000000 R15: 0000000000000000
default_idle+0x29/0x110
? sched_clock+0x9/0x10
? sched_clock_cpu+0x22/0xc0
arch_cpu_idle+0xf/0x20
default_idle_call+0x23/0x40
cpuidle_idle_call+0xcb/0x160
do_idle+0x85/0xd0
cpu_startup_entry+0x68/0x70
rest_init+0xae/0xb0
start_kernel+0x40c/0x415
? set_init_arg+0x63/0x63
x86_64_start_reservations+0x2a/0x2c
x86_64_start_kernel+0x77/0x7b
secondary_startup_64+0xa5/0xa5
Kernel Offset: disabled
Rebooting in 2 seconds..

-- 
You are receiving this mail because:
You are the assignee for the bug.
