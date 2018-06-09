From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
 4.17.0-x64-08428-g7d3bf613e99a
Date: Sat, 9 Jun 2018 08:02:28 -0700
Message-ID: <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org>
References: <201806091606.51078.randrianasulu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201806091606.51078.randrianasulu@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Randrianasulu <randrianasulu@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[add linux-scsi m-l]

On 06/09/2018 06:06 AM, Andrew Randrianasulu wrote:
> Hello, everyone!
> 
> I was trying to test not-yet-completed 4.18-rc1, and run into this bug, probably 
> due to HAL (yes, I still use this) trying to poll empty DVD-RW drive:
> 
> [   35.040167] ------------[ cut here ]------------
> [   35.040171] kernel BUG at drivers/scsi/scsi_error.c:197!
> [   35.040196] invalid opcode: 0000 [#1] SMP NOPTI
> [   35.040210] CPU: 2 PID: 117 Comm: kworker/2:1H Not tainted 
> 4.17.0-x64-08428-g7d3bf613e99a-dirty #18
> [   35.040225] Hardware name: MSI MS-7693/970A-G46 (MS-7693), BIOS V2.8 
> 01/08/2016
> [   35.040244] Workqueue: kblockd blk_mq_timeout_work
> [   35.040283] RIP: 0010:scsi_times_out+0xe9/0x1a6 [scsi_mod]
> [   35.040287] Code: 03 76 18 48 c7 c2 f9 c2 01 a0 48 89 ee 48 c7 c7 14 be 01 a0 
> 31 c0 e8 76 ad 00 00 48 8b 83 98 01 00 00 a8 01 0f 84 a5 00 00 00 <0f> 0b 49 8b 
> 7c 24 38 e8 8f ba 4b e1 41 83 bc 24 2c 01
>  00 00 ff 74
> [   35.040312] RSP: 0018:ffffc90000293d98 EFLAGS: 00010202
> [   35.040318] RAX: ffff88031f240605 RBX: ffff88031eed8500 RCX: 00000000fffefd40
> [   35.040323] RDX: ffffc90000293e80 RSI: 0000000000002007 RDI: ffff88031eed8638
> [   35.040327] RBP: ffff88031eed8638 R08: ffff88031eed85d8 R09: 0000000000000000
> [   35.040332] R10: 0000000000000040 R11: fefefefefefefeff R12: ffff88031f2a8800
> [   35.040336] R13: ffff88031f2a8800 R14: ffff88031f29e910 R15: 0000000000000001
> [   35.040341] FS:  0000000000000000(0000) GS:ffff88032ed00000(0000) 
> knlGS:0000000000000000
> [   35.040346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   35.040350] CR2: 00000000f7ea83c0 CR3: 000000031e194000 CR4: 00000000000406e0
> [   35.040354] Call Trace:
> [   35.040360]  blk_mq_check_expired+0xdc/0x10c
> [   35.040365]  bt_iter+0x42/0x45
> [   35.040369]  __sbitmap_for_each_set.constprop.12+0x83/0xac
> [   35.040374]  ? blk_mq_update_nr_requests+0xad/0xad
> [   35.040595]  ? blk_mq_exit_hctx+0xda/0xda
> [   35.041595]  blk_mq_queue_tag_busy_iter+0xa3/0xb4
> [   35.042578]  ? blk_mq_exit_hctx+0xda/0xda
> [   35.043550]  blk_mq_timeout_work+0x6b/0xca
> [   35.044505]  process_one_work+0x17c/0x2a6
> [   35.045445]  worker_thread+0x19f/0x243
> [   35.046393]  ? rescuer_thread+0x262/0x262
> [   35.047346]  kthread+0x100/0x108
> [   35.048290]  ? kthread_destroy_worker+0x3e/0x3e
> [   35.049242]  ret_from_fork+0x27/0x50
> [   35.050192] Modules linked in: bridge stp llc bnep rfcomm hidp snd_aloop ipv6 
> pcmcia pcmcia_core xfs libcrc32c lp parport f71882fg input_leds mousedev 
> hid_generic usbhid hid btusb btintel btbcm btrtl bluetooth nouveau ecdh_generic 
> rfkill morus1280_sse2 morus1280_glue morus640_sse2 morus640_glue ttm 
> drm_kms_helper ghash_clmulni_intel drm crct10dif_pclmul crc32_pclmul 
> drm_panel_orientation_quirks crc32c_intel aegis256_aesni cfbcopyarea 
> fb_sys_fops sysimgblt pcbc sysfillrect cfbimgblt syscopyarea cfbfillrect 
> aesni_intel glue_helper i2c_algo_bit crypto_simd aes_x86_64 ohci_pci 
> snd_hda_codec_realtek aegis128l_aesni pktcdvd aegis128_aesni agpgart ohci_hcd 
> snd_hda_codec_generic cryptd xhci_pci kvm_amd xhci_hcd ehci_pci snd_hda_intel 
> ehci_hcd snd_hda_codec kvm usbcore led_class snd_hda_core video usb_common
> [   35.055814]  backlight irqbypass fb snd_hwdep snd_pcm mxm_wmi r8169 fbdev 
> mac_hid fam15h_power k10temp mii snd_timer ccp evdev snd rng_core hwmon wmi 
> i2c_piix4 sha1_generic sha256_generic button soundcore font sr_mod acpi_cpufreq 
> rtc_cmos sg i2c_core cdrom edac_mce_amd sd_mod ahci libahci libata scsi_mod 
> [last unloaded: pcmcia_core]
> [   35.058426] ---[ end trace fdc9e8c678138a75 ]---
> [   35.059725] RIP: 0010:scsi_times_out+0xe9/0x1a6 [scsi_mod]
> [   35.059726] Code: 03 76 18 48 c7 c2 f9 c2 01 a0 48 89 ee 48 c7 c7 14 be 01 a0 
> 31 c0 e8 76 ad 00 00 48 8b 83 98 01 00 00 a8 01 0f 84 a5 00 00 00 <0f> 0b 49 8b 
> 7c 24 38 e8 8f ba 4b e1 41 83 bc 24 2c 01 00 00 ff 74
> [   35.063794] RSP: 0018:ffffc90000293d98 EFLAGS: 00010202
> [   35.063796] RAX: ffff88031f240605 RBX: ffff88031eed8500 RCX: 00000000fffefd40
> [   35.063797] RDX: ffffc90000293e80 RSI: 0000000000002007 RDI: ffff88031eed8638
> [   35.063798] RBP: ffff88031eed8638 R08: ffff88031eed85d8 R09: 0000000000000000
> [   35.069198] R10: 0000000000000040 R11: fefefefefefefeff R12: ffff88031f2a8800
> [   35.069198] R13: ffff88031f2a8800 R14: ffff88031f29e910 R15: 0000000000000001
> [   35.069200] FS:  0000000000000000(0000) GS:ffff88032ed00000(0000) 
> knlGS:0000000000000000
> [   35.073191] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   35.073192] CR2: 00000000f7ea83c0 CR3: 000000031e194000 CR4: 00000000000406e0
> 
> 
> and this resulted later on in failure to enter suspend-to-ram:
> 
> [  181.912985] PM: suspend entry (deep)
> [  181.912993] PM: Syncing filesystems ... done.
> [  182.026561] Freezing user space processes ...
> [  202.029084] Freezing of tasks failed after 20.002 seconds (1 tasks refusing 
> to freeze, wq_busy=0):
> [  202.029106] hald-addon-stor D    0   909    849 0x20020004
> [  202.029113] Call Trace:
> [  202.029128]  ? __schedule+0x37f/0x57f
> [  202.029134]  ? usleep_range+0x51/0x51
> [  202.029139]  schedule+0x7f/0x89
> [  202.029144]  schedule_timeout+0x21/0xc7
> [  202.029151]  ? check_preempt_curr+0x2e/0x68
> [  202.029157]  do_wait_for_common+0x102/0x133
> [  202.029163]  ? wake_up_q+0x47/0x47
> [  202.029169]  wait_for_common+0x36/0x4e
> [  202.029174]  flush_work+0x12e/0x14b
> [  202.029179]  ? wake_up_worker+0x25/0x25
> [  202.029185]  __cancel_work_timer+0xfb/0x14f
> [  202.029190]  ? kobj_lookup+0xfc/0x130
> [  202.029196]  disk_block_events+0x5f/0x78
> [  202.029202]  __blkdev_get+0xaa/0x3f7
> [  202.029207]  blkdev_get+0x83/0x2a3
> [  202.029211]  ? bdgrab+0x12/0x17
> [  202.029216]  ? bd_acquire+0x3a/0xad
> [  202.029220]  ? bd_acquire+0xad/0xad
> [  202.029226]  do_dentry_open.isra.22+0x16b/0x22d
> [  202.029232]  path_openat+0x98f/0xb27
> [  202.029238]  ? _raw_spin_unlock_irqrestore+0x18/0x23
> [  202.029243]  do_filp_open+0x4d/0xa3
> [  202.029249]  ? __blkdev_put+0x154/0x170
> [  202.029254]  ? _cond_resched+0x25/0x29
> [  202.029260]  ? slab_pre_alloc_hook+0x2d/0x53
> [  202.029265]  ? slab_post_alloc_hook.isra.62+0xa/0x1a
> [  202.029270]  ? kmem_cache_alloc+0xa0/0x10b
> [  202.029277]  ? do_sys_open+0x6a/0xef
> [  202.029281]  do_sys_open+0x6a/0xef
> [  202.029287]  do_int80_syscall_32+0x52/0x5f
> [  202.029293]  entry_INT80_compat+0x85/0x90
> [  202.029316] OOM killer enabled.
> [  202.029318] Restarting tasks ... done.
> [  202.035210] PM: suspend exit
> 
> full dmesg attached
> 


-- 
~Randy
