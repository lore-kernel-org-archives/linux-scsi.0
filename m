From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196191] New: NULL pointer dereference at
 beiscsi_process_cq+0x6f6
Date: Sun, 25 Jun 2017 18:30:26 +0000
Message-ID: <bug-196191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33114 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751244AbdFYSae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Jun 2017 14:30:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6265A2861F
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2017 18:30:33 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196191

            Bug ID: 196191
           Summary: NULL pointer dereference at beiscsi_process_cq+0x6f6
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.9.30-2~bpo8+1 (Debian)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: wferi@niif.hu
        Regression: No

An iSCSI-booted server occasionally halts with following console log during
bootup:

    [  OK  ] Reached target Network is Online.
             Starting LSB: Starts and stops the iSCSI initiator s...ault
targets...
    [  214.044354] iscsi: registered transport (tcp)
    [  214.316086] iscsi: registered transport (iser)
    [  217.293303] hb: link status definitely up for interface enp5s0f5, 200
Mbps full duplex
    [  217.709239] cloud: link status definitely up for interface enp5s0f7,
10000 Mbps full duplex
    [  218.438152] BUG: unable to handle kernel NULL pointer dereference at    
      (null)
    [  218.463932] IP: [<ffffffffc05c5256>] beiscsi_process_cq+0x6f6/0xa00
[be2iscsi]
    [  218.487703] PGD 0 [  218.493722] 
    [  218.498607] Oops: 0000 [#1] SMP
    [  218.508917] Modules linked in: ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp bonding ext4 crc16 jbd2 crc32c_generic fscrypto ecb
mbcache intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate joydev iTCO_wdt iTCO_vendor_support evdev
intel_uncore mgag200 ttm drm_kms_helper pcspkr mei_me intel_rapl_perf drm
lpc_ich i2c_algo_bit mei mfd_core shpchp wmi ac button acpi_pad
acpi_power_meter ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ipmi_watchdog ip6_tables ipt_REJECT
nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_tcpudp nf_log_ipv4
nf_log_common xt_LOG xt_limit xt_recent xt_multiport xt_conntrack ipmi_si
nf_conntrack ipmi_poweroff iptable_filter ipmi_devintf ip_tables
ipmi_msghandler x_tables configfs autofs4 xfs libcrc32c dm_service_time
dm_multipath dm_mod sg sd_mod hid_generic usbhid hid be2iscsi crc32c_intel
libiscsi ehci_pci aesni_intel aes_x86_64 scsi_transport_iscsi glue_helper
ehci_hcd iscsi_boot_sysfs lrw gf128mul ablk_helper i2c_i801 cryptd usbcore
i2c_smbus usb_common scsi_mod be2net
    [  218.847642] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
4.9.0-0.bpo.3-amd64 #1 Debian 4.9.30-2~bpo8+1
    [  218.877399] Hardware name: FUJITSU PRIMERGY BX924 S4/D3143-B1, BIOS
V4.6.5.4 R1.13.0 for D3143-B1x 07/16/2015
    [  218.910016] task: ffffffffb640e540 task.stack: ffffffffb6400000
    [  218.929476] RIP: 0010:[<ffffffffc05c5256>]  [<ffffffffc05c5256>]
beiscsi_process_cq+0x6f6/0xa00 [be2iscsi]
    [  218.961249] RSP: 0000:ffff95bfbfa03e48  EFLAGS: 00010297
    [  218.978707] RAX: ffff95bfb5100e00 RBX: 0000000000000001 RCX:
0000000000000005
    [  219.002171] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
ffff95bfb532d504
    [  219.025636] RBP: 0000000000000001 R08: 0000000003fb0001 R09:
0000000000011bcd
    [  219.049097] R10: 00000000594e5a87 R11: ffff95bfb551fd18 R12:
ffff95bfb2822208
    [  219.072562] R13: 0000000000000005 R14: ffff95bfb2818810 R15:
ffff95bfb2557d40
    [  219.096026] FS:  0000000000000000(0000) GS:ffff95bfbfa00000(0000)
knlGS:0000000000000000
    [  219.122634] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  219.141521] CR2: 0000000000000000 CR3: 00000017c5a07000 CR4:
