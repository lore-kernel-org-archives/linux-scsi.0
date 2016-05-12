From: Meelis Roos <mroos@linux.ee>
Subject: UBSAN: Undefined behaviour in
 drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
Date: Thu, 12 May 2016 19:02:41 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1605121859240.4797@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This is from a dual-AthlonMP 32-bit x86 system with onboard Adaptec SCSI 
controller, once during bootup.

[    4.896307] ================================================================================
[    4.896471] UBSAN: Undefined behaviour in drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
[    4.896629] shift exponent -1 is negative
[    4.896722] CPU: 0 PID: 224 Comm: systemd-udevd Not tainted 4.6.0-rc6-00072-g33656a1 #22
[    4.896880] Hardware name: Unknown Unknown/S2462 THUNDER K7, BIOS Guinness-8    04/07/2003
[    4.897038]  00000000 c134beac 00000046 f67a3a88 00000001 c1381f8b f67a3a7c ffffffff
[    4.897392]  c1382516 c1700104 f67a3a8c c1abdf00 00000000 00000002 0000312d f6bed490
[    4.897746]  f6bed490 f67a3acc c10a9259 f6bdc490 f6bdc480 23d798ff 00000001 23d798ff
[    4.898101] Call Trace:
[    4.898193]  [<c134beac>] ? dump_stack+0x45/0x69
[    4.898287]  [<c1381f8b>] ? ubsan_epilogue+0xb/0x40
[    4.898382]  [<c1382516>] ? __ubsan_handle_shift_out_of_bounds+0xd6/0x120
[    4.898484]  [<c10a9259>] ? sched_clock_local+0x49/0x1b0
[    4.898581]  [<c10546a0>] ? default_send_IPI_mask_allbutself_logical+0x130/0x130
[    4.898739]  [<c1054435>] ? default_send_IPI_single+0x35/0x60
[    4.898844]  [<f810455e>] ? ahc_reset_channel+0x6e/0x370 [aic7xxx]
[    4.898943]  [<c10a14cc>] ? try_to_wake_up+0x3c/0x640
[    4.899044]  [<c1092e9f>] ? __alloc_workqueue_key+0x34f/0x5d0
[    4.899141]  [<c108f270>] ? apply_wqattrs_cleanup.part.28+0x40/0x40
[    4.899245]  [<f810d184>] ? ahc_linux_initialize_scsi_bus+0x54/0x320 [aic7xxx]
[    4.899404]  [<c135e1a2>] ? vsnprintf+0x442/0x8c0
[    4.899504]  [<f80fdd59>] ? ahc_set_name+0x19/0x30 [aic7xxx]
[    4.899607]  [<f810f905>] ? ahc_linux_register_host+0x195/0x270 [aic7xxx]
[    4.899708]  [<c14d0000>] ? cpufreq_governor_dbs+0x500/0xbd0
[    4.899812]  [<f81119ba>] ? ahc_linux_pci_dev_probe+0x11a/0x320 [aic7xxx]
[    4.899909]  [<c123b107>] ? kernfs_add_one+0x147/0x1b0
[    4.900005]  [<c123ada6>] ? kernfs_new_node+0x36/0x80
[    4.900100]  [<c144026c>] ? __pm_runtime_resume+0x3c/0x60
[    4.900195]  [<c1393d71>] ? pci_device_probe+0x91/0x130
[    4.900284]  [<c1431f48>] ? driver_probe_device+0xc8/0x330
[    4.900284]  [<c14321b0>] ? driver_probe_device+0x330/0x330
[    4.900284]  [<c14321b0>] ? driver_probe_device+0x330/0x330
[    4.900284]  [<c1432249>] ? __driver_attach+0x99/0xd0
[    4.900284]  [<c142fb3c>] ? bus_for_each_dev+0x4c/0x90
[    4.900284]  [<c143170a>] ? driver_attach+0x1a/0x40
[    4.900284]  [<c14321b0>] ? driver_probe_device+0x330/0x330
[    4.900284]  [<c1431107>] ? bus_add_driver+0x127/0x290
[    4.900284]  [<f809f000>] ? 0xf809f000
[    4.900284]  [<c1432c67>] ? driver_register+0x67/0x120
[    4.900284]  [<f809f56e>] ? ahc_linux_init+0x56e/0x1000 [aic7xxx]
[    4.900284]  [<c1000413>] ? do_one_initcall+0x73/0x260
[    4.900284]  [<f809f000>] ? 0xf809f000
[    4.900284]  [<c100042a>] ? do_one_initcall+0x8a/0x260
[    4.900284]  [<f809f000>] ? 0xf809f000
[    4.900284]  [<c1144646>] ? free_pages_prepare+0x296/0x590
[    4.900284]  [<c11a2e74>] ? kfree+0x174/0x290
[    4.900284]  [<c113a609>] ? do_init_module+0x15/0x21c
[    4.900284]  [<c113a669>] ? do_init_module+0x75/0x21c
[    4.900284]  [<c11197e1>] ? load_module+0x20e1/0x2d30
[    4.900284]  [<c11b44cc>] ? kernel_read_file+0x11c/0x250
[    4.900284]  [<c111a5bd>] ? SyS_finit_module+0x9d/0xb0
[    4.900284]  [<c1002066>] ? do_fast_syscall_32+0xb6/0x1d0
[    4.900284]  [<c164de9b>] ? sysenter_past_esp+0x40/0x6a
[    4.900284] ================================================================================

-- 
Meelis Roos (mroos@linux.ee)
