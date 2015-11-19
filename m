From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 21:21:35 +0200
Message-ID: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:54970 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbbKSTco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 14:32:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <JBottomley@Odin.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi,

I get the below crash when cold booting OCTEON router with USB disk as
rootfs. Bisected to:

	commit bf2cf3baa20b0a6cd2d08707ef05dc0e992a8aa0
	Author: Bart Van Assche <bart.vanassche@sandisk.com>
	Date:   Fri Sep 18 17:23:42 2015 -0700

	    scsi: Fix a bdi reregistration race

Reverting the patch makes the board boot fine again.

A.

Waiting for rootfs media to appear... Press ENTER to interrupt.
[    1.540522] usb 1-1: new high-speed USB device number 2 using ehci-platform
[    1.699752] usb-storage 1-1:1.0: USB Mass Storage device detected
[    1.706054] scsi host0: usb-storage 1-1:1.0
[    2.702105] scsi 0:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI: 5
[    2.714214] sd 0:0:0:0: [sda] Spinning up disk...
[    3.720503] ...
[    6.674040] usb 1-1: USB disconnect, device number 2
[    6.750508] .ready
[    6.752558] sd 0:0:0:0: [sda] Read Capacity(10) failed: Result: hostbyte=0x00 driverbyte=0x04
[    6.761112] sd 0:0:0:0: [sda] Sense not available.
[    6.765918] sd 0:0:0:0: [sda] Write Protect is off
[    6.770741] sd 0:0:0:0: [sda] Asking for cache data failed
[    6.776236] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.782745] ------------[ cut here ]------------
[    6.787383] WARNING: CPU: 1 PID: 15 at /home/aaro/git/linux/block/genhd.c:626 add_disk+0x41c/0x478()
[    6.796549] Modules linked in:
[    6.799624] CPU: 1 PID: 15 Comm: kworker/u4:1 Not tainted 4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[    6.808959] Workqueue: events_unbound async_run_entry_fn
[    6.814296] Stack : 0000000000000001 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
	  ffffffff816b78f8 80000000330e9000 0000000000000272 0000000000000009
	  ffffffff813471cc 0000000000000000 80000000330086a0 8000000033008400
	  80000000330e9000 ffffffff811cea44 800000003314bb68 8000000033008400
	  80000000330e9000 800000003314ba70 800000003314bb88 ffffffff8135331c
	  000000000000015f ffffffff813c0900 000000000000006e 0000000000000000
	  735f756e626f756e ffffffff81124190 0000000000000000 0000000000000000
	  ...
[    6.879950] Call Trace:
[    6.882414] [<ffffffff81124190>] show_stack+0x88/0xa8
[    6.887475] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[    6.892549] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[    6.898481] [<ffffffff813471cc>] add_disk+0x41c/0x478
[    6.903552] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
[    6.909047] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
[    6.914898] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
[    6.920663] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
[    6.926159] [<ffffffff81160dc4>] kthread+0xd4/0xf0
[    6.930968] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
[    6.937069] 
[    6.938562] ---[ end trace a84c8a326c0c5a61 ]---
[    6.943227] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.948177] ------------[ cut here ]------------
[    6.952831] WARNING: CPU: 0 PID: 147 at /home/aaro/git/linux/mm/backing-dev.c:856 bdi_exit+0xbc/0xe0()
[    6.962159] Modules linked in:
[    6.965232] CPU: 0 PID: 147 Comm: kworker/0:1 Tainted: G        W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[    6.975778] Workqueue: usb_hub_wq hub_event
[    6.979974] Stack : 0000000000000000 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
	  ffffffff816b78f8 800000003324f480 0000000000000358 0000000000000009
	  ffffffff811eef74 800000003311b890 0000000000000001 80000000333b03c8
	  0000000000000001 ffffffff811cea44 80000000333436c8 80000000333b03c8
	  0000000000000001 80000000333435d0 80000000333436e8 ffffffff8135331c
	  00000000000001f3 ffffffff813c0900 0000000000000074 0000000000000000
	  0000000000000005 ffffffff81124190 0000000000000000 0000000000000000
	  ...