00000000001406f0
    [  219.164986] Stack:
    [  219.171579]  0000000080202f00 0000000ab86fc200 ffff95bfb2818d70
ffff95bfb87000e2
    [  219.195943]  ffff95bfb532d504 ffff95bfb5100e00 ffff95bfb551fd18
01ff95bf00011bcd
    [  219.220310]  00000000000000fe 0000000000000000 ffff95bf00008100
ffff95bfb86fa018
    [  219.244675] Call Trace:
    [  219.252699]  <IRQ> [  219.259008]  [<ffffffffc05c5628>] ?
be_iopoll+0xc8/0x170 [be2iscsi]
    [  219.279627]  [<ffffffffb5b58d64>] ? irq_poll_softirq+0xa4/0xd0
    [  219.298813]  [<ffffffffb5e0a2e6>] ? __do_softirq+0x106/0x292
    [  219.317430]  [<ffffffffb587dbe8>] ? irq_exit+0x98/0xa0
    [  219.334317]  [<ffffffffb5e0a02f>] ? do_IRQ+0x4f/0xd0
    [  219.334317]  [<ffffffffb5e0a02f>] ? do_IRQ+0x4f/0xd0
    [  219.350635]  [<ffffffffb5e08142>] ? common_interrupt+0x82/0x82
    [  219.369810]  <EOI> [  219.376123]  [<ffffffffb5ccce93>] ?
cpuidle_enter_state+0x113/0x260
    [  219.396741]  [<ffffffffb58bc09e>] ? cpu_startup_entry+0x17e/0x260
    [  219.416785]  [<ffffffffb6549f84>] ? start_kernel+0x46d/0x48d
    [  219.435392]  [<ffffffffb6549120>] ? early_idt_handler_array+0x120/0x120
    [  219.457141]  [<ffffffffb65495b9>] ? x86_64_start_kernel+0x152/0x176
    [  219.477745] Code: 00 0f b6 44 24 50 c6 06 22 88 56 01 88 46 02 44 89 c8
0f c8 89 46 1c 0f b6 44 24 40 41 8d 44 01 ff 0f c8 89 46 20 eb ac 48 8b 30 <f6>
06 3f 0f 85 bb 00 00 00 49 8b 3b e9 74 ff ff ff 41 f6 86 10 
    [  219.540521] RIP  [<ffffffffc05c5256>] beiscsi_process_cq+0x6f6/0xa00
[be2iscsi]
    [  219.564571]  RSP <ffff95bfbfa03e48>
    [  219.576023] CR2: 0000000000000000
    [  219.586917] ---[ end trace f9ec7ddab1cda260 ]---
    [  219.722293] Kernel panic - not syncing: Fatal exception in interrupt
    [  219.743253] Kernel Offset: 0x34800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
    [  219.898801] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt

This is what gdb has to say about the address:

    (gdb) list *(beiscsi_process_cq+0x6f6)
    0xa286 is in beiscsi_process_cq (./drivers/scsi/be2iscsi/be_main.c:1356).
    1351        
    1352                spin_lock_bh(&session->back_lock);
    1353                switch (type) {
    1354                case HWH_TYPE_IO:
    1355                case HWH_TYPE_IO_RD:
    1356                        if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
    1357                             ISCSI_OP_NOOP_OUT)
    1358                                be_complete_nopin_resp(beiscsi_conn,
task, &csol_cqe);
    1359                        else
    1360                                be_complete_io(beiscsi_conn, task,
&csol_cqe);

and a disassembly around 0x6f6=1782:

    1354                case HWH_TYPE_IO:
    1355                case HWH_TYPE_IO_RD:
    1356                        if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
       0x000000000000a283 <+1779>:      mov    (%rax),%rsi
       0x000000000000a286 <+1782>:      testb  $0x3f,(%rsi)
       0x000000000000a289 <+1785>:      jne    0xa34a <beiscsi_process_cq+1978>
       0x000000000000a28f <+1791>:      mov    (%r11),%rdi
       0x000000000000a292 <+1794>:      jmpq   0xa20b <beiscsi_process_cq+1659>

I guess `task->hdr` is NULL at this point.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
