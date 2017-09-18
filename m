From: Meelis Roos <mroos@linux.ee>
Subject: qla2xxx UBSAN warning in 4.14-rc1
Date: Mon, 18 Sep 2017 13:49:47 +0300 (EEST)
Message-ID: <alpine.LRH.2.21.1709181335450.628@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57205 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751706AbdIRKtw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Sep 2017 06:49:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello, I decided to widen the coverage of my kernel testbed and put some 
FC cards into servers. This one is a PCI-X QLA2340 in HP Proliant DL 380 
G4 (first 64-bit generation of Proliants). I got a UBSAN warning from 
qla2xxx before probing for the firmware.

This is reproducible with or without firmware being available.

[    3.905570] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 10.00.00.01-k.
[    3.905977] qla2xxx 0000:06:02.0: PCI IRQ 78 -> rerouted to legacy IRQ 18
[    3.906172] qla2xxx [0000:06:02.0]-001d: : Found an ISP2312 irq 18 iobase 0xffffc90000139000.
[...]
[    4.180117] ================================================================================
[    4.180300] UBSAN: Undefined behaviour in drivers/scsi/qla2xxx/qla_isr.c:275:14
[    4.180464] shift exponent 32 is too large for 32-bit type 'int'
[    4.180576] CPU: 0 PID: 138 Comm: systemd-udevd Not tainted 4.14.0-rc1-00009-g0666f560b71b #27
[    4.180741] Hardware name: HP ProLiant DL380 G4, BIOS P51 07/19/2007
[    4.180849] Call Trace:
[    4.180961]  dump_stack+0x4e/0x6c
[    4.181072]  ubsan_epilogue+0xd/0x3b
[    4.181179]  __ubsan_handle_shift_out_of_bounds+0x112/0x14c
[    4.181290]  ? try_to_del_timer_sync+0x44/0x68
[    4.181440]  qla2x00_mbx_completion+0x1c5/0x25d [qla2xxx]
[    4.182683]  qla2300_intr_handler+0x1ea/0x3bb [qla2xxx]
[    4.182827]  qla2x00_mailbox_command+0x77b/0x139a [qla2xxx]
[    4.182935]  ? __const_udelay+0x3c/0x3e
[    4.183073]  qla2x00_mbx_reg_test+0x83/0x114 [qla2xxx]
[    4.183213]  ? qla2x00_read_nvram_data+0x5c/0xe1 [qla2xxx]
[    4.183349]  qla2x00_chip_diag+0x354/0x45f [qla2xxx]
[    4.183489]  ? qla25xx_read_optrom_data+0x401/0x401 [qla2xxx]
[    4.183628]  qla2x00_initialize_adapter+0x2c2/0xa4e [qla2xxx]
[    4.183767]  qla2x00_probe_one+0x1681/0x392e [qla2xxx]
[    4.183883]  ? kernfs_add_one+0x11c/0x1ca
[    4.183990]  pci_device_probe+0x10b/0x1f1
[    4.184102]  driver_probe_device+0x21f/0x3a4
[    4.184210]  __driver_attach+0xa9/0xe1
[    4.184317]  ? driver_probe_device+0x3a4/0x3a4
[    4.184424]  bus_for_each_dev+0x6e/0xb5
[    4.184530]  driver_attach+0x22/0x3c
[    4.184638]  bus_add_driver+0x1d1/0x2ae
[    4.184745]  driver_register+0x78/0x130
[    4.184851]  __pci_register_driver+0x75/0xa8
[    4.184953]  ? 0xffffffffa0227000
[    4.185099]  qla2x00_module_init+0x21b/0x267 [qla2xxx]
[    4.185211]  do_one_initcall+0x5a/0x1e2
[    4.185323]  ? kfree+0x164/0x27a
[    4.185435]  do_init_module+0x9d/0x285
[    4.185545]  load_module+0x20db/0x38e3
[    4.185654]  ? disable_ro_nx+0x8f/0x8f
[    4.185765]  ? kernel_read+0x60/0xe5
[    4.185875]  ? kernel_read_file_from_fd+0x44/0x6d
[    4.185988]  SYSC_finit_module+0xa8/0xbc
[    4.186104]  SyS_finit_module+0x9/0xb
[    4.186216]  do_syscall_64+0x77/0x271
[    4.186331]  entry_SYSCALL64_slow_path+0x25/0x25
[    4.186444] RIP: 0033:0x7f29e6783219
[    4.186552] RSP: 002b:00007ffc8cb7c858 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    4.186723] RAX: ffffffffffffffda RBX: 0000561d18660bd0 RCX: 00007f29e6783219
[    4.186837] RDX: 0000000000000000 RSI: 00007f29e64992d5 RDI: 0000000000000007
[    4.186944] RBP: 00007f29e64992d5 R08: 0000000000000000 R09: 00007ffc8cb7cdd0
[    4.187055] R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
[    4.187170] R13: 0000561d18666140 R14: 0000000000020000 R15: 00007ffc8cb7c970
[    4.187284] ================================================================================
[...]
[    4.489060] scsi host4: qla2xxx
[    4.489875] qla2xxx [0000:06:02.0]-00fb:4: QLogic QLA2340 - .
[    4.489976] qla2xxx [0000:06:02.0]-00fc:4: ISP2312: PCI-X (100 MHz) @ 0000:06:02.0 hdma+ host#=4 fw=3.03.28 IPX.



-- 
Meelis Roos (mroos@linux.ee)
