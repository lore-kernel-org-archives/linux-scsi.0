From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: nsp32 driver failure
Date: Mon, 7 May 2012 11:29:42 +0900 (JST)
Message-ID: <487129.1530.qm@web100019.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100019.mail.kks.yahoo.co.jp ([114.111.98.193]:23839 "HELO
	web100019.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754984Ab2EGC3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 May 2012 22:29:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

IO Data makes a PCMCIA/Cardbus card CBSC-II, with a switch for 16-bit or 32-bit mode.  In 32-bit mode it is vendor 10FC, device 0005, which nsp32 recognizes but fails.  In 16-bit mode it is handled correctly by a different driver (I think nsp_cs).

In Windows the card operates correctly in 32-bit mode and I did not try 16-bit mode.  Windows formatted a SCSI disk.  Linux could access the disk after I switched the card to 16-bit mode.  So I think nsp32 is to blame.

[    6.200391] nsp32: loading...
[    8.040016] pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
[    8.040455] pci 0000:04:00.0: reg 10: [io  0x0000-0x007f]
[    8.040466] pci 0000:04:00.0: reg 14: [mem 0x00000000-0x00000fff]
[    8.040532] pci 0000:04:00.0: BAR 1: assigned [mem 0x88000000-0x88000fff]
[    8.040762] pci 0000:04:00.0: BAR 1: set to [mem 0x88000000-0x88000fff] (PCI address [0x88000000-0x88000fff]
[    8.041176] pci 0000:04:00.0: BAR 0: assigned [io  0x5000-0x507f]
[    8.041411] pci 0000:04:00.0: BAR 0: set to [io  0x5000-0x507f] (PCI address [0x5000-0x507f]
[    8.041826] pci 0000:04:00.0: cache line size of 64 is not supported
[    8.041935] nsp32 0000:04:00.0: enabling device (0000 -> 0003)
[    8.042171] nsp32 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.042420] nsp32 0000:04:00.0: setting latency timer to 64
[    8.044859] nsp32: No EEPROM detected: 0x0
[    8.055175] scsi5 : NinjaSCSI-32Bi/UDE: irq 19, io 0x5000+0x80
[   28.768068] nsp32: abort
[   38.768068] nsp32: abort
[   38.768336] nsp32: Bus Reset
[   58.779308] nsp32: abort
[   58.779557] nsp32: Host Reset
[   78.790310] nsp32: abort
[   78.790559] scsi 5:0:0:0: Device offlined - not ready after error recovery
[   99.744051] nsp32: abort
[  109.744062] nsp32: abort
[  109.744328] nsp32: Bus Reset
[  129.755297] nsp32: abort
[  129.755542] nsp32: Host Reset
[  149.766309] nsp32: abort
[  149.766558] scsi 5:0:1:0: Device offlined - not ready after error recovery
[  170.720041] nsp32: abort
[  180.720039] nsp32: abort
[  180.720287] nsp32: Bus Reset
[  200.731039] nsp32: abort
[  200.731284] nsp32: Host Reset
[  220.742046] nsp32: abort
[  220.742301] scsi 5:0:2:0: Device offlined - not ready after error recovery
[  241.760052] nsp32: abort
[  241.820051] INFO: task swapper:1 blocked for more than 120 seconds.
[  241.820303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.820744] swapper       D 00000002     0     1      0 0x00000000
[  241.821092]  f7044000 00000046 00000020 00000002 00000000 f704419c c29971c0 c29971c0
[  241.821879]  c2990000 c29971c0 c27998bc c20dd1c9 c27998bc f703ffbc c1064914 00000000
[  241.822683]  00000000 f703ffd0 00000000 c15830a9 00000000 f7044000 c10647a2 c27998c0
[  241.823485] Call Trace:
[  241.823730]  [<c20dd1c9>] ? _raw_spin_lock_irqsave+0x11/0x2a
[  241.823976]  [<c1064914>] ? prepare_to_wait+0x14/0x52
[  241.824238]  [<c15830a9>] ? wait_for_device_probe+0x56/0x71
[  241.824494]  [<c10647a2>] ? autoremove_wake_function+0x0/0x29
[  241.824740]  [<c28b1cfe>] ? prepare_namespace+0x2a/0x172
[  241.824982]  [<c28b13db>] ? kernel_init+0xfd/0x108
[  241.825245]  [<c28b12de>] ? kernel_init+0x0/0x108
[  241.825499]  [<c1023076>] ? kernel_thread_helper+0x6/0x10
[  251.760061] nsp32: abort
[  251.760324] nsp32: Bus Reset
[  271.771051] nsp32: abort
[  271.771307] nsp32: Host Reset
[  291.782053] nsp32: abort
[  291.782310] scsi 5:0:3:0: Device offlined - not ready after error recovery
[  312.288051] nsp32: abort
[  322.288059] nsp32: abort
[  322.288323] nsp32: Bus Reset
[  342.299061] nsp32: abort
[  342.299322] nsp32: Host Reset
[  361.825062] INFO: task swapper:1 blocked for more than 120 seconds.
[  361.825318] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  361.825758] swapper       D 00000002     0     1      0 0x00000000
[  361.826108]  f7044000 00000046 00000020 00000002 00000000 f704419c c29971c0 c29971c0
[  361.826893]  c2990000 c29971c0 c27998bc c20dd1c9 c27998bc f703ffbc c1064914 00000000
[  361.827695]  00000000 f703ffd0 00000000 c15830a9 00000000 f7044000 c10647a2 c27998c0
[  361.828497] Call Trace:
[  361.828741]  [<c20dd1c9>] ? _raw_spin_lock_irqsave+0x11/0x2a
[  361.828985]  [<c1064914>] ? prepare_to_wait+0x14/0x52
[  361.829246]  [<c15830a9>] ? wait_for_device_probe+0x56/0x71
[  361.829502]  [<c10647a2>] ? autoremove_wake_function+0x0/0x29
[  361.829746]  [<c28b1cfe>] ? prepare_namespace+0x2a/0x172
[  361.829988]  [<c28b13db>] ? kernel_init+0xfd/0x108
[  361.830246]  [<c28b12de>] ? kernel_init+0x0/0x108
[  361.830504]  [<c1023076>] ? kernel_thread_helper+0x6/0x10
[  362.310065] nsp32: abort
[  362.310325] scsi 5:0:4:0: Device offlined - not ready after error recovery
[  383.072057] nsp32: abort
[  393.072066] nsp32: abort
[  393.072326] nsp32: Bus Reset
[  413.083302] nsp32: abort
[  413.083545] nsp32: Host Reset
[  433.094300] nsp32: abort
[  433.094544] scsi 5:0:5:0: Device offlined - not ready after error recovery
[  454.048039] nsp32: abort
[  464.048039] nsp32: abort
[  464.048286] nsp32: Bus Reset
[  481.830067] INFO: task swapper:1 blocked for more than 120 seconds.
[  481.830321] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  481.830758] swapper       D 00000002     0     1      0 0x00000000
[  481.831107]  f7044000 00000046 00000020 00000002 00000000 f704419c c29971c0 c29971c0
[  481.831894]  c2990000 c29971c0 c27998bc c20dd1c9 c27998bc f703ffbc c1064914 00000000
[  481.832711]  00000000 f703ffd0 00000000 c15830a9 00000000 f7044000 c10647a2 c27998c0
[  481.833535] Call Trace:
[  481.833777]  [<c20dd1c9>] ? _raw_spin_lock_irqsave+0x11/0x2a
[  481.834033]  [<c1064914>] ? prepare_to_wait+0x14/0x52
[  481.834280]  [<c15830a9>] ? wait_for_device_probe+0x56/0x71
[  481.834532]  [<c10647a2>] ? autoremove_wake_function+0x0/0x29
[  481.834776]  [<c28b1cfe>] ? prepare_namespace+0x2a/0x172
[  481.835030]  [<c28b13db>] ? kernel_init+0xfd/0x108
[  481.835275]  [<c28b12de>] ? kernel_init+0x0/0x108
[  481.835527]  [<c1023076>] ? kernel_thread_helper+0x6/0x10
[  484.059044] nsp32: abort
[  484.059288] nsp32: Host Reset
[  504.070038] nsp32: abort
[  504.070301] scsi 5:0:6:0: Device offlined - not ready after error recovery
[  504.070608] nsp32: irq: 19 mmio: f863a000+0x1000 slot: 0000:04:00.0 model: I-O DATA CBSC-II CardBus card
[  504.071074] ------------[ cut here ]------------
[  504.071095] md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
[  504.071143] RAMDISK: lzma image found at block 0
[  504.072004] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x5f/0x70()
[  504.072248] Hardware name: Latitude D820                   
[  504.072503] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1e.0/0000:03:01.0/0000:04:00.0/config'
[  504.072941] Modules linked in:
[  504.073228] Pid: 4501, comm: pccardd Not tainted 2.6.35.3-remix-orient #21
[  504.073483] Call Trace:
[  504.073726]  [<c1054214>] ? warn_slowpath_common+0x6a/0x7b
[  504.073970]  [<c110298a>] ? sysfs_add_one+0x5f/0x70
[  504.074218]  [<c105428b>] ? warn_slowpath_fmt+0x28/0x2c
[  504.079595]  [<c110298a>] ? sysfs_add_one+0x5f/0x70
[  504.079839]  [<c1102432>] ? sysfs_add_file_mode+0x3f/0x66
[  504.080086]  [<c1102464>] ? sysfs_add_file+0xb/0xe
[  504.080353]  [<c14ab2a7>] ? pci_create_sysfs_dev_files+0x38/0x1f6
[  504.080600]  [<c14a5dd6>] ? pci_bus_add_device+0x27/0x2c
[  504.080843]  [<c14a5df9>] ? pci_bus_add_devices+0x1e/0xed
[  504.081090]  [<c20403c0>] ? cb_alloc+0x9d/0xa5
[  504.081345]  [<c1aa1922>] ? socket_insert+0xb1/0xe6
[  504.081588]  [<c1aa1ff3>] ? pccardd+0x1b4/0x349
[  504.081831]  [<c1aa1e3f>] ? pccardd+0x0/0x349
[  504.082076]  [<c1064483>] ? kthread+0x5f/0x64
[  504.082330]  [<c1064424>] ? kthread+0x0/0x64
[  504.082571]  [<c1023076>] ? kernel_thread_helper+0x6/0x10
[  504.082811] ---[ end trace e480b0f669a3c27d ]---