[    7.045656] Call Trace:
[    7.048112] [<ffffffff81124190>] show_stack+0x88/0xa8
[    7.053192] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[    7.058253] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[    7.064211] [<ffffffff811eef74>] bdi_exit+0xbc/0xe0
[    7.069099] [<ffffffff81336eb0>] blk_release_queue+0x20/0xf0
[    7.074786] [<ffffffff8135889c>] kobject_put+0xd4/0x128
[    7.080022] [<ffffffff81346b9c>] disk_release+0xa4/0xf0
[    7.085276] [<ffffffff813cc1ac>] device_release+0x3c/0xc0
[    7.090697] [<ffffffff8135889c>] kobject_put+0xd4/0x128
[    7.095933] [<ffffffff813fb4d8>] scsi_disk_release+0x60/0x88
[    7.101611] [<ffffffff813cc1ac>] device_release+0x3c/0xc0
[    7.107020] [<ffffffff8135889c>] kobject_put+0xd4/0x128
[    7.112264] [<ffffffff813fe654>] sd_remove+0x9c/0xc8
[    7.117240] [<ffffffff813d0e78>] __device_release_driver+0x90/0x148
[    7.123527] [<ffffffff813d0f58>] device_release_driver+0x28/0x40
[    7.129543] [<ffffffff813d0608>] bus_remove_device+0xe0/0x140
[    7.135307] [<ffffffff813ccc48>] device_del+0x118/0x228
[    7.140555] [<ffffffff813f80a0>] __scsi_remove_device+0xd0/0xd8
[    7.146485] [<ffffffff813f624c>] scsi_forget_host+0x84/0x98
[    7.152080] [<ffffffff813ea408>] scsi_remove_host+0x80/0x178
[    7.157751] [<ffffffff8148f140>] usb_stor_disconnect+0x50/0x118
[    7.163693] [<ffffffff814692b4>] usb_unbind_interface+0x84/0x2d0
[    7.169710] [<ffffffff813d0e78>] __device_release_driver+0x90/0x148
[    7.175997] [<ffffffff813d0f58>] device_release_driver+0x28/0x40
[    7.182025] [<ffffffff813d0608>] bus_remove_device+0xe0/0x140
[    7.187781] [<ffffffff813ccc48>] device_del+0x118/0x228
[    7.193029] [<ffffffff81466714>] usb_disable_device+0xcc/0x268
[    7.198876] [<ffffffff8145c490>] usb_disconnect+0x88/0x2e8
[    7.204381] [<ffffffff8145e58c>] hub_event+0x704/0x1298
[    7.209616] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
[    7.215381] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
[    7.220888] [<ffffffff81160dc4>] kthread+0xd4/0xf0
[    7.225690] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
[    7.231800] 
[    7.233294] ---[ end trace a84c8a326c0c5a62 ]---
[   14.981154] usb 1-1: new high-speed USB device number 3 using ehci-platform
[   15.149942] usb-storage 1-1:1.0: USB Mass Storage device detected
[   15.156250] scsi host1: usb-storage 1-1:1.0
[   16.162292] scsi 1:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI: 5
[   16.172039] sd 1:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   16.181665] sd 1:0:0:0: [sda] Write Protect is off
[   16.187266] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.196375] ------------[ cut here ]------------
[   16.201023] WARNING: CPU: 0 PID: 15 at /home/aaro/git/linux/fs/sysfs/dir.c:31 sysfs_warn_dup+0x68/0xc8()
[   16.210529] sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:0'
[   16.217769] Modules linked in:
[   16.220853] CPU: 0 PID: 15 Comm: kworker/u4:1 Tainted: G        W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   16.231409] Workqueue: events_unbound async_run_entry_fn
[   16.236746] Stack : 0000000000000000 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
	  ffffffff816b78f8 80000000330e9000 000000000000001f 0000000000000009
	  ffffffff8129add8 8000000032316c10 0000000000000000 800000003314bc28
	  800000003313a300 ffffffff811cea44 800000003314b928 800000003314bc28
	  800000003313a300 800000003314b830 800000003314b948 ffffffff8135331c
	  00000000000002c5 ffffffff813c0900 000000000000006e 0000000000000000
	  735f756e626f756e ffffffff81124190 0000000000000000 0000000000000000
	  ...
