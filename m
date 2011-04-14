From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: 2.6.39-rc3: usb-storage hotplug kref corruption/ list corruption
Date: Thu, 14 Apr 2011 20:49:10 +0200
Message-ID: <20110414204910.625a1c51@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

two days ago I switched from 2.6.38-rc7 to 2.6.39-rc3.  I have got a
desktop monitor with built-in USB hub to which a built-in card reader and
keyboard and mouse are attached.  When I came home today in the evening
and switched the monitor on, USB did not work anymore (could not use mouse
and keyboard, also not if I plugged another keyboard into a different
onboard USB port).  Everything else still worked.

Looking into it, I noticed that the cause was a bug that happened when I
switched the monitor on (?) at noon:

Apr 14 14:39:35 stein kernel: usb 1-2: new high speed USB device number 27 using ehci_hcd
Apr 14 14:39:35 stein kernel: hub 1-2:1.0: USB hub found
Apr 14 14:39:35 stein kernel: hub 1-2:1.0: 3 ports detected
Apr 14 14:39:35 stein kernel: usb 1-2.1: new high speed USB device number 28 using ehci_hcd
Apr 14 14:39:36 stein kernel: hub 1-2.1:1.0: USB hub found
Apr 14 14:39:36 stein kernel: hub 1-2.1:1.0: 3 ports detected
Apr 14 14:39:36 stein kernel: usb 1-2.2: new full speed USB device number 29 using ehci_hcd
Apr 14 14:39:36 stein kernel: input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input19
Apr 14 14:39:36 stein kernel: generic-usb 0003:046D:C042.0015: input: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:12.2-2.2/input0
Apr 14 14:39:36 stein kernel: generic-usb 0003:046D:C042.0016: claimed by neither input, hiddev nor hidraw
Apr 14 14:39:36 stein kernel: usb 1-2.3: new low speed USB device number 30 using ehci_hcd
Apr 14 14:39:36 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.0/input/input20
Apr 14 14:39:36 stein kernel: generic-usb 0003:1267:0103.0017: input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0000:00:12.2-2.3/input0
Apr 14 14:39:36 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.1/input/input21
Apr 14 14:39:36 stein kernel: generic-usb 0003:1267:0103.0018: input: USB HID v1.10 Device [HID 1267:0103] on usb-0000:00:12.2-2.3/input1
Apr 14 14:39:36 stein kernel: usb 1-2.1.1: new high speed USB device number 31 using ehci_hcd
Apr 14 14:39:36 stein kernel: scsi14 : usb-storage 1-2.1.1:1.0
Apr 14 14:39:37 stein kernel: scsi 14:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.88 PQ: 0 ANSI: 0
Apr 14 14:39:37 stein kernel: sd 14:0:0:0: Attached scsi generic sg5 type 0
Apr 14 14:39:37 stein kernel: sd 14:0:0:0: [sde] Attached SCSI removable disk
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/kref.c:34 kref_get+0x23/0x2c()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: Modules linked in: firewire_sbp2 firedtv dvb_core firewire_ohci firewire_core crc_itu_t cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031f26>] warn_slowpath_null+0x15/0x17
Apr 14 14:39:37 stein kernel: [<ffffffff811398af>] kref_get+0x23/0x2c
Apr 14 14:39:37 stein kernel: [<ffffffff811388be>] kobject_get+0x1a/0x22
Apr 14 14:39:37 stein kernel: [<ffffffff8125e65b>] get_device+0x14/0x1a
Apr 14 14:39:37 stein kernel: [<ffffffff8126dec1>] scsi_request_fn+0x60/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f53 ]---
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: list_del corruption, ffff88021c202978->next is LIST_POISON1 (dead000000100100)
Apr 14 14:39:37 stein kernel: Modules linked in:
[...]
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 14 14:39:37 stein kernel: [<ffffffff81144179>] __list_del_entry+0x8d/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81144195>] list_del+0x11/0x30
Apr 14 14:39:37 stein kernel: [<ffffffff8127272c>] scsi_device_dev_release_usercontext+0x4d/0x12a
Apr 14 14:39:37 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:39:37 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:39:37 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:39:37 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:39:37 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:39:37 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:39:37 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:39:37 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:39:37 stein kernel: [<ffffffff8126e24d>] scsi_request_fn+0x3ec/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f54 ]---
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: list_del corruption, ffff88021c202988->next is LIST_POISON1 (dead000000100100)
Apr 14 14:39:37 stein kernel: Modules linked in:
[...]
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 14 14:39:37 stein kernel: [<ffffffff81144179>] __list_del_entry+0x8d/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81144195>] list_del+0x11/0x30
Apr 14 14:39:37 stein kernel: [<ffffffff81272736>] scsi_device_dev_release_usercontext+0x57/0x12a
Apr 14 14:39:37 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:39:37 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:39:37 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
[...]
Apr 14 14:41:42 stein kernel: INFO: task kworker/3:1:10845 blocked for more than 120 seconds.
[...]
Apr 14 14:41:42 stein kernel: INFO: task usb-stor-scan:10869 blocked for more than 120 seconds.


Any idea what caused the kref underflow?

