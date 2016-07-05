From: Meelis Roos <mroos@linux.ee>
Subject: UBSAN warning from qla2xxx
Date: Wed, 6 Jul 2016 00:07:09 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1607060004130.8418@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:47903 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbcGEVF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2016 17:05:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>

I tried UBSAN on one of my servers with QLogic FC adapter and got the 
following UBSAN warning on x86-64:

[    4.250370] ================================================================================
[    4.250692] UBSAN: Undefined behaviour in drivers/scsi/qla2xxx/qla_isr.c:2500:14
[    4.251004] shift exponent 32 is too large for 32-bit type 'int'
[    4.251182] CPU: 1 PID: 1877 Comm: systemd-udevd Tainted: G          I     4.7.0-rc6 #2
[    4.251507] Hardware name: HP ProLiant DL360 G6, BIOS P64 01/22/2015
[    4.251689]  0000000000000001 ffff88030ec3b698 ffffffff8143377f 0000000000000034
[    4.252135]  ffff88030ec3b6c0 ffffffffa05416e0 ffff88030ec3b6b0 ffffffff8148a6dd
[    4.252584]  0000000000000020 ffff88030ec3b740 ffffffff8148ad29 0000000000000002
[    4.253033] Call Trace:
[    4.253210]  [<ffffffff8143377f>] dump_stack+0x4e/0x6f
[    4.253392]  [<ffffffff8148a6dd>] ubsan_epilogue+0xd/0x40
[    4.253569]  [<ffffffff8148ad29>] __ubsan_handle_shift_out_of_bounds+0xf9/0x150
[    4.253885]  [<ffffffff811375b1>] ? try_to_del_timer_sync+0x51/0x90
[    4.254105]  [<ffffffff81137732>] ? del_timer_sync+0x22/0x60
[    4.254305]  [<ffffffffa048c07a>] qla24xx_mbx_completion+0x13a/0x170 [qla2xxx]
[    4.254629]  [<ffffffffa0493daf>] qla24xx_intr_handler+0x20f/0x3b0 [qla2xxx]
[    4.254818]  [<ffffffffa04749e4>] qla2x00_mailbox_command+0x644/0xf70 [qla2xxx]
[    4.255131]  [<ffffffff81440006>] ? __rb_insert_augmented+0x3c6/0x640
[    4.255320]  [<ffffffffa04b4850>] ? qla82xx_get_flash_version+0x5a0/0x5a0 [qla2xxx]
[    4.255689]  [<ffffffffa0476481>] qla2x00_mbx_reg_test+0xa1/0x140 [qla2xxx]
[    4.255880]  [<ffffffffa0466866>] qla24xx_chip_diag+0x66/0xe0 [qla2xxx]
[    4.256065]  [<ffffffffa046e9a8>] qla2x00_initialize_adapter+0x2b8/0xa30 [qla2xxx]
[    4.256388]  [<ffffffffa045ede1>] qla2x00_probe_one+0x1021/0x2e20 [qla2xxx]
[    4.256569]  [<ffffffff81321fb7>] ? kernfs_activate+0x87/0x160
[    4.256747]  [<ffffffff8149cf19>] local_pci_probe+0x59/0xf0
[    4.256922]  [<ffffffff8149ed4b>] pci_device_probe+0x14b/0x1c0
[    4.257104]  [<ffffffff8162ada0>] driver_probe_device+0x110/0x6d0
[    4.257280]  [<ffffffff8162b44e>] __driver_attach+0xee/0x150
[    4.257457]  [<ffffffff8162b360>] ? driver_probe_device+0x6d0/0x6d0
[    4.257635]  [<ffffffff81627dc7>] bus_for_each_dev+0x67/0xb0
[    4.257813]  [<ffffffff8162a2b2>] driver_attach+0x22/0x40
[    4.257989]  [<ffffffff81629a72>] bus_add_driver+0x172/0x340
[    4.258211]  [<ffffffffa0211000>] ? 0xffffffffa0211000
[    4.258389]  [<ffffffff8162c028>] driver_register+0x78/0x130
[    4.258567]  [<ffffffff8149c782>] __pci_register_driver+0x62/0xa0
[    4.258751]  [<ffffffffa02111c9>] qla2x00_module_init+0x1c9/0x217 [qla2xxx]
[    4.258931]  [<ffffffff8100046c>] do_one_initcall+0x5c/0x1e0
[    4.259114]  [<ffffffff81252c93>] ? kfree+0x153/0x260
[    4.259291]  [<ffffffff81251ca1>] ? kmem_cache_alloc+0xc1/0x170
[    4.259470]  [<ffffffff811b7ad4>] do_init_module+0x91/0x25f
[    4.259647]  [<ffffffff81160e25>] load_module+0x21e5/0x3570
[    4.259826]  [<ffffffff8115db20>] ? resolve_symbol_wait+0x170/0x170
[    4.260006]  [<ffffffff81279191>] ? kernel_read+0x61/0xe0
[    4.260191]  [<ffffffff811623c3>] SYSC_finit_module+0xc3/0xf0
[    4.260367]  [<ffffffff81162409>] SyS_finit_module+0x9/0x10
[    4.260575]  [<ffffffff81002a21>] do_syscall_64+0x71/0x150
[    4.260755]  [<ffffffff81933880>] entry_SYSCALL64_slow_path+0x25/0x25
[    4.260933] ================================================================================

-- 
Meelis Roos (mroos@linux.ee)