[   16.302416] Call Trace:
[   16.304872] [<ffffffff81124190>] show_stack+0x88/0xa8
[   16.309933] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[   16.315003] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[   16.320942] [<ffffffff81141d30>] warn_slowpath_fmt+0x38/0x48
[   16.326612] [<ffffffff8129add8>] sysfs_warn_dup+0x68/0xc8
[   16.332035] [<ffffffff8129af60>] sysfs_create_dir_ns+0xa0/0xb8
[   16.337880] [<ffffffff8135922c>] kobject_add_internal+0xb4/0x328
[   16.343906] [<ffffffff81359504>] kobject_add+0x64/0xc0
[   16.349055] [<ffffffff813cddd8>] device_add+0xe8/0x5d8
[   16.354212] [<ffffffff813ce588>] device_create_groups_vargs+0x140/0x150
[   16.360856] [<ffffffff811ee458>] bdi_register+0x70/0x128
[   16.366178] [<ffffffff81346ee8>] add_disk+0x138/0x478
[   16.371254] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
[   16.376749] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
[   16.382601] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
[   16.388357] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
[   16.393861] [<ffffffff81160dc4>] kthread+0xd4/0xf0
[   16.398662] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
[   16.404771] 
[   16.406264] ---[ end trace a84c8a326c0c5a63 ]---
[   16.410896] ------------[ cut here ]------------
[   16.415525] WARNING: CPU: 0 PID: 15 at /home/aaro/git/linux/lib/kobject.c:240 kobject_add_internal+0x2d4/0x328()
[   16.425722] kobject_add_internal failed for 8:0 with -EEXIST, don't try to register things with the same name in the same directory.
[   16.437654] Modules linked in:
[   16.440732] CPU: 0 PID: 15 Comm: kworker/u4:1 Tainted: G        W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   16.451281] Workqueue: events_unbound async_run_entry_fn
[   16.456607] Stack : 0000000000000000 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
	  ffffffff816b78f8 80000000330e9000 00000000000000f0 0000000000000009
	  ffffffff8135944c 8000000032316c10 0000000000000000 800000003314bc28
	  800000003313a300 ffffffff811cea44 800000003314b978 800000003314bc28
	  800000003313a300 800000003314b880 800000003314b998 ffffffff8135331c
	  0000000000000369 ffffffff813c0900 000000000000006e 0000000000000000
	  735f756e626f756e ffffffff81124190 0000000000000000 0000000000000000
	  ...