Note, the kernel was already tainted because of a DRM/TTM DMA mapping bug
two days before.

Also, I am noticing now that there was already a lockdep report from when
the EHCI driver was loaded.

Here is the entire log:

Apr 12 20:56:34 stein kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: EHCI Host Controller
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Apr 12 20:56:34 stein kernel: ------------[ cut here ]------------
Apr 12 20:56:34 stein kernel: WARNING: at kernel/lockdep.c:2465 lockdep_trace_alloc+0x79/0x9e()
Apr 12 20:56:34 stein kernel: Hardware name: System Product Name
Apr 12 20:56:34 stein kernel: Modules linked in:
Apr 12 20:56:34 stein kernel: Pid: 1, comm: swapper Not tainted 2.6.39-rc3 #2
Apr 12 20:56:34 stein kernel: Call Trace:
Apr 12 20:56:34 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 12 20:56:34 stein kernel: [<ffffffff8114e7b3>] ? pci_get_subsys+0x45/0x8b
Apr 12 20:56:34 stein kernel: [<ffffffff81031f26>] warn_slowpath_null+0x15/0x17
Apr 12 20:56:34 stein kernel: [<ffffffff810586a2>] lockdep_trace_alloc+0x79/0x9e
Apr 12 20:56:34 stein kernel: [<ffffffff810a4642>] kmem_cache_alloc+0x24/0xac
Apr 12 20:56:34 stein kernel: [<ffffffff8114e7b3>] pci_get_subsys+0x45/0x8b
Apr 12 20:56:34 stein kernel: [<ffffffff8114e80a>] pci_get_device+0x11/0x13
Apr 12 20:56:34 stein kernel: [<ffffffff812a16c0>] usb_amd_find_chipset_info+0x3f/0x187
Apr 12 20:56:34 stein kernel: [<ffffffff812a6e7b>] ehci_pci_setup+0x73a/0x9cb
Apr 12 20:56:34 stein kernel: [<ffffffff81296fd7>] usb_add_hcd+0x19b/0x58e
Apr 12 20:56:34 stein kernel: [<ffffffff812a1053>] usb_hcd_pci_probe+0x1d6/0x297
Apr 12 20:56:34 stein kernel: [<ffffffff8114de9b>] local_pci_probe+0x12/0x16
Apr 12 20:56:34 stein kernel: [<ffffffff8114e0e0>] pci_device_probe+0x60/0x8f
Apr 12 20:56:34 stein kernel: [<ffffffff81261660>] ? driver_sysfs_add+0x6b/0x90
Apr 12 20:56:34 stein kernel: [<ffffffff812617a8>] driver_probe_device+0xa7/0x136
Apr 12 20:56:34 stein kernel: [<ffffffff81261893>] __driver_attach+0x5c/0x80
Apr 12 20:56:34 stein kernel: [<ffffffff81261837>] ? driver_probe_device+0x136/0x136
Apr 12 20:56:34 stein kernel: [<ffffffff81260fb3>] bus_for_each_dev+0x54/0x89
Apr 12 20:56:34 stein kernel: [<ffffffff812615f3>] driver_attach+0x19/0x1b
Apr 12 20:56:34 stein kernel: [<ffffffff812608e9>] bus_add_driver+0xc8/0x214
Apr 12 20:56:34 stein kernel: [<ffffffff81261c3c>] driver_register+0x99/0x10a
Apr 12 20:56:34 stein kernel: [<ffffffff8114e316>] __pci_register_driver+0x63/0xd3
Apr 12 20:56:34 stein kernel: [<ffffffff8169be92>] ? usb_devio_init+0x9b/0x9b
Apr 12 20:56:34 stein kernel: [<ffffffff8169befc>] ehci_hcd_init+0x6a/0x78
Apr 12 20:56:34 stein kernel: [<ffffffff8100020a>] do_one_initcall+0x7a/0x12e
Apr 12 20:56:34 stein kernel: [<ffffffff8167c55c>] kernel_init+0xb5/0x135
Apr 12 20:56:34 stein kernel: [<ffffffff8113fa5e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Apr 12 20:56:34 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 12 20:56:34 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 12 20:56:34 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 12 20:56:34 stein kernel: [<ffffffff8167c4a7>] ? parse_early_options+0x20/0x20
Apr 12 20:56:34 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 12 20:56:34 stein kernel: ---[ end trace 6a2f7052e2c76f50 ]---
Apr 12 20:56:34 stein kernel: QUIRK: Enable AMD PLL fix
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: debug port 1
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: irq 17, io mem 0xfadff000
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Apr 12 20:56:34 stein kernel: hub 1-0:1.0: USB hub found
Apr 12 20:56:34 stein kernel: hub 1-0:1.0: 6 ports detected
Apr 12 20:56:34 stein kernel: ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[...]
Apr 12 20:56:40 stein kernel: powernow-k8: Found 1 AMD Phenom(tm) II X4 905e Processor (4 cpu cores) (version 2.20.00)
Apr 12 20:56:40 stein kernel: powernow-k8:    0 : pstate 0 (2500 MHz)
Apr 12 20:56:40 stein kernel: powernow-k8:    1 : pstate 1 (1900 MHz)
Apr 12 20:56:40 stein kernel: powernow-k8:    2 : pstate 2 (1400 MHz)
Apr 12 20:56:40 stein kernel: powernow-k8:    3 : pstate 3 (800 MHz)
Apr 12 20:56:42 stein kernel: ------------[ cut here ]------------
Apr 12 20:56:42 stein kernel: WARNING: at lib/dma-debug.c:803 check_unmap+0x19a/0x696()
Apr 12 20:56:42 stein kernel: Hardware name: System Product Name
Apr 12 20:56:42 stein kernel: NULL NULL: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x00000000ce47b000] [size=4096 bytes]
Apr 12 20:56:42 stein kernel: Modules linked in: cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 12 20:56:42 stein kernel: Pid: 4397, comm: X Tainted: G        W   2.6.39-rc3 #2
Apr 12 20:56:42 stein kernel: Call Trace:
Apr 12 20:56:42 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 12 20:56:42 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 12 20:56:42 stein kernel: [<ffffffff8134606d>] ? _raw_spin_lock_irqsave+0x49/0x53
Apr 12 20:56:42 stein kernel: [<ffffffff811474e5>] ? check_unmap+0x102/0x696
Apr 12 20:56:42 stein kernel: [<ffffffff8114757d>] check_unmap+0x19a/0x696
Apr 12 20:56:42 stein kernel: [<ffffffff81021810>] ? __change_page_attr_set_clr+0x16d/0x99d
Apr 12 20:56:42 stein kernel: [<ffffffff81147ae5>] debug_dma_free_coherent+0x6c/0x7a
Apr 12 20:56:42 stein kernel: [<ffffffff811ccb00>] ttm_put_pages+0x117/0x255
Apr 12 20:56:42 stein kernel: [<ffffffff811c62cb>] ttm_tt_free_alloced_pages+0xbc/0xe2
Apr 12 20:56:42 stein kernel: [<ffffffff811c6695>] ttm_tt_destroy+0x50/0xda
Apr 12 20:56:42 stein kernel: [<ffffffff811c6f27>] ttm_bo_cleanup_memtype_use+0x29/0x63
Apr 12 20:56:42 stein kernel: [<ffffffff811c96aa>] ttm_bo_release+0x112/0x1df
Apr 12 20:56:42 stein kernel: [<ffffffff811c9598>] ? ttm_bo_create+0xff/0xff
Apr 12 20:56:42 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 12 20:56:42 stein kernel: [<ffffffff811c7748>] ttm_bo_unref+0x33/0x40
Apr 12 20:56:42 stein kernel: [<ffffffff811f6f66>] radeon_bo_unref+0x3f/0x5e
Apr 12 20:56:42 stein kernel: [<ffffffff811b58f2>] ? drm_gem_handle_delete+0x89/0xab
Apr 12 20:56:42 stein kernel: [<ffffffff811b5779>] ? drm_gem_object_release_handle+0x5a/0x5a
Apr 12 20:56:42 stein kernel: [<ffffffff8120985a>] radeon_gem_object_free+0x1e/0x20
Apr 12 20:56:42 stein kernel: [<ffffffff811b57a1>] drm_gem_object_free+0x28/0x2a
Apr 12 20:56:42 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 12 20:56:42 stein kernel: [<ffffffff811b5901>] drm_gem_handle_delete+0x98/0xab
Apr 12 20:56:42 stein kernel: [<ffffffff811b5937>] drm_gem_close_ioctl+0x23/0x25
Apr 12 20:56:42 stein kernel: [<ffffffff811b4106>] drm_ioctl+0x277/0x343
Apr 12 20:56:42 stein kernel: [<ffffffff811b5914>] ? drm_gem_handle_delete+0xab/0xab
Apr 12 20:56:42 stein kernel: [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
Apr 12 20:56:42 stein kernel: [<ffffffff81058895>] ? trace_hardirqs_on+0xd/0xf
Apr 12 20:56:42 stein kernel: [<ffffffff810b5e8b>] do_vfs_ioctl+0x464/0x4b3
Apr 12 20:56:42 stein kernel: [<ffffffff810953bd>] ? remove_vma+0x69/0x71
Apr 12 20:56:42 stein kernel: [<ffffffff810b5f1c>] sys_ioctl+0x42/0x65
Apr 12 20:56:42 stein kernel: [<ffffffff813472bb>] system_call_fastpath+0x16/0x1b
Apr 12 20:56:42 stein kernel: ---[ end trace 6a2f7052e2c76f52 ]---
Apr 12 20:57:03 stein kdm: :0[4480]: pam_unix(kde:session): session opened for user stefan by (uid=0)
Apr 12 20:57:55 stein kernel: DMA-API: debugging out of memory - disabling
[...]
Apr 14 08:21:02 stein -- MARK --
Apr 14 08:41:02 stein -- MARK --
Apr 14 08:56:35 stein syslog-ng[4092]: Log statistics; processed='src.internal(src#1)=33', stamp='src.internal(src#1)=1302763262', processed='global(payload_reallocs)=0', processed='source(net)=0', processed='global(msg_clones)=0', processed='center(queued)=0', processed='global(sdata_updates)=0', processed='center(received)=0', processed='destination(console_all)=2430', processed='source(src)=2430', processed='destination(messages)=2430'
Apr 14 09:16:35 stein -- MARK --
Apr 14 09:23:13 stein kernel: usb 1-2: new high speed USB device number 22 using ehci_hcd
Apr 14 09:23:13 stein kernel: hub 1-2:1.0: USB hub found
Apr 14 09:23:13 stein kernel: hub 1-2:1.0: 3 ports detected
Apr 14 09:23:13 stein kernel: usb 1-2.1: new high speed USB device number 23 using ehci_hcd
Apr 14 09:23:13 stein kernel: hub 1-2.1:1.0: USB hub found
Apr 14 09:23:13 stein kernel: hub 1-2.1:1.0: 3 ports detected
Apr 14 09:23:13 stein kernel: usb 1-2.2: new full speed USB device number 24 using ehci_hcd
Apr 14 09:23:13 stein kernel: input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input16
Apr 14 09:23:13 stein kernel: generic-usb 0003:046D:C042.0011: input: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:12.2-2.2/input0
Apr 14 09:23:13 stein kernel: generic-usb 0003:046D:C042.0012: claimed by neither input, hiddev nor hidraw
Apr 14 09:23:14 stein kernel: usb 1-2.3: new low speed USB device number 25 using ehci_hcd
Apr 14 09:23:14 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.0/input/input17
Apr 14 09:23:14 stein kernel: generic-usb 0003:1267:0103.0013: input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0000:00:12.2-2.3/input0
Apr 14 09:23:14 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.1/input/input18
Apr 14 09:23:14 stein kernel: generic-usb 0003:1267:0103.0014: input: USB HID v1.10 Device [HID 1267:0103] on usb-0000:00:12.2-2.3/input1
Apr 14 09:23:14 stein kernel: usb 1-2.1.1: new high speed USB device number 26 using ehci_hcd
Apr 14 09:23:14 stein kernel: scsi13 : usb-storage 1-2.1.1:1.0
Apr 14 09:23:15 stein kernel: scsi 13:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.88 PQ: 0 ANSI: 0
Apr 14 09:23:15 stein kernel: sd 13:0:0:0: Attached scsi generic sg5 type 0
Apr 14 09:23:15 stein kernel: sd 13:0:0:0: [sde] Attached SCSI removable disk
Apr 14 09:43:15 stein -- MARK --
Apr 14 09:55:29 stein kernel: usb 1-2: USB disconnect, device number 22
Apr 14 09:55:29 stein kernel: usb 1-2.1: USB disconnect, device number 23
Apr 14 09:55:29 stein kernel: usb 1-2.1.1: USB disconnect, device number 26
Apr 14 09:55:29 stein kernel: usb 1-2.2: USB disconnect, device number 24
Apr 14 09:55:29 stein kernel: generic-usb 0003:046D:C042.0011: can't reset device, 0000:00:12.2-2.2/input0, status -71
Apr 14 09:55:29 stein kernel: usb 1-2: clear tt 2 (0180) error -19
Apr 14 09:55:29 stein kernel: generic-usb 0003:1267:0103.0013: can't reset device, 0000:00:12.2-2.3/input0, status -71
Apr 14 09:55:29 stein kernel: usb 1-2: clear tt 3 (0190) error -19
Apr 14 09:55:29 stein kernel: generic-usb 0003:1267:0103.0014: can't reset device, 0000:00:12.2-2.3/input1, status -71
Apr 14 09:55:29 stein kernel: usb 1-2: clear tt 3 (0190) error -19
Apr 14 09:55:29 stein kernel: usb 1-2.3: USB disconnect, device number 25
Apr 14 10:15:29 stein -- MARK --
Apr 14 10:35:29 stein -- MARK --
Apr 14 10:55:29 stein -- MARK --
Apr 14 11:15:29 stein -- MARK --
Apr 14 11:35:29 stein -- MARK --
Apr 14 11:55:29 stein -- MARK --
Apr 14 12:15:29 stein -- MARK --
Apr 14 12:35:29 stein -- MARK --
Apr 14 12:55:29 stein -- MARK --
Apr 14 13:15:29 stein -- MARK --
Apr 14 13:35:29 stein -- MARK --
Apr 14 13:55:29 stein -- MARK --
Apr 14 14:15:29 stein -- MARK --
Apr 14 14:35:29 stein -- MARK --
Apr 14 14:39:35 stein kernel: usb 1-2: new high speed USB device number 27 using ehci_hcd
Apr 14 14:39:35 stein kernel: hub 1-2:1.0: USB hub found
Apr 14 14:39:35 stein kernel: hub 1-2:1.0: 3 ports detected
Apr 14 14:39:35 stein kernel: usb 1-2.1: new high speed USB device number 28 using ehci_hcd
Apr 14 14:39:36 stein kernel: hub 1-2.1:1.0: USB hub found
Apr 14 14:39:36 stein kernel: hub 1-2.1:1.0: 3 ports detected
Apr 14 14:39:36 stein kernel: usb 1-2.2: new full speed USB device number 29 using ehci_hcd
Apr 14 14:39:36 stein kernel: input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input19
Apr 14 14:39:36 stein kernel: generic-usb 0003:046D:C042.0015: input: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:12.2-2.2/input0
Apr 14 14:39:36 stein kernel: generic-usb 0003:046D:C042.0016: claimed by neither input, hiddev nor hidraw
Apr 14 14:39:36 stein kernel: usb 1-2.3: new low speed USB device number 30 using ehci_hcd
Apr 14 14:39:36 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.0/input/input20
Apr 14 14:39:36 stein kernel: generic-usb 0003:1267:0103.0017: input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0000:00:12.2-2.3/input0
Apr 14 14:39:36 stein kernel: input: HID 1267:0103 as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.3/1-2.3:1.1/input/input21
Apr 14 14:39:36 stein kernel: generic-usb 0003:1267:0103.0018: input: USB HID v1.10 Device [HID 1267:0103] on usb-0000:00:12.2-2.3/input1
Apr 14 14:39:36 stein kernel: usb 1-2.1.1: new high speed USB device number 31 using ehci_hcd
Apr 14 14:39:36 stein kernel: scsi14 : usb-storage 1-2.1.1:1.0
Apr 14 14:39:37 stein kernel: scsi 14:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.88 PQ: 0 ANSI: 0
Apr 14 14:39:37 stein kernel: sd 14:0:0:0: Attached scsi generic sg5 type 0
Apr 14 14:39:37 stein kernel: sd 14:0:0:0: [sde] Attached SCSI removable disk
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/kref.c:34 kref_get+0x23/0x2c()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: Modules linked in: firewire_sbp2 firedtv dvb_core firewire_ohci firewire_core crc_itu_t cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031f26>] warn_slowpath_null+0x15/0x17
Apr 14 14:39:37 stein kernel: [<ffffffff811398af>] kref_get+0x23/0x2c
Apr 14 14:39:37 stein kernel: [<ffffffff811388be>] kobject_get+0x1a/0x22
Apr 14 14:39:37 stein kernel: [<ffffffff8125e65b>] get_device+0x14/0x1a
Apr 14 14:39:37 stein kernel: [<ffffffff8126dec1>] scsi_request_fn+0x60/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f53 ]---
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: list_del corruption, ffff88021c202978->next is LIST_POISON1 (dead000000100100)
Apr 14 14:39:37 stein kernel: Modules linked in: firewire_sbp2 firedtv dvb_core firewire_ohci firewire_core crc_itu_t cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 14 14:39:37 stein kernel: [<ffffffff81144179>] __list_del_entry+0x8d/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81144195>] list_del+0x11/0x30
Apr 14 14:39:37 stein kernel: [<ffffffff8127272c>] scsi_device_dev_release_usercontext+0x4d/0x12a
Apr 14 14:39:37 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:39:37 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:39:37 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:39:37 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:39:37 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:39:37 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:39:37 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:39:37 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:39:37 stein kernel: [<ffffffff8126e24d>] scsi_request_fn+0x3ec/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f54 ]---
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: list_del corruption, ffff88021c202988->next is LIST_POISON1 (dead000000100100)
Apr 14 14:39:37 stein kernel: Modules linked in: firewire_sbp2 firedtv dvb_core firewire_ohci firewire_core crc_itu_t cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 14 14:39:37 stein kernel: [<ffffffff81144179>] __list_del_entry+0x8d/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81144195>] list_del+0x11/0x30
Apr 14 14:39:37 stein kernel: [<ffffffff81272736>] scsi_device_dev_release_usercontext+0x57/0x12a
Apr 14 14:39:37 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:39:37 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:39:37 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:39:37 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:39:37 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:39:37 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:39:37 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:39:37 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:39:37 stein kernel: [<ffffffff8126e24d>] scsi_request_fn+0x3ec/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f55 ]---
Apr 14 14:39:37 stein kernel: ------------[ cut here ]------------
Apr 14 14:39:37 stein kernel: WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Apr 14 14:39:37 stein kernel: Hardware name: System Product Name
Apr 14 14:39:37 stein kernel: list_del corruption, ffff88021c2029e8->next is LIST_POISON1 (dead000000100100)
Apr 14 14:39:37 stein kernel: Modules linked in: firewire_sbp2 firedtv dvb_core firewire_ohci firewire_core crc_itu_t cpufreq_ondemand powernow_k8 freq_table mperf snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device nfsd lockd it87 hwmon_vid sunrpc ext4 jbd2 crc16 sr_mod cdrom snd_hda_codec_realtek k10temp yenta_socket snd_hda_intel pcmcia_core pcmcia_rsrc snd_hda_codec snd_pcm pata_atiixp snd_timer sg snd snd_page_alloc r8169 mii processor usb_storage
Apr 14 14:39:37 stein kernel: Pid: 10845, comm: kworker/3:1 Tainted: G        W   2.6.39-rc3 #2
Apr 14 14:39:37 stein kernel: Call Trace:
Apr 14 14:39:37 stein kernel: [<ffffffff81031ef9>] warn_slowpath_common+0x80/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81031fa5>] warn_slowpath_fmt+0x41/0x43
Apr 14 14:39:37 stein kernel: [<ffffffff81144179>] __list_del_entry+0x8d/0x98
Apr 14 14:39:37 stein kernel: [<ffffffff81144195>] list_del+0x11/0x30
Apr 14 14:39:37 stein kernel: [<ffffffff81272743>] scsi_device_dev_release_usercontext+0x64/0x12a
Apr 14 14:39:37 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:39:37 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:39:37 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:39:37 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:39:37 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:39:37 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:39:37 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:39:37 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:39:37 stein kernel: [<ffffffff8126e24d>] scsi_request_fn+0x3ec/0x4cb
Apr 14 14:39:37 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:39:37 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:39:37 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:39:37 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:39:37 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:39:37 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:39:37 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:39:37 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:39:37 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:39:37 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:39:37 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:39:37 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:39:37 stein kernel: ---[ end trace 6a2f7052e2c76f56 ]---
Apr 14 14:41:42 stein kernel: INFO: task kworker/3:1:10845 blocked for more than 120 seconds.
Apr 14 14:41:42 stein kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 14 14:41:42 stein kernel: kworker/3:1     D 0000000000000000     0 10845      2 0x00000000
Apr 14 14:41:42 stein kernel: ffff8801437958f0 0000000000000046 00000000000227ad ffff880143794010
Apr 14 14:41:42 stein kernel: ffff88021e130ee0 ffff880143795fd8 0000000000011280 0000000000004000
Apr 14 14:41:42 stein kernel: ffff880143795fd8 0000000000011280 ffff8800b170aca0 ffff88021e130ee0
Apr 14 14:41:42 stein kernel: Call Trace:
Apr 14 14:41:42 stein kernel: [<ffffffff81032d6a>] ? vprintk+0x3ae/0x3f3
Apr 14 14:41:42 stein kernel: [<ffffffff8113cc27>] ? put_dec+0x20/0x3c
Apr 14 14:41:42 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:41:42 stein kernel: [<ffffffff81344320>] schedule_timeout+0x28/0x1f1
Apr 14 14:41:42 stein kernel: [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
Apr 14 14:41:42 stein kernel: [<ffffffff8102d906>] ? sub_preempt_count+0x92/0xa6
Apr 14 14:41:42 stein kernel: [<ffffffff8134364d>] wait_for_common+0xcd/0x12b
Apr 14 14:41:42 stein kernel: [<ffffffff8102f4e5>] ? try_to_wake_up+0x282/0x282
Apr 14 14:41:42 stein kernel: [<ffffffff81343745>] wait_for_completion+0x18/0x1a
Apr 14 14:41:42 stein kernel: [<ffffffff8104526c>] wait_on_cpu_work+0x80/0x98
Apr 14 14:41:42 stein kernel: [<ffffffff81043a77>] ? do_work_for_cpu+0x26/0x26
Apr 14 14:41:42 stein kernel: [<ffffffff8104534b>] wait_on_work+0xc7/0x115
Apr 14 14:41:42 stein kernel: [<ffffffff81045284>] ? wait_on_cpu_work+0x98/0x98
Apr 14 14:41:42 stein kernel: [<ffffffff8134677c>] ? _raw_spin_unlock_irqrestore+0x46/0x64
Apr 14 14:41:42 stein kernel: [<ffffffff8104546d>] __cancel_work_timer+0xd4/0x11d
Apr 14 14:41:42 stein kernel: [<ffffffff810454c3>] cancel_delayed_work_sync+0xd/0xf
Apr 14 14:41:42 stein kernel: [<ffffffff811297ba>] blk_sync_queue+0x24/0x42
Apr 14 14:41:42 stein kernel: [<ffffffff811297ee>] blk_cleanup_queue+0x16/0x5b
Apr 14 14:41:42 stein kernel: [<ffffffff8126dd69>] scsi_free_queue+0x9/0xb
Apr 14 14:41:42 stein kernel: [<ffffffff812727be>] scsi_device_dev_release_usercontext+0xdf/0x12a
Apr 14 14:41:42 stein kernel: [<ffffffff8134341e>] ? printk+0x3c/0x3e
Apr 14 14:41:42 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:41:42 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:41:42 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:41:42 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:41:42 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:41:42 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:41:42 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:41:42 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:41:42 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:41:42 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:41:42 stein kernel: [<ffffffff8126e24d>] scsi_request_fn+0x3ec/0x4cb
Apr 14 14:41:42 stein kernel: [<ffffffff811279e1>] __blk_run_queue+0x7b/0xe9
Apr 14 14:41:42 stein kernel: [<ffffffff81129277>] blk_delay_work+0x26/0x37
Apr 14 14:41:42 stein kernel: [<ffffffff81046068>] process_one_work+0x243/0x3dd
Apr 14 14:41:42 stein kernel: [<ffffffff81046007>] ? process_one_work+0x1e2/0x3dd
Apr 14 14:41:42 stein kernel: [<ffffffff81129251>] ? blk_requeue_request+0x44/0x44
Apr 14 14:41:42 stein kernel: [<ffffffff810465cd>] worker_thread+0x1d3/0x312
Apr 14 14:41:42 stein kernel: [<ffffffff810463fa>] ? rescuer_thread+0x1f8/0x1f8
Apr 14 14:41:42 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:41:42 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:41:42 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:41:42 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:41:42 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:41:42 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:41:42 stein kernel: INFO: lockdep is turned off.
Apr 14 14:41:42 stein kernel: INFO: task usb-stor-scan:10869 blocked for more than 120 seconds.
Apr 14 14:41:42 stein kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 14 14:41:42 stein kernel: usb-stor-scan   D 0000000000000000     0 10869      2 0x00000000
Apr 14 14:41:42 stein kernel: ffff880079afb6f0 0000000000000046 ffff880200000000 ffff880079afa010
Apr 14 14:41:42 stein kernel: ffff8800b170aca0 ffff880079afbfd8 0000000000011280 0000000000004000
Apr 14 14:41:42 stein kernel: ffff880079afbfd8 0000000000011280 ffff88021e114a60 ffff8800b170aca0
Apr 14 14:41:42 stein kernel: Call Trace:
Apr 14 14:41:42 stein kernel: [<ffffffff81346719>] ? _raw_spin_unlock_irq+0x36/0x53
Apr 14 14:41:42 stein kernel: [<ffffffff8102d837>] ? finish_task_switch+0x79/0xb6
Apr 14 14:41:42 stein kernel: [<ffffffff81343fb9>] ? schedule+0x872/0x8aa
Apr 14 14:41:42 stein kernel: [<ffffffff81344320>] schedule_timeout+0x28/0x1f1
Apr 14 14:41:42 stein kernel: [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
Apr 14 14:41:42 stein kernel: [<ffffffff8102d906>] ? sub_preempt_count+0x92/0xa6
Apr 14 14:41:42 stein kernel: [<ffffffff8134364d>] wait_for_common+0xcd/0x12b
Apr 14 14:41:42 stein kernel: [<ffffffff8102f4e5>] ? try_to_wake_up+0x282/0x282
Apr 14 14:41:42 stein kernel: [<ffffffff81343745>] wait_for_completion+0x18/0x1a
Apr 14 14:41:42 stein kernel: [<ffffffff8104526c>] wait_on_cpu_work+0x80/0x98
Apr 14 14:41:42 stein kernel: [<ffffffff81043a77>] ? do_work_for_cpu+0x26/0x26
Apr 14 14:41:42 stein kernel: [<ffffffff8104534b>] wait_on_work+0xc7/0x115
Apr 14 14:41:42 stein kernel: [<ffffffff81045284>] ? wait_on_cpu_work+0x98/0x98
Apr 14 14:41:42 stein kernel: [<ffffffff8104546d>] __cancel_work_timer+0xd4/0x11d
Apr 14 14:41:42 stein kernel: [<ffffffff810454c3>] cancel_delayed_work_sync+0xd/0xf
Apr 14 14:41:42 stein kernel: [<ffffffff811297ba>] blk_sync_queue+0x24/0x42
Apr 14 14:41:42 stein kernel: [<ffffffff811297ee>] blk_cleanup_queue+0x16/0x5b
Apr 14 14:41:42 stein kernel: [<ffffffff8126dd69>] scsi_free_queue+0x9/0xb
Apr 14 14:41:42 stein kernel: [<ffffffff812727be>] scsi_device_dev_release_usercontext+0xdf/0x12a
Apr 14 14:41:42 stein kernel: [<ffffffff812726df>] ? scsi_device_cls_release+0x12/0x12
Apr 14 14:41:42 stein kernel: [<ffffffff81045c63>] execute_in_process_context+0x2a/0x7a
Apr 14 14:41:42 stein kernel: [<ffffffff812726cb>] scsi_device_dev_release+0x17/0x19
Apr 14 14:41:42 stein kernel: [<ffffffff8125ec2a>] device_release+0x49/0x7e
Apr 14 14:41:42 stein kernel: [<ffffffff8113888e>] kobject_release+0x51/0x67
Apr 14 14:41:42 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:41:42 stein kernel: [<ffffffff81139882>] kref_put+0x43/0x4d
Apr 14 14:41:42 stein kernel: [<ffffffff8113879f>] kobject_put+0x47/0x4b
Apr 14 14:41:42 stein kernel: [<ffffffff8125e682>] put_device+0x12/0x14
Apr 14 14:41:42 stein kernel: [<ffffffff81272b08>] __scsi_remove_device+0x8a/0x8f
Apr 14 14:41:42 stein kernel: [<ffffffff81270d57>] scsi_probe_and_add_lun+0xb47/0xb6d
Apr 14 14:41:42 stein kernel: [<ffffffff81058895>] ? trace_hardirqs_on+0xd/0xf
Apr 14 14:41:42 stein kernel: [<ffffffff8134484f>] ? mutex_unlock+0x9/0xb
Apr 14 14:41:42 stein kernel: [<ffffffff8126fdcd>] ? scsi_alloc_target+0x260/0x29b
Apr 14 14:41:42 stein kernel: [<ffffffff8113883d>] ? kobject_del+0x37/0x37
Apr 14 14:41:42 stein kernel: [<ffffffff8127101f>] __scsi_scan_target+0xbd/0x5fc
Apr 14 14:41:42 stein kernel: [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
Apr 14 14:41:42 stein kernel: [<ffffffff8102d906>] ? sub_preempt_count+0x92/0xa6
Apr 14 14:41:42 stein kernel: [<ffffffff81271686>] ? scsi_scan_host_selected+0xa8/0x123
Apr 14 14:41:42 stein kernel: [<ffffffff8102b65f>] ? get_parent_ip+0x11/0x41
Apr 14 14:41:42 stein kernel: [<ffffffff8102d906>] ? sub_preempt_count+0x92/0xa6
Apr 14 14:41:42 stein kernel: [<ffffffff812715b6>] scsi_scan_channel+0x58/0x80
Apr 14 14:41:42 stein kernel: [<ffffffff812716c0>] scsi_scan_host_selected+0xe2/0x123
Apr 14 14:41:42 stein kernel: [<ffffffff8127176c>] do_scsi_scan_host+0x6b/0x70
Apr 14 14:41:42 stein kernel: [<ffffffff81271a38>] scsi_scan_host+0x196/0x1b3
Apr 14 14:41:42 stein kernel: [<ffffffffa000221d>] usb_stor_scan_thread+0x107/0x115 [usb_storage]
Apr 14 14:41:42 stein kernel: [<ffffffff81049c9d>] ? wake_up_bit+0x25/0x25
Apr 14 14:41:42 stein kernel: [<ffffffffa0002116>] ? usb_stor_probe2+0x2e4/0x2e4 [usb_storage]
Apr 14 14:41:42 stein kernel: [<ffffffff810498ea>] kthread+0x7d/0x85
Apr 14 14:41:42 stein kernel: [<ffffffff81348014>] kernel_thread_helper+0x4/0x10
Apr 14 14:41:42 stein kernel: [<ffffffff8102d800>] ? finish_task_switch+0x42/0xb6
Apr 14 14:41:42 stein kernel: [<ffffffff81346b44>] ? retint_restore_args+0xe/0xe
Apr 14 14:41:42 stein kernel: [<ffffffff8104986d>] ? __init_kthread_worker+0x56/0x56
Apr 14 14:41:42 stein kernel: [<ffffffff81348010>] ? gs_change+0xb/0xb
Apr 14 14:41:42 stein kernel: INFO: lockdep is turned off.
[...]
Apr 14 15:42:21 stein -- MARK --
Apr 14 15:42:31 stein kernel: usb 1-2: USB disconnect, device number 27
Apr 14 15:42:31 stein kernel: usb 1-2.1: USB disconnect, device number 28
Apr 14 15:42:31 stein kernel: usb 1-2.1.1: USB disconnect, device number 31
Apr 14 15:42:31 stein kernel: generic-usb 0003:046D:C042.0015: can't reset device, 0000:00:12.2-2.2/input0, status -71
Apr 14 15:42:31 stein kernel: generic-usb 0003:1267:0103.0017: can't reset device, 0000:00:12.2-2.3/input0, status -71
Apr 14 15:42:31 stein kernel: usb 1-2: clear tt 2 (01d0) error -19
Apr 14 15:42:31 stein kernel: usb 1-2: clear tt 3 (01e0) error -19
Apr 14 15:42:31 stein kernel: generic-usb 0003:1267:0103.0018: can't reset device, 0000:00:12.2-2.3/input1, status -71
Apr 14 15:42:31 stein kernel: usb 1-2: clear tt 3 (01e0) error -19
Apr 14 16:02:31 stein -- MARK --
Apr 14 16:22:31 stein -- MARK --
Apr 14 16:42:31 stein -- MARK --
Apr 14 17:02:31 stein -- MARK --
Apr 14 17:22:31 stein -- MARK --
Apr 14 17:42:31 stein -- MARK --
Apr 14 18:02:31 stein -- MARK --
Apr 14 18:22:31 stein -- MARK --
Apr 14 18:42:31 stein -- MARK --
Apr 14 19:00:14 stein sshd[11597]: SSH: Server;Ltype: Version;Remote: 192.168.0.37-37916;Protocol: 2.0;Client: OpenSSH_5.8p1-hpn13v10
Apr 14 19:00:14 stein sshd[11597]: Accepted publickey for stefan from 192.168.0.37 port 37916 ssh2
Apr 14 19:00:14 stein sshd[11597]: pam_unix(sshd:session): session opened for user stefan by (uid=0)
Apr 14 19:01:03 stein su[11611]: Successful su for root by stefan
Apr 14 19:01:03 stein su[11611]: + /dev/pts/6 stefan:root
Apr 14 19:01:03 stein su[11611]: pam_unix(su:session): session opened for user root by stefan(uid=500)
Apr 14 19:01:52 stein shutdown[11625]: shutting down for system reboot



-- 
Stefan Richter
-=====-==-== -=-- -===-
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