[   16.522269] Call Trace:
[   16.524722] [<ffffffff81124190>] show_stack+0x88/0xa8
[   16.529782] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[   16.534850] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[   16.540789] [<ffffffff81141d30>] warn_slowpath_fmt+0x38/0x48
[   16.546459] [<ffffffff8135944c>] kobject_add_internal+0x2d4/0x328
[   16.552571] [<ffffffff81359504>] kobject_add+0x64/0xc0
[   16.557718] [<ffffffff813cddd8>] device_add+0xe8/0x5d8
[   16.562873] [<ffffffff813ce588>] device_create_groups_vargs+0x140/0x150
[   16.569499] [<ffffffff811ee458>] bdi_register+0x70/0x128
[   16.574828] [<ffffffff81346ee8>] add_disk+0x138/0x478
[   16.579889] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
[   16.585391] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
[   16.591244] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
[   16.596998] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
[   16.602502] [<ffffffff81160dc4>] kthread+0xd4/0xf0
[   16.607303] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
[   16.613412] 
[   16.614904] ---[ end trace a84c8a326c0c5a64 ]---
[   16.633023]  sda: sda1 sda2
[   16.636291] CPU 1 Unable to handle kernel paging request at virtual address 0000000000000040, epc == ffffffff8129b258, ra == ffffffff8129b258
[   16.649023] Oops[#1]:
[   16.651304] CPU: 1 PID: 15 Comm: kworker/u4:1 Tainted: G        W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   16.661845] Workqueue: events_unbound async_run_entry_fn
[   16.667174] task: 8000000033140000 ti: 8000000033148000 task.ti: 8000000033148000
[   16.674664] $ 0   : 0000000000000000 0000000010009ce1 0000000000010000 0000000000000000
[   16.682729] $ 4   : ffffffff82f462d0 000000000000022a ffffffff816c0a88 0000000000000001
[   16.690793] $ 8   : 80000000329dc2c0 800000003310da10 fffffffffffffffc 0000000000000000
[   16.698859] $12   : 800000000307c068 0000000000000897 0000000000000001 800000003310da10
[   16.706924] $16   : ffffffff82f40000 0000000000000040 0000000000000001 800000003331a0f0
[   16.714990] $20   : ffffffff816c0a88 0000000000000000 80000000330086a0 8000000033008400
[   16.723055] $24   : 80000000332b11f0 0000000000000000                                  
[   16.731119] $28   : 8000000033148000 800000003314bc20 80000000330e9000 ffffffff8129b258
[   16.739184] Hi    : 0000000000000000
[   16.742762] Lo    : 8888888888888889
[   16.746347] epc   : ffffffff8129b258 sysfs_do_create_link_sd.isra.0+0x48/0x100
[   16.753581] ra    : ffffffff8129b258 sysfs_do_create_link_sd.isra.0+0x48/0x100
[   16.760810] Status: 10009ce3	KX SX UX KERNEL EXL IE 
[   16.765854] Cause : 00800008 (ExcCode 02)
[   16.769867] BadVA : 0000000000000040
[   16.773445] PrId  : 000d9301 (Cavium Octeon II)
[   16.777979] Modules linked in:
[   16.781048] Process kworker/u4:1 (pid: 15, threadinfo=8000000033148000, task=8000000033140000, tls=0000000000000000)
[   16.791582] Stack : 8000000032316800 8000000032316880 800000003231680c 8000000032c3c300
	  80000000329dbe70 ffffffff81346f80 8000000032316800 0000000000000000
	  0000000300000000 0080000033008400 8000000032316400 8000000032316800
	  8000000032381800 8000000032381968 8000000033008400 ffffffff81400794
	  80000000330e9000 8000000032308c80 8000000032308c60 ffffffff81f30000
	  800000003302a900 ffffffff8116373c 8000000033008400 8000000032308c80
	  80000000330e9000 0000000000000000 800000003302a900 ffffffff8115a83c
	  8000000033008418 8000000033008400 80000000330e9030 8000000033008418
	  0000000000000088 8000000033008400 ffffffff81790000 80000000330086a0
	  8000000033008400 ffffffff8115ac60 ffffffff81790000 ffffffff81790000
	  ...
[   16.857191] Call Trace:
[   16.859642] [<ffffffff8129b258>] sysfs_do_create_link_sd.isra.0+0x48/0x100
[   16.866531] [<ffffffff81346f80>] add_disk+0x1d0/0x478
[   16.871592] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
[   16.877086] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
[   16.882928] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
[   16.888683] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
[   16.894178] [<ffffffff81160dc4>] kthread+0xd4/0xf0
[   16.898978] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
[   16.905079] 
[   16.906570] 
Code: ffbf0028  0c5777b4  00e0902d <de310000> 12200003  00000000  0c4a5ad8  0220202d  661062d0 
[   16.916655] ---[ end trace a84c8a326c0c5a65 ]---
[   16.921305] Fatal exception: panic in 5 secondsFound rootfs /dev/sda2. Press ENTER to interrupt.
rootfs: recovering journal

[   19.162984] ------------[ cut here ]------------
[   19.167838] WARNING: CPU: 0 PID: 577 at /home/aaro/git/linux/fs/fs-writeback.c:2065 __mark_inode_dirty+0x204/0x2b8()
[   19.178400] bdi-block not registered
[   19.181996] Modules linked in:
[   19.185098] CPU: 0 PID: 577 Comm: fsck.ext4 Tainted: G      D W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   19.195472] Stack : ffffffff81f38340 0000000000000000 ffffffff81f3d648 ffffffffffffffff
	  0000000000000000 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000066 0000000000000066
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f40000
	  0000000000000000 ffffffff81609e08 ffffffff81f30000 ffffffff81f36878
	  ffffffff8175e287 ffffffff816b78f8 8000000032970c00 0000000000000000
	  0000000000000241 ffffffff81f36878 0000000000000200 0000000000000000
	  0000000000000001 80000000323ff930 80000000323ffa48 ffffffff8135331c
	  000000000000052f ffffffff8118a4c8 000000000000001c ffffffff816b78f8
	  0000000000000000 ffffffff81124190 0000000000000000 0000000000000000
	  ...
[   19.261131] Call Trace:
[   19.263588] [<ffffffff81124190>] show_stack+0x88/0xa8
[   19.268649] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[   19.273717] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[   19.279646] [<ffffffff81141d30>] warn_slowpath_fmt+0x38/0x48
[   19.285326] [<ffffffff81255cec>] __mark_inode_dirty+0x204/0x2b8
[   19.291270] [<ffffffff8125fec4>] __block_commit_write.isra.7+0x8c/0x128
[   19.297896] [<ffffffff8125ffb0>] block_write_end+0x50/0xb0
[   19.303398] [<ffffffff812641c4>] blkdev_write_end+0x14/0x40
[   19.308984] [<ffffffff811d01dc>] generic_perform_write+0x144/0x230
[   19.315182] [<ffffffff811d1db8>] __generic_file_write_iter+0x190/0x1f0
[   19.321728] [<ffffffff81264dc8>] blkdev_write_iter+0x80/0x138
[   19.327483] [<ffffffff81227fb8>] __vfs_write+0xb8/0x110
[   19.332722] [<ffffffff812288f0>] vfs_write+0xa0/0x1c0
[   19.337782] [<ffffffff812295b0>] SyS_pwrite64+0xb0/0xc8
[   19.343025] [<ffffffff811324a0>] syscall_common+0x8/0x2c
[   19.348342] 
[   19.349834] ---[ end trace a84c8a326c0c5a66 ]---
[   19.669411] ------------[ cut here ]------------
[   19.674089] WARNING: CPU: 1 PID: 577 at /home/aaro/git/linux/fs/fs-writeback.c:2065 __mark_inode_dirty+0x204/0x2b8()
[   19.684640] bdi-block not registered
[   19.688219] Modules linked in:
[   19.691307] CPU: 1 PID: 577 Comm: fsck.ext4 Tainted: G      D W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   19.701683] Stack : ffffffff81f38340 0000000000000000 ffffffff81f3df10 ffffffffffffffff
	  0000000000000001 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000066 0000000000000066
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f40000
	  0000000000000000 ffffffff81609e08 ffffffff81f30000 ffffffff81f36878
	  ffffffff8175e287 ffffffff816b78f8 8000000032970c00 0000000000000001
	  0000000000000241 ffffffff81f36878 0000000000000200 0000000000000000
	  0000000000000001 80000000323ff930 80000000323ffa48 ffffffff8135331c
	  00000000000005c9 ffffffff8118a4c8 000000000000001c ffffffff816b78f8
	  0000000000000001 ffffffff81124190 0000000000000000 0000000000000000
	  ...
[   19.767344] Call Trace:
[   19.769801] [<ffffffff81124190>] show_stack+0x88/0xa8
[   19.774884] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[   19.779947] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[   19.785889] [<ffffffff81141d30>] warn_slowpath_fmt+0x38/0x48
[   19.791577] [<ffffffff81255cec>] __mark_inode_dirty+0x204/0x2b8
[   19.797512] [<ffffffff8125fec4>] __block_commit_write.isra.7+0x8c/0x128
[   19.804148] [<ffffffff8125ffb0>] block_write_end+0x50/0xb0
[   19.809644] [<ffffffff812641c4>] blkdev_write_end+0x14/0x40
[   19.815238] [<ffffffff811d01dc>] generic_perform_write+0x144/0x230
[   19.821442] [<ffffffff811d1db8>] __generic_file_write_iter+0x190/0x1f0
[   19.827981] [<ffffffff81264dc8>] blkdev_write_iter+0x80/0x138
[   19.833748] [<ffffffff81227fb8>] __vfs_write+0xb8/0x110
[   19.838982] [<ffffffff812288f0>] vfs_write+0xa0/0x1c0
[   19.844052] [<ffffffff812295b0>] SyS_pwrite64+0xb0/0xc8
[   19.849290] [<ffffffff811324a0>] syscall_common+0x8/0x2c
[   19.854617] 
[   19.856111] ---[ end trace a84c8a326c0c5a67 ]---
[   19.973436] ------------[ cut here ]------------
[   19.978086] WARNING: CPU: 0 PID: 577 at /home/aaro/git/linux/fs/fs-writeback.c:2065 __mark_inode_dirty+0x204/0x2b8()
[   19.988646] bdi-block not registered
[   19.992241] Modules linked in:
[   19.995314] CPU: 0 PID: 577 Comm: fsck.ext4 Tainted: G      D W       4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
[   20.005686] Stack : ffffffff81f38340 0000000000000000 ffffffff81f3e7d8 ffffffffffffffff
	  0000000000000000 0000000000000004 ffffffff81760000 0000000000000000
	  0000000000000001 0000000000000000 0000000000000066 0000000000000066
	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f40000
	  0000000000000000 ffffffff81609e08 ffffffff81f30000 ffffffff81f36878
	  ffffffff8175e287 ffffffff816b78f8 8000000032970c00 0000000000000000
	  0000000000000241 ffffffff81f36878 0000000000000200 0000000000000000
	  0000000000000001 80000000323ff930 80000000323ffa48 ffffffff8135331c
	  0000000000000663 ffffffff8118a4c8 000000000000001c ffffffff816b78f8
	  0000000000000000 ffffffff81124190 0000000000000000 0000000000000000
	  ...
[   20.071375] Call Trace:
[   20.073832] [<ffffffff81124190>] show_stack+0x88/0xa8
[   20.078893] [<ffffffff8135331c>] dump_stack+0x6c/0x90
[   20.083963] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
[   20.089892] [<ffffffff81141d30>] warn_slowpath_fmt+0x38/0x48
[   20.095570] [<ffffffff81255cec>] __mark_inode_dirty+0x204/0x2b8
[   20.101513] [<ffffffff8125fec4>] __block_commit_write.isra.7+0x8c/0x128
[   20.108138] [<ffffffff8125ffb0>] block_write_end+0x50/0xb0
[   20.113642] [<ffffffff812641c4>] blkdev_write_end+0x14/0x40
[   20.119228] [<ffffffff811d01dc>] generic_perform_write+0x144/0x230
[   20.125428] [<ffffffff811d1db8>] __generic_file_write_iter+0x190/0x1f0
[   20.131975] [<ffffffff81264dc8>] blkdev_write_iter+0x80/0x138
[   20.137731] [<ffffffff81227fb8>] __vfs_write+0xb8/0x110
[   20.142973] [<ffffffff812288f0>] vfs_write+0xa0/0x1c0
[   20.148034] [<ffffffff812295b0>] SyS_pwrite64+0xb0/0xc8
[   20.153280] [<ffffffff811324a0>] syscall_common+0x8/0x2c
[   20.158598] 
[   20.160090] ---[ end trace a84c8a326c0c5a68 ]---
rootfs: clean, 388512/30269440 files, 5188197/121048062 blocks
[   20.273335] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[   20.281558] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[   21.930502] Kernel panic - not syncing: Fatal exception
[   21.935740] ---[ end Kernel panic - not syncing: Fatal exception

*** NMI Watchdog interrupt on Core 0x1 ***
	$0	0x0000000000000000	at	0x0000000010009ce0
	v0	0x8000000003075f39	v1	0x0000000000000001
	a0	0xffffffff81758d48	a1	0x0000000000000002
	a2	0x0000000000000040	a3	0x0000000000000000
	a4	0x0000000000000000	a5	0xfffffffffffffffe
	a6	0x0000000000000001	a7	0x8000000032804000
	t0	0x0000000010009ce0	t1	0x000000001000001f
	t2	0x800000003326dd80	t3	0x0000000000000000
	s0	0xffffffff81758b00	s1	0x0000000000000002
	s2	0x0000000000000002	s3	0xffffffff81758d48
	s4	0x0000000000000000	s5	0x0000000000000001
	s6	0xffffffff81760000	s7	0xffffffff81760000
	t8	0x0000000000000000	t9	0xffffffff81120800
	k0	0x0000000000000000	k1	0x0000000000000000
	gp	0x80000000323d4000	sp	0x80000000323d77a0
	s8	0xffffffff81758b00	ra	0xffffffff81128ec8
	err_epc	0xffffffff81128eec	epc	0xffffffff815de370
	status	0x0000000010489ce4	cause	0x0000000040808800
	sum0	0x0000000000000000	en0	0x0000000000000000
*** Chip soft reset soon ***
